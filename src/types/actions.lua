--!strict
export type Action<Type = any> = {
	type: Type,
}

export type AnyAction = {
	[string]: any,
} & Action

export type ActionCreator<Type, Payload, Args...> = typeof(setmetatable(
	{} :: { name: Type },
	{} :: { __call: (any, Args...) -> Payload & Action<Type> }
))

return nil
