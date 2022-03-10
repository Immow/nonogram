local s               = require("settings")
local problems        = require("problems")
local boardNumbers    = require("board_numbers")
local boardCellsMain  = require("board_cells_main")
local boardCellsTop   = require("board_cells_top")
local boardCellsLeft  = require("board_cells_left")
local boardDimensions = require("board_dimensions")
local lib             = require("lib")

local Solver = {}
Solver.results = {}
Solver.activeCell = {x = 0, y = 0}
Solver.direction = ""
Solver.speed = 0.5
Solver.timer = Solver.speed

local run = false

function Solver:setCoordinates(x, y)
	self.activeCell.x = boardCellsMain.boardCells[x][y].position[1]
	self.activeCell.y = boardCellsMain.boardCells[x][y].position[2]
end

function Solver:markCellsFase1(count, i, dir)
	local index = nil
	local difference = nil
	local board = nil
	local chunkIndex = 1
	local length = nil
	if dir == "horizontal" then
		print("Solving row: "..i)
		length = #boardCellsMain.boardCells[i]
		board = boardDimensions.resultLeft
		index = #board[i]
		difference = #problems[s.problem][1] - count
	else
		print("Solving column: "..i)
		length = #boardCellsMain.boardCells
		board = boardDimensions.resultTop
		index = #board[i]
		difference = #problems[s.problem] - count
	end
	if difference == 0 then
		local number = board[i][index] -- select the left most number
		for j = 1, length do
			if chunkIndex <= number and dir == "horizontal" then
				boardCellsMain.boardCells[i][j]:markCellSolver()
			elseif chunkIndex <= number and dir == "vertical" then
				boardCellsMain.boardCells[j][i]:markCellSolver()
			end
			
			if chunkIndex > number then
				index = index - 1
				number = board[i][index]
				chunkIndex = 1
				if dir == "horizontal" then
					boardCellsMain.boardCells[i][j]:crossCell()
					print("marking Row")
				else
					boardCellsMain.boardCells[j][i]:crossCell()
					print("marking Column")
				end
			else
				chunkIndex = chunkIndex + 1
			end
		end
	else
		local number = board[i][index] -- select the left most number
		for j = 1, length do
			if chunkIndex > difference and number - chunkIndex >= 0 and number > difference and dir == "horizontal" then
				print("itteration: "..j.." marking cell: "..boardCellsMain.boardCells[i][j].position[1]..", "..boardCellsMain.boardCells[i][j].position[2])
				boardCellsMain.boardCells[i][j]:markCellSolver()
			elseif chunkIndex > difference and number - chunkIndex >= 0 and number > difference and dir == "vertical" then
				print("itteration: "..i.." marking cell: "..boardCellsMain.boardCells[j][i].position[2]..", "..boardCellsMain.boardCells[j][i].position[1])
				boardCellsMain.boardCells[j][i]:markCellSolver()
			end

			if chunkIndex > number + 1 and index > 1 then
				index = index - 1
				number = board[i][index]
				chunkIndex = 1
			end
			chunkIndex = chunkIndex + 1
		end
	end
end

function Solver.countNumbers()
	local count = 0
	for i = 1, #boardDimensions.resultLeft do
		for j = 1, #boardDimensions.resultLeft[i] do
			if boardDimensions.resultLeft[i][j] then
				count = count + boardDimensions.resultLeft[i][j]
				if j > 1 then count = count + 1 end
			end
		end
		Solver:markCellsFase1(count, i, "horizontal")
		count = 0
	end

	for i = 1, #boardDimensions.resultTop do
		for j = 1, #boardDimensions.resultTop[i] do
			if boardDimensions.resultTop[i][j] then
				count = count + boardDimensions.resultTop[i][j]
				if j > 1 then count = count + 1 end
			end
		end
		Solver:markCellsFase1(count, i, "vertical")
		count = 0
	end
end

function Solver.setNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	if dx == 1 then
		indexOfActiveNumber = indexOfActiveNumber - 1
		chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber]
	end

	if dx == -1 then
		indexOfActiveNumber = indexOfActiveNumber + 1
		chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber]
	end

	if dy == 1 then
		indexOfActiveNumber = indexOfActiveNumber - 1
		chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber]
	end

	if dy == -1 then
		indexOfActiveNumber = indexOfActiveNumber + 1
		chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber]
	end
	return indexOfActiveNumber, chunkNumber
end

