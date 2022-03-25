local state = require("state")
local puzzleGenerator = require("puzzle_generator")
local s = require("settings")
local colors = require("colors")
debug = false

-- FUNCTION TO PRINT TABLES
function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

function love.load()
	love.graphics.setBackgroundColor(colors.black)
	ButtonFont = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 30)
	Default = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 12)
	ProblemNumber = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 50)
	ArrowNumber = love.graphics.newFont("assets/font/Roboto-Regular.ttf", 20)

	state:load()

	-- puzzleGenerator.removeFile()
	-- puzzleGenerator:generate(65, 30, 6, 10)
end

function love.update(dt)
	state:update(dt)
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
