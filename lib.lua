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

return Lib