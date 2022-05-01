local cross  = require("state.game.cross")
local boardDimensions = require("state.game.board_dimensions")

local Cell = {}
Cell.__index = Cell

---@param settings any x, y, width, height, id, position
function Cell.new(settings)
	local instance = setmetatable({}, Cell)
	instance.x                   = settings.x or 0
	instance.y                   = settings.y or 0
	instance.width               = settings.width or 0
	instance.height              = settings.height or 0
	instance.setCell             = false
	instance.id                  = settings.id or 0 -- 0 == main, 1 == top, 2 == left, 4 == emtpy cell (top or left)
	instance.position            = settings.position
	instance.alpha               = 0
	instance.fade                = false
	instance.fadeSpeed           = 2
	instance.highLight           = false
	instance.locked              = false
	instance.wrong               = false
	instance.state               = "empty"
	instance.winAnimation        = false
	instance.foundCellsToAnimate = {}
	instance.hasRun              = false
	return instance
end

function Cell:checkNeighbours()
	if #self.foundCellsToAnimate > 0 then return end
	if self.hasRun then self.winAnimation = false return end
	if self.winAnimation then
		self.hasRun = true
		local width = boardDimensions.mainCellCount_x
		local height = boardDimensions.mainCellCount_y
		local left = -1
		local right = 1
		local up = -1
		local down = 1
		Timer.new(1, function ()
			if self.position.x < width then -- right
				self.foundCellsToAnimate[1] = {x = self.position.x + right, y = self.position.y}
			end

			if self.position.x > 1 then -- left
				self.foundCellsToAnimate[2] = {x = self.position.x + left, y = self.position.y}
			end

			if self.position.y > 1 then -- up
				self.foundCellsToAnimate[3] = {x = self.position.x, y = self.position.y + up}
			end

			if self.position.y < height then -- down
				self.foundCellsToAnimate[4] = {x = self.position.x, y = self.position.y + down}
			end

			if self.position.x < width and self.position.y > 1 then -- top right
				self.foundCellsToAnimate[5] = {x = self.position.x + right, y = self.position.y + up}
			end

			if self.position.x > 1 and self.position.y > 1 then -- top left
				self.foundCellsToAnimate[6] = {x = self.position.x + left, y = self.position.y + up}
			end

			if self.position.y < height and self.position.x < width then -- down right
				self.foundCellsToAnimate[7] = {x = self.position.x + right, y = self.position.y + down}
			end

			if self.position.y < height and self.position.x > 1 then -- down left
				self.foundCellsToAnimate[8] = {x = self.position.x + left, y = self.position.y + down}
			end
		end)
		Timer.new(2, function () self.foundCellsToAnimate = {} end)
	end
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

function Cell:drawWinAnimation()
	if self.winAnimation then
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.reset()
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
				-- if clickedCell == "empty" or clickedCell == "crossed" then
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
				-- if clickedCell == "empty" or clickedCell == "marked" then
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
	self:checkNeighbours()
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
		love.graphics.setColor(Colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	elseif self.state == "crossed" then
		love.graphics.setColor(Colors.setColorAndAlpha({color = Colors.gray[700], alpha = self.alpha}))
		self:setWrongColor()
		love.graphics.setLineWidth(2)
		cross.newCross(self.x, self.y)
		love.graphics.setLineWidth(1)
		love.graphics.setColor(Colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	else
		love.graphics.setColor(Colors.white24)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end
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
	self:drawWinAnimation()

	if debug then
		love.graphics.setColor(1,0,0)
		love.graphics.print("i: "..self.position.x.." j: "..self.position.y, self.x, self.y+15)
		love.graphics.print("id: "..self.id, self.x, self.y)
	end
end

return Cell