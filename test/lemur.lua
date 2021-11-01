--[[
	Loads our library and all of its dependencies, then runs tests using TestEZ.
]]

-- If you add any dependencies, add them to this table so they'll be loaded!
local LOAD_MODULES = {
	{"src", "RoactRodux"},
	{"modules/rodux/src", "Rodux"},
	{"modules/roact/src", "Roact"},
	{"modules/testez/src", "TestEZ"},
}

-- This makes sure we can load Lemur and other libraries that depend on init.lua
package.path = package.path .. ";?/init.lua"

-- If this fails, make sure you've cloned all Git submodules of this repo!
local lemur = require("modules.lemur")

-- Create a virtual Roblox tree
local habitat = lemur.Habitat.new()

-- We'll put all of our library code and dependencies here
local ReplicatedStorage = habitat.game:GetService("ReplicatedStorage")

-- Load all of the modules specified above
for _, module in ipairs(LOAD_MODULES) do
	local container = habitat:loadFromFs(module[1])
	container.Name = module[2]
	container.Parent = ReplicatedStorage
end

-- When Lemur implements a proper scheduling interface, we'll use that instead.
local runTests = habitat:loadFromFs("test/runner.server.lua")
habitat:require(runTests)
