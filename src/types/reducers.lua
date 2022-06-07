local _actions = require(script.Parent.actions)

type AnyAction = _actions.AnyAction

export type Reducer<State = any, Action = AnyAction> = (State?, Action) -> State

return nil
