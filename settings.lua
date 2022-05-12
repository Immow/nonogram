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
Settings.displayTime = true
Settings.sfxVolume = 0.5
Settings.musicVolume = 0.5
Settings.displayTouch = true
Settings.version = 0.03

-- stuff we save in game.dat
Settings.game = {state = {}, time = {}, size = {}, displayWinAnimation = {}}

return Settings