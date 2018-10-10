--[[
	A helper function to define a Rodux action creator with an associated name.

	`makeActionCreator` provides a utility that makes action creation cleaner
	and less error prone. Define your Rodux action like this:

		return makeActionCreator("MyAction", function(value)
			return {
				value = value,
			}
		end)

	The resulting action creator will populate the `type` field will be automatically.
	Additionally, the action creatoralso has a 'name' property that can be checked by
	your reducer:

		local MyAction = require(Reducers.MyAction)
		...
		if action.type == MyAction.name then
			-- change some state!
		end

	This creates a clear link between reducers and the actions they use, and allows
	linters like Luacheck to generate warnings if we type names incorrectly.
]]

local function makeActionCreator(name, fn)
	assert(type(name) == "string", "Bad argument #1: Expecteda string name for the action creator")
	assert(type(fn) == "function", "Bad argument #2: Expected a function that creates action objects")

	return setmetatable({
		name = name,
	}, {
		__call = function(self, ...)
			local result = fn(...)

			assert(type(result) == "table", "Invalid action: An action creator must return a table")

			result.type = name

			return result
		end
	})
end

return makeActionCreator