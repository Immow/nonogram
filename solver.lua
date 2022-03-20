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
Solver.speed = 0.1
Solver.timer = Solver.speed
Solver.functionResults = {}

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
		-- print("Solving row: "..i)
		length = #boardCellsMain.boardCells[i]
		board = boardDimensions.resultLeft
		index = #board[i]
		difference = #problems[s.problem][1] - count
	else
		-- print("Solving column: "..i)
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
					-- print("marking Row")
				else
					boardCellsMain.boardCells[j][i]:crossCell()
					-- print("marking Column")
				end
			else
				chunkIndex = chunkIndex + 1
			end
		end
	else
		local number = board[i][index] -- select the left most number
		for j = 1, length do
			if chunkIndex > difference and number - chunkIndex >= 0 and number > difference and dir == "horizontal" then
				-- print("itteration: "..j.." marking cell: "..boardCellsMain.boardCells[i][j].position[1]..", "..boardCellsMain.boardCells[i][j].position[2])
				boardCellsMain.boardCells[i][j]:markCellSolver()
			elseif chunkIndex > difference and number - chunkIndex >= 0 and number > difference and dir == "vertical" then
				-- print("itteration: "..i.." marking cell: "..boardCellsMain.boardCells[j][i].position[2]..", "..boardCellsMain.boardCells[j][i].position[1])
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

---@return any indexOfActiveNumber
---@return any chunkNumber
function Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	if dx ~= 0 then
		if dx == 1 then
			Solver.direction = "Left to Right"
			indexOfActiveNumber = #boardDimensions.resultLeft[y]
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- left most number on left matrix
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
			indexOfActiveNumber = 1
			chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber] -- first most number on left matrix
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
			indexOfActiveNumber = #boardDimensions.resultTop[x]
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- left most number on left matrix
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
			indexOfActiveNumber = 1
			chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber] -- first most number on left matrix
		end
	end
	return indexOfActiveNumber, chunkNumber
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

function Solver.countUnsolvedNumbers(x, y, dx, dy)
	local unsolvedNumbers = {}
	if dx ~= 0 then
		for i = 1, #boardDimensions.resultLeft[y] do
			if not boardCellsLeft.numberCellsLeft[y][i].crossed then
				table.insert(unsolvedNumbers, boardDimensions.resultLeft[y][i])
			end
		end
	end

	if dy ~= 0 then
		for i = 1, #boardDimensions.resultTop[x] do
			if not boardCellsTop.numberCellsTop[x][i].crossed then
				table.insert(unsolvedNumbers, boardDimensions.resultTop[x][i])
			end
		end
	end
	return unsolvedNumbers
end

function Solver.countTotalNumbers(x, y, dx, dy)
	local numbers = {}
	if dx ~= 0 then
		for i = 1, #boardDimensions.resultLeft[y] do
			table.insert(numbers, boardDimensions.resultLeft[y][i])
		end
	end

	if dy ~= 0 then
		for i = 1, #boardDimensions.resultTop[x] do
			table.insert(numbers, boardDimensions.resultTop[x][i])
		end
	end
	return numbers
end

function Solver.setUnsolvedNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	if Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber) then
		if Solver.canSelectNextNumber(x, y, dx, dy, indexOfActiveNumber) then
			indexOfActiveNumber, chunkNumber = Solver.setNextNumber(x, y, dx, dy, indexOfActiveNumber)
			if Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber) then
				Solver.setUnsolvedNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
			end
		end
	end
	return indexOfActiveNumber, chunkNumber
end

function Solver.getNextNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	if Solver.canSelectNextNumber(x, y, dx, dy, indexOfActiveNumber) then
		indexOfActiveNumber, chunkNumber = Solver.setNextNumber(x, y, dx, dy, indexOfActiveNumber)
		return chunkNumber
	end
end

function Solver.canSelectNextNumber(x, y, dx, dy, indexOfActiveNumber)
	if dx == 1 then
		return indexOfActiveNumber > 1
	end

	if dx == -1 then
		return indexOfActiveNumber < #boardDimensions.resultLeft[y]
	end

	if dy == 1 then
		return indexOfActiveNumber > 1
	end

	if dy == -1 then
		return indexOfActiveNumber < #boardDimensions.resultTop[x]
	end
