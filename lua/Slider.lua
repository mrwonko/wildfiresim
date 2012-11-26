local function round(num, step)
	num = num + step/2
	num = num - num%step
	return num
end

Slider = Clickable:New()

function Slider:New(info)
	--create parent foobar thingy
	local obj = Clickable.New(Slider, info)
	--default values
	obj.color = obj.color or sf.Color(255, 255, 255)
	obj.outline = obj.outline or -1
	obj.outlineColor = obj.outlineColor or sf.Color(0, 0, 0)
	obj.textColor = obj.textColor or sf.Color(255, 255, 255)
	obj.textSize = obj.textSize or 15
	obj.min = obj.min or 0
	obj.max = obj.max or 1
	obj.value = obj.value or obj.min
	obj.round = obj.round or 0.1
	obj.textSuffix = obj.text or ""
	--create objects
	obj.text = sf.String()
	obj.text:SetSize(obj.textSize)
	obj.text:SetColor(sf.Color(obj.outlineColor.r*.5+obj.color.r*.5, obj.outlineColor.g*.5+obj.color.g*.5, obj.outlineColor.b*.5+obj.color.b*.5))
	obj:SetText(""..obj.value..obj.textSuffix)
	obj.rect = sf.Shape.Rectangle(sf.Vector2f(0, 0), obj.size, obj.color, obj.outline, obj.outlineColor)
	obj.circle = sf.Shape.Circle(sf.Vector2f(0, 0), obj.size.y/2+obj.outline-1, obj.outlineColor, 0, sf.Color(0,0,0))
	
	obj:SetPosition(obj.position)
	return obj
end

function Slider:MouseMoved(x, y)
	local leftX = self.position.x + self.offset.x + self.size.y/2
	local lenX = self.size.x-self.size.y
	--get deltaX
	local dX = x - leftX
	--put it in correct range
	dX = math.max(math.min(dX, lenX), 0)
	dX = dX/lenX
	--round it, if necessary
	if window and (window:GetInput():IsKeyDown(sf.Key.LControl) or window:GetInput():IsKeyDown(sf.Key.RControl)) and self.round ~=0 then
		dX = round(dX, self.round / (self.max-self.min) )
	end
	
	self:SetValue ((1-dX)*self.min+dX*self.max)
	if self.OnMoved then
		self:OnMoved()
	end
end

function Slider:SetText(text)
	self.text:SetText(sf.Unicode.Text(text))
	self.text:SetCenter(sf.Vector2f(self.text:GetRect():GetWidth()/2, self.text:GetRect():GetHeight()/2)-self.size/2)
end

function Slider:Draw(renderTarget)
	Clickable.Draw(self, renderTarget)
	renderTarget:Draw(self.rect)
	renderTarget:Draw(self.circle)
	renderTarget:Draw(self.text)
end

function Slider:SetPosition(position)
	Clickable.SetPosition(self, position)
	self:UpdatePosition()
end

function Slider:SetOffset(offset)
	Clickable.SetOffset(self, offset)
	self:UpdatePosition()
end

function Slider:UpdatePosition()
	self.rect:SetPosition(self.position + self.offset)
	local normVal = (self.value - self.min) / (self.max - self.min)
	local len = self.size.x - self.size.y
	self.circle:SetPosition(self.position + self.offset + sf.Vector2f(self.size.y/2 + normVal * len, self.size.y/2))
	self.text:SetPosition(self.position + self.offset)
end

function Slider:SetValue(val)
	self.value = val
	self:UpdatePosition()
	self:SetText(""..round(self.value, 0.01)..self.textSuffix)
end

function Slider:OnEvent(event)
	if event.Type == sf.Event.MouseButtonPressed and event.MouseButton.Button == 0 and self:Contains(event.MouseButton.X, event.MouseButton.Y) then
		self:MouseMoved(event.MouseButton.X, event.MouseButton.Y)
		self.clicked = true
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

function CreateSlider(info)
	if not info.position then
		info.position = sf.Vector2f(info.positionX or 0, info.positionY or 0)
	end
	if not info.offset and info.offsetX and info.offsetY then
		info.offset = sf.Vector2f(info.offsetX or 0, info.offsetY or 0)
	end
	if not info.size then
		info.size = sf.Vector2f(info.sizeX or 50, info.sizeY or 10)
	end
	if info.OnClick then
		info.UserOnClick = info.OnClick
		info.OnClick = nil
	end
	if not info.color and info.colorR and info.colorB and info.colorG then
		info.color = sf.Color(info.colorR, info.colorB, info.colorG)
	end
	if not info.outlineColor and info.outlineColorR and info.outlineColorB and info.outlineColorG then
		info.outlineColor = sf.Color(info.outlineColorR, info.outlineColorB, info.outlineColorG)
	end
	local but = Slider:New(info)
	if info.name then
		clickables[info.name] = but
	else
		table.insert(clickables, but)
	end
end