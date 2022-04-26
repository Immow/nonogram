local Settings = {}

Settings.ww, Settings.wh = love.graphics.getDimensions()
Settings.focused = true

Settings.button = {}
Settings.button.width = 120
Settings.button.height = 50
Settings.button.padding = 5

Settings.cellSize = 30
Settings.boardOffsetX = 10
Settings.boardOffsetY = 10

-- stuff we save in config.cfg
Settings.problemNr = 1
Settings.markAndCross = true
Settings.hints = true
Settings.validation = true
Settings.time = true

Settings.sfxVolume = 1
Settings.musicVolume = 1
Settings.gamesState = {state = {}, time = {}, size = {}, displayWinAnimation = {}}

return Settings