local problems = require("problems")

if love.filesystem.getInfo("config.cfg") then
	local data = Lib.readData("config.cfg")
	if data.version < Settings.version then
		for _, file in pairs( love.filesystem.getDirectoryItems("/game_saves")) do
			if love.filesystem.getInfo("game_saves/"..file, "file") then
				love.filesystem.remove("game_saves/"..file)
			end
		end

		if love.filesystem.getInfo("game.dat") then
			love.filesystem.remove("game.dat")
		end
		
		Lib.writeData("config.cfg", Lib.saveDataList())
	else
		for key, value in pairs(data) do
			Settings[key] = value
		end
	end
else
	Lib.writeData("config.cfg", Lib.saveDataList())
end

if love.filesystem.getInfo("game.dat") then
	Settings.game = Lib.readData("game.dat")
else
	for i = 1, #problems do
		table.insert(Settings.game.state, "new")
		table.insert(Settings.game.size, #problems[i].." x "..#problems[i][1])
		table.insert(Settings.game.time, 0)
		table.insert(Settings.game.displayWinAnimation, true)
	end
	Lib.writeData("game.dat", Settings.game)
end

if not love.filesystem.getInfo("game_saves") then
	love.filesystem.createDirectory("game_saves")
end