UIEventListener = {}

UIEventListener.AddButtonClick = function(go, callback)
	HurcnEngine.UIEventListener.AddButtonClick(go, function(cb_go)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go)
	    end)
	end)
end
UIEventListener.RemoveButtonClick = function(go)
	HurcnEngine.UIEventListener.RemoveButtonClick(go)
end

UIEventListener.AddToggleChange = function(go, callback)
	HurcnEngine.UIEventListener.AddToggleChange(go, function(cb_go)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go)
	    end)
	end)
end
UIEventListener.RemoveToggleChange = function(go)
	HurcnEngine.UIEventListener.RemoveToggleChange(go)
end

UIEventListener.AddSliderChange = function(go, callback)
	HurcnEngine.UIEventListener.AddSliderChange(go, function(cb_go)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go)
	    end)
	end)
end
UIEventListener.RemoveSliderChange = function(go)
	HurcnEngine.UIEventListener.RemoveSliderChange(go)
end

UIEventListener.AddDropdownChange = function(go, callback)
	HurcnEngine.UIEventListener.AddDropdownChange(go, function(cb_go)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go)
	    end)
	end)
end
UIEventListener.RemoveDropdownChange = function(go)
	HurcnEngine.UIEventListener.RemoveDropdownChange(go)
end

UIEventListener.AddInputFieldEndEdit = function(go, callback)
	HurcnEngine.UIEventListener.AddInputFieldEndEdit(go, function(cb_go)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go)
	    end)
	end)
end
UIEventListener.RemoveInputFieldEndEdit = function(go)
	HurcnEngine.UIEventListener.RemoveInputFieldEndEdit(go)
end

UIEventListener.AddInputFieldEdit = function(go, callback)
	HurcnEngine.UIEventListener.AddInputFieldEdit(go, function(cb_go)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go)
	    end)
	end)
end
UIEventListener.RemoveInputFieldEdit = function(go)
	HurcnEngine.UIEventListener.RemoveInputFieldEdit(go)
end

UIEventListener.AddDragEvent = function(param, callback1, callback2, callback3)
	HurcnEngine.UIEventListener.AddDragEvent(
		param, 
		function(cb_param1, cb_param2)
			coroutine.start(function()
		    	coroutine.step()
		    	callback1(cb_param1, cb_param2)
		    end)
		end,
		function(cb_param1, cb_param2)
			coroutine.start(function()
		    	coroutine.step()
		    	callback2(cb_param1, cb_param2)
		    end)
		end,
		function(cb_param1, cb_param2)
			coroutine.start(function()
		    	coroutine.step()
		    	callback3(cb_param1, cb_param2)
		    end)
		end
	)
end
UIEventListener.RemoveDragEvent = function(param)
	HurcnEngine.UIEventListener.RemoveDragEvent(param)
end

UIEventListener.AddPointerEvent = function(param, callback1, callback2, callback3)
	HurcnEngine.UIEventListener.AddPointerEvent(
		param, 
		function(cb_param1, cb_param2)
			coroutine.start(function()
		    	coroutine.step()
		    	callback1(cb_param1, cb_param2)
		    end)
		end,
		function(cb_param1, cb_param2)
			coroutine.start(function()
		    	coroutine.step()
		    	callback2(cb_param1, cb_param2)
		    end)
		end,
		function(cb_param1, cb_param2)
			coroutine.start(function()
		    	coroutine.step()
		    	callback3(cb_param1, cb_param2)
		    end)
		end
	)
end
UIEventListener.RemovePointerEvent = function(param)
	HurcnEngine.UIEventListener.RemovePointerEvent(param)
end



EventTriggerListener = {}

EventTriggerListener.AddListener = function(go, triggerType, callback)
	HurcnEngine.EventTriggerListener.AddListener(go, triggerType, function(cb_go, cb_param)
		coroutine.start(function()
	    	coroutine.step()
	    	callback(cb_go, cb_param)
	    end)
	end)
end

EventTriggerListener.RemoveAllListeners = function(go)
	HurcnEngine.EventTriggerListener.RemoveAllListeners(go)
end

UIEventListener.AddTMP_DropdownChange = function(go, callback)
	HurcnEngine.UIEventListener.AddTMP_DropdownChange(go, function(cb_go)
		coroutine.start(function()
			coroutine.step()
			callback(cb_go)
		end)
	end)
end
UIEventListener.RemoveTMP_DropdownChange = function(go)
	HurcnEngine.UIEventListener.RemoveTMP_DropdownChange(go)
end

UIEventListener.AddTMP_InputFieldEndEdit = function(go, callback)
	HurcnEngine.UIEventListener.AddTMP_InputFieldEndEdit(go, function(cb_go)
		coroutine.start(function()
			coroutine.step()
			callback(cb_go)
		end)
	end)
end
UIEventListener.RemoveTMP_InputFieldEndEdit = function(go)
	HurcnEngine.UIEventListener.RemoveTMP_InputFieldEndEdit(go)
end