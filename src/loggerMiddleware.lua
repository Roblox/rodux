local indent = "    "

local function prettyPrint(value, indentLevel)
	indentLevel = indentLevel or 0
	local output = {}

	if typeof(value) == "table" then
		table.insert(output, "{\n")

		for key, subValue in pairs(value) do
			table.insert(output, string.rep(indent, indentLevel + 1))
			table.insert(output, tostring(key))
			table.insert(output, " = ")

			table.insert(output, prettyPrint(subValue, indentLevel + 1))
			table.insert(output, "\n")
		end

		table.insert(output, string.rep(indent, indentLevel))
		table.insert(output, "}")
	elseif typeof(value) == "string" then
		table.insert(output, string.format("%q", value))
		table.insert(output, " (string)")
	else
		table.insert(output, tostring(value))
		table.insert(output, " (")
		table.insert(output, typeof(value))
		table.insert(output, ")")
	end

	return table.concat(output, "")
end

-- We want to be able to override outputFunction in tests, so the shape of this
-- module is kind of unconventional.
--
-- We fix it this weird shape in init.lua.
local loggerMiddleware = {
	outputFunction = print,
}

function loggerMiddleware.middleware(nextDispatch, store)
	return function(action)
		local result = nextDispatch(action)

		loggerMiddleware.outputFunction(string.format(
			"Action dispatched: %s\nState changed to: %s",
			prettyPrint(action),
			prettyPrint(store:getState())
		))

		return result
	end
end

return loggerMiddleware
