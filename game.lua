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

local nPerRow = {}
local nPerColumn = {}

local cells = {}
local cellSize = (wh -200) / 10
local rows = 15
local column = 10
local cell_x = (ww - (rows * cellSize)) / 2
local cell_y = (wh - (column * cellSize)) / 2

function Game:generateCells(r, c)
	local start_x = cell_x
	for j = 1, c do
		table.insert(cells, {})
		for i = 1, r do
			table.insert(cells[j], cell.new({x = cell_x, y = cell_y, width = cellSize, height = cellSize}))
			cell_x = cell_x + cellSize
			if i == r then
				cell_x = start_x
			end
		end
		cell_y = cell_y + cellSize
	end
end

Game:generateCells(#problems[problem][1], #problems[problem])

function Game:CheckRow(prob, row, index)
	if cells[row][index].marked and problems[prob][row][index] == 1 then
		return true
	end
end

function Game:createRowNumbers(prob)
	local count = 0
	local row = 1
	for i = 1, #problems[prob] do
		for j = 1, #problems[prob][i] do
			if j == 1 then
				table.insert(nPerRow, {})
			end
			if problems[prob][i][j] == 1 then
				count = count + 1
			end
			if problems[prob][i][j] == 0 and count > 0 then
				table.insert(nPerRow[row], count)
				count = 0
			end
			if j == #problems[prob][i] then
				row = row + 1
			end
		end
	end
end

Game:createRowNumbers(problem)
print(tprint(nPerRow))

function Game:draw()
	for i = 1, #cells do
		for j = 1, #cells[i] do
			cells[i][j]:draw()
		end
	end
end

function Game:update(dt)
	for i = 1, #cells do
		for j = 1, #cells[i]do
			local c = cells[i][j]
			c:update(dt)
			if self:CheckRow(problem, i, j) then

			end
		end
	end
end

function Game:mousepressed(x,y,button,istouch,presses)

end

function Game:mousereleased(x,y,button,istouch,presses)
	for i = 1, #cells do
		for j = 1, #cells[i] do
			cells[i][j].setCell = false
		end
	end
end

return Game