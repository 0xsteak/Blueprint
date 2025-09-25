local StringUtils = require("./StringUtils")

-- -- -- -- --

local Format = {}

local function formatCall(func: string, ...): string
	-- 'f' at the start means "formatted"
	local fArgs = {}

	for _, arg in { ... } do
		local formatter = Format[typeof(arg)]
		if not formatter then
			continue
		end

		table.insert(fArgs, formatter(arg))
	end

	return `{func}({table.concat(fArgs, ", ")})`
end

Format["nil"] = tostring

function Format.string(value: string): string
	return `"{value:gsub("\n", "\\n"):gsub("\r", "\\r"):gsub('"', '\\"')}"`
end

Format.number = tostring

Format.boolean = tostring

function Format.table(t): string
	local arrayPart = {}
	local dictPart = {}

	local dictSize = 0

	local dictKeys = {}

	for index, value in t do
		if index ~= #arrayPart + 1 then
			dictPart[index] = value

			if index ~= "Class" then
				table.insert(dictKeys, index)
			end

			dictSize += 1
			continue
		end

		table.insert(arrayPart, value)
	end

	table.sort(dictKeys)

	if dictPart.Class then
		table.insert(dictKeys, 1, "Class")
	end

	local f = "{"

	for _, index in dictKeys do
		local value = dictPart[index]
		if value == nil then
			continue
		end

		local fIndex
		local fValue

		if typeof(index) == "string" and StringUtils.IsValidIdentifier(index) then
			fIndex = index
		else
			local formatter = Format[typeof(index)]
			if not formatter then
				continue
			end

			fIndex = `[{formatter(index)}]`
		end

		local formatter = Format[typeof(value)]
		if not formatter then
			continue
		end

		fValue = formatter(value)

		if typeof(index) == "table" then
			fIndex = fIndex:gsub("\n", "\n" .. string.rep(" ", 4))
		end

		if typeof(value) == "table" then
			fValue = fValue:gsub("\n", "\n" .. string.rep(" ", 4))
		end

		f ..= "\n" .. string.rep(" ", 4) .. fIndex .. " = " .. fValue .. ","
	end

	for index, value in arrayPart do
		local fValue

		local formatter = Format[typeof(value)]
		if not formatter then
			continue
		end

		fValue = formatter(value)

		if typeof(value) == "table" then
			fValue = fValue:gsub("\n", "\n" .. string.rep(" ", 4))
		end

		if dictSize == 0 then
			local newLineCount = select(2, f:gsub("\n", ""))

			f ..= fValue

			if index < #arrayPart then
				f ..= ", "
			end

			if #f // 100 > newLineCount then
				f ..= "\n"
			end
		else
			f ..= "\n" .. string.rep(" ", 4) .. fValue .. ","
		end
	end

	f ..= if dictSize > 0 then "\n}" else "}"

	return f
end

function Format.vector(value: vector): string
	local x = value.x
	local y = value.y
	local z = value.z

	if x == 0 and y == 0 and z == 0 then
		return "vector.zero"
	end

	if x == 1 and y == 1 and z == 1 then
		return "vector.one"
	end

	return formatCall("vector.create", x, y, z)
end

function Format.Axes(value: Axes): string
	local axesPropsArgs = {
		X = Enum.Axis.X,
		Y = Enum.Axis.Y,
		Z = Enum.Axis.Z,
		Top = Enum.NormalId.Top,
		Bottom = Enum.NormalId.Bottom,
		Left = Enum.NormalId.Left,
		Right = Enum.NormalId.Right,
		Back = Enum.NormalId.Back,
		Front = Enum.NormalId.Front,
	}

	local constructorArgs = {}

	for prop, arg in axesPropsArgs do
		if value[prop] then
			table.insert(constructorArgs, arg)
		end
	end

	return formatCall("Axes.new", table.unpack(constructorArgs))
end

function Format.BrickColor(value: BrickColor): string
	return formatCall("BrickColor.new", value.Name)
end

function Format.CFrame(value: CFrame): string
	return formatCall("CFrame.new", value:GetComponents())
