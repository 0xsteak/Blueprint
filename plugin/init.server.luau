if not game:GetService("RunService"):IsEdit() then
	return
end

-- -- -- -- --

local Generator = require("@self/Generator")

-- -- -- -- --

local Selection = game:GetService("Selection")
local StudioService = game:GetService("StudioService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local toolBar = plugin:CreateToolbar("Blueprint")
local button = toolBar:CreateButton(
	"Generate",
	"Generates a code snippet with a blueprint of your selected instance",
	StudioService:GetClassIcon("ModuleScript").Image
)

local function generate()
	local target = Selection:Get()[1]
	if not target then
		return
	end

	local code, varName = Generator.Generate(target)
	if not code then
		return
	end

	local codeScript = Instance.new("Script")
	codeScript.Name = "Blueprint_" .. varName
	codeScript.Parent = workspace
	codeScript.Disabled = true
	codeScript.Source = code

	ScriptEditorService:OpenScriptDocumentAsync(codeScript)
end

button.Click:Connect(generate)
