local problems = require("problems")

if love.filesystem.getInfo("config.cfg") then
	local data = TSerial.unpack(love.filesystem.read("config.cfg"))
	for key, value in pairs(data) do
		Settings[key] = value
	end
end

if love.filesystem.getInfo("game.dat") then
	Settings.gamesState = TSerial.unpack(love.filesystem.read("game.dat"))
else
	for i = 1, #problems do
		table.insert(Settings.gamesState.state, "new")
		table.insert(Settings.gamesState.size, #problems[i].." x "..#problems[i][1])
		table.insert(Settings.gamesState.time, 0)
	end
	love.filesystem.write("game.dat", TSerial.pack(Settings.gamesState, drop, true))
end