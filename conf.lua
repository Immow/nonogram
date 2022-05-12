function love.conf(t)
	t.title = "Nonogram"
	t.identity = "Nonogram"
	t.version = "11.3"
	t.console = true
	t.window.width = 1080
	t.window.height = 800
	t.window.msaa = 8
	t.modules.joystick = false
	t.modules.physics = false
	t.externalstorage = true
	t.window.vsync = 1
	t.window.resizable = false
end