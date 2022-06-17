local Lib = {}

function Lib.writeData(name, data)
	love.filesystem.write(name, TSerial.pack(data, drop, true))
end

function Lib.readData(name)
	return TSerial.unpack(love.filesystem.read(name))
end

function Lib.copyCellState(cells)
	local out = {}
	for i, rows in ipairs(cells) do
		out[i] = {}
		for _, cell in ipairs(rows) do
			if cell.state then
				table.insert(out[i], cell.state)
			end
		end
	end

	return out
end

function Lib.Transpose(m)
	local res = {}

	for i = 1, #m[1] do
		res[i] = {}
		for j = 1, #m do
			res[i][j] = m[j][i]
		end
	end

	return res
end

function Lib.clearCells(table)
	for i = 1, #table do
		for j = 1, #table[i] do
			table[i][j].state = "empty"
			table[i][j].setCell = false
			table[i][j].alpha = 0
			table[i][j].fade = false
			table[i][j].locked = false
			table[i][j].wrong = false
		end
	end

	if love.filesystem.getInfo("game_saves/"..Settings.problemNr..".dat") then
		love.filesystem.remove("game_saves/"..Settings.problemNr..".dat")
	end
end

function Lib.loadSaveState(object, name)
	if love.filesystem.getInfo("game_saves/"..Settings.problemNr..".dat") then
		local data = Lib.readData("game_saves/"..Settings.problemNr..".dat")
		for i, rows in ipairs(data[name]) do
			for j, value in ipairs(rows) do
				object[i][j].state = value
				object[i][j].fade = true
			end
		end
	end
end

function Lib.saveDataList()
	return {
		problemNr    = Settings.problemNr,
		markAndCross = Settings.markAndCross,
		hints        = Settings.hints,
		validation   = Settings.validation,
		time         = Settings.displayTime,
		sfxVolume    = Settings.sfxVolume,
		musicVolume  = Settings.musicVolume,
		displayTouch = Settings.displayTouch,
		version      = Settings.version,
	}
end

function Lib.onBoard(x, y, board_x, board_y, board_width, board_height)
	return x >= board_x and x <= board_width and y >= board_y and y <= board_height
end

function Lib.isCellCrossed(arg)
	return arg.state
end

---Arrow left
---@param ox number -- offset x
---@param oy number -- offset y
---@param l number  -- length
---@param w number  -- width
---@param st number -- thickness of shaft
---@param v number  -- oscillating velocity
---@param r number  -- oscillating range
---@return any
function Lib.OscilatingArrowLeft(ox, oy, l, w, st, v, r)
    ox = ox + math.cos(love.timer.getTime() * v) * r
    local arrow = {}
    local ah    = w * 0.75 -- how pointy arrow head is
    local x1,y1 = ox     , oy + (w / 2)
    local x2,y2 = ox + ah, oy + w
    local x3,y3 = ox + ah, oy + (w / 2) + (st / 2)
    local x4,y4 = ox + l , oy + (w / 2) + (st / 2)
    local x5,y5 = ox + l , oy + (w / 2) - (st / 2)
    local x6,y6 = ox + ah, oy + (w / 2) - (st / 2)
    local x7,y7 = ox + ah, oy
---@diagnostic disable-next-line: redundant-parameter
    local trig  = love.math.triangulate(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7)
    function arrow.draw()
        for _, v in ipairs(trig) do
            love.graphics.polygon("fill", v)
        end
    end
    return arrow
end

---Arrow up
---@param ox number -- offset x
---@param oy number -- offset y
---@param l number  -- length
---@param w number  -- width
---@param st number -- thickness of shaft
---@param v number  -- oscillating velocity
---@param r number  -- oscillating range
---@return any
function Lib.OscilatingArrowUp(ox, oy, l, w, st, v, r)
    oy = oy + math.cos(love.timer.getTime() * v) * r
    local arrow = {}
    local ah    = w * 0.75 -- how pointy arrow head is
    local x1,y1 = ox + w / 2, oy
    local x2,y2 = ox, oy + ah
    local x3,y3 = ox + (w / 2) - (st / 2), oy + ah
    local x4,y4 = ox + (w / 2) - (st / 2) , oy + l
    local x5,y5 = ox + (w / 2) + (st / 2) , oy + l
    local x6,y6 = ox + (w / 2) + (st / 2) , oy + ah
    local x7,y7 = ox + w, oy + ah
---@diagnostic disable-next-line: redundant-parameter
    local trig  = love.math.triangulate(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7)
    function arrow.draw()
        for _, v in ipairs(trig) do
            love.graphics.polygon("fill", v)
        end
    end
    return arrow
end

return Lib