--!strict
local actions = require(script.Parent.actions)

type BaseAction = actions.Action<string>

type EmptyObject = {}

export type CombinedState<State> = EmptyObject & State

export type IDispatch<Store> = <Action>(self: Store, action: Action & BaseAction) -> ()
export type Dispatch<State = any> = IDispatch<Store<State>>

export type IStore<State, Dispatch> = {
	dispatch: Dispatch,
	getState: (self: IStore<State, Dispatch>) -> State,

	--[[
		FIXME LUAU: Typing self as any here is a hack. We need to look
		into the exact issue (suspected to be related to contravariance).
	]]
	destruct: (self: any) -> (),
	flush: (self: any) -> (),

	changed: RBXScriptSignal,
}
export type Store<State = any> = IStore<State, Dispatch<State>>

return nil
