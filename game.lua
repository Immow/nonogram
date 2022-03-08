local s              = require("settings")
local problems       = require("problems")
local boardNumbers   = require("board_numbers")
local boardCellsMain = require("board_cells_main")
local boardCellsTop  = require("board_cells_top")
local boardCellsLeft = require("board_cells_left")
local gameButtons    = require("game_buttons")
local boardDimensions = require("board_dimensions")
local solver = require("solver")

local Game = {}

function Game:load()
	boardDimensions:load()
	boardNumbers:load()
	boardCellsLeft:generateNumberCellsLeft(boardDimensions.maxNumbersLeft, #problems[s.problem])
	boardCellsTop:generateNumberCellsTop(#problems[s.problem][1], boardDimensions.maxNumbersTop)
	boardCellsMain:load()
	gameButtons:load()
end

function Game:draw()
	love.graphics.setFont(ProblemNumber)
	love.graphics.setColor(0,1,0)
	love.graphics.print(s.problem, 10,10)
	love.graphics.setFont(Default)
	boardCellsLeft:draw()
	boardCellsTop:draw()
	boardCellsMain:draw()
	boardNumbers:draw()
	gameButtons:draw()
	solver:draw()
end

function Game:update(dt)
	boardCellsLeft:update(dt)
	boardCellsTop:update(dt)
	boardCellsMain:update(dt)
	gameButtons:update(dt)
	solver:update(dt)
end

function Game:keypressed(key,scancode,isrepeat)
	if key == "space" then
		solver:start(1,1)
	end

	if key == "kp+" then
		if s.cellSize < 100 then
			s.cellSize = s.cellSize + 1
			self:load()
		end
	end

	if key == "kp-" then
		if s.cellSize > 5 then
			s.cellSize = s.cellSize - 1
			self:load()
		end
	end
	solver:keypressed(key,scancode,isrepeat)
end

function Game:mousepressed(x,y,button,istouch,presses)
	boardCellsMain:mousepressed(x,y,button,istouch,presses)
	gameButtons:mousepressed(x,y,button,istouch,presses)
	boardCellsTop:mousepressed(x,y,button,istouch,presses)
end

function Game:mousereleased(x,y,button,istouch,presses)
	boardCellsLeft:mousereleased(x,y,button,istouch,presses)
	boardCellsTop:mousereleased(x,y,button,istouch,presses)
	boardCellsMain:mousereleased(x,y,button,istouch,presses)
	gameButtons:mousereleased(x,y,button,istouch,presses)
end

return Game