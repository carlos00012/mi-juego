--!strict
-- Paleta y tipografía de la interfaz.

local Theme = {
	Colors = {
		Background = Color3.fromRGB(20, 36, 58),
		Panel = Color3.fromRGB(30, 51, 80),
		PanelLight = Color3.fromRGB(42, 70, 105),
		PanelDark = Color3.fromRGB(14, 25, 40),
		Accent = Color3.fromRGB(255, 180, 92),
		Text = Color3.fromRGB(245, 233, 216),
		Muted = Color3.fromRGB(168, 184, 200),
		Green = Color3.fromRGB(110, 200, 140),
		Red = Color3.fromRGB(230, 110, 110),
		Blue = Color3.fromRGB(120, 170, 230),
		Purple = Color3.fromRGB(160, 130, 230),
	},
	Font = Enum.Font.Gotham,
	FontBold = Enum.Font.GothamBold,
	FontBlack = Enum.Font.GothamBlack,
}

return table.freeze(Theme)
