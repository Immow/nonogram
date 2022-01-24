local s            = require("settings")
local cell         = require("cell")
local boardNumbers = require("boardnumbers")

local BoardCellsLeft = {}

local numberCellsLeft = {}
BoardCellsLeft.x = 0
BoardCellsLeft.y = 0

function BoardCellsLeft:generateNumberCellsLeft(r, c)
	numberCellsLeft = {}
	self.x = 0
	self.y = boardNumbers.y
	for i = 1, c do
		numberCellsLeft[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 2})
			numberCellsLeft[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end
end

function BoardCellsLeft:draw()
	for i = 1, #numberCellsLeft do
		for j = 1, #numberCellsLeft[i] do
			numberCellsLeft[i][j]:draw()
		end
	end
end

function BoardCellsLeft:update(dt)
	for i = 1, #numberCellsLeft do
		for j = 1, #numberCellsLeft[i]do
			numberCellsLeft[i][j]:update(dt)
		end
	end
end

function BoardCellsLeft:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsLeft:mousereleased(x,y,button,istouch,presses)
	for i = 1, #numberCellsLeft do
		for j = 1, #numberCellsLeft[i] do
			numberCellsLeft[i][j].setCell = false
		end
	end
end

return BoardCellsLeft