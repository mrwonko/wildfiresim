Tree = Burnable:New()
Tree.scorched = "stump"

Tree.fireImages =
{
	ImageManager["fire/tree1.png"],
	ImageManager["fire/tree2.png"]
}

function Tree:New(info)
	local obj = Burnable.New(Tree, info)
	
	return obj
end

TreeTypes = {}
Tree.types = TreeTypes

function TreeType(info)
	t = Tree:New(info)
	if not t.name then
		error("No name specified!", 2)
	end
	TreeTypes[t.name] = t
end

function CreateTrees(matrix)
	for y, line in pairs(matrix) do
		for x, data in pairs(line) do
			if not data.name then
				error("No name specified!", 2)
			end
			local ttype = TreeTypes[data.name]
			if not ttype then
				error("No tree type "..data.name.." found!", 2)
			end
			data.x = x
			data.y = y
			sim:AddTree(ttype:Copy(data))
		end
	end
end