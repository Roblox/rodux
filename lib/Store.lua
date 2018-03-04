local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)
local NoYield = require(script.Parent.NoYield)

local Store = {}

-- This value is exposed as a private value so that the test code can stay in
-- sync with what event we listen to for dispatching the Changed event.
-- It may not be Heartbeat in the future.
Store._flushEvent = RunService.Heartbeat

Store.__index = Store

--[[
	Create a new Store whose state is transformed by the given reducer function.

	Each time an action is dispatched to the store, the new state of the store
	is given by:

		state = reducer(state, action)

	Reducers do not mutate the state object, so the original state is still
	valid.
]]
function Store.new(reducer, initialState, middlewares)
	assert(typeof(reducer) == "function", "Bad argument #1 to Store.new, expected function.")

	local self = {
		_reducer = reducer,
		_state = reducer(initialState, {}),
	}

	self._lastState = self._state
	self._mutatedSinceFlush = false
	self._connections = {}

	self.changed = Signal.new()

	setmetatable(self, Store)

	local connection = self._flushEvent:Connect(function()
		self:flush()
	end)
	table.insert(self._connections, connection)

	local dispatch = Store.dispatch
	for _, middleware in ipairs(middlewares) do
		dispatch = middleware(dispatch)
	end

	self.dispatch = dispatch

	return self
end

--[[
	Get the current state of the Store. Do not mutate this!
]]
function Store:getState()
	return self._state
end

--[[
	Dispatch an action to the store. This allows the store's reducer to mutate
	the state of the application by creating a new copy of the state.

	Listeners on the Changed event of the store are notified when the state
	changes, but not necessarily on every Dispatch.

	Pass a function to dispatch a thunk.
]]
function Store:dispatch(action)
	if typeof(action) == "function" then
		local result = action(self)

		return result
	elseif typeof(action) == "table" then
		if action.type == nil then
			error("action does not have a type field", 2)
		end

		self._state = self._reducer(self._state, action)
		self._mutatedSinceFlush = true
	else
		error(("actions of type %q are not permitted"):format(typeof(action)), 2)
	end
end

--[[
	Marks the store as deleted, disconnecting any outstanding connections.
]]
function Store:destruct()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end

	self._connections = nil
end

--[[
	Flush all pending actions since the last change event was dispatched.
]]
function Store:flush()
	if not self._mutatedSinceFlush then
		return
	end

	self._mutatedSinceFlush = false

	-- On self.Changed:Fire, further actions may be immediately dispatched,
	-- in which case self._lastState will be set to the most recent self._state,
	-- unless we cache this value first
	local state = self._state

	-- If a Changed listener yields, *very* surprising bugs can ensue.
	-- Because of that, Changed listeners cannot yield.
	NoYield(function()
		self.changed:fire(state, self._lastState)
	end)

	self._lastState = state
end

return Store
