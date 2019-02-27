--
-- Event ---------------------------------------------------------
--

Event = class()
function Event:ctor(publisher, name, data)
	self.publisher = publisher
	self.name  = name
	self.data = data
	self.context = nil
end

--
-- EventDispatcher ---------------------------------------------------------
--

EventDispatcher = class()

local _instance = nil
function EventDispatcher.Instance()
	if not _instance then
		_instance = EventDispatcher.new()
	end
	return _instance
end

function EventDispatcher:ctor()
	self.receivers  = {}
end

function EventDispatcher:DispatchEvent(event)
	local eventName = event.name
	if not eventName then return end

	local list = self.receivers[eventName]

	if (not list) or type(list) ~= "table" then return end

	for _, v in ipairs(list) do
		if (not v[3]) or (v[3] and (v[3] == event.publisher)) then
		    event.context = v[2]
		    v[1](event)
		end
	end
end

function EventDispatcher:HasEventListener(eventName, listener, publisher)
	if not eventName then
		return false
	end

	if self.receivers then
		local list = self.receivers[eventName]
		if not list then return false end

		for i, v in ipairs(list) do
			if (v[1] == listener) and (v[3] == publisher) then return true, i end
		end
	end

	return false
end

function EventDispatcher:HasEventListenerByName(eventName)
	if not eventName then
		return false
	end

	if self.receivers then
		local list = self.receivers[eventName]
		if list and table.getn(list) > 0 then
			return true
		end
	end

	return false
end

function EventDispatcher:AddEventListener(eventName, listener, args)
	args = args or {}
	if (not eventName) or (not listener) or (not self.receivers) then return end

	local existed = self:HasEventListener(eventName, listener, args.publisher)
	if not existed then
		local list = self.receivers[eventName]
		if (not list) or type(list) ~= "table" then
			list = {}
			self.receivers[eventName] = list
		end
		table.insert(list, {listener, args.context, args.publisher, args.permanent})
	end
end

function EventDispatcher:RemoveEventListener(eventName, listener, publisher)
	if (not eventName) or (not listener) or (not self.receivers) then return end
	if publisher then
		local existed, i = self:HasEventListener(eventName, listener, publisher)
		if existed then
			local list = self.receivers[eventName]
			table.remove(list, i)
		end
	else
		local list = self.receivers[eventName]
		if not list then return end

		for i = #list, 1, -1 do
			local v = list[i]
			if (v[1] == listener) then
				table.remove(list, i)
			end
		end
	end
end

function EventDispatcher:RemoveEventListenerByName(eventName)
	if (not eventName) or (not self.receivers) then return end
	self.receivers[eventName] = nil
end

function EventDispatcher:RemoveAllEventListeners()
	local permanentList = {}
	for eventName, list in pairs(self.receivers) do
		for index, receiver in pairs(list) do
			if receiver[4] == true then
				table.insert(permanentList, {eventName = eventName, receiver = receiver})
			end
		end
	end
	self.receivers = {}
	for _, v in ipairs(permanentList) do
		self.receivers[v.eventName] = self.receivers[v.eventName] or {}
		table.insert(self.receivers[v.eventName], v.receiver)
	end
	-- print(table.tostring(self.receivers))
end
