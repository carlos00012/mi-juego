--!strict
-- Críptidos del MVP.

local Types = require(script.Parent.Parent:WaitForChild("Types"))

local Cryptids: { Types.Cryptid } = {
	{
		id = "bigfoot",
		name = "Bigfoot",
		rarity = "Common",
		weight = 45,
		favoriteRecipe = "forest_pancakes",
		patienceMultiplier = 1.1,
		payoutMultiplier = 1.0,
		bodyColor = Color3.fromRGB(92, 64, 45),
		eyeColor = Color3.fromRGB(255, 190, 90),
		shape = "tall",
		description = "El vecino más tranquilo de Mistwood. Paga puntual y deja propina si hay panqueques.",
	},
	{
		id = "jackalope",
		name = "Jackalope",
		rarity = "Uncommon",
		weight = 35,
		favoriteRecipe = "carrot_cake",
		patienceMultiplier = 1.0,
		payoutMultiplier = 1.05,
		bodyColor = Color3.fromRGB(200, 160, 110),
		eyeColor = Color3.fromRGB(255, 120, 170),
		shape = "small",
		description = "Presume de cuernos en cada foto. Si le sirves zanahoria, se queda a charlar.",
	},
	{
		id = "mothman",
		name = "Mothman",
		rarity = "Rare",
		weight = 20,
		favoriteRecipe = "luna_latte",
		patienceMultiplier = 0.9,
		payoutMultiplier = 1.3,
		bodyColor = Color3.fromRGB(70, 70, 85),
		eyeColor = Color3.fromRGB(255, 70, 70),
		shape = "moth",
		description = "Aparece antes de las malas noticias. Últimamente solo trae preguntas sobre Mabel.",
	},
}

return table.freeze(Cryptids)
