local problems = require("problems")
local number = require("numbers")
local boardDimensions = require("boarddimensions")
local s = require("settings")

local numbersTop = {}
numbersTop.result = {}
numbersTop.numbers = {}
numbersTop.x = boardDimensions.getXofBoardcellMain()
numbersTop.y = boardDimensions.getYBoardcellMain()

function numbersTop:comboBreaker(problem, count, i, j)
	return (problems[problem][j][i] == 0 or j == 1) and count > 0
end

function numbersTop:createColumnNumbers(problem)
	local count = 0
	for i = 1, #problems[problem][1] do
		for j = #problems[problem], 1, -1  do
			if j == #problems[problem] then
				table.insert(numbersTop.result, {})
			end
			if problems[problem][j][i] == 1 then
				count = count + 1
			end
			if self:comboBreaker(problem, count, i, j) then
				table.insert(numbersTop.result[i], count)
				count = 0
			end
		end
	end
	print(tprint(numbersTop.result))
end

function numbersTop:setNumberPositions()
	for i = 1, #problems[s.problem][1] do
		numbersTop.numbers[i] = {}
		for j = 1, #numbersTop.result[i] do
			local y = self.y - (s.cellSize * j)
			numbersTop.numbers[i][j] = number.new({x = self.x, y = y, text = numbersTop.result[i][j]})
		end
		self.x = self.x + s.cellSize
	end
end

function numbersTop:draw()
	for i = 1, #numbersTop.numbers do
		for j = 1, #numbersTop.numbers[i] do
			numbersTop.numbers[i][j]:draw()
		end
	end
end

return numbersTop