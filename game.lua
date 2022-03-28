local s               = require("settings")
local boardDimensions = require("board_dimensions")
local boardNumbers    = require("board_numbers")
local boardMain       = require("board_main")
local boardTop        = require("board_top")
local boardLeft       = require("board_left")
local gameButtons     = require("game_buttons")
local solver          = require("solver")
local TSerial         = require("TSerial")

local Game = {}

function Game:load()
	boardDimensions:load()
	boardNumbers:load()
	boardLeft:load()
	boardTop:load()
	boardMain:load()
	gameButtons:load()
	boardMain:markAllTheThings()
end

function Game:draw()
	love.graphics.setFont(ProblemNumber)
	love.graphics.setColor(0,1,0)
	love.graphics.print(s.problem, 10,10)
	love.graphics.setFont(Default)
	boardLeft:draw()
	boardTop:draw()
	boardMain:draw()
	boardNumbers:draw()
	gameButtons:draw()
	solver:draw()
end

function Game:update(dt)
	boardLeft:update(dt)
	boardTop:update(dt)
	boardMain:update(dt)
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

function Game:keyreleased(key,scancode)
	boardMain:keyreleased(key,scancode)
end

function Game:mousepressed(x,y,button,istouch,presses)
	boardMain:mousepressed(x,y,button,istouch,presses)
	gameButtons:mousepressed(x,y,button,istouch,presses)
end

function Game:mousereleased(x,y,button,istouch,presses)
	boardLeft:mousereleased(x,y,button,istouch,presses)
	boardTop:mousereleased(x,y,button,istouch,presses)
	boardMain:mousereleased(x,y,button,istouch,presses)
	gameButtons:mousereleased(x,y,button,istouch,presses)
end

return Game