local Time = {state = "stop"}
local time = 0

function Time:load()
	time = Settings.gamesState.time[Settings.problemNr]
end

function Time:start()
	self.state = "start"
end

function Time:stop()
	self.state = "stop"
end

function Time.reset()
	Settings.gamesState.time[Settings.problemNr] = 0
	time = 0
end

function Time:update(dt)
	if self.state == "start" then
		time = time + dt
		Settings.gamesState.time[Settings.problemNr] = math.floor(time)
	end
end

return Time