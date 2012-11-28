TileBar = {}
TileBar.tileDistanceX = 8

function TileBar:New(info)
	local obj = info or {}
	setmetatable(obj, self)
	self.__index = self
	
	obj.bgColor = sf.Color(191, 191, 191)
	obj.tileSize = Burnable.tileSize
	
	obj.bgRect = 0
	obj.trees = {}
	obj.grounds = {}
	obj.treeOffset = 0
	obj.groundOffset = 0
	
	obj.leftArrowImage = ImageManager["interface/leftarrow.png"]
	obj.rightArrowImage = ImageManager["interface/rightarrow.png"]
	obj.arrowSprites = {}
	--images I load permanently are put in here
	obj.preloadedImages = {
		ImageManager["interface/burn.png"],
		ImageManager["interface/extinguish.png"]
	}
	
	obj.selected = false
	
	obj.radius = 0
	
	self.numHorizontalTiles = 0
	return obj
end

function TileBar:Draw(renderTarget)
	if self.bgRect ~= 0 then
		renderTarget:Draw(self.bgRect)
	end
	for i, tree in ipairs(self.trees) do
		if tree.visible then
			renderTarget:Draw(tree.sprite)
		end
	end
	for i, tree in ipairs(self.grounds) do
		if tree.visible then
			renderTarget:Draw(tree.sprite)
		end
	end
	for i, sprite in ipairs(self.arrowSprites) do
		renderTarget:Draw(sprite)
	end
	checkMe = {
		"treeBurnSprite",
		"treeExtinguishSprite",
		"groundBurnSprite",
		"groundExtinguishSprite",
		--render editSprite topmost
		"editSprite",
		"editRect",
	}
	for _, name in ipairs(checkMe) do
		if self[name] then
			renderTarget:Draw(self[name])
		end
	end
end

function TileBar:UpdatePosition(upperLeft, lowerRight)
	self.lowerRight = lowerRight
	self.upperLeft = upperLeft
	self.height = lowerRight.y - upperLeft.y
	self.width = lowerRight.x - upperLeft.x
	self.tileDistanceY = (self.height- 2*self.tileSize)/3
	self.bgRect = sf.Shape.Rectangle(upperLeft, lowerRight, self.bgColor, 0, sf.Color(0, 0, 0))
	self:UpdateTiles()
end

function TileBar:CalculateNumHorizontalTiles()
	self.numHorizontalTiles = math.floor((self.width - 2*self.tileSize - 3*self.tileDistanceX) / (self.tileSize + self.tileDistanceX))
end

