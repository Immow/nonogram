local s = require("settings")
local cell = require("cell")
local boardNumbers = require("boardnumbers")
local problems = require("problems")

local BoardCellsMain = {}

local boardCells = {}
BoardCellsMain.x = 0
BoardCellsMain.y = 0
BoardCellsMain.squaresInRow = 0
BoardCellsMain.squaresInColumn = 0

function BoardCellsMain:load()
	self:generateBoardCells(#problems[s.problem][1], #problems[s.problem])
	self:gridLines()
end

function BoardCellsMain:gridLines()
	if #problems[s.problem][1] >= 5 and #problems[s.problem] >= 5 then
		self.squaresInRow = math.floor(#problems[s.problem][1] / 5)
		self.squaresInColumn = math.floor(#problems[s.problem] / 5)
	end
end

function BoardCellsMain:validateCells()
	local count = 0
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			if boardCells[i][j].marked and problems[s.problem][i][j] == 0 then
				count = count + 1
			end
			if boardCells[i][j].crossed and problems[s.problem][i][j] == 1 then
				count = count + 1
			end
		end
	end
	return count
end

function BoardCellsMain:generateBoardCells(r, c)
	boardCells = {}
	self.x = boardNumbers.x
	self.y = boardNumbers.y
	for i = 1, c do
		boardCells[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 0})
			boardCells[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end

end

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