local colors = require("colors")
local Boardguides = {}
Boardguides.__index = Boardguides

function Boardguides.new(settings)
	local instance = setmetatable({}, Boardguides)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.width = settings.width or 0
	instance.height = settings.height or 0
	return instance
end

function Boardguides:draw()
	love.graphics.setColor(colors.gray[500])
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return Boardguides