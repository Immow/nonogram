-- local tserial = require("tserialize")
local PuzzleGenerator = {}
--[[
- Puzzle generator rules (make it possible for humans to solve)
	- Large numbers, the number is greater than half the row or column length
	- Combined numbers (chunks) plus empty space result in vinding valid results
	- At least 1 number per column or row
	- Check the density of numbers, if there are not enough numbers we can't solve the problem
]]
PuzzleGenerator.result = {}

function PuzzleGenerator.removeFile()
	love.filesystem.remove("dump.txt")
end

function PuzzleGenerator:checkRow()
	print("running checkRow")
	local succes = false
	for i = 1, #self.result do
		local count = 0
		for j = 1, #self.result[i] do
			if self.result[i][j] == 1 then
				count = count + 1
			else
				if count > #self.result[i] / 2 then
					print(count)
					succes = true
					break
				else
					count = 0
				end
			end
		end
	end
	return succes
end

function PuzzleGenerator:checkColumn()
	print("running checkColumn")
	local succes = false
	for i = 1, #self.result[1] do
		local count = 0
		for j = 1, #self.result[i] do
			if self.result[j][i] == 1 then
				count = count + 1
			else
				if count > #self.result / 2 then
					print(count)
					succes = true
					break
				else
					count = 0
				end
			end
		end
	end
	return succes
end

function PuzzleGenerator:generate(width, height, bias, amount)

	local function run()
			self.result = {}
			print("run")
			for i = 1, height do
				table.insert(self.result, {})
				for j = 1, width do
					local r = love.math.random(1,10)
					if r <= bias then
						r = 1
					else
						r = 0
					end
					table.insert(self.result[i], r)
				end
			end

			if self:checkRow() or self:checkColumn() then
				for i = 1, #self.result do
					for j = 1, #self.result[i] do
						love.filesystem.append("dump.txt", tostring(self.result[i][j]))
						if j < #self.result[i] then
							love.filesystem.append("dump.txt", ",")
						end
						if j == #self.result[i] then
							love.filesystem.append("dump.txt", "\n")
						end
					end
				end
				love.filesystem.append("dump.txt", "\n")
			else
				run()
			end
		end

	for _ = 1, amount do
		run()
	end
end

return PuzzleGenerator