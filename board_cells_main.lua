local s            = require("settings")
local cell         = require("cell")
local boardNumbers = require("board_numbers")
local problems     = require("problems")
local boardCellsLeft = require("board_cells_left")
local boardCellsTop = require("board_cells_top")
local lib           = require("lib")

local BoardCellsMain = {}

local guides = {}

local boardCells = {}
local boardCells_t = nil
BoardCellsMain.x = 0
BoardCellsMain.y = 0

function BoardCellsMain:load()
	self:generateBoardCells(#problems[s.problem][1], #problems[s.problem])
	boardCells_t = lib.Transpose(boardCells)
	self.generateGridGuides()
end

function BoardCellsMain.generateGridGuides()
	guides = {}
	local verticalLines = 0
	local horizontalLines = 0
	local y = boardNumbers.y

	if #problems[s.problem][1] > 5 then
		verticalLines = math.floor(#problems[s.problem][1] / 5)
	end

	if #problems[s.problem] > 5 then
		horizontalLines = math.floor(#problems[s.problem] / 5)
	end

	for i = 1, verticalLines do
		local x1 = boardNumbers.x + 5 * s.cellSize
		local y1 = boardNumbers.y
		local y2 = boardNumbers.y + (#problems[s.problem] * s.cellSize)
		x1 = x1 + (5 * s.cellSize * (i - 1))
		local test1 = {x1,y1,x1,y2}
		table.insert(guides, function () return love.graphics.line(test1) end)
	end

	for i = 1, horizontalLines do
		local x1 = boardNumbers.x
		local y1 = boardNumbers.y + 5 * s.cellSize
		local x2 = boardNumbers.x + (#problems[s.problem][1] * s.cellSize)
		y1 = y1 + (5 * s.cellSize * (i - 1))
		local test2 = {x1,y1,x2,y1}
		table.insert(guides, function () return love.graphics.line(test2) end)
	end
end

function BoardCellsMain.clear()
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			boardCells[i][j].marked = false
			boardCells[i][j].crossed = false
			boardCells[i][j].setCell = false
			boardCells[i][j].alpha = 0
			boardCells[i][j].fade = false
		end
	end
end

local function validateLine(i, j, direction)
	local failed = false
	if direction == "r" then
		for k = 1, #boardCells[i] do
			if boardCells[i][k].marked and problems[s.problem][i][k] == 0 then
				failed = true
			end
			if boardCells[i][k].crossed and problems[s.problem][i][k] == 1 then
				failed = true
			end
			if not boardCells[i][k].marked and problems[s.problem][i][k] == 1 then
				failed = true
			end
		end
		if failed == false then return true end
	end

	if direction == "c" then
		for k = 1, #boardCells do
			if boardCells[k][j].marked and problems[s.problem][k][j] == 0 then
				failed = true
			end
			if boardCells[k][j].crossed and problems[s.problem][k][j] == 1 then
				failed = true
			end
			if not boardCells[k][j].marked and problems[s.problem][k][j] == 1 then
				failed = true
			end
		end
		if failed == false then return true end
	end
end

function BoardCellsMain:markCrossedCelsInLine(i, j, direction)
	if validateLine(i, j, direction) then
		if direction == "r" then
			for k = 1, #boardCells[i] do
				if problems[s.problem][i][k] == 0 then
					boardCells[i][k].crossed = true
					boardCells[i][k].fade = true
				end
			end
		end
		if direction == "c" then
			for k = 1, #boardCells do
				if problems[s.problem][k][j] == 0 then
					boardCells[k][j].crossed = true
					boardCells[k][j].fade = true
					-- print(boardCells[i][j].position[1], boardCells[i][j].position[2])
				end
			end
		end
	end
end

function BoardCellsMain:checkMarkedCells(maxNumber, sourceNumbers, output, problemTable, markedTable)

	local function cellReset(i, chunk, range, offset)
		range = range - offset
		output[i][chunk+range].crossed = false
		output[i][chunk+range].fade = false
		output[i][chunk+range].alpha = 0
	end

	for i = 1, #problemTable do
		local chunk = 1
		local range = maxNumber - #sourceNumbers[i]
		local chunkFails = false
		for j = 1, #problemTable[i] do
			if problemTable[i][j] == 1 and not markedTable[i][j].marked then
				cellReset(i, chunk, range, 0)
				chunkFails = true
			end

			if problemTable[i][j] == 0 and markedTable[i][j].marked and problemTable[i][j+1] == 1 then
				cellReset(i, chunk, range, 0)
				chunkFails = true
			end

			if problemTable[i][j] == 0 and markedTable[i][j].marked and problemTable[i][j-1] == 1 then
				cellReset(i, chunk, range, 1)
				chunkFails = true
			end

			if problemTable[i][j] == 1 and (problemTable[i][j+1] == 0 or j == #markedTable[i]) then
				if not chunkFails then
					output[i][chunk+range].crossed = true
					output[i][chunk+range].fade = true
				end
				chunk = chunk + 1
			end
		end
	end
end

function BoardCellsMain.validateCells()
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
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 0, position = {i, j}})
			boardCells[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end
end

function BoardCellsMain:draw()
	love.graphics.setColor(1,1,1)
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			boardCells[i][j]:draw()
		end
	end
	for i = 1, #guides do
		guides[i]()
	end
end

function BoardCellsMain:update(dt)
	local x, y = love.mouse.getPosition()
	for i = 1, #boardCells do
		for j = 1, #boardCells[i]do
			boardCells[i][j]:update(dt)
			if love.mouse.isDown("1") then
				self:markCrossedCelsInLine(i, j, "r")
				self:markCrossedCelsInLine(i, j, "c")
				if boardCells[i][j]:containsPoint(x,y) then
					self:checkMarkedCells(boardNumbers.maxNumbersRow, boardNumbers.resultRow, boardCellsLeft.numberCellsLeft, boardNumbers.matrix_o, boardCells)
					self:checkMarkedCells(boardNumbers.maxNumbersColumn, boardNumbers.resultColumn, boardCellsTop.numberCellsTop, boardNumbers.matrix_t, boardCells_t)
				end
			end
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