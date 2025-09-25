local Properties = require("./Properties")
local Format = require("./Format")
local StringUtils = require("./StringUtils")

-- -- -- -- --

type BlueprintData = {
	Class: string,
	[string]: string,
} & {
	[number]: BlueprintData | Instance,
}

-- -- -- -- --

local Generator = {}

local function generateBlueprintData(instance: Instance): BlueprintData
	local className = instance.ClassName

	local data = {
		Class = instance.ClassName,
	}

	local defaults = Properties.GetDefaults(className)

	if not defaults then
		print(`{className} is not supported.`)
		return
	end

	for prop, defaultValue in defaults do
		if prop == "Parent" or instance[prop] == defaultValue then
			continue
		end

		data[prop] = instance[prop]
	end

	for index, child in instance:GetChildren() do
		data[index] = generateBlueprintData(child)
	end

	return data
end

function Generator.Generate(instance: Instance): (string, string)
	local data: BlueprintData = generateBlueprintData(instance)
	if not data then
		return
	end

	local varName = StringUtils.MakeIdentifier(instance.Name)

	return `local {varName} = Blueprint.new({Format.table(data)})`, varName
end

return Generator
