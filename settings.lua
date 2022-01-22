local Settings = {}

Settings.problem = 1
Settings.ww, Settings.wh = love.graphics.getDimensions()

Settings.button = {}
Settings.button.width = 200
Settings.button.height = 50
Settings.button.padding = 5
Settings.button.x = Settings.ww - Settings.button.width - Settings.button.padding
Settings.button.y = Settings.wh - Settings.button.height - Settings.button.padding

Settings.cellSize = 30

return Settings