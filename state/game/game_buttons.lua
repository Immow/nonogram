local newButton = require("constructors.button")
local boardMain = require("state.game.board_main")
local boardTop  = require("state.game.board_top")
local boardLeft = require("state.game.board_left")
local problems  = require("problems")

local GameButtons = {}

GameButtons.buttons = {}

local hint = {
	count = 0,
	displayHint = false,
	cell = nil,
	color = 1,
	direction = 1,
	speed = 1.5
}

local function incrementHintCount()
	hint.count = hint.count + 1
end

local function getTotalCells()
	local markedCells = {}
	for i, rows in ipairs(boardMain.cells) do
		for j, cell in ipairs(rows) do
			if cell.state == "empty" and problems[Settings.problemNr][i][j] == 1 then
				table.insert(markedCells, cell)
			end
		end
	end
	return markedCells
end

local function getEmptyCell()
	local cellList = getTotalCells()
	local randomPick = love.math.random(1, #cellList)

	cellList[randomPick]:markCellSolver()
	boardMain:markAllTheThings()
	boardMain:isTheProblemSolved()
	Sound:play("marked", "sfx", Settings.sfxVolume, love.math.random(0.5, 2))
	return cellList[randomPick]
end

local function displayHintCell()
	if not Settings.hints then return end
	if #getTotalCells() == 0 then return end
	hint.color = 1
	hint.displayHint = true
	incrementHintCount()
	hint.cell = getEmptyCell()
	Timer.new(3, function () hint.displayHint = false end)
	WriteSaveData()
end

local function drawHintCell()
	if hint.displayHint then
		love.graphics.setColor(0,hint.color,0)
		love.graphics.rectangle("line", hint.cell.x, hint.cell.y, hint.cell.width, hint.cell.height)
	end
end

local function hintFadeAnimation(dt)
	if hint.displayHint then
		if hint.color > 1 then
			hint.direction = hint.direction * -1
			hint.color = 1
		end

		if hint.color < 0 then
			hint.direction = hint.direction * -1
			hint.color = 0
		end

		hint.color = hint.color + (hint.speed * hint.direction) * dt
	end
end

local function clearCells()
	Lib:clearCells(boardLeft.cells)
	Lib:clearCells(boardMain.cells)
	Lib:clearCells(boardTop.cells)
	Settings.gamesState.state[Settings.problemNr] = "new"
	love.filesystem.write("game.dat", TSerial.pack(Settings.gamesState, drop, true))
end

local function nextProblem()
	if #problems == Settings.problemNr then
		Settings.problemNr = 1
		State.setScene("state.game.game")
	else
		Settings.problemNr = Settings.problemNr + 1
		State.setScene("state.game.game")
	end
end

local function previousProblem()
	if 1 == Settings.problemNr then
		Settings.problemNr = #problems
		State.setScene("state.game.game")
	else
		Settings.problemNr = Settings.problemNr - 1
		State.setScene("state.game.game")
	end
end

local function winningState()
	boardMain.winningState = false
end

local buttonList = {
	{name = "Validate", func = boardMain.validateCells},
	{name = "Clear", func = clearCells},
	{name = "Prev", func = previousProblem},
	{name = "Next", func = nextProblem},
	{name = "Hint", func = displayHintCell},
	{name = "Menu", func = State.setScene, argument = "state.menu.menu_main"},
}

local winButtonList = {
	name = "You win!",
	func = winningState,
	argument = nil,
	x = Settings.ww / 2 - Settings.button.width / 2,
	y = Settings.wh / 2 - Settings.button.height / 2,
}

local winButton = newButton.new({x = winButtonList.x, y = winButtonList.y, width = Settings.button.width, height = Settings.button.height, text = winButtonList["name"], func = winButtonList["func"], font = ButtonFont, argument = winButtonList["argument"]})

function GameButtons:load()
	self:generateButtons()
end


function GameButtons:generateButtons()
	local x = Settings.button.padding
	local y = Settings.wh - (Settings.button.padding + Settings.button.height)
	for i = 1, #buttonList do
		GameButtons.buttons[i] = newButton.new({x = x, y = y, width = Settings.button.width, height = Settings.button.height, text = buttonList[i]["name"], func = buttonList[i]["func"], font = ButtonFont, argument = buttonList[i]["argument"]})
		x = x + Settings.button.width + Settings.button.padding
	end
end

function GameButtons:draw()
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:draw()
	end

	if boardMain.winningState then
		winButton:draw()
	end

	drawHintCell()
end

function GameButtons:update(dt)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:update(dt)
	end

	if boardMain.winningState then
		winButton:update(dt)
	end

	hintFadeAnimation(dt)
end

function GameButtons:mousepressed(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousepressed(x,y,button,istouch,presses)
	end

	if boardMain.winningState then
		winButton:mousepressed(x,y,button,istouch,presses)
	end
end

function GameButtons:mousereleased(x,y,button,istouch,presses)
	for i = 1, #GameButtons.buttons do
		GameButtons.buttons[i]:mousereleased(x,y,button,istouch,presses)
	end

	if boardMain.winningState then
		winButton:mousereleased(x,y,button,istouch,presses)
	end
end

return GameButtons