function Save(filename)
	print("saving "..filename)
	local file, err = io.open(filename, "w+")
	if not file then
		print(err)
		return
	end
	
	file:write([[--automatically generated level save

--global settings
]])
	file:write('clickables["simulationspeed"]:SetValue('..clickables["simulationspeed"].value..')\n')
	file:write('clickables["windspeed"]:SetValue('..clickables["windspeed"].value..')\n')
	--not yet implemented
	--file:write('clickables["precipitation"]:SetValue('..clickables["precipitation"].value..')\n')
	--file:write('clickables["humidity"]:SetValue('..clickables["humidity"].value..')\n')
	file:write('clickables["temperature"]:SetValue('..clickables["temperature"].value..')\n')
	file:write('clickables["winddirection"]:SetAngle('..clickables["winddirection"].angle..')\n')
	
	file:write([[
--level info
]])
	sim:Save(file)
	
	file:close()
end