local newButton      = require("button")
local s              = require("settings")
local boardCellsMain = require("board_cells_main")

local GameButtons = {}

GameButtons.buttons = {}

local buttonNames = {
	{name = "Validate", func = boardCellsMain.validateCells},
	{name = "Clear", func = boardCellsMain.clear},
	{name = "Next", func = print("")},
	{name = "Prev", func = print("")},
	{name = "Hint", func = print("")},
	{name = "Menu", func = print("")},
}

function GameButtons:load()
	self:generateButtons()
end

function GameButtons:generateButtons()
	local x = s.button.padding
	local y = s.wh - (s.button.padding + s.button.height)
	for i = 1, #buttonNames do
		GameButtons.buttons[i] = newButton.new({x = x, y = y, width = s.button.width, height = s.button.height, text = buttonNames[i]["name"], func = buttonNames[i]["func"], id = i})
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

return GameButtons