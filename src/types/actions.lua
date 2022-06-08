export type Action<Type = string> = {
	type: Type,
}

export type AnyAction = Action & {
	[string]: any,
}

export type ActionCreator<Type, Action, Args...> = typeof(setmetatable(
	{} :: { name: Type },
	{} :: { __call: (any, Args...) -> (Action & { type: Type }) }
))

return nil
