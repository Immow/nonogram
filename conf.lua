function love.conf(t)
	t.title = "Nonogram"
	t.identity = "Nonogram"
	t.version = "11.3"
	t.console = true
	t.window.width = 800
	t.window.height = 600
	t.window.msaa = 8
	t.modules.joystick = false
	t.modules.physics = false
	t.externalstorage = true
	t.window.vsync = 0
	t.window.resizable = false
end