function TileBar:UpdateTiles()
	--trees
	local deleter = 
	{
		name = "Bäume löschen",
		image = ImageManager["interface/deleteTree.png"],
		tree = nil,
		visible = false,
	}
	deleter.sprite = sf.Sprite(deleter.image)
	deleter.sprite:Resize(sf.Vector2f(self.tileSize, self.tileSize))
	
	self.trees = {
		deleter,
	}
	for name, tree in pairs(TreeTypes) do
		if tree.image then
			local t =
			{
				name = name,
				image = tree.image,
				sprite = sf.Sprite(tree.image),
				tree = tree,
				visible = false;
			}
			table.insert(self.trees, t)
		end
	end
	
	--ground
	local deleter = 
	{
		name = "Boden löschen",
		image = ImageManager["interface/deleteGround.png"],
		tree = nil,
		visible = false,
	}
	deleter.sprite = sf.Sprite(deleter.image)
	deleter.sprite:Resize(sf.Vector2f(self.tileSize, self.tileSize))
	
	self.grounds = {
		deleter,
	}
	for name, ground in pairs(GroundTypes) do
		if ground.image then
			local g =
			{
				name = name,
				image = ground.image,
				sprite = sf.Sprite(ground.image),
				ground = ground,
				visible = false;
			}
			table.insert(self.grounds, g)
		end
	end
	
	self:CalculateNumHorizontalTiles()
	
	--leave space for the left arrow
	local offsetX = self.tileDistanceX
	--y position is always the same
	local posY = self.tileDistanceY
	self.arrowSprites[1] = sf.Sprite(self.leftArrowImage)
	self.arrowSprites[1]:SetPosition(self.upperLeft + sf.Vector2f(offsetX, posY))
	self.arrowSprites[2] = sf.Sprite(self.rightArrowImage)
	self.arrowSprites[2]:SetPosition(self.upperLeft + sf.Vector2f(offsetX + (self.numHorizontalTiles-1)*(self.tileDistanceX+self.tileSize), posY))
	for i, tree in ipairs(self.trees) do
		local j = i - self.treeOffset;
		if j > 0 then
			if j > self.numHorizontalTiles + 2 then
				break
			end
			local posX = offsetX + j * (self.tileDistanceX + self.tileSize)
			tree.sprite:SetPosition(self.upperLeft + sf.Vector2f(posX, posY))
			tree.visible = true
		end
	end
	
	--burn & extinguish
	self.treeBurnSprite = sf.Sprite(ImageManager["interface/burn.png"])
	self.treeBurnSprite:SetPosition(self.upperLeft+sf.Vector2f(offsetX + (self.numHorizontalTiles)*(self.tileDistanceX+self.tileSize), posY))
	self.treeExtinguishSprite = sf.Sprite(ImageManager["interface/extinguish.png"])
	self.treeExtinguishSprite:SetPosition(self.upperLeft+sf.Vector2f(offsetX + (self.numHorizontalTiles+1)*(self.tileDistanceX+self.tileSize), posY))
	
	--leave space for the left arrow
	local offsetX = self.tileDistanceX
	--y position is always the same
	local posY = self.tileDistanceY*2+self.tileSize
	self.arrowSprites[3] = sf.Sprite(self.leftArrowImage)
	self.arrowSprites[3]:SetPosition(self.upperLeft + sf.Vector2f(offsetX, posY))
	self.arrowSprites[4] = sf.Sprite(self.rightArrowImage)
	self.arrowSprites[4]:SetPosition(self.upperLeft + sf.Vector2f(offsetX + (self.numHorizontalTiles-1)*(self.tileDistanceX+self.tileSize), posY))
	for i, ground in ipairs(self.grounds) do
		local j = i - self.groundOffset;
		if j > 0 then
			if j > self.numHorizontalTiles +2 then
				break
			end
			local posX = offsetX + j * (self.tileDistanceX + self.tileSize)
			ground.sprite:SetPosition(self.upperLeft + sf.Vector2f(posX, posY))
			ground.visible = true
		end
	end
	
	--burn & extinguish
	self.groundBurnSprite = sf.Sprite(ImageManager["interface/burn.png"])
	self.groundBurnSprite:SetPosition(self.upperLeft+sf.Vector2f(offsetX + (self.numHorizontalTiles)*(self.tileDistanceX+self.tileSize), posY))
	self.groundExtinguishSprite = sf.Sprite(ImageManager["interface/extinguish.png"])
	self.groundExtinguishSprite:SetPosition(self.upperLeft+sf.Vector2f(offsetX + (self.numHorizontalTiles+1)*(self.tileDistanceX+self.tileSize), posY))
end

function TileBar:Update(deltaT)
end

