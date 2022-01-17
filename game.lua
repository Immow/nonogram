local cell = require("cell")

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

local cells = {}
local sellSize = (wh -200) / 10
local rows = 15
local column = 10
local cell_x = (ww - (rows * sellSize)) / 2
local cell_y = (wh - (column * sellSize)) / 2

function Game:generateCells(r, c)
	local start_x = cell_x
	for j = 1, c do
		for i = 1, r do
			table.insert(cells, cell.new({x = cell_x, y = cell_y, width = sellSize, height = sellSize}))
			cell_x = cell_x + sellSize
			if i == r then
				cell_x = start_x
			end
		end
		cell_y = cell_y + sellSize
	end
end

Game:generateCells(rows, column)

function Game:draw()
	for i = 1, #cells do
		cells[i]:draw()
	end
end

function Game:update(dt)
	for i = 1, #cells do
		cells[i]:update(dt)
	end
end

function Game:mousepressed(x,y,button,istouch,presses)

end

function Game:mousereleased(x,y,button,istouch,presses)
	for i = 1, #cells do
		cells[i].setCell = false
	end
end

return Game