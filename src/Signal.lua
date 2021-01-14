--[[
	A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event.
]]

local function immutableAppend(list, ...)
	local len = #list
	local varLen = select("#", ...)
	local new = table.create(len + varLen)

	for index, value in ipairs(list) do
		new[index] = value
	end

	for index = 1, varLen do
		new[len + index] = select(index, ...)
	end

	return new
end

local function immutableRemoveValue(list, removeValue)
	local new = {}

	for _, value in ipairs(list) do
		if value ~= removeValue then
			table.insert(new, value)
		end
	end

	return new
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = {
		_listeners = {},
	}

	setmetatable(self, Signal)

	return self
end

function Signal:connect(callback)
	local listener = {
		callback = callback,
		disconnected = false,
	}

	self._listeners = immutableAppend(self._listeners, listener)

	local function disconnect()
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