# State
In Rodux, the **state** of your game is one large table that contains everything that is currently happening. The state is the *single source of truth* in your game. This makes it easy to:

* Save and load state
* Debug your game
* Undo/redo actions

## What to put in state
Anything that changes in your game should go in your state table. You should be able to look at your state table and determine exactly what was going on at a given point in time, without knowing anything else.

Constants and configuration values that don't ever change in your game don't need to go in your state table.

## State is read-only
In Rodux, state is **read-only** - it cannot be changed directly. The only way to change your state is by dispatching an [action](./actions.md). This means that every change to your state flows down a single path, which can be easily manipulated. Logging state changes, for example, only needs to happen in one place, instead of sprinkling `print` statements across your entire codebase.

## State is updated using pure functions
Since state is read-only, the way to change it is with **pure functions**, known in Rodux as [reducers](./reducers.md). Reducers take the old state and an action, and return a brand-new state table. They do not change the old state - they make a new state table.
