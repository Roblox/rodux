Whenever the `state` in your `store` needs to be updated in response to an event, you `dispatch` an `action` to your `store` with any relevant information required to make said update. An `action` is usually a Lua table with a `type` field. They are usually created via an action creator Lua module like the following:

```lua
local function ReceivedNewPhoneNumber(phoneNumber)
	return {
		type = "ReceivedNewPhoneNumber",
		phoneNumber = phoneNumber,
	}
end

return ReceivedNewPhoneNumber
```

We can then `dispatch` an `action` to our `store` via [`Store:dispatch`](../api-reference.md#storedispatch) like so:

```lua
local store = Store.new(function(currentState, action)
	-- The body of your reducer
end)

store:dispatch(ReceivedNewPhoneNumber("15552345678"))
```

!!! info
	In most cases your `action` will be sent directly to the `reducer` to be processed. However, if you specified any `middleware` when initializing your `store`, your `action` might also be processed by that `middleware`.