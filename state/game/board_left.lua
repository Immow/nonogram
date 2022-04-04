local cell            = require("constructors.cell")
local boardDimensions = require("state.game.board_dimensions")
local problems        = require("problems")

local BoardLeft = {}

BoardLeft.cells = nil
BoardLeft.x = nil
BoardLeft.y = nil

function BoardLeft:load()
	self:generateNumberCellsLeft(boardDimensions.maxNumbersLeft, #problems[Settings.problemNr])
	Lib.loadSaveState(self.cells, "left")
end

function BoardLeft:generateNumberCellsLeft(r, c)
	self.cells = {}
	self.x = boardDimensions.leftX
	self.y = boardDimensions.leftY
	for i = 1, c do
		self.cells[i] = {}
		for j = r, 1, -1 do
			local x = self.x + Settings.cellSize * (r - j)
			local newCell = cell.new({x = x, y = self.y, width = Settings.cellSize, height = Settings.cellSize, id = 2, position = {i,j}})
			self.cells[i][j] = newCell
			if j > #boardDimensions.resultLeft[i] then
				self.cells[i][j].locked = true
				self.cells[i][j].id = 4
			end
		end
		self.y = self.y + Settings.cellSize
	end
end

function BoardLeft:draw()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw()
		end
	end
end

function BoardLeft:update(dt)
	for i = 1, #self.cells do
		for j = 1, #self.cells[i]do
			self.cells[i][j]:update(dt)
		end
	end
end

function BoardLeft:mousereleased(x,y,button,istouch,presses)
	if Lib.onBoard(
		x,
		y,
		boardDimensions.leftX,
		boardDimensions.leftY,
		boardDimensions.leftWidth + boardDimensions.leftX,
		boardDimensions.leftHeight + boardDimensions.leftY
	)
	then
		for i = 1, #self.cells do
			for j = 1, #self.cells[i] do
				self.cells[i][j].setCell = false
			end
		end
	end
end

return BoardLeft