local indentStr = "    "

local function prettyPrint(t, indent)
	indent = indent or 1
	local outputBuffer = {
		"{\n"
	}

	for key, value in pairs(t) do
		local strKey = tostring(key)

		table.insert(outputBuffer, indentStr:rep(indent + 1))
		table.insert(outputBuffer, strKey)
		table.insert(outputBuffer, " = ")

		if type(value) == "table" then
			table.insert(outputBuffer, prettyPrint(value, indent + 1))
			table.insert(outputBuffer, "\n")
		else
			table.insert(outputBuffer, tostring(value))
			table.insert(outputBuffer, "; (")
			table.insert(outputBuffer, typeof(value))
			table.insert(outputBuffer, ")\n")
		end
	end

	table.insert(outputBuffer, indentStr:rep(indent))
	table.insert(outputBuffer, "}")

	return table.concat(outputBuffer, "")
end

local function loggerPlugin(next)
	return function(store, action)
		print("Action dispatched:", prettyPrint(action))
		next(store, action)
		print("State changed to:", prettyPrint(store:getState()))
	end
end

return loggerPlugin
