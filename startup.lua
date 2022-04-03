if love.filesystem.getInfo("config.cfg") then
	local data = TSerial.unpack(love.filesystem.read("config.cfg"))
	Settings = data
end