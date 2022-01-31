local s            = require("settings")
local cell         = require("cell")
local problems     = require("problems")
local boardCellsLeft = require("board_cells_left")
local boardCellsTop = require("board_cells_top")
local lib           = require("lib")
local boardDimensions = require("board_dimensions")

local BoardCellsMain = {}

local guides = {}

local boardCells   = nil
local boardCells_t = nil
BoardCellsMain.x   = nil
BoardCellsMain.y   = nil

function BoardCellsMain:load()
	self:generateBoardCells(#problems[s.problem][1], #problems[s.problem])
	boardCells_t = lib.Transpose(boardCells)
	self.generateGridGuides()
end

function BoardCellsMain.generateGridGuides()
	guides = {}
	local verticalLines = 0
	local horizontalLines = 0

	if #problems[s.problem][1] > 5 then
		verticalLines = math.floor(#problems[s.problem][1] / 5)
	end

	if #problems[s.problem] > 5 then
		horizontalLines = math.floor(#problems[s.problem] / 5)
	end

	for i = 1, verticalLines do
		local x1 = boardDimensions.mainX + 5 * s.cellSize
		local y1 = boardDimensions.mainY
		local y2 = boardDimensions.mainY + (#problems[s.problem] * s.cellSize)
		x1 = x1 + (5 * s.cellSize * (i - 1))
		local verticalLine = {x1,y1,x1,y2}
		table.insert(guides, function () return love.graphics.line(verticalLine) end)
	end

	for i = 1, horizontalLines do
		local x1 = boardDimensions.mainX
		local y1 = boardDimensions.mainY + 5 * s.cellSize
		local x2 = boardDimensions.mainX + (#problems[s.problem][1] * s.cellSize)
		y1 = y1 + (5 * s.cellSize * (i - 1))
		local horizontalLine = {x1,y1,x2,y1}
		table.insert(guides, function () return love.graphics.line(horizontalLine) end)
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
	if direction == "horizontal" then
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

	if direction == "vertical" then
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
		if direction == "horizontal" then
			for k = 1, #boardCells[i] do
				if problems[s.problem][i][k] == 0 then
					boardCells[i][k].crossed = true
					boardCells[i][k].fade = true
				end
			end

			local offsetX = boardDimensions.maxNumbersLeft - #boardDimensions.resultLeft[i]
			for k = 1, #boardDimensions.resultLeft[i] do
				boardCellsLeft.numberCellsLeft[i][k+offsetX].crossed = true
				boardCellsLeft.numberCellsLeft[i][k+offsetX].fade = true
			end
		end

		if direction == "vertical" then
			for k = 1, #boardCells do
				if problems[s.problem][k][j] == 0 then
					boardCells[k][j].crossed = true
					boardCells[k][j].fade = true
				end
			end

			local offsetY = boardDimensions.maxNumbersTop - #boardDimensions.resultTop[j]
			for k = 1, #boardDimensions.resultTop[j] do
				boardCellsTop.numberCellsTop[j][k+offsetY].crossed = true
				boardCellsTop.numberCellsTop[j][k+offsetY].fade = true
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
	self.x = boardDimensions.mainX
	self.y = boardDimensions.mainY
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
				if boardCells[i][j]:containsPoint(x,y) then
					self:markCrossedCelsInLine(i, j, "horizontal")
					self:markCrossedCelsInLine(i, j, "vertical")
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