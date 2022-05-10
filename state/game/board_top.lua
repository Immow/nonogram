local cell            = require("constructors.cell")
local boardDimensions = require("state.game.board_dimensions")
local problems        = require("problems")

local BoardTop = {}

BoardTop.cells = nil
BoardTop.x = nil
BoardTop.y = nil

function BoardTop:load()
	self:generateNumberCellsTop(#problems[Settings.problemNr][1], boardDimensions.maxNumbersTop)
	Lib.loadSaveState(self.cells, "top")
end

function BoardTop:generateNumberCellsTop(r, c)
	self.cells = {}
	self.x = boardDimensions.topX
	self.y = boardDimensions.topY
	for i = 1, r do
		self.cells[i] = {}
		for j = c, 1, -1 do
			local y = self.y + Settings.cellSize * (c - j)
			local newCell = cell.new({x = self.x, y = y, width = Settings.cellSize, height = Settings.cellSize, id = 1, position = {i, j,}})
			self.cells[i][j] = newCell
			if j > #boardDimensions.resultTop[i] then
				self.cells[i][j].id = 4
				self.cells[i][j].locked = true
			end
		end
		self.x = self.x + Settings.cellSize
	end
end

function BoardTop:drawBorder()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw("empty")
		end
	end
end

function BoardTop:drawCross()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw("crossed")
		end
	end
end

function BoardTop:drawMarked()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw("marked")
		end
	end
end

function BoardTop:draw()
	self:drawMarked()
	self:drawBorder()
	self:drawCross()
end

function BoardTop:update(dt)
	for i = 1, #self.cells do
		for j = 1, #self.cells[i]do
			self.cells[i][j]:update(dt)
		end
	end
end

function BoardTop:mousereleased(x,y,button,istouch,presses)
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j].setCell = false
		end
	end
end

return BoardTop