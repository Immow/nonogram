local s              = require("settings")
local problems       = require("problems")
local boardNumbers   = require("board_numbers")
local boardCellsMain = require("board_cells_main")
local boardCellsTop  = require("board_cells_top")
local boardCellsLeft = require("board_cells_left")
local boardDimensions = require("board_dimensions")

local Solver = {}
Solver.results = {}


-- function Solver:markCells(count, i)
-- 	print("running: "..i)
-- 	local index = #boardDimensions.resultLeft[i]
-- 	local chunkIndex = 1
-- 	local difference = #problems[s.problem][1] - count
-- 	if difference == 0 then
-- 		-- for j = 1, #boardCellsMain.boardCells[i] do
-- 		-- 	boardCellsMain.boardCells[i][j]:crossCell() -- needs to be changed
-- 		-- end
-- 	else
-- 		for j = 1, #boardCellsMain.boardCells[i] do
-- 			local number = boardDimensions.resultLeft[i][index]
-- 			print("itteration: "..j, "chunkIndex: "..chunkIndex, "number: "..number, "index: "..index)
-- 			if chunkIndex <= difference then
-- 				-- we skip
-- 			end
-- 			if chunkIndex > difference then
-- 				boardCellsMain.boardCells[i][j]:crossCell()
-- 			end
-- 			if chunkIndex > number then
-- 				-- we skip
-- 				chunkIndex = 1
-- 				if index > 2 then
-- 					index = index - 1
-- 				end
-- 			end
-- 			chunkIndex = chunkIndex + 1
-- 			number = number - 1
-- 		end
-- 	end
-- end

-- function Solver:markCells(count, i)
-- 	print("itteration: "..i)
-- 	local index = #boardDimensions.resultLeft[i]
-- 	print("index "..index)
-- 	local chunks = #boardDimensions.resultLeft[i]
-- 	print("chunks "..chunks)
-- 	local loopSize = boardDimensions.resultLeft[i][index]
-- 	print("loopSize"..loopSize)
-- 	local difference = #problems[s.problem][1] - count
-- 	if difference == 0 then
-- 		for j = 1, #boardCellsMain.boardCells[i] do
-- 			-- boardCellsMain.boardCells[i][j]:crossCell() -- needs to be changed
-- 		end
-- 	else
-- 		if chunks > 1 then
-- 			for j = 1, loopSize do
-- 				if j > difference then
-- 					boardCellsMain.boardCells[i][j]:markCellSolver()
-- 				end
-- 				chunks = chunks + 1
-- 			end
-- 		end

-- 		index = index - 1

-- 		if index >= 1 then
-- 			print("WTF")
-- 			Solver:markCells(count, i)
-- 		end
		
-- 	end

-- end

function Solver:markCells(count, i)
	print("running: "..i)
	local index = #boardDimensions.resultLeft[i]
	local chunkIndex = 1
	-- local chunk = boardDimensions.resultLeft[i][index] + 1
	local difference = #problems[s.problem][1] - count
	-- print("count: "..count)
	if difference == 0 then
		local number = boardDimensions.resultLeft[i][index] -- select the left most number
		for j = 1, #boardCellsMain.boardCells[i] do
			print(chunkIndex)
			if chunkIndex <= number then
				boardCellsMain.boardCells[i][j]:markCellSolver()
			end

			chunkIndex = chunkIndex + 1
			
			if chunkIndex > number + 1 then
				index = index - 1
				number = boardDimensions.resultLeft[i][index]
				chunkIndex = 1
				boardCellsMain.boardCells[i][j]:crossCell()
			end
		end
	else
		local number = boardDimensions.resultLeft[i][index] -- select the left most number
		for j = 1, #boardCellsMain.boardCells[i] do
			if chunkIndex > difference and chunkIndex < number + 1 and number > difference then
				boardCellsMain.boardCells[i][j]:markCellSolver()
			end

			chunkIndex = chunkIndex + 1

			if chunkIndex > number + difference then
				index = index - 1
				number = boardDimensions.resultLeft[i][index]
				chunkIndex = 1
			end
		end
	end
end

function Solver.countNumbers()
	local count = 0
	for i = 1, #boardDimensions.resultLeft do
		for j = 1, #boardDimensions.resultLeft[i] do
			if boardDimensions.resultLeft[i][j] then
				count = count + boardDimensions.resultLeft[i][j]
				if j > 1 then count = count + 1 end
			end
		end
		Solver:markCells(count, i)
		count = 0
	end
end

function Solver:start(startPoint, endPoint)
	if not endPoint then endPoint = #problems end
	for i = startPoint, endPoint do
		self.countNumbers()
	end
end

function Solver:draw()

end

function Solver:update(dt)

end

return Solver