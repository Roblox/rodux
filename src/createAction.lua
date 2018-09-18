--[[
	A helper function to define a Rodux action creator with an associated name.

	`createAction` provides a utility that makes action creation cleaner
	and less error prone. Define your Rodux action like this:

		return Action("MyAction", function(value)
			return {
				value = value,
			}
		end)

	The `type` field will be added automatically. Additionally, the returned action
	creator now has a 'name' property that can be checked by your reducer:

		local MyAction = require(Reducers.MyAction)
		...
		if action.type == MyAction.name then
			-- change some state!
		end

	This creates a clear link between reducers and the actions they use, and allows
	linters like Luacheck to generate warnings if we type names incorrectly.
]]

local function createAction(name, fn)
	assert(type(name) == "string", "A name must be provided to create an Action")
	assert(type(fn) == "function", "A function must be provided to create an Action")

	return setmetatable({
		name = name,
	}, {
		__call = function(self, ...)
			local result = fn(...)

			assert(type(result) == "table", "An action must return a table")

			result.type = name

			return result
		end
	})
end

return createAction