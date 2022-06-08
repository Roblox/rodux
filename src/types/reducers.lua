local actions = require(script.Parent.actions)

type AnyAction = actions.AnyAction

export type Reducer<State = any, Action = AnyAction> = (State?, Action) -> State

return nil
