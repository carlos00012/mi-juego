--!strict
-- Construye el mundo base: suelo, plaza central, spawn y ambiente.

local Lighting = game:GetService("Lighting")

local WorldBuilder = {}

local function part(props: { [string]: any }): Part
	local p = Instance.new("Part")
	p.Name = props.Name or "Part"
	p.Anchored = true
	p.CanCollide = props.CanCollide ~= false
	p.CanQuery = props.CanQuery ~= false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Size = props.Size or Vector3.new(4, 1, 4)
	p.CFrame = props.CFrame or CFrame.new()
	p.Color = props.Color or Color3.fromRGB(120, 120, 120)
	p.Material = props.Material or Enum.Material.SmoothPlastic
	p.Transparency = props.Transparency or 0
	p.Parent = props.Parent
	return p
end

local function makeTree(parent: Instance, position: Vector3, scale: number)
	local trunk = part({
		Name = "Trunk",
		Size = Vector3.new(2 * scale, 10 * scale, 2 * scale),
		CFrame = CFrame.new(position + Vector3.new(0, 5 * scale, 0)),
		Color = Color3.fromRGB(80, 55, 40),
		Material = Enum.Material.Wood,
		Parent = parent,
	})
	trunk.CanCollide = false

	local leaves = Instance.new("Part")
	leaves.Name = "Leaves"
	leaves.Shape = Enum.PartType.Ball
	leaves.Size = Vector3.new(11 * scale, 9 * scale, 11 * scale)
	leaves.CFrame = CFrame.new(position + Vector3.new(0, 12 * scale, 0))
	leaves.Color = Color3.fromRGB(48, 92, 64)
	leaves.Material = Enum.Material.Grass
	leaves.Anchored = true
	leaves.CanCollide = false
	leaves.Parent = parent
end

function WorldBuilder.build()
	local world = Instance.new("Folder")
	world.Name = "World"
	world.Parent = workspace

	part({
		Name = "Ground",
		Size = Vector3.new(600, 1, 600),
		CFrame = CFrame.new(0, -0.5, 0),
		Color = Color3.fromRGB(38, 62, 45),
		Material = Enum.Material.Grass,
		Parent = world,
	})

	part({
		Name = "Plaza",
		Size = Vector3.new(78, 1, 78),
		CFrame = CFrame.new(0, 0.05, 0),
		Color = Color3.fromRGB(82, 88, 96),
		Material = Enum.Material.Cobblestone,
		Parent = world,
	})

	local spawn = workspace:FindFirstChild("SpawnLocation")
	if spawn and spawn:IsA("SpawnLocation") then
		spawn.Name = "LobbySpawn"
	else
		spawn = Instance.new("SpawnLocation")
		spawn.Name = "LobbySpawn"
		spawn.Parent = world
	end
	spawn.Anchored = true
	spawn.CanCollide = true
	spawn.Duration = 0
	spawn.Neutral = true
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.CFrame = CFrame.new(0, 1.05, 0)
	spawn.Color = Color3.fromRGB(255, 180, 92)
	spawn.Material = Enum.Material.Neon
	spawn.Transparency = 0.35

	local arch = Instance.new("Folder")
	arch.Name = "Arch"
	arch.Parent = world

	for _, x in { -10, 10 } do
		part({
			Name = "Post",
			Size = Vector3.new(1.5, 12, 1.5),
			CFrame = CFrame.new(x, 6, -18),
			Color = Color3.fromRGB(80, 55, 40),
			Material = Enum.Material.Wood,
			Parent = arch,
		})
	end

	local beam = part({
		Name = "Beam",
		Size = Vector3.new(22, 2.5, 1.5),
		CFrame = CFrame.new(0, 12.5, -18),
		Color = Color3.fromRGB(80, 55, 40),
		Material = Enum.Material.Wood,
		Parent = arch,
	})

	local gui = Instance.new("SurfaceGui")
	gui.Name = "SignGui"
	gui.Face = Enum.NormalId.Back
	gui.CanvasSize = Vector2.new(800, 200)
	gui.Parent = beam

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1, 0.6)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 220, 160)
	title.Text = "MISTWOOD"
	title.Parent = gui

	local subtitle = Instance.new("TextLabel")
	subtitle.Position = UDim2.fromScale(0, 0.6)
	subtitle.Size = UDim2.fromScale(1, 0.4)
	subtitle.BackgroundTransparency = 1
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextScaled = true
	subtitle.TextColor3 = Color3.fromRGB(210, 220, 230)
	subtitle.Text = "The last café before the veil"
	subtitle.Parent = gui

	for i = 1, 10 do
		local angle = (i / 10) * math.pi * 2
		local radius = 48
		local position = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
		makeTree(world, position, 0.8 + (i % 3) * 0.15)
	end

	Lighting.ClockTime = 0
	Lighting.Brightness = 1.4
	Lighting.Ambient = Color3.fromRGB(28, 36, 52)
	Lighting.OutdoorAmbient = Color3.fromRGB(40, 52, 72)
	Lighting.FogEnd = 520
	Lighting.FogColor = Color3.fromRGB(18, 28, 44)
	Lighting.EnvironmentDiffuseScale = 0.35
	Lighting.EnvironmentSpecularScale = 0.2

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if not atmosphere then
		atmosphere = Instance.new("Atmosphere")
	end
	atmosphere.Name = "Mist"
	atmosphere.Density = 0.32
	atmosphere.Haze = 1.8
	atmosphere.Glare = 0
	atmosphere.Color = Color3.fromRGB(180, 200, 220)
	atmosphere.Decay = Color3.fromRGB(90, 110, 140)
	atmosphere.Parent = Lighting

	local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
	if not bloom then
		bloom = Instance.new("BloomEffect")
	end
	bloom.Name = "LanternBloom"
	bloom.Intensity = 0.5
	bloom.Size = 18
	bloom.Threshold = 1.6
	bloom.Parent = Lighting

	print("[Mundo] Plaza de Mistwood construida")
end

return WorldBuilder
