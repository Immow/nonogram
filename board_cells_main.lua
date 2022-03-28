local s            = require("settings")
local cell         = require("cell")
local problems     = require("problems")
local boardCellsLeft = require("board_cells_left")
local boardCellsTop = require("board_cells_top")
local boardDimensions = require("board_dimensions")
local lib = require("lib")
local colors = require("colors")
local clickedOnBoard = false
local mouseX, mouseY = 0, 0

local BoardCellsMain = {}
local guides = {}
local arrow = {}

BoardCellsMain.boardCells = nil
BoardCellsMain.x   = nil
BoardCellsMain.y   = nil
BoardCellsMain.mistakes = {}
BoardCellsMain.winningState = nil

function BoardCellsMain:load()
	self:generateBoardCells(#problems[s.problem][1], #problems[s.problem])
	lib.loadSaveState(BoardCellsMain.boardCells)

	self.generateGridGuides()
	self.winningState = false
	arrow = {offset = 30, barLength = 60, arrowSize = 14}
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

function BoardCellsMain:isWithinBounds(x, y, grid)
	return x <= #grid[1] and y <= #grid and
		x >= 1 and y >= 1
end

function BoardCellsMain:lockCells(x, y, dx, dy)
	while self:isWithinBounds(x, y, self.boardCells) do
		local currentCell = self.boardCells[y][x]
		currentCell:lockCell()
		x = x + dx * -1
		y = y + dy * -1
	end
end

function BoardCellsMain:validateLine(x, y, dx, dy)
	while self:isWithinBounds(x, y, self.boardCells) do
		local wrong1 = self.boardCells[y][x].state == "marked" and problems[s.problem][y][x] == 0
		local wrong2 = self.boardCells[y][x].state == "crossed" and problems[s.problem][y][x] == 1
		local wrong3 = self.boardCells[y][x].state == "empty" and problems[s.problem][y][x] == 1
		if wrong1 or wrong2 or wrong3 then
			return false
		end
		x = x + dx
		y = y + dy
	end
	return true
end

function BoardCellsMain:crossNumbers(x, y, dx, dy, chunkCount)
	if dx ~= 0 then
		local grid, size = boardCellsLeft.numberCellsLeft, boardDimensions.resultLeft
		if dx > 0 then
			local length = #size[y]
			local currentCell = grid[y][length - chunkCount]
			currentCell:crossCell()
		else
			local length = 1
			local currentCell = grid[y][length + chunkCount]
			currentCell:crossCell()
		end
	else
		local grid, size = boardCellsTop.numberCellsTop, boardDimensions.resultTop
		if dy > 0 then
			local length = #size[x]
			local currentCell = grid[x][length - chunkCount]
			currentCell:crossCell()
		else
			local length = 1
			local currentCell = grid[x][length + chunkCount]
			currentCell:crossCell()
		end
	end
end

function BoardCellsMain.onBoard(x, y)
	local board_x = boardDimensions.mainX
	local board_width = board_x + boardDimensions.mainWidth
	local board_y = boardDimensions.mainY
	local board_height = board_y + boardDimensions.mainHeight
	return x >= board_x and x <= board_width and y >= board_y and y <= board_height
end

function BoardCellsMain:markChunks(x, y, dx, dy)
	local lastVisitedCell = {}
	local chunkCount = 0

	while self:isWithinBounds(x, y, self.boardCells) do
		local crossedCell = self.boardCells[y][x].state == "crossed" and problems[s.problem][y][x] == 0
		local markedCell = self.boardCells[y][x].state == "marked" and problems[s.problem][y][x] == 1

		if not (crossedCell or markedCell) then break end
		
		local nextChunk = lastVisitedCell.state == "marked" and problems[s.problem][y][x] == 0

		if nextChunk and crossedCell then
			self:lockCells(x, y, dx, dy)
			self:crossNumbers(x, y, dx, dy, chunkCount)
			chunkCount = chunkCount + 1
		end
		lastVisitedCell = self.boardCells[y][x]

		x = x + dx
		y = y + dy
	end
end

function BoardCellsMain:markChunksInLine(x, y, dx, dy)
	while self:isWithinBounds(x, y, self.boardCells) do
		local currentCell = self.boardCells[y][x]
		if currentCell.state == "empty" then
			currentCell:crossCell()
		else
			currentCell:lockCell()
		end
		x = x + dx
		y = y + dy
	end
end

function BoardCellsMain:crossCellsInLine(i, dx, dy)
	if dx ~= 0 then
		local left = boardCellsLeft.numberCellsLeft
		for j = 1, #left[i] do
			if not left[i][j].locked then
				left[i][j]:crossCell()
			end
		end
	end

	if dy ~= 0 then
		local top = boardCellsTop.numberCellsTop
		for j = 1, #top[i] do
			if not top[i][j].locked then
				top[i][j]:crossCell()
			end
		end
	end
end

function BoardCellsMain:markAllTheThings()
	local width = #self.boardCells[1]
	local height = #self.boardCells
	for i = 1, #self.boardCells do
		if BoardCellsMain:validateLine(1, i, 1, 0) then
			self:markChunksInLine(1, i, 1, 0)
			self:crossCellsInLine(i, 1, 0)
		end
		BoardCellsMain:markChunks(1, i, 1, 0) -- left to right
		BoardCellsMain:markChunks(width, i, -1, 0) -- right to left
	end
	for i = 1, #self.boardCells[1] do
		if BoardCellsMain:validateLine(i, 1, 0, 1) then
			self:markChunksInLine(i, 1, 0, 1)
			self:crossCellsInLine(i, 0, 1)
		end
		BoardCellsMain:markChunks(i, 1, 0, 1) -- top to bottom
		BoardCellsMain:markChunks(i, height, 0, -1) -- bottom to top
	end
end

function BoardCellsMain.validateCells()
	BoardCellsMain.mistakes = {}
	for i = 1, #BoardCellsMain.boardCells do
		for j = 1, #BoardCellsMain.boardCells[i] do
			if BoardCellsMain.boardCells[i][j].state == "marked" and problems[s.problem][i][j] == 0 then
				table.insert(BoardCellsMain.mistakes, {BoardCellsMain.boardCells[i][j].position})
				BoardCellsMain.boardCells[i][j].wrong = true
			end
			if BoardCellsMain.boardCells[i][j].state == "crossed" and problems[s.problem][i][j] == 1 then
				table.insert(BoardCellsMain.mistakes, {BoardCellsMain.boardCells[i][j].position})
				BoardCellsMain.boardCells[i][j].wrong = true
			end
		end
	end
	return BoardCellsMain.mistakes
end

function BoardCellsMain:isTheProblemSolved()
	self.winningState = true
	for i = 1, #self.boardCells do
		for j = 1, #self.boardCells[i] do
			if problems[s.problem][i][j] == 1 and (self.boardCells[i][j].state == "empty" or self.boardCells[i][j].state == "crossed") then
				self.winningState = false
				return self.winningState
			end

			if problems[s.problem][i][j] == 0 and self.boardCells[i][j].state == "marked" then
				self.winningState = false
				return self.winningState
			end
		end
	end
	return self.winningState
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

local clickedCell = "empty"
local cellPosition = {}
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
	self:drawNumberCount()
end

function BoardCellsMain:drawNumberCount()
	if cellPosition.position then
		local a, b = BoardCellsMain.countTotalNumbers(cellPosition.position[1], cellPosition.position[2])
		love.graphics.setColor(1,0,0)
		lib:OscilatingArrowLeft(mouseX - arrow.barLength, mouseY, arrow.barLength,arrow.arrowSize,4,0,0).draw()
		lib:OscilatingArrowUp(mouseX - arrow.arrowSize / 2, mouseY - arrow.barLength + 7,arrow.barLength,arrow.arrowSize,4,0,0).draw()
		love.graphics.setColor(1,1,1,0.3)
		love.graphics.rectangle("fill", mouseX - arrow.offset, mouseY + arrow.arrowSize / 2 - ArrowNumber:getHeight() /2, ArrowNumber:getWidth(a),ArrowNumber:getHeight())
		love.graphics.rectangle("fill", mouseX + arrow.arrowSize / 2 - ArrowNumber:getWidth(b) / 2 - arrow.arrowSize / 2, mouseY - arrow.offset, ArrowNumber:getWidth(b), ArrowNumber:getHeight())
		love.graphics.setColor(1,1,1)
		love.graphics.setFont(ArrowNumber)
		love.graphics.print(a, mouseX - arrow.offset, mouseY + arrow.arrowSize / 2 - ArrowNumber:getHeight() /2)
		love.graphics.print(b, mouseX + arrow.arrowSize / 2 - ArrowNumber:getWidth(b) / 2 - arrow.arrowSize / 2, mouseY - arrow.offset)
		love.graphics.setFont(Default)
	end
end

function BoardCellsMain:update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	for i = 1, #self.boardCells do
		for j = 1, #self.boardCells[i] do
			self.boardCells[i][j]:update(dt, clickedCell)
			if self.onBoard(mouseX, mouseY) then
				if love.keyboard.isDown("lctrl", "rctrl") then
					if self.boardCells[i][j]:containsPoint(mouseX, mouseY) then
						cellPosition = {position = self.boardCells[i][j].position}
					end
				end
			end
		end
	end
end

function BoardCellsMain:unsetCels()
	for i = 1, #self.boardCells do
		for j = 1, #self.boardCells[i] do
			self.boardCells[i][j].setCell = false
		end
	end
end

function BoardCellsMain.countTotalNumbers(x, y)
	local countLeft = 0
	local countTop = 0
	for i = 1, #boardDimensions.resultLeft[x] do
		if boardCellsLeft.numberCellsLeft[x][i].state == "empty" then
			countLeft = countLeft + boardDimensions.resultLeft[x][i]
		end
	end

	for i = 1, #boardDimensions.resultTop[y] do
		if boardCellsTop.numberCellsTop[y][i].state == "empty" then
			countTop = countTop + boardDimensions.resultTop[y][i]
		end
	end
	return countLeft, countTop
end

function BoardCellsMain:keyreleased(key,scancode)
	if key == "lctrl" or "rctrl" then
		cellPosition = {}
	end
end

function BoardCellsMain:mousepressed(x,y,button,istouch,presses)
	if self.onBoard(x, y) then
		for i = 1, #self.boardCells do
			for j = 1, #self.boardCells[i] do
				if self.boardCells[i][j]:containsPoint(x, y) then
					if self.boardCells[i][j].state == "empty" then
						clickedCell = "empty"
					elseif self.boardCells[i][j].state == "marked" then
						clickedCell = "marked"
					else
						clickedCell = "crossed"
					end
				end
			end
		end
		clickedOnBoard = true
	else
		clickedOnBoard = false
	end
end

function BoardCellsMain:mousereleased(x,y,button,istouch,presses)
	if clickedOnBoard then
		self:unsetCels()
		self:isTheProblemSolved()
		self:markAllTheThings()
		love.filesystem.write(s.problem.."-main.dat", TSerial.pack(self.boardCells, drop, true))
	end
end

return BoardCellsMain