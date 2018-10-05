The `store` is comprised of three parts and is your main entry point for all things Rodux. It is created via [`Store.new`](../api-reference.md#storenew).

### State
This is the object that contains all of the data backing the business logic of your application. It is usually represented as a Lua table and it can be read via [`Store:getState`](../api-reference.md#storegetstate).

```lua
local exampleState = {
	myPhoneNumber = "15552345678",
	myFriends = {
		"Joe",
		"Cassandra",
	},
}
```

### Reducer
This is a pure function that takes in an `action` object and the current state of your `store` and outputs a new state in response to the `action`. Reducers are often broken down into many individual pure functions, each of which modifies one portion of the state. You provide your global `reducer` to the `store` during initialization via [`Store.new`](../api-reference.md#storenew). See the [Reducer](reducers.md) page for more details.

### Dispatcher
This is the function of the `store` that handles incoming `action` objects and forwards them to your `reducer`. If you have applied any `middleware` to your `store`, the `middleware` will wrap this `dispatcher` function and reassign it such that the `action` will be passed through all of the `middleware` you provided to your `store` before forwarding the `action` object to the `reducer`. You can provide `middleware` to the `store` during initialization via [`Store.new`](../api-reference.md#storenew).

```lua
local store = Rodux.Store.new(function(action, currentState)
	-- The body of your reducer
end)

local state = store:getState()
```