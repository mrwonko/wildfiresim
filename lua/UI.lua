dofileEnv("TileBar.lua", wbs)

UI =
{
	New = function(self, sidebarwidth, tilebarheight)
		if not sidebarwidth then
			error("No sidebar width supplied!", 2)
		end
		if not tilebarheight then
			error("No tilebar height supplied!", 2)
		end
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		
		obj.sidebar = sf.Shape.Rectangle(sf.Vector2f(0, 0), sf.Vector2f(-1, 1), sf.Color(191, 191, 191), 0, sf.Color(0,0,0));
		obj.tilebar = TileBar:New()
		obj.sidebarwidth = sidebarwidth
		obj.tilebarheight = tilebarheight
		return obj
	end;
	
	Init = function(self, width, height)
		self:UpdatePosition(width, height)
		return true
	end;
	
	UpdatePosition = function(self, width, height)
		if not width then
			error("no width supplied!", 2)
		end
		if not height then
			error("no height supplied!", 2)
		end
		for k, clickable in pairs(clickables) do
			if clickable.sidebar then
				clickable:SetOffset(sf.Vector2f(width - self.sidebarwidth, 0))
			end
			if clickable.tilebar then
				clickable:SetOffset(sf.Vector2f(0, height - self.sidebarwidth))
			end
		end
		self.sidebar:SetPosition(width, 0)
		self.sidebar:SetScale(self.sidebarwidth, height)
		self.tilebar:UpdatePosition(sf.Vector2f(0, height-self.tilebarheight), sf.Vector2f(width-self.sidebarwidth, height))
	end;
	
	Draw = function(self, renderTarget)
		if not renderTarget then
			error("No renderTarget supplied!", 2)
		end
		renderTarget:Draw(self.sidebar)
		for k, clickable in pairs(clickables) do
			clickable:Draw(renderTarget)
		end
		self.tilebar:Draw(renderTarget)
	end;
	
	Update = function(self, deltaT)
		for k, updatable in pairs(updatables) do
			updatable:OnUpdate(deltaT)
		end
		self.tilebar:Update(deltaT)
	end;
	
	OnEvent = function(self, event)
		for k, clickable in pairs(clickables) do
			if clickable:OnEvent(event) then
				return
			end
		end
		if self.tilebar:OnEvent(event) then
			return
		end
	end;
}