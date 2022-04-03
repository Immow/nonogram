Default       = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 12)
ButtonFont    = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 30)
SettingsFont  = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 19)
TitleFont     = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 30)
ProblemNumber = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 50)
ArrowNumber   = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 20)
Percentage    = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 16)

TSerial  = require("libs.TSerial")
Settings = require("settings")
Colors   = require("libs.colors")
Timer    = require("libs.timer")
Sound    = require("libs.sounds")

require("startup")

local state  = require("state.state")
-- require("libs.TPrint")
debug = false

function love.load()
	love.graphics.setBackgroundColor(Colors.black)
	Sound:play("music", "music", Settings.musicVolume, 1, true)
	state:load()
	-- puzzleGenerator.removeFile()
	-- puzzleGenerator:generate(15, 15, 6, 20)
end

function love.update(dt)
	state:update(dt)
	Timer.updateAll(dt)
end

function love.draw()
	love.graphics.setFont(Default)
	state:draw()
end

function love.keypressed(key,scancode,isrepeat)
	state:keypressed(key,scancode, isrepeat)
end

function love.keyreleased(key,scancode)
	state:keyreleased(key,scancode)
end

function love.mousepressed(x,y,button,istouch,presses)
	state:mousepressed(x,y,button,istouch,presses)
end

function love.mousereleased(x,y,button,istouch,presses)
	state:mousereleased(x,y,button,istouch,presses)
end

function love.touchpressed(id,x,y,dx,dy,pressure)
	state:touchpressed(id,x,y,dx,dy,pressure)
end

function love.touchreleased(id,x,y,dx,dy,pressure)
	state:touchreleased(id,x,y,dx,dy,pressure)
end

function love.touchmoved(id,x,y,dx,dy,pressure)
	state:touchmoved(id,x,y,dx,dy,pressure)
end
