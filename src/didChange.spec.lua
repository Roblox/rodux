return function()
	local didChange = require(script.Parent.didChange)

	it("should return true for changed non-table to non-table values", function()
		local original = "hello"
		local new = "world"

		local isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(true)
	end)

	it("should return false for not-changed non-table to non-table values", function()
		local original = "hello world"
		local new = "hello world"

		local isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(false)
	end)

	it("should return true for changed table to table values", function()
		-- check same key change
		local original = {
			key = "hello"
		}
		local new = {
			key = "world"
		}

		local isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(true)

		-- check new key added
		original = {
			key = "hello"
		}
		new = {
			key = "hello",
			otherKey = "world"
		}

		isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(true)

		-- check key removed
		original = {
			key = "hello"
		}
		new = {}

		isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(true)

		-- check recursive
		original = {
			data = {
				key = "hello"
			}
		}
		new = {
			data = {
				key = "world"
			}
		}

		isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(true)
	end)

	it("should return false for not changed table to table values", function()
		local original = {
			key = "hello world"
		}
		local new = {
			key = "hello world"
		}

		local isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(false)

		-- check recursive
		original = {
			data = {
				key = "hello world"
			}
		}
		new = {
			data = {
				key = "hello world"
			}
		}

		isDifferent = didChange(original, new)
		expect(isDifferent).to.equal(false)
	end)
end
