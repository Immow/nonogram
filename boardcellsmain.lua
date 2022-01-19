local s = require("settings")
local cell = require("cell")
local problems = require("problems")
local d = require("boarddimensions")

local BoardCellsMain = {}

local boardCells = {}
BoardCellsMain.x = d.getXofBoardcellMain()
BoardCellsMain.y = d.getYBoardcellMain()

function BoardCellsMain:generateBoardCells(r, c)
	for i = 1, c do
		boardCells[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = "board"})
			boardCells[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end
end

BoardCellsMain:generateBoardCells(#problems[s.problem][1], #problems[s.problem])

function BoardCellsMain:draw()
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			boardCells[i][j]:draw()
		end
	end
end

function BoardCellsMain:update(dt)
	for i = 1, #boardCells do
		for j = 1, #boardCells[i]do
			boardCells[i][j]:update(dt)
		end
	end
end

function BoardCellsMain:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsMain:mousereleased(x,y,button,istouch,presses)
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			boardCells[i][j].setCell = false
		end
	end
end

return BoardCellsMain