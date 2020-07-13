--[[
	A function that can be used to determine if a new value is equal to the old
	value, recursively
]]

local didChange

didChange = function(original, new)
	-- if both original and new aren't tables, compare
	if not (type(original) == 'table' and type(new) == 'table') then
		return original ~= new
	end

	print(new, type(new), original, type(original))

	-- compare new to old
	for key, value in pairs(new) do
		-- check for changed keys
		print(key, value, original[key], original[key] ~= value)
		if not (type(original[key]) == 'table' and type(value) == 'table') then
			if original[key] ~= value then
				return true
			end
		end

		-- repeat for children
		if type(value) == 'table' then
			return didChange(original[key], value)
		end
	end

	-- compare old to new
	for key, value in pairs(original) do
		-- check for changed keys
		if not (type(value) == 'table' and type(new[key]) == 'table') then
			if value ~= new[key] then
				return true
			end
		end

		-- repeat for children
		if type(value) == 'table' then
			return didChange(value, new[key])
		end
	end

	return false
end

return didChange
