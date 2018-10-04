Most of the time, calling `Store:dispatch` sends incoming `action` objects directly to the `reducer` to determine what updates should be made to the `state`. This is enough for most cases, but some features would be difficult to implement if this was all Rodux provided. For example:

- Delayed processing of an `action`.
- Logging `action` objects dispatched to our `store`.
- Performing a network request in response to an `action` and storing the response in the `state`.

Rodux has the concept of `middleware` to deal with these sorts of situations.

A `middleware` is a function that accepts the next `dispatch` function in the `middleware` chain, as well as the `store` the `middleware` is being used with, and returns a new function. That function is called whenever an `action` is dispatched and can dispatch more `actions`, log to output, or perform any other side effects! When an `action` is dispatched, `middleware` are run in the order they were specified in [`Store.new`](../api-reference.md#storenew) from left to right.

Here is an example of a `middleware` that could be used to delay the processing of `action` objects dispatched to the `store`.

```lua
local reducer = function(state, action)
	-- the body of your reducer
end

local initialState = {}

local delayOneSecondMiddleware = function(nextDispatch, store)
	return function(action)
		delay(1, function()
			--[[
				nextDispatch passes the action to the next middleware provided
				to the store at initialization or to the reducer if the action
				has already been processed by all the provided middleware.
			]]
			nextDispatch(action)
		end)
	end
end

local store = Rodux.Store.new(reducer, initialState, {
	delayOneSecondMiddleware,
})
```

!!! warning
	If the `delayOneSecondMiddleware` function did not call `nextDispatch`, then the `action` would not be processed by any other `middleware` in the `middleware` chain or our `reducer`!

Rodux has two `middlewares` available to you out of the box. See [`Middleware`](../api-reference.md#middleware), [`thunkMiddleware`](../api-reference.md#roduxthunkmiddleware), and [`loggerMiddleware`](../api-reference.md#roduxloggermiddleware) for more details.