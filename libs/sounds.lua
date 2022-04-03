
local Sound = {
	active = {},
	source = {},
}

function Sound:init(id, source, soundType)
	soundType = soundType or "static"
	if Sound.source[id] ~= nil then return end
	if type(source) == "table" then
		Sound.source[id] = {}
		for i=1,#source do
			Sound.source[id][i] = love.audio.newSource(source[i], soundType)
		end
	else
		Sound.source[id] = love.audio.newSource(source, soundType)
	end
end

-- SFX
Sound:init("marked", {"assets/sfx/marked.wav"})
Sound:init("click", {"assets/sfx/click.wav"})
Sound:init("beep", {"assets/sfx/beep.wav"})
Sound:init("crossed", {"assets/sfx/crossed.wav"})

-- Music
Sound:init("music", {"assets/music/Adventure-320bit.mp3"})

function Sound:play(id, channel, volume, pitch, loop)
	assert(Sound.source[id] ~= nil, "ID does not exist.")
	local source
	if type(Sound.source[id]) == "table" then
		source = Sound.source[id][math.random(1,#Sound.source[id])]
	else
		source = Sound.source[id]
	end
	local clone = source:clone()
	clone:setVolume(volume or 1 * math.random(90,100) / 100)
	clone:setPitch(pitch or 1 *	math.random(90,110) / 100)
	clone:setLooping(loop or false)
	clone:play()
	if Sound.active[channel] == nil then
		Sound.active[channel] = {}
	end
	table.insert(Sound.active[channel], clone)
end

function Sound:stop(channel)
	assert(Sound.active[channel] ~= nil, "Channel does not exist")
	for k,sound in pairs(Sound.active[channel]) do
		sound:stop()
	end
end

function Sound:setVolume(channel, volume)
	assert(Sound.active[channel] ~= nil, "Channel does not exist")
	for k,sound in pairs(Sound.active[channel]) do
		sound:setVolume(volume)
	end
end

function Sound:setPitch(channel, pitch)
	assert(Sound.active[channel] ~= nil, "Channel does not exist")
	for k,sound in pairs(Sound.active[channel]) do
		sound:setPitch(pitch)
	end
end

function Sound:update()
	for k, channel in pairs(Sound.active) do
		if channel[1] ~= nil and not channel[1]:isPlaying() then
			table.remove(channel, 1)
		end
	end
end

return Sound
