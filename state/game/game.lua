local boardDimensions   = require("state.game.board_dimensions")
local boardNumbers      = require("state.game.board_numbers")
local boardMain         = require("state.game.board_main")
local boardTop          = require("state.game.board_top")
local boardLeft         = require("state.game.board_left")
local gameButtons       = require("state.game.game_buttons")
-- local solver            = require("solver")
local time              = require("state.game.time")
local gameNumber        = require("state.game.game_number")
local winAnimation      = require("state.game.win_animation")

local Game = {}

function Game:load()
	boardDimensions:load()
	boardNumbers:load()
	boardLeft:load()
	boardTop:load()
	boardMain:load()
	gameButtons:load()
	boardMain:markAllTheThings()
	time:load()
	gameNumber:load()
end

function WriteSaveData()
	local data = {
		main = Lib.copyCellState(boardMain.cells),
		left = Lib.copyCellState(boardLeft.cells),
		top = Lib.copyCellState(boardTop.cells),
	}
	
	Lib.writeData("game_saves/"..Settings.problemNr..".dat", data)
	
	local gameSettings = Lib.saveDataList()
	Lib.writeData("config.cfg", gameSettings)

	if Settings.game.state[Settings.problemNr] == "solved" then -- is the puzzle solved
		Settings.game.state[Settings.problemNr] = "solved"
		Lib.writeData("game.dat", Settings.game)
	else
		Settings.game.state[Settings.problemNr] = "pending"
		Lib.writeData("game.dat", Settings.game)
	end
end

function Game:draw()
	boardLeft:draw()
	boardTop:draw()
	boardMain:draw()
	boardNumbers:draw()
	gameButtons:draw()
	gameNumber:draw()
	time:draw()
	-- solver:draw()
end

function Game:update(dt)
	boardLeft:update(dt)
	boardTop:update(dt)
	boardMain:update(dt)
	gameButtons:update(dt)
	time:update(dt)
	winAnimation:update(dt)
	-- solver:update(dt)
end

function Game:keypressed(key,scancode,isrepeat)
	-- if key == "space" then
	-- 	solver:start(1,1)
	-- end
	if key == "space" then
		Settings.game.displayWinAnimation[Settings.problemNr] = true
		Settings.game.state[Settings.problemNr] = "pending"
		for i = 1, #boardMain.cells do
			for j = 1, #boardMain.cells[i] do
				boardMain.cells[i][j]:resetCrossPosition()
			end
		end
	end

	-- if key == "kp+" then
	-- 	if Settings.cellSize < 100 then
	-- 		Settings.cellSize = Settings.cellSize + 1
	-- 		self:load()
	-- 	end
	-- end

	-- if key == "kp-" then
	-- 	if Settings.cellSize > 5 then
	-- 		Settings.cellSize = Settings.cellSize - 1
	-- 		self:load()
	-- 	end
	-- end

	-- solver:keypressed(key,scancode,isrepeat)
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

	WriteSaveData()
	winAnimation:mousereleased(x,y,button,istouch,presses)
end

return Game