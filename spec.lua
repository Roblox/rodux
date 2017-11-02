local lemur = require("lemur")

local habitat = lemur.Habitat.new()

local Rodux = lemur.Instance.new("Folder")
Rodux.Name = "Rodux"
habitat:loadFromFs("src/rodux", Rodux)

-- Simulate rbxpacker's 'collapse' mechanism
do
	local newRoot = Rodux:FindFirstChild("init")
	newRoot.Name = Rodux.Name
	newRoot.Parent = nil

	for _, child in ipairs(Rodux:GetChildren()) do
		child.Parent = newRoot
	end

	Rodux = newRoot
end

local TestEZ = lemur.Instance.new("Folder")
TestEZ.Name = "TestEZ"
habitat:loadFromFs("testez/lib", TestEZ)

local TestBootstrap = habitat:require(TestEZ.TestBootstrap)
local TextReporter = habitat:require(TestEZ.Reporters.TextReporter)

TestBootstrap:run(Rodux, TextReporter)