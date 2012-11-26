TextInput = Clickable:New()

function TextInput:New(info)
	--create parent foobar thingy
	local obj = Clickable.New(TextInput, info)
	--default values
	obj.color = obj.color or sf.Color(255, 255, 255)
	obj.outline = obj.outline or -1
	obj.outlineColor = obj.outlineColor or sf.Color(0, 0, 0)
	obj.textColor = obj.textColor or sf.Color(0, 0, 0)
	obj.textSize = obj.textSize or 15
	obj.value = obj.value or ""
	obj.maxLenght = obj.maxLength or 10
	
	obj.blinkTime = obj.blinkTime or 1
	obj.blinkTimer = 0
	obj.suffix = ""
	
	--create objects
	obj.text = sf.String()
	obj.text:SetSize(obj.textSize)
	obj.text:SetColor(obj.textColor)
	obj:UpdateText()
	obj.text:SetCenter(sf.Vector2f(obj.outline-1, obj.outline+1))
	obj.shape = sf.Shape.Rectangle(sf.Vector2f(0, 0), obj.size, obj.color, obj.outline, obj.outlineColor)
	
	--there's a strange bug when the obj.color defaults - the set color is wrong.
	obj.shape:SetColor(obj.color)
	
	obj:SetPosition(obj.position)
	
	return obj
end

function TextInput:UpdateText()
	self.text:SetText(sf.Unicode.Text(self.value .. self.suffix))
end

function TextInput:UpdatePosition()
	self.shape:SetPosition(self.position + self.offset)
	self.text:SetPosition(self.position + self.offset)
end

function TextInput:SetValue(val)
	self.value = val
	self:UpdateText()
end

function TextInput:Draw(renderTarget)
	Clickable.Draw(self, renderTarget)
	renderTarget:Draw(self.shape)
	renderTarget:Draw(self.text)
end

function TextInput:SetPosition(position)
	Clickable.SetPosition(self, position)
	self:UpdatePosition()
end

function TextInput:SetOffset(offset)
	Clickable.SetOffset(self, offset)
	self:UpdatePosition()
end

function TextInput:SetSize(size)
	Clickable.SetSize(self, size)
	self.shape:SetScale(self.size)
end


function TextInput:IsValidKey(key)
	if key >= sf.Key.A and key <= sf.Key.Z or key >= sf.Key.Num0 and key <= sf.Key.Num9 then
		return true
	end
	return false
end

function TextInput:OnEvent(event)
	if event.Type == sf.Event.KeyPressed and self.active then
		if self:IsValidKey(event.Key.Code) and string.len(self.value) < self.maxLen then
			self:SetValue(self.value .. string.char(event.Key.Code))
			return true
		elseif event.Key.Code == sf.Key.Back and string.len(self.value) > 0 then
			self:SetValue(string.sub(self.value, 1, -2))
			return true
		elseif event.Key.Code == sf.Key.Return then
			self:Deactivate()
			return true
		end
		return false
	elseif event.Type == sf.Event.MouseButtonPressed and event.MouseButton.Button == 0 then
		if self:Contains(event.MouseButton.X, event.MouseButton.Y) then
			self:Activate()
			return true
		else
			self:Deactivate()
			return false
		end
	end
	return false
end

function TextInput:Activate()
	self.active = true
	self.suffix = "_"
	self.blinkTimer = 0
	self:UpdateText()
end

function TextInput:Deactivate()
	self.active = false
	self.suffix = ""
	self:UpdateText()
end

function TextInput:OnUpdate(deltaT)
	if not self.active then
		return
	end
	self.blinkTimer = self.blinkTimer + deltaT
	if self.blinkTimer > self.blinkTime then
		if self.suffix == "" then
			self.suffix = "_"
		else
			self.suffix = ""
		end
		self:UpdateText()
		self.blinkTimer = 0
	end
end

function CreateTextInput(info)
	if not info.position then
		info.position = sf.Vector2f(info.positionX or 0, info.positionY or 0)
	end
	if not info.offset and info.offsetX and info.offsetY then
		info.offset = sf.Vector2f(info.offsetX or 0, info.offsetY or 0)
	end
	if not info.size then
		info.size = sf.Vector2f(info.sizeX or 0, info.sizeY or 0)
	end
	if not info.color and info.colorR and info.colorB and info.colorG then
		info.color = sf.Color(info.colorR, info.colorB, info.colorG)
	end
	if not info.textColor and info.textColorR and info.textColorB and info.textColorG then
		info.textColor = sf.Color(info.textColorR, info.textColorB, info.textColorG)
	end
	if not info.outlineColor and info.outlineColorR and info.outlineColorB and info.outlineColorG then
		info.outlineColor = sf.Color(info.outlineColorR, info.outlineColorB, info.outlineColorG)
	end
	local but = TextInput:New(info)
	if info.name then
		clickables[info.name] = but
		updatables[info.name] = but
	else
		table.insert(clickables, but)
		table.insert(updatables, but)
	end
end