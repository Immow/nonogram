local text       = require("constructors.text")
local textSwitch = {}

local mtClass    = {__index = text}
local mtInstance = {__index = textSwitch}

setmetatable(textSwitch, mtClass)

function textSwitch.new(settings)
    local instance = text.new(settings)
    setmetatable(instance, mtInstance)
	instance.name = settings.name
    return instance
end

function textSwitch:update(dt)
	
end

function textSwitch:draw()
	
end

return textSwitch