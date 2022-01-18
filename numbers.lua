local Numbers = {}
Numbers.__index = Numbers

function Numbers.new(settings)
	local instance = setmetatable({}, Numbers)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.font = settings.font or love.graphics.getFont()
	instance.fontSize = settings.fontSize or 12
	instance.rows = settings.rows or 1
	instance.columns = settings.columns or 1
	return instance
end

function Numbers:update(dt)
	
end

function Numbers:draw()
	
end

return Numbers