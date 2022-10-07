--!strict
--[[
	A helper function to define a Rodux action creator with an associated name.
]]

local actions = require(script.Parent.types.actions)

export type Action<Type> = actions.Action<Type>

export type ActionCreator<Type, Action, Args...> = actions.ActionCreator<Type, Action, Args...>

local function makeActionCreator<Type, Payload, Args...>(name: Type, fn: (Args...) -> Payload): ActionCreator<Type, Payload, Args...>
	assert(type(name) == "string", "Bad argument #1: Expected a string name for the action creator")

	assert(type(fn) == "function", "Bad argument #2: Expected a function that creates action objects")

	return setmetatable({
		name = name,
	}, {
		__call = function(_self: any, ...: Args...): Payload & Action<Type>
			local result = fn(...)

			assert(type(result) == "table", "Invalid action: An action creator must return a table")

			result.type = name

			return result
		end,
	})
end

return makeActionCreator
