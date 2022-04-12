local Row = require("constructors.row")
local game = require("state.game.game")

local Button_Library = {}

local mtClass    = {__index = Row}
local mtInstance = {__index = Button_Library}

setmetatable(Button_Library, mtClass)

local function convertTime(time)
	local hours = math.floor(math.fmod(time, 86400)/3600)
	local minutes = math.floor(math.fmod(time,3600)/60)
	local seconds = math.floor(math.fmod(time,60))
	return string.format("%02d:%02d:%02d",hours,minutes,seconds)
end

function Button_Library.new(settings)
	local instance = Row.new(settings)
	setmetatable(instance, mtInstance)
	instance.buttonNr        = settings.buttonNr
	instance.state           = settings.state
	instance.time            = convertTime(settings.time)
	instance.size            = settings.size
	instance.font            = settings.font
	instance.spacing         = 8
	instance.solvedIcon      = love.graphics.newImage("assets/icons/done.png")
	instance.newIcon         = love.graphics.newImage("assets/icons/new.png")
	instance.pendingIcon     = love.graphics.newImage("assets/icons/pending.png")
	instance.sizeIcon        = love.graphics.newImage("assets/icons/size.png")
	instance.timeIcon        = love.graphics.newImage("assets/icons/time.png")
	instance.textHeight      = SettingsFont:getHeight()
	instance.backgroundColor = {0.25, 0.25, 0.25}
	return instance
end

function Button_Library:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Button_Library:mousereleased(x,y,button,istouch,presses)
	if button == 1 then
		if self:containsPoint(x, y) then
			Sound:play("click", "click", Settings.sfxVolume, 1)
			Settings.problemNr = self.buttonNr
			State.setScene("state.game.game")
			game:load()
		end
	end
end

function Button_Library:drawBackground()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Button_Library:drawButtonNr()
	local offset = self.width / 3
	love.graphics.setColor(self.backgroundColor)
	love.graphics.rectangle("fill", self.x, self.y, offset - offset / 3, self.height)
	love.graphics.setColor(Colors.white)
	love.graphics.print(self.buttonNr, self.x + self.spacing, self.y + self.height / 2 - self.textHeight / 2)
end

function Button_Library:drawSize()
	local offset = self.width / 3
	local offset2 = self.x + offset - (offset / 3) + self.spacing
	local offset3 = self.x + offset + 2 * (offset / 3) - (SettingsFont:getWidth(self.size) + self.spacing)
	love.graphics.draw(self.sizeIcon, offset2, self.y + self.height / 2 - self.newIcon:getHeight() / 2)
	love.graphics.print(self.size, offset3, self.y + self.height / 2 - self.textHeight / 2)
end

function Button_Library:drawTime()
	local offset = self.width / 3
	local offset2 = self.x + offset + 2 * (offset / 3) + (self.spacing * 2)
	love.graphics.draw(self.timeIcon, offset2, self.y + self.height / 2 - self.newIcon:getHeight() / 2)
	if self.time == "00:00:00" then
		local offset3 = self.x + self.width - offset / 3 - (self.spacing + SettingsFont:getWidth("--:--:--") + self.spacing)
		love.graphics.print("--:--:--", offset3, self.y + self.height / 2 - self.textHeight / 2)
	else
		local offset3 = self.x + self.width - offset / 3 - (self.spacing + SettingsFont:getWidth(self.time) + self.spacing)
		love.graphics.print(self.time, offset3, self.y + self.height / 2 - self.textHeight / 2)

		
	end
end

function Button_Library:drawState()
	local width = (self.width / 3) / 3
	local x = self.x + self.width - width / 2 - self.newIcon:getWidth() / 2
	if self.state == "new" then
		love.graphics.draw(self.newIcon, x, self.y + self.height / 2 - self.newIcon:getHeight() / 2)
	elseif self.state == "solved" then
		love.graphics.draw(self.solvedIcon, x, self.y + self.height / 2 - self.newIcon:getHeight() / 2)
	else
		love.graphics.draw(self.pendingIcon, x, self.y + self.height / 2 - self.newIcon:getHeight() / 2)
	end
end

function Button_Library:drawDivider()
	love.graphics.setColor(self.backgroundColor)
	local width = 5
	local offset = self.width / 3
	local offset2 = self.x + offset + 2 * (offset / 3) + width / 2
	love.graphics.rectangle("fill", offset2, self.y, width, self.height)
end

function Button_Library:drawStateBackground()
	love.graphics.setColor(self.backgroundColor)
	local width = (self.width / 3) / 3
	love.graphics.rectangle("fill", self.x + self.width - width, self.y, width, self.height)
end

function Button_Library:draw()
	self:drawBackground()
	self:drawStateBackground()
	self:drawDivider()
	love.graphics.setFont(SettingsFont)
	love.graphics.setColor(Colors.white)
	self:drawButtonNr()
	self:drawSize()
	self:drawTime()
	self:drawState()
end

return Button_Library