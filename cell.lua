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
	instance.selected = false
	instance.marked = false
	instance.setCell = false
	return instance
end

function Cell:containsPoint(x, y)
	if self.x then
		return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
	end
end

function Cell:update(dt)
	local x, y = love.mouse.getPosition()
	if love.mouse.isDown(1) then
		if not self.setCell then
			if self:containsPoint(x, y) then
				if self.marked then
					self.marked = false
					self.setCell = true
				else
					self.marked = true
					self.setCell = true
				end
			end
		end
	end
end

function Cell:draw()
	if self.marked == true then
		love.graphics.setColor(1,0,0)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	else
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end
end

return Cell