---@class PlayerDataManager:DataManager
PlayerDataManager = class(DataManager)

function PlayerDataManager:ctor()

end

function PlayerDataManager:Init()
	print("PlayerDataManager init")
end

function PlayerDataManager:Clear()

end

PlayerDataManager.instance = PlayerDataManager.new()
