--!strict
--[[
	A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event.
]]
local __DEV__ = _G.__DEV__

local function immutableAppend(list, ...)
	local new = {}
	local len = #list

	for key = 1, len do
		new[key] = list[key]
	end

	for i = 1, select("#", ...) do
		new[len + i] = select(i, ...)
	end

	return new
end

local function immutableRemoveValue(list, removeValue)
	local new = {}

	for i = 1, #list do
		if list[i] ~= removeValue then
			table.insert(new, list[i])
		end
	end

	return new
end

type Listener = {
	callback: (...any) -> (),
	disconnected: boolean,
	connectTraceback: string?,
	disconnectTraceback: string?,
}

type Store = {
	_isDispatching: boolean,
}

local Signal = {}

Signal.__index = Signal

function Signal.new(store: Store?)
	local self = {
		_listeners = {},
		_store = store,
	}

	setmetatable(self, Signal)

	return self
end

function Signal:connect(callback)
	if typeof(callback) ~= "function" then
		error("Expected the listener to be a function.")
	end

	if self._store and self._store._isDispatching then
		error(
			"You may not call store.changed:connect() while the reducer is executing. "
				.. "If you would like to be notified after the store has been updated, subscribe from a "
				.. "component and invoke store:getState() in the callback to access the latest state. "
		)
	end

	local listener: Listener = {
		callback = callback,
		disconnected = false,
		connectTraceback = nil,
		disconnectTraceback = nil,
	}

	if __DEV__ then
		listener.connectTraceback = debug.traceback()
	end

	self._listeners = immutableAppend(self._listeners, listener)

	local function disconnect()
		if listener.disconnected then
			error(
				("Listener connected at: \n%s\n" .. "was already disconnected at: \n%s\n"):format(
					tostring(listener.connectTraceback),
					tostring(listener.disconnectTraceback)
				)
			)
		end

		if self._store and self._store._isDispatching then
			error("You may not unsubscribe from a store listener while the reducer is executing.")
		end

		if __DEV__ then
			listener.disconnectTraceback = debug.traceback()
		end

		listener.disconnected = true
		self._listeners = immutableRemoveValue(self._listeners, listener)
	end

	return {
		disconnect = disconnect,
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		if not listener.disconnected then
			listener.callback(...)
		end
	end
end

return Signal
