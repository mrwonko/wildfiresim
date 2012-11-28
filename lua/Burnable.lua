Burnable =
{
}

Burnable.size = sf.Vector2f(17, 17)
Burnable.tileSize = 16
Burnable.fireImageChangeTime = .5
Burnable.burning = false
--default values
Burnable.incombustible = false

Burnable.ignitionTemperature = 500
Burnable.burnTemperature = 1000
Burnable.burnDuration = 60
--[[
Burnable.mass = 60000
Burnable.humidity = 0.5
Burnable.area = 90
Burnable.temperature = 0
Burnable.absorption = 0.94
Burnable.heatCapacity = 2.2
Burnable.volume = 3e9
Burnable.ignitionTemperature = 800
Burnable.maximumTemperature = 1200
Burnable.heizwert = 10
Burnable.massLossRate = 1
--]]

--constants
local metersPerUnit = config.tile_distance or 2
local euler = 2.71828
--verlust wg. kälterer umgebung
local temperatureLossConst = 1/60
--erhöhung wg. heißer bäume
local temperatureGainConst = 1/10
--wind faster than this and fire can't backtrack
local criticalWindSpeed = 70/3.6

Burnable.heatConstant = 1e-10

--[[
local boltzmannkonstante = 5.67e-8
--erhöhung weil der baum brennt (bis maximumTemperature)
local burn_temperatureIncreaseConst = 1/3
--]]


Burnable.saveMe =
{
	"name",
	"burning",
	"temperature",
}

function Burnable:New(info)
	local obj = info or {}
	setmetatable(obj, self)
	self.__index = self
	if not clickables.temperature then
		print("o.O")
	else
		obj.temperature = clickables.temperature.value
	end
	
	if obj.image then
		if type(obj.image) == "string" then
			obj.imageName = obj.image
			obj.image = ImageManager[obj.imageName]
		end
		obj:SetSprite(sf.Sprite(obj.image))
		obj.sprite:SetBlendMode(sf.Blend.Alpha)
	end
	
	if obj.fireImages then
		obj:SetFireSprite(sf.Sprite(obj.fireImages[1]))
		obj.fireSprite:SetBlendMode(sf.Blend.Add)
		obj.currentImage = 1
		obj.fireTimer = math.random()*obj.fireImageChangeTime*table.maxn(obj.fireImages)
	end
	
	obj:SetPosition(obj.x or 0, obj.y or 0)
	
	return obj
end

function Burnable:Copy(data)	
		--copy the info
		local info = {}
		for k, v in pairs(self) do
			info[k] = v
		end
		for k, v in pairs(data) do
			info[k] = v
		end
		return self:New(info)
end

function Burnable:Save(file)
	file:write('\t\t\t{\n')
	for _, key in pairs(self.saveMe) do
		if self[key] then
			file:write("\t\t\t\t")
			if type(self[key]) == "string" or type(self[key]) == "number" then
				file:write(key..'="'..self[key]..'",')
			elseif type(self[key]) == "boolean" then
				if self[key] then
					file:write(key..'=true,')
				else
					file:write(key..'=true,')
				end
			else
				file:write("-- ignoring "..type(self[key]).." "..key)
			end
			file:write('\n')
		end
	end
	file:write('\t\t\t}')
end

function Burnable:Update(deltaT)
	--aimate fire image, if there is one
	if self.fireImages then
		self.fireTimer = self.fireTimer + deltaT
		if self.fireTimer >= self.fireImageChangeTime then
			self.currentImage = self.currentImage + 1
			self.fireTimer = 0
			if self.currentImage > table.maxn(self.fireImages) then
				self.currentImage = 1
			end
			self.fireSprite:SetImage(self.fireImages[self.currentImage])
		end
	end
end

function Burnable:SetSprite(sprite)
	self.sprite = sprite
	self.sprite:Resize(self.size)
	self.sprite:SetCenter(self.size/2)
end

function Burnable:SetFireSprite(sprite)
	self.fireSprite = sprite
	self.fireSprite:Resize(self.size)
	self.fireSprite:SetCenter(self.size/2)
end

function Burnable:UpdatePosition()
	if self.sprite then
		self.sprite:SetPosition(self.x*self.tileSize, self.y*self.tileSize)
	end
	if self.fireSprite then
		self.fireSprite:SetPosition(self.x*self.tileSize, self.y*self.tileSize)
	end
end

function Burnable:SetPosition(x, y)
	self.x = x
	self.y = y
	self:UpdatePosition()
end

function Burnable:SetPositionX(x)
	self.x = x
	self:UpdatePosition()
end

function Burnable:SetPositionY(y)
	self.y = y
	self:UpdatePosition()
end

function Burnable:Draw(renderTarget)
	if self.sprite then
		renderTarget:Draw(self.sprite)
	end
end

function Burnable:DrawFire(renderTarget)
	if self.fireSprite and self.burning then
		renderTarget:DrawAdditive(self.fireSprite)
	end
end

