local s         = require("settings")
local newButton = require("constructors.button")
local state     = require("state.state")

local MenuMain = {}
MenuMain.buttons = {}

local buttonList = {
	{name = "Play "   , func = state.setScene, argument = "state.game.game"},
	{name = "Audio"   , func = state.setScene, argument = "state.menu.menu_audio"},
	{name = "Settings", func = nil},
	{name = "Library" , func = nil},
	{name = "Quit"    , func = love.event.quit},
}

function MenuMain:load()
	self:generateButtons()
end

function MenuMain:generateButtons()
	local x = s.ww / 2 - s.button.width / 2
	local y = s.wh / 2 - (s.button.padding * (#buttonList - 1) + #buttonList * s.button.height) / 2
	for i = 1, #buttonList do
		MenuMain.buttons[i] = newButton.new({x = x, y = y, width = s.button.width, height = s.button.height, text = buttonList[i]["name"], func = buttonList[i]["func"], font = ButtonFont, argument = buttonList[i]["argument"]})
		y = y + s.button.height + s.button.padding
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