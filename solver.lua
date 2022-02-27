local s              = require("settings")
local problems       = require("problems")
local boardNumbers   = require("board_numbers")
local boardCellsMain = require("board_cells_main")
local boardCellsTop  = require("board_cells_top")
local boardCellsLeft = require("board_cells_left")
local boardDimensions = require("board_dimensions")

local Solver = {}
Solver.results = {}

function Solver:markRow(count, i)
	print("Solving row: "..i)
	local index = #boardDimensions.resultLeft[i]
	local chunkIndex = 1
	local difference = #problems[s.problem][1] - count
	if difference == 0 then
		local number = boardDimensions.resultLeft[i][index] -- select the left most number
		for j = 1, #boardCellsMain.boardCells[i] do
			if chunkIndex <= number then
				boardCellsMain.boardCells[i][j]:markCellSolver()
			end
			
			if chunkIndex > number then
				index = index - 1
				number = boardDimensions.resultLeft[i][index]
				chunkIndex = 1
				boardCellsMain.boardCells[i][j]:crossCell()
				print("itteration: "..j.." marking line")
			else
				chunkIndex = chunkIndex + 1
			end
		end
	else
		local number = boardDimensions.resultLeft[i][index] -- select the left most number
		for j = 1, #boardCellsMain.boardCells[i] do

			if chunkIndex > difference and number - chunkIndex >= 0 and number > difference then
				print("itteration: "..j.." marking cell: "..boardCellsMain.boardCells[i][j].position[1]..", "..boardCellsMain.boardCells[i][j].position[2])
				boardCellsMain.boardCells[i][j]:markCellSolver()
			end

			if chunkIndex > number + 1 and index > 1 then
				index = index - 1
				number = boardDimensions.resultLeft[i][index]
				chunkIndex = 1
			end
			chunkIndex = chunkIndex + 1
		end
	end
end

function Solver:markColumn(count, i)
	print("Solving column: "..i)
	local index = #boardDimensions.resultTop[i]
	local chunkIndex = 1
	local difference = #problems[s.problem] - count
	if difference == 0 then
		local number = boardDimensions.resultTop[i][index] -- select the left most number
		for j = 1, #boardCellsMain.boardCells do
			if chunkIndex <= number then
				boardCellsMain.boardCells[j][i]:markCellSolver()
			end
			
			if chunkIndex > number then
				index = index - 1
				number = boardDimensions.resultTop[i][index]
				chunkIndex = 1
				boardCellsMain.boardCells[j][i]:crossCell()
				print("itteration: "..j.." marking line")
			else
				chunkIndex = chunkIndex + 1
			end
		end
	else
		local number = boardDimensions.resultTop[i][index] -- select the left most number
		for j = 1, #boardCellsMain.boardCells do

			if chunkIndex > difference and number - chunkIndex >= 0 and number > difference then
				print("itteration: "..j.." marking cell: "..boardCellsMain.boardCells[j][i].position[1]..", "..boardCellsMain.boardCells[j][i].position[2])
				boardCellsMain.boardCells[j][i]:markCellSolver()
			end

			if chunkIndex > number + 1 and index > 1 then
				index = index - 1
				number = boardDimensions.resultTop[i][index]
				chunkIndex = 1
			end
			chunkIndex = chunkIndex + 1
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
		Solver:markRow(count, i)
		count = 0
	end

	for i = 1, #boardDimensions.resultTop do
		for j = 1, #boardDimensions.resultTop[i] do
			if boardDimensions.resultTop[i][j] then
				count = count + boardDimensions.resultTop[i][j]
				if j > 1 then count = count + 1 end
			end
		end
		Solver:markColumn(count, i)
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