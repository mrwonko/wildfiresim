Ground = Burnable:New()
Ground.scorched = "test_scorched"

Ground.fireImages =
{
	ImageManager["fire/ground1.png"],
	ImageManager["fire/ground2.png"]
}

function Ground:New(info)
	local obj = Burnable.New(Ground, info)
	
	return obj
end

GroundTypes = {}
Ground.types = GroundTypes

function GroundType(info)
	local g = Ground:New(info)
	if not g.name then
		error("No name specified!", 2)
	end
	GroundTypes[g.name] = g
end

function CreateGround(matrix)
	for y, line in pairs(matrix) do
		for x, data in pairs(line) do
			if not data.name then
				error("No name specified!", 2)
			end
			local gtype = GroundTypes[data.name]
			if not gtype then
				error("No ground type "..data.name.." found!", 2)
			end
			data.x = x
			data.y = y
			sim:AddGround(gtype:Copy(data))
		end
	end
end