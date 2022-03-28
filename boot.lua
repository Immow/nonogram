Boot = {}

function Boot:load()
    self:FileCheck()
    -- self:ConfigCheck()
    -- self:SetGameId()
    self:LoadGameList()
    -- self:OsCheck()
    -- self:CheckFireworks()
end

--- Checks if OS is Android or IOS
--@return true if OS is Android or IOS
-- function Boot:OsCheck()
--     if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then
--         return true
--     else
--         return false
--     end
-- end

--- Chekcs if problems.dat & numbergame.cfg are present and creates them if not
function Boot:FileCheck()
    if not love.filesystem.getInfo("problems.dat") then
        love.filesystem.write("problems.dat", TSerial.pack(s.gameData, drop, false))
    end
    if not love.filesystem.getInfo("numbergame.cfg") then
        love.filesystem.write("numbergame.cfg", TSerial.pack(self:ConfigSettings(),drop, false))
    end
end

--- default table data to write in FileCheck() to numbergame.cfg
--@return table _ sound, difficuly and boardsize
-- function Boot:ConfigSettings()
--     if not love.filesystem.getInfo("numbergame.cfg") then
--         return {masterVolume = 1, effectVolume = 1, musicVolume = 1, difficulty = "easy", boardsize = 9, gameId = 1, gameState = "MenuMain", gameIdEasy = 1, gameIdMedium = 1, gameIdHard = 1, gameIdTutorial = 1, version = s.version}
--     end
-- end

--- Reads from numbergame.cfg and sets s.difficulty, sound settings and s.GameBoardSize. If values are nil then use defaults.
-- function Boot:ConfigCheck()
--     if love.filesystem.getInfo("numbergame.cfg") then
--         local temp = TSerial.unpack(s.lr("numbergame.cfg"))
--         if not temp["version"] or temp["version"] < s.version then
--             love.filesystem.write("numbergame.cfg", TSerial.pack({masterVolume = 1, effectVolume = 1, musicVolume = 1, difficulty = "easy", boardsize = 9, gameId = 1, gameState = "MenuMain", gameIdEasy = 1, gameIdMedium = 1, gameIdHard = 1, gameIdTutorial = 1, version = s.version}, drop, false))
--         end
--         s.difficulty = temp["difficulty"]
--         s.GameBoardSize = temp["boardsize"]
--         s.gameId = temp["gameId"]
--         s.gameIdEasy = temp["gameIdEasy"]
--         s.gameIdMedium = temp["gameIdMedium"]
--         s.gameIdHard = temp["gameIdHard"]
--         s.gameIdTutorial = temp["gameIdTutorial"]
--         s.gameState = temp["gameState"]
--         s.masterVolume = temp["masterVolume"]
--         s.effectVolume = temp["effectVolume"]
--         s.musicVolume = temp["musicVolume"]
--     end
-- end

--- Sets game according to game difficulty
-- function Boot:SetGameId()
--     if s.difficulty == "easy" then
--         s.gameId = s.gameIdEasy
--     elseif s.difficulty == "medium" then
--         s.gameId = s.gameIdMedium
--     elseif s.difficulty == "hard" then
--         s.gameId = s.gameIdHard
--     elseif s.difficulty == "tutorial" then
--         s.gameId = s.gameIdTutorial
--     end
--     s.previousGameId = s.gameId
--     s.previousdifficulty = s.difficulty
-- end

--- Reads the problem number from poblems.dat and stores it in s.gameNumbers
function Boot:LoadGameList()
    gameData = TSerial.unpack(love.filesystem.read("game.dat"))
end