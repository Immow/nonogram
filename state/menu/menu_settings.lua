local newButton   = require("constructors.button")
local state       = require("state.state")
local row         = require("constructors.row")
local text        = require("constructors.text")
local radioButton = require("constructors.radio_button")

local MenuSettings = {}
MenuSettings.buttons = {}

local buttonList = {
	{name = "Back", func = state.setScene, argument = "state.menu.menu_main"},
}

local mute = love.graphics.newImage("assets/icons/mute.png")
local audio = love.graphics.newImage("assets/icons/audio.png")

local startPosition = 100
local centerRow = Settings.ww / 2 - 500 / 2
local rowHeight = 46
local function get_y_position(position)
	if position == 1 then return startPosition end
	local offset = 4
	local y = position * rowHeight + (offset * (position - 1)) + startPosition - rowHeight
	return y
end

local rows = {
	row.new({x = centerRow, y = get_y_position(1), width = 500, height = rowHeight, color = Colors.black}),
	row.new({x = centerRow, y = get_y_position(2), width = 500, height = rowHeight}),
	row.new({x = centerRow, y = get_y_position(3), width = 500, height = rowHeight}),
	row.new({x = centerRow, y = get_y_position(4), width = 500, height = rowHeight}),
	row.new({x = centerRow, y = get_y_position(5), width = 500, height = rowHeight, color = Colors.black}),
	row.new({x = centerRow, y = get_y_position(6), width = 500, height = rowHeight}),
	row.new({x = centerRow, y = get_y_position(7), width = 500, height = rowHeight}),
}

local labels = {
	{name = "Game Settings", font = TitleFont, offset = 0},
	{name = "Mark/Cross", font = SettingsFont},
	{name = "Hints", font = SettingsFont},
	{name = "Validation", font = SettingsFont},
	{name = "Audio", font = TitleFont, offset = 0},
	{name = "SFX", font = SettingsFont},
	{name = "Music", font = SettingsFont},
}

local names = {}

local radioButtons = {
	radioButton.new({x = rows[2].x + rows[2].width, y = rows[2].y, parrentHeight = rowHeight, bool = "markAndCross"}),
	radioButton.new({x = rows[3].x + rows[3].width, y = rows[3].y, parrentHeight = rowHeight, bool = "hints"}),
	radioButton.new({x = rows[4].x + rows[4].width, y = rows[4].y, parrentHeight = rowHeight, bool = "validation"}),
}


local function generateNames()
	for i = 1, #rows do
		local r = rows[i]
		local l = labels[i]
		table.insert(names, text.new({x = r.x, y = r.y, height = r.height, text = l.name, font = l.font, offset = l.offset}))
	end
end

function MenuSettings:load()

	self:generateButtons()
	generateNames()
end

function MenuSettings:generateButtons()
	local x = Settings.ww - (Settings.button.width + Settings.button.padding)
	local y = Settings.wh - (Settings.button.height + Settings.button.padding)
	for i = 1, #buttonList do
		MenuSettings.buttons[i] = newButton.new({
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


function MenuSettings:draw()
	for i = 1, #rows do
		rows[i]:draw()
		names[i]:draw()
	end

	for i = 1, #MenuSettings.buttons do
		MenuSettings.buttons[i]:draw()
	end

	for i = 1, #radioButtons do
		radioButtons[i]:draw()
	end



	love.graphics.draw(mute)
	love.graphics.draw(audio, 0, 200)
end

function MenuSettings:update(dt)
	for i = 1, #MenuSettings.buttons do
		MenuSettings.buttons[i]:update(dt)
	end

	for i = 1, #radioButtons do
		radioButtons[i]:update(dt)
	end
end

function MenuSettings:mousepressed(x,y,button,istouch,presses)
	for i = 1, #MenuSettings.buttons do
		MenuSettings.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end

	for i = 1, #radioButtons do
		radioButtons[i]:mousepressed(x,y,button,istouch,presses)
	end
end

function MenuSettings:mousereleased(x,y,button,istouch,presses)
	for i = 1, #MenuSettings.buttons do
		MenuSettings.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end

	for i = 1, #radioButtons do
		radioButtons[i]:mousereleased(x,y,button,istouch,presses)
	end
end

return MenuSettings