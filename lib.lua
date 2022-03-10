local Lib = {}

function Lib.Transpose(m)
	local res = {}

	for i = 1, #m[1] do
		res[i] = {}
		for j = 1, #m do
			res[i][j] = m[j][i]
		end
	end

	return res
end

function Lib:clearCells(table)
	for i = 1, #table do
		for j = 1, #table[i] do
			table[i][j].marked = false
			table[i][j].crossed = false
			table[i][j].setCell = false
			table[i][j].alpha = 0
			table[i][j].fade = false
			table[i][j].locked = false
			table[i][j].wrong = false
		end
	end
end

function Lib:isCellCrossed(arg)
	return arg.crossed
end

return Lib