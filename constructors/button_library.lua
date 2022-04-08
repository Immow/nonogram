local state = require("state.state")
local Row   = require("constructors.row")
local game  = require("state.game.game")
local Button_Library = {}

local mtClass    = {__index = Row}
local mtInstance = {__index = Button_Library}

setmetatable(Button_Library, mtClass)

function Button_Library.new(settings)
	local instance = Row.new(settings)
	setmetatable(instance, mtInstance)
	instance.draggingDistance = 0
	instance.dragging = false
	instance.buttonNr = settings.buttonNr
	instance.startPosition_y = instance.y
	instance.endPosition_y = settings.endPosition_y
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
			Settings.problemNr = self.buttonNr
			state.setScene("state.game.game")
			game:load()
		end
	end
end

function Button_Library:loadGame()
	Settings.problemNr = self.buttonNr
	state.setScene("state.game.game")
	game:load()
end

function Button_Library:update(dt)
	if self.dragging then
		self.y = love.mouse.getY() - self.draggingDistance
	end
end

function Button_Library:drawBackground()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.reset()
end

function Button_Library:drawButtonNr()
	love.graphics.setColor(Colors.white)
	love.graphics.print(self.buttonNr, self.x, self.y)
	love.graphics.reset()
end

function Button_Library:draw()
	self:drawBackground()
	self:drawButtonNr()
	love.graphics.print(self.y, self.x + 50, self.y)
end

return Button_Library