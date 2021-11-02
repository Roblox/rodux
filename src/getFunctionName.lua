local function getFunctionName(fn)
	local functionName
	if typeof(fn) == "function" then
		-- try using Roblox Lua's debug.info before falling back to lua5.1 debug.getinfo
		-- selene: allow(incorrect_standard_library_use)
		functionName = (type(debug.info) == "function") and debug.info(fn, "sln")
			or (type(debug.getinfo) == "function") and debug.getinfo(fn).source
	end
	if functionName == nil or functionName == "" then
		functionName = tostring(fn)
	end

	return functionName
end

return getFunctionName
