local RobloxApi = require("./RobloxApi")

-- -- -- -- --

local Properties = {}

local classesInfo: { [string]: { props: { string }, superclass: string } } = {}
local propsDefaults: { [string]: { [string]: any } } = {}

local function getAllProps(class: string): { string }
	local props = {}

	local info = classesInfo[class]
	local superclass = info.superclass

	for _, prop in info.props do
		table.insert(props, prop)
	end

	if superclass ~= "<<<ROOT>>>" then
		for _, prop in getAllProps(superclass) do
			table.insert(props, prop)
		end
	end

	return props
end

for _, class in RobloxApi.Get().Classes do
	local name = class.Name

	local info = {
		superclass = class.Superclass,
	}
	local props = {}
	info.props = props

	for _, member in class.Members do
		if
			member.MemberType ~= "Property"
			or RobloxApi.HasTag(member.Tags, "ReadOnly")
			or RobloxApi.HasTag(member.Tags, "Deprecated")
			or member.Security.Write ~= "None"
		then
			continue
		end

		table.insert(props, member.Name)
	end

	classesInfo[name] = info
end

for name in classesInfo do
	local props = getAllProps(name)

	local success, instance = pcall(function()
		return Instance.new(name)
	end)

	local defaults = {}

	if not success then
		continue
	end

	for _, prop in props do
		local successProp, value = pcall(function()
			return instance[prop]
		end)

		if successProp then
			defaults[prop] = value
		end
	end

	propsDefaults[name] = defaults
end

Properties.Get = getAllProps

function Properties.GetDefaults(class: string): { [string]: any }?
	return propsDefaults[class]
end

return Properties
