local cross = require("cross")
local colors = require("colors")

local Cell = {}
Cell.__index = Cell

---comment
---@param settings any, x, y, width, height
---@return table
function Cell.new(settings)
	local instance = setmetatable({}, Cell)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.width = settings.width or 0
	instance.height = settings.height or 0
	instance.crossed = false
	instance.marked = false
	instance.setCell = false
	instance.id = settings.id or 0
	instance.alpha = 0
	instance.fade = false
	return instance
end

function Cell:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Cell:fadeIn(dt)
	if self.fade then
		if self.alpha < 1 then
			self.alpha = self.alpha + 1 * dt
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
					if self.crossed then
						self.crossed = false
						self.setCell = true
						self.alpha = 0
					else
						self.fade = true
						self.crossed = true
						self.setCell = true
					end
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
				self.crossed = false
				if self.marked then
					self.marked = false
					self.setCell = true
					self.alpha = 0
				else
					self.fade = true
					self.marked = true
					self.setCell = true
				end
			end
		end
	end

	if love.mouse.isDown(2) then
		if self:containsPoint(x, y) then
			if not self.setCell then
				self.marked = false
				if self.crossed then
					self.crossed = false
					self.setCell = true
					self.alpha = 0
				else
					self.fade = true
					self.crossed = true
					self.setCell = true
				end
			end
		end
	end
end

function Cell:update(dt)
	self:markCell(dt)
	self:crossCellLeft(dt)
end

function Cell:draw()
	if self.marked then
		love.graphics.setColor(0.290 ,0.078 ,0.549,self.alpha)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	elseif self.crossed then
		love.graphics.setColor(0.380 ,0.380 ,0.380,self.alpha)
		cross:newCross(self.x, self.y)
		love.graphics.setColor(colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	else
		love.graphics.setColor(colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end
end

return Cell