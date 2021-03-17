--[[
	A middleware that allows for functions to be dispatched.
	Functions will receive a single argument, the store itself.
	This middleware consumes the function; middleware further down the chain
	will not receive it.
]]
local function reportThunkError(errorReporter, failedAction, error_, traceback)
	local message = ("Caught error when running thunk (%s) " ..
		"through thunk: \n%s"):format(tostring(failedAction), tostring(error_))

	errorReporter:reportErrorImmediately(message, traceback)
end

local function thunkMiddleware(nextDispatch, store)
	return function(action)
		if typeof(action) == "function" then
			local ok, result = pcall(function()
				return action(store)
			end)

			if not ok then
				-- report the error and move on so it's non-fatal app
				reportThunkError(store._errorReporter, action, result, debug.traceback())
				return nil
			end

			return result
		end

		local ok, result = pcall(function()
			return nextDispatch(action)
		end)

		if not ok then
			-- report the error and move on so it's non-fatal app
			reportThunkError(store._errorReporter, action, result, debug.traceback())
			return nil
		end

		return result
	end
end

return thunkMiddleware
