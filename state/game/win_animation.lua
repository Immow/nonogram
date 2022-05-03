local boardMain = require("state.game.board_main")

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
					local xRange = love.math.random(-400, 400)
					local yRange = love.math.random(-50, -150)
					local speed = love.math.random(-10, 10)
					local cell = boardMain.cells[i][j]
					local moveCell_x = boardMain.cells[i][j].cross_x + xRange
					local moveCellDown = boardMain.cells[i][j].cross_y + 50 + Settings.wh
					local moveCellSqueezeDown = boardMain.cells[i][j].cross_y + (Settings.cellSize - cell.cross.offset * 2) * 0.2
					local moveCellSqueezeUp = boardMain.cells[i][j].cross_y - (Settings.cellSize - cell.cross.offset * 2) * 0.2
					local moveCellUp = boardMain.cells[i][j].cross_y + yRange
					Timer.new(love.math.random(0, 100)/ 80, function ()
						Flux.to(cell, .7, {crossScale_x = .5, crossScale_y = .2, cross_y = moveCellSqueezeDown}):ease("quadin")
							:after(cell, .3, {crossScale_x = 1, crossScale_y = 1, cross_y = moveCellSqueezeUp}):ease("backout")
							:after(cell, 3, {cross_x = moveCell_x, crossRotationSpeed = speed})
							:ease("linear"):oncomplete(function() cell.crossRotationSpeed = 0 end)

						Flux.to(cell, 0.5, {cross_y = moveCellUp}):delay(0.8)
							:after(cell, 3,{cross_y = moveCellDown}):ease("cubicinout")
					end)
				end
			end
		end
		Sound:play("beep", "sfx", Settings.sfxVolume, 1)
		Settings.gamesState.displayWinAnimation[Settings.problemNr] = false -- makes loop only run once.
	end
end

return WinAnimation