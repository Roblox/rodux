# Reducers
A **reducer** is a function that transforms the [state](./state.md) in response to [actions](./actions.md). Reducers should be pure functions - given the same inputs, they should always have the same output. The reducer signature is:

```
reducer(state, action) -> newState
```

Reducers take the current state and an action, and return a new state table. It is important that the reducer **does not mutate the state**. It should return a new state, instead. This means that this reducer, which changes its `state` argument, is incorrect:

```lua
local function reducer(state, action)
    state.value = action.value

    return state
end
```

Instead of writing this, you should instead write:

```lua
local function reducer(state, action)
    local newState = {}

    for key, value in pairs(state) do
        newState[key] = value
    end

    newState.value = action.value

    return newState
end
```

## Initializing state: the `@@INIT` action
When you first create a store, Rodux will automatically dispatch an action with a type of `@@INIT` before any other actions are dispatched. Your reducer should use this action to set up the state correctly:

```lua
local function reducer(state, action)
    if action.type == "@@INIT" then
        return {
            value = "default",
            -- ...
        }
    end

    -- Do something with the action
end
```

!!! question
    #### If there's an initialization action, what's the point of supplying an initial state?
    They do different things! The initialization action is for setting up parts of your state that need to be set up at run-time. The initial state that you can supply when creating a store is for loading your state from storage.

## Handling more than one type of action
Most of the time, your reducer needs to handle many types of actions. You can use the `type` field of the action for this:

```lua
local function reducer(state, action)
    if action.type == "someAction" then
        -- Do something with this action
    elseif action.type == "otherAction" then
        -- Do something with another action
    else
        -- Don't know how to handle this action; don't change the state at all
        return state
    end
end
```

!!! question
    #### Why is the reducer returning the same state value if it can't handle the action?
    You're allowed to return the same state **provided it has not changed**. If the state doesn't change at all, the existing state is still valid, and can be returned from the reducer.

Writing out `if-elseif-else` blocks can be inconvenient at times. To simplify these constructs, Rodux provides a `createReducer` function. This `createReducer` call is equivalent to the reducer above:

```lua
local reducer = Rodux.createReducer({
    someAction = function(state, action)
        -- Do something with someAction
    end,
    otherAction = function(state, action)
        -- Do something with otherAction
    end,
})
```
