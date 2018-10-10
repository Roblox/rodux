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

Additionally, Rodux provides a helper method called `makeActionCreator` to generate 'action creators'. These are a lot like the `ReceivedNewPhoneNumber` function above, except for two key differences:

* Instead of functions, action creators returned from `makeActionCreator` are callable tables that also include a `name` field.
* Action creators will automatically populate the `type` field of each action they create using their `name`.

We can define an action creator like this:

```lua
return makeActionCreator("ReceivedNewPhoneNumber", function(phoneNumber)
	return {
		phoneNumber = phoneNumber,
	}
end)
```

Since the `name` of the action creator populates the `type` of the actions it creates, we can use an action creators `name` to identify actions that were created by it. As we'll see in the Reducers section, this is helpful for determining which action we're processing:

```lua
	local MyAction = require(MyAction)
	...
	if action.type == MyAction.name then
		-- change some state!
	end
```

!!! info
	Actions are nothing more than tables with a `type` field, so there are many ways to generate them! If `makeActionCreator` doesn't work for your project, you can always generate actions and action creators however you like!