local cross  = require("constructors.cross")
local boardDimensions = require("state.game.board_dimensions")

local Cell = {}
Cell.__index = Cell

---@param settings any x, y, width, height, id, position
function Cell.new(settings)
	local instance = setmetatable({}, Cell)
	---@param instance.state any "empty, crossed, marked"
	---@param instance.id any 0 == main, 1 == top, 2 == left, 4 == emtpy cell (top or left)
	instance.x                   = settings.x or 0
	instance.y                   = settings.y or 0
	instance.width               = settings.width or 0
	instance.height              = settings.height or 0
	instance.setCell             = false
	instance.id                  = settings.id or 0
	instance.position            = settings.position
	instance.alpha               = 0
	instance.fade                = false
	instance.fadeSpeed           = 2
	instance.highLight           = false
	instance.locked              = false
	instance.wrong               = false
	instance.state               = "empty"
	instance.cross_x             = instance.x
	instance.cross_y             = instance.y
	instance.crossRotationSpeed  = 0
	instance.crossScale_x        = 1
	instance.crossScale_y        = 1
	instance.cross               = cross.new({x = instance.cross_x, y = instance.cross_y, id = instance.id })
	return instance
end

function Cell:getId()
	return self.id
end

function Cell:containsPoint(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Cell:containsPointX(x)
	return x > self.x and x < self.x + self.width
end

function Cell:containsPointY(y)
	return y > self.y and y < self.y + self.height
end

function Cell:getPosition()
	return self.position.x, self.position.y
end

function Cell:printPosition()
	print("x: "..self.position.x..", y: "..self.position.y)
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
	if self.id == 2 or self.id == 1 then -- matrix on left and top
		local x, y = love.mouse.getPosition()
		self:fadeIn(dt)

		if love.mouse.isDown(1) or love.mouse.isDown(2) then
			if self:containsPoint(x, y) then
				if not self.setCell and not self.locked then
					if self.state == "empty" then
						self.state = "crossed"
					else
						self.state = "empty"
					end
					self.alpha = 0
					self.fade = true
					self.setCell = true
					Sound:play("crossed", "sfx", Settings.sfxVolume, love.math.random(0.5, 2))
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
			if not self.setCell and not self.locked then
				if self.state ~= "marked" then
					self.state = "marked"
				else
					self.state = "empty"
				end
				self.alpha = 0
				self.fade = true
				self.setCell = true
				self.wrong = false
				Sound:play("marked", "sfx", Settings.sfxVolume, love.math.random(0.5, 2))
			end
		end
	end

	if love.mouse.isDown(2) then
		if self:containsPoint(x, y) then
			if not self.setCell and not self.locked then
				if self.state ~= "crossed" then
					self.state = "crossed"
				else
					self.state = "empty"
				end
				self.alpha = 0
				self.fade = true
				self.setCell = true
				self.wrong = false
				Sound:play("crossed", "sfx", Settings.sfxVolume, love.math.random(0.5, 2))
			end
		end
	end
end

function Cell:setHiglight()
	local x, y = love.mouse.getPosition()
	local checkX = x >= boardDimensions.mainX and x <= boardDimensions.width
	local checkY = y >= boardDimensions.mainY and y <= boardDimensions.height
	if checkX and checkY then
		if self:containsPointX(x) or self:containsPointY(y) then
			self.highLight = true
		else
			self.highLight = false
		end
	else
		self.highLight = false
	end
end

function Cell:update(dt)
	self:setHiglight()
	self:markCell(dt)
	self:crossCellLeft(dt)
	self.cross:setPosition(self.cross_x, self.cross_y)
	self.cross:update(dt, self.crossRotationSpeed)
end

function Cell:resetCrossPosition()
	self.cross_x = self.x
	self.cross_y = self.y
	self.cross:reset()
end

function Cell:setWrongColor()
	if self.wrong then
		love.graphics.setColor(Colors.red[800])
	end
end

function Cell:crossCell()
	self.state = "crossed"
	self.fade = true
	self.locked = true
end

function Cell:lockCell()
	self.locked = true
end

function Cell:markCellSolver()
	self.state = "marked"
	self.locked = true
	self.fade = true
end

function Cell:drawHighlightOutsideNumbers()
	if (self.id == 2 or self.id == 1) and self.highLight then
		if not self.locked then
			love.graphics.setColor(Colors.blueGray)
			love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		end
	end
end

function Cell:drawState()
	if self.state == "marked" then
		love.graphics.setColor(Colors.setColorAndAlpha({color = Colors.purple[900], alpha = self.alpha}))
		self:setWrongColor()
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	elseif self.state == "crossed" then
		love.graphics.setColor(Colors.setColorAndAlpha({color = Colors.gray[700], alpha = self.alpha}))
		self:setWrongColor()
		self.cross:draw(self.crossScale_x, self.crossScale_y)
	end
	love.graphics.setColor(Colors.white24)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function Cell:drawLockedState()
	if self.locked and self.id ~= 4 and Settings.gamesState.state[Settings.problemNr] ~= "solved" then
		love.graphics.setColor(Colors.setColorAndAlpha({color = Colors.green[800]}))
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end
end

function Cell:draw()
	self:drawHighlightOutsideNumbers()
	self:drawState()
	self:drawLockedState()

	if debug then
		love.graphics.setColor(1,0,0)
		love.graphics.print("i: "..self.position.x.." j: "..self.position.y, self.x, self.y+15)
		love.graphics.print("id: "..self.id, self.x, self.y)
	end
end

return Cell