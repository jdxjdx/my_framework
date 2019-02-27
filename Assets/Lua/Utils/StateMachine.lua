---@class BaseState
BaseState = class()

function BaseState:ctor()
	self.stateMachine = nil
end

function BaseState:OnEnter(data, subState)
end

function BaseState:OnExit()
end

function BaseState:OnUpdate()
end

StateMachine = class()

function StateMachine:ctor(name, invalidId)
	self.name = name or "UnnamedStateMachine"
	self.invalidId = invalidId or 0
	self.currentId = self.invalidId
	self.states = {}
end

function StateMachine:AddState(stateId, state)
	if stateId == self.invalidId then
		Debugger.LogError("invalid state id")
		return
	end

	if not BaseState.is(state, BaseState) then
		Debugger.LogError("invalid state")
		return
	end

	if self.states[stateId] then
		Debugger.LogWarning("overriding existing state")
	end

	self.states[stateId] = state
	state.stateMachine = self
end

function StateMachine:ChangeState(stateId, data, subState)
	if stateId ~= self.invalidId and self.states[stateId] == nil then
		Debugger.LogWarning(self.name .. " state machine doesn't have the state: " .. tostring(stateId))
		stateId = self.invalidId
	end

	if self.currentId ~= self.invalidId then
		self.states[self.currentId]:OnExit()
	end
	self.currentId = stateId
	if stateId ~= self.invalidId then
		self.states[stateId]:OnEnter(data, subState)
	end
end

function StateMachine:Update()
	if self.states[self.currentId] then
		self.states[self.currentId]:OnUpdate()
	end
end

function StateMachine:RemoveState(stateId)
	if stateId ~= self.invalidId and stateId == self.currentId then
		self:ChangeState(self.invalidId)
	end
	self.states[stateId] = nil
end

function StateMachine:ClearAll()
	if self.currentId ~= self.invalidId then
		self:ChangeState(self.invalidId)
	end
	self.states = {}
end

function StateMachine:GetCurrentStateId()
	return self.currentId
end

function StateMachine:GetCurrentState()
	if self.currentId ~= self.invalidId then
		return self.states[self.currentId]
	else
		return nil
	end
end

function StateMachine:GetState(stateId)
	return self.states[stateId]
end