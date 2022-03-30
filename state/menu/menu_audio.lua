local s         = require("settings")
local newButton = require("constructors.button")
local state     = require("state.state")

local MenuAudio = {}
MenuAudio.buttons = {}

local buttonList = {
	{name = "Back", func = state.setScene, argument = "state.menu.menu_main"},
}

function MenuAudio:load()
	self:generateButtons()
end

function MenuAudio:generateButtons()
	local x = s.ww / 2 - s.button.width / 2
	local y = s.wh / 2 - (s.button.padding * (#buttonList - 1) + #buttonList * s.button.height) / 2
	for i = 1, #buttonList do
		MenuAudio.buttons[i] = newButton.new({x = x, y = y, width = s.button.width, height = s.button.height, text = buttonList[i]["name"], func = buttonList[i]["func"], font = ButtonFont, argument = buttonList[i]["argument"]})
		y = y + s.button.height + s.button.padding
	end
end

function MenuAudio:draw()
	for i = 1, #MenuAudio.buttons do
		MenuAudio.buttons[i]:draw()
	end
end

function MenuAudio:update(dt)
	for i = 1, #MenuAudio.buttons do
		MenuAudio.buttons[i]:update(dt)
	end
end

function MenuAudio:mousepressed(x,y,button,istouch,presses)
	for i = 1, #MenuAudio.buttons do
		MenuAudio.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
end

function MenuAudio:mousereleased(x,y,button,istouch,presses)
	for i = 1, #MenuAudio.buttons do
		MenuAudio.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
end

return MenuAudio