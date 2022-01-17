local state = require("state")
local menu = require("menu")
local game = require("game")

function love.update(dt)
	if state.menu then menu:update(dt) end
	if state.running then game:update(dt) end
end

function love.draw()
	if state.menu then menu:draw() end
	if state.running then game:draw() end
end

function love.keypressed(key,scancode,isrepeat)
	if key == "space" then
		state:changeState("running")
	end
end

function love.keyreleased(key,scancode)

end

function love.mousepressed(x,y,button,istouch,presses)
	if state.running then game:mousepressed(x,y,button,istouch,presses) end
end

function love.mousereleased(x,y,button,istouch,presses)
	if state.running then game:mousereleased(x,y,button,istouch,presses) end
end

function love.touchpressed(id,x,y,dx,dy,pressure)

end

function love.touchreleased(id,x,y,dx,dy,pressure)

end

function love.touchmoved(id,x,y,dx,dy,pressure)

end
