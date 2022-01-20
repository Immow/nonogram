local problems = require("problems")
local number = require("numbers")
local boardDimensions = require("boarddimensions")
local s = require("settings")

local numbersLeft = {}
numbersLeft.result = {}
numbersLeft.numbers = {}
numbersLeft.x = boardDimensions.getXofBoardcellMain()
numbersLeft.y = boardDimensions.getYBoardcellMain()

function numbersLeft:comboBreaker(problem, count, i, j)
	return (problems[problem][i][j] == 0 or j == 1) and count > 0
end

function numbersLeft:createRowNumbers(problem)
	local count = 0
	for i = 1, #problems[problem] do
		for j = #problems[problem][i], 1, -1  do
			if j == #problems[problem][i] then
				table.insert(numbersLeft.result, {})
			end
			if problems[problem][i][j] == 1 then
				count = count + 1
			end
			if self:comboBreaker(problem, count, i, j) then
				table.insert(numbersLeft.result[i], count)
				count = 0
			end
		end
	end
end
function numbersLeft:setNumberPositions()
	for i = 1, #problems[s.problem] do
		numbersLeft.numbers[i] = {}
		for j = 1, #numbersLeft.result[i] do
			local x = self.x - (s.cellSize * j)
			numbersLeft.numbers[i][j] = number.new({x = x, y = self.y, text = numbersLeft.result[i][j]})
		end
		self.y = self.y + s.cellSize
	end
end

function numbersLeft:draw()
	for i = 1, #numbersLeft.numbers do
		for j = 1, #numbersLeft.numbers[i] do
			numbersLeft.numbers[i][j]:draw()
		end
	end
end

return numbersLeft