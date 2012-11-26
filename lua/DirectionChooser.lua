DirectionChooser = Clickable:New()

function DirectionChooser:New(info)
	--create parent foobar thingy
	local obj = Clickable.New(DirectionChooser, info)
	--default values
	obj.color = obj.color or sf.Color(255, 255, 255)
	obj.outline = obj.outline or -1
	obj.outlineColor = obj.outlineColor or sf.Color(0, 0, 0)
	--radius/size never changes!
	obj.radius = obj.radius or 10
	obj.size = sf.Vector2f(obj.radius*2, obj.radius*2)
	obj.thickness = obj.thickness or 1
	obj.angle = obj.angle or 0 --in radians
	--create objects
	local text = obj.text or ""
	obj.circle = sf.Shape.Circle(sf.Vector2f(0,0), obj.radius, obj.color, obj.outline, obj.outlineColor)
	obj.line = sf.Shape.Line(sf.Vector2f(0, 0), sf.Vector2f(obj.radius, 0), obj.thickness, obj.outlineColor, 0, obj.outlineColor)
	
	obj:SetPosition(obj.position)
	return obj
end

function DirectionChooser:GetDirection()
	return sf.Vector2f(math.cos(self.angle), -math.sin(self.angle))
end

function DirectionChooser:MouseMoved(x, y)
	local round = 0
	if window and (window:GetInput():IsKeyDown(sf.Key.LControl) or window:GetInput():IsKeyDown(sf.Key.RControl)) then
		round = 30
	end
	local center = self.position + self.offset + self.size/2
	local dir = sf.Vector2f(x, y) - center
	--mouse at center?
	if dir.x == 0 and dir.y == 0 then
		return
	end
	self.angle = math.atan(-dir.y/dir.x)
	if dir.x < 0 then
		self.angle = self.angle + math.pi
	elseif dir.y > 0 then
		self.angle = self.angle + 2 * math.pi
	end
	
	if round ~=0 then
		local dg = math.deg(self.angle)
		dg = dg + round/2
		dg = dg - dg%round
		self.angle = math.rad(dg)
	end
	
	self.line:SetRotation(math.deg(self.angle))
	print(self:GetDirection().x, self:GetDirection().y)
	if self.OnDirectionChanged then
		self:OnDirectionChanged()
	end
end

function DirectionChooser:SetAngle(ang)
	self.angle = ang
	self.line:SetRotation(math.deg(self.angle))
end

function DirectionChooser:Contains(x, y)
	local center = self.position + self.offset + self.size/2
	local deltaX = x - center.x
	local deltaY = y - center.y
	return (deltaX*deltaX + deltaY*deltaY <= self.radius*self.radius)
end

function DirectionChooser:Draw(renderTarget)
	Clickable.Draw(self, renderTarget)
	renderTarget:Draw(self.circle)
	renderTarget:Draw(self.line)
end

function DirectionChooser:SetPosition(position)
	Clickable.SetPosition(self, position)
	self:UpdatePosition()
end

function DirectionChooser:SetOffset(offset)
	Clickable.SetOffset(self, offset)
	self:UpdatePosition()
end

function DirectionChooser:UpdatePosition()
	self.circle:SetPosition(self.position + self.offset + self.size/2)
	self.line:SetPosition(self.position + self.offset + self.size/2)
end

function DirectionChooser:OnEvent(event)
	if event.Type == sf.Event.MouseButtonPressed and event.MouseButton.Button == 0 and self:Contains(event.MouseButton.X, event.MouseButton.Y) then
		self.clicked = true
		self:MouseMoved(event.MouseButton.X, event.MouseButton.Y)
		return true
	elseif event.Type == sf.Event.MouseButtonReleased and event.MouseButton.Button == 0 and self.clicked then
		self.clicked = false
		return true
	elseif event.Type == sf.Event.MouseMoved and self.clicked then
		self:MouseMoved(event.MouseMove.X, event.MouseMove.Y)
		return true
	end
	return false
end

function CreateDirectionChooser(info)
	if not info.position then
		info.position = sf.Vector2f(info.positionX or 0, info.positionY or 0)
	end
	if not info.offset and info.offsetX and info.offsetY then
		info.offset = sf.Vector2f(info.offsetX or 0, info.offsetY or 0)
	end
	if not info.size then
		info.size = sf.Vector2f(info.sizeX or 0, info.sizeY or 0)
	end
	if info.OnClick then
		info.UserOnClick = info.OnClick
		info.OnClick = nil
	end
	if not info.color and info.colorR and info.colorB and info.colorG then
		info.color = sf.Color(info.colorR, info.colorB, info.colorG)
	end
	if not info.downColor and info.downColorR and info.downColorB and info.downColorG then
		info.downColor = sf.Color(info.downColorR, info.downColorB, info.downColorG)
	end
	if not info.outlineColor and info.outlineColorR and info.outlineColorB and info.outlineColorG then
		info.outlineColor = sf.Color(info.outlineColorR, info.outlineColorB, info.outlineColorG)
	end
	local but = DirectionChooser:New(info)
	if info.name then
		clickables[info.name] = but
	else
		table.insert(clickables, but)
	end
end