local Slider = {}
Slider.__index = Slider

function Slider.new(settings)
	local instance = setmetatable({}, Slider)
	instance.x              = settings.x
	instance.y              = settings.y
	instance.parrent_width  = settings.parrent_width
	instance.parrent_height = settings.parrent_height
	instance.groove_width   = 200
	instance.groove_height  = 4
	instance.groove_x       = settings.x + instance.parrent_width - (instance.groove_width + 80)
	instance.groove_y       = settings.y + instance.parrent_height / 2 - instance.groove_height / 2
	instance.knob_width     = 28
	instance.knob_height    = 28
	instance.knob_x         = instance.groove_x + (instance.groove_width - instance.knob_width) * Settings[settings.id] or instance.groove_x + instance.groove_width - instance.knob_width
	instance.knob_y         = settings.y + instance.parrent_height / 2 - instance.knob_height / 2
	instance.text_bg_width  = 50
	instance.text_bg_height = instance.knob_height
	instance.text_bg_x      = settings.x + instance.parrent_width - (instance.text_bg_width + 5)
	instance.text_bg_y      = instance.knob_y
	instance.id             = settings.id
	return instance
end

function Slider:containsPoint(x, y)
	return x >= self.knob_x and x <= self.knob_x + self.knob_width and y >= self.knob_y and y <= self.knob_y + self.knob_height
end

function Slider:update(dt)
	local x, y = love.mouse.getPosition()
	if love.mouse.isDown(1) and self:containsPoint(x, y) then
		self.knob_x = x - self.knob_width / 2
	end
	
	if self.knob_x < self.groove_x then
		self.knob_x = self.groove_x
	end

	if self.knob_x + self.knob_width > self.groove_x + self.groove_width then
		self.knob_x = self.groove_x + self.groove_width - self.knob_width
	end

	if self.id == "sfxVolume" then
		Settings.sfxVolume = (100 / ( (self.groove_width - self.knob_width) / (self.knob_x - self.groove_x))) / 100
	end

	if self.id == "musicVolume" then
		Settings.musicVolume = (100 / ( (self.groove_width - self.knob_width) / (self.knob_x - self.groove_x))) / 100
		Sound:setVolume("music", Settings.musicVolume)
	end
end

function Slider:drawGroove()
	love.graphics.setColor(Colors.gray[700])
	love.graphics.rectangle("fill", self.groove_x, self.groove_y, self.groove_width, self.groove_height)
end

function Slider:drawKnob()
	love.graphics.setColor(Colors.white)
	love.graphics.rectangle("fill", self.knob_x, self.knob_y, self.knob_width, self.knob_height, 1, 1)
	love.graphics.setColor(Colors.black)
	love.graphics.rectangle("line", self.knob_x, self.knob_y, self.knob_width, self.knob_height, 1, 1)
	love.graphics.reset()
end

function Slider:backgroundAmount()
	love.graphics.setColor(Colors.gray[600])
	love.graphics.rectangle("fill", self.text_bg_x, self.text_bg_y, self.text_bg_width, self.text_bg_height)
	love.graphics.reset()
end

function Slider:text()
	love.graphics.setFont(Percentage)
	local percentage = math.floor(100 / ( (self.groove_width - self.knob_width) / (self.knob_x - self.groove_x)))
	local width = Percentage:getWidth(percentage)
	local height = Percentage:getHeight()
	local x = self.text_bg_x + self.text_bg_width / 2 - width / 2
	local y = self.text_bg_y + self.text_bg_height / 2 - height / 2
	love.graphics.setColor(Colors.white)
	love.graphics.print(percentage, x, y)
	love.graphics.reset()
	love.graphics.setFont(Default)
end

function Slider:draw()
	self:drawGroove()
	self:drawKnob()
	self:backgroundAmount()
	self:text()
end

return Slider