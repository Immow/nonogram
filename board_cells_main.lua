local s            = require("settings")
local cell         = require("cell")
local problems     = require("problems")
local boardCellsLeft = require("board_cells_left")
local boardCellsTop = require("board_cells_top")
local boardDimensions = require("board_dimensions")
local colors = require("colors")

local BoardCellsMain = {}

local guides = {}

BoardCellsMain.boardCells = nil
BoardCellsMain.x   = nil
BoardCellsMain.y   = nil
BoardCellsMain.mistakes = nil

function BoardCellsMain:load()
	self:generateBoardCells(#problems[s.problem][1], #problems[s.problem])
	self.generateGridGuides()
end

function BoardCellsMain.generateGridGuides()
	guides = {}
	local verticalLines = 0
	local horizontalLines = 0

	if #problems[s.problem][1] > 5 then
		if #problems[s.problem][1] / 5 ==  math.floor(#problems[s.problem][1] / 5) then
			verticalLines =  #problems[s.problem][1] / 5 - 1
		else
			verticalLines = math.floor(#problems[s.problem][1] / 5)
		end
	end

	if #problems[s.problem] > 5 then
		if #problems[s.problem] / 5 == math.floor(#problems[s.problem] / 5) then
			horizontalLines = #problems[s.problem] / 5 - 1
		else
			horizontalLines = math.floor(#problems[s.problem] / 5)
		end
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

function BoardCellsMain:validateLine(i, j, direction)
	local failed = false
	if direction == "horizontal" then
		for k = 1, #self.boardCells[i] do
			if self.boardCells[i][k].marked and problems[s.problem][i][k] == 0 then
				failed = true
			end
			if self.boardCells[i][k].crossed and problems[s.problem][i][k] == 1 then
				failed = true
			end
			if not self.boardCells[i][k].marked and problems[s.problem][i][k] == 1 then
				failed = true
			end
		end
		if failed == false then return true end
	end

	if direction == "vertical" then
		for k = 1, #self.boardCells do
			if self.boardCells[k][j].marked and problems[s.problem][k][j] == 0 then
				failed = true
			end
			if self.boardCells[k][j].crossed and problems[s.problem][k][j] == 1 then
				failed = true
			end
			if not self.boardCells[k][j].marked and problems[s.problem][k][j] == 1 then
				failed = true
			end
		end

		if failed == false then return true end
	end
end

function BoardCellsMain:markCrossedCelsInLine(i, j, direction)
	if self:validateLine(i, j, direction) then
		if direction == "horizontal" then
			for k = 1, #self.boardCells[i] do
				if problems[s.problem][i][k] == 0 then
					self.boardCells[i][k].crossed = true
					self.boardCells[i][k].fade = true
					self.boardCells[i][k].locked = true
				else
					self.boardCells[i][k].locked = true
				end
			end

			for k = 1, #boardDimensions.resultLeft[i] do
				if boardDimensions.resultLeft[i].id ~= 4 then
					boardCellsLeft.numberCellsLeft[i][k].crossed = true
					boardCellsLeft.numberCellsLeft[i][k].fade = true
					boardCellsLeft.numberCellsLeft[i][k].locked = true
				end
			end
		end

		if direction == "vertical" then
			for k = 1, #self.boardCells do
				if problems[s.problem][k][j] == 0 then
					self.boardCells[k][j].crossed = true
					self.boardCells[k][j].fade = true
					self.boardCells[k][j].locked = true
				else
					self.boardCells[k][j].locked = true
				end
			end

			for k = 1, #boardDimensions.resultTop[j] do
				if boardDimensions.resultTop[j].id ~= 4 then
					boardCellsTop.numberCellsTop[j][k].crossed = true
					boardCellsTop.numberCellsTop[j][k].fade = true
					boardCellsTop.numberCellsTop[j][k].locked = true
				end
			end
		end
	end
end

function BoardCellsMain.validateCells()
	BoardCellsMain.mistakes = {}
	for i = 1, #BoardCellsMain.boardCells do
		for j = 1, #BoardCellsMain.boardCells[i] do
			if BoardCellsMain.boardCells[i][j].marked and problems[s.problem][i][j] == 0 then
				table.insert(BoardCellsMain.mistakes, {BoardCellsMain.boardCells[i][j].position})
				BoardCellsMain.boardCells[i][j].wrong = true
			end
			if BoardCellsMain.boardCells[i][j].crossed and problems[s.problem][i][j] == 1 then
				table.insert(BoardCellsMain.mistakes, {BoardCellsMain.boardCells[i][j].position})
				BoardCellsMain.boardCells[i][j].wrong = true
			end
		end
	end
	return BoardCellsMain.mistakes
end

function BoardCellsMain:generateBoardCells(r, c)
	self.boardCells = {}
	self.x = boardDimensions.mainX
	self.y = boardDimensions.mainY
	for i = 1, c do
		self.boardCells[i] = {}
		for j = 1, r do
			local x = self.x + s.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = s.cellSize, height = s.cellSize, id = 0, position = {i, j}})
			self.boardCells[i][j] = newCell
		end
		self.y = self.y + s.cellSize
	end
end

function BoardCellsMain:draw()
	for i = 1, #self.boardCells do
		for j = 1, #self.boardCells[i] do
			self.boardCells[i][j]:draw()
		end
	end
	for i = 1, #guides do
		love.graphics.setColor(colors.white)
		love.graphics.setColor(colors.setColorAndAlpha({color = colors.gray[500]}))
		guides[i]()
	end
end

function BoardCellsMain:update(dt)
	local x, y = love.mouse.getPosition()
	for i = 1, #self.boardCells do
		for j = 1, #self.boardCells[i]do
			self.boardCells[i][j]:update(dt)
			if love.mouse.isDown("1") then
				if self.boardCells[i][j]:containsPoint(x,y) then
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
	for i = 1, #self.boardCells do
		for j = 1, #self.boardCells[i] do
			self.boardCells[i][j].setCell = false
		end
	end
end

return BoardCellsMain