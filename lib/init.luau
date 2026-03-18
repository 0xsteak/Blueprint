type BlueprintImpl = {
	__index: BlueprintImpl,
	new: (blueprintData: BlueprintData) -> Blueprint,
	Build: (self: Blueprint) -> Instance,
	Destroy: (self: Blueprint) -> (),
}

export type BlueprintData = {
	Class: string,
	[string]: string,
} & {
	[number]: BlueprintData | Instance,
}

type self = {
	Data: BlueprintData,
}

export type Blueprint = typeof(setmetatable({} :: self, {} :: BlueprintImpl))

local Blueprint = {} :: BlueprintImpl
Blueprint.__index = Blueprint

local function buildFromData(blueprintData: BlueprintData): Instance
	local instance = Instance.new(blueprintData.Class)

	for property, value in pairs(blueprintData) do
		if property == 'Class' then continue end

		if typeof(property) == 'number' then
			if typeof(value) == 'table' then
				buildFromData(value).Parent = instance
			elseif typeof(value) == 'Instance' then
				value.Parent = instance
			end

			continue
		end

		instance[property] = value
	end

	return instance
end

function Blueprint.new(blueprintData: BlueprintData): Blueprint
	local self = setmetatable({}, Blueprint) :: Blueprint

	self.Class = 'Blueprint'
	self.Data = blueprintData

	return self
end

function Blueprint.Build(self: Blueprint): Instance
	return buildFromData(self.Data)
end

function Blueprint.Destroy(self: Blueprint)
	self.Instance:Destroy()
end

return Blueprint
