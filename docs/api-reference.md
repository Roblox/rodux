# Rodux API Reference

## Store
The Store class is the core piece of Rodux. It is the state container that you create and use.

### Store.new
```lua
Store.new(reducer, initialState, middlewares) -> Store
```
Creates and returns a new store.

`reducer` is the store's root reducer function. `initialState` is the store's initial state. This should be used to load a saved state from storage. `middlewares` is a table of middlewares to apply.

The store will automatically dispatch an initialization action with a `type` of `@@INIT`.

!!! note
	The initialization action does not pass through middlewares prior to reaching the reducer.

### Store.changed
```lua
Store.changed:connect(function(newState, oldState)
	-- do something with newState or oldState
end)
```
A [Signal](#Signal) that is fired when the store's state is changed.

!!! danger
	Do not yield within any listeners on `changed`; an error will be thrown.

### Store:dispatch
```lua
Store:dispatch(action) -> nil
```
Dispatches an action. The action will travel through all of the store's middlewares before reaching the store's reducer.

The action must contain a `type` field to indicate what type of action it is. No other fields are required.

### Store:getState
```lua
Store:getState() -> table
```
Gets the store's current state.

!!! warning
	Do not modify this value. Doing so may cause serious bugs in Rodux, your code, or both!

### Store:destruct
```lua
Store:destruct() -> nil
```
Destroys the store, disconnecting all connections it may possess.

!!! danger
	Attempting to use the store after `destruct` has been called will cause problems.

### Store:flush
```lua
Store:flush() -> nil
```
Flushes the store's pending actions, firing the `changed` event. You should not need to use this method; it is called automatically from within Rodux.

## Signal
The Signal class in Rodux represents a simple, predictable event that is controlled from within Rodux. It is not publicly exposed and cannot be created outside of Rodux.

### Signal:connect
```lua
Signal:connect(listener) -> { disconnect }
```
Connects a listener to the signal. The listener will be invoked whenever the signal is fired.

`connect` returns a table with a `disconnect` function that can be used to disconnect the listener from the signal.

## Helper functions
Rodux supplies some helper functions to make creating complex reducers easier.

### Rodux.combineReducers
A helper function that can be used to combine reducers.

```lua
local reducer = combineReducers({
	key1 = reducer1,
	key2 = reducer2,
})
```

`combineReducers` is functionally equivalent to writing:

```lua
local function reducer(state, action)
	return {
		key1 = reducer1(state.key1, action),
		key2 = reducer2(state.key2, action),
	}
end
```

### Rodux.createReducer
A helper function that can be used to create reducers.

```lua
local reducer = createReducer({
	action1 = function(state, action)
		-- Handle actions of type "action1"
	end,
	action2 = function(state, action)
		-- Handle actions of type "action2"
	end,
	-- ...
})
```

## Middleware
Rodux ships with several middleware that address common use-cases.

### Rodux.loggerMiddleware
```lua
loggerMiddleware(outputFunction = print) -> middlewareFunction
```
A middleware that logs actions and the new state that results from them.

This middleware supports changing the output function. By default, it is `print`, and state changes are printed to the output. As a consequence of this, `loggerMiddleware` must be called when using it:

```lua
local store = Store.new(reducer, initialState, { loggerMiddleware() })
```

### Rodux.thunkMiddleware
A middleware that allows thunks to be dispatched. Thunks are functions that perform asynchronous tasks or side effects, and can dispatch actions as needed.

```lua
local store = Store.new(reducer, initialState, { thunkMiddleware })
store:dispatch(function(store)
	print("Hello from a thunk!")
	store:dispatch({
		type = "thunkAction"
	})
end)
```
