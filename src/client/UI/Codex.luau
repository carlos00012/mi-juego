--!strict
-- Códice de críptidos.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local Cryptids = require(Config:WaitForChild("Cryptids"))
local Recipes = require(Config:WaitForChild("Recipes"))
local Types = require(Shared:WaitForChild("Types"))

local Components = require(script.Parent:WaitForChild("Components"))
local Theme = require(script.Parent:WaitForChild("Theme"))

local Codex = {}
Codex.__index = Codex

type Card = {
	cryptid: Types.Cryptid,
	portrait: Frame,
	name: TextLabel,
	rarity: TextLabel,
	description: TextLabel,
	meta: TextLabel,
}

local recipeNames: { [string]: string } = {}
for _, recipe in Recipes do
	recipeNames[recipe.id] = recipe.name
end

function Codex.new(playerGui: PlayerGui)
	local self = setmetatable({}, Codex)
	self.cards = {}

	local overlay = Components.frame({
		Name = "CodexOverlay",
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
		Size = UDim2.fromScale(0.9, 0.84),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.Colors.Panel,
		ZIndex = 51,
		Parent = overlay,
	})
	Components.corner(panel, 18)
	Components.stroke(panel, Theme.Colors.Purple, 2)

	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MaxSize = Vector2.new(620, 540)
	sizeConstraint.MinSize = Vector2.new(320, 300)
	sizeConstraint.Parent = panel

	Components.label({
		Name = "Title",
		Size = UDim2.fromScale(0.5, 0.08),
		Position = UDim2.fromScale(0.05, 0.035),
		Font = Theme.FontBlack,
		Text = "Códice de críptidos",
		TextColor3 = Theme.Colors.Purple,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 52,
		Parent = panel,
	})

	self.progressLabel = Components.label({
		Name = "Progress",
		Size = UDim2.fromScale(0.3, 0.06),
		Position = UDim2.fromScale(0.05, 0.115),
		Font = Theme.Font,
		Text = "0 / 3 descubiertos",
		TextColor3 = Theme.Colors.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
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
	scroll.Size = UDim2.fromScale(0.9, 0.74)
	scroll.Position = UDim2.fromScale(0.05, 0.19)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Theme.Colors.Purple
	scroll.ZIndex = 52
	scroll.Parent = panel
	Components.list(scroll, Enum.FillDirection.Vertical, 10)

	for _, cryptid in Cryptids do
		local card = Components.frame({
			Name = cryptid.id,
			Size = UDim2.new(1, -10, 0, 124),
			BackgroundColor3 = Theme.Colors.PanelLight,
			ZIndex = 52,
			Parent = scroll,
		})
		Components.corner(card, 12)
		Components.stroke(card, Theme.Colors.PanelDark, 1)

		local portrait = Components.frame({
			Name = "Portrait",
			Size = UDim2.fromOffset(72, 72),
			Position = UDim2.fromOffset(16, 16),
			BackgroundColor3 = Theme.Colors.PanelDark,
			ZIndex = 53,
			Parent = card,
		})
		Components.corner(portrait, 36)
		Components.stroke(portrait, Theme.Colors.Muted, 2)

		local name = Components.label({
			Name = "Name",
			Size = UDim2.fromScale(0.4, 0.26),
			Position = UDim2.fromOffset(104, 10),
			Font = Theme.FontBlack,
			Text = "???",
			TextColor3 = Theme.Colors.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 53,
			Parent = card,
		})
		name.TextScaled = true

		local rarity = Components.label({
			Name = "Rarity",
			Size = UDim2.fromScale(0.3, 0.18),
			Position = UDim2.fromOffset(104, 38),
			Font = Theme.FontBold,
			Text = "Desconocido",
			TextColor3 = Theme.Colors.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 53,
			Parent = card,
		})
		rarity.TextScaled = true

		local description = Components.label({
			Name = "Description",
			Size = UDim2.fromScale(0.82, 0.34),
			Position = UDim2.fromOffset(104, 62),
			Font = Theme.Font,
			Text = "Sirve a este críptido para añadirlo al códice.",
			TextColor3 = Theme.Colors.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			ZIndex = 53,
			Parent = card,
		})
		description.TextScaled = false
		description.TextSize = 13

		local meta = Components.label({
			Name = "Meta",
			Size = UDim2.fromScale(0.82, 0.16),
			Position = UDim2.fromOffset(104, 100),
			Font = Theme.Font,
			Text = "",
			TextColor3 = Theme.Colors.Accent,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 53,
			Parent = card,
		})
		meta.TextScaled = false
		meta.TextSize = 13

		table.insert(self.cards, {
			cryptid = cryptid,
			portrait = portrait,
			name = name,
			rarity = rarity,
			description = description,
			meta = meta,
		})
	end

	return self
end

function Codex:refresh(profile: Types.Profile)
	local discovered = 0

	for _, record in self.cards do
		local count = profile.codex[record.cryptid.id] or 0
		local found = count > 0
		if found then
			discovered += 1
			record.portrait.BackgroundColor3 = record.cryptid.bodyColor
			record.name.Text = record.cryptid.name
			record.rarity.Text = record.cryptid.rarity
			record.description.Text = record.cryptid.description
			record.meta.Text = string.format(
				"Visto %d veces · Favorito: %s",
				count,
				recipeNames[record.cryptid.favoriteRecipe] or "???"
			)
			record.rarity.TextColor3 = record.cryptid.eyeColor
		else
			record.portrait.BackgroundColor3 = Theme.Colors.PanelDark
			record.name.Text = "???"
			record.rarity.Text = "Desconocido"
			record.rarity.TextColor3 = Theme.Colors.Muted
			record.description.Text = "Sirve a este críptido para añadirlo al códice."
			record.meta.Text = "Aún no lo has visto en The Lantern."
		end
	end

	self.progressLabel.Text = string.format("%d / %d descubiertos", discovered, #self.cards)
end

function Codex:open(profile: Types.Profile)
	self:refresh(profile)
	self.overlay.Visible = true
end

function Codex:close()
	self.overlay.Visible = false
end

function Codex:toggle(profile: Types.Profile)
	if self.overlay.Visible then
		self:close()
	else
		self:open(profile)
	end
end

return Codex
