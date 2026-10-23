--!strict
-- Componentes reutilizables de UI.

local Theme = require(script.Parent:WaitForChild("Theme"))

local Components = {}

function Components.corner(parent: Instance, radius: number): UICorner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

function Components.stroke(parent: Instance, color: Color3, thickness: number): UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Transparency = 0.35
	stroke.Parent = parent
	return stroke
end

function Components.padding(parent: Instance, all: number): UIPadding
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, all)
	padding.PaddingBottom = UDim.new(0, all)
	padding.PaddingLeft = UDim.new(0, all)
	padding.PaddingRight = UDim.new(0, all)
	padding.Parent = parent
	return padding
end

function Components.list(
	parent: Instance,
	direction: Enum.FillDirection,
	padding: number
): UIListLayout
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = direction
	layout.Padding = UDim.new(0, padding)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = parent
	return layout
end

function Components.frame(props: { [string]: any }): Frame
	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Frame"
	frame.BackgroundColor3 = props.BackgroundColor3 or Theme.Colors.Panel
	frame.BackgroundTransparency = props.BackgroundTransparency or 0
	frame.BorderSizePixel = 0
	frame.Size = props.Size or UDim2.fromOffset(100, 100)
	frame.Position = props.Position or UDim2.fromOffset(0, 0)
	frame.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	frame.Visible = props.Visible ~= false
	frame.ZIndex = props.ZIndex or 1
	frame.Parent = props.Parent
	return frame
end

function Components.label(props: { [string]: any }): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = props.Name or "Label"
	label.BackgroundTransparency = props.BackgroundTransparency or 1
	label.BackgroundColor3 = props.BackgroundColor3 or Theme.Colors.Panel
	label.BorderSizePixel = 0
	label.Size = props.Size or UDim2.fromScale(1, 1)
	label.Position = props.Position or UDim2.fromOffset(0, 0)
	label.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	label.Font = props.Font or Theme.Font
	label.Text = props.Text or ""
	label.TextColor3 = props.TextColor3 or Theme.Colors.Text
	label.TextScaled = props.TextScaled ~= false
	label.TextWrapped = props.TextWrapped == true
	label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	label.ZIndex = props.ZIndex or 1
	label.Parent = props.Parent
	return label
end

function Components.button(props: { [string]: any }): TextButton
	local button = Instance.new("TextButton")
	button.Name = props.Name or "Button"
	button.BackgroundColor3 = props.BackgroundColor3 or Theme.Colors.PanelLight
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Size = props.Size or UDim2.fromOffset(120, 44)
	button.Position = props.Position or UDim2.fromOffset(0, 0)
	button.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	button.Font = props.Font or Theme.FontBold
	button.Text = props.Text or "Button"
	button.TextColor3 = props.TextColor3 or Theme.Colors.Text
	button.TextScaled = props.TextScaled ~= false
	button.ZIndex = props.ZIndex or 2
	button.Parent = props.Parent

	Components.corner(button, 10)
	Components.stroke(button, props.StrokeColor or Theme.Colors.Accent, 1)

	local baseColor = button.BackgroundColor3
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.12)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = baseColor
	end)
	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = baseColor:Lerp(Color3.new(0, 0, 0), 0.15)
	end)
	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = baseColor
	end)

	return button
end

function Components.bar(
	parent: Instance,
	size: UDim2,
	position: UDim2,
	color: Color3
): (Frame, Frame)
	local back = Components.frame({
		Name = "BarBack",
		Size = size,
		Position = position,
		BackgroundColor3 = Theme.Colors.PanelDark,
		Parent = parent,
	})
	Components.corner(back, 6)

	local fill = Components.frame({
		Name = "BarFill",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = color,
		Parent = back,
	})
	Components.corner(fill, 6)

	return back, fill
end

function Components.formatNumber(value: number): string
	local formatted = tostring(math.floor(value))
	local result = formatted:reverse():gsub("(%d%d%d)", "%1,"):reverse()
	if result:sub(1, 1) == "," then
		result = result:sub(2)
	end
	return result
end

return table.freeze(Components)
