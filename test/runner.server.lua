--[[
	This test runner is invoked in all the environments that we want to test our
	library in.

	We target Lemur, Roblox Studio, and Roblox-CLI.
]]

local isRobloxCli, ProcessService = pcall(game.GetService, game, "ProcessService")

local completed, result = xpcall(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local Roact = require(ReplicatedStorage.Roact)
	local TestEZ = require(ReplicatedStorage.TestEZ)

	Roact.setGlobalConfig({
		internalTypeChecks = true,
		typeChecks = true,
		elementTracing = true,
		propValidation = true,
	})

	local results = TestEZ.TestBootstrap:run(
		{ ReplicatedStorage.RoactRodux },
		TestEZ.Reporters.TextReporter
	)

	return results.failureCount == 0 and 0 or 1
end, debug.traceback)

local statusCode
local errorMessage = nil
if completed then
	statusCode = result
else
	statusCode = 1
	errorMessage = result
end

if __LEMUR__ then
	-- Lemur has access to normal Lua OS APIs

	if errorMessage ~= nil then
		print(errorMessage)
	end
	os.exit(statusCode)
elseif isRobloxCli then
	-- Roblox CLI has a special service to terminate the process

	if errorMessage ~= nil then
		print(errorMessage)
	end
	ProcessService:ExitAsync(statusCode)
else
	-- In Studio, we can just throw an error to get the user's attention

	if errorMessage ~= nil then
		error(errorMessage, 0)
	end
end
