local newButton       = require("constructors.button")
local state           = require("state.state")
local icon            = require("constructors.icon")
local newLibraryButton = require("constructors.button_library")
local problems        = require("problems")

local Library = {}

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

Library.listButtons = {}
Library.listClickBox = {
	x = centerRow,
	y = startPosition,
	width = rowWidth,
	height = listHeight
}

local icons = {
	-- icon.new({x = Library.listButtons[2].x, y = Library.listButtons[2].y, parrent_width = Library.listButtons[2].width , parrent_height = rowHeight, bool = "markAndCross"}),
}

function Library:load()
	self:generateButtons()
	self:generateListButtons()
end

function Library:generateButtons()
	local x = Settings.ww - (Settings.button.width + Settings.button.padding)
	local y = Settings.wh - (Settings.button.height + Settings.button.padding)
	self.buttons = {}
	for i = 1, #buttonList do
		self.buttons[i] = newButton.new({
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

function Library:generateListButtons()
	self.listButtons = {}
	local yPos = startPosition
	for i = 1, #problems do
		table.insert(self.listButtons, newLibraryButton.new(
			{
				x = centerRow,
				y = yPos,
				width = rowWidth,
				height = rowHeight,
				buttonNr = i,
				endPosition_y = (startPosition + listHeight - (rowHeight + rowOffset)) - (#problems - i) * (rowHeight + rowOffset)
			}
		))
		yPos = yPos + rowHeight + rowOffset
	end
end

function Library:containsPoint(x, y)
	return x >= self.listClickBox.x and x <= self.listClickBox.x + self.listClickBox.width and
		y >= self.listClickBox.y and y <= self.listClickBox.y + self.listClickBox.height
end

function Library:resetPosition()
	for i = 1, #self.listButtons do
		self.listButtons[i].draggingDistance = 0
	end
end

function Library.hideTopOfList()
	love.graphics.setColor(Colors.black) -- hide top
	love.graphics.rectangle("fill", 0, 0, Settings.ww, startPosition)
	love.graphics.reset()
end

function Library.hideBottomOfList()
	love.graphics.setColor(Colors.black) -- hide bottom
	love.graphics.rectangle("fill", 0, Settings.wh - listBottomOffset, Settings.ww, listBottomOffset)
	love.graphics.reset()
end

function Library:temp()
	love.graphics.setColor(0,1,0) -- box to detect where we click
	love.graphics.rectangle("line", self.listClickBox.x, self.listClickBox.y, self.listClickBox.width, self.listClickBox.height)
	love.graphics.reset()
end

function Library:draw()
	for i = 1, #self.listButtons do
		self.listButtons[i]:draw()
	end
	
	-- for i = 1, #icon do
	-- 	icon[i]:draw()
	-- end

	self.hideTopOfList()
	self.hideBottomOfList()
	self:temp() -- temporary (show where we detect clicks)

	for i = 1, #Library.buttons do
		self.buttons[i]:draw()
	end
end

function Library:update(dt)
	for i = 1, #self.buttons do
		self.buttons[i]:update(dt)
	end

	for i = 1, #self.listButtons do
		self.listButtons[i]:update(dt)
	end

	if self.listButtons[1].y > self.listClickBox.y then
		for i = 1, #self.listButtons do
			self.listButtons[i].y = self.listButtons[i].startPosition_y
		end
	end

	if self.listButtons[#problems].y + rowHeight + rowOffset < self.listClickBox.y + self.listClickBox.height then
		for i = 1, #self.listButtons do
			self.listButtons[i].y = self.listButtons[i].endPosition_y
		end
	end
end

function Library:mousepressed(x,y,button,istouch,presses)
	for i = 1, #self.buttons do
		self.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end
	
	if self:containsPoint(x, y) then
		for i = 1, #self.listButtons do
			self.listButtons[i]:mousepressed(x,y,button,istouch,presses)
			self.listButtons[i].dragging = true
			self.listButtons[i].draggingDistance = y - self.listButtons[i].y
		end
	end
end

function Library:mousereleased(x,y,button,istouch,presses)
	for i = 1, #self.buttons do
		self.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
	
	for i = 1, #self.listButtons do
		self.listButtons[i]:mousereleased(x,y,button,istouch,presses)
		self.listButtons[i].dragging = false
	end
end

return Library