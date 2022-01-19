local s = require("settings")
local cell = require("cell")
local problems = require("problems")

local BoardCellsLeft = {}

local numbersPerRow = {}
local numbersPerColumn = {}

local numberCellsLeft = {}
BoardCellsLeft.x = 0
BoardCellsLeft.y = s.cellSize * math.ceil(#problems[s.problem] / 2)


function BoardCellsLeft:generateNumberCellsLeft(r, c)
	local start_x = self.x
	for j = 1, c do
		table.insert(numberCellsLeft, {})
		for i = 1, r do
			table.insert(numberCellsLeft[j], cell.new({x = self.x, y = self.y, width = s.cellSize, height = s.cellSize, id = "number"}))
			self.x = self.x + s.cellSize
			if i == r then
				self.x = start_x
			end
		end
		self.y = self.y + s.cellSize
	end
end

BoardCellsLeft:generateNumberCellsLeft(math.ceil(#problems[s.problem][1] / 2), #problems[s.problem])

function BoardCellsLeft:draw()

	for i = 1, #numberCellsLeft do
		for j = 1, #numberCellsLeft[i] do
			numberCellsLeft[i][j]:draw()
		end
	end
end

function BoardCellsLeft:update(dt)
	-- for i = 1, #boardCells do
	-- 	for j = 1, #boardCells[i]do
	-- 		boardCells[i][j]:update(dt)
	-- 	end
	-- end
end

function BoardCellsLeft:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsLeft:mousereleased(x,y,button,istouch,presses)
	-- for i = 1, #boardCells do
	-- 	for j = 1, #boardCells[i] do
	-- 		boardCells[i][j].setCell = false
	-- 	end
	-- end
end

return BoardCellsLeft