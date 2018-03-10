# Actions
**Actions** are bundles of data sent from your game to your store. They are tables with a single required field: `type`. The `type` field is used to describe the type of the action, which determines what it does. It is recommended, but not required, that `type` be a string, for easy debugging. You can dispatch actions to the store using its [dispatch](../api-reference.md#storedispatch) method.

Here's an example action that tells the store that a player joined:

```lua
local PLAYER_JOIN = "playerJoin"

local action = {
    type = PLAYER_JOIN,
    player = newPlayer,
}
```

!!! question
    #### Do types have to be defined as variables first?
    No, not at all! It is a good practice, however, because it is easier to change type names and to catch mistakes.

## Action creators
**Action creators** are functions that create actions for you. This allows you to validate your action arguments before the action is dispatched, add extra data to the action, and normalize your inputs. Here's an action creator for the player join action above:

```lua
local function playerJoin(player)
    return {
        type = PLAYER_JOIN,
        player = player,
    }
end
```

And here's it in use:

```lua
-- somewhere inside an event handler
store:dispatch(playerJoin(player))
```
