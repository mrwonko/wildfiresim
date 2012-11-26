local errorImageFilename = "../textures/error.png"

local errorImage = sf.Image()
if not errorImage:LoadFromFile(errorImageFilename) then
	error("Could not load Error Image!")
end

ImageManager =
{
}
local ImageManagerMetatable =
{
	__mode = "k"; --weak table, i.e. does not add to reference count. Thus unused images are automatically collected.
	
	--index function - called when index doesn't exist. That means the image is not yet loaded.
	__index = function(t, index)
		if type(index) ~= "string" then
			print(debug.traceback("ImageManager called with invalid index type!"))
			return errorImage
		end
		local img = sf.Image()
		if not img:LoadFromFile("../textures/" .. index) then
			--TODO: Error Handling?
			print("Warning: Could not load image "..index)
			return errorImage;
		end
		t[index] = img
		return img
	end;
}
setmetatable(ImageManager, ImageManagerMetatable)