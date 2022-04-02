local Settings = {}

Settings.problem = 1
Settings.ww, Settings.wh = love.graphics.getDimensions()

Settings.button = {}
Settings.button.width = 120
Settings.button.height = 50
Settings.button.padding = 5

Settings.cellSize = 30
Settings.boardOffsetX = 10
Settings.boardOffsetY = 10

Settings.markAndCross = true
Settings.hints = true
Settings.validation = true

return Settings