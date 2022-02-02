local newButton      = require("button")
local s              = require("settings")
local boardCellsMain = require("board_cells_main")
local boardCellsTop  = require("board_cells_top")
local boardCellsLeft = require("board_cells_left")
local state          = require("state")
local lib            = require("lib")
local problems       = require("problems")

local GameButtons = {}

GameButtons.buttons = {}

local function clearCells()
	lib:clearCells(boardCellsLeft.numberCellsLeft)
	lib:clearCells(boardCellsMain.boardCells)
	lib:clearCells(boardCellsTop.numberCellsTop)
end

local function nextProblem()
	if #problems == s.problem then
		s.problem = 1
		state.setScene("game")
	else
		s.problem = s.problem + 1
		state.setScene("game")
	end
end

local function previousProblem()
	if 1 == s.problem then
		s.problem = #problems
		state.setScene("game")
	else
		s.problem = s.problem - 1
		state.setScene("game")
	end
end

local buttonList = {
	{name = "Validate", func = boardCellsMain.validateCells},
	{name = "Clear", func = clearCells},
	{name = "Prev", func = previousProblem},
	{name = "Next", func = nextProblem},
	{name = "Hint", func = nil},
	{name = "Menu", func = state.setScene, argument = "menu_main"},
}

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

function GameButtons:clearBoard()

end

function GameButtons:draw()
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:draw()
	end
end

function GameButtons:update(dt)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:update(dt)
	end
end

function GameButtons:mousepressed(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
end

function GameButtons:mousereleased(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
end

return GameButtons