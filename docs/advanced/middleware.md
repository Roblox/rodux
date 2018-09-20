In most cases the `dispatcher` in our `store` sends incoming `action` objects directly to the `reducer` to determine what updates should be made to the `state` object tree, but sometimes we want some additional processing to be done on the `action` that our `reducer` cannot provide. Features like delayed processing of an `action`, logging `action` objects dispatched to our `store`, or waiting for the response from a network request before sending our `action` payload to the `reducer` are quite cumbersome within the strict confines of Rodux. We circumvent this problem by introducing custom `middleware` that processes `action` objects before they are passed on to the `reducer`, allowing us to break out of the Rodux paradigm in a controlled and consistent fashion when necessary.

When creating a `store` via [`Store.new`](../api-reference.md#storenew), you can optionally provide `middleware` like so:

!!! info
	the following examples assume that you've successfully [installed Rodux](installation.md) into `ReplicatedStorage`!

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Rodux)

local reducer = function(state, action)
	-- the body of your reducer
end

local initialState = {}

local delayOneSecondMiddleware = function(nextDispatch, store)
	return function(action)
		delay(1, function()
			nextDispatch(action)
		end)
	end
end

local store = Rodux.Store.new(reducer, initialState, {
	delayOneSecondMiddleware,
})
```

Rodux has two `middlewares` available to you out of the box. See [`Thunks`](thunks.md) and [`Debugging`](../debugging.md) for more details.