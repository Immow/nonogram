local GameNumber = {}
GameNumber.width = 200
GameNumber.height = 80
GameNumber.x = 0 - (GameNumber.width + 1)
GameNumber.y = 50
GameNumber.problemNr = Settings.problemNr
GameNumber.active = nil
GameNumber.font = {}
GameNumber.font.width = ProblemNumber:getWidth(Settings.problemNr)
GameNumber.font.height = ProblemNumber:getHeight()

function GameNumber:drawBoardNumber()
	love.graphics.setFont(ProblemNumber)
	love.graphics.setColor(Colors.white)
	love.graphics.print(self.problemNr, self.x + self.width - (self.font.width + 10), self.y + self.height / 2 - self.font.height / 2)
	love.graphics.setFont(Default)
end

function GameNumber:background()
	love.graphics.setColor({0.152, 0.152, 0.152})
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor({0.25, 0.25, 0.25})
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.reset()
end

function GameNumber:reset()
	self.x = 0 - (self.width + 1)
	self.y = 50
	self.active = nil
end

function GameNumber:load()
	if self.active then
		self.active:stop()
		self:reset()
	end
	self.problemNr = Settings.problemNr
	self.font.width = ProblemNumber:getWidth(Settings.problemNr)
	self.active = Flux.to(self, 1, { x = 0}):ease("quintout"):oncomplete(function () self.active = Flux.to(self, 1, {x = 0 - (self.width + 1) }):delay(1):ease("quintout")end)
end

function GameNumber:draw()
	self:background()
	self:drawBoardNumber()
end

return GameNumber