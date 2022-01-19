local problems = require("problems")

local RowNumbers = {}
RowNumbers.result = {}

function RowNumbers:createRowNumbers(problem)
	local count = 0
	for i = 1, #problems[problem] do
		for j = 1, #problems[problem][i] do
			if j == 1 then
				table.insert(RowNumbers.result, {})
			end
			if problems[problem][i][j] == 1 then
				count = count + 1
			end
			if problems[problem][i][j] == 0 and count > 0 then
				table.insert(RowNumbers.result[i], count)
				count = 0
			end
			if j == #problems[problem][i] and count > 0 then
				table.insert(RowNumbers.result[i], count)
				count = 0
			end
		end
	end
end

return RowNumbers