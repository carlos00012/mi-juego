--!strict
-- Asigna parcelas a jugadores y mantiene las mesas según las mejoras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local GameConfig = require(Config:WaitForChild("GameConfig"))
local Types = require(Shared:WaitForChild("Types"))

local CafeBuilder = require(script.Parent.Parent:WaitForChild("World"):WaitForChild("CafeBuilder"))

local PlotService = {}

local plots: { [number]: Types.PlotRecord } = {}
local playerPlot: { [number]: Types.PlotRecord } = {}

function PlotService:start()
	for index, origin in GameConfig.PlotPositions do
		local plot = CafeBuilder.build(index, origin)
		plots[index] = plot
	end
	print(`[Parcelas] ${#GameConfig.PlotPositions} cafeterías construidas`)
end

function PlotService:getPlot(player: Player): Types.PlotRecord?
	return playerPlot[player.UserId]
end

function PlotService:getPlotByIndex(index: number): Types.PlotRecord?
	return plots[index]
end

function PlotService:getAllPlots(): { [number]: Types.PlotRecord }
	return plots
end

function PlotService:isOwner(player: Player, plot: Types.PlotRecord): boolean
	return plot.ownerUserId == player.UserId
end

local function setStationPrompts(plot: Types.PlotRecord, enabled: boolean)
	for _, station in plot.stations do
		local prompt = station:FindFirstChild("CookPrompt")
		if prompt and prompt:IsA("ProximityPrompt") then
			prompt.Enabled = enabled
		end
	end
end

function PlotService:refreshTables(plot: Types.PlotRecord, extraLevel: number)
	local desired = 3 + math.clamp(extraLevel, 0, 3)
	local current = #plot.tables

	while current < desired do
		local record = CafeBuilder.addTable(plot, current + 1)
		if not record then
			break
		end
		current += 1
	end

	while current > desired and current > 3 do
		local record = table.remove(plot.tables)
		if record then
			record.seat:SetAttribute("OccupiedBy", nil)
			record.model:Destroy()
		end
		current -= 1
	end
end

function PlotService:assign(player: Player, profile: Types.Profile): Types.PlotRecord?
	if playerPlot[player.UserId] then
		return playerPlot[player.UserId]
	end

	local chosen: Types.PlotRecord? = nil
	for index = 1, #GameConfig.PlotPositions do
		local plot = plots[index]
		if plot and plot.ownerUserId == 0 then
			chosen = plot
			break
		end
	end

	if not chosen then
		return nil
	end

	chosen.ownerUserId = player.UserId
	chosen.ownerName = player.DisplayName
	chosen.spawn.Enabled = true
	CafeBuilder.setOwnerSign(chosen, player.DisplayName)
	setStationPrompts(chosen, true)
	self:refreshTables(chosen, profile.upgrades.extra_table or 0)

	playerPlot[player.UserId] = chosen
	return chosen
end

function PlotService:release(player: Player)
	local plot = playerPlot[player.UserId]
	if not plot then
		return
	end

	playerPlot[player.UserId] = nil
	plot.ownerUserId = 0
	plot.ownerName = ""
	plot.spawn.Enabled = false
	CafeBuilder.setOwnerSign(plot, "")
	setStationPrompts(plot, false)
	self:refreshTables(plot, 0)
end

return PlotService
