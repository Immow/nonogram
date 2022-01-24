local newButton      = require("button")
local s              = require("settings")
local boardCellsMain = require("boardCellsMain")

local GameButtons = {}

GameButtons.buttons = {}

local buttonNames = {
	-- {name = "Validate", func = function() boardCellsMain:validateCells() end},
	{name = "Clear", func = function() boardCellsMain:clear() end},
	-- {name = "Next", func = ""},
	-- {name = "Prev", func = ""},
	-- {name = "Hint", func = ""},
	-- {name = "Menu", func = ""},
}

function GameButtons:load()
	self:generateButtons(buttonNames)
end

function GameButtons:generateButtons(table)
	local x = s.button.padding
	local y = s.wh - (s.button.padding + s.button.height)
	for i = 1, #table do
		GameButtons.buttons[i] = newButton.new({x = x, y = y, width = s.button.width, height = s.button.height, text = table[i]["name"], func = table[i]["func"]})
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