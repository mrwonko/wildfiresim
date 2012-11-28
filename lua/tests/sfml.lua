--script to test lua export

--setup
print("Creating RenderWindow.")
local app = sf.RenderWindow(sf.VideoMode(800, 600), "SFML says hello!")
local text = sf.String("Ich bin ein Text.")
local filename = "../textures/test.jpg"
local img = sf.Image()
if not img:LoadFromFile(filename) then
	print("Could not load "..filename.."!")
	return
end
local sprite = sf.Sprite(img, sf.Vector2f(0, 100))

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
			end
		end
	end
	--logic
	
	--rendering
	app:Clear(sf.Color(0, 0, 0))
	app:Draw(text)
	app:Draw(sprite)
	app:Display()
end