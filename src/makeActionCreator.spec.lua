return function()
	local createAction = require(script.Parent.createAction)

	it("should set the name of the action", function()
		local action = createAction("foo", function()
			return {}
		end)

		expect(action.name).to.equal("foo")
	end)

	it("should be able to be called as a function", function()
		local action = createAction("foo", function()
			return {}
		end)

		expect(action).never.to.throw()
	end)

	it("should return a table when called as a function", function()
		local action = createAction("foo", function()
			return {}
		end)

		expect(action()).to.be.a("table")
	end)

	it("should set the type of the action", function()
		local action = createAction("foo", function()
			return {}
		end)

		expect(action().type).to.equal("foo")
	end)

	it("should set values", function()
		local action = createAction("foo", function(value)
			return {
				value = value
			}
		end)

		expect(action(100).value).to.equal(100)
	end)

	it("should throw when its result does not return a table", function()
		local action = createAction("foo", function()
			return function() end
		end)

		expect(action).to.throw()
	end)

	it("should throw if the first argument is not a string", function()
		expect(function()
			createAction(nil, function()
				return {}
			end)
		end).to.throw()

		expect(function()
			createAction(100, function()
				return {}
			end)
		end).to.throw()
	end)

	it("should throw if the second argument is not a function", function()
		expect(function()
			createAction("foo", nil)
		end).to.throw()

		expect(function()
			createAction("foo", {})
		end).to.throw()
	end)
end