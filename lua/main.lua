--change dofile to use proper directory
local oldDofile = dofile
dofile = function(filename, ...)
	if type(filename) ~= "string" then
		error("dofile called without a string argument!", 2)
	end
	return oldDofile("../lua/"..filename, unpack(arg))
end

--change loadfile to use proper directory
local oldLoadfile = loadfile
loadfile = function(filename, ...)
	if type(filename) ~= "string" then
		error("loadfile called without a string argument!", 2)
	end
	return oldLoadfile("../lua/"..filename, unpack(arg))
end

-- I rewrote require since it wouldn't work
local oldRequire = require
local loaded = {}
require = function(filename, ...)
	if type(filename) ~= "string" then
		error("require called without a string argument!", 2)
	end
	if loaded[filename] then
		return
	end
	local file = loadfile(filename)
	if not file then
		error("could not find "..filename.."!", 2)
		return
	end
	loaded[filename] = true
	return file()
end

local cfgFile, err = loadfile("Config.lua")
local config = {}
if cfgFile then
	setfenv(cfgFile, config)
	cfgFile()
else
	print(err)
end
config.width = config.width or 800
config.height = config.height or 600
config.sidebar_width = config.sidebar_width or 150
local strings = {}
local stringFile, err = loadfile("localizations/"..config.language..".lua")
if stringFile then
	setfenv(stringFile, strings)
	stringFile()
else
	error("Error loading language "..config.lanuage..": "..err)
end

--Wald Brand Simulation
wbs = {}
wbs.config = config
wbs.strings = strings
--wbs MetaTable
local wbsMT = {
	--things not found here are searched in _G - globals
	__index = _G
}
setmetatable(wbs, wbsMT)

local function dofileEnv(name, env)
	local file, err = loadfile(name)
	if file then
		setfenv(file, env)
		file()
	else
		error(err, 2)
	end
end
wbs.dofileEnv = dofileEnv

wbs.clickables = {}
wbs.updatables = {}
wbs.wbs = wbs

dofileEnv("ImageManager.lua", wbs)
dofileEnv("Framework.lua", wbs)
dofileEnv("Save.lua", wbs)
dofileEnv("Clickable.lua", wbs)
dofileEnv("Button.lua", wbs)
dofileEnv("DirectionChooser.lua", wbs)
dofileEnv("Slider.lua", wbs)
dofileEnv("Text.lua", wbs)
dofileEnv("TextInput.lua", wbs)

dofileEnv("Burnable.lua", wbs)
dofileEnv("Tree.lua", wbs)
dofileEnv("Ground.lua", wbs)

dofileEnv("Sidebar.lua", wbs)
--todo: dynamic loading - all from folder
dofileEnv("defines/treeTypes.lua", wbs)
dofileEnv("defines/groundTypes.lua", wbs)

if not wbs.Init() then
	error("Could not initialize!")
end
wbs.MainLoop()
wbs.Deinit()