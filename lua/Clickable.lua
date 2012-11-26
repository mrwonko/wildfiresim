Clickable =
{
	New = function(self, object)
		local object = object or {}
		setmetatable(object, self)
		self.__index = self
		
		object.position = object.position or sf.Vector2f(0, 0)
		--e.g. sidebar offset
		object.offset = object.offset or sf.Vector2f(0, 0)
		object.size = object.size or sf.Vector2f(10, 10)
		object.clicked = false
		
		return object
	end;
	
	--helps because IntRect has a 
	Contains = function(self, x, y)
		return (x >= self.position.x+self.offset.x and x <= self.position.x+self.offset.x+self.size.x and y >= self.position.y+self.offset.y and y <= self.position.y+self.offset.y+self.size.y)
	end;
	
	--return: whether the event was processed
	OnEvent = function(self, event)
		if event.Type == sf.Event.MouseButtonPressed and self:Contains(event.MouseButton.X, event.MouseButton.Y) then
			self.clicked = true
			self:OnClick(event.MouseButton.Button, event.MouseButton.x, event.MouseButton.y)
			return true
		elseif event.Type == sf.Event.MouseButtonReleased and self.clicked then
			self.clicked = false
			self:OnRelease(event.MouseButton.Button)
			return true
		end
		return false
	end;
	
	--functions to be overwritten by inheritants
	SetPosition = function(self, position)
		self.position = position
	end;
	
	SetOffset = function(self, offset)
		self.offset = offset
	end;
	
	SetSize = function(self, size)
		self.size = size
	end;
	
	Draw = function (self, renderTarget)
	end;
	
	OnClick = function(self, button, x, y)
	end;
	
	OnRelease = function(self, button)
	end;
}