--[[
	A middleware that allows for functions to be dispatched.
	Functions will receive a single argument, the store itself.
	This middleware consumes the function; middleware further down the chain
	will not receive it.
]]
local function tracebackReporter(message)
	return debug.traceback(message)
end

local function thunkMiddleware(nextDispatch, store)
	return function(action)
		if typeof(action) == "function" then
			local ok, result = xpcall(function()
				return action(store)
			end, tracebackReporter)

			if not ok then
				local reducerName = typeof(action) == "function" and (debug.info and debug.info(action, "n"))
					or (debug.getinfo and debug.getinfo(action, "n").name)
				if reducerName == nil or reducerName == "" then
					reducerName = tostring(action)
				end

				-- report the error and move on so it's non-fatal app
				store._errorReporter.reportReducerError(store:getState(), action, {
					message = "Caught error in thunk (" .. reducerName .. ")",
					thrownValue = result,
				})
				return nil
			end

			return result
		end

		return nextDispatch(action)
	end
end

return thunkMiddleware
