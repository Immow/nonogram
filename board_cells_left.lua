local s            = require("settings")
local cell         = require("cell")
local boardNumbers = require("board_numbers")
local boardDimensions = require("board_dimensions")

local BoardCellsLeft = {}

BoardCellsLeft.numberCellsLeft = {}
BoardCellsLeft.x = 0
BoardCellsLeft.y = 0

function BoardCellsLeft:generateNumberCellsLeft(r, c)
	self.numberCellsLeft = {}
	self.x = 0 + boardDimensions.x
	self.y = boardNumbers.y
	for i = 1, c do
		self.numberCellsLeft[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 2, position = {i,j}, origin = {boardNumbers.x, boardNumbers.y}})
			self.numberCellsLeft[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end
end

function BoardCellsLeft:clear()
	for i = 1, #self.numberCellsLeft do
		for j = 1, #self.numberCellsLeft[i] do
			self.numberCellsLeft[i][j].marked = false
			self.numberCellsLeft[i][j].crossed = false
			self.numberCellsLeft[i][j].setCell = false
			self.numberCellsLeft[i][j].alpha = 0
			self.numberCellsLeft[i][j].fade = false
		end
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