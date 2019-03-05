When you initialize your `store` with [`Store.new`](../api-reference.md#storenew), you provide a single function called a `reducer` which will consume any `action` dispatched to your `store` and create a new `state` object based on the current `state` of your `store`.

```lua
local phoneNumberReducer = function(state, action)
	if action.type == "ReceivedNewPhoneNumber" then
		return action.phoneNumber
	end

	return state
end
```

Note that `state` is never actually modified by our `reducer`. The `state` of our `store` is *read-only*, so our `reducer` must construct a new `state` object in response to the received `action`.

For complex applications, it is often useful to break down the global `reducer` you provide to the `store` into a set of smaller `reducer` functions, each of which is responsible for a portion of the `state`.

```lua
local friendsReducer = function(state, action)
	--[[
		The state might be nil the first time this reducer is executed.
		In that case, we need to initialize our state to be the empty table.
	]]
	state = state or {}

	if action.type == "MadeNewFriends" then
		local newState = {}

		-- Since state is read-only, we copy it into newState
		for index, friend in ipairs(state) do
			newState[index] = friend
		end

		for _, friend in ipairs(action.newFriends)
			table.insert(newState, friend)
		end

		return newState
	end

	return state
end

--[[
	note that the reducer for our entire application is defined by a table of
	sub-reducers where each sub-reducer is responsible for one portion of the
	overall state.
]]
local reducer = function(state, action)
	return {
		myPhoneNumber = phoneNumberReducer(state.myPhoneNumber, action),
		myFriends = friendsReducer(state.myFriends, action),
	}
end
```

Alternatively, you can use [`Rodux.createReducer`](../api-reference.md#roduxcreatereducer) and [`Rodux.combineReducers`](../api-reference.md#roduxcombinereducers) to generate the same code as seen above. Using `Rodux.createReducer` and `Rodux.combineReducers` to create your `reducer` functions isn't as verbose and is less prone to developer error.

```lua
local phoneNumberReducer = Rodux.createReducer(nil, {
	ReceivedNewPhoneNumber = function(state, action)
		return action.phoneNumber
	end,
})

local friendsReducer = Rodux.createReducer({}, {
	MadeNewFriends = function(state, action)
		local newState = {}

		-- Since state is read-only, we copy it into newState
		for index, friend in ipairs(state) do
			newState[index] = friend
		end

		for _, friend in ipairs(action.friends)
			table.insert(newState, friend)
		end

		return newState
	end,
})

local reducer = Rodux.combineReducers({
	myPhoneNumber = phoneNumberReducer,
	myFriends = friendsReducer,
})
```