function Burnable:Burn()
	if not self.incombustible then
		self.burning = true
		self.temperature = self.burnTemperature
	end
end

function Burnable:Extinguish()
	self.burning = false
	self.temperature = clickables.temperature.value
end

function Burnable:Calculate(matrix1, matrix2, deltaT)
	if self.incombustible then
		return
	end
	
	self.deltaTemperature = 0
	
	if self.burning then
		self:WhileIBurn(deltaT)		
	else --brennt noch nicht
		-- wärmeverlust durch kältere umgebung
		self:CalculateHeatLoss(deltaT)
		
		--wärmegewinn durch warme Bäume
		local function calc(matrix)
			--für jeden baum in max. max_calc_distance distanz, tue:
			for x=self.x-config.max_calc_distance,self.x+config.max_calc_distance do
				for y=self.y-config.max_calc_distance, self.y+config.max_calc_distance do
					--wenn es diesen baum gibt, dann
					local tree = matrix[y] and matrix[y][x]
					if tree ~= self and tree and tree.burning then
						--guck, wie viel wärmer er dich machen wird
						self:AddTemperature(tree, deltaT)
					end
				end
			end
		end
		calc(matrix1)
		calc(matrix2)
	end
end

function Burnable:Apply(deltaT)
	if self.incombustible then
		return
	end
	if self.deltaTemperature and self.deltaTemperature ~= 0 then
		self.temperature = self.temperature + self.deltaTemperature
	end
	
	if self.burning then
		if self.iWillExtinguish then
			self:ReplaceByScorched()
		end
	else --brennt noch nicht
		if self:WillIBurn(deltaT) then
			self.burning = true
			if self.sprite then
				self.sprite:SetColor(sf.Color(255, 255, 255))
			end
		else
			local mult = 1 - (self.temperature - clickables.temperature.value) / (self.ignitionTemperature - clickables.temperature.value) / 2
			mult = math.min(mult, 1)
			mult = math.max(mult, 0)
			if self.sprite then
				self.sprite:SetColor(sf.Color(255, 255*mult, 255*mult))
			end
		end
	end
end

--fügt die temperatur hinzu, für die der gegebene Baum zuständig ist
function Burnable:AddTemperature(tree, deltaT)
	
	--wind value
	local difVec = sf.Vector2f((tree.x-self.x), (tree.y-self.y))
	
	local distancePow2 = metersPerUnit*metersPerUnit*(difVec.x*difVec.x+difVec.y*difVec.y)
	--use 1m for same cell (ground-tree-fire)
	if distancePow2 == 0 then
		distancePow2 = config.tree_ground_distance
	end
	local distance = math.sqrt(distancePow2)
	local windVec = clickables.winddirection:GetDirection()
	local windSpeed = clickables.windspeed:InMetersPerSecond()
	local windFactor = 1 + (difVec.x*windVec.x + difVec.y*windVec.y) * windSpeed / criticalWindSpeed / distance
	--must not be negative (or it would cool)
	windFactor = math.max(0, windFactor)
	
	local pow = math.pow(euler, -temperatureGainConst * deltaT)
	--local addme = ( (self.temperature - tree.burnTemperature)*pow + (tree.burnTemperature - self.temperature) ) / distancePow2
	
	local addme = (self.heatConstant * math.pow(tree.burnTemperature+273, 4) / distancePow2) * deltaT

	if addme < 0 then
		print("Warning: Negative addme!")
		return
	end
	addme = addme * windFactor
	self.deltaTemperature = self.deltaTemperature + addme
end

--Hitzeverlust durch Luft
function Burnable:CalculateHeatLoss(deltaT)
	self.deltaTemperature = self.deltaTemperature + ( (self.temperature - clickables.temperature.value)*math.pow(euler, -temperatureLossConst * deltaT) + (clickables.temperature.value - self.temperature) )
end

--wird aufgerufen, solange der baum brennt, und verbrennt ihn und löscht ihn anschließend
function Burnable:WhileIBurn(deltaT)
	self.burnDuration = (self.burnDuration or 0) - deltaT
	self.iWillExtinguish = self.burnDuration <= 0
end

--schaut anhand von temperatur etc. 
function Burnable:WillIBurn(deltaT)
	return self.temperature >= self.ignitionTemperature
end

function Burnable:ReplaceByScorched()
	if not self.types then
		print("OMG? Error!")
		return
	end
	local replacer = self.types[self.scorched]
	if not replacer then
		print("Could not find scorched version ("..self.scorched..") for "..self.name.."!")
	else
		replacer = replacer:Copy{x=self.x, y=self.y}
	end
	local matrix1 = sim.treeMatrix
	local matrix2 = sim.groundMatrix
	if matrix1[self.y] and matrix1[self.y][self.x] == self then
		matrix1[self.y][self.x] = replacer
	elseif matrix2[self.y] and matrix2[self.y][self.x] == self then
		matrix2[self.y][self.x] = replacer
	else
		print("WTF? Error!")
	end
	return
end