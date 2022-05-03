local Cross = {}
Cross.__index = Cross

function Cross.new(settings)
	local instance = setmetatable({}, Cross)
	instance.x      = settings.x
	instance.y      = settings.y
	instance.angle  = settings.angle or 0
	instance.speed  = settings.speed or 0
	instance.id     = settings.id
	instance.offset = 5
	return instance
end

function Cross:setPosition(x, y)
	self.x = x
	self.y = y
end

function Cross:reset()
	self.angle = 0
	self.speed = 0
end

function Cross:update(dt, speed)
	if self.id == 0 and Settings.gamesState.state[Settings.problemNr] == "solved" then
		self.angle = (self.angle + speed * dt * math.pi/2) % (2*math.pi)
	end
end

local topLefttoBottomRight = {5 - (Settings.cellSize) / 2, 5 - (Settings.cellSize) / 2, Settings.cellSize - 5 - (Settings.cellSize) / 2, Settings.cellSize - 5 - (Settings.cellSize) / 2}
local topRighttoBottomLeft = {Settings.cellSize - 5 - (Settings.cellSize) / 2, 5 - (Settings.cellSize) / 2, 5 - (Settings.cellSize) / 2, Settings.cellSize - 5 - (Settings.cellSize) / 2}
function Cross:draw(scaleX, scaleY)
	love.graphics.setLineWidth(2)
	love.graphics.push()
	love.graphics.translate(self.x + (Settings.cellSize) / 2, self.y + (Settings.cellSize) / 2)
	love.graphics.scale(scaleX or 1, scaleY or 1)
	love.graphics.rotate(self.angle)
	love.graphics.line(topLefttoBottomRight)
	love.graphics.line(topRighttoBottomLeft)
	love.graphics.pop()
	love.graphics.setLineWidth(1)
end

return Cross