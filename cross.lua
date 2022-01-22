local s = require("settings")

local Cross = {}

function Cross:newCross(x, y)
	local topLefttoBottomRight = {x,y,x+s.cellSize, y+s.cellSize}
	local topRighttoBottomLeft = {x+s.cellSize, y, x,y+s.cellSize}
	return love.graphics.line(topLefttoBottomRight), love.graphics.line(topRighttoBottomLeft)
end

return Cross