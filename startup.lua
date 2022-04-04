if love.filesystem.getInfo("config.cfg") then
	local data = TSerial.unpack(love.filesystem.read("config.cfg"))
	-- Settings = data
	for key, value in pairs(data) do
		print(Settings[key])
		Settings[key] = value
	end

	-- print(Settings["hints"])
end