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

local function convertTime(t)
	local hours = math.floor(math.fmod(t, 86400)/3600)
	local minutes = math.floor(math.fmod(t, 3600)/60)
	local seconds = math.floor(math.fmod(t, 60))
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function Time:draw(x, y)
	if Settings.time then
		love.graphics.print(convertTime(time), x, y)
	end
end

function Time:update(dt)
	if self.state == "start" and Settings.gamesState.state[Settings.problemNr] ~= "solved" and Settings.focused then
		time = time + dt
		Settings.gamesState.time[Settings.problemNr] = math.floor(time)
	end
end

return Time