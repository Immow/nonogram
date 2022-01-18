local cell = require("cell")
local problems = require("problems")

-- FUNCTION TO PRINT TABLES
function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

local Game = {}
local ww, wh = love.graphics.getDimensions()
local problem = 1
local cellSize = (wh -200) / 10

local numbersPerRow = {}
local numbersPerColumn = {}

local numberCellsLeft = {}
local numberCellsLeft_x = 0
local numberCellsLeft_y = cellSize * math.ceil(#problems[problem] / 2)

local numberCellsTop = {}
local numberCellsTop_x = cellSize * math.ceil(#problems[problem][1] / 2)
local numberCellsTop_y = 0

local boardCells = {}
local boardCells_x = numberCellsTop_x
local boardCells_y = numberCellsLeft_y

function Game:generateBoardCells(r, c)
	local start_x = boardCells_x
	for j = 1, c do
		table.insert(boardCells, {})
		for i = 1, r do
			table.insert(boardCells[j], cell.new({x = boardCells_x, y = boardCells_y, width = cellSize, height = cellSize, id = "board"}))
			boardCells_x = boardCells_x + cellSize
			if i == r then
				boardCells_x = start_x
			end
		end
		boardCells_y = boardCells_y + cellSize
	end
end

Game:generateBoardCells(#problems[problem][1], #problems[problem])

function Game:generateNumberCellsLeft(r, c)
	local start_x = numberCellsLeft_x
	for j = 1, c do
		table.insert(numberCellsLeft, {})
		for i = 1, r do
			table.insert(numberCellsLeft[j], cell.new({x = numberCellsLeft_x, y = numberCellsLeft_y, width = cellSize, height = cellSize, id = "number"}))
			numberCellsLeft_x = numberCellsLeft_x + cellSize
			if i == r then
				numberCellsLeft_x = start_x
			end
		end
		numberCellsLeft_y = numberCellsLeft_y + cellSize
	end
end

Game:generateNumberCellsLeft(math.ceil(#problems[problem][1] / 2), #problems[problem])

function Game:generateNumberCellsTop(r, c)
	local start_x = numberCellsTop_x
	for j = 1, c do
		table.insert(numberCellsTop, {})
		for i = 1, r do
			table.insert(numberCellsTop[j], cell.new({x = numberCellsTop_x, y = numberCellsTop_y, width = cellSize, height = cellSize, id = "number"}))
			numberCellsTop_x = numberCellsTop_x + cellSize
			if i == r then
				numberCellsTop_x = start_x
			end
		end
		numberCellsTop_y = numberCellsTop_y + cellSize
	end
end

Game:generateNumberCellsTop(#problems[problem][1], math.ceil(#problems[problem] / 2))

function Game:CheckRow(prob, row, index)
	if boardCells[row][index].marked and problems[prob][row][index] == 1 then
		return true
	end
end

function Game:createRowNumbers(problem)
	local count = 0
	for i = 1, #problems[problem] do
		for j = 1, #problems[problem][i] do
			if j == 1 then
				table.insert(numbersPerRow, {})
			end
			if problems[problem][i][j] == 1 then
				count = count + 1
			end
			if problems[problem][i][j] == 0 and count > 0 then
				table.insert(numbersPerRow[i], count)
				count = 0
			end
			if j == #problems[problem][i] and count > 0 then
				table.insert(numbersPerRow[i], count)
				count = 0
			end
		end
	end
end

function Game:createColumnNumbers(problem)
	local count = 0
	for i = 1, #problems[problem][1] do
		for j = 1, #problems[problem] do
			if j == 1 then
				table.insert(numbersPerColumn, {})
			end
			if problems[problem][j][i] == 1 then
				count = count + 1
			end
			if problems[problem][j][i] == 0 and count > 0 then
				table.insert(numbersPerColumn[i], count)
				count = 0
			end
			if j == #problems[problem] and count > 0 then
				table.insert(numbersPerColumn[i], count)
				count = 0
			end
		end
	end
end

Game:createRowNumbers(problem)
Game:createColumnNumbers(problem)

function Game:draw()
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			boardCells[i][j]:draw()
		end
	end

	for i = 1, #numberCellsLeft do
		for j = 1, #numberCellsLeft[i] do
			numberCellsLeft[i][j]:draw()
		end
	end

	for i = 1, #numberCellsTop do
		for j = 1, #numberCellsTop[i] do
			numberCellsTop[i][j]:draw()
		end
	end
end

function Game:update(dt)
	for i = 1, #boardCells do
		for j = 1, #boardCells[i]do
			boardCells[i][j]:update(dt)
		end
	end
end

function Game:mousepressed(x,y,button,istouch,presses)

end

function Game:mousereleased(x,y,button,istouch,presses)
	for i = 1, #boardCells do
		for j = 1, #boardCells[i] do
			boardCells[i][j].setCell = false
		end
	end
end

return Game