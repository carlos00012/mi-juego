--!strict
-- Compra y aplica mejoras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local UpgradeUtil = require(Shared:WaitForChild("Util"):WaitForChild("UpgradeUtil"))

local DataService = require(script.Parent:WaitForChild("DataService"))
local PlotService = require(script.Parent:WaitForChild("PlotService"))
local RemoteService = require(script.Parent:WaitForChild("RemoteService"))
local SyncService = require(script.Parent:WaitForChild("SyncService"))

local UpgradeService = {}

local lastPurchase: { [number]: number } = {}

local function applyUpgrade(player: Player, upgradeId: string)
	if upgradeId == "extra_table" then
		local profile = DataService:getProfile(player)
		local plot = PlotService:getPlot(player)
		if profile and plot then
			PlotService:refreshTables(plot, profile.upgrades.extra_table or 0)
		end
	end
end

function UpgradeService:purchase(player: Player, upgradeId: any): (boolean, string)
	if type(upgradeId) ~= "string" then
		return false, "Mejora inválida."
	end

	local now = os.clock()
	local last = lastPurchase[player.UserId] or 0
	if now - last < 0.35 then
		return false, "Espera un momento."
	end
	lastPurchase[player.UserId] = now

	local upgrade = UpgradeUtil.get(upgradeId)
	if not upgrade then
		return false, "Esa mejora no existe."
	end

	local profile = DataService:getProfile(player)
	if not profile then
		return false, "Tu perfil todavía está cargando."
	end

	local plot = PlotService:getPlot(player)
	if not plot then
		return false, "No tienes una cafetería asignada."
	end

	local current = profile.upgrades[upgradeId] or 0
	if current >= upgrade.maxLevel then
		return false, "Ya está al nivel máximo."
	end

	local cost = UpgradeUtil.getCost(upgrade, current)
	if profile.ecto < cost then
		return false, `Necesitas Ɛ{cost} y tienes Ɛ{profile.ecto}.`
	end

	profile.ecto -= cost
	profile.upgrades[upgradeId] = current + 1
	DataService:updateLeaderstats(player)
	applyUpgrade(player, upgradeId)

	SyncService:push(player)
	SyncService:notify(player, `Mejora comprada: {upgrade.name}`, "success")

	task.spawn(function()
		DataService:save(player)
	end)

	return true, `{upgrade.name} mejorada.`
end

function UpgradeService:start()
	local remote = RemoteService.PurchaseUpgrade
	if remote then
		remote.OnServerInvoke = function(player: Player, upgradeId: any)
			return self:purchase(player, upgradeId)
		end
	end
end

return UpgradeService
