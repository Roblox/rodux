The `thunkMiddleware` packaged with Rodux will intercept any `action` dispatched to our `store` that is a Lua *function* and execute that function instead of forwarding our `action` to the `reducer`. These functions (also called thunks) have access to the `store` and are allowed to dispatch `action` objects themselves as necessary.

```lua
local reducer = function(state, action)
	--[[
		Reducer that handles all actions for our store,
		including actions of the type "MadeNewFriends".
	]]
end

local initialState = {}

local store = Rodux.Store.new(reducer, initialState, {
	Rodux.thunkMiddleware,
})

--[[
	Our thunkMiddleware will process this action as a thunk
	since it is a Lua function
]]
store:dispatch(function(store)
	getAsyncNewFriendsForUser("Sarah", function(result)
		store:dispatch({
			type = "MadeNewFriends",
			newFriends = result,
		})
	end)
end)
```

Thunks are a simple way to introduce more complex processing of `action` objects, but you may want to consider creating custom [`middleware`](middleware.md) for complex features instead of relying on thunks alone.