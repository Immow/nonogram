local Editor = {}

local puzzle = {
	width = 0,
	height = 0,
}

function Editor:load()
	puzzle.width = 5
	puzzle.height = 5
end

function Editor:update(dt)
end

function Editor:draw()
	love.graphics.rectangle("fill", 10,10,150,80)
	love.graphics.rectangle("fill", 170,10,150,80)
	love.graphics.setColor(1,1,1)
end

return Editor