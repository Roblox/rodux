local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)
local NoYield = require(script.Parent.NoYield)
local inspect = require(script.Parent.inspect).inspect

local defaultErrorReporter = {
	reportErrorDeferred = function(self, message, stacktrace)
		print(message)
		print(stacktrace)
	end,
	reportErrorImmediately = function(self, message, stacktrace)
		print(message)
		print(stacktrace)
	end
}

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
function Store.new(reducer, initialState, middlewares, errorReporter)
	assert(typeof(reducer) == "function", "Bad argument #1 to Store.new, expected function.")
	assert(middlewares == nil or typeof(middlewares) == "table", "Bad argument #3 to Store.new, expected nil or table.")
	if middlewares ~= nil then
		for i=1, #middlewares, 1 do
			assert(
				typeof(middlewares[i]) == "function",
				("Expected the middleware ('%s') at index %d to be a function."):format(tostring(middlewares[i]), i)
			)
		end
end

	local self = {}

	self._errorReporter = errorReporter or defaultErrorReporter
	self._isDispatching = false
	self._reducer = reducer
	local initAction = {
		type = "@@INIT",
	}
	self._lastAction = initAction
	local ok, result = pcall(function()
		self._state = reducer(initialState, initAction)
	end)
	if not ok then
		local message = ("Caught error with init action of reducer (%s): %s"):format(tostring(reducer), tostring(result))
		errorReporter:reportErrorImmediately(message, debug.traceback())
		self._state = initialState
	end
	self._lastState = self._state

	self._mutatedSinceFlush = false
	self._connections = {}

	self.changed = Signal.new(self)

	setmetatable(self, Store)

	local connection = self._flushEvent:Connect(function()
		self:flush()
	end)
	table.insert(self._connections, connection)

	if middlewares then
		local unboundDispatch = self.dispatch
		local dispatch = function(...)
			return unboundDispatch(self, ...)
		end

		for i = #middlewares, 1, -1 do
			local middleware = middlewares[i]
			dispatch = middleware(dispatch, self)
		end

		self.dispatch = function(_self, ...)
			return dispatch(...)
		end
	end

	return self
end

--[[
	Get the current state of the Store. Do not mutate this!
]]
function Store:getState()
	if self._isDispatching then
		error(("You may not call store:getState() while the reducer is executing. " ..
			"The reducer (%s) has already received the state as an argument. " ..
			"Pass it down from the top reducer instead of reading it from the store."):format(tostring(self._reducer)))
	end

	return self._state
end

function Store:_reportReducerError(failedAction, error_, traceback)
	local message = ("Caught error when running action (%s) " ..
		"through reducer (%s): \n%s \n" ..
		"previous action type was: %s"):format(tostring(failedAction), tostring(self._reducer), tostring(error_), inspect(self._lastAction))

	self._errorReporter:reportErrorImmediately(message, traceback)
end

--[[
	Dispatch an action to the store. This allows the store's reducer to mutate
	the state of the application by creating a new copy of the state.

	Listeners on the changed event of the store are notified when the state
	changes, but not necessarily on every Dispatch.
]]
function Store:dispatch(action)
	if typeof(action) ~= "table" then
		error(("Actions must be tables. " ..
			"Use custom middleware for %q actions."):format(typeof(action)),
			2
		)
	end

	if action.type == nil then
		error("Actions may not have an undefined 'type' property. " ..
			"Have you misspelled a constant? \n" ..
			inspect(action), 2)
	end

	if self._isDispatching then
		error("Reducers may not dispatch actions.")
	end

	local ok, result = pcall(function()
		self._isDispatching = true
		self._state = self._reducer(self._state, action)
		self._mutatedSinceFlush = true
	end)

	self._isDispatching = false

	if not ok then
		self:_reportReducerError(
			action,
			result,
			debug.traceback()
		)
	end
	self._lastAction = action
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

	-- On self.changed:fire(), further actions may be immediately dispatched, in
	-- which case self._lastState will be set to the most recent self._state,
	-- unless we cache this value first
	local state = self._state

	-- If a changed listener yields, *very* surprising bugs can ensue.
	-- Because of that, changed listeners cannot yield.
	NoYield(function()
		self.changed:fire(state, self._lastState)
	end)

	self._lastState = state
end

return Store
