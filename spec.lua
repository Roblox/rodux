local lemur = require("src.lemur")

local habitat = lemur.Habitat.new()

local Rodux = lemur.Instance.new("Folder")
Rodux.Name = "Rodux"
habitat:loadFromFs("src/rodux", Rodux)

local TestEZ = lemur.Instance.new("Folder")
TestEZ.Name = "TestEZ"
habitat:loadFromFs("src/testez", TestEZ)

local TestBootstrap = habitat:require(TestEZ.TestBootstrap)
local TextReporter = habitat:require(TestEZ.Reporters.TextReporter)

TestBootstrap:run(Rodux, TextReporter)