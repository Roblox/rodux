The following is an example of a Rodux store that keeps track of the current user's phone number and the names of their friends. It demonstrates the use of the Rodux `store`, `actions`, `reducers`, and `middleware` in a real world setting. The `loggerMiddleware` has been included to demonstrate how to include `middleware` in your `store` and to provide valuable output in response to dispatched `action` objects.

!!! info
	This example assumes that you've successfully [installed Rodux](introduction/installation.md) into `ReplicatedStorage` and placed the contents of the following in a LocalScript under `StarterPlayer/StarterPlayerScripts`!

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Rodux)

-- Action creator for the ReceivedNewPhoneNumber action
local function ReceivedNewPhoneNumber(phoneNumber)
	return {
		type = "ReceivedNewPhoneNumber",
		phoneNumber = phoneNumber,
	}
end

-- Action creator for the MadeNewFriends action
local function MadeNewFriends(listOfNewFriends)
	return {
		type = "MadeNewFriends",
		newFriends = listOfNewFriends,
	}
end

-- Reducer for the current user's phone number
local phoneNumberReducer = Rodux.createReducer("", {
	ReceivedNewPhoneNumber = function(state, action)
		return action.phoneNumber
	end,
})

-- Reducer for the current user's list of friends
local friendsReducer = Rodux.createReducer({}, {
	MadeNewFriends = function(state, action)
		local newState = {}

		-- Since state is read-only, we copy it into newState
		for index, friend in ipairs(state) do
			newState[index] = friend
		end

		for _, friend in ipairs(action.newFriends) do
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

store:dispatch(ReceivedNewPhoneNumber("15552345678"))
store:dispatch(MadeNewFriends({
	"Cassandra",
	"Joe",
}))

--[[
	Expected output to the developer console:

	Action dispatched: {
	    phoneNumber = "12345678" (string)
	    type = "ReceivedNewPhoneNumber" (string)
	}
	State changed to: {
	    myPhoneNumber = "12345678" (string)
	    myFriends = {
	    }
	}
	Action dispatched: {
	    newFriends = {
	        1 = "Cassandra" (string)
	        2 = "Joe" (string)
	    }
	    type = "MadeNewFriends" (string)
	}
	State changed to: {
	    myPhoneNumber = "12345678" (string)
	    myFriends = {
	        1 = "Cassandra" (string)
	        2 = "Joe" (string)
	    }
	}
]]
```