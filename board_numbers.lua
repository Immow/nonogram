local problems = require("problems")
local s        = require("settings")
local number   = require("numbers")
local lib      = require("lib")
local boardDimensions = require("board_dimensions")

local boardNumbers = {}
boardNumbers.resultLeft = {}
boardNumbers.numbersLeft = {}
boardNumbers.resultTop = {}
boardNumbers.numbersTop = {}
boardNumbers.maxNumbersLeft = {}
boardNumbers.maxNumbersTop = {}
boardNumbers.x = 0
boardNumbers.y = 0

function boardNumbers:purge()
	self.resultLeft = {}
	self.numbersLeft = {}
	self.resultTop = {}
	self.numbersTop = {}
end

function boardNumbers:load()
	boardNumbers.matrix_o = problems[s.problem]
	boardNumbers.matrix_t = lib.Transpose(self.matrix_o)
	boardNumbers:createNumbers(self.matrix_o, self.resultLeft)
	boardNumbers:createNumbers(self.matrix_t, self.resultTop)
	boardNumbers:setMostNumbers()
	boardNumbers:setX()
	boardNumbers:setY()
	boardNumbers:setNumberPositionsBoardLeft()
	boardNumbers:setNumberPositionsBoardTop()
end

function boardNumbers:setX()
	self.x = self.maxNumbersLeft * s.cellSize + boardDimensions.x
end

function boardNumbers:setY()
	self.y = self.maxNumbersTop * s.cellSize + boardDimensions.y
end

function boardNumbers:setMostNumbers()
	local countLeft = 0
	for i = 1, #self.resultLeft do
		if countLeft < #self.resultLeft[i] then
			countLeft = #self.resultLeft[i]
		end
		self.maxNumbersLeft = countLeft
	end
	local countTop = 0
	for i = 1, #self.resultTop do
		if countTop < #self.resultTop[i] then
			countTop = #self.resultTop[i]
		end
	end
	self.maxNumbersTop = countTop
end

function boardNumbers:createNumbers(input, output)
	local count = 0
	for i = 1, #input do
		table.insert(output, {})
		for j = #input[i], 1, -1 do

			if input[i][j] == 1 then
				count = count + 1
			end

			if count > 0 and (input[i][j] == 0 or j == 1) then
				table.insert(output[i], count)
				count = 0
			end
		end
	end
end

function boardNumbers:setNumberPositionsBoardLeft()
	local y = self.y
	for i = 1, #problems[s.problem] do
		boardNumbers.numbersLeft[i] = {}
		for j = 1, #boardNumbers.resultLeft[i] do
			local x = self.x - (s.cellSize * j)
			boardNumbers.numbersLeft[i][j] = number.new({x = x, y = y, text = boardNumbers.resultLeft[i][j], font = Default})
		end
		y = y + s.cellSize
	end
end

function boardNumbers:setNumberPositionsBoardTop()
	local x = self.x
	for i = 1, #problems[s.problem][1] do
		boardNumbers.numbersTop[i] = {}
		for j = 1, #boardNumbers.resultTop[i] do
			local y = self.y - (s.cellSize * j)
			boardNumbers.numbersTop[i][j] = number.new({x = x, y = y, text = boardNumbers.resultTop[i][j], font = Default})
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