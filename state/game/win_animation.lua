local problems = require("problems")
local boardMain = require("state.game.board_main")

local WinAnimation = {time = 2, animatedCells = {}}

-- function WinAnimation:fadeAnimation(dt)
-- 	if self.color > 1 then
-- 		self.direction = self.direction * -1
-- 		self.color = 1
-- 	end

-- 	if self.color < 0 then
-- 		self.direction = self.direction * -1
-- 		self.color = 0
-- 	end

-- 	self.color = self.color + (self.speed * self.direction) * dt
-- end

function WinAnimation.setClickedCellWinAnimation()
	if Settings.gamesState.displayWinAnimation[Settings.problemNr] and
		Settings.gamesState.state[Settings.problemNr] == "solved" then
		boardMain.clickedCell.winAnimation = true
		-- print(TPrint.print(boardMain.clickedCell.foundCellsToAnimate))
		-- for key, value in pairs(boardMain.clickedCell.foundCellsToAnimate) do
		-- 	print(value)
		-- end
	end
end

function WinAnimation:mousereleased(x,y,button,istouch,presses)
	self.setClickedCellWinAnimation()
end

function WinAnimation:keypressed(key,scancode,isrepeat)
end

function WinAnimation:update(dt)
	if Settings.gamesState.displayWinAnimation then
		for i = 1, #boardMain.cells do
			for j = 1, #boardMain.cells[i] do
				if #boardMain.cells[i][j].foundCellsToAnimate > 0 then
					for key, value in pairs(boardMain.cells[i][j].foundCellsToAnimate) do
						boardMain.cells[value.y][value.x].winAnimation = true
					end
				end
			end
		end
	end
	-- self:fadeAnimation(dt)
	-- if self.time - dt > 0 then
	-- 	self.time = self.time - dt
	-- else
	-- 	self:remove()
	-- end
end

return WinAnimation