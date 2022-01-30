local State = {}

State.states = {menu = false, paused = false, game = false, ended = false}

function State:changeState(state)
	self.states = {menu = false, paused = false, game = false, ended = false}
	for i = 1, #state do
		for key, _ in pairs(self.states) do
			if key == state[i] then
				self.states[key] = require(key)
			end
		end
	end
end

function State:load()
	for key, value in pairs(self.states) do
		if value then
			self.states[key]:load()
		end
	end
end

function State:draw()
	for key, value in pairs(self.states) do
		if value then
			self.states[key]:draw()
		end
	end
end

function State:update(dt)
	for key, value in pairs(self.states) do
		if value then
			self.states[key]:update(dt)
		end
	end
end

function State:mousepressed(x,y,button,istouch,presses)
	for key, value in pairs(self.states) do
		if value then
			self.states[key]:mousepressed(x,y,button,istouch,presses)
		end
	end
end

function State:mousereleased(x,y,button,istouch,presses)
	for key, value in pairs(self.states) do
		if value then
			self.states[key]:mousereleased(x,y,button,istouch,presses)
		end
	end
end

return State