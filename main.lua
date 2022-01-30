local state = require("state")

local s = require("settings")
local colors = require("colors")
debug = false

function love.load()
	love.graphics.setBackgroundColor(colors.black)
	ButtonFont = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 30)
	Default = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 12)
	state:load()
end

function love.update(dt)
	state:update(dt)
end

function love.draw()
	love.graphics.setFont(Default)
	state:draw()
end

function love.keypressed(key,scancode,isrepeat)
	if key == "space" then
		s.problem = 2
		state:setScene("game")
	end
end

function love.keyreleased(key,scancode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed(x,y,button,istouch,presses)
	state:mousepressed(x,y,button,istouch,presses)
end

function love.mousereleased(x,y,button,istouch,presses)
	state:mousereleased(x,y,button,istouch,presses)
end

function love.touchpressed(id,x,y,dx,dy,pressure)

end

function love.touchreleased(id,x,y,dx,dy,pressure)

end

function love.touchmoved(id,x,y,dx,dy,pressure)

end