end

function Format.Color3(value: Color3): string
	-- return formatCall("Color3.new", value.R, value.G, value.B)
	return formatCall("Color3.fromHex", value:ToHex())
end

function Format.ColorSequence(value: ColorSequence): string
	return formatCall("ColorSequence.new", value.Keypoints)
end

function Format.ColorSequenceKeypoint(value: ColorSequenceKeypoint): string
	return formatCall("ColorSequenceKeypoint.new", value.Time, value.Value)
end

function Format.DateTime(value: DateTime): string
	return formatCall("DateTime.fromUnixTimestampMillis", value.UnixTimestampMillis)
end

Format.EnumItem = tostring

function Format.Faces(value: Faces): string
	local facesPropsArgs = {
		Top = Enum.NormalId.Top,
		Bottom = Enum.NormalId.Bottom,
		Left = Enum.NormalId.Left,
		Right = Enum.NormalId.Right,
		Back = Enum.NormalId.Back,
		Front = Enum.NormalId.Front,
	}

	local constructorArgs = {}

	for prop, arg in facesPropsArgs do
		if value[prop] then
			table.insert(constructorArgs, arg)
		end
	end

	return formatCall("Faces.new", table.unpack(constructorArgs))
end

function Format.Font(value: Font): string
	local style = if value.Style ~= Enum.FontStyle.Normal then value.Style else nil
	local weight = if value.Weight ~= Enum.FontWeight.Regular or style then value.Weight else nil

	return formatCall("Font.new", value.Family, weight, style)
end

function Format.NumberRange(value: NumberRange): string
	return formatCall("NumberRange.new", value.Min, value.Max)
end

function Format.NumberSequence(value: NumberSequence): string
	return formatCall("NumberSequence.new", value.Keypoints)
end

function Format.NumberSequenceKeypoint(value: NumberSequenceKeypoint): string
	return formatCall("NumberSequenceKeypoint.new", value.Time, value.Value, value.Envelope)
end

function Format.Path2DControlPoint(value: Path2DControlPoint): string
	return formatCall("Path2DControlPoint.new", value.Position, value.LeftTangent, value.RightTangent)
end

function Format.PhysicalProperties(value: PhysicalProperties): string
	return formatCall(
		"PhysicalProperties.new",
		value.Density,
		value.Friction,
		value.Elasticity,
		value.FrictionWeight,
		value.ElasticityWeight
	)
end

function Format.Rect(value: Rect): string
	return formatCall("Rect.new", value.Min.X, value.Min.Y, value.Max.X, value.Max.Y)
end

function Format.UDim(value: UDim): string
	return formatCall("UDim.new", value.Scale, value.Offset)
end

function Format.UDim2(value: UDim2): string
	local xScale = value.X.Scale
	local xOffset = value.X.Offset
	local yScale = value.Y.Scale
	local yOffset = value.Y.Offset

	if xScale == 0 and xOffset == 0 and yScale == 0 and yOffset == 0 then
		return formatCall("UDim2.new")
	elseif xScale == 0 and yScale == 0 then
		return formatCall("UDim2.fromOffset", xOffset, yOffset)
	elseif xOffset == 0 and yOffset == 0 then
		return formatCall("UDim2.fromScale", xScale, yScale)
	else
		return formatCall("UDim2.new", xScale, xOffset, yScale, yOffset)
	end
end

function Format.Vector2(value: Vector2): string
	local x = value.X
	local y = value.Y

	if x == 0 and y == 0 then
		return "Vector2.zero"
	elseif x == 1 and y == 1 then
		return "Vector2.one"
	else
		return formatCall("Vector2.new", value.X, value.Y)
	end
end

function Format.Vector3(value: Vector3): string
	local x = value.X
	local y = value.Y
	local z = value.Z

	if x == 0 and y == 0 and z == 0 then
		return "Vector3.zero"
	elseif x == 1 and y == 1 and z == 1 then
		return "Vector3.one"
	else
		return formatCall("Vector3.new", value.X, value.Y, value.Z)
	end
end

return Format
