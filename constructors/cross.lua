-- local Cross = {}

-- function Cross.newCross(self.x, self.y)
-- 	local offset = 5
-- 	local topLefttoBottomRight = {self.x + offset,self.y + offset, self.x - offset + Settings.cellSize, y - offset + Settings.cellSize}
-- 	local topRighttoBottomLeft = {x - offset + Settings.cellSize, y + offset, x + offset, y - offset + Settings.cellSize}
-- 	return love.graphics.line(topLefttoBottomRight), love.graphics.line(topRighttoBottomLeft)
-- end

-- return Cross

local Cross = {}
Cross.__index = Cross

function Cross.new(settings)
	local instance = setmetatable({}, Cross)
	instance.x      = settings.x
	instance.y      = settings.y
	instance.angle  = settings.angle or 0
	instance.speed  = settings.speed
	return instance
end

function Cross:setPosition(x, y)
	self.x = x
	self.y = y
end

function Cross:resetRotation()
	self.angle = 0
end

function Cross:update(dt)
	if Settings.gamesState.state[Settings.problemNr] == "solved" then
		self.angle = (self.angle + self.speed * dt * math.pi/2) % (2*math.pi)
	end
end

local offset = 5
local topLefttoBottomRight = {offset - (Settings.cellSize) / 2, offset - (Settings.cellSize) / 2, Settings.cellSize - offset - (Settings.cellSize) / 2, Settings.cellSize - offset - (Settings.cellSize) / 2}
local topRighttoBottomLeft = {Settings.cellSize - offset - (Settings.cellSize) / 2, offset - (Settings.cellSize) / 2, offset - (Settings.cellSize) / 2, Settings.cellSize - offset - (Settings.cellSize) / 2}
function Cross:draw()
	-- love.graphics.setLineWidth(2)
	love.graphics.push()
	love.graphics.translate(self.x + (Settings.cellSize) / 2, self.y + (Settings.cellSize) / 2)
	love.graphics.rotate(self.angle)
	love.graphics.line(topLefttoBottomRight)
	love.graphics.line(topRighttoBottomLeft)
	love.graphics.pop()
	-- love.graphics.setLineWidth(1)
end

return Cross