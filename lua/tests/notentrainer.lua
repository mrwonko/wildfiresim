--  constants

local g_errorImageFilename = "../textures/error.png"
local g_entryFilename = "../lua/notentrainer_entries.lua"

local g_errorImage = sf.Image()
if not g_errorImage:LoadFromFile(g_errorImageFilename) then
	error("Could not load Error Image!")
end

--  Image Manager

--Singleton, kind of.
local ImageManager =
{
}
local ImageManagerMetatable =
{
	__mode = "k"; --weak table, i.e. does not add to reference count. Thus unused images are automatically collected.
	
	--index function - called when index doesn't exist. That means the image is not yet loaded.
	__index = function(t, index)
		local img = sf.Image()
		if not img:LoadFromFile(index) then
			--TODO: Error Handling?
			print("Could not load image "..index)
			return g_errorImage;
		end
		t[index] = img
		return img
	end;
}
setmetatable(ImageManager, ImageManagerMetatable)

-- Entry Definition
local Entry =
{
	New = function(self, object)
		object = object or {}
		object.question = object.question or "<Frage fehlt>";
		object.answer = object.answer or "";
		object.questionText = sf.String(object.question)
		if object.image then
			object.imageSprite = sf.Sprite(ImageManager["../textures/"..object.image], sf.Vector2f(0, 100))
		end
		setmetatable(object, self)
		self.__index = self
		return object
	end;
	
	Draw = function(self, renderTarget)
		if self.imageSprite then
			renderTarget:Draw(self.imageSprite)
		end
		renderTarget:Draw(self.questionText)
	end;
}

local entries = {}

function CreateEntry(info)
	if not info then return end
	if not info.question then
		--thread, string, level (1 = this function)
		print(debug.traceback(1, "No question defined!", 2))
		return
	end
	if not info.answer then
		--thread, string, level (1 = this function)
		print(debug.traceback(1, "No answer defined!", 2))
		return
	end
	--keeps the user from overwriting class methods
	safe_info =
	{
		question = info.question;
		answer = info.answer;
		image = info.image;
	}
	table.insert(entries, Entry:New(safe_info))
end

--  Entry loading
local entryFileEnv = {}
entryFileEnv.Entry = CreateEntry
local entryFileEnvMT = {__index = _G}
setmetatable(entryFileEnv, entryFileEnvMT)--unsafe?
local entryFile = loadfile(g_entryFilename)
if not entryFile then
	print("Could not load entries from "..g_entryFilename.."!")
	return
end
setfenv(entryFile, entryFileEnv)
entryFile()

--  shuffle entries
math.randomseed(os.time())
function Shuffle(what)
	local t = {}
	for i, v in ipairs(what) do
		t[i] = v
	end
	local shuffled_entries = {}
	while table.maxn(t) > 0 do
		index = math.random(1, table.maxn(t))
		table.insert(shuffled_entries, t[index])
		table.remove(t, index)
	end
	return shuffled_entries
end
local workEntries = Shuffle(entries)

--  State Machine

local currentState = 0
local endState = {}
local correctAnswers = 0

function SetState(state)
	if currentState and currentState ~= 0 then
		currentState:OnStop()
	end
	currentState = state
	state:OnStart()
end

local State = {
	New = function(self, object)
		object = object or {}
		object.drawables = object.drawables or {}
		setmetatable(object, self)
		self.__index = self
		return object
	end;
	
	OnStart = function(self)
	end;
	OnStop = function(self)
	end;
	KeyPressed = function(self, key)
	end;
	
	Draw = function(self, renderTarget)
		if not renderTarget then
			error("State:Draw() called without renderTarget argument!", 2)
			return
		end
		for k, drawable in pairs(self.drawables) do
			renderTarget:Draw(drawable)
		end
	end;
}

--object
local endState = State:New()
--object
local startState = State:New()
--class
local QuestionState = State:New()

function QuestionState:New(entry)
	obj = State.New(self)
	obj.entry = entry
	obj.text = sf.String()
	obj.text:SetPosition(sf.Vector2f(0, 50))
	table.insert(obj.drawables, obj.text)
	obj.done = false
	obj.answer = ""
	return obj
end

function QuestionState:Draw(renderTarget)
	State.Draw(self, renderTarget)
	self.entry:Draw(renderTarget)
end

function QuestionState:OnStart()
	self.done = false
	self.text:SetText(sf.Unicode.Text(""))
	self.answer = ""
end

function QuestionState:KeyPressed(key)
	if self.done then
		self:Done()
		return
	else
		if key >= sf.Key.A and key <= sf.Key.Z or key >= sf.Key.Num0 and key <= sf.Key.Num9 then
			self.answer = self.answer .. string.char(key)
			self.text:SetText(sf.Unicode.Text(self.answer))
			return
		elseif key == sf.Key.Space then
			self.answer = self.answer .. " "
			self.text:SetText(sf.Unicode.Text(self.answer))
			return
		elseif key == sf.Key.Back then
			if string.len(self.answer) > 0 then
				self.answer = string.sub(self.answer, 1, -2)
				self.text:SetText(sf.Unicode.Text(self.answer))
			end
			return
		elseif key == sf.Key.Return then
			if string.lower(self.answer) == string.lower(self.entry.answer) then
				self:Correct()
			else
				self:Incorrect()
			end
			return
		end
	end
end

function QuestionState:Correct()
	correctAnswers = correctAnswers + 1
	self.text:SetText(sf.Unicode.Text("Richtig!"))
	self.done = true
end

function QuestionState:Incorrect()
	self.text:SetText(sf.Unicode.Text("Falsch! Richtig ist "..self.entry.answer.."."))
	self.done = true
end

function QuestionState:Done()
	if table.maxn(workEntries) == 0 then
		SetState(endState)
	else
		SetState(QuestionState:New(workEntries[1]))
		table.remove(workEntries, 1)
	end
end

startState.drawables[1] = sf.String("Willkommen!\nEscape zum Beenden oder was anderes zum Starten.")
function startState:OnStart()
	correctAnswers = 0
	workEntries = Shuffle(entries)
end
function startState:KeyPressed(key)
	SetState(QuestionState:New(workEntries[1]))
	table.remove(workEntries, 1)
end

endState.drawables[1] = sf.String()
function endState:OnStart()
	self.drawables[1]:SetText(sf.Unicode.Text("Du hast "..correctAnswers.." von "..table.maxn(entries).." richtig."))
end
function endState:KeyPressed()
	SetState(startState)
end

SetState(startState)

--  Setup

print("Creating RenderWindow.")
local app = sf.RenderWindow(sf.VideoMode(800, 600), "SFML says hello!")

print("Entering main loop.")
while app:IsOpened() do
	--input
	event = sf.Event()
	while app:GetEvent(event) do
		if event.Type == sf.Event.Closed then
			print("Window closed, quitting program.")
			app:Close()
		elseif event.Type == sf.Event.KeyPressed then
			if  event.Key.Code == sf.Key.Escape then
				print("Escape pressed, quitting program.")
				app:Close()
			elseif currentState then
				currentState:KeyPressed(event.Key.Code)
			end
		end
	end
	--logic
	
	if not currentState then
		App:Close()
	end
	
	--rendering
	app:Clear(sf.Color(0, 0, 0))
	
	if currentState then
		currentState:Draw(app)
	end
	
	app:Display()
end