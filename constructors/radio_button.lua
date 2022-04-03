local RadioButton = {}
RadioButton.__index = RadioButton

function RadioButton.new(settings)
	local instance = setmetatable({}, RadioButton)
	instance.on = love.graphics.newImage("assets/icons/radio_on.png")
	instance.off = love.graphics.newImage("assets/icons/radio_off.png")
	instance.width = instance.on:getWidth()
	instance.height = instance.on:getHeight()
	instance.offset = settings.offset or 10
	instance.x = settings.x + settings.parrent_width - (instance.width + instance.offset)
	instance.y = settings.y + settings.parrent_height / 2 - instance.height / 2
	instance.state = 1
	instance.bool = settings.bool

	return instance
end

function RadioButton:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function RadioButton:mousepressed(x,y,button,istouch,presses)
	if button == 1  and self:containsPoint(x, y) then
		if self.state == 1 then
			self.state = 0
			Settings[self.bool] = false
		else
			self.state = 1
			Settings[self.bool] = true
		end
	end
end

function RadioButton:draw()
	if self.state == 1 then
		love.graphics.draw(self.on, self.x, self.y)
	else
		love.graphics.draw(self.off, self.x, self.y)
	end
end

return RadioButton