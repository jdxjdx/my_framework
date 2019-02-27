require("Utils.class")
require("Utils.Utils")
require("Utils.EventDispatcher")
require("Utils.StateMachine")
require("Utils.TouchEventUtils")

require("Gameplay.GameData.PlayerDataManager")

--主入口函数。从这里开始lua逻辑
function Main()					
	print("logic start")

	PlayerDataManager.instance:Init()
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end