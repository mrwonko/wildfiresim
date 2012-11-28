Button = Clickable:New()

function Button:New(info)
	--create parent foobar thingy
	local obj = Clickable.New(Button, info)
	--default values
	obj.color = obj.color or sf.Color(191, 191, 191)
	obj.downColor = obj.downColor or sf.Color(127, 127, 127)
	obj.outline = obj.outline or -1
	obj.outlineColor = obj.outlineColor or sf.Color(0, 0, 0)
	obj.textColor = obj.textColor or sf.Color(0, 0, 0)
	obj.textSize = obj.textSize or 15
	--create objects
	local text = obj.text or ""
	obj.text = sf.String()
	obj.text:SetScale(obj.textSize/15)
	obj.text:SetColor(obj.textColor)
	obj:SetText(text)
	obj.shape = sf.Shape.Rectangle(sf.Vector2f(0, 0), obj.size, obj.color, obj.outline, obj.outlineColor)
	
	--there's a strange bug when the obj.color defaults - the set color is wrong.
	obj.shape:SetColor(obj.color)
	
	obj:SetPosition(obj.position)
	return obj
end

function Button:SetText(text)
	self.text:SetText(sf.Unicode.Text(text))
	self.text:SetCenter(sf.Vector2f(self.text:GetRect().width()/2-self.size.x/2, self.outline))
end

function Button:Draw(renderTarget)
	Clickable.Draw(self, renderTarget)
	renderTarget:Draw(self.shape)
	renderTarget:Draw(self.text)
end

function Button:SetPosition(position)
	Clickable.SetPosition(self, position)
	self:UpdatePosition()
end

function Button:SetOffset(offset)
	Clickable.SetOffset(self, offset)
	self:UpdatePosition()
end

function Button:UpdatePosition()
	self.shape:SetPosition(self.position + self.offset)
	self.text:SetPosition(self.position + self.offset)
end

function Button:SetSize(size)
	Clickable.SetSize(self, size)
	self.shape:SetScale(self.size)
end

function Button:OnClick(button)
	if button == 0 then
		self.shape:SetColor(self.downColor)
	end
end

function Button:OnRelease(button, x, y)
	if button == 0 then
		self.shape:SetColor(self.color)
		if self.UserOnClick and self:Contains(window:GetInput():GetMouseX(), window:GetInput():GetMouseY()) then
			self:UserOnClick()
		end
	end
end

function CreateButton(info)
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
	local but = Button:New(info)
	if info.name then
		clickables[info.name] = but
	else
		table.insert(clickables, but)
	end
end