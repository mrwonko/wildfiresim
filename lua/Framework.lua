--forward declaration(s)
local UpdateBars = 0

dofileEnv("UI.lua", wbs)
dofileEnv("Sim.lua", wbs)
local ui = 0
sim = 0
local fullView = sf.View()

local resized = false

local function UpdateViews()
	local halfSize = sf.Vector2f(window:GetSize().x/2, window:GetSize().y/2)
	fullView:SetHalfSize(halfSize)
	fullView:SetCenter(halfSize)
	sim:UpdateView(window:GetSize().x)/2, window:GetSize().y/2)
	resized = false
end

function Init()
	window = sf.RenderWindow(sf.VideoMode(config.width, config.height), strings.title)
	sim = Sim:New(window)
	ui = UI:New(config.sidebar_width, config.tilebar_height)
	if not ui then
		print("UI:New failed!")
		return false
	end
	if not sim:Init() then
		return false
	end
	if not ui:Init(window:GetSize().x(), window:GetSize().y) then
		return false
	end
	UpdateViews()
	return true
end

local function ProcessEvent(event)
	--send event to UI
	if ui:OnEvent(event) then
		return
	end
	
	--send event to sim
	if sim:OnEvent(event) then
		return
	end
	--check for other events
	if event.Type == sf.Event.Closed then
		window:Close()
		return
	elseif event.Type == sf.Event.Resized then
		resized = true
		return
	end
end

local function Logic()
	--  update UI
	if resized then
		ui:UpdatePosition(window:GetSize().x, window:GetSize().y)
		UpdateViews()
	end
	ui:Update(window:GetFrameTime())
	--  update simulation
	sim:Update(window:GetFrameTime())
end

local function Rendering()
	window:Clear(sf.Color(0,0,0))
	--  render map
	sim:Draw(window)
	
	--  render UI
	window:SetView(fullView)
	ui:Draw(window)
	
	window:Display()
end

function MainLoop()
	while window:IsOpened() do
		local event = sf.Event()
		while window:GetEvent(event) do
			ProcessEvent(event)
		end
		Logic()
		Rendering()
	end
end

function Deinit()
	window = nil;
end