local s = require("settings")

local Cross = {}

function Cross.newCross(x, y)
	local offset = 5
	local topLefttoBottomRight = {x + offset,y + offset, x - offset + s.cellSize, y - offset + s.cellSize}
	local topRighttoBottomLeft = {x - offset + s.cellSize, y + offset, x + offset, y - offset + s.cellSize}
	return love.graphics.line(topLefttoBottomRight), love.graphics.line(topRighttoBottomLeft)
end

return Cross