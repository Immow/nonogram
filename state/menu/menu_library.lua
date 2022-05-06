local newButton        = require("constructors.button")
local newLibraryButton = require("constructors.button_library")
local problems         = require("problems")

local Library = {}

local buttonList = {
	{name = "Back", func = State.setScene, argument = "state.menu.menu_main"},
}

Library.listButtons = {}

Library.startPosition = 100
Library.rowWidth = 500
Library.centerRow = Settings.ww / 2 - Library.rowWidth / 2
Library.rowHeight = 46
Library.rowOffset = 4
Library.listBottomOffset = 100
Library.listHeight = Settings.wh - (Library.startPosition + Library.listBottomOffset)
Library.dragging = false
Library.oy = 0
Library.scrollLimit = 0
Library.timer = 0

Library.listClickBox = {
	x = Library.centerRow,
	y = Library.startPosition,
	width = Library.rowWidth,
	height = Library.listHeight
}

Library.scrollbar = {
	x = Library.listClickBox.x + Library.listClickBox.width + 10,
	y = Library.listClickBox.y,
	width = 5,
	height = Library.listHeight,
	knob = {
		x = Library.listClickBox.x + Library.listClickBox.width + 10,
		y = Library.listClickBox.y,
		width = 5,
		height = 30,
	}
}

function Library:load()
	self:generateButtons()
	self:generateListButtons()
	self.scrollLimit = #self.listButtons * (self.rowHeight + self.rowOffset) - (self.listHeight + self.rowOffset)
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
	local yPos = 0
	for i = 1, #problems do
		table.insert(self.listButtons, newLibraryButton.new(
			{
				y = yPos,
				width = self.rowWidth,
				height = self.rowHeight,
				buttonNr = i,
				state = Settings.gamesState.state[i],
				size = Settings.gamesState.size[i],
				time = Settings.gamesState.time[i],
			}
		))
		yPos = yPos + self.rowHeight + self.rowOffset
	end
end

function Library:containsPoint(x, y)
	return
		x >= self.listClickBox.x and
		x <= self.listClickBox.x + self.listClickBox.width and
		y >= self.listClickBox.y and
		y <= self.listClickBox.y + self.listClickBox.height
end

function Library.hideTopOfList()
	love.graphics.setColor(Colors.black) -- hide top
	love.graphics.rectangle("fill", 0, 0, Settings.ww, Library.startPosition)
	love.graphics.reset()
end

function Library.hideBottomOfList()
	love.graphics.setColor(Colors.black) -- hide bottom
	love.graphics.rectangle("fill", 0, Settings.wh - Library.listBottomOffset, Settings.ww, Library.listBottomOffset)
	love.graphics.reset()
end

function Library:border()
	love.graphics.setColor(Colors.gray[500]) -- box to detect where we click
	love.graphics.rectangle("line", self.listClickBox.x, self.listClickBox.y, self.listClickBox.width, self.listClickBox.height)
	love.graphics.reset()
end

function Library:drawButtons()
	for i = 1, #Library.buttons do
		self.buttons[i]:draw()
	end
end

function Library:drawScrollbar()
	love.graphics.setColor(Colors.gray[400])
	love.graphics.rectangle("line", self.scrollbar.x, self.scrollbar.y, self.scrollbar.width, self.scrollbar.height)
	love.graphics.reset()
end

function Library:drawScrollbarKnob()
	love.graphics.setColor(Colors.gray[400])
	love.graphics.rectangle("fill", self.scrollbar.knob.x, self.scrollbar.knob.y, self.scrollbar.knob.width, self.scrollbar.knob.height)
	love.graphics.reset()
end

function Library:drawListButtons()
	for i = 1, #self.listButtons do
		self.listButtons[i]:draw()
	end
end

function Library:draw()
	love.graphics.origin()
	love.graphics.push()
	love.graphics.translate(self.centerRow, (self.startPosition + self.oy))
	self:drawListButtons()
	love.graphics.pop()
	
	self.hideTopOfList()
	self.hideBottomOfList()
	self:border()
	self:drawButtons()
	self:drawScrollbar()
	self:drawScrollbarKnob()
end

function Library:updateButtons(dt)
	for i = 1, #self.buttons do
		self.buttons[i]:update(dt)
	end
end

function Library:dragTimer(dt)
	if self.dragging then
		self.timer = self.timer + dt
	end
end

function Library:updateKnob()
	self.scrollbar.knob.y = ((self.oy) * -1 ) * ((self.listHeight - self.scrollbar.knob.height) / self.scrollLimit) + self.startPosition
end

function Library:update(dt)
	self:updateButtons(dt)
	self:dragTimer(dt)
	self:updateKnob()
end

function Library:resetDragDetection()
	self.timer = 0
	self.dragging = false
end

function Library:mousepressed(x,y,button,istouch,presses)
	for i = 1, #self.buttons do
		self.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end

	if self:containsPoint(x, y) then
		self.dragging = true
	end
end

function Library:mousemoved(x, y, dx, dy, istouch)
	if self.dragging then
		self.oy = self.oy + dy
		self.oy = math.max(-self.scrollLimit, math.min(0, self.oy))
	end
end

function Library:mousereleased(x,y,button,istouch,presses)
	for i = 1, #self.buttons do
		self.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end
	
	if self.timer < 0.15 and self:containsPoint(x, y) then
		for i = 1, #self.listButtons do
			self.listButtons[i]:mousereleased(x - self.centerRow, y - (self.oy + self.startPosition) ,button,istouch,presses)
		end
	end
	self:resetDragDetection()
end

return Library