local problems = require("problems")
local boardMain = require("state.game.board_main")
local boardLeft = require("state.game.board_left")
local boardTop = require("state.game.board_top")

local Hint = {}
Hint.__index = Hint
local active = {}

local function getTotalCells()
	local cells = {}
	for i, rows in ipairs(boardMain.cells) do
		for j, cell in ipairs(rows) do
			if cell.state == "empty" and problems[Settings.problemNr][i][j] == 1 then
				table.insert(cells, cell)
			end
		end
	end
	return cells
end

local function getEmptyCell()
	local cellList = getTotalCells()
	if #cellList > 0 then
		local random = love.math.random(1, #cellList)
	
		cellList[random]:markCellSolver()
		boardMain:markAllTheThings()
		boardMain:isTheProblemSolved()
		Sound:play("marked", "sfx", Settings.sfxVolume, love.math.random(0.5, 2))
		return cellList[random]
	end
end

function Hint.new(time)
	local instance = setmetatable({}, Hint)
	instance.time = time
	instance.count = 0
	instance.cell = getEmptyCell() or nil
	instance.color = 1
	instance.direction = 1
	instance.speed = 1.5
	table.insert(active, instance)

	local data = {
		main = Lib.copyCellState(boardMain.cells),
		left = Lib.copyCellState(boardLeft.cells),
		top = Lib.copyCellState(boardTop.cells),
	}
	
	Lib.writeData("game_saves/"..Settings.problemNr..".dat", data)
end

-- local function incrementHintCount()
-- 	hint.count = hint.count + 1
-- end

function Hint:fadeAnimation(dt)
	if self.color > 1 then
		self.direction = self.direction * -1
		self.color = 1
	end

	if self.color < 0 then
		self.direction = self.direction * -1
		self.color = 0
	end

	self.color = self.color + (self.speed * self.direction) * dt
end

function Hint.purge()
	active = {}
end

function Hint:remove()
	for i ,Hint in ipairs(active) do
		if self == Hint then
			table.remove(active, i)
			return
		end
	end
end

function Hint:draw()
	if Settings.hints and self.cell then
		love.graphics.setColor(0, self.color, 0)
		love.graphics.rectangle("line", self.cell.x, self.cell.y, self.cell.width, self.cell.height)
	end
	love.graphics.reset()
end

function Hint.drawAll()
	for _, Hint in ipairs(active) do
		Hint:draw()
	end
end

function Hint:update(dt)
	self:fadeAnimation(dt)
	if self.time - dt > 0 then
		self.time = self.time - dt
	else
		self:remove()
	end
end

function Hint.updateAll(dt)
	for _, Hint in ipairs(active) do
		Hint:update(dt)
	end
end

return Hint