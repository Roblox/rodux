--[[
	A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event.
]]

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

local Signal = {}

Signal.__index = Signal

function Signal.new()
	local self = {
		_listeners = {}
	}

	setmetatable(self, Signal)

	return self
end

function Signal:connect(callback)
	self._listeners = immutableAppend(self._listeners, callback)

	local function disconnect()
		self._listeners = immutableRemoveValue(self._listeners, callback)
	end

	return {
		disconnect = disconnect
	}
end

function Signal:fire(...)
	for _, listener in ipairs(self._listeners) do
		listener(...)
	end
end

return Signal