local Numbers = {}
Numbers.__index = Numbers

---@param settings any x,y,font,fontsize,text
function Numbers.new(settings)
	local instance = setmetatable({}, Numbers)
	instance.x        = settings.x or 0
	instance.y        = settings.y or 0
	instance.font     = settings.font or love.graphics.getFont()
	instance.fontSize = settings.fontSize or 12
	instance.text     = settings.text or ""
	return instance
end

function Numbers:update(dt)
	
end

function Numbers:centerTextX()
	return Settings.cellSize / 2 - self.font:getWidth(self.text) / 2
end

function Numbers:centerTextY()
	return Settings.cellSize / 2 - self.font:getHeight(self.text) / 2
end

function Numbers:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(Colors.white10)
	love.graphics.print(self.text, self.x + self:centerTextX(), self.y + self:centerTextY())
end

return Numbers