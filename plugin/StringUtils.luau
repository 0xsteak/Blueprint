local StringUtils = {}

local reservedKeywords = {
	"and",
	"break",
	"do",
	"else",
	"elseif",
	"end",
	"false",
	"for",
	"function",
	"if",
	"in",
	"local",
	"nil",
	"not",
	"or",
	"repeat",
	"return",
	"then",
	"true",
	"until",
	"while",
}

function StringUtils.IsLuauReserved(str: string): boolean
	return table.find(reservedKeywords, str) and true or false
end

function StringUtils.IsValidIdentifier(str: string): boolean
	return str:match("^[%a_]+[%w_]*$") and not table.find(reservedKeywords, str) and true or false
end

function StringUtils.MakeIdentifier(str: string): string
	if StringUtils.IsLuauReserved(str) then
		return "_" .. str
	end

	str = str:gsub("[%s%-]", "_")
	str = str:match("[%w_]+") or ""

	if str:sub(1, 1):match("%d") then
		str = "_" .. str
	end

	return if #str > 0 then str else "a"
end

return StringUtils
