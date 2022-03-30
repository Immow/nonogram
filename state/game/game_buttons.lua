local newButton = require("constructors.button")
local s         = require("settings")
local boardMain = require("state.game.board_main")
local boardTop  = require("state.game.board_top")
local boardLeft = require("state.game.board_left")
local state     = require("state.state")
local lib       = require("libs.lib")
local problems  = require("problems")

local GameButtons = {}

GameButtons.buttons = {}

local function clearCells()
	lib:clearCells(boardLeft.cells)
	lib:clearCells(boardMain.cells)
	lib:clearCells(boardTop.cells)
end

local function nextProblem()
	if #problems == s.problem then
		s.problem = 1
		state.setScene("state.game.game")
	else
		s.problem = s.problem + 1
		state.setScene("state.game.game")
	end
end

local function previousProblem()
	if 1 == s.problem then
		s.problem = #problems
		state.setScene("state.game.game")
	else
		s.problem = s.problem - 1
		state.setScene("state.game.game")
	end
end

local function winningState()
	boardMain.winningState = false
end

local buttonList = {
	{name = "Validate", func = boardMain.validateCells},
	{name = "Clear", func = clearCells},
	{name = "Prev", func = previousProblem},
	{name = "Next", func = nextProblem},
	{name = "Hint", func = nil},
	{name = "Menu", func = state.setScene, argument = "state.menu.menu_main"},
}

local winButtonList = {
	name = "You win!",
	func = winningState,
	argument = nil,
	x = s.ww / 2 - s.button.width / 2,
	y = s.wh / 2 - s.button.height / 2,
}

local winButton = newButton.new({x = winButtonList.x, y = winButtonList.y, width = s.button.width, height = s.button.height, text = winButtonList["name"], func = winButtonList["func"], font = ButtonFont, argument = winButtonList["argument"]})

function GameButtons:load()
	self:generateButtons()
end

function GameButtons:generateButtons()
	local x = s.button.padding
	local y = s.wh - (s.button.padding + s.button.height)
	for i = 1, #buttonList do
		GameButtons.buttons[i] = newButton.new({x = x, y = y, width = s.button.width, height = s.button.height, text = buttonList[i]["name"], func = buttonList[i]["func"], font = ButtonFont, argument = buttonList[i]["argument"]})
		x = x + s.button.width + s.button.padding
	end
end

function GameButtons:draw()
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:draw()
	end

	if boardMain.winningState then
		winButton:draw()
	end
end

function GameButtons:update(dt)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:update(dt)
	end

	if boardMain.winningState then
		winButton:update(dt)
	end
end

function GameButtons:mousepressed(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end

	if boardMain.winningState then
		winButton:mousepressed(x,y,button,istouch,presses)
	end
end

function GameButtons:mousereleased(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end

	if boardMain.winningState then
		winButton:mousereleased(x,y,button,istouch,presses)
	end
end

return GameButtons