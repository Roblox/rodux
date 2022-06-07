local Store = require(script.Store)
local createReducer = require(script.createReducer)
local combineReducers = require(script.combineReducers)
local makeActionCreator = require(script.makeActionCreator)
local loggerMiddleware = require(script.loggerMiddleware)
local thunkMiddleware = require(script.thunkMiddleware)
local makeThunkMiddleware = require(script.makeThunkMiddleware)

local _actions = require(script.types.actions)
local _reducers = require(script.types.reducers)

export type Action<Type = any> = _actions.Action<Type>
export type AnyAction = _actions.AnyAction
export type ActionCreator<Type, Action, Args...> = _actions.ActionCreator<Type, Action, Args...>

export type Reducer<State = any, Action = AnyAction> = _reducers.Reducer<State, Action>

return {
	Store = Store,
	createReducer = createReducer,
	combineReducers = combineReducers,
	makeActionCreator = makeActionCreator,
	loggerMiddleware = loggerMiddleware.middleware,
	thunkMiddleware = thunkMiddleware,
	makeThunkMiddleware = makeThunkMiddleware,
}
