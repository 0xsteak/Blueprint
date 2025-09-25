type ApiSecurity = "None" | "LocalUserSecurity"

type ApiTag = "NotCreatable" | "Deprecated" | "ReadOnly" | "Service"

type ApiClassMember = {
	MemberType: "Property",
	Name: string,
	Security: {
		Read: ApiSecurity,
		Write: ApiSecurity,
	},
	Tags: { ApiTag },
}

type ApiClass = {
	Members: { ApiClassMember },
	Name: string,
	Tags: { ApiTag },
	Superclass: string,
}

type Api = {
	Classes: { ApiClass },
}

-- -- -- -- --

local RobloxApi = {}

local HttpService = game:GetService("HttpService")

function RobloxApi.Get(): Api
	local version = HttpService:GetAsync("https://s3.amazonaws.com/setup.roblox.com/versionQTStudio")
	local jsonApi = HttpService:GetAsync(`https://s3.amazonaws.com/setup.roblox.com/{version}-API-Dump.json`)
	return HttpService:JSONDecode(jsonApi)
end

function RobloxApi.HasTag(tags: { ApiTag }, tag: ApiTag): boolean
	return tags and table.find(tags, tag) and true or false
end

return RobloxApi
