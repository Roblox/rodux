-- upstream: https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/inspect.js
local HttpService = game:GetService("HttpService")

local isArray = require(script.Parent.isArray)
local objectKeys = require(script.Parent.objectKeys)

local MAX_ARRAY_LENGTH = 10
local MAX_RECURSIVE_DEPTH = 2

local formatValue
local formatObjectValue
local formatArray
local formatObject
local getObjectTag

local function find(array, value)
	for i = 1, #array do
		if array[i] == value then
			return i
		end
	end
	return nil
end

--[[
 * Used to print values in error messages.
 ]]
local function inspect(value)
	return formatValue(value, {})
end

function formatValue(value, seenValues)
	local valueType = typeof(value)
	if valueType == "string" then
		return HttpService:JSONEncode(value)
	elseif valueType == "number" then
		if value ~= value then
			return "NaN"
		elseif value == math.huge then
			return "Infinity"
		elseif value == -math.huge then
			return "-Infinity"
		else
			return tostring(value)
		end
	elseif valueType == "function" then
		return "[function]"
	elseif valueType == "table" then
		return formatObjectValue(value, seenValues)
	else
		return tostring(value)
	end
end

function formatObjectValue(value, previouslySeenValues)
	if find(previouslySeenValues, value) ~= nil then
		return "[Circular]"
	end

	local seenValues = { unpack(previouslySeenValues) }
	table.insert(seenValues, value)

	if typeof(value.toJSON) == "function" then
		local jsonValue = value:toJSON(value)

		if jsonValue ~= value then
			if typeof(jsonValue) == "string" then
				return jsonValue
			else
				return formatValue(jsonValue, seenValues)
			end
		end
	elseif isArray(value) then
		return formatArray(value, seenValues)
	end

	return formatObject(value, seenValues)
end

function formatObject(object, seenValues)
	local keys = objectKeys(object)

	if #keys == 0 then
		return "{}"
	end
	if #seenValues > MAX_RECURSIVE_DEPTH then
		return "[" .. getObjectTag(object) .. "]"
	end

	local properties = {}
	for i = 1, #keys do
		local key = keys[i]
		local value = formatValue(object[key], seenValues)

		properties[i] = key .. ": " .. value
	end

	return "{ " .. table.concat(properties, ", ") .. " }"
end

function formatArray(array, seenValues)
	local length = #array
	if length == 0 then
		return "[]"
	end
	if #seenValues > MAX_RECURSIVE_DEPTH then
		return "[Array]"
	end

	local len = math.min(MAX_ARRAY_LENGTH, length)
	local remaining = length - len
	local items = {}

	for i = 1, len do
		items[i] = (formatValue(array[i], seenValues))
	end

	if remaining == 1 then
		table.insert(items, "... 1 more item")
	elseif remaining > 1 then
		table.insert(items, ("... %s more items"):format(remaining))
	end

	return "[" .. table.concat(items, ", ") .. "]"
end

function getObjectTag(_object)
	return "Object"
end

return {
	inspect = inspect,
}
