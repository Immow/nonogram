local boardCellsMain = require("boardcellsmain")
local colors = require("colors")

local Button = {}
Button.__index = Button

function Button.new(settings)
	local instance = setmetatable({}, Button)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.text  = settings.text or ""
	instance.func = settings.func or ""
	instance.width = settings.width or 200
	instance.height = settings.height or 80
	instance.flashRed = false
	instance.flashGreen = false
	instance.flash = false
	instance.circleX = 0
	instance.circleY = 0
	instance.circleRadius = 0
	instance.run = false
	instance.speed = 500
	instance.offset = 10
	instance.buttonFillet = 5
	return instance
end



function Button:containsPoint(x, y)
	if self.x then
		return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
	end
end

function Button:mousepressed(x,y,button,istouch,presses)
	if button == 1 then
		if self:containsPoint(x, y) then
			self.circleX = x
			self.circleY = y
			self.run = true
			if boardCellsMain:validateCells() > 0 then
				self.flashRed = true
			else
				self.flashGreen = true
			end
		end
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

function Button:stencilFunction()
	return love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.buttonFillet, self.buttonFillet)
end

function Button:draw()
	love.graphics.setColor(colors.gray)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.buttonFillet, self.buttonFillet)
	if self.run then
		love.graphics.stencil(function() self:stencilFunction() end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		if self.flashRed then
			love.graphics.setColor(colors.red[900])
		elseif self.flashGreen then
			love.graphics.setColor(colors.green[900])
		end
		love.graphics.circle("fill", self.circleX, self.circleY, self.circleRadius)
		love.graphics.setStencilTest()
	end
	love.graphics.setColor(colors.black)
	love.graphics.print(self.text, self.x, self.y)
end

return Button