local Row       = require("constructors.row")
local Button_Library = {}

local mtClass    = {__index = Row}
local mtInstance = {__index = Button_Library}

setmetatable(Button_Library, mtClass)

function Button_Library.new(settings)
	local instance = Row.new(settings)
	setmetatable(instance, mtInstance)
	instance.draggingDistance = 0
	instance.dragging = false
	return instance
end

function Button_Library:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Button_Library:mousepressed(x,y,button,istouch,presses)

end

function Button_Library:mousereleased(x,y,button,istouch,presses)
	if button == 1 then
		if self:containsPoint(x, y) then
			Sound:play("click", "click", Settings.sfxVolume, 1)
		end
	end
end

function Button_Library:update(dt)
	if self.dragging then
		self.y = love.mouse.getY() - self.draggingDistance
	end
end

function Button_Library:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	-- if self.color ~= Colors.black then
	-- 	love.graphics.setColor(self.highlightColor1)
	-- 	love.graphics.rectangle("fill", self.x, self.y + self.height - self.highlightHeight, self.width, self.highlightHeight)
	-- 	love.graphics.setColor(self.highlightColor2)
	-- 	love.graphics.rectangle("fill", self.x, self.y + self.height - (self.highlightHeight * 2), self.width, self.highlightHeight)
	-- end
end

return Button_Library