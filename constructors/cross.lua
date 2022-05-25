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
	if self.id == 0 and Settings.game.state[Settings.problemNr] == "solved" then
		self.angle = (self.angle + speed * dt * math.pi/2) % (2*math.pi)
	end
end

local padding = 5
local centerOffset = (Settings.cellSize - padding * 2) / 2
local line = {
	p1 =  0 - (Settings.cellSize / 2 - padding),
	p2 = (Settings.cellSize / 2 - padding),
}

local topLeftToBottomRight = {line.p1, line.p1, line.p2, line.p2}
local topRightToBottomLeft = {line.p2, line.p1, line.p1, line.p2}

function Cross:draw(scaleX, scaleY)
	love.graphics.setLineWidth(2)
	love.graphics.push()
	love.graphics.translate(self.x + (centerOffset + padding), self.y + (centerOffset + padding))
	love.graphics.scale(scaleX or 1, scaleY or 1)
	love.graphics.rotate(self.angle)
	love.graphics.line(topLeftToBottomRight)
	love.graphics.line(topRightToBottomLeft)
	love.graphics.pop()
	love.graphics.setLineWidth(1)
end

return Cross