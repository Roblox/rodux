local function getFunctionName(fn)
	-- selene: allow(incorrect_standard_library_use)
	local functionName = typeof(fn) == "function" and (debug.info and debug.info(fn, "sln"))
		or (debug.getinfo and debug.getinfo(fn).name or debug.getinfo(fn).source)
	if functionName == nil or functionName == "" then
		functionName = tostring(fn)
	end

	return functionName
end

return getFunctionName