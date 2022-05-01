local problems = require("problems")
local boardMain = require("state.game.board_main")

local WinAnimation = {}

function WinAnimation:mousereleased(x,y,button,istouch,presses)
end

function WinAnimation:keypressed(key,scancode,isrepeat)
end

function WinAnimation:update(dt)
	local crossedCell = nil
	local displayWinAnimation = Settings.gamesState.displayWinAnimation[Settings.problemNr]
	local gameState = Settings.gamesState.state[Settings.problemNr] == "solved"
	if displayWinAnimation and gameState then
		for i = 1, #boardMain.cells do
			for j = 1, #boardMain.cells[i] do
				if boardMain.cells[i][j].state == "crossed" then
					if not crossedCell then
						crossedCell = boardMain.cells[i][j]
					end
					
					if crossedCell.y > Settings.wh + 200 then
						Settings.gamesState.displayWinAnimation[Settings.problemNr] = false
						return
					end
					local xRange = love.math.random(-300, 300)
					local yRange = love.math.random(-10, -100)
					local cell = boardMain.cells[i][j]
					local random_x = boardMain.cells[i][j].cross_x + xRange
					local down = boardMain.cells[i][j].cross_y + 50 + Settings.wh
					local random_y_up = boardMain.cells[i][j].cross_y + yRange
					Flux.to(cell, 2.5, {cross_x = random_x, cross_rotation = 2}):ease("linear")
					Flux.to(cell, 0.5, {cross_y = random_y_up}):after(cell, 2,{cross_y = down}):ease("cubicinout")
				end
			end
		end
		Settings.gamesState.displayWinAnimation[Settings.problemNr] = false
	end
end

return WinAnimation