-- Arranca el lugar en modo Run de Studio y comprueba que el servidor construye el mundo.
-- Ejecutar con run-in-roblox. No guarda cambios en el lugar.

local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")

local messages = {}
local connection = LogService.MessageOut:Connect(function(message, messageType)
	table.insert(messages, string.format("[%s] %s", tostring(messageType), tostring(message)))
end)

RunService:Run()
task.wait(6)

local plots = workspace:FindFirstChild("Plots")
local world = workspace:FindFirstChild("World")
local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")

assert(world, "No se creó el mundo")
assert(plots, "No se crearon las parcelas")
assert(#plots:GetChildren() == 6, "Se esperaban 6 parcelas")
assert(remotes, "No se crearon los remotes")

local plot1 = plots:FindFirstChild("Plot_1")
assert(plot1, "Falta Plot_1")
assert(plot1:FindFirstChild("Stations"), "Falta el folder de estaciones")
assert(plot1:FindFirstChild("Tables"), "Falta el folder de mesas")
assert(plot1:FindFirstChild("Customers"), "Falta el folder de clientes")

RunService:Stop()
connection:Disconnect()

for _, message in messages do
	print("LOG " .. message)
end
print("RUN_SMOKE_OK")
