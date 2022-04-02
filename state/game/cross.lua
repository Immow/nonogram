local Cross = {}

function Cross.newCross(x, y)
	local offset = 5
	local topLefttoBottomRight = {x + offset,y + offset, x - offset + Settings.cellSize, y - offset + Settings.cellSize}
	local topRighttoBottomLeft = {x - offset + Settings.cellSize, y + offset, x + offset, y - offset + Settings.cellSize}
	return love.graphics.line(topLefttoBottomRight), love.graphics.line(topRighttoBottomLeft)
end

return Cross