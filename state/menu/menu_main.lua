local newButton = require("constructors.button")

local MenuMain = {}

local buttonList = {
	{name = "Play "   , func = State.setScene, argument = "state.game.game"},
	{name = "Settings", func = State.setScene, argument = "state.menu.menu_settings"},
	{name = "Library" , func = State.setScene, argument = "state.menu.menu_library"},
	{name = "Quit"    , func = love.event.quit},
}

function MenuMain:load()
	self:generateButtons()
end

function MenuMain:generateButtons()
	local x = Settings.ww / 2 - Settings.button.width / 2
	local y = Settings.wh / 2 - (Settings.button.padding * (#buttonList - 1) + #buttonList * Settings.button.height) / 2
	MenuMain.buttons = {}
	for i = 1, #buttonList do
		MenuMain.buttons[i] = newButton.new({
			x = x,
			y = y,
			width = Settings.button.width,
			height = Settings.button.height,
			text = buttonList[i]["name"],
			func = buttonList[i]["func"],
			font = ButtonFont,
			argument = buttonList[i]["argument"]
		})
		y = y + Settings.button.height + Settings.button.padding
	end
end

function MenuMain:draw()
	for i = 1, #MenuMain.buttons do
		MenuMain.buttons[i]:draw()
	end
end

function MenuMain:update(dt)
	for i = 1, #MenuMain.buttons do
		MenuMain.buttons[i]:update(dt)
	end
end

function MenuMain:mousepressed(x,y,button,istouch,presses)
	for i = 1, #MenuMain.buttons do
		MenuMain.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
end

function MenuMain:mousereleased(x,y,button,istouch,presses)
	for i = 1, #MenuMain.buttons do
		MenuMain.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
end

return MenuMain