local problems = require("problems")

local BoardDimensions = {
	x               = Settings.boardOffsetX,
	y               = Settings.boardOffsetY,
	width           = nil,
	height          = nil,
	mainX           = nil,
	mainY           = nil,
	mainWidth       = nil,
	mainHeight      = nil,
	mainCellCount_x = nil,
	mainCellCount_y = nil,
	leftX           = nil,
	leftY           = nil,
	leftWidth       = nil,
	leftHeight      = nil,
	topX            = nil,
	topY            = nil,
	topWidth        = nil,
	topHeight       = nil,
	resultLeft      = nil,
	resultTop       = nil,
	maxNumbersLeft  = nil,
	maxNumbersTop   = nil,
}

function BoardDimensions:load()
	self.resultLeft = {}
	self.resultTop = {}
	self.matrix_o = problems[Settings.problemNr]
	self.matrix_t = Lib.Transpose(self.matrix_o)
	self:createNumbers(self.matrix_o, self.resultLeft)
	self:createNumbers(self.matrix_t, self.resultTop)
	self:setMostNumbers()
	self.width = (self.maxNumbersLeft + #problems[Settings.problemNr][1]) * Settings.cellSize + self.x
	self.height = (self.maxNumbersTop + #problems[Settings.problemNr]) * Settings.cellSize + self.y
	self.mainX = (self.maxNumbersLeft * Settings.cellSize) + self.x
	self.mainY = (self.maxNumbersTop * Settings.cellSize) + self.y
	self.mainWidth = #problems[Settings.problemNr][1] * Settings.cellSize
	self.mainHeight = #problems[Settings.problemNr] * Settings.cellSize
	self.mainCellCount_x = #problems[Settings.problemNr][1]
	self.mainCellCount_y = #problems[Settings.problemNr]
	self.leftX = self.x
	self.leftY = (self.maxNumbersTop * Settings.cellSize) + self.y
	self.leftWidth = self.maxNumbersLeft * Settings.cellSize
	self.leftHeight = self.mainHeight
	self.topX = (self.maxNumbersLeft * Settings.cellSize) + self.x
	self.topY = self.y
	self.topWidth = self.mainWidth
	self.topHeight = self.maxNumbersTop * Settings.cellSize
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
		for j = #input[i], 1, -1 do -- insert the numbers in reverse
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

return BoardDimensions