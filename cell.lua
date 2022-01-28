local cross  = require("cross")
local colors = require("colors")

local Cell = {}
Cell.__index = Cell

---@param settings any x, y, width, height, id, position
function Cell.new(settings)
	local instance = setmetatable({}, Cell)
	instance.x         = settings.x or 0
	instance.y         = settings.y or 0
	instance.width     = settings.width or 0
	instance.height    = settings.height or 0
	instance.crossed   = false
	instance.marked    = false
	instance.setCell   = false
	instance.id        = settings.id or 0
	instance.position  = settings.position
	instance.alpha     = 0
	instance.fade      = false
	instance.fadeSpeed = 2
	instance.highLight = false
	return instance
end

function Cell:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Cell:containsPointX(x)
	return x >= self.x and x <= self.x + self.width
end

function Cell:containsPointY(y)
	return y >= self.y and y <= self.y + self.height
end

function Cell:fadeIn(dt)
	if self.fade then
		if self.alpha < 1 then
			self.alpha = self.alpha + self.fadeSpeed * dt
		end
		if self.alpha >= 1 then
			self.alpha = 1
			self.fade = false
		end
	end
end

function Cell:crossCellLeft(dt)
	if self.id == 2 or self.id == 1 then
		local x, y = love.mouse.getPosition()
		self:fadeIn(dt)

		if love.mouse.isDown(1) or love.mouse.isDown(2) then
			if self:containsPoint(x, y) then
				if not self.setCell then
					self.alpha = 0
					self.fade = true
					self.setCell = true
					self.marked = false
					self.crossed = not self.crossed
				end
			end
		end
	end
end

function Cell:markCell(dt)
	if self.id ~= 0 then return end

	local x, y = love.mouse.getPosition()
	self:fadeIn(dt)

	if love.mouse.isDown(1) then
		if self:containsPoint(x, y) then
			if not self.setCell then
				self.alpha = 0
				self.fade = true
				self.setCell = true
				self.crossed = false
				self.marked = not self.marked
			end
		end
	end

	if love.mouse.isDown(2) then
		if self:containsPoint(x, y) then
			if not self.setCell then
				self.alpha = 0
				self.fade = true
				self.setCell = true
				self.marked = false
				self.crossed = not self.crossed
			end
		end
	end
end

function Cell:setHiglight()
	local x, y = love.mouse.getPosition()
	if self:containsPointX(x) or self:containsPointY(y) then
		self.highLight = true
	else
		self.highLight = false
	end
end

function Cell:update(dt)
	self:setHiglight()
	self:markCell(dt)
	self:crossCellLeft(dt)
end

function Cell:addAlpha(color)
	color[4] = self.alpha
	return color
end

function Cell:draw()
	if self.marked then
		love.graphics.setColor(self:addAlpha(colors.purple[900]))
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	elseif self.crossed then
		love.graphics.setColor(self:addAlpha(colors.gray[700]))
		cross:newCross(self.x, self.y)
		love.graphics.setColor(colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	else
		if (self.id == 2 or self.id == 1) and self.highLight then
			love.graphics.setColor(colors.red[500])
		else
			love.graphics.setColor(colors.white24)
		end
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end

	if debug then
		love.graphics.setColor(1,0,0)
		love.graphics.print("i: "..self.position[1].." j: "..self.position[2], self.x, self.y)
	end
end

return Cell