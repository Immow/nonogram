local boardDimensions = require("state.game.board_dimensions")
local boardNumbers    = require("state.game.board_numbers")
local boardMain       = require("state.game.board_main")
local boardTop        = require("state.game.board_top")
local boardLeft       = require("state.game.board_left")
local gameButtons     = require("state.game.game_buttons")
local solver          = require("solver")
local time            = require("state.game.time")

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
end

function WriteSaveData()
	local data = {
		main = Lib.copyCellState(boardMain.cells),
		left = Lib.copyCellState(boardLeft.cells),
		top = Lib.copyCellState(boardTop.cells),
	}

	local gameSettings = Lib.saveDataList()

	Lib:writeData(Settings.problemNr..".dat", data)
	Lib:writeData("config.cfg", gameSettings)

	if Settings.gamesState.state[Settings.problemNr] == "solved" then -- is the puzzle solved
		Settings.gamesState.state[Settings.problemNr] = "solved"
		Lib:writeData("game.dat", Settings.gamesState)
	else
		Settings.gamesState.state[Settings.problemNr] = "pending"
		Lib:writeData("game.dat", Settings.gamesState)
	end
end

function Game.drawBoardNumber()
	love.graphics.setFont(ProblemNumber)
	love.graphics.setColor(0,1,0)
	love.graphics.print(Settings.problemNr, 10,10)
	love.graphics.setFont(Default)
end

function Game:draw()
	self.drawBoardNumber()
	boardLeft:draw()
	boardTop:draw()
	boardMain:draw()
	boardNumbers:draw()
	gameButtons:draw()
	time:draw(10, 10 + ProblemNumber:getHeight())
	-- solver:draw()
end

function Game:update(dt)
	boardLeft:update(dt)
	boardTop:update(dt)
	boardMain:update(dt)
	gameButtons:update(dt)
	time:update(dt)
	-- solver:update(dt)
end

function Game:keypressed(key,scancode,isrepeat)
	-- if key == "space" then
	-- 	solver:start(1,1)
	-- end

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

	if Lib.onBoard(
			x, y, boardDimensions.mainX, boardDimensions.mainY,
			boardDimensions.mainWidth + boardDimensions.mainX,
			boardDimensions.mainHeight + boardDimensions.mainY
		)
	or
		Lib.onBoard(
			x, y, boardDimensions.leftX, boardDimensions.leftY,
			boardDimensions.leftWidth + boardDimensions.leftX,
			boardDimensions.leftHeight + boardDimensions.leftY
		)
	or
		Lib.onBoard(
			x, y, boardDimensions.topX,	boardDimensions.topY,
			boardDimensions.topWidth + boardDimensions.topX,
			boardDimensions.topHeight + boardDimensions.topY
		)
	then
		WriteSaveData()
		time:start()
	end
end

return Game