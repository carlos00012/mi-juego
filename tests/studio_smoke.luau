-- Smoke test para ejecutar en Roblox Studio con run-in-roblox.
-- No forma parte del lugar: comprueba que los módulos cargan y que el mundo se construye.

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local server = ServerScriptService:WaitForChild("Server")
local services = server:WaitForChild("Services")
local world = server:WaitForChild("World")
local shared = ReplicatedStorage:WaitForChild("Shared")
local config = shared:WaitForChild("Config")

local WorldBuilder = require(world:WaitForChild("WorldBuilder"))
local CafeBuilder = require(world:WaitForChild("CafeBuilder"))
local PlotService = require(services:WaitForChild("PlotService"))
local DataService = require(services:WaitForChild("DataService"))
local RemoteService = require(services:WaitForChild("RemoteService"))
local SyncService = require(services:WaitForChild("SyncService"))
local CustomerService = require(services:WaitForChild("CustomerService"))
local UpgradeService = require(services:WaitForChild("UpgradeService"))

local Recipes = require(config:WaitForChild("Recipes"))
local Cryptids = require(config:WaitForChild("Cryptids"))
local Upgrades = require(config:WaitForChild("Upgrades"))
local UpgradeUtil = require(shared:WaitForChild("Util"):WaitForChild("UpgradeUtil"))

assert(#Recipes == 6, "Se esperaban 6 recetas")
assert(#Cryptids == 3, "Se esperaban 3 críptidos")
assert(#Upgrades == 6, "Se esperaban 6 mejoras")
assert(UpgradeUtil.getCost(Upgrades[1], 0) > 0, "El coste debe ser positivo")

WorldBuilder.build()
PlotService:start()

local plot = PlotService:getPlotByIndex(1)
assert(plot, "No se construyó la parcela 1")
assert(plot.spawn, "Falta el spawn de la parcela")
assert(plot.stations.Coffee, "Falta la estación de café")
assert(plot.stations.Stove, "Falta la estufa")
assert(plot.stations.Prep, "Falta la estación de preparación")
assert(#plot.tables == 3, "La parcela debe empezar con 3 mesas")
assert(plot.ownerLabel.Text == "For rent", "El cartel debe indicar que está libre")

local fakePlayer = {
	UserId = 999,
	DisplayName = "Smoke Tester",
	Parent = game,
}
local fakeProfile = {
	upgrades = { extra_table = 2 },
	ecto = 100,
	xp = 0,
	level = 1,
	codex = {},
	stats = {},
	version = 1,
	lastSeen = 0,
}

local assigned = PlotService:assign(fakePlayer, fakeProfile)
assert(assigned == plot, "La asignación devolvió otra parcela")
assert(plot.ownerUserId == 999, "La parcela no tiene dueño")
assert(plot.spawn.Enabled == true, "El spawn debería estar activo")
assert(#plot.tables == 5, "La mejora de mesas no se aplicó")
local coffeePrompt = plot.stations.Coffee:FindFirstChild("CookPrompt")
assert(coffeePrompt and coffeePrompt.Enabled == true, "El prompt de café debería estar activo")

PlotService:refreshTables(plot, 0)
assert(#plot.tables == 3, "Las mesas extra no se retiraron")

CustomerService:clearPlot(plot)
PlotService:release(fakePlayer)
assert(plot.ownerUserId == 0, "La parcela no se liberó")
assert(coffeePrompt.Enabled == false, "El prompt debería desactivarse al liberar")

RemoteService:start()
assert(ReplicatedStorage:FindFirstChild("Remotes"), "No se creó la carpeta Remotes")
assert(RemoteService.ProfileSync, "Falta ProfileSync")
assert(RemoteService.Notify, "Falta Notify")
assert(RemoteService.PurchaseUpgrade, "Falta PurchaseUpgrade")
assert(RemoteService.RequestProfile, "Falta RequestProfile")

SyncService:start()
UpgradeService:start()

assert(DataService, "DataService no cargó")
print("SMOKE_OK")
