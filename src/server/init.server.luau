--!strict
-- Punto de entrada del servidor.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local GameConfig = require(Config:WaitForChild("GameConfig"))

local Services = script:WaitForChild("Services")
local World = script:WaitForChild("World")

local CustomerService = require(Services:WaitForChild("CustomerService"))
local DataService = require(Services:WaitForChild("DataService"))
local PlotService = require(Services:WaitForChild("PlotService"))
local RemoteService = require(Services:WaitForChild("RemoteService"))
local SyncService = require(Services:WaitForChild("SyncService"))
local UpgradeService = require(Services:WaitForChild("UpgradeService"))
local WorldBuilder = require(World:WaitForChild("WorldBuilder"))

local function setWalkSpeed(character: Model)
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	humanoid.WalkSpeed = GameConfig.WalkSpeed
end

local function onCharacterAdded(character: Model)
	setWalkSpeed(character)
end

local function onPlayerAdded(player: Player)
	local profile = DataService:load(player)
	if not profile or not player.Parent then
		return
	end

	local plot = PlotService:assign(player, profile)
	if plot then
		player.RespawnLocation = plot.spawn
		if player.Character then
			player.Character:PivotTo(plot.spawn.CFrame + Vector3.new(0, 3, 0))
		end
	else
		SyncService:notify(player, "No hay cafeterías libres en este servidor.", "error")
	end

	if player.Character then
		setWalkSpeed(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)

	SyncService:push(player)
	SyncService:notify(
		player,
		"Bienvenido a The Lantern. Sirve a los críptidos y haz crecer tu café.",
		"info"
	)
end

WorldBuilder.build()
RemoteService:start()
DataService:start()
PlotService:start()
SyncService:start()
CustomerService:start()
UpgradeService:start()

Players.PlayerAdded:Connect(function(player: Player)
	task.spawn(onPlayerAdded, player)
end)

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end

Players.PlayerRemoving:Connect(function(player: Player)
	local plot = PlotService:getPlot(player)
	if plot then
		CustomerService:clearPlot(plot)
	end
	DataService:save(player)
	PlotService:release(player)
	DataService:unload(player)
end)

print(`[Servidor] {GameConfig.GameName} iniciado`)
