local problems = require("problems")

local BoardNumbersTop = {}
BoardNumbersTop.result = {}

function BoardNumbersTop:createColumnNumbers(problem)
	local count = 0
	for i = 1, #problems[problem][1] do
		for j = 1, #problems[problem] do
			if j == 1 then
				table.insert(BoardNumbersTop.result, {})
			end
			if problems[problem][j][i] == 1 then
				count = count + 1
			end
			if problems[problem][j][i] == 0 and count > 0 then
				table.insert(BoardNumbersTop.result[i], count)
				count = 0
			end
			if j == #problems[problem] and count > 0 then
				table.insert(BoardNumbersTop.result[i], count)
				count = 0
			end
		end
	end
end

return BoardNumbersTop