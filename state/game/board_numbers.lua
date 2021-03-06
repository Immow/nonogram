local problems        = require("problems")
local number          = require("constructors.numbers")
local boardDimensions = require("state.game.board_dimensions")

local BoardNumbers = {}

BoardNumbers.numbersLeft = {}
BoardNumbers.numbersTop = {}

BoardNumbers.x = 0
BoardNumbers.y = 0

function BoardNumbers:load()
	self.numbersLeft = {}
	self.numbersTop = {}
	BoardNumbers:setNumberPositionsBoardLeft()
	BoardNumbers:setNumberPositionsBoardTop()
end

function BoardNumbers:setNumberPositionsBoardLeft()
	self.x = boardDimensions.mainX
	local y = boardDimensions.mainY
	for i = 1, #problems[Settings.problemNr] do
		BoardNumbers.numbersLeft[i] = {}
		for j = 1, #boardDimensions.resultLeft[i] do
			local x = self.x - (Settings.cellSize * j)
			BoardNumbers.numbersLeft[i][j] = number.new({x = x, y = y, text = boardDimensions.resultLeft[i][j], font = Default})
		end
		y = y + Settings.cellSize
	end
end

function BoardNumbers:setNumberPositionsBoardTop()
	local x = boardDimensions.mainX
	self.y = boardDimensions.mainY
	for i = 1, #problems[Settings.problemNr][1] do
		BoardNumbers.numbersTop[i] = {}
		for j = 1, #boardDimensions.resultTop[i] do
			local y = self.y - (Settings.cellSize * j)
			BoardNumbers.numbersTop[i][j] = number.new({x = x, y = y, text = boardDimensions.resultTop[i][j], font = Default})
		end
		x = x + Settings.cellSize
	end
end

function BoardNumbers:draw()
	for i = 1, #BoardNumbers.numbersLeft do
		for j = 1, #BoardNumbers.numbersLeft[i] do
			BoardNumbers.numbersLeft[i][j]:draw()
		end
	end

	for i = 1, #BoardNumbers.numbersTop do
		for j = 1, #BoardNumbers.numbersTop[i] do
			BoardNumbers.numbersTop[i][j]:draw()
		end
	end
end

return BoardNumbers