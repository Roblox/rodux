The `thunkmiddleware` packaged with Rodux will intercept any `action` dispatched to your `store` that is a Lua *function* and simply execute that function instead of forwarding your `action` to the `reducer`. These functions (also called thunks) have access to the `store` and are allowed to dispatch `action` objects as necessary.

!!! info
	the following examples assume that you've successfully [installed Rodux](installation.md) into `ReplicatedStorage`!

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Rodux)

local reducer = function(state, action)
	-- reducer that handles actions of type "MadeANewFriend"
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
	getAsyncFriendsForUser("Sarah", function(result)
		for _, friend in ipairs(result)
			store:dispatch({
				type = "MadeANewFriend",
				friend = friend,
			})
		end
	end)
end)
```

Thunks are the simplest way to introduce more complex processing of `action` objects. However, thunks allow any portion of your code with access to the `store` to create custom business logic and dispatch it via an `action` to the `store`. One of the primary goals of Rodux is to put your business logic in a centralized location and thunks work directly against that goal. It is often a good first step for prototyping a new idea, but it's highly recommended that you create custom [`middleware`](middleware.md) for complex features instead of relying on thunks alone.