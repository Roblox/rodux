!!! info
	This example assumes that you've successfully [installed Rodux](introduction/installation.md) into `ReplicatedStorage`!

```lua
--[[
	Contents of Main.lua
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Rodux)

local MadeNewFriends = require(script.Parent.ActionCreators.MadeNewFriends)
local ReceivedNewPhoneNumber = require(script.Parent.ActionCreators.ReceivedNewPhoneNumber)

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

		for _, friend in ipairs(action.newFriends)
			table.insert(newState, friend)
		end

		return newState
	end,
})

local reducer = Rodux.combineReducers({
	myPhoneNumber = phoneNumberReducer,
	myFriends = friendsReducer,
})

local store = Rodux.Store.new(reducer, nil, {
	Rodux.loggerMiddleware,
})

store:dispatch(ReceivedNewPhoneNumber("12345678"))
store:dispatch(MadeNewFriends({
	"Cassandra",
	"Joe",
}))
```

```lua
--[[
	Contents of ActionCreators/ReceivedNewPhoneNumber.lua
]]

local ReceivedNewPhoneNumber(function(phoneNumber)
	return {
		type = script.name,
		phoneNumber = phoneNumber,
	}
end)

return ReceivedNewPhoneNumber
```

```lua
--[[
	Contents of ActionCreators/MadeNewFriends.lua
]]

local MadeNewFriends(function(listOfNewFriends)
	return {
		type = script.name,
		newFriends = listOfNewFriends,
	}
end)

return MadeNewFriends
```