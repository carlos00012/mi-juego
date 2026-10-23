--!strict
-- Tienda de mejoras.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local Upgrades = require(Config:WaitForChild("Upgrades"))
local Types = require(Shared:WaitForChild("Types"))
local UpgradeUtil = require(Shared:WaitForChild("Util"):WaitForChild("UpgradeUtil"))

local Components = require(script.Parent:WaitForChild("Components"))
local Theme = require(script.Parent:WaitForChild("Theme"))

local Shop = {}
Shop.__index = Shop

type Card = {
	upgrade: Types.Upgrade,
	card: Frame,
	levelLabel: TextLabel,
	costLabel: TextLabel,
	button: TextButton,
}

function Shop.new(playerGui: PlayerGui, purchase: (string) -> (boolean, string))
	local self = setmetatable({}, Shop)
	self.purchase = purchase
	self.cards = {}
	self.profile = nil

	local overlay = Components.frame({
		Name = "ShopOverlay",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(5, 10, 18),
		BackgroundTransparency = 0.45,
		Visible = false,
		ZIndex = 50,
		Parent = playerGui,
	})
	overlay.Active = true
	self.overlay = overlay

	local panel = Components.frame({
		Name = "Panel",
		Size = UDim2.fromScale(0.9, 0.86),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.Colors.Panel,
		ZIndex = 51,
		Parent = overlay,
	})
	Components.corner(panel, 18)
	Components.stroke(panel, Theme.Colors.Accent, 2)

	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MaxSize = Vector2.new(640, 560)
	sizeConstraint.MinSize = Vector2.new(320, 300)
	sizeConstraint.Parent = panel

	local title = Components.label({
		Name = "Title",
		Size = UDim2.fromScale(0.55, 0.08),
		Position = UDim2.fromScale(0.05, 0.035),
		Font = Theme.FontBlack,
		Text = "Mejoras del café",
		TextColor3 = Theme.Colors.Accent,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 52,
		Parent = panel,
	})
	title.TextScaled = true

	local subtitle = Components.label({
		Name = "Subtitle",
		Size = UDim2.fromScale(0.6, 0.05),
		Position = UDim2.fromScale(0.05, 0.11),
		Font = Theme.Font,
		Text = "Gasta Ecto para hacer crecer The Lantern.",
		TextColor3 = Theme.Colors.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 52,
		Parent = panel,
	})
	subtitle.TextScaled = true

	self.ectoLabel = Components.label({
		Name = "Ecto",
		Size = UDim2.fromScale(0.25, 0.07),
		Position = UDim2.fromScale(0.55, 0.045),
		Font = Theme.FontBold,
		Text = "Ɛ 0",
		TextColor3 = Theme.Colors.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 52,
		Parent = panel,
	})

	local close = Components.button({
		Name = "Close",
		Size = UDim2.fromOffset(38, 38),
		Position = UDim2.new(1, -50, 0, 14),
		Text = "X",
		BackgroundColor3 = Theme.Colors.PanelDark,
		StrokeColor = Theme.Colors.Red,
		ZIndex = 53,
		Parent = panel,
	})
	close.Activated:Connect(function()
		self:close()
	end)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "Cards"
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.Size = UDim2.fromScale(0.9, 0.68)
	scroll.Position = UDim2.fromScale(0.05, 0.2)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Theme.Colors.Accent
	scroll.ZIndex = 52
	scroll.Parent = panel
	Components.list(scroll, Enum.FillDirection.Vertical, 10)

	for _, upgrade in Upgrades do
		local card = Components.frame({
			Name = upgrade.id,
			Size = UDim2.new(1, -10, 0, 96),
			BackgroundColor3 = Theme.Colors.PanelLight,
			ZIndex = 52,
			Parent = scroll,
		})
		Components.corner(card, 12)
		Components.stroke(card, Theme.Colors.PanelDark, 1)

		local dot = Components.frame({
			Name = "Dot",
			Size = UDim2.fromOffset(10, 10),
			Position = UDim2.fromOffset(16, 18),
			BackgroundColor3 = Theme.Colors.Accent,
			ZIndex = 53,
			Parent = card,
		})
		Components.corner(dot, 5)

		local name = Components.label({
			Name = "Name",
			Size = UDim2.fromScale(0.5, 0.28),
			Position = UDim2.fromOffset(34, 8),
			Font = Theme.FontBold,
			Text = upgrade.name,
			TextColor3 = Theme.Colors.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 53,
			Parent = card,
		})
		name.TextScaled = true

		local description = Components.label({
			Name = "Description",
			Size = UDim2.fromScale(0.62, 0.44),
			Position = UDim2.fromOffset(16, 36),
			Font = Theme.Font,
			Text = upgrade.description,
			TextColor3 = Theme.Colors.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			ZIndex = 53,
			Parent = card,
		})
		description.TextScaled = false
		description.TextSize = 14

		local levelLabel = Components.label({
			Name = "Level",
			Size = UDim2.fromScale(0.16, 0.2),
			Position = UDim2.fromScale(0.66, 0.14),
			Font = Theme.FontBold,
			Text = "Nv. 0/3",
			TextColor3 = Theme.Colors.Muted,
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 53,
			Parent = card,
		})
		levelLabel.TextScaled = true

		local costLabel = Components.label({
			Name = "Cost",
			Size = UDim2.fromScale(0.16, 0.22),
			Position = UDim2.fromScale(0.66, 0.36),
			Font = Theme.Font,
			Text = "Ɛ 0",
			TextColor3 = Theme.Colors.Accent,
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 53,
			Parent = card,
		})
		costLabel.TextScaled = true

		local button = Components.button({
			Name = "Buy",
			Size = UDim2.fromScale(0.26, 0.3),
			Position = UDim2.fromScale(0.7, 0.62),
			Text = "Comprar",
			Parent = card,
		})
		button.ZIndex = 54

		local record: Card = {
			upgrade = upgrade,
			card = card,
			levelLabel = levelLabel,
			costLabel = costLabel,
			button = button,
		}
		table.insert(self.cards, record)

		button.Activated:Connect(function()
			local profile = self.profile
			if not profile then
				return
			end
			local level = UpgradeUtil.getLevel(profile, upgrade.id)
			if level >= upgrade.maxLevel then
				return
			end

			button.Text = "..."
			task.spawn(function()
				self.purchase(upgrade.id)
				if self.profile then
					self:refresh(self.profile)
				end
			end)
		end)
	end

	return self
end

function Shop:refresh(profile: Types.Profile)
	self.profile = profile
	self.ectoLabel.Text = "Ɛ " .. Components.formatNumber(profile.ecto)

	for _, record in self.cards do
		local level = UpgradeUtil.getLevel(profile, record.upgrade.id)
		record.levelLabel.Text = string.format("Nv. %d/%d", level, record.upgrade.maxLevel)

		if level >= record.upgrade.maxLevel then
			record.costLabel.Text = "Máximo"
			record.button.Text = "MAX"
			record.button.BackgroundColor3 = Theme.Colors.PanelDark
		else
			local cost = UpgradeUtil.getCost(record.upgrade, level)
			record.costLabel.Text = "Ɛ " .. Components.formatNumber(cost)
			record.button.Text = profile.ecto >= cost and "Comprar" or "Faltan Ɛ"
			record.button.BackgroundColor3 = profile.ecto >= cost and Theme.Colors.PanelLight
				or Theme.Colors.PanelDark
		end
	end
end

function Shop:open(profile: Types.Profile)
	self:refresh(profile)
	self.overlay.Visible = true
end

function Shop:close()
	self.overlay.Visible = false
end

function Shop:toggle(profile: Types.Profile)
	if self.overlay.Visible then
		self:close()
	else
		self:open(profile)
	end
end

return Shop
