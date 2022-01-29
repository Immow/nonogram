local s = require("settings")
local problems = require("problems")
local lib = require("lib")

local boardDimensions = {}

boardDimensions.x              = 0
boardDimensions.y              = 0
boardDimensions.width          = nil
boardDimensions.height         = nil

boardDimensions.mainX          = nil
boardDimensions.mainY          = nil
boardDimensions.mainWidth      = nil
boardDimensions.mainHeight     = nil

boardDimensions.leftX          = nil
boardDimensions.leftY          = nil
boardDimensions.leftWidth      = nil
boardDimensions.leftHeight     = nil

boardDimensions.topX           = nil
boardDimensions.topY           = nil
boardDimensions.topWidth       = nil
boardDimensions.topHeight      = nil

boardDimensions.resultLeft     = nil
boardDimensions.resultTop      = nil
boardDimensions.maxNumbersLeft = nil
boardDimensions.maxNumbersTop  = nil

function boardDimensions:load()
	self.matrix_o = problems[s.problem]
	self.matrix_t = lib.Transpose(self.matrix_o)
	self:createNumbers(self.matrix_o, self.resultLeft)
	self:createNumbers(self.matrix_t, self.resultTop)
	self:setMostNumbers()
	self:setWidth()
	self:setHeight()
	self:setMainX()
	self:setMainY()
	self:setMainWidth()
	self:setMainHeight()
	self:setLeftX()
	self:setLeftY()
	self:setLeftWidth()
	self:setLeftHeight()
	self:setTopX()
	self:setTopY()
	self:setTopWidth()
	self:setTopHeight()
end

function boardDimensions:setWidth()
	self.width = (self.maxNumbersLeft + #problems[s.problem]) * s.cellSize
end

function boardDimensions:setHeight()
	self.height = (self.maxNumbersTop + #problems[s.problem]) * s.cellSize
end

function boardDimensions:setMainX()
	self.mainX = (self.maxNumbersLeft * s.cellSize) + self.x
end

function boardDimensions:setMainY()
	self.mainY = (self.maxNumbersTop * s.cellSize) + self.y
end

function boardDimensions:setMainWidth()
	self.mainWidth = #problems[s.problem] * s.cellSize
end

function boardDimensions:setMainHeight()
	self.mainHeight = #problems[s.problem] * s.cellSize
end

function boardDimensions:setLeftX()
	self.leftX = self.x
end

function boardDimensions:setLeftY()
	self.leftY = (self.maxNumbersTop * s.cellSize) + self.y
end

function boardDimensions:setLeftWidth()
	self.setLeftWidth = self.maxNumbersLeft * s.cellSize
end

function boardDimensions:setLeftHeight()
	self.setLeftHeight = self.mainHeight
end

function boardDimensions:setTopX()
	self.topX = (self.maxNumbersLeft * s.cellSize) + self.x
end

function boardDimensions:setTopY()
	self.topY = self.y
end

function boardDimensions:setTopWidth()
	self.setTopWidth = self.mainWidth
end

function boardDimensions:setTopHeight()
	self.setTopHeight = self.maxNumbersTop * s.cellSize
end

function boardDimensions:setMostNumbers()
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
function boardDimensions:createNumbers(input, output)
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

function boardDimensions:purge()
	self.resultLeft = {}
	self.resultTop = {}
end

return boardDimensions