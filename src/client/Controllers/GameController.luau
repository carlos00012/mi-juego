--!strict
-- Conecta remotes, perfil y UI del cliente.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local Recipes = require(Config:WaitForChild("Recipes"))
local Types = require(Shared:WaitForChild("Types"))

local HUD = require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("HUD"))
local Shop = require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("Shop"))
local Codex = require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("Codex"))

local GameController = {}

local recipeNames: { [string]: string } = {}
for _, recipe in Recipes do
	recipeNames[recipe.id] = recipe.name
end

function GameController.start()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local remotes = ReplicatedStorage:WaitForChild("Remotes")
	local profileSync = remotes:WaitForChild("ProfileSync") :: RemoteEvent
	local notifyRemote = remotes:WaitForChild("Notify") :: RemoteEvent
	local purchaseRemote = remotes:WaitForChild("PurchaseUpgrade") :: RemoteFunction
	local requestRemote = remotes:WaitForChild("RequestProfile") :: RemoteFunction

	local hud = HUD.new(playerGui)
	local currentProfile: Types.Profile? = nil
	local shop
	local codex

	local function applyProfile(profile: Types.Profile)
		currentProfile = profile
		hud:setProfile(profile)
		shop:refresh(profile)
		codex:refresh(profile)
	end

	shop = Shop.new(playerGui, function(upgradeId: string): (boolean, string)
		local ok, message = purchaseRemote:InvokeServer(upgradeId)
		if not ok then
			hud:notify(message or "No se pudo comprar la mejora.", "error")
		end
		return ok, message
	end)

	codex = Codex.new(playerGui)

	hud.shopButton.Activated:Connect(function()
		if currentProfile then
			codex:close()
			shop:toggle(currentProfile)
		else
			hud:notify("Tu perfil todavía está cargando.", "info")
		end
	end)

	hud.codexButton.Activated:Connect(function()
		if currentProfile then
			shop:close()
			codex:toggle(currentProfile)
		else
			hud:notify("Tu perfil todavía está cargando.", "info")
		end
	end)

	profileSync.OnClientEvent:Connect(function(profile: Types.Profile)
		applyProfile(profile)
	end)

	notifyRemote.OnClientEvent:Connect(function(text: string, kind: string?)
		hud:notify(text, kind)
	end)

	local function updateCarry()
		local recipeId = player:GetAttribute("CarryingRecipeId")
		if type(recipeId) == "string" then
			hud:setCarrying(recipeNames[recipeId] or recipeId)
		else
			hud:setCarrying(nil)
		end
	end

	player:GetAttributeChangedSignal("CarryingRecipeId"):Connect(updateCarry)
	updateCarry()

	task.spawn(function()
		for _ = 1, 20 do
			local ok, profile = pcall(function()
				return requestRemote:InvokeServer()
			end)
			if ok and profile then
				applyProfile(profile :: Types.Profile)
				return
			end
			task.wait(0.5)
		end
	end)

	print(`[Cliente] {player.Name} conectado a Cryptid Café`)
end

return GameController
