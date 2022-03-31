local Timer = {}
Timer.__index = Timer
local active = {}

function Timer.new(time, callback)
	local instance = setmetatable({}, Timer)
	instance.time = time
	instance.callback = callback

	table.insert(active, instance)
end

function Timer:remove()
	for i,timer in ipairs(active) do
		if self == timer then
			table.remove(active, i)
			return
		end
	end
end

function Timer:update(dt)
	if self.time - dt > 0 then
		self.time = self.time - dt
	else
		self.callback()
		self:remove()
	end
end

function Timer.updateAll(dt)
	for i,timer in ipairs(active) do
		timer:update(dt)
	end
end

return Timer
