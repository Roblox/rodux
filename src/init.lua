local Store = require(script.Store)
local createReducer = require(script.createReducer)
local combineReducers = require(script.combineReducers)
local makeActionCreator = require(script.makeActionCreator)
local loggerMiddleware = require(script.loggerMiddleware)
local thunkMiddleware = require(script.thunkMiddleware)
local makeThunkMiddleware = require(script.makeThunkMiddleware)

local actions = require(script.types.actions)
local reducers = require(script.types.reducers)

export type Action<Type = string> = actions.Action<Type>
export type AnyAction = actions.AnyAction
export type ActionCreator<Type, Action, Args...> = actions.ActionCreator<Type, Action, Args...>

export type Reducer<State = any, Action = AnyAction> = reducers.Reducer<State, Action>

return {
	Store = Store,
	createReducer = createReducer,
	combineReducers = combineReducers,
	makeActionCreator = makeActionCreator,
	loggerMiddleware = loggerMiddleware.middleware,
	thunkMiddleware = thunkMiddleware,
	makeThunkMiddleware = makeThunkMiddleware,
}
