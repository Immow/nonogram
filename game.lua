local s              = require("settings")
local problems       = require("problems")
local boardNumbers   = require("board_numbers")
local boardCellsMain = require("board_cells_main")
local boardCellsTop  = require("board_cells_top")
local boardCellsLeft = require("board_cells_left")
local gameButtons    = require("game_buttons")
local boardDimensions = require("board_dimensions")

local Game = {}

function Game:load()
	boardDimensions:purge()
	boardDimensions:load()
	boardNumbers:purge()
	boardNumbers:load()
	boardCellsLeft:generateNumberCellsLeft(boardDimensions.maxNumbersLeft, #problems[s.problem])
	boardCellsTop:generateNumberCellsTop(#problems[s.problem][1], boardDimensions.maxNumbersTop)
	boardCellsMain:load()
	gameButtons:load()
end

function Game:draw()
	boardCellsLeft:draw()
	boardCellsTop:draw()
	boardCellsMain:draw()
	boardNumbers:draw()
	gameButtons:draw()
end

function Game:update(dt)
	boardCellsLeft:update(dt)
	boardCellsTop:update(dt)
	boardCellsMain:update(dt)
	gameButtons:update(dt)
end

function Game:mousepressed(x,y,button,istouch,presses)
	boardCellsMain:mousepressed(x,y,button,istouch,presses)
	gameButtons:mousepressed(x,y,button,istouch,presses)
end

function Game:mousereleased(x,y,button,istouch,presses)
	boardCellsLeft:mousereleased(x,y,button,istouch,presses)
	boardCellsTop:mousereleased(x,y,button,istouch,presses)
	boardCellsMain:mousereleased(x,y,button,istouch,presses)
	gameButtons:mousereleased(x,y,button,istouch,presses)
end

return Game