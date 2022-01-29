local problems = require("problems")
local s        = require("settings")
local number   = require("numbers")
local boardDimensions = require("board_dimensions")

local boardNumbers = {}

boardNumbers.numbersLeft = {}
boardNumbers.numbersTop = {}

boardNumbers.x = 0
boardNumbers.y = 0

function boardNumbers:purge()
	self.numbersLeft = {}
	self.numbersTop = {}
end

function boardNumbers:load()
	boardNumbers:setNumberPositionsBoardLeft()
	boardNumbers:setNumberPositionsBoardTop()
end

function boardNumbers:setNumberPositionsBoardLeft()
	self.x = boardDimensions.mainX
	local y = boardDimensions.mainY
	for i = 1, #problems[s.problem] do
		boardNumbers.numbersLeft[i] = {}
		for j = 1, #boardDimensions.resultLeft[i] do
			local x = self.x - (s.cellSize * j)
			boardNumbers.numbersLeft[i][j] = number.new({x = x, y = y, text = boardDimensions.resultLeft[i][j], font = Default})
		end
		y = y + s.cellSize
	end
end

function boardNumbers:setNumberPositionsBoardTop()
	local x = boardDimensions.mainX
	self.y = boardDimensions.mainY
	for i = 1, #problems[s.problem][1] do
		boardNumbers.numbersTop[i] = {}
		for j = 1, #boardDimensions.resultTop[i] do
			local y = self.y - (s.cellSize * j)
			boardNumbers.numbersTop[i][j] = number.new({x = x, y = y, text = boardDimensions.resultTop[i][j], font = Default})
		end
		x = x + s.cellSize
	end
end

function boardNumbers:draw()
	for i = 1, #boardNumbers.numbersLeft do
		for j = 1, #boardNumbers.numbersLeft[i] do
			boardNumbers.numbersLeft[i][j]:draw()
		end
	end

	for i = 1, #boardNumbers.numbersTop do
		for j = 1, #boardNumbers.numbersTop[i] do
			boardNumbers.numbersTop[i][j]:draw()
		end
	end
end

return boardNumbers