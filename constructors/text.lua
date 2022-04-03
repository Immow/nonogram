local Text = {}
Text.__index = Text

function Text.new(settings)
	local instance = setmetatable({}, Text)

	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.text = settings.text or ""
	instance.height = settings.height or 0
	instance.color = settings.color or Colors.white
	instance.offset = settings.offset or 10
	instance.font = settings.font
	return instance
end

function Text:draw()
	love.graphics.setColor(self.color)
	love.graphics.setFont(self.font)
	love.graphics.print(self.text, self.x + self.offset, self.y + self.height / 2 - self.font:getHeight() / 2)
	love.graphics.reset()
end

return Text