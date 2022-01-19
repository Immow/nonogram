local s = require("settings")
local cell = require("cell")
local problems = require("problems")

local BoardCellsTop = {}

local numberCellsTop = {}
BoardCellsTop.x = s.cellSize * math.ceil(#problems[s.problem][1] / 2)
BoardCellsTop.y = 0

function BoardCellsTop:generateNumberCellsTop(r, c)
	local start_x = self.x
	for j = 1, c do
		table.insert(numberCellsTop, {})
		for i = 1, r do
			table.insert(numberCellsTop[j], cell.new({x = self.x, y = self.y, width = s.cellSize, height = s.cellSize, id = "number"}))
			self.x = self.x + s.cellSize
			if i == r then
				self.x = start_x
			end
		end
		self.y = self.y + s.cellSize
	end
end

BoardCellsTop:generateNumberCellsTop(#problems[s.problem][1], math.ceil(#problems[s.problem] / 2))

function BoardCellsTop:draw()
	for i = 1, #numberCellsTop do
		for j = 1, #numberCellsTop[i] do
			numberCellsTop[i][j]:draw()
		end
	end
end

function BoardCellsTop:update(dt)
	-- for i = 1, #boardCells do
	-- 	for j = 1, #boardCells[i]do
	-- 		boardCells[i][j]:update(dt)
	-- 	end
	-- end
end

function BoardCellsTop:mousepressed(x,y,button,istouch,presses)

end

function BoardCellsTop:mousereleased(x,y,button,istouch,presses)
	-- for i = 1, #boardCells do
	-- 	for j = 1, #boardCells[i] do
	-- 		boardCells[i][j].setCell = false
	-- 	end
	-- end
end

return BoardCellsTop