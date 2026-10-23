--!strict
-- Construye una cafetería por parcela. Todo el arte del MVP es placeholder.

local Types =
	require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Types"))

local CafeBuilder = {}

local TABLE_SLOTS = {
	{ table = Vector3.new(-12, 0, -4), chair = Vector3.new(-8, 0, -4) },
	{ table = Vector3.new(12, 0, -4), chair = Vector3.new(8, 0, -4) },
	{ table = Vector3.new(-12, 0, 4), chair = Vector3.new(-8, 0, 4) },
	{ table = Vector3.new(12, 0, 4), chair = Vector3.new(8, 0, 4) },
	{ table = Vector3.new(-12, 0, 12), chair = Vector3.new(-8, 0, 12) },
	{ table = Vector3.new(12, 0, 12), chair = Vector3.new(8, 0, 12) },
}

local function makePart(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	material: Enum.Material?
): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.CanCollide = true
	p.CanQuery = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Size = size
	p.CFrame = cframe
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Parent = parent
	return p
end

local function decoration(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	material: Enum.Material?
): Part
	local p = makePart(parent, name, size, cframe, color, material)
	p.CanCollide = false
	p.CanQuery = false
	return p
end

local function makeLabel(
	parent: Instance,
	name: string,
	text: string,
	color: Color3,
	size: UDim2,
	position: UDim2
): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.BackgroundTransparency = 1
	label.Size = size
	label.Position = position
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = color
	label.Text = text
	label.Parent = parent
	return label
end

local function makeTable(plot: Types.PlotRecord, slotIndex: number): Types.TableRecord?
	local slot = TABLE_SLOTS[slotIndex]
	if not slot then
		return nil
	end

	local origin = plot.origin
	local tablePosition = origin + slot.table
	local chairPosition = origin + slot.chair

	local model = Instance.new("Model")
	model.Name = "Table_" .. slotIndex
	model.Parent = plot.model:WaitForChild("Tables")

	local top = makePart(
		model,
		"Top",
		Vector3.new(6, 0.4, 6),
		CFrame.new(tablePosition + Vector3.new(0, 3, 0)),
		Color3.fromRGB(120, 82, 52),
		Enum.Material.Wood
	)
	top.CanCollide = true

	makePart(
		model,
		"Leg",
		Vector3.new(1, 2.6, 1),
		CFrame.new(tablePosition + Vector3.new(0, 1.6, 0)),
		Color3.fromRGB(80, 55, 40),
		Enum.Material.Wood
	)

	local candle = decoration(
		model,
		"Candle",
		Vector3.new(0.5, 0.8, 0.5),
		CFrame.new(tablePosition + Vector3.new(0, 3.6, 0)),
		Color3.fromRGB(255, 190, 100),
		Enum.Material.Neon
	)
	candle.CanCollide = false

	local seat = makePart(
		model,
		"Seat",
		Vector3.new(3, 0.5, 3),
		CFrame.new(chairPosition + Vector3.new(0, 1.5, 0)),
		Color3.fromRGB(100, 66, 46),
		Enum.Material.Wood
	)
	seat:SetAttribute("OccupiedBy", 0)

	local tableIsRight = tablePosition.X > chairPosition.X
	local backX = chairPosition.X + (tableIsRight and -1.5 or 1.5)
	makePart(
		model,
		"Back",
		Vector3.new(0.5, 3, 3),
		CFrame.new(Vector3.new(backX, 2.3, chairPosition.Z)),
		Color3.fromRGB(100, 66, 46),
		Enum.Material.Wood
	)

	local seatCFrame = CFrame.lookAt(
		Vector3.new(chairPosition.X, 1.75, chairPosition.Z),
		Vector3.new(tablePosition.X, 1.75, tablePosition.Z)
	)
	local approachX = chairPosition.X + (tableIsRight and -3 or 3)

	return {
		index = slotIndex,
		model = model,
		seat = seat,
		seatCFrame = seatCFrame,
		approachPosition = Vector3.new(approachX, 0.5, chairPosition.Z),
		occupiedBy = nil,
	}
end

local function makeStation(
	plot: Types.PlotRecord,
	x: number,
	stationType: string,
	color: Color3
): Part
	local station = makePart(
		plot.model:WaitForChild("Stations"),
		"Station_" .. stationType,
		Vector3.new(4, 4, 3),
		CFrame.new(plot.origin + Vector3.new(x, 2.5, -15.5)),
		color,
		Enum.Material.Metal
	)
	station:SetAttribute("StationType", stationType)
	station:SetAttribute("PlotIndex", plot.index)

	local gui = Instance.new("BillboardGui")
	gui.Name = "StationLabel"
	gui.Size = UDim2.fromOffset(180, 44)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 70
	gui.Parent = station

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(22, 34, 50)
	frame.BackgroundTransparency = 0.2
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	makeLabel(
		frame,
		"Title",
		stationType,
		Color3.fromRGB(255, 210, 150),
		UDim2.fromScale(0.92, 0.72),
		UDim2.fromScale(0.04, 0.14)
	)

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "CookPrompt"
	prompt.ActionText = "Cook"
	prompt.ObjectText = stationType
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 14
	prompt.RequiresLineOfSight = false
	prompt.Enabled = false
	prompt.Parent = station

	return station
