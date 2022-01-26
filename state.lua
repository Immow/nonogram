local State = {menu = false, paused = false, game = true, ended = false}

function State:changeState(state)
	self["menu"]    = state == "menu"
	self["paused"]  = state == "paused"
	self["game"]    = state == "game"
	self["ended"]   = state == "ended"
end

return State