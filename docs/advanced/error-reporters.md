When Rodux encounters errors during action processing or when updating consumers, it will rethrow them by default. In some cases, you may want to intercept errors and record them somewhere useful, often with additional context.

The `Rodux.Store.new` function accepts an optional `errorReporter` object with the following shape:
```
ErrorReporter = {
	reportReducerError(prevState, action, errorResult) -> (),
	reportUpdateError(prevState, currentState, actionLog, errorResult) -> (),
}
```

The default implementation used by rodux looks like this:
```lua
local rethrowErrorReporter = {
	reportReducerError = function(prevState, action, errorResult)
		error(string.format("Received error: %s\n\n%s", errorResult.message, errorResult.thrownValue))
	end,
	reportUpdateError = function(prevState, currentState, lastActions, errorResult)
		error(string.format("Received error: %s\n\n%s", errorResult.message, errorResult.thrownValue))
	end,
}
```

In practice, you might use a custom error reporter to send detailed error information to an analytics endpoint:
```lua
-- This example supposes that we have some utilities for serializing the store
-- objects that were involved when an error was thrown
local inspectObject = require(MyUtils.inspectObject)
local tableDiff = require(MyUtils.tableDiff)
local sendToAnalyticsBackend = require(MyUtils.sendToAnalyticsBackend)

local rethrowErrorReporter = {
	reportReducerError = function(prevState, action, errorResult)
		local message = string.format(
			"%s\n\nAction:\n%s\n\nError contents:\n%s",
			errorResult.message,
			inspectObject(action),
			tostring(errorResult.thrownValue)
		)
		sendToAnalyticsBackend(message)
	end,
	reportUpdateError = function(prevState, currentState, lastActions, errorResult)
		local message = string.format(
			"%s\n\n" ..
				"Store changes in the last flush:\n%s\n\n" ..
				"Most recent actions (starting with the oldest):\n%s\n\n" ..
				"Error contents:\n%s",
			errorResult.message,
			inspectObject(tableDiff(prevState, currentState)),
			inspectObject(actionLog),
			tostring(errorResult.thrownValue)
		)
		sendToAnalyticsBackend(message)
	end,
}
```