function Solver.markChunksInLine(x, y, dx, dy)
	local indexOfActiveNumber
	local chunkNumber
	local previousCell = {}
	local direction
	previousCell.marked = false
	if dx ~= 0 then
		if dx == 1 then
			Solver.direction = "Left to Right"
			direction = dx
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			direction = math.abs(dx)
			indexOfActiveNumber = 1
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			direction = dy
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			direction = math.abs(dy)
			indexOfActiveNumber = 1
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
		end
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if chunkNumber == 0 then
			if not currentCell.marked and previousCell.crossed then
				break
			end
			currentCell:crossCell()
			indexOfActiveNumber, chunkNumber = Solver.setNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
		end

		if currentCell.marked or currentCell.crossed then
			if currentCell.marked then
				chunkNumber = chunkNumber - direction
			end
		elseif previousCell.marked and chunkNumber > 0 then
			chunkNumber = chunkNumber - direction
			currentCell:markCellSolver()
		else
			break
		end
		y = y + dy
		x = x + dx
		previousCell = currentCell
		-- coroutine.yield()
	end
	boardCellsMain:markAllTheThings()
end

function Solver.markChunks()
	local width = #boardCellsMain.boardCells[1]
	local height = #boardCellsMain.boardCells
	for i = 1, #boardCellsMain.boardCells do
		Solver.markChunksInLine(1, i, 1, 0) -- left to right
		Solver.markChunksInLine(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.markChunksInLine(i, 1, 0, 1) -- top to bottom
		Solver.markChunksInLine(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.markChunksInLineWithGaps(1, i, 1, 0) -- left to right
		Solver.markChunksInLineWithGaps(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.markChunksInLineWithGaps(i, 1, 0, 1) -- top to bottom
		Solver.markChunksInLineWithGaps(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.crossIfNumberDoesntFitInChunk(1, i, 1, 0) -- left to right
		Solver.crossIfNumberDoesntFitInChunk(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.crossIfNumberDoesntFitInChunk(i, 1, 0, 1) -- top to bottom
		Solver.crossIfNumberDoesntFitInChunk(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.markIfNumberFitsExactlyInChunk(1, i, 1, 0) -- left to right
		Solver.markIfNumberFitsExactlyInChunk(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.markIfNumberFitsExactlyInChunk(i, 1, 0, 1) -- top to bottom
		Solver.markIfNumberFitsExactlyInChunk(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.crossCellBetweenChunks(1, i, 1, 0) -- left to right
		Solver.crossCellBetweenChunks(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.crossCellBetweenChunks(i, 1, 0, 1) -- top to bottom
		Solver.crossCellBetweenChunks(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.crossIfNumberFitsLoosleyInChunk(1, i, 1, 0) -- left to right
		Solver.crossIfNumberFitsLoosleyInChunk(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.crossIfNumberFitsLoosleyInChunk(i, 1, 0, 1) -- top to bottom
		Solver.crossIfNumberFitsLoosleyInChunk(i, height, 0, -1) -- bottom to top
	end
end

function Solver.markChunksInLineWithGaps(x, y, dx, dy)
	local indexOfActiveNumber
	local chunkNumber
	local previousCell = {}
	previousCell.marked = false
	local count = 0
	local switchedNumber = false
	local inNewChunk = false
	local detectedMarkedCell = false
	local chunkCell

	if dx ~= 0 then
		if dx == 1 then
			Solver.direction = "Left to Right"
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
			chunkCell = boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber]
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			indexOfActiveNumber = 1
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
			chunkCell = boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber]
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
			chunkCell = boardCellsTop.numberCellsTop[x][indexOfActiveNumber]
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			indexOfActiveNumber = 1
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
			chunkCell = boardCellsTop.numberCellsTop[x][indexOfActiveNumber]
		end
	end

	if chunkCell.crossed then
		while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
			local currentCell = boardCellsMain.boardCells[y][x]
			print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])
	
			Solver.activeCell.x = currentCell.x
			Solver.activeCell.y = currentCell.y
			
			if previousCell.marked and currentCell.crossed then
				switchedNumber = true
				indexOfActiveNumber, chunkNumber = Solver.setNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
			end

			if previousCell.crossed and switchedNumber and not currentCell.marked and not currentCell.crossed then
				inNewChunk = true
			end

			if previousCell.crossed and switchedNumber and currentCell.marked and not currentCell.crossed then
				break
			end
			
			if inNewChunk then
				count = count + 1
			end

			if inNewChunk and currentCell.marked and count <= chunkNumber then
				detectedMarkedCell = true
			end

			if detectedMarkedCell and count <= chunkNumber then
				currentCell:markCellSolver()
			end

			if inNewChunk and count > chunkNumber then
				break
			end

			y = y + dy
			x = x + dx
			previousCell = currentCell
			-- coroutine.yield()
		end
	else
		return
	end
end

function Solver.crossIfNumberDoesntFitInChunk(x, y, dx, dy) -- edge solution
	local indexOfActiveNumber
	local chunkNumber
	local foundCrossedCell
	local i = 0
	local emptyCell = 0
	local emptyCellList = {}

	if dx ~= 0 then
		if dx == 1 then
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			Solver.direction = "Left to Right"
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			indexOfActiveNumber = 1
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			indexOfActiveNumber = 1
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
		end
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		i = i + 1
		local currentCell = boardCellsMain.boardCells[y][x]
		print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if not currentCell.marked and not currentCell.crossed then
			emptyCell = emptyCell + 1
			table.insert(emptyCellList, currentCell)
		end

		if emptyCell == chunkNumber  or currentCell.marked then return end

		if currentCell.crossed then
			for j = 1, #emptyCellList do
				emptyCellList[j]:crossCell()
			end
			emptyCellList = {}
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.markIfNumberFitsExactlyInChunk(x, y, dx, dy) -- edge solution
	local indexOfActiveNumber
	local chunkNumber
	local foundMarkedCell
	local i = 0

	if dx ~= 0 then
		if dx == 1 then
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			Solver.direction = "Left to Right"
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			indexOfActiveNumber = 1
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			indexOfActiveNumber = 1
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
		end
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		i = i + 1
		local currentCell = boardCellsMain.boardCells[y][x]
		print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if i > chunkNumber + 1 then
			return
		end

		if currentCell.marked and i < chunkNumber then
			foundMarkedCell = currentCell
		end

		if i > chunkNumber and foundMarkedCell and currentCell.crossed then
			while i > 1 do
				i = i - 1
				if dx == 1 then
					x = x - 1
					boardCellsMain.boardCells[y][x]:markCellSolver()
				end

				if dx == -1 then
					x = x + 1
					boardCellsMain.boardCells[y][x]:markCellSolver()
				end

				if dy == 1 then
					y = y - 1
					boardCellsMain.boardCells[y][x]:markCellSolver()
				end

				if dy == -1 then
					y = y + 1
					boardCellsMain.boardCells[y][x]:markCellSolver()
				end
			end
			break
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.crossCellBetweenChunks(x, y, dx, dy) -- edge solution
	local indexOfActiveNumber
	local chunkNumber
	local foundMarkedCell = false
	local i = 0
	local emptyCell = 0
	local emptyCellList = {}
	local chunkCount = 0
	-- local previousCell = {}
	-- previousCell.marked = false

	if dx ~= 0 then
		if dx == 1 then
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			Solver.direction = "Left to Right"
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			indexOfActiveNumber = 1
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			indexOfActiveNumber = 1
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
		end
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		i = i + 1
		local currentCell = boardCellsMain.boardCells[y][x]
		print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if not currentCell.marked and not currentCell.crossed then
			table.insert(emptyCellList, currentCell)
			chunkCount = chunkCount + 1
		end

		if emptyCell == chunkNumber or chunkCount > chunkNumber then return end

		if currentCell.marked then
			foundMarkedCell = true
			chunkCount = chunkCount + 1
		end

		if foundMarkedCell and currentCell.crossed and chunkCount == chunkNumber then
			for j = 1, #emptyCellList do
				emptyCellList[j]:markCellSolver()
			end
			break
		end

		-- previousCell = currentCell

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.crossIfNumberFitsLoosleyInChunk(x, y, dx, dy) -- edge solution
	local indexOfActiveNumber
	local chunkNumber
	local foundMarkedCell = 0
	local emptyCell = 0
	local emptyCellList = {}
	local i = 0

	if dx ~= 0 then
		if dx == 1 then
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			Solver.direction = "Left to Right"
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			indexOfActiveNumber = 1
			if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			indexOfActiveNumber = 1
			if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then return end
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
		end
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		i = i + 1
		local currentCell = boardCellsMain.boardCells[y][x]
		print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if not currentCell.marked and not currentCell.crossed then
			emptyCell = emptyCell + 1
			table.insert(emptyCellList, currentCell)
		end

		if i > chunkNumber + 1 then
			return
		end

		if currentCell.marked then
			foundMarkedCell = foundMarkedCell + 1
		end

		if emptyCell > 0 and foundMarkedCell == chunkNumber then
			for j = 1, #emptyCellList do
				emptyCellList[j]:crossCell()
			end
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver:start(startPoint, endPoint)
	if not endPoint then endPoint = #problems end
	for i = startPoint, endPoint do
		self.countNumbers()
		boardCellsMain:markAllTheThings()
		Co = coroutine.create(Solver.markChunks)
		run = true
	end
end

function Solver:draw()
	love.graphics.setColor(1, 0, 0)
	love.graphics.print(self.direction, 700)
	love.graphics.rectangle("line", self.activeCell.x, self.activeCell.y, s.cellSize, s.cellSize)
	love.graphics.setColor(1, 1, 1)
end

function Solver:keypressed(key,scancode,isrepeat)
	if key == "c" then
		if coroutine.status(Co) == "suspended" then
			coroutine.resume(Co)
		end
	end
end

function Solver:update(dt)
	if run then
		if coroutine.status(Co) == "suspended" then
			if self.timer > 0 then
				self.timer = self.timer - 1 * dt
			end

			if self.timer <= 0 then
				self.timer = self.speed
				coroutine.resume(Co)
			end
		end
	end
end

return Solver