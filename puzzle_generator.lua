local tserial = require("tserialize")
local PuzzleGenerator = {}

PuzzleGenerator.result = {}

function PuzzleGenerator:generate(width, height)
	
	for i = 1, height do
		table.insert(self.result, {})
		for j = 1, width do
			local r = love.math.random(0,1)
			table.insert(self.result[i], r)
		end
	end
	love.filesystem.write("dump.txt", tserial.pack(self.result, drop, false))
end

return PuzzleGenerator