local s = require("settings")
local problems = require("problems")
local lib = require("lib")

local BoardDimensions = {
	x              = 0,
	y              = 0,
	width          = nil,
	height         = nil,
	mainX          = nil,
	mainY          = nil,
	mainWidth      = nil,
	mainHeight     = nil,
	leftX          = nil,
	leftY          = nil,
	leftWidth      = nil,
	leftHeight     = nil,
	topX           = nil,
	topY           = nil,
	topWidth       = nil,
	topHeight      = nil,
	resultLeft     = nil,
	resultTop      = nil,
	maxNumbersLeft = nil,
	maxNumbersTop  = nil,
}

function BoardDimensions:load()
	self.matrix_o = problems[s.problem]
	self.matrix_t = lib.Transpose(self.matrix_o)
	self:createNumbers(self.matrix_o, self.resultLeft)
	self:createNumbers(self.matrix_t, self.resultTop)
	self:setMostNumbers()
	self.width = (self.maxNumbersLeft + #problems[s.problem][1]) * s.cellSize + self.x
	self.height = (self.maxNumbersTop + #problems[s.problem][1]) * s.cellSize + self.y
	self.mainX = (self.maxNumbersLeft * s.cellSize) + self.x
	self.mainY = (self.maxNumbersTop * s.cellSize) + self.y
	self.mainWidth = #problems[s.problem] * s.cellSize
	self.mainHeight = #problems[s.problem] * s.cellSize
	self.leftX = self.x
	self.leftY = (self.maxNumbersTop * s.cellSize) + self.y
	self.setLeftWidth = self.maxNumbersLeft * s.cellSize
	self.setLeftHeight = self.mainHeight
	self.topX = (self.maxNumbersLeft * s.cellSize) + self.x
	self.topY = self.y
	self.setTopWidth = self.mainWidth
	self.setTopHeight = self.maxNumbersTop * s.cellSize
end

function BoardDimensions:setMostNumbers()
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

--- generates the numbers for top and left board
function BoardDimensions:createNumbers(input, output)
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

function BoardDimensions:purge()
	self.resultLeft = {}
	self.resultTop = {}
end

return BoardDimensions