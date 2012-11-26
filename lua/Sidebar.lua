local distance = 10
local posY = distance
--start
CreateButton{
	name = "startstop";
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	text = "Start";
	outline = -1;
	running = false;
	OnClick = function(self)
		if self.running then
			self:SetText(strings.simstart)
			self.running = false
			sim:Stop()
		else
			self:SetText(strings.simstop)
			self.running = true
			sim:Start()
		end
	end;
}

posY = posY + distance + 20

--simspeed
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.simspeed;
}
posY = posY + 20

CreateSlider{
	name="simulationspeed";
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	min = 0;
	max = 10;
	value = 1;
	round = 1;
	text = "x";
	OnMoved = function(self)
	end;
}
posY = posY + distance + 20

--wind direction
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.winddirection;
}
posY = posY + 20

CreateDirectionChooser{
	name = "winddirection";
	positionX = 55;
	positionY = posY;
	sidebar = true;
	radius = 20;
	outline = -1;
	OnDirectionChanged = function(self)
		--print("Direction picked:" .. math.deg(self.angle))
	end
}
posY = posY + distance + 40

--wind speed
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.windspeed;
}
posY = posY + 20

CreateSlider{
	name = "windspeed";
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	min = 0;
	max = 150;
	round = 5;
	text = " km/h";
	OnMoved = function(self)
		--print("Wind ist jetzt "..self:InMetersPerSecond().." m/s schnell!")
	end;
	InMetersPerSecond = function(self)
		return self.value/3.6
	end;
}
posY = posY + distance + 20

--[[ not yet implemented

--percipitation
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.precipitation;
}
posY = posY + 20

CreateSlider{
	name = "precipitation";
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	min = 0;
	max = 100; --ab 60mm/min = starkregen
	round = 5;
	text = " mm/h";
	OnMoved = function(self)
	end;
}
posY = posY + distance + 20

--]]

--temperature
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.temperature;
}
posY = posY + 20

CreateSlider{
	name = "temperature";
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	min = -30;
	max = 70;
	value = 20;
	round = 5;
	text = "°C";
	OnMoved = function(self)
	end;
}
posY = posY + distance + 20

--[[ not yet implemented

--humidity
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.humidity;
}
posY = posY + 20

CreateSlider{
	name = "humidity";
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	min = 0;
	max = 100;
	round = 5;
	text = " %";
	OnMoved = function(self)
	end;
}
posY = posY + distance + 20

--]]

--Name
CreateText{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	textSize = 15;
	text = strings.name;
}
posY = posY + 20

CreateTextInput {
	name = "name";
	positionX = 10;
	positionY = posY;
	sizeX = 130;
	sizeY = 20;
	maxLen = 15;
	sidebar = true;
}
posY = posY + distance + 20

--save/load
CreateButton{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 75;
	sizeY = 20;
	text = strings.save;
	outline = -1;
	running = false;
	OnClick = function(self)
		Save("../saves/"..clickables["name"].value..".lua")
	end;
}
CreateButton{
	positionX = 95;
	positionY = posY;
	sidebar = true;
	sizeX = 45;
	sizeY = 20;
	text = strings.load;
	outline = -1;
	running = false;
	OnClick = function(self)
		sim:Clear()
		local file, err = loadfile("../saves/"..clickables["name"].value..".lua")
		if file then
			setfenv(file, wbs)
			file()
		else
			print(err)
		end
	end;
}
posY = posY + distance + 20

--new
CreateButton{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	text = strings.new;
	outline = -1;
	OnClick = function(self)
		sim:Clear()
	end;
}
posY = posY + distance + 20

--center camera
CreateButton{
	positionX = 10;
	positionY = posY;
	sidebar = true;
	sizeX = 130;
	sizeY = 20;
	text = strings.center;
	outline = -1;
	OnClick = function(self)
		sim.view:Move(-sim.offset.x, -sim.offset.y)
		sim.offset = sf.Vector2f(0, 0)
	end;
}
posY = posY + distance + 20