local Row = {}
Row.__index = Row

function Row.new(settings)
	local instance = setmetatable({}, Row)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.width = settings.width
	instance.height = settings.height
	instance.color = settings.color or {0.152, 0.152, 0.152}
	instance.highlightColor1 = {0.215,0.211, 0.215}
	instance.highlightColor2 = {0.16,0.16, 0.16}
	instance.highlightHeight = 1
	return instance
end

function Row:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	if self.color ~= Colors.black then
		love.graphics.setColor(self.highlightColor1)
		love.graphics.rectangle("fill", self.x, self.y + self.height - self.highlightHeight, self.width, self.highlightHeight)
		love.graphics.setColor(self.highlightColor2)
		love.graphics.rectangle("fill", self.x, self.y + self.height - (self.highlightHeight * 2), self.width, self.highlightHeight)
	end
end

return Row