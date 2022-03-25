local Lib = {}

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

function Lib:clearCells(table)
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
end

function Lib:isCellCrossed(arg)
	return arg.state
end

---Arrow right
---@param ox number -- offset x
---@param oy number -- offset y
---@param l number  -- length
---@param w number  -- width
---@param st number -- thickness of shaft
---@param v number  -- oscillating velocity
---@param r number  -- oscillating range
---@return any
function Lib:OscilatingArrowRight(ox, oy, l, w, st, v, r)
    ox = ox + math.cos(love.timer.getTime() * v) * r
    local arrow = {}
    local ah    = w * 0.75 -- how pointy arrow head is
    local x1,y1 = ox         , oy + (w / 2) + (st / 2)
    local x2,y2 = ox + l - ah, oy + (w / 2) + (st / 2)
    local x3,y3 = ox + l - ah, oy + w
    local x4,y4 = ox + l     , oy + w / 2
    local x5,y5 = ox + l - ah, oy
    local x6,y6 = ox + l - ah, oy + (w / 2) - (st / 2)
    local x7,y7 = ox         , oy + (w / 2) - (st / 2)
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
function Lib:OscilatingArrowUp(ox, oy, l, w, st, v, r)
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
    local trig  = love.math.triangulate(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7)
    function arrow.draw()
        for _, v in ipairs(trig) do
            love.graphics.polygon("fill", v)
        end
    end
    return arrow
end

return Lib