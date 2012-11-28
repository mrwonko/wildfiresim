Text = Clickable:New()

function Text:New(info)
	--create parent foobar thingy
	local obj = Clickable.New(Text, info)
	--default values
	obj.color = obj.color or sf.Color(0, 0, 0)
	local text = obj.text or "..."
	obj.textSize = obj.textSize or 15
	--create objects
	obj.text = sf.String()
	obj.text:SetScale(obj.textSize/15)
	obj.text:SetColor(obj.color)
	obj:SetText(text)
	obj:SetPosition(obj.position)
	return obj
end

function Text:SetText(text)
	self.text:SetText(sf.Unicode.Text(text))
	self.text:SetCenter(sf.Vector2f(self.text:GetRect().width()/2, self.text:GetRect().height()/2)-self.size/2)
end

function Text:Draw(renderTarget)
	Clickable.Draw(self, renderTarget)
	renderTarget:Draw(self.text)
end

function Text:SetPosition(position)
	Clickable.SetPosition(self, position)
	self:UpdatePosition()
end

function Text:SetOffset(offset)
	Clickable.SetOffset(self, offset)
	self:UpdatePosition()
end

function Text:UpdatePosition()
	self.text:SetPosition(self.position + self.offset)
end

function CreateText(info)
	if not info.position then
		info.position = sf.Vector2f(info.positionX or 0, info.positionY or 0)
	end
	if not info.offset and info.offsetX and info.offsetY then
		info.offset = sf.Vector2f(info.offsetX or 0, info.offsetY or 0)
	end
	if not info.size then
		info.size = sf.Vector2f(info.sizeX or 50, info.sizeY or 10)
	end
	if not info.color and info.colorR and info.colorB and info.colorG then
		info.color = sf.Color(info.colorR, info.colorB, info.colorG)
	end
	local but = Text:New(info)
	if info.name then
		clickables[info.name] = but
	else
		table.insert(clickables, but)
	end
end