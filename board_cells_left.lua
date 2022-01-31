local s            = require("settings")
local cell         = require("cell")
local boardDimensions = require("board_dimensions")

local BoardCellsLeft = {}

BoardCellsLeft.numberCellsLeft = nil
BoardCellsLeft.x = nil
BoardCellsLeft.y = nil

function BoardCellsLeft:generateNumberCellsLeft(r, c)
	self.numberCellsLeft = {}
	self.x = boardDimensions.leftX
	self.y = boardDimensions.leftY
	for i = 1, c do
		self.numberCellsLeft[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 2, position = {i,j}})
			self.numberCellsLeft[i][j] = newCell
			if j > #boardDimensions.resultLeft[i] then
				self.numberCellsLeft[i][j-1].locked = true
				self.numberCellsLeft[i][j-1].id = 4
			end
		end
		self.y = self.y + s.cellSize
	end
end

function BoardCellsLeft:draw()
	for i = 1, #self.numberCellsLeft do
		for j = 1, #self.numberCellsLeft[i] do
			self.numberCellsLeft[i][j]:draw()
		end
	end
end

function BoardCellsLeft:update(dt)
	for i = 1, #self.numberCellsLeft do
		for j = 1, #self.numberCellsLeft[i]do
			self.numberCellsLeft[i][j]:update(dt)
		end
	end
end

function BoardCellsLeft:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsLeft:mousereleased(x,y,button,istouch,presses)
	for i = 1, #self.numberCellsLeft do
		for j = 1, #self.numberCellsLeft[i] do
			self.numberCellsLeft[i][j].setCell = false
		end
	end
end

return BoardCellsLeft