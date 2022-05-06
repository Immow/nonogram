local boardMain = require("state.game.board_main")
local boardLeft = require("state.game.board_left")
local boardTop  = require("state.game.board_top")

local WinAnimation = {}

function WinAnimation:mousereleased(x,y,button,istouch,presses)
end

function WinAnimation:animateWinAnimation(displayWinAnimation, solvedState, board)
	if displayWinAnimation and solvedState then
		for i = 1, #board.cells do
			for j = 1, #board.cells[i] do
				if board.cells[i][j].state == "crossed" then
					local xRange = love.math.random(-400, 400)
					local yRange = love.math.random(-50, -150)
					local rotationspeed = love.math.random(-20, 20) -- love.math.random() > 0.5 and 1 or -1
					local cell = board.cells[i][j]
					local moveCell_x = board.cells[i][j].cross_x + xRange
					local moveCellDown = board.cells[i][j].cross_y + 50 + Settings.wh
					local moveCellSqueezeDown = board.cells[i][j].cross_y + (Settings.cellSize - cell.cross.offset * 2) * 0.2
					local moveCellSqueezeUp = board.cells[i][j].cross_y - (Settings.cellSize - cell.cross.offset * 2) * 0.2
					local moveCellUp = board.cells[i][j].cross_y + yRange
					Timer.new(love.math.random(0, 100)/ 80, function ()
						Flux.to(cell, .7, {crossScale_x = .5, crossScale_y = .2, cross_y = moveCellSqueezeDown}):ease("quadin")
							:after(cell, .3, {crossScale_x = 1, crossScale_y = 1, cross_y = moveCellSqueezeUp}):ease("backout")
							:after(cell, 3, {cross_x = moveCell_x, crossRotationSpeed = rotationspeed})
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

function WinAnimation:update(dt)
	local displayWinAnimation = Settings.gamesState.displayWinAnimation[Settings.problemNr]
	local solvedState = Settings.gamesState.state[Settings.problemNr] == "solved"
	self:animateWinAnimation(displayWinAnimation, solvedState, boardMain)
	self:animateWinAnimation(displayWinAnimation, solvedState, boardLeft)
	self:animateWinAnimation(displayWinAnimation, solvedState, boardTop)
end

return WinAnimation