end

function CafeBuilder.addTable(plot: Types.PlotRecord, slotIndex: number): Types.TableRecord?
	local record = makeTable(plot, slotIndex)
	if record then
		table.insert(plot.tables, record)
	end
	return record
end

function CafeBuilder.build(index: number, origin: Vector3): Types.PlotRecord
	local plotsFolder = workspace:FindFirstChild("Plots")
	if not plotsFolder then
		plotsFolder = Instance.new("Folder")
		plotsFolder.Name = "Plots"
		plotsFolder.Parent = workspace
	end

	local model = Instance.new("Model")
	model.Name = "Plot_" .. index
	model.Parent = plotsFolder

	for _, folderName in { "Structure", "Stations", "Tables", "Customers", "Markers" } do
		local folder = Instance.new("Folder")
		folder.Name = folderName
		folder.Parent = model
	end

	local plot = {
		index = index,
		origin = origin,
		model = model,
		stations = {},
		tables = {},
		ownerUserId = 0,
		ownerName = "",
	} :: any

	makePart(
		model:WaitForChild("Structure"),
		"PlotPad",
		Vector3.new(100, 0.4, 100),
		CFrame.new(origin + Vector3.new(0, 0, 0)),
		Color3.fromRGB(44, 72, 52),
		Enum.Material.Grass
	)

	makePart(
		model:WaitForChild("Structure"),
		"Floor",
		Vector3.new(44, 0.5, 36),
		CFrame.new(origin + Vector3.new(0, 0.25, 0)),
		Color3.fromRGB(120, 82, 52),
		Enum.Material.WoodPlanks
	)

	local wallColor = Color3.fromRGB(56, 78, 62)
	makePart(
		model:WaitForChild("Structure"),
		"WallBack",
		Vector3.new(44, 14, 1),
		CFrame.new(origin + Vector3.new(0, 7.5, -18)),
		wallColor,
		Enum.Material.WoodPlanks
	)
	makePart(
		model:WaitForChild("Structure"),
		"WallLeft",
		Vector3.new(1, 14, 36),
		CFrame.new(origin + Vector3.new(-22, 7.5, 0)),
		wallColor,
		Enum.Material.WoodPlanks
	)
	makePart(
		model:WaitForChild("Structure"),
		"WallRight",
		Vector3.new(1, 14, 36),
		CFrame.new(origin + Vector3.new(22, 7.5, 0)),
		wallColor,
		Enum.Material.WoodPlanks
	)
	makePart(
		model:WaitForChild("Structure"),
		"WallFrontLeft",
		Vector3.new(17, 14, 1),
		CFrame.new(origin + Vector3.new(-13.5, 7.5, 18)),
		wallColor,
		Enum.Material.WoodPlanks
	)
	makePart(
		model:WaitForChild("Structure"),
		"WallFrontRight",
		Vector3.new(17, 14, 1),
		CFrame.new(origin + Vector3.new(13.5, 7.5, 18)),
		wallColor,
		Enum.Material.WoodPlanks
	)
	makePart(
		model:WaitForChild("Structure"),
		"WallFrontTop",
		Vector3.new(10, 3, 1),
		CFrame.new(origin + Vector3.new(0, 13, 18)),
		wallColor,
		Enum.Material.WoodPlanks
	)

	for _, x in { -5, 5 } do
		makePart(
			model:WaitForChild("Structure"),
			"DoorPost",
			Vector3.new(1, 11, 1.4),
			CFrame.new(origin + Vector3.new(x, 6, 18)),
			Color3.fromRGB(80, 55, 40),
			Enum.Material.Wood
		)
	end
	makePart(
		model:WaitForChild("Structure"),
		"DoorBeam",
		Vector3.new(11, 1, 1.4),
		CFrame.new(origin + Vector3.new(0, 11.5, 18)),
		Color3.fromRGB(80, 55, 40),
		Enum.Material.Wood
	)

	for _, x in { -22.1, 22.1 } do
		for _, z in { -3, 7 } do
			local glass = makePart(
				model:WaitForChild("Structure"),
				"Window",
				Vector3.new(0.2, 6, 9),
				CFrame.new(origin + Vector3.new(x, 7.5, z)),
				Color3.fromRGB(150, 200, 220),
				Enum.Material.Glass
			)
			glass.Transparency = 0.45
			glass.CanCollide = false
		end
	end

	local counter = makePart(
		model:WaitForChild("Structure"),
		"Counter",
		Vector3.new(26, 3, 2),
		CFrame.new(origin + Vector3.new(0, 2, -12)),
		Color3.fromRGB(100, 66, 46),
		Enum.Material.Wood
	)
	counter.CanCollide = true
	makePart(
		model:WaitForChild("Structure"),
		"CounterTop",
		Vector3.new(28, 0.4, 2.6),
		CFrame.new(origin + Vector3.new(0, 3.7, -12)),
		Color3.fromRGB(60, 40, 30),
		Enum.Material.Wood
	)

	local menu = makePart(
		model:WaitForChild("Structure"),
		"MenuBoard",
		Vector3.new(18, 8, 0.3),
		CFrame.new(origin + Vector3.new(0, 9, -17.3)),
		Color3.fromRGB(26, 46, 38),
		Enum.Material.SmoothPlastic
	)
	local menuGui = Instance.new("SurfaceGui")
	menuGui.Face = Enum.NormalId.Back
	menuGui.CanvasSize = Vector2.new(700, 300)
	menuGui.Parent = menu

	makeLabel(
		menuGui,
		"MenuTitle",
		"MENU",
		Color3.fromRGB(255, 210, 150),
		UDim2.fromScale(0.9, 0.32),
		UDim2.fromScale(0.05, 0.08)
	)
	makeLabel(
		menuGui,
		"MenuSub",
		"Fresh from the garden · served all night",
		Color3.fromRGB(200, 220, 210),
		UDim2.fromScale(0.9, 0.18),
		UDim2.fromScale(0.05, 0.42)
	)
	makeLabel(
		menuGui,
		"MenuHint",
		"Ask the barista about the special",
		Color3.fromRGB(200, 220, 210),
		UDim2.fromScale(0.9, 0.16),
		UDim2.fromScale(0.05, 0.66)
	)

	local sign = makePart(
		model:WaitForChild("Structure"),
		"Sign",
		Vector3.new(20, 4, 0.4),
		CFrame.new(origin + Vector3.new(0, 13, 18.7)),
		Color3.fromRGB(42, 30, 24),
		Enum.Material.Wood
	)
	local signGui = Instance.new("SurfaceGui")
	signGui.Face = Enum.NormalId.Back
	signGui.CanvasSize = Vector2.new(800, 200)
	signGui.Parent = sign

	local signLabel = makeLabel(
		signGui,
		"Title",
		"The Lantern",
		Color3.fromRGB(255, 210, 150),
		UDim2.fromScale(0.9, 0.55),
		UDim2.fromScale(0.05, 0.08)
	)
	signLabel.Font = Enum.Font.GothamBlack

	local ownerLabel = makeLabel(
		signGui,
		"Owner",
		"For rent",
		Color3.fromRGB(210, 220, 230),
		UDim2.fromScale(0.9, 0.25),
		UDim2.fromScale(0.05, 0.65)
	)
	ownerLabel.Font = Enum.Font.Gotham

	for _, position in
		{
			Vector3.new(-18, 9, -12),
			Vector3.new(18, 9, -12),
			Vector3.new(-18, 9, 12),
			Vector3.new(18, 9, 12),
		}
	do
		local lantern = decoration(
			model:WaitForChild("Structure"),
			"Lantern",
			Vector3.new(1, 1.4, 1),
			CFrame.new(origin + position),
			Color3.fromRGB(255, 190, 100),
			Enum.Material.Neon
		)
		local light = Instance.new("PointLight")
		light.Color = Color3.fromRGB(255, 180, 100)
		light.Brightness = 1.6
		light.Range = 22
		light.Shadows = true
		light.Parent = lantern
	end

	plot.stations.Coffee = makeStation(plot, -9, "Coffee", Color3.fromRGB(80, 120, 150))
	plot.stations.Stove = makeStation(plot, 0, "Stove", Color3.fromRGB(150, 80, 70))
	plot.stations.Prep = makeStation(plot, 9, "Prep", Color3.fromRGB(90, 140, 90))

	for slotIndex = 1, 3 do
		CafeBuilder.addTable(plot, slotIndex)
	end

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "PlotSpawn"
	spawn.Anchored = true
	spawn.CanCollide = true
	spawn.Duration = 0
	spawn.Neutral = true
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.CFrame = CFrame.new(origin + Vector3.new(0, 1.05, 14))
	spawn.Color = Color3.fromRGB(255, 180, 92)
	spawn.Material = Enum.Material.Neon
	spawn.Transparency = 0.55
	spawn.Enabled = true
	spawn.Parent = model
	plot.spawn = spawn

	local function marker(name: string, localPosition: Vector3): Part
		local p = makePart(
			model:WaitForChild("Markers"),
			name,
			Vector3.new(2, 0.2, 2),
			CFrame.new(origin + localPosition),
			Color3.fromRGB(255, 255, 255),
			Enum.Material.SmoothPlastic
		)
		p.Transparency = 1
		p.CanCollide = false
		p.CanQuery = false
		return p
	end

	plot.customerSpawn = marker("CustomerSpawn", Vector3.new(0, 0.5, 27))
	plot.doorInside = marker("DoorInside", Vector3.new(0, 0.5, 14.5))
	plot.doorOutside = marker("DoorOutside", Vector3.new(0, 0.5, 26))

	plot.signLabel = signLabel
	plot.ownerLabel = ownerLabel

	return plot
end

function CafeBuilder.setOwnerSign(plot: Types.PlotRecord, ownerName: string)
	plot.ownerLabel.Text = ownerName ~= "" and ("Owner: " .. ownerName) or "For rent"
end

return CafeBuilder
