local s               = require("settings")
local boardDimensions = require("board_dimensions")
local boardNumbers    = require("board_numbers")
local boardMain       = require("board_main")
local boardTop        = require("board_top")
local boardLeft       = require("board_left")
local gameButtons     = require("game_buttons")
local solver          = require("solver")
local TSerial         = require("TSerial")
local lib             = require("lib")

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

function Game.writeSaveData()
	local data = {main = {}, left = {}, top = {}}
	for i, rows in ipairs(boardMain.cells) do
		data.main[i] = {}
		for _, cell in ipairs(rows) do
			if cell.state then
				table.insert(data.main[i], cell.state)
			end
		end
	end
	for i, rows in ipairs(boardLeft.cells) do
		data.left[i] = {}
		for _, cell in ipairs(rows) do
			if cell.state then
				table.insert(data.left[i], cell.state)
			end
		end
	end
	for i, rows in ipairs(boardTop.cells) do
		data.top[i] = {}
		for _, cell in ipairs(rows) do
			if cell.state then
				table.insert(data.top[i], cell.state)
			end
		end
	end
	love.filesystem.write(s.problem..".dat", TSerial.pack(data, drop, true))
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

	if lib.onBoard(
		x,
		y,
		boardDimensions.mainX,
		boardDimensions.mainY,
		boardDimensions.mainWidth + boardDimensions.mainX,
		boardDimensions.mainHeight + boardDimensions.mainY
	)
	or
	lib.onBoard(
		x,
		y,
		boardDimensions.leftX,
		boardDimensions.leftY,
		boardDimensions.leftWidth + boardDimensions.leftX,
		boardDimensions.leftHeight + boardDimensions.leftY
	)
	or
	lib.onBoard(
		x,
		y,
		boardDimensions.topX,
		boardDimensions.topY,
		boardDimensions.topWidth + boardDimensions.topX,
		boardDimensions.topHeight + boardDimensions.topY
		)
	then
		Game.writeSaveData()
	end
end

return Game