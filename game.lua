local boardCellsMain = require("boardcellsmain")
local boardCellsTop  = require("boardcellstop")
local boardCellsLeft = require("boardcellsleft")

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

-- function Game:createRowNumbers(problem)
-- 	local count = 0
-- 	for i = 1, #problems[problem] do
-- 		for j = 1, #problems[problem][i] do
-- 			if j == 1 then
-- 				table.insert(numbersPerRow, {})
-- 			end
-- 			if problems[problem][i][j] == 1 then
-- 				count = count + 1
-- 			end
-- 			if problems[problem][i][j] == 0 and count > 0 then
-- 				table.insert(numbersPerRow[i], count)
-- 				count = 0
-- 			end
-- 			if j == #problems[problem][i] and count > 0 then
-- 				table.insert(numbersPerRow[i], count)
-- 				count = 0
-- 			end
-- 		end
-- 	end
-- end

-- function Game:createColumnNumbers(problem)
-- 	local count = 0
-- 	for i = 1, #problems[problem][1] do
-- 		for j = 1, #problems[problem] do
-- 			if j == 1 then
-- 				table.insert(numbersPerColumn, {})
-- 			end
-- 			if problems[problem][j][i] == 1 then
-- 				count = count + 1
-- 			end
-- 			if problems[problem][j][i] == 0 and count > 0 then
-- 				table.insert(numbersPerColumn[i], count)
-- 				count = 0
-- 			end
-- 			if j == #problems[problem] and count > 0 then
-- 				table.insert(numbersPerColumn[i], count)
-- 				count = 0
-- 			end
-- 		end
-- 	end
-- end

-- Game:createRowNumbers(problem)
-- Game:createColumnNumbers(problem)

function Game:draw()
	boardCellsTop:draw()
	boardCellsLeft:draw()
	boardCellsMain:draw()
end

function Game:update(dt)
	boardCellsTop:update(dt)
	boardCellsLeft:update(dt)
	boardCellsMain:update(dt)
end

function Game:mousepressed(x,y,button,istouch,presses)

end

function Game:mousereleased(x,y,button,istouch,presses)
	boardCellsTop:mousereleased(x,y,button,istouch,presses)
	boardCellsLeft:mousereleased(x,y,button,istouch,presses)
	boardCellsMain:mousereleased(x,y,button,istouch,presses)
end

return Game