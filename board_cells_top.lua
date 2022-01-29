local s            = require("settings")
local cell         = require("cell")
local boardDimensions = require("board_dimensions")

local BoardCellsTop = {}

BoardCellsTop.numberCellsTop = nil
BoardCellsTop.x = nil
BoardCellsTop.y = nil

function BoardCellsTop:generateNumberCellsTop(r, c)
	self.numberCellsTop = {}
	self.x = boardDimensions.topX
	self.y = boardDimensions.topY
	for i = 1, r do
		self.numberCellsTop[i] = {}
		for j = 1, c do
			local y = self.y + s.cellSize * (j - 1)
			local newCell = cell.new({x = self.x, y = y, width = s.cellSize, height = s.cellSize, id = 1, position = {i, j,}})
			self.numberCellsTop[i][j] = newCell
		end
		self.x = self.x + s.cellSize
	end
end

function BoardCellsTop:clear()
	for i = 1, #self.numberCellsTop do
		for j = 1, #self.numberCellsTop[i] do
			self.numberCellsTop[i][j].marked = false
			self.numberCellsTop[i][j].crossed = false
			self.numberCellsTop[i][j].setCell = false
			self.numberCellsTop[i][j].alpha = 0
			self.numberCellsTop[i][j].fade = false
		end
	end
end

function BoardCellsTop:draw()
	for i = 1, #self.numberCellsTop do
		for j = 1, #self.numberCellsTop[i] do
			self.numberCellsTop[i][j]:draw()
		end
	end
end

function BoardCellsTop:update(dt)
	for i = 1, #self.numberCellsTop do
		for j = 1, #self.numberCellsTop[i]do
			self.numberCellsTop[i][j]:update(dt)
		end
	end
end

function BoardCellsTop:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsTop:mousereleased(x,y,button,istouch,presses)
	for i = 1, #self.numberCellsTop do
		for j = 1, #self.numberCellsTop[i] do
			self.numberCellsTop[i][j].setCell = false
		end
	end
end

return BoardCellsTop