if love.filesystem.getInfo("config.cfg") then
	local data = TSerial.unpack(love.filesystem.read("config.cfg"))
	for key, value in pairs(data) do
		Settings[key] = value
	end
end