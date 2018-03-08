# Middleware
Middleware is a way to modify the behavior of a store by altering the dispatch behavior. Middlewares can modify an action, consume it entirely (stopping it from being dispatched), or just do something else on top of the action. They do this by overriding the store's `dispatch` method entirely. A middleware is a factory for new `dispatch` methods, to rephrase things.

## Using middlewares
Middlewares can be used by specifying them in an array in the third argument of `Store.new`:

```lua
local store = Rodux.Store.new(
	reducer,
	initialState,
	{ middleware3, middleware2, middleware1 }
)
```

!!! question
    #### Why are the middlewares in reverse order?
	Rodux evaluates its middlewares in last-in-first-out order: the last argument is the one that's invoked first. The order of your middlewares is important.

Once you've done this, the middlewares are active and will take effect whenever you use the store's `dispatch` method.

## Built-in middlewares
Rodux comes with two built-in middlewares: `loggerMiddleware` and `thunkMiddleware`.

### loggerMiddleware
`loggerMiddleware` is a very simple middleware that lets you log changes to your state. It is exposed as `Rodux.loggerMiddleware` from the main Rodux module. Whenever an action is dispatched, it will print two things:

* The action in its entirety
* The state after the action was reduced

To use it, specify it like this:

```lua
local store = Rodux.Store.new(
	reducer, 
	initialState, 
	{ Rodux.loggerMiddleware() }
)
```

!!! question
    #### Why is `loggerMiddleware` called?
	`loggerMiddleware` is called because it allows you to change the function used to print to the output. For example, if you wanted to print all the changes to your store as warnings, you could do this:

	```lua
	local store = Rodux.Store.new(
		reducer, 
		initialState, 
		{ Rodux.loggerMiddleware(warn) }
	)
	```

Now, whenever you dispatch an action, you'll see something like the following in the output window:

```
Action dispatched: {
        type = "test"; (string)
		payload = 1; (number)
    }
State changed to: {
		testValue = 1; (number)
	}
```

### thunkMiddleware
`thunkMiddleware` is a middleware that lets you use thunks - it lets you dispatch a function to your store, which will be run. The function can do anything, and can dispatch new actions at will. Thunks are commonly used for asynchronous, long-running operations, like reading from a data store or performing a HTTP request.

To use it, just include it in your `middlewares` table:

```lua
local store = Rodux.Store.new(
	reducer, 
	initialState, 
	{ Rodux.thunkMiddleware }
)
```

Once you've done that, you can dispatch a function just like you would an action with the store's `dispatch` method:

```lua
store:dispatch(function(store)
	-- Do something that takes a while

	-- Then dispatch an action to tell the store about the result!
	store:dispatch({
		type = "someAction"
	})
end)
```

## Writing your own middlewares
There's nothing magic about writing middlewares! Here's how you can write your own.

### A simple example: printing the type field
Here's a simple middleware that just prints the action's `type` field:

```lua
local function printType(next)
	return function(store, action)
		print(action.type)
		next(store, action)
	end
end
```

Breaking it down:

* `printType` is a function that takes one argument: `next`. This is the next middleware in the chain. At the end of the chain lies the original `dispatch` method.
* `printType` returns a new function that takes two arguments: `store` and `action`. These arguments are the *exact signature* of the original `dispatch` method.
* The function returned from `printType` prints the action's type, then calls `next` to pass the action on.

To use this function, specify it in the third argument to `Store.new`:

```lua
local function reducer(state, action)
	-- Just return the same state, for demonstrational purposes.
	return state
end

local store = Store.new(reducer, {}, { printType })

store:dispatch({
	type = "testAction"
})
```

Run this code and you'll see this in the output:
```
testAction
```

### Canceling actions
Nothing says you *have* to call `next` at all! Here's a middleware that just swallows up any action that it comes across. These actions never modify the store's state.

```lua
local function swallowAction(next)
	return function(store, action)
		-- Do nothing! Since next is not called, the action never moves on.
	end
end
```

### Modifying actions: PascalCased Type
Similarly, you don't always have to call `next` with the same action. Say you prefer using `PascalCase` for your actions. Rodux requires that your actions have a `type` field, so your code style is being broken! Middlewares to the rescue - you can replace the action so that it fits the structure Rodux is expecting, without having to make compromises about your casing.

```lua
local function pascalCaseType(next)
	return function(store, action)
		-- If the action has a Type field, substitute it with an identical action
		-- that substitutes type for Type!
		if action.Type then
			local newAction = {}

			for key, value in pairs(action) do
				-- Change the casing on the Type field
				if key == "Type" then
					newAction.type = value
				-- Everything else can stay as-is
				else
					newAction[key] = value
				end
			end

			-- Pass the new action on!
			next(store, newAction)
		-- Otherwise, just send the action on!
		else
			next(store, action)
		end
	end
end
```
