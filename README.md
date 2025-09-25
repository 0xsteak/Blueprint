# Blueprint

**Blueprint** is a tool for easily converting Roblox instances into executable Luau code.



## Library

The library is located in the **lib** folder. It is used to create blueprints.

### Usage

Example of creating a simple blueprint with a GUI Frame with a TextLabel inside it:
```luau
local FrameBlueprint = Blueprint.new({
	Class = "Frame", -- This field is required
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.new(1, 0, 0),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(200, 200),
	{
		Class = "TextLabel",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "Hello World!",
		TextSize = 14
	}
})

-- After creating a blueprint, your instance is cached
-- To create an instance from the blueprint you need to call the :Build() method
local Frame = FrameBlueprint:Build()

Frame.Parent = ScreenGui
```

## Plugin

The plugin is located in the plugins folder. The plugin is used in Roblox Studio to convert instances into code snippets that use the Blueprint library for creating blueprints for these instances. Unfortunately, the plugin doesn't have an advanced UI or anything like that yet.

### Installation

<a href="https://github.com/rojo-rbx/rokit">**Rokit**</a> is required for the installation!

**Windows**: Run install-plugin.bat

**MacOS**: Run install-plugin.sh (not tested)

### Usage

1. Open the plugins tab (You should see a "Generate" button there)
2. Select your instance in explorer
3. Press "Generate" button and it will open a new script for you, which contains the code snippet.