local newButton   = require("constructors.button")
local row         = require("constructors.row")
local text        = require("constructors.text")

local Credits = {}

local function backButton()
	local data = Lib.saveDataList()

	Lib.writeData("config.cfg", data)
	State.setScene("state.menu.menu_main")
end

local buttonList = {
	{name = "Back", func = backButton},
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
	row.new({x = centerRow, y = get_y_position(2), width = rowWidth, height = rowHeight}),
	row.new({x = centerRow, y = get_y_position(3), width = rowWidth, height = rowHeight, color = Colors.black}),
	row.new({x = centerRow, y = get_y_position(4), width = rowWidth, height = rowHeight}),
}

local labelSettings = {
	{name = "Game Created by", font = TitleFont, offset = 0, color = Colors.blue[300]},
	{name = "Koen Schippers, Flux Game Design", font = SettingsFont},
	{name = "Music", font = TitleFont, offset = 0, color = Colors.blue[300]},
	{name = "Alexander Nakarada", font = SettingsFont},
}

local labels = {}

local function generateLabels()
	labels = {}
	for i = 1, #rows do
		local r = rows[i]
		local l = labelSettings[i]
		table.insert(labels, text.new({
			x      = r.x,
			y      = r.y,
			height = r.height,
			text   = l.name,
			font   = l.font,
			offset = l.offset,
			color  = l.color
		}))
	end
end

function Credits:load()
	self:generateButtons()
	generateLabels()
end

function Credits:generateButtons()
	Credits.buttons = {}
	local x = Settings.ww - (Settings.button.width + Settings.button.padding)
	local y = Settings.wh - (Settings.button.height + Settings.button.padding)
	for i = 1, #buttonList do
		Credits.buttons[i] = newButton.new({
			x        = x,
			y        = y,
			width    = Settings.button.width,
			height   = Settings.button.height,
			text     = buttonList[i]["name"],
			func     = buttonList[i]["func"],
			font     = ButtonFont,
			argument = buttonList[i]["argument"],
		})
		y = y + Settings.button.height + Settings.button.padding
	end
end


function Credits:draw()
	for i = 1, #rows do
		rows[i]:draw()
		labels[i]:draw()
	end

	for i = 1, #Credits.buttons do
		Credits.buttons[i]:draw()
	end
end

function Credits:update(dt)
	for i = 1, #Credits.buttons do
		Credits.buttons[i]:update(dt)
	end
end

function Credits:mousepressed(x,y,button,istouch,presses)
	for i = 1, #Credits.buttons do
		Credits.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
end

function Credits:mousereleased(x,y,button,istouch,presses)
	for i = 1, #Credits.buttons do
		Credits.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
end

return Credits