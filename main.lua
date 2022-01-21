local state = require("state")
local menu = require("menu")
local game = require("game")
local s = require("settings")

function love.load()
	game:load()
end

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
		s.problem = 2
		game:load()
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
