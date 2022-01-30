local s = require("settings")
local newButton = require("button")

local Menu = {}

local buttonNames = {
	{name = "Play "   , func = nil},
	{name = "Audio"   , func = nil},
	{name = "Settings", func = nil},
	{name = "Library" , func = nil},
	{name = "Quit"    , func = nil},
}

function Menu:load()
	-- self:generateButtons()
end

function Menu:generateButtons()
	local x = s.ww / 2 - s.button.width / 2
	local y = s.wh - (s.button.padding + s.button.height)
	for i = 1, #buttonNames do
		Menu.buttons[i] = newButton.new({x = x, y = y, width = s.button.width, height = s.button.height, text = buttonNames[i]["name"], func = buttonNames[i]["func"], id = i, font = ButtonFont})
		y = y + s.button.height + s.button.padding
	end
end

function Menu:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("fill", 50,50,100,100)
end

function Menu:update(dt)
	
end

return Menu