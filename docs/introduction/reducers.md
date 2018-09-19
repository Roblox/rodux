!!! note
	This section assumes you are already familiar with [Actions](actions.md) and [The Store](store.md).

When you initialize your `store` with [`Store.new`](../api-reference.md#storenew), you provide a single function called a `reducer` which will consume any `action` dispatched to your `store` and create a new `state` object tree based on the current `state` object tree of your `store`.

```lua
local phoneNumberReducer = function(state, action)
	if action.type == "ReceivedNewPhoneNumber" then
		return action.phoneNumber
	end

	return state
end
```

Note that `state` is never actually modified by our `reducer`. The `state` object tree of our `store` is *read-only*, so our `reducer` must construct a new `state` in response to the received `action`.

For complex applications, it is often useful to break down the global `reducer` you provide to the `store` into a set of smaller `reducer` functions, each of which is responsible for a portion of the `state` object tree.

```lua
local friendsReducer = function(state, action)
	--[[
		The state will be nil the first time this reducer is executed.
		In that case, we need to initialize our state to be the empty table.
	]]
	state = state or {}

	if action.type == "MadeANewFriend" then
		local newState = {}

		-- Since state is read-only, we copy it into newState
		for index, friend in ipairs(state) do
			newState[index] = friend
		end

		table.insert(newState, action.friend)
		return newState
	end

	return state
end

local reducer = function(action, state)
	return {
		myPhoneNumber = phoneNumberReducer(state.myPhoneNumber, action),
		myFriends = friendsReducer(state.myFriends, action),
	}
end
```

Alternatively, you can use [`Rodux.createReducer`](../api-reference.md#roduxcreatereducer) and [`Rodux.combineReducers`](../api-reference.md#roduxcombinereducers) to generate the same code as seen above. This method of creating `reducer` functions isn't as verbose and is less prone to developer error.

!!! info
	This example assumes that you've successfully [installed Rodux](installation.md) into `ReplicatedStorage`!

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Rodux)

local phoneNumberReducer = Rodux.createReducer(nil, {
	CurrentUserChanged = function(state, action)
		return action.phoneNumber
	end,
})

local friendsReducer = Rodux.createReducer({}, {
	MadeANewFriend = function(state, action)
		local newState = {}

		-- Since state is read-only, we copy it into newState
		for index, friend in ipairs(state) do
			newState[index] = friend
		end

		table.insert(newState, action.friend)
		return newState
	end,
})

local reducer = Rodux.combineReducers({
	myPhoneNumber = phoneNumberReducer,
	myFriends = friendsReducer,
})

local store = Rodux.Store.new(reducer)
```