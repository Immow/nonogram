local newButton = require("constructors.button")
local boardMain = require("state.game.board_main")
local boardTop  = require("state.game.board_top")
local boardLeft = require("state.game.board_left")
local problems  = require("problems")
local time      = require("state.game.time")
local hint      = require("constructors.hint")

local GameButtons = {}

GameButtons.buttons = {}

local function clearCells()
	Lib:clearCells(boardLeft.cells)
	Lib:clearCells(boardMain.cells)
	Lib:clearCells(boardTop.cells)
	Settings.gamesState.state[Settings.problemNr] = "new"
	Settings.gamesState.displayWinAnimation[Settings.problemNr] = true
	time:stop()
	time.reset()
	Lib:writeData("game.dat", Settings.gamesState)
	for i = 1, #boardMain.cells do
		for j = 1, #boardMain.cells[i] do
			boardMain.cells[i][j]:resetCrossPosition()
		end
	end
end

local function nextProblem()
	if #problems == Settings.problemNr then
		Settings.problemNr = 1
	else
		Settings.problemNr = Settings.problemNr + 1
	end
	State.setScene("state.game.game")
	Lib:writeData("config.cfg", Lib.saveDataList())
	Lib:writeData("game.dat", Settings.gamesState)
	hint.purge()
	time:stop()
end

local function previousProblem()
	if 1 == Settings.problemNr then
		Settings.problemNr = #problems
	else
		Settings.problemNr = Settings.problemNr - 1
	end
	State.setScene("state.game.game")
	local data = Lib.saveDataList()
	Lib:writeData("config.cfg", data)
	Lib:writeData("game.dat", Settings.gamesState)
	hint.purge()
	time:stop()
end

local function mainMenu()
	State.setScene("state.menu.menu_main")
	time:stop()
	Lib:writeData("game.dat", Settings.gamesState)
end

local function winningState()
	Settings.gamesState.displayWinAnimation[Settings.problemNr] = false
	Lib:writeData("game.dat", Settings.gamesState)
end

local function hintButton()
	hint.new(2)
	time:start()
end

local buttonList = {
	{name = "Validate", func = boardMain.validateCells},
	{name = "Clear", func = clearCells},
	{name = "Prev", func = previousProblem},
	{name = "Next", func = nextProblem},
	{name = "Hint", func = hintButton},
	{name = "Menu", func = mainMenu},
}

-- local winButtonList = {
-- 	name = "You win!",
-- 	func = winningState,
-- 	argument = nil,
-- 	x = Settings.ww / 2 - Settings.button.width / 2,
-- 	y = Settings.wh / 2 - Settings.button.height / 2,
-- }

-- local winButton = newButton.new({x = winButtonList.x, y = winButtonList.y, width = Settings.button.width, height = Settings.button.height, text = winButtonList["name"], func = winButtonList["func"], font = ButtonFont, argument = winButtonList["argument"]})

function GameButtons:load()
	self:generateButtons()
end

function GameButtons:generateButtons()
	local x = Settings.button.padding
	local y = Settings.wh - (Settings.button.padding + Settings.button.height)
	for i = 1, #buttonList do
		GameButtons.buttons[i] = newButton.new({x = x, y = y, width = Settings.button.width, height = Settings.button.height, text = buttonList[i]["name"], func = buttonList[i]["func"], font = ButtonFont, argument = buttonList[i]["argument"]})
		x = x + Settings.button.width + Settings.button.padding
	end
end

function GameButtons:draw()
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:draw()
	end

	-- if Settings.gamesState.state[Settings.problemNr] == "solved" and Settings.gamesState.displayWinAnimation[Settings.problemNr] then
	-- 	winButton:draw()
	-- end

	hint.drawAll()
end

function GameButtons:update(dt)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:update(dt)
	end

	-- if Settings.gamesState.state[Settings.problemNr] == "solved" and Settings.gamesState.displayWinAnimation[Settings.problemNr] then
	-- 	winButton:update(dt)
	-- end

	hint.updateAll(dt)
end

function GameButtons:mousepressed(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end

	-- if Settings.gamesState.state[Settings.problemNr] == "solved" and Settings.gamesState.displayWinAnimation[Settings.problemNr] then
	-- 	winButton:mousepressed(x,y,button,istouch,presses)
	-- end
end

function GameButtons:mousereleased(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end

	-- if Settings.gamesState.state[Settings.problemNr] == "solved" and Settings.gamesState.displayWinAnimation[Settings.problemNr] then
	-- 	winButton:mousereleased(x,y,button,istouch,presses)
	-- end
end

return GameButtons