function TileBar:MousePressed(x, y)
	--helper function
	local function CreateRect(position, size)
		return sf.IntRect(position.x, position.y, size.x, size.y)
	end
	
	--all the things that are to be tested
	local testMe ={}
	
	--arrow buttons
	if table.maxn(self.arrowSprites) == 4 then
		--1: tree left
		table.insert(testMe,
		{
			rect = CreateRect(self.arrowSprites[1]:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self.treeOffset = self.treeOffset - 1
				self:UpdateTiles()
			end,
		})
		--2: tree right
		table.insert(testMe,
		{
			rect = CreateRect(self.arrowSprites[2]:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self.treeOffset = self.treeOffset + 1
				self:UpdateTiles()
			end,
		})
		--3: ground left
		table.insert(testMe,
		{
			rect = CreateRect(self.arrowSprites[3]:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self.groundOffset = self.groundOffset - 1
				self:UpdateTiles()
			end,
		})
		--4: ground right
		table.insert(testMe,
		{
			rect = CreateRect(self.arrowSprites[4]:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self.groundOffset = self.groundOffset + 1
				self:UpdateTiles()
			end,
		})
	end
	
	--tree tiles
	for i, tree in ipairs(self.trees) do
		table.insert(testMe, {
			rect = CreateRect(tree.sprite:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self:TreeSelected(tree)
			end,
		})
	end
	--burn
	if self.treeBurnSprite then
		table.insert(testMe,
		{
			rect = CreateRect(self.treeBurnSprite:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self:TreeBurnSelected()
			end,
		})
	end
	--extinguish
	if self.treeExtinguishSprite then
		table.insert(testMe,
		{
			rect = CreateRect(self.treeExtinguishSprite:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self:TreeExtinguishSelected()
			end,
		})
	end
	--ground tiles
	for i, ground in ipairs(self.grounds) do
		table.insert(testMe, {
			rect = CreateRect(ground.sprite:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self:GroundSelected(ground)
			end,
		})
	end
	--burn
	if self.groundBurnSprite then
		table.insert(testMe,
		{
			rect = CreateRect(self.groundBurnSprite:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self:GroundBurnSelected()
			end,
		})
	end
	--extinguish
	if self.groundExtinguishSprite then
		table.insert(testMe,
		{
			rect = CreateRect(self.groundExtinguishSprite:GetPosition(), sf.Vector2f(self.tileSize, self.tileSize)),
			OnClick = function()
				self:GroundExtinguishSelected()
			end,
		})
	end
	
	for i, info in ipairs(testMe) do
		if info.rect:Contains(x, y) then
			info.OnClick()
			return
		end
	end
end

function TileBar:OnEvent(event)
	local functionMapping =
	{
		tree = self.PlantTree,
		ground = self.PlantGround,
		treeBurn = self.BurnTree,
		groundBurn = self.BurnGround,
		treeExtinguish = self.ExtinguishTree,
		groundExtinguish = self.ExtinguishGround,
	}
	if event.Type == sf.Event.MouseButtonPressed then
		if event.MouseButton.Button == 0 then
			--click in tilebar
			if sf.IntRect(self.upperLeft.x, self.upperLeft.y, self.lowerRight.x - self.upperLeft.x, self.lowerRight.y - self.upperLeft.y):Contains(event.MouseButton.X, event.MouseButton.Y) then
				self:MousePressed(event.MouseButton.X, event.MouseButton.Y)
				return true
			--click on screen to edit
			elseif self.selected and sf.IntRect(0, 0, self.lowerRight.x - self.upperLeft.x, self.upperLeft.y - self.upperLeft.y):Contains(event.MouseButton.X, event.MouseButton.Y) then
				self.editRect:SetPosition(event.MouseButton.X, event.MouseButton.Y)
				self.lmbPressed = true
				if functionMapping[self.selected] then
					functionMapping[self.selected](self, event.MouseButton.X, event.MouseButton.Y)
				else
					print("Warning: TileBar.selected has invalid value:", self.selected)
					self.selected = false
					self.selectedTree = nil
					self.selectedGround = nil
					self.editSprite = nil
					self.editRect = nil
				end
				return true
			end
		--RMB to stop editing
		elseif event.MouseButton.Button == 1 and self.selected then
			self.editRect = nil
			self.selected = false
			self.selectedTree = nil
			self.selectedGround = nil
			self.editSprite = nil
			return true
		end
		return false
	elseif event.Type == sf.Event.KeyPressed then
		if event.Key.Code == sf.Key.Add then
			self:ChangeRadius(1)
			return true
		elseif event.Key.Code == sf.Key.Subtract then
			self:ChangeRadius(-1)
			return true
		end
		return false
	elseif event.Type == sf.Event.MouseWheelMoved then
		self:ChangeRadius(event.MouseWheel.Delta)
		return true
	--release lmb to stop adding trees
	elseif event.Type == sf.Event.MouseButtonReleased and event.MouseButton.Button == 0 and self.selected then
		self.lmbPressed = false
		return true
	--move mouse while editing
	elseif event.Type == sf.Event.MouseMoved and self.selected then
		self.editSprite:SetPosition(event.MouseMove.X, event.MouseMove.Y)
		if self.editRect then
			self.editRect:SetPosition(event.MouseMove.X, event.MouseMove.Y)
		end
		if not self.lmbPressed then
			return false
		end
		if functionMapping[self.selected] then
			functionMapping[self.selected](self, event.MouseMove.X, event.MouseMove.Y)
		else
			print("Warning: TileBar.selected has invalid value!")
			self.selected = false
			self.selectedTree = nil
			self.selectedGround = nil
			self.editSprite = nil
			self.editRect = nil
		end
		--someone else may use this event, too, if he wants (to not brake sliders etc.)
		return false
	end
	return false
end

function TileBar:SetupEditSprite()
	self.editSprite:Resize(sf.Vector2f(self.tileSize, self.tileSize))
	self.editSprite:SetCenter(sf.Vector2f(self.tileSize/2, self.tileSize/2))
end

function TileBar:TreeBurnSelected()
	self.selected = "treeBurn"
	self.editSprite = sf.Sprite(ImageManager["interface/burn.png"])
	self:SetupEditSprite()
	self:CreateEditRect()
	self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
end

function TileBar:TreeExtinguishSelected()
	self.selected = "treeExtinguish"
	self.editSprite = sf.Sprite(ImageManager["interface/extinguish.png"])
	self:SetupEditSprite()
	self:CreateEditRect()
	self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
end

function TileBar:GroundBurnSelected()
	self.selected = "groundBurn"
	self.editSprite = sf.Sprite(ImageManager["interface/burn.png"])
	self:SetupEditSprite()
	self:CreateEditRect()
	self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
end

function TileBar:GroundExtinguishSelected()
	self.selected = "groundExtinguish"
	self.editSprite = sf.Sprite(ImageManager["interface/extinguish.png"])
	self:SetupEditSprite()
	self:CreateEditRect()
	self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
end

function TileBar:TreeSelected(tree)
	self.selected = "tree"
	self.selectedTree = tree
	self.editSprite = sf.Sprite(tree.image)
	self:SetupEditSprite()
	self:CreateEditRect()
	self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
end

function TileBar:GroundSelected(ground)
	self.selected = "ground"
	self.selectedGround = ground
	self.editSprite = sf.Sprite(ground.image)
	self:SetupEditSprite()
	self:CreateEditRect()
	self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
end

function TileBar:CalculatePosition(x, y)
	local pos = sf.Vector2f(x, y)
	pos = pos + sim.offset
	pos = pos/self.tileSize
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y+0.5)
	return pos.x, pos.y
end

function TileBar:PlantTree(x, y)
	local tree = self.selectedTree
	x, y = self:CalculatePosition(x, y)
	if not tree.tree then
		for x2=x-(self.radius),x+(self.radius) do
			for y2=y-(self.radius),y+(self.radius) do
				sim:DeleteTree(x2, y2)
			end
		end
		return
	end
	for x2=x-(self.radius),x+(self.radius) do
		for y2=y-(self.radius),y+(self.radius) do
			sim:AddTree(tree.tree:Copy{x=x2, y=y2})
		end
	end
end

function TileBar:CreateEditRect()
	local c = sf.Color(0,0,0)
	c.a = 0
	self.editRect = sf.Shape.Rectangle(sf.Vector2f(-self.tileSize, -self.tileSize)*(self.radius+0.5), sf.Vector2f(self.tileSize, self.tileSize)*(self.radius+0.5), c, 1, sf.Color(255, 255, 255))
end

function TileBar:BurnTree(x, y)
	x, y = self:CalculatePosition(x, y)
	for x2=x-(self.radius),x+(self.radius) do
		for y2=y-(self.radius),y+(self.radius) do
			local t = sim:GetTree(x2, y2)
			if t then
				t:Burn()
			end
		end
	end
end

function TileBar:ExtinguishTree(x, y)
	x, y = self:CalculatePosition(x, y)
	for x2=x-(self.radius),x+(self.radius) do
		for y2=y-(self.radius),y+(self.radius) do
			local t = sim:GetTree(x2, y2)
			if t then
				t:Extinguish()
			end
		end
	end
end

function TileBar:BurnGround(x, y)
	x, y = self:CalculatePosition(x, y)
	for x2=x-(self.radius),x+(self.radius) do
		for y2=y-(self.radius),y+(self.radius) do
			local g = sim:GetGround(x2, y2)
			if g then
				g:Burn()
			end
		end
	end
end

function TileBar:ExtinguishGround(x, y)
	x, y = self:CalculatePosition(x, y)
	for x2=x-(self.radius),x+(self.radius) do
		for y2=y-(self.radius),y+(self.radius) do
			local g = sim:GetGround(x2, y2)
			if g then
				g:Extinguish()
			end
		end
	end
end

function TileBar:PlantGround(x, y)
	local ground = self.selectedGround
	x, y = self:CalculatePosition(x, y)
	if not ground.ground then
		for x2=x-(self.radius),x+(self.radius) do
			for y2=y-(self.radius),y+(self.radius) do
				sim:DeleteGround(x2, y2)
			end
		end
		return
	end
	for x2=x-(self.radius),x+(self.radius) do
		for y2=y-(self.radius),y+(self.radius) do
			sim:AddGround(ground.ground:Copy{x=x2, y=y2})
		end
	end
end

function TileBar:ChangeRadius(delta)	
	if delta > 0 or self.radius > 0 then
		self.radius = math.max(self.radius + delta, 0)
		self:CreateEditRect()
		self.editRect:SetPosition(window:GetInput():GetMouseX(), window:GetInput():GetMouseY())
	end
end