Sim =
{
	New = function(self, window)
		if not window then
			error("No window supplied!", 2)
		end
		local obj = {}
		setmetatable(obj, self)
		self.__index = self

		obj.view = sf.View()
		obj.window = window
		obj.offset = sf.Vector2f(0,0)
		obj.running = false
		obj.width = 0
		obj.height = 0
		obj.groundMatrix = {}
		obj.treeMatrix = {}
		return obj
	end;
	
	GetGround = function(self, x, y)
		return self.groundMatrix[y] and self.groundMatrix[y][x]
	end;
	
	GetTree = function(self, x, y)
		return self.treeMatrix[y] and self.treeMatrix[y][x]
	end;
	
	AddTree = function(self, tree)
		if not self.treeMatrix[tree.y] then
			self.treeMatrix[tree.y] = {}
		end
		self.treeMatrix[tree.y][tree.x] = tree
	end;
	
	DeleteTree = function(self, x, y)
		if not self.treeMatrix[y] then
			return
		end
		self.treeMatrix[y][x] = nil
	end;
	
	DeleteGround = function(self, x, y)
		if not self.groundMatrix[y] then
			return
		end
		self.groundMatrix[y][x] = nil
	end;
	
	AddGround = function(self, ground)
		if not self.groundMatrix[ground.y] then
			self.groundMatrix[ground.y] = {}
		end
		self.groundMatrix[ground.y][ground.x] = ground
	end;
	
	Init = function(self)
		return true
	end;
	
	UpdateView = function(self, halfwidth, halfheight)
		self.width = 2*halfwidth - config.sidebar_width
		self.height = 2*halfheight - config.tilebar_height
		self.view:SetCenter(halfwidth, halfheight)
		self.view:SetHalfSize(halfwidth, halfheight)
		self.view:Move(self.offset)
	end;
	
	Update = function(self, deltaT)
		if not self.running then
			return
		end
		
		--update them (e.g. animate fire)
		for x, line in pairs(self.treeMatrix) do
			for y, tree in pairs(line) do
				tree:Update(deltaT)
			end
		end
		for x, line in pairs(self.groundMatrix) do
			for y, ground in pairs(line) do
				ground:Update(deltaT)
			end
		end
		--use sim speed
		deltaT = deltaT * clickables["simulationspeed"].value
		--calculate inflammability chance
		for x, line in pairs(self.treeMatrix) do
			for y, tree in pairs(line) do
				if tree.Calculate then
					tree:Calculate(self.treeMatrix, self.groundMatrix, deltaT*clickables["simulationspeed"].value)
				end
			end
		end
		for x, line in pairs(self.groundMatrix) do
			for y, ground in pairs(line) do
				if ground.Calculate then
					ground:Calculate(self.treeMatrix, self.groundMatrix, deltaT*clickables["simulationspeed"].value)
				end
			end
		end
		--apply chance
		for x, line in pairs(self.treeMatrix) do
			for y, tree in pairs(line) do
				if tree.Apply then
					tree:Apply(deltaT*clickables["simulationspeed"].value)
				end
			end
		end
		for x, line in pairs(self.groundMatrix) do
			for y, ground in pairs(line) do
				if ground.Apply then
					ground:Apply(deltaT*clickables["simulationspeed"].value)
				end
			end
		end
	end;
	
	OnEvent = function(self, event)
		for x, line in pairs(self.treeMatrix) do
			for y, tree in pairs(line) do
				if tree.OnEvent then
					if tree:OnEvent(event) then
						return true
					end
				end
			end
		end
		for x, line in pairs(self.groundMatrix) do
			for y, ground in pairs(line) do
				if ground.OnEvent then
					if ground:OnEvent(event) then
						return true
					end
				end
			end
		end
		-- do mouse dragging
		if event.Type == sf.Event.MouseButtonPressed and event.MouseButton.Button == 1 and sf.IntRect(0, 0, self.width, self.height):Contains(event.MouseButton.X, event.MouseButton.Y) then
			self.drag = true
			self.mousePosX = event.MouseButton.X
			self.mousePosY = event.MouseButton.Y
			self.window:ShowMouseCursor(false)
			return true
		elseif event.Type == sf.Event.MouseButtonReleased and event.MouseButton.Button == 1 and self.drag then
			self.drag = false
			self.window:ShowMouseCursor(true)
			return true
		elseif event.Type == sf.Event.MouseMoved and self.drag then
			local delta = sf.Vector2f(event.MouseMove.X - self.mousePosX, event.MouseMove.Y - self.mousePosY)
			self.window:SetCursorPosition(self.mousePosX, self.mousePosY)
			self.view:Move(delta)
			self.offset = self.offset + delta
			return true
		end
		return false
	end;
	
	Draw = function(self, renderTarget)
		if not renderTarget then
			error("No renderTarget specified!", 2)
		end
		renderTarget:SetView(self.view)
		--render ground
		self:DrawGround(renderTarget)
		--render ground fire
		self:DrawGroundFires(renderTarget)
		--render trees
		self:DrawTrees(renderTarget)
		--render tree fires
		self:DrawTreeFires(renderTarget)
	end;
	
	DrawGround = function(self, renderTarget)
		for y, line in pairs(self.groundMatrix) do
			for x, ground in pairs(line) do
				ground:Draw(renderTarget)
			end
		end
	end;
	
	DrawGroundFires = function(self, renderTarget)
		for y, line in pairs(self.groundMatrix) do
			for x, ground in pairs(line) do
				ground:DrawFire(renderTarget)
			end
		end
	end;
	
	DrawTrees = function(self, renderTarget)
		for y, line in pairs(self.treeMatrix) do
			for x, tree in pairs(line) do
				tree:Draw(renderTarget)
			end
		end
	end;
	
	DrawTreeFires = function(self, renderTarget)
		for y, line in pairs(self.treeMatrix) do
			for x, tree in pairs(line) do
				tree:DrawFire(renderTarget)
			end
		end
	end;
	
	Start = function(self)
		self.running = true
	end;
	
	Stop = function(self)
		self.running = false
	end;
	
	Save = function(self, file)
		file:write("CreateTrees{\n")
		for y, line in pairs(self.treeMatrix) do
			file:write("\t["..y.."] =\n\t{\n")
			for x, t in pairs(line) do
				file:write("\t\t["..x.."] =\n")
				t:Save(file)
				file:write(",\n")
			end
			file:write("\t},\n")
		end
		file:write("}\n\nCreateGround{\n")
		for y, line in pairs(self.groundMatrix) do
			file:write("\t["..y.."] =\n\t{\n")
			for x, g in pairs(line) do
				file:write("\t\t["..x.."] =\n")
				g:Save(file)
				file:write(",\n")
			end
			file:write("\t},\n")
		end
		file:write("}\n\n")
	end;

	Clear = function(self)
		self.treeMatrix = {}
		self.groundMatrix = {}
	end;
}