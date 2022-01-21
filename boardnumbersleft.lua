local problems = require("problems")
local number = require("numbers")
local s = require("settings")
local boardNumbers = require("boardnumbers")

local boardNumbersLeft = {}
boardNumbersLeft.result = {}
boardNumbersLeft.numbers = {}
boardNumbersLeft.x = 0
boardNumbersLeft.y = 0

function boardNumbersLeft:comboBreaker(problem, count, i, j)
	return (problems[problem][i][j] == 0 or j == 1) and count > 0
end

function boardNumbersLeft:getMostNumbersPerRow()
	local result = 0
	for i = 1, #boardNumbersLeft.result do
		result = #boardNumbersLeft.result[1]
		if result < #boardNumbersLeft.result[i] then
			result = #boardNumbersLeft.result[i]
		end
	end
	return result
end

function boardNumbersLeft:createRowNumbers(problem)
	local count = 0
	for i = 1, #problems[problem] do
		for j = #problems[problem][i], 1, -1  do
			if j == #problems[problem][i] then
				table.insert(boardNumbersLeft.result, {})
			end
			if problems[problem][i][j] == 1 then
				count = count + 1
			end
			if self:comboBreaker(problem, count, i, j) then
				table.insert(boardNumbersLeft.result[i], count)
				count = 0
			end
		end
	end
end

function boardNumbersLeft:setNumberPositions()
	self.x = boardNumbers.x
	self.y = boardNumbers.y
	for i = 1, #problems[s.problem] do
		boardNumbersLeft.numbers[i] = {}
		for j = 1, #boardNumbersLeft.result[i] do
			local x = self.x - (s.cellSize * j)
			boardNumbersLeft.numbers[i][j] = number.new({x = x, y = self.y, text = boardNumbersLeft.result[i][j]})
		end
		self.y = self.y + s.cellSize
	end
end

function boardNumbersLeft:draw()
	for i = 1, #boardNumbersLeft.numbers do
		for j = 1, #boardNumbersLeft.numbers[i] do
			boardNumbersLeft.numbers[i][j]:draw()
		end
	end
end

return boardNumbersLeft