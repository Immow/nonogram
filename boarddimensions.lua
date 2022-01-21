local s = require("settings")
local problems = require("problems")

local BoardDimensions = {}

function BoardDimensions.getXofBoardcellMain(table)
	return s.cellSize * math.ceil(#problems[s.problem][1] / 2)
end

function BoardDimensions.getYBoardcellMain()
	return s.cellSize * math.ceil(#problems[s.problem] / 2)
end

return BoardDimensions