end

---@return any chunkNumber
---@return any indexOfActiveNumber
function Solver.setNextNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	if dx == 1 then
		assert(indexOfActiveNumber > 1, indexOfActiveNumber.." is not above 1, will result in out of bounds index at x: "..x..", y: "..y)
		indexOfActiveNumber = indexOfActiveNumber - 1
		chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber]
	end
	
	if dx == -1 then
		assert(indexOfActiveNumber < #boardDimensions.resultLeft[y], indexOfActiveNumber.." is not above 1, will result in out of bounds index at x: "..x..", y: "..y)
		indexOfActiveNumber = indexOfActiveNumber + 1
		chunkNumber = boardDimensions.resultLeft[y][indexOfActiveNumber]
	end

	if dy == 1 then
		assert(indexOfActiveNumber > 1, indexOfActiveNumber.." is not above 1, will result in out of bounds index at x: "..x..", y: "..y)
		indexOfActiveNumber = indexOfActiveNumber - 1
		chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber]
	end

	if dy == -1 then
		assert(indexOfActiveNumber < #boardDimensions.resultTop[x], indexOfActiveNumber.." is not above 1, will result in out of bounds index at x: "..x..", y: "..y)
		indexOfActiveNumber = indexOfActiveNumber + 1
		chunkNumber = boardDimensions.resultTop[x][indexOfActiveNumber]
	end
	assert(chunkNumber ~= nil, "chunknumber is nil at x: "..x..", y:"..y)
	return indexOfActiveNumber, chunkNumber
end

function Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber)
	if dx ~= 0 then
		if boardCellsLeft.numberCellsLeft[y][indexOfActiveNumber].crossed then
			return true
		end
	end

	if dy ~= 0 then
		if boardCellsTop.numberCellsTop[x][indexOfActiveNumber].crossed then
			return true
		end
	end
end

function Solver.isLineSolved(x, y, dx, dy)
	if dx ~= 0 then
		for i = 1, #boardDimensions.resultLeft[y] do
			if not boardCellsLeft.numberCellsLeft[y][i].crossed then
				return false
			end
		end
		return true
	end

	if dy ~= 0 then
		for i = 1, #boardDimensions.resultTop[x] do
			if not boardCellsTop.numberCellsTop[x][i].crossed then
				return false
			end
		end
		return true
	end
end

function Solver.returnLargestNumbers(x, y, dx, dy)
	local largestNumber = 0
	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		if dx ~= 0 then
			for i = 1, #boardDimensions.resultLeft[y] do
				if boardDimensions.resultLeft[y][i] > largestNumber then
					largestNumber = boardDimensions.resultLeft[y][i]
				end
			end
		else
			for i = 1, #boardDimensions.resultTop[x] do
				if boardDimensions.resultTop[x][i] > largestNumber then
					largestNumber = boardDimensions.resultTop[x][i]
				end
			end
		end
		y = y + dy
		x = x + dx
	end
	return largestNumber
end

function Solver.addScore(name)
	if not Solver.functionResults[name] then
		Solver.functionResults[name] = 1
	else
		Solver.functionResults[name] = Solver.functionResults[name] + 1
	end
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
	
	boardCellsMain:markAllTheThings()

	for i = 1, #boardCellsMain.boardCells do -- Does not do anything!
		Solver.crossIfNumberDoesntFitInChunk(1, i, 1, 0) -- left to right
		Solver.crossIfNumberDoesntFitInChunk(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.crossIfNumberDoesntFitInChunk(i, 1, 0, 1) -- top to bottom
		Solver.crossIfNumberDoesntFitInChunk(i, height, 0, -1) -- bottom to top
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

	for i = 1, #boardCellsMain.boardCells do
		Solver.crossChunks(1, i, 1, 0) -- left to right
		Solver.crossChunks(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.crossChunks(i, 1, 0, 1) -- top to bottom
		Solver.crossChunks(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.combinedMarkChunks(1, i, 1, 0) -- left to right
		Solver.combinedMarkChunks(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.combinedMarkChunks(i, 1, 0, 1) -- top to bottom
		Solver.combinedMarkChunks(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.markCellsInChunk(1, i, 1, 0) -- left to right
		Solver.markCellsInChunk(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.markCellsInChunk(i, 1, 0, 1) -- top to bottom
		Solver.markCellsInChunk(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		Solver.compareEmptyAndMarkedCells(1, i, 1, 0) -- left to right
		Solver.compareEmptyAndMarkedCells(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		Solver.compareEmptyAndMarkedCells(i, 1, 0, 1) -- top to bottom
		Solver.compareEmptyAndMarkedCells(i, height, 0, -1) -- bottom to top
	end

	for i = 1, #boardCellsMain.boardCells do
		-- Solver.markCellBycomparingAgainstNeighbour(1, i, 1, 0) -- left to right
		Solver.markCellBycomparingAgainstNeighbour(width, i, -1, 0) -- right to left
	end
	for i = 1, #boardCellsMain.boardCells[1] do
		-- Solver.markCellBycomparingAgainstNeighbour(i, 1, 0, 1) -- top to bottom
		-- Solver.markCellBycomparingAgainstNeighbour(i, height, 0, -1) -- bottom to top
	end

	print("end of loop reached")
	for key, score in pairs(Solver.functionResults) do
		print(key, score)
	end
	boardCellsMain:markAllTheThings()
end

function Solver.markChunksInLine(x, y, dx, dy)
	if Solver.isLineSolved(x, y, dx, dy) then return end
	local indexOfActiveNumber
	local chunkNumber
	local previousCell = {}
	previousCell.marked = false
	indexOfActiveNumber, chunkNumber = Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if chunkNumber == 0 then
			if not currentCell.marked and previousCell.crossed then
				break
			end
			currentCell:crossCell()
			if Solver.canSelectNextNumber(x, y, dx, dy, indexOfActiveNumber) then
				indexOfActiveNumber, chunkNumber = Solver.setNextNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
			else
				return
			end
		end

		if currentCell.marked or currentCell.crossed then
			if currentCell.marked then
				chunkNumber = chunkNumber - 1
			end
		elseif previousCell.marked and chunkNumber > 0 then
			chunkNumber = chunkNumber - 1
			currentCell:markCellSolver()
			-- Solver.addScore("markChunksInLine")
		else
			break
		end
		y = y + dy
		x = x + dx
		previousCell = currentCell
		-- coroutine.yield()
	end
end

function Solver.crossIfNumberDoesntFitInChunk(x, y, dx, dy) -- edge solution
	if Solver.isLineSolved(x, y, dx, dy) then return end

	local indexOfActiveNumber
	local chunkNumber
	local emptyCellCount = 0
	local emptyCellList = {}

	indexOfActiveNumber, chunkNumber = Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	indexOfActiveNumber, chunkNumber = Solver.setUnsolvedNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		local emptyCell = not currentCell.marked and not currentCell.crossed
		-- print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])
		
		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y
		
		if emptyCell then
			emptyCellCount = emptyCellCount + 1
			table.insert(emptyCellList, currentCell)
		end

		if emptyCellCount == chunkNumber or currentCell.marked then return end

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

function Solver.crossCellBetweenChunks(x, y, dx, dy) -- edge solution
	if Solver.isLineSolved(x, y, dx, dy) then return end
	local indexOfActiveNumber
	local chunkNumber
	local foundMarkedCell = false
	local i = 0
	local emptyCellList = {}
	local chunkCount = 0
	
	indexOfActiveNumber, chunkNumber = Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	if Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber) then return end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		local emptyCell = not currentCell.marked and not currentCell.crossed
		
		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y
		
		i = i + 1

		if emptyCell then
			table.insert(emptyCellList, currentCell)
			chunkCount = chunkCount + 1
		end

		if currentCell.marked then
			foundMarkedCell = true
			chunkCount = chunkCount + 1
		end
		
		if foundMarkedCell and currentCell.crossed and chunkCount == chunkNumber then
			for j = 1, #emptyCellList do
				emptyCellList[j]:markCellSolver()
				-- Solver.addScore("crossCellBetweenChunks")
			end
			break
		end
		
		if chunkCount > chunkNumber then return end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.crossIfNumberFitsLoosleyInChunk(x, y, dx, dy) -- edge solution
	if Solver.isLineSolved(x, y, dx, dy) then return end

	local indexOfActiveNumber
	local chunkNumber
	local foundMarkedCell = 0
	local emptyCell = 0
	local emptyCellList = {}
	local i = 0

	indexOfActiveNumber, chunkNumber = Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	if Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber) then return end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		i = i + 1
		local currentCell = boardCellsMain.boardCells[y][x]
		-- print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])

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
				-- Solver.addScore("crossIfNumberFitsLoosleyInChunk")
			end
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.crossChunks(x, y, dx, dy)
	if Solver.isLineSolved(x, y, dx, dy) then return end
	local indexOfActiveNumber
	local chunkNumber
	local i = 0
	local previousCell = {marked = false}
	local list = {}

	indexOfActiveNumber, chunkNumber =  Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		local emptyCell = not currentCell.marked and not currentCell.crossed

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		i = i + 1

		if emptyCell or currentCell.marked then
			table.insert(list, currentCell)
		end

		if currentCell.crossed and previousCell.marked and i <= chunkNumber +2 then
			for j = #list, 1, -1 do
				if j > #list - chunkNumber then
					list[j]:markCellSolver()
					-- Solver.addScore("crossChunks")
				else
					list[j]:crossCell()
					-- Solver.addScore("crossChunks")
				end
			end
			break
		end

		previousCell = currentCell

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.combinedMarkChunks(x, y, dx, dy)
	local markedCell = 0
	local emptyCellCount = 0
	local emptyCell
	local largestNumber = Solver.returnLargestNumbers(x, y, dx, dy)

	if dx ~= 0 then
		if dx == 1 then
			Solver.direction = "Left to Right"
		end

		if dx == -1 then
			Solver.direction = "Right to Left"
		end
	else
		if dy == 1 then
			Solver.direction = "Top to Bottom"
		end

		if dy == -1 then
			Solver.direction = "Bottom to Top"
		end
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		-- print("i: "..x.." current cell ".. currentCell.position[1], currentCell.position[2])

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y
		
		if markedCell > 1 and emptyCellCount == 1 and markedCell >= largestNumber then
			emptyCell:crossCell()
			-- Solver.addScore("combinedMarkChunks")
			markedCell = 0
			emptyCellCount = 0
		end

		if not currentCell.marked and not currentCell.crossed and markedCell > 0 then
			emptyCellCount = emptyCellCount + 1
			emptyCell = currentCell
		end

		if currentCell.marked then
			markedCell = markedCell + 1
		end

		if currentCell.crossed or emptyCellCount > 1 then
			markedCell = 0
			emptyCellCount = 0
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.markCellsInChunk(x, y, dx, dy)
	if Solver.isLineSolved(x, y, dx, dy) then return end

	local indexOfActiveNumber
	local chunkNumber = 0
	local emptyCellList = {}
	local emptyCellListWithNoMarkedCellDetected = {}
	local markedCellCount = 0
	local i = 0
	local foundMarkedCell = false
	local done = false
	local solvedNumbers = 0

	indexOfActiveNumber, chunkNumber = Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	if not Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber) then return end

	local function checkIfNumberIsCrossed()
		if Solver.isNumberCrossed(x, y, dx, dy, indexOfActiveNumber) then
			solvedNumbers = solvedNumbers + 1
			if Solver.canSelectNextNumber(x, y, dx, dy, indexOfActiveNumber) then
				indexOfActiveNumber, chunkNumber = Solver.setNextNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
				checkIfNumberIsCrossed()
			else
				done = true
			end
		end
	end
	
	checkIfNumberIsCrossed()

	if done then return end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		local emptyCell = not currentCell.marked and not currentCell.crossed

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		i = i + 1

		if currentCell.marked and i < chunkNumber then
			foundMarkedCell = true
		end

		if emptyCell and foundMarkedCell and i <= chunkNumber  then
			table.insert(emptyCellList, currentCell)
		end

		if emptyCell and markedCellCount == 0 then
			table.insert(emptyCellListWithNoMarkedCellDetected, currentCell)
		end

		if currentCell.marked then
			markedCellCount = markedCellCount + 1
		end

		if #emptyCellListWithNoMarkedCellDetected > 0 and markedCellCount == chunkNumber then
			for j = 1, #emptyCellListWithNoMarkedCellDetected do
				emptyCellListWithNoMarkedCellDetected[j]:crossCell()
				-- Solver.addScore("markCellsInChunk")
			end
			break
		end
		
		if #emptyCellList > 0 and i > chunkNumber and markedCellCount < chunkNumber then
			for j = 1, #emptyCellList do
				emptyCellList[j]:markCellSolver()
				-- Solver.addScore("markCellsInChunk")
			end
			break
		end

		if currentCell.crossed then
			if #emptyCellListWithNoMarkedCellDetected > 0 then return end
			i = 0
			foundMarkedCell = false
			markedCellCount = 0
			emptyCellListWithNoMarkedCellDetected = {}
			emptyCellList = {}
		end

		if #emptyCellListWithNoMarkedCellDetected > 0 and i > chunkNumber then
			break
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end
end

function Solver.compareEmptyAndMarkedCells(x, y, dx, dy) -- edge solution
	if Solver.isLineSolved(x, y, dx, dy) then return end

	local emptyCellList = {}
	local sumOfUnsolvedNumbers = 0
	local unsolvedNumberList = Solver.countUnsolvedNumbers(x, y, dx, dy)
	local numberList = Solver.countTotalNumbers(x, y, dx, dy)
	local sumOfMarkedCells = 0
	local totalSumNumberList = 0

	for _, value in ipairs(unsolvedNumberList) do
		sumOfUnsolvedNumbers = sumOfUnsolvedNumbers + value
	end

	for _, value in ipairs(numberList) do
		totalSumNumberList = totalSumNumberList + value
	end

	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		local emptyCell = not currentCell.marked and not currentCell.crossed
		
		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if emptyCell then
			table.insert(emptyCellList, currentCell)
		end

		if currentCell.marked then
			sumOfMarkedCells = sumOfMarkedCells + 1
		end

		y = y + dy
		x = x + dx
		-- coroutine.yield()
	end

	if totalSumNumberList - sumOfMarkedCells == #emptyCellList then
		for i = 1, #emptyCellList do
			emptyCellList[i]:markCellSolver()
			-- Solver.addScore("compareEmptyAndMarkedCells")
		end
	end
end

function Solver.markCellBycomparingAgainstNeighbour(x, y, dx, dy)
	if Solver.isLineSolved(x, y, dx, dy) then return end
	local indexOfActiveNumber
	local chunkNumber = 0
	local emptyCellList = {}
	local i = 0
	local previousCell = {marked = false}
	local nextChunk = false
	local crossedCellList = {}
	local markedCellList = {}

	indexOfActiveNumber, chunkNumber = Solver.setStartingNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	indexOfActiveNumber, chunkNumber = Solver.setUnsolvedNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)

	local neighbour = Solver.getNextNumber(x, y, dx, dy, indexOfActiveNumber, chunkNumber)
	
	if not neighbour then return end
	if neighbour == chunkNumber then return end
	print(chunkNumber, neighbour)


	while boardCellsMain:isWithinBounds(x, y, boardCellsMain.boardCells) do
		local currentCell = boardCellsMain.boardCells[y][x]
		local emptyCell = not currentCell.marked and not currentCell.crossed

		Solver.activeCell.x = currentCell.x
		Solver.activeCell.y = currentCell.y

		if (currentCell.marked and #crossedCellList == 0) or i > neighbour then
			break
		end

		if #emptyCellList > 0 and currentCell.crossed then
			table.insert(crossedCellList, currentCell)
		end

		if #emptyCellList > 0 and currentCell.marked then
			table.insert(markedCellList, currentCell)
		end

		if emptyCell then
			table.insert(emptyCellList, currentCell)
		end
		
		if #crossedCellList == 2 and #markedCellList ~= neighbour then
			break
		end

		if currentCell.marked and previousCell.crossed and #emptyCellList > 0 then
			nextChunk = true
		end

		if nextChunk then
			i = i + 1
		end

		if i == neighbour then
			if #emptyCellList == chunkNumber then
				for _, cell in ipairs(emptyCellList) do
					cell:markCellSolver()
				end
			end
		end
		previousCell = currentCell

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

	if key == "d" then
		print(boardDimensions.resultLeft[1][2])
	end

	if key == "up" then
		self.speed = self.speed + 0.1
	end

	if key == "down" then
		if self.speed > 0.1 then
			self.speed = self.speed - 0.1
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