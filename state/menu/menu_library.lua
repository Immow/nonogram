local newButton   = require("constructors.button")
local state       = require("state.state")
local row         = require("constructors.row")
local icon        = require("icon")

local Library = {}
Library.buttons = {}

local buttonList = {
	{name = "Back", func = state.setScene, argument = "state.menu.menu_main"},
}

local startPosition = 100
local rowWidth = 500
local centerRow = Settings.ww / 2 - rowWidth / 2
local rowHeight = 46
local function get_y_position(position)
	if position == 1 then return startPosition end
	local offset = 4
	local y = position * rowHeight + (offset * (position - 1)) + startPosition - rowHeight
	return y
end

local rows = {
	row.new({x = centerRow, y = get_y_position(1), width = rowWidth, height = rowHeight, color = Colors.black}),
}

local icons = {
	icon.new({x = rows[2].x, y = rows[2].y, parrent_width = rows[2].width , parrent_height = rowHeight, bool = "markAndCross"}),
}

function Library:load()
	self:generateButtons()
end

function Library:generateButtons()
	local x = Settings.ww - (Settings.button.width + Settings.button.padding)
	local y = Settings.wh - (Settings.button.height + Settings.button.padding)
	for i = 1, #buttonList do
		Library.buttons[i] = newButton.new({
			x = x,
			y = y, width = Settings.button.width,
			height = Settings.button.height,
			text = buttonList[i]["name"],
			func = buttonList[i]["func"],
			font = ButtonFont,
			argument = buttonList[i]["argument"],
		})
		y = y + Settings.button.height + Settings.button.padding
	end
end

function Library:draw()
	for i = 1, #rows do
		rows[i]:draw()
	end

	for i = 1, #Library.buttons do
		Library.buttons[i]:draw()
	end

	for i = 1, #icon do
		icon[i]:draw()
	end
end

function Library:update(dt)
	for i = 1, #Library.buttons do
		Library.buttons[i]:update(dt)
	end
end

function Library:mousepressed(x,y,button,istouch,presses)
	for i = 1, #Library.buttons do
		Library.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
end

function Library:mousereleased(x,y,button,istouch,presses)
	for i = 1, #Library.buttons do
		Library.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
end

return Library