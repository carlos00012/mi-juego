-- Prueba el constructor de modelos de cliente y el movimiento por WeldConstraint.
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local world = ServerScriptService:WaitForChild("Server"):WaitForChild("World")
local CustomerModelBuilder = require(world:WaitForChild("CustomerModelBuilder"))
local Cryptids = require(
	ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Cryptids")
)

for _, cryptid in Cryptids do
	local model, root, head = CustomerModelBuilder.build(cryptid, Vector3.new(0, 0.5, 0))
	model.Parent = workspace

	local body = model:FindFirstChild("Body")
	assert(body, "Falta Body")
	assert(model.PrimaryPart == root, "El PrimaryPart no es Root")
	assert(body.Anchored == false, "Body debería ser dinámico")
	assert(root.Anchored == true, "Root debería estar anclado")
	assert(#model:GetChildren() >= 5, "Faltan partes del cliente")

	local startBody = body.Position
	local target = CFrame.new(0, 0.5, 10)
	local tween = TweenService:Create(root, TweenInfo.new(0.5), { CFrame = target })
	tween:Play()
	tween.Completed:Wait()
	task.wait(0.2)

	local moved = (body.Position - startBody).Magnitude
	print("MODEL", cryptid.id, "BODY_MOVED", moved, "ROOT", root.Position, "HEAD", head.Position)
	assert(moved > 8, "Las partes soldadas no siguieron al Root")
	assert(math.abs(root.Position.Z - 10) < 1, "El Root no llegó al destino")

	model:Destroy()
end

print("CUSTOMER_MODEL_SMOKE_OK")
