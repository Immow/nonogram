local s = require("settings")
local cell = require("cell")
local problems = require("problems")
local boardCellsLeft = require("boardcellsleft")
local boardCellsTop = require("boardcellsleft")

local BoardCellsMain = {}
local boardCells = {}
BoardCellsMain.x = boardCellsTop.x
BoardCellsMain.y = boardCellsLeft.y

function BoardCellsMain:generateBoardCells(r, c)
	local start_x = self.x
	for j = 1, c do
		table.insert(boardCells, {})
		for i = 1, r do
			table.insert(boardCells[j], cell.new({x = self.x, y = self.y, width = s.cellSize, height = s.cellSize, id = "board"}))
			self.x = self.x + s.cellSize
			if i == r then
				self.x = start_x
			end
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