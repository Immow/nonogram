local problems = require("problems")
local boardMain = require("state.game.board_main")
local cross     = require("constructors.cross")

local WinAnimation = {}

function WinAnimation:mousereleased(x,y,button,istouch,presses)
end

function WinAnimation:update(dt)
	local displayWinAnimation = Settings.gamesState.displayWinAnimation[Settings.problemNr]
	local solvedState = Settings.gamesState.state[Settings.problemNr] == "solved"
	if displayWinAnimation and solvedState then
		for i = 1, #boardMain.cells do
			for j = 1, #boardMain.cells[i] do
				if boardMain.cells[i][j].state == "crossed" then
					local xRange = love.math.random(-300, 300)
					local yRange = love.math.random(-10, -100)
					local cell = boardMain.cells[i][j]
					local random_x = boardMain.cells[i][j].cross_x + xRange
					local down = boardMain.cells[i][j].cross_y + 50 + Settings.wh
					local random_y_up = boardMain.cells[i][j].cross_y + yRange
					Flux.to(cell, 2.5, {cross_x = random_x, crossSpeed =  love.math.random(-10, 10)}):ease("linear")
					Flux.to(cell, 0.5, {cross_y = random_y_up}):after(cell, 2,{cross_y = down}):ease("cubicinout")
				end
			end
		end
		Settings.gamesState.displayWinAnimation[Settings.problemNr] = false
	end
end

return WinAnimation