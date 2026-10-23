--!strict
-- HUD principal: economía, objetivo, avisos y estado del plato.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local GameConfig = require(Config:WaitForChild("GameConfig"))
local Types = require(Shared:WaitForChild("Types"))
local UpgradeUtil = require(Shared:WaitForChild("Util"):WaitForChild("UpgradeUtil"))

local Components = require(script.Parent:WaitForChild("Components"))
local Theme = require(script.Parent:WaitForChild("Theme"))

local HUD = {}
HUD.__index = HUD

function HUD.new(playerGui: PlayerGui)
	local self = setmetatable({}, HUD)

	local gui = Instance.new("ScreenGui")
	gui.Name = "CryptidCafeHUD"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = playerGui
	self.gui = gui
	self.toasts = {}

	local stats = Components.frame({
		Name = "Stats",
		Size = UDim2.fromOffset(260, 92),
		Position = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Theme.Colors.Panel,
		Parent = gui,
	})
	Components.corner(stats, 14)
	Components.stroke(stats, Theme.Colors.Accent, 1)

	self.ectoLabel = Components.label({
		Name = "Ecto",
		Size = UDim2.fromScale(0.58, 0.48),
		Position = UDim2.fromScale(0.05, 0.06),
		Font = Theme.FontBlack,
		Text = "Ɛ 0",
		TextColor3 = Theme.Colors.Accent,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = stats,
	})

	self.levelLabel = Components.label({
		Name = "Level",
		Size = UDim2.fromScale(0.34, 0.32),
		Position = UDim2.fromScale(0.62, 0.12),
		Font = Theme.FontBold,
		Text = "Level 1",
		TextColor3 = Theme.Colors.Muted,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = stats,
	})

	self.xpText = Components.label({
		Name = "XpText",
		Size = UDim2.fromScale(0.9, 0.2),
		Position = UDim2.fromScale(0.05, 0.62),
		Font = Theme.Font,
		Text = "0 / 100 XP",
		TextColor3 = Theme.Colors.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = stats,
	})

	local _, xpFill = Components.bar(
		stats,
		UDim2.fromScale(0.9, 0.1),
		UDim2.fromScale(0.05, 0.84),
		Theme.Colors.Green
	)
	self.xpFill = xpFill

	local objective = Components.frame({
		Name = "Objective",
		Size = UDim2.fromOffset(430, 48),
		Position = UDim2.new(0.5, 0, 0, 116),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Theme.Colors.Panel,
		Parent = gui,
	})
	Components.corner(objective, 12)
	Components.stroke(objective, Theme.Colors.Purple, 1)

	Components.label({
		Name = "Tag",
		Size = UDim2.fromScale(0.22, 0.8),
		Position = UDim2.fromScale(0.03, 0.1),
		Font = Theme.FontBold,
		Text = "OBJETIVO",
		TextColor3 = Theme.Colors.Purple,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = objective,
	})

	self.objectiveLabel = Components.label({
		Name = "Text",
		Size = UDim2.fromScale(0.7, 0.8),
		Position = UDim2.fromScale(0.27, 0.1),
		Font = Theme.Font,
		Text = "Sirve a tu primer cliente",
		TextColor3 = Theme.Colors.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = objective,
	})

	self.shopButton = Components.button({
		Name = "ShopButton",
		Size = UDim2.fromOffset(108, 44),
		Position = UDim2.new(1, -132, 0, 16),
		Text = "Mejoras",
		Parent = gui,
	})

	self.codexButton = Components.button({
		Name = "CodexButton",
		Size = UDim2.fromOffset(108, 44),
		Position = UDim2.new(1, -132, 0, 68),
		Text = "Códice",
		BackgroundColor3 = Theme.Colors.Panel,
		Parent = gui,
	})

	self.carry = Components.frame({
		Name = "Carry",
		Size = UDim2.fromOffset(330, 44),
		Position = UDim2.new(0.5, 0, 1, -24),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Theme.Colors.PanelDark,
		Visible = false,
		Parent = gui,
	})
	Components.corner(self.carry, 12)
	Components.stroke(self.carry, Theme.Colors.Accent, 1)
	self.carryLabel = Components.label({
		Name = "Text",
		Size = UDim2.fromScale(0.92, 0.8),
		Position = UDim2.fromScale(0.04, 0.1),
		Font = Theme.FontBold,
		Text = "Llevando: ...",
		TextColor3 = Theme.Colors.Accent,
		Parent = self.carry,
	})

	local toastContainer = Components.frame({
		Name = "Toasts",
		Size = UDim2.fromOffset(340, 260),
		Position = UDim2.new(0, 16, 1, -16),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Parent = gui,
	})
	local toastLayout = Components.list(toastContainer, Enum.FillDirection.Vertical, 6)
	toastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	self.toastContainer = toastContainer

	return self
end

local function objectiveFor(profile: Types.Profile): string
	local stats = profile.stats
	local served = stats.customersServed or 0
	if served < 1 then
		return "Sirve a tu primer cliente (0/1)"
	end
	if UpgradeUtil.getTotalLevels(profile) == 0 then
		return "Compra tu primera mejora"
	end
	if served < 5 then
		return string.format("Sirve a 5 clientes (%d/5)", served)
	end
	if (profile.codex.mothman or 0) == 0 then
		return "Descubre a Mothman"
	end
	return "Juego libre: sigue sirviendo y mejorando"
end

function HUD:setProfile(profile: Types.Profile)
	self.profile = profile
	self.ectoLabel.Text = "Ɛ " .. Components.formatNumber(profile.ecto)
	self.levelLabel.Text = "Level " .. profile.level

	local needed = GameConfig.getXpForLevel(profile.level)
	self.xpText.Text = string.format("%d / %d XP", profile.xp, needed)
	self.xpFill.Size = UDim2.fromScale(math.clamp(profile.xp / needed, 0, 1), 1)
	self.objectiveLabel.Text = objectiveFor(profile)
end

function HUD:setCarrying(recipeName: string?)
	if recipeName then
		self.carry.Visible = true
		self.carryLabel.Text = "Llevando: " .. recipeName
	else
		self.carry.Visible = false
	end
end

function HUD:notify(text: string, kind: string?)
	local color = Theme.Colors.Accent
	if kind == "success" then
		color = Theme.Colors.Green
	elseif kind == "error" then
		color = Theme.Colors.Red
	elseif kind == "codex" then
		color = Theme.Colors.Purple
	elseif kind == "info" then
		color = Theme.Colors.Blue
	end

	local toast = Components.frame({
		Name = "Toast",
		Size = UDim2.fromOffset(340, 44),
		BackgroundColor3 = Theme.Colors.Panel,
		Parent = self.toastContainer,
	})
	Components.corner(toast, 10)
	Components.stroke(toast, color, 1)

	local accent = Components.frame({
		Name = "Accent",
		Size = UDim2.new(0, 6, 1, -12),
		Position = UDim2.fromOffset(6, 6),
		BackgroundColor3 = color,
		Parent = toast,
	})
	Components.corner(accent, 3)

	local label = Components.label({
		Name = "Text",
		Size = UDim2.new(1, -28, 1, -8),
		Position = UDim2.fromOffset(20, 4),
		Font = Theme.Font,
		Text = text,
		TextColor3 = Theme.Colors.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = toast,
	})
	label.TextScaled = false
	label.TextSize = 16

	table.insert(self.toasts, toast)
	if #self.toasts > 5 then
		local oldest = table.remove(self.toasts, 1)
		if oldest then
			oldest:Destroy()
		end
	end

	task.delay(3.5, function()
		if not toast.Parent then
			return
		end
		local tween = TweenService:Create(toast, TweenInfo.new(0.35), {
			BackgroundTransparency = 1,
		})
		tween:Play()
		local textTween = TweenService:Create(label, TweenInfo.new(0.35), {
			TextTransparency = 1,
		})
		textTween:Play()
		tween.Completed:Once(function()
			toast:Destroy()
		end)
	end)
end

function HUD:destroy()
	self.gui:Destroy()
end

return HUD
