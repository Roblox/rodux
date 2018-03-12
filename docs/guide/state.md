# State
In Rodux, the **state** of your game is one large table that contains everything that is currently happening. The state is the *single source of truth* in your game. This makes it easy to:

* Save and load state
* Debug your game
* Undo/redo actions

## What to put in state
Anything that changes in your game should go in your state table. You should be able to look at your state table and determine exactly what was going on at a given point in time, without knowing anything else.

Constants and configuration values that don't ever change in your game don't need to go in your state table.

## State is read-only
In Rodux, state is **read-only** - it cannot be changed directly. The only way to change your state is by dispatching an [action](actions.md). This means that every change to your state flows down a single path, which can be easily manipulated. Logging state changes, for example, only needs to happen in one place, instead of sprinkling `print` statements across your entire codebase.

!!! question
    #### Why is state immutable?
    State is immutable because it makes it very, very easy to determine if state changed. If state was mutable, you would need to traverse the entire state tree, which can be very slow in large games, to find out if something changed. Since state is immutable, you can just do something like:

    ```lua
    if state ~= oldState then
        -- State changed, do something!
    end
    ```

    This also makes it very easy to undo an action - just save the old state value, and replace the current state with the old state. That state will always be valid, since it's never changed, only replaced!

## State is updated using pure functions
Since state is read-only, the way to change it is with **pure functions**, known in Rodux as [reducers](reducers.md). Reducers take the old state and an action, and return a brand-new state table. They do not change the old state - they make a new state table.
