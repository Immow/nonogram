local cell              = require("constructors.cell")
local problems          = require("problems")
local boardLeft         = require("state.game.board_left")
local boardTop          = require("state.game.board_top")
local boardDimensions   = require("state.game.board_dimensions")

local mouseX, mouseY = 0, 0

local BoardMain = {}
local guides = {}
local arrow = {}
local cellPosition = {}
local clickedCell = nil

BoardMain.cells = nil
BoardMain.x   = nil
BoardMain.y   = nil
BoardMain.mistakes = {}

function BoardMain:load()
	self:generateBoardCells(#problems[Settings.problemNr][1], #problems[Settings.problemNr])
	Lib.loadSaveState(self.cells, "main")

	self.generateGridGuides()
	arrow = {offset = 30, barLength = 60, arrowSize = 14}
end

function BoardMain.generateGridGuides()
	guides = {}
	local verticalLines = 0
	local horizontalLines = 0

	if #problems[Settings.problemNr][1] > 5 then
		if #problems[Settings.problemNr][1] / 5 ==  math.floor(#problems[Settings.problemNr][1] / 5) then
			verticalLines =  #problems[Settings.problemNr][1] / 5 - 1
		else
			verticalLines = math.floor(#problems[Settings.problemNr][1] / 5)
		end
	end

	if #problems[Settings.problemNr] > 5 then
		if #problems[Settings.problemNr] / 5 == math.floor(#problems[Settings.problemNr] / 5) then
			horizontalLines = #problems[Settings.problemNr] / 5 - 1
		else
			horizontalLines = math.floor(#problems[Settings.problemNr] / 5)
		end
	end

	for i = 1, verticalLines do
		local x1 = boardDimensions.mainX + 5 * Settings.cellSize
		local y1 = boardDimensions.mainY
		local y2 = boardDimensions.mainY + (#problems[Settings.problemNr] * Settings.cellSize)
		x1 = x1 + (5 * Settings.cellSize * (i - 1))
		local verticalLine = {x1,y1,x1,y2}
		table.insert(guides, function () return love.graphics.line(verticalLine) end)
	end

	for i = 1, horizontalLines do
		local x1 = boardDimensions.mainX
		local y1 = boardDimensions.mainY + 5 * Settings.cellSize
		local x2 = boardDimensions.mainX + (#problems[Settings.problemNr][1] * Settings.cellSize)
		y1 = y1 + (5 * Settings.cellSize * (i - 1))
		local horizontalLine = {x1,y1,x2,y1}
		table.insert(guides, function () return love.graphics.line(horizontalLine) end)
	end
end

function BoardMain:isWithinBounds(x, y, grid)
	return x <= #grid[1] and y <= #grid and
		x >= 1 and y >= 1
end

local canPlaySound = true

local function playSolveSound()
	if canPlaySound then
		Sound:play("beep", "beep", Settings.sfxVolume, 1)
		canPlaySound = false
		Timer.new(1, function () canPlaySound = true end)
	end
end

function BoardMain:lockCells(x, y, dx, dy)
	while self:isWithinBounds(x, y, self.cells) do
		local currentCell = self.cells[y][x]
		currentCell:lockCell()
		x = x + dx * -1
		y = y + dy * -1
	end
end

function BoardMain:validateLine(x, y, dx, dy)
	while self:isWithinBounds(x, y, self.cells) do
		local wrong1 = self.cells[y][x].state == "marked" and problems[Settings.problemNr][y][x] == 0
		local wrong2 = self.cells[y][x].state == "crossed" and problems[Settings.problemNr][y][x] == 1
		local wrong3 = self.cells[y][x].state == "empty" and problems[Settings.problemNr][y][x] == 1
		if wrong1 or wrong2 or wrong3 then
			return false
		end
		x = x + dx
		y = y + dy
	end
	return true
end

function BoardMain:crossNumbers(x, y, dx, dy, chunkCount)
	if dx ~= 0 then
		local grid, size = boardLeft.cells, boardDimensions.resultLeft
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
		local grid, size = boardTop.cells, boardDimensions.resultTop
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

function BoardMain:markChunks(x, y, dx, dy)
	local lastVisitedCell = {}
	local chunkCount = 0

	while self:isWithinBounds(x, y, self.cells) do
		local crossedCell = self.cells[y][x].state == "crossed" and problems[Settings.problemNr][y][x] == 0
		local markedCell = self.cells[y][x].state == "marked" and problems[Settings.problemNr][y][x] == 1

		if not (crossedCell or markedCell) then break end
		
		local nextChunk = lastVisitedCell.state == "marked" and problems[Settings.problemNr][y][x] == 0

		if nextChunk and crossedCell then
			-- if not self.cells[y][x].locked then
			-- 	playSolveSound()
			-- end
			self:lockCells(x, y, dx, dy)
			self:crossNumbers(x, y, dx, dy, chunkCount)
			chunkCount = chunkCount + 1
		end
		lastVisitedCell = self.cells[y][x]

		x = x + dx
		y = y + dy
	end
end

function BoardMain:markChunksInLine(x, y, dx, dy)
	while self:isWithinBounds(x, y, self.cells) do
		local currentCell = self.cells[y][x]
		if currentCell.state == "empty" then
			currentCell:crossCell()
		else
			currentCell:lockCell()
		end
		x = x + dx
		y = y + dy
	end
end

function BoardMain:crossCellsInLine(i, dx, dy)
	if dx ~= 0 then
		local left = boardLeft.cells
		for j = 1, #left[i] do
			if not left[i][j].locked then
				left[i][j]:crossCell()
			end
		end
	end

	if dy ~= 0 then
		local top = boardTop.cells
		for j = 1, #top[i] do
			if not top[i][j].locked then
				top[i][j]:crossCell()
			end
		end
	end
end

function BoardMain:markAllTheThings()
	if not Settings.markAndCross then return end
	local width = #self.cells[1]
	local height = #self.cells
	for i = 1, #self.cells do
		if BoardMain:validateLine(1, i, 1, 0) then
			self:markChunksInLine(1, i, 1, 0)
			self:crossCellsInLine(i, 1, 0)
		end
		BoardMain:markChunks(1, i, 1, 0) -- left to right
		BoardMain:markChunks(width, i, -1, 0) -- right to left
	end
	for i = 1, #self.cells[1] do
		if BoardMain:validateLine(i, 1, 0, 1) then
			self:markChunksInLine(i, 1, 0, 1)
			self:crossCellsInLine(i, 0, 1)
		end
		BoardMain:markChunks(i, 1, 0, 1) -- top to bottom
		BoardMain:markChunks(i, height, 0, -1) -- bottom to top
	end
end

function BoardMain.validateCells()
	if not Settings.validation then return end
	BoardMain.mistakes = {}
	for i = 1, #BoardMain.cells do
		for j = 1, #BoardMain.cells[i] do
			if BoardMain.cells[i][j].state == "marked" and problems[Settings.problemNr][i][j] == 0 then
				table.insert(BoardMain.mistakes, {BoardMain.cells[i][j].position})
				BoardMain.cells[i][j].wrong = true
			end
			if BoardMain.cells[i][j].state == "crossed" and problems[Settings.problemNr][i][j] == 1 then
				table.insert(BoardMain.mistakes, {BoardMain.cells[i][j].position})
				BoardMain.cells[i][j].wrong = true
			end
		end
	end
	return BoardMain.mistakes
end

function BoardMain:isTheProblemSolved()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			if problems[Settings.problemNr][i][j] == 1 and
				(self.cells[i][j].state == "empty" or self.cells[i][j].state == "crossed") then
				Settings.game.state[Settings.problemNr] = "pending"
				return false
			end
			
			if problems[Settings.problemNr][i][j] == 0 and self.cells[i][j].state == "marked" then
				Settings.game.state[Settings.problemNr] = "pending"
				return false
			end
		end
	end
	Settings.game.state[Settings.problemNr] = "solved"
	return true
end

function BoardMain:generateBoardCells(r, c)
	self.cells = {}
	self.x = boardDimensions.mainX
	self.y = boardDimensions.mainY
	for i = 1, c do
		self.cells[i] = {}
		for j = 1, r do
			local x = self.x + Settings.cellSize * (j - 1)
			local newCell = cell.new({x = x, y = self.y, width = Settings.cellSize, height = Settings.cellSize, id = 0, position = {y = i, x = j}})
			self.cells[i][j] = newCell
		end
		self.y = self.y + Settings.cellSize
	end
end

function BoardMain.drawGuides()
		for i = 1, #guides do
		love.graphics.setColor(Colors.white)
		love.graphics.setColor(Colors.setColorAndAlpha({color = Colors.gray[500]}))
		guides[i]()
	end
end

function BoardMain:drawBorder()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw("empty")
		end
	end
end

function BoardMain:drawCross()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw("crossed")
		end
	end
end

function BoardMain:drawMarked()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:draw("marked")
		end
	end
end

function BoardMain:draw()
	self:drawMarked()
	self:drawBorder()
	self:drawCross()
	self.drawGuides()
	self:drawNumberCount()
end

function BoardMain:drawNumberCount()
	if cellPosition.position then
		local a, b = BoardMain.countTotalNumbers(cellPosition.position.y, cellPosition.position.x)
		love.graphics.setColor(1,0,0)
		Lib.OscilatingArrowLeft(mouseX - arrow.barLength, mouseY, arrow.barLength,arrow.arrowSize,4,0,0).draw()
		Lib.OscilatingArrowUp(mouseX - arrow.arrowSize / 2, mouseY - arrow.barLength + 7,arrow.barLength,arrow.arrowSize,4,0,0).draw()
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

function BoardMain:update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j]:update(dt, clickedCell)
			if Lib.onBoard(
				mouseX,
				mouseY,
				boardDimensions.mainX,
				boardDimensions.mainY,
				boardDimensions.mainWidth + boardDimensions.mainX,
				boardDimensions.mainHeight + boardDimensions.mainY
				)
			then
				if love.keyboard.isDown("lctrl", "rctrl") then
					if self.cells[i][j]:containsPoint(mouseX, mouseY) then
						cellPosition = {position = self.cells[i][j].position}
					end
				end
			end
		end
	end
end

function BoardMain:unsetCels()
	for i = 1, #self.cells do
		for j = 1, #self.cells[i] do
			self.cells[i][j].setCell = false
		end
	end
end

function BoardMain.countTotalNumbers(x, y)
	local countLeft = 0
	local countTop = 0
	for i = 1, #boardDimensions.resultLeft[x] do
		if boardLeft.cells[x][i].state == "empty" then
			countLeft = countLeft + boardDimensions.resultLeft[x][i]
		end
	end

	for i = 1, #boardDimensions.resultTop[y] do
		if boardTop.cells[y][i].state == "empty" then
			countTop = countTop + boardDimensions.resultTop[y][i]
		end
	end
	return countLeft, countTop
end

function BoardMain:keyreleased(key,scancode)
	if key == "lctrl" or "rctrl" then
		cellPosition = {}
	end
end

function BoardMain:mousepressed(x,y,button,istouch,presses)
	if Lib.onBoard(
		x,
		y,
		boardDimensions.mainX,
		boardDimensions.mainY,
		boardDimensions.mainWidth + boardDimensions.mainX,
		boardDimensions.mainHeight + boardDimensions.mainY
		)
	then
		for i = 1, #self.cells do
			for j = 1, #self.cells[i] do
				if self.cells[i][j]:containsPoint(x, y) then
					if self.cells[i][j].state == "empty" then
						clickedCell = "empty"
					elseif self.cells[i][j].state == "marked" then
						clickedCell = "marked"
					else
						clickedCell = "crossed"
					end
				end
			end
		end
	end
end

function BoardMain:mousereleased(x,y,button,istouch,presses)
	self:unsetCels()
	self:isTheProblemSolved()
	self:markAllTheThings()
end

return BoardMain