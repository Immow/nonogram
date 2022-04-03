local Button = {}
Button.__index = Button

function Button.new(settings)
	local instance = setmetatable({}, Button)
	instance.x            = settings.x or 0
	instance.y            = settings.y or 0
	instance.func         = settings.func
	instance.argument     = settings.argument
	instance.width        = settings.width or 200
	instance.height       = settings.height or 80
	instance.flashRed     = false
	instance.flashGreen   = false
	instance.flash        = false
	instance.circleX      = 0
	instance.circleY      = 0
	instance.circleRadius = 0
	instance.run          = false
	instance.speed        = 500
	instance.offset       = 10
	instance.buttonFillet = 5
	instance.font         = settings.font or love.graphics.getFont()
	instance.fontSize     = settings.fontSize or 12
	instance.text         = settings.text or ""
	instance.id           = settings.id
	return instance
end

function Button:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Button:runFunction()
	if self.func then
		self.func(self.argument)
	end
end

function Button:mousepressed(x,y,button,istouch,presses)
	if button == 1 then
		if self:containsPoint(x, y) then
			self.circleX = x
			self.circleY = y
			self.run = true
			Sound:play("click", "click", Settings.sfxVolume, 1)
			if self.text == "Validate" and Settings.validation then
				if #self.func() > 0 then
					self.flashRed = true
				else
					self.flashGreen = true
				end
			end
		end
	end
end

function Button:mousereleased(x,y,button,istouch,presses)
	if self:containsPoint(x, y) then
		self:runFunction()
	end
end

function Button:update(dt)
	if self.run and self.circleRadius < self.width + self.offset then
		self.circleRadius = self.circleRadius + self.speed * dt
	end

	if self.circleRadius >= self.width + self.offset then
		self.run = false
		self.flashGreen = false
		self.flashRed = false
		self.circleRadius = 0
	end
end

function Button:centerTextX()
	return self.width / 2 - ButtonFont:getWidth(self.text) / 2
end

function Button:centerTextY()
	return self.height / 2 - ButtonFont:getHeight() / 2
end

function Button:draw()
	local rec = function() love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.buttonFillet, self.buttonFillet) end
	rec()
	love.graphics.setColor(Colors.gray)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.buttonFillet, self.buttonFillet)
	if self.run then
		love.graphics.stencil(rec, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		if self.flashRed then
			love.graphics.setColor(Colors.red[900])
		elseif self.flashGreen then
			love.graphics.setColor(Colors.green[600])
		else
			love.graphics.setColor(Colors.white54)
		end
		love.graphics.circle("fill", self.circleX, self.circleY, self.circleRadius)
		love.graphics.setStencilTest()
	end
	love.graphics.setColor(Colors.black)
	love.graphics.setFont(self.font)
	love.graphics.print(self.text, self.x + self:centerTextX(), self.y + self:centerTextY())
	love.graphics.reset()
end

return Button