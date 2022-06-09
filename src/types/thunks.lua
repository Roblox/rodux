--!strict
local store = require(script.Parent.store)

type IStore<State, Dispatch> = store.IStore<State, Dispatch>
type IDispatch<Store> = store.IDispatch<Store>
type BoundDispatch = store.BoundDispatch

export type IThunkAction<ReturnType, Store> = (Store) -> ReturnType
export type ThunkAction<ReturnType, State = any> = IThunkAction<ReturnType, ThunkfulStore<State>>

export type IBoundThunkDispatch<Store> = <ReturnType>(
	thunkAction: IThunkAction<ReturnType, Store>
) -> ReturnType
export type BoundThunkDispatch<State = any> = BoundDispatch & IBoundThunkDispatch<ThunkfulStore<State>>

export type IThunkDispatch<Store> = <ReturnType>(
	self: Store,
	thunkAction: IThunkAction<ReturnType, Store>
) -> ReturnType
export type ThunkDispatch<State = any> = IDispatch<ThunkfulStore<State>> & IThunkDispatch<ThunkfulStore<State>>

export type ThunkfulStore<State = any> = IStore<State, ThunkDispatch<State>>

return nil
