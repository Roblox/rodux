# Modularity
Despite Rodux's requirement that your state be centralized in a single object, modular code is still possible!

A lot of the time, you'll have a bunch of separate blocks of state:

```lua
{
    market = {
        -- state about the market
    },
    round = {
        -- state about the round
    },
    players = {
        -- state about players in the game
    },
    -- ...and so forth
}
```

You can write a reducer that works like this:

```lua
local function reducer(state, action)
    return {
        market = marketReducer(state.market, action),
        round = roundReducer(state.round, action),
        players = playersReducer(state.players, action),
    }
end
```

The individual reducer functions can come from separate modules anywhere in your game - there's nothing special about them. They're just like any other reducer. Rodux provides a super-simple function that can make combining these reducers easier: `combineReducers`. It works like this:

```lua
local reducer = Rodux.combineReducers({
    market = marketReducer,
    round = roundReducer,
    players = playersReducer,
})
```

This is exactly the same as the reducer from before! Further, nothing stops you from combining reducers in multiple layers, like this:

```lua
local reducer = Rodux.combineReducers({
    market = Rodux.combineReducers({
        sell = marketSellReducer,
        buy = marketBuyReducer,
        bank = marketBankReducer,
    }),
})
```

Rodux's only constraint on your code is that at the end you have to glue everything together into one function. How you structure the rest of your code is entirely up to you.
