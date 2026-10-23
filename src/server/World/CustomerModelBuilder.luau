--!strict
-- Construye el modelo placeholder de un críptido cliente.
-- El Root está anclado y el resto de partes se sueldan a él con WeldConstraint.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Types = require(Shared:WaitForChild("Types"))

local CustomerModelBuilder = {}

function CustomerModelBuilder.build(cryptid: Types.Cryptid, position: Vector3): (Model, Part, Part)
	local model = Instance.new("Model")
	model.Name = "Customer_" .. cryptid.id

	local root = Instance.new("Part")
	root.Name = "Root"
	root.Size = Vector3.new(0.2, 0.2, 0.2)
	root.Transparency = 1
	root.Anchored = true
	root.CanCollide = false
	root.CanQuery = false
	root.CFrame = CFrame.new()
	root.Parent = model
	model.PrimaryPart = root

	local bodyHeight = 3.2
	local bodyWidth = 2.4
	local headSize = 2.2

	if cryptid.shape == "tall" then
		bodyHeight = 4
		bodyWidth = 2.8
		headSize = 2.4
	elseif cryptid.shape == "small" then
		bodyHeight = 2.6
		bodyWidth = 2.2
		headSize = 2.0
	end

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(bodyWidth, bodyHeight, bodyWidth)
	body.CFrame = CFrame.new(0, bodyHeight / 2, 0)
	body.Color = cryptid.bodyColor
	body.Material = Enum.Material.SmoothPlastic
	body.Anchored = false
	body.CanCollide = false
	body.Massless = true
	body.Parent = model

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(headSize, headSize, headSize)
	head.CFrame = CFrame.new(0, bodyHeight + headSize / 2 - 0.2, 0)
	head.Color = cryptid.bodyColor:Lerp(Color3.new(1, 1, 1), 0.08)
	head.Material = Enum.Material.SmoothPlastic
	head.Anchored = false
	head.CanCollide = false
	head.Massless = true
	head.Parent = model

	local function weld(part: BasePart)
		part.Anchored = false
		part.CanCollide = false
		part.Massless = true
		local constraint = Instance.new("WeldConstraint")
		constraint.Part0 = root
		constraint.Part1 = part
		constraint.Parent = root
	end

	weld(body)
	weld(head)

	for _, offsetX in { -0.45, 0.45 } do
		local eye = Instance.new("Part")
		eye.Name = "Eye"
		eye.Size = Vector3.new(0.28, 0.28, 0.12)
		eye.CFrame = head.CFrame * CFrame.new(offsetX, 0.18, -headSize / 2 - 0.06)
		eye.Color = cryptid.eyeColor
		eye.Material = Enum.Material.Neon
		eye.Parent = model
		weld(eye)
	end

	if cryptid.shape == "tall" then
		for _, offsetX in { -0.8, 0.8 } do
			local ear = Instance.new("Part")
			ear.Name = "Ear"
			ear.Size = Vector3.new(0.35, 1.1, 0.35)
			ear.CFrame = head.CFrame * CFrame.new(offsetX, headSize / 2, 0)
			ear.Color = cryptid.bodyColor
			ear.Material = Enum.Material.SmoothPlastic
			ear.Parent = model
			weld(ear)
		end
	elseif cryptid.shape == "small" then
		for _, offsetX in { -0.55, 0.55 } do
			local antler = Instance.new("Part")
			antler.Name = "Antler"
			antler.Size = Vector3.new(0.2, 1.5, 0.2)
			antler.CFrame = head.CFrame
				* CFrame.new(offsetX, headSize / 2 + 0.5, 0)
				* CFrame.Angles(0, 0, offsetX > 0 and -0.3 or 0.3)
			antler.Color = Color3.fromRGB(230, 210, 170)
			antler.Material = Enum.Material.SmoothPlastic
			antler.Parent = model
			weld(antler)
		end
	elseif cryptid.shape == "moth" then
		for _, offsetX in { -1.8, 1.8 } do
			local wing = Instance.new("Part")
			wing.Name = "Wing"
			wing.Size = Vector3.new(0.3, 3.2, 4.4)
			wing.CFrame = head.CFrame * CFrame.new(offsetX, -0.4, 0.5)
			wing.Color = cryptid.bodyColor
			wing.Material = Enum.Material.SmoothPlastic
			wing.Transparency = 0.15
			wing.Parent = model
			weld(wing)
		end
	end

	model:PivotTo(CFrame.new(position))
	return model, root, head
end

return CustomerModelBuilder
