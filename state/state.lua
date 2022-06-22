local State = {}
local scene = {}

function State:load()
	State.setScene("state.menu.menu_main")
end

function State:update(dt)
	if scene.update then scene:update(dt) end
end

function State:draw()
	if scene.draw then scene:draw() end
end

function State:keypressed(key,scancode,isrepeat)
	if scene.keypressed then scene:keypressed(key,scancode,isrepeat) end
end

function State:keyreleased(key,scancode)
	if scene.keyreleased then scene:keyreleased(key,scancode) end
end

function State:mousepressed(x,y,button,istouch,presses)
	if scene.mousepressed then scene:mousepressed(x,y,button,istouch,presses) end
end

function State:mousereleased(x,y,button,istouch,presses)
	if scene.mousereleased then scene:mousereleased(x,y,button,istouch,presses) end
end

function State:mousemoved(x, y, dx, dy, istouch)
	if scene.mousemoved then scene:mousemoved(x, y, dx, dy, istouch) end
end

function State:wheelmoved(x, y)
	if scene.wheelmoved then scene:wheelmoved(x, y) end
end

function State:touchpressed(id,x,y,dx,dy,pressure)
	if scene.touchpressed then scene:touchpressed(id,x,y,dx,dy,pressure) end
end

function State:touchreleased(id,x,y,dx,dy,pressure)
	if scene.touchreleased then scene:touchreleased(id,x,y,dx,dy,pressure) end
end

function State:touchmoved(id,x,y,dx,dy,pressure)
	if scene.touchmoved then scene:touchmoved(id,x,y,dx,dy,pressure) end
end

function State:textinput(t)
	if scene.textinput then scene:textinput(t) end
end

function State.setScene(nextScene)
	scene = require(nextScene)
	if scene.load then scene:load() end
end

return State