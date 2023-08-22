The fifth argument to [`Store.new`](../api-reference.md#storenew) takes a devtools object that you can optionally provide. A devtools object has only two requirements: `devtools.__className` must be `"Devtools"` and `devtools:_hookIntoStore(store)` must be a valid function call. Beyond that, your devtools can be anything you need it to be.

Devtools can be very useful during development in gathering performance data, providing introspection, debugging, etc. We leave the devtools implementation up to the user in order to support any and all use cases, such as store modification in unit testing, live state inspection plugins, and whatever else you come up with.

A simple example of a devtools that profiles and logs:

```Lua
local Devtools = {}
Devtools.__className = "Devtools"
Devtools.__index = Devtools

-- Creates a new Devtools object
function Devtools.new()
	local self = setmetatable({
		_events = table.create(100),
		_eventsIndex = 0,
	}, Devtools)

	return self
end

-- Overwrites the store's reducer and flushHandler with wrapped versions that contain logging and profiling
function Devtools:_hookIntoStore(store)
	self._store = store
	self._source = store._source

	self._originalReducer = store._reducer
	store._reducer = function(state: any, action: any): any
		local startClock = os.clock()
		local result = self._originalReducer(state, action)
		local stopClock = os.clock()

		self:_addEvent("Reduce", {
			name = action.type or tostring(action),
			elapsedMs = (stopClock - startClock) * 1000,
			action = action,
			state = result,
		})
		return result
	end

	self._originalFlushHandler = store._flushHandler
	store._flushHandler = function(...)
		local startClock = os.clock()
		self._originalFlushHandler(...)
		local stopClock = os.clock()

		self:_addEvent("Flush", {
			name = "@@FLUSH",
			elapsedMs = (stopClock - startClock) * 1000,
			listeners = table.clone(store.changed._listeners),
		})
	end
end

-- Adds an event to the log
-- Automatically adds event.timestamp and event.source
function Devtools:_addEvent(eventType: "Reduce" | "Flush", props: { [any]: any })
	self._eventsIndex = (self._eventsIndex or 0) + 1
	self._events[self._eventsIndex] = {
		eventType = eventType,
		source = self._source,
		timestamp = DateTime.now().UnixTimestampMillis,
		props = props,
	}
end

-- Returns a shallow copy of the event log
function Devtools:GetLoggedEvents()
	return table.clone(self._events)
end
```
