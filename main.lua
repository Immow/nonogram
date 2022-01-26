local state = require("state")
local menu = require("menu")
local game = require("game")
local s = require("settings")
local colors = require("colors")

function love.load()
	love.graphics.setBackgroundColor(colors.black)
	ButtonFont = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 30)
	Default = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 12)

	if state.game then game:load() end
end

function love.update(dt)
	if state.menu then menu:update(dt) end
	if state.game then game:update(dt) end
end

function love.draw()
	-- love.graphics.setFont(Default)
	if state.menu then menu:draw() end
	if state.game then game:draw() end
end

function love.keypressed(key,scancode,isrepeat)
	if key == "space" then
		s.problem = 2
		game:load()
	end
end

function love.keyreleased(key,scancode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed(x,y,button,istouch,presses)
	if state.game then game:mousepressed(x,y,button,istouch,presses) end
end

function love.mousereleased(x,y,button,istouch,presses)
	if state.game then game:mousereleased(x,y,button,istouch,presses) end
end

function love.touchpressed(id,x,y,dx,dy,pressure)

end

function love.touchreleased(id,x,y,dx,dy,pressure)

end

function love.touchmoved(id,x,y,dx,dy,pressure)

end
