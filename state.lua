local State = {menu = false, paused = false, running = true, ended = false}

function State:changeState(state)
	self["menu"]    = state == "menu"
	self["paused"]  = state == "paused"
	self["running"] = state == "running"
	self["ended"]   = state == "ended"
end

return State