local s = require("settings")
local cell = require("cell")
local problems = require("problems")
local d = require("boarddimensions")

local BoardCellsTop = {}

local numberCellsTop = {}
BoardCellsTop.x = d.getXofBoardcellMain()
BoardCellsTop.y = 0

function BoardCellsTop:generateNumberCellsTop(r, c)
	for i = 1, c do
		numberCellsTop[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 1})
			numberCellsTop[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end
end

function BoardCellsTop:draw()
	for i = 1, #numberCellsTop do
		for j = 1, #numberCellsTop[i] do
			numberCellsTop[i][j]:draw()
		end
	end
end

function BoardCellsTop:update(dt)
	-- for i = 1, #boardCells do
	-- 	for j = 1, #boardCells[i]do
	-- 		boardCells[i][j]:update(dt)
	-- 	end
	-- end
end

function BoardCellsTop:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsTop:mousereleased(x,y,button,istouch,presses)
	-- for i = 1, #boardCells do
	-- 	for j = 1, #boardCells[i] do
	-- 		boardCells[i][j].setCell = false
	-- 	end
	-- end
end

return BoardCellsTop