local boardNumbers = require("boardnumbers")
local boardCellsMain = require("boardcellsmain")
local boardCellsTop  = require("boardcellstop")
local boardCellsLeft = require("boardcellsleft")
local boardNumbersLeft = require("boardnumbersleft")
local boardNumbersTop = require("boardnumberstop")
local problems = require("problems")
local s = require("settings")

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

function Game:load()
	boardNumbers:createRowNumbers()
	boardNumbers:createColumnNumbers()
	boardNumbers:setMostNumbers()
	boardNumbers:setX()
	boardNumbers:setY()
	boardNumbers:setNumberPositionsRow()
	boardNumbers:setNumberPositionsColumn()
	boardCellsLeft:generateNumberCellsLeft(boardNumbers.maxNumbersRow, #problems[s.problem])
	boardCellsTop:generateNumberCellsTop(#problems[s.problem][1], boardNumbers.maxNumbersColumn)
	boardCellsMain:generateBoardCells(#problems[s.problem][1], #problems[s.problem])
-- 	boardNumbersLeft:createRowNumbers(s.problem)
-- 	boardNumbersLeft:setNumberPositions()
-- 	boardNumbersTop:createColumnNumbers(s.problem)
-- 	boardNumbersTop:setNumberPositions()
end

function Game:draw()
	boardNumbers:draw()
	boardCellsTop:draw()
	boardCellsLeft:draw()
	boardCellsMain:draw()
	-- boardNumbersLeft:draw()
	-- boardNumbersTop:draw()
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