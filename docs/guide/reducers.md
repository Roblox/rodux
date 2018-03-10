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
