local lemur = require("modules.lemur")

local habitat = lemur.Habitat.new()

local Rodux = lemur.Instance.new("Folder")
Rodux.Name = "Rodux"
habitat:loadFromFs("lib", Rodux)

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
habitat:loadFromFs("modules/testez/lib", TestEZ)

local TestBootstrap = habitat:require(TestEZ.TestBootstrap)
local TextReporter = habitat:require(TestEZ.Reporters.TextReporter)

local results = TestBootstrap:run(Rodux, TextReporter)

if results.failureCount > 0 then
	os.exit(1)
end