!!! note
	This section assumes you are already familiar with [The Store](store.md).

Whenever the `state` object tree in your `store` needs to be updated in response to an event, you `dispatch` an `action` to your `store` with any relevant information required to make said update. An `action` must be a Lua table with a `type` field. They are usually defined by a Lua module with the following format:

```lua
local ReceivedNewPhoneNumber(function(phoneNumber)
	return {
		type = "ReceivedNewPhoneNumber",
		phoneNumber = phoneNumber,
	}
end)

return ReceivedNewPhoneNumber
```

We can then `dispatch` an `action` to our `store` via [`Store:dispatch`](../api-reference.md#storedispatch) like so:

!!! info
	This example assumes that you've successfully [installed Rodux](installation.md) into `ReplicatedStorage` and placed the sample code above in `ReplicatedStorage.Actions.ReceivedNewPhoneNumber`!

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Rodux)

local ReceivedNewPhoneNumber = require(ReplicatedStorage.Actions.ReceivedNewPhoneNumber)

local store = Store.new(function(currentState, action)
	-- The body of your reducer
end)

store:dispatch(ReceivedNewPhoneNumber("19876543"))

local state = store:getState()
```

In most cases your `action` will be sent directly to the `reducer` to be processed. However, if you specified any `middleware` when initializing your `store`, your `action` might also be processed by that `middleware`.