return function()
	local Store = require(script.Parent.Store)
	local loggerMiddleware = require(script.Parent.loggerMiddleware)

	it("should print whenever an action is dispatched", function()
		local outputCount = 0

		local function reducer(state, action)
			return state
		end

		local function outputFunction()
			outputCount = outputCount + 1
		end

		-- Modify the output function so we don't spam test logs.
		loggerMiddleware.outputFunction = outputFunction

		local store = Store.new(reducer, {
			value = 0,
			otherValue = {},
		}, { loggerMiddleware })
		store:dispatch({
			type = "test"
		})

		expect(outputCount >= 1).to.be.ok()
	end)
end
