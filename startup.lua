local problems = require("problems")
local lib      = require("libs.lib")

if love.filesystem.getInfo("config.cfg") then
	local data = Lib:readData("config.cfg")
	for key, value in pairs(data) do
		Settings[key] = value
	end
else
	Lib:writeData("config.cfg", Lib.saveDataList())
end

if love.filesystem.getInfo("game.dat") then
	Settings.gamesState = Lib:readData("game.dat")
else
	for i = 1, #problems do
		table.insert(Settings.gamesState.state, "new")
		table.insert(Settings.gamesState.size, #problems[i].." x "..#problems[i][1])
		table.insert(Settings.gamesState.time, 0)
		table.insert(Settings.gamesState.displayWinAnimation, true)
	end
	Lib:writeData("game.dat", Settings.gamesState)
end

if not love.filesystem.getInfo("game_saves") then
	love.filesystem.createDirectory("game_saves")
end