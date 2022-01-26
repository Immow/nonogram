local problems = require("problems")
local number   = require("numbers")
local s        = require("settings")

local boardNumbers = {}
boardNumbers.resultRow = {}
boardNumbers.numbersRow = {}
boardNumbers.resultColumn = {}
boardNumbers.numbersColumn = {}
boardNumbers.x = 0
boardNumbers.y = 0

function boardNumbers:purge()
	self.resultRow = {}
	self.numbersRow = {}
	self.resultColumn = {}
	self.numbersColumn = {}
end

function boardNumbers:load()
	boardNumbers:createRowNumbers()
	boardNumbers:createColumnNumbers()
	boardNumbers:setMostNumbers()
	boardNumbers:setX()
	boardNumbers:setY()
	boardNumbers:setNumberPositionsRow()
	boardNumbers:setNumberPositionsColumn()
end

function boardNumbers:setX()
	self.x = self.maxNumbersRow * s.cellSize
end

function boardNumbers:setY()
	self.y = self.maxNumbersColumn * s.cellSize
end

function boardNumbers.comboBreakerRow(problem, count, i, j)
	return (problems[problem][i][j] == 0 or j == 1) and count > 0
end

function boardNumbers.comboBreakerColumn(problem, count, i, j)
	return (problems[problem][j][i] == 0 or j == 1) and count > 0
end

function boardNumbers:setMostNumbers()
	local resultRow = 0
	for i = 1, #self.resultRow do
		if resultRow < #self.resultRow[i] then
			resultRow = #self.resultRow[i]
		end
		self.maxNumbersRow = resultRow
	end
	local resultColumn = 0
	for i = 1, #self.resultColumn do
		if resultColumn < #self.resultColumn[i] then
			resultColumn = #self.resultColumn[i]
		end
	end
	self.maxNumbersColumn = resultColumn
end

function boardNumbers:createRowNumbers()
	local count = 0
	for i = 1, #problems[s.problem] do
		for j = #problems[s.problem][i], 1, -1 do
			if j == #problems[s.problem][i] then
				table.insert(boardNumbers.resultRow, {})
			end
			if problems[s.problem][i][j] == 1 then
				count = count + 1
			end
			if self.comboBreakerRow(s.problem, count, i, j) then
				table.insert(boardNumbers.resultRow[i], count)
				count = 0
			end
		end
	end
end

function boardNumbers:createColumnNumbers()
	local count = 0
	for i = 1, #problems[s.problem][1] do
		for j = #problems[s.problem], 1, -1 do
			if j == #problems[s.problem] then
				table.insert(boardNumbers.resultColumn, {})
			end
			if problems[s.problem][j][i] == 1 then
				count = count + 1
			end
			if self.comboBreakerColumn(s.problem, count, i, j) then
				table.insert(boardNumbers.resultColumn[i], count)
				count = 0
			end
		end
	end
end

function boardNumbers:setNumberPositionsRow()
	local y = self.y
	for i = 1, #problems[s.problem] do
		boardNumbers.numbersRow[i] = {}
		for j = 1, #boardNumbers.resultRow[i] do
			local x = self.x - (s.cellSize * j)
			boardNumbers.numbersRow[i][j] = number.new({x = x, y = y, text = boardNumbers.resultRow[i][j]})
		end
		y = y + s.cellSize
	end
end

function boardNumbers:setNumberPositionsColumn()
	local x = self.x
	for i = 1, #problems[s.problem][1] do
		boardNumbers.numbersColumn[i] = {}
		for j = 1, #boardNumbers.resultColumn[i] do
			local y = self.y - (s.cellSize * j)
			boardNumbers.numbersColumn[i][j] = number.new({x = x, y = y, text = boardNumbers.resultColumn[i][j]})
		end
		x = x + s.cellSize
	end
end

function boardNumbers:draw()
	love.graphics.setColor(1,1,1)
	for i = 1, #boardNumbers.numbersRow do
		for j = 1, #boardNumbers.numbersRow[i] do
			boardNumbers.numbersRow[i][j]:draw()
		end
	end

	for i = 1, #boardNumbers.numbersColumn do
		for j = 1, #boardNumbers.numbersColumn[i] do
			boardNumbers.numbersColumn[i][j]:draw()
		end
	end
end

return boardNumbers