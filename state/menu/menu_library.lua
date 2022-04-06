local newButton       = require("constructors.button")
local state           = require("state.state")
local icon            = require("constructors.icon")
local newLibraryButton = require("constructors.button_library")
local problems        = require("problems")

local Library = {}
Library.buttons = {}

local buttonList = {
	{name = "Back", func = state.setScene, argument = "state.menu.menu_main"},
}


local startPosition = 100
local rowWidth = 500
local centerRow = Settings.ww / 2 - rowWidth / 2
local rowHeight = 46
local rowOffset = 4
local listBottomOffset = 200
local listHeight = Settings.wh - (startPosition + listBottomOffset)

local libraryButtons = {}
local listClickBox = {
	x = centerRow,
	y = startPosition,
	width = rowWidth,
	height = listHeight
}

local icons = {
	-- icon.new({x = libraryButtons[2].x, y = libraryButtons[2].y, parrent_width = libraryButtons[2].width , parrent_height = rowHeight, bool = "markAndCross"}),
}

function Library:load()
	self:generateButtons()
	self:generateLibraryButtons()
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

function Library:generateLibraryButtons()
	local yPos = startPosition
	for i = 1, #problems do
		table.insert(libraryButtons, newLibraryButton.new({x = centerRow, y = yPos, width = rowWidth, height = rowHeight}))
		yPos = yPos + rowHeight + rowOffset
	end
end

function Library:containsPoint(x, y)
	return x >= listClickBox.x and x <= listClickBox.x + listClickBox.width and
		y >= listClickBox.y and y <= listClickBox.y + listClickBox.height
end

local clickPostition = 0
local test = false

function Library:draw()
	for i = 1, #libraryButtons do
		libraryButtons[i]:draw()
	end
	
	for i = 1, #icon do
		icon[i]:draw()
	end

	love.graphics.setColor(Colors.black) -- hide top
	love.graphics.rectangle("fill", 0, 0, Settings.ww, startPosition)

	love.graphics.setColor(Colors.black) -- hide bottom
	love.graphics.rectangle("fill", 0, Settings.wh - listBottomOffset, Settings.ww, listBottomOffset)
	
	love.graphics.setScissor(listClickBox.x, listClickBox.y, listClickBox.width, listClickBox.height)
	love.graphics.setColor(1,0,0)
	love.graphics.rectangle("fill", 100, startPosition, 100, listHeight)
	love.graphics.reset()

	love.graphics.setColor(0,1,0) -- box to detect where we click
	love.graphics.rectangle("line", listClickBox.x, listClickBox.y, listClickBox.width, listClickBox.height)
	love.graphics.reset()
	
	for i = 1, #Library.buttons do
		Library.buttons[i]:draw()
	end
end

function Library:update(dt)
	for i = 1, #Library.buttons do
		Library.buttons[i]:update(dt)
	end

	for i = 1, #libraryButtons do
		libraryButtons[i]:update(dt)
	end

	-- local x, y = love.mouse.getPosition()

	-- if love.mouse.isDown(1) then
	-- 	if self:containsPoint(x, y) then
	-- 		for i = 1, #Library.buttons do
	-- 			libraryButtons[i].dragging = true
	-- 			-- libraryButtons[i].draggingDistance = y - libraryButtons[i].y
	-- 		end
	-- 	end
	-- end
end

function Library:mousepressed(x,y,button,istouch,presses)
	for i = 1, #Library.buttons do
		Library.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
	
	if self:containsPoint(x, y) then
		for i = 1, #libraryButtons do
			libraryButtons[i]:mousepressed(x,y,button,istouch,presses)
			libraryButtons[i].dragging = true
			libraryButtons[i].draggingDistance = y - libraryButtons[i].y
		end
	end
end

function Library:mousereleased(x,y,button,istouch,presses)
	for i = 1, #Library.buttons do
		Library.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
	
	for i = 1, #libraryButtons do
		libraryButtons[i]:mousereleased(x,y,button,istouch,presses)
		libraryButtons[i].dragging = false
	end
end

return Library