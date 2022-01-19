local Settings = {}

Settings.problem = 1
Settings.ww, Settings.wh = love.graphics.getDimensions()
Settings.cellSize = (Settings.wh -200) / 10

return Settings