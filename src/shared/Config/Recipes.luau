--!strict
-- Recetas del MVP. `menuLevel` indica el nivel de Menu Board necesario.

local Types = require(script.Parent.Parent:WaitForChild("Types"))

local Recipes: { Types.Recipe } = {
	{
		id = "luna_latte",
		name = "Luna Latte",
		station = "Coffee",
		duration = 3,
		value = 28,
		xp = 12,
		menuLevel = 0,
		color = Color3.fromRGB(180, 215, 255),
		description = "Espuma de luna, canela y un toque de magia.",
	},
	{
		id = "forest_pancakes",
		name = "Forest Floor Pancakes",
		station = "Stove",
		duration = 4,
		value = 32,
		xp = 14,
		menuLevel = 0,
		color = Color3.fromRGB(190, 140, 80),
		description = "Torre de panqueques con sirope de musgo dulce.",
	},
	{
		id = "carrot_cake",
		name = "Carrot Cloud Cake",
		station = "Prep",
		duration = 4,
		value = 30,
		xp = 13,
		menuLevel = 0,
		color = Color3.fromRGB(235, 160, 90),
		description = "Bizcocho esponjoso que flota un segundo al servirlo.",
	},
	{
		id = "berry_smoothie",
		name = "Berry Beast Smoothie",
		station = "Prep",
		duration = 3,
		value = 38,
		xp = 16,
		menuLevel = 1,
		color = Color3.fromRGB(220, 100, 150),
		description = "Bayas del bosque, yogur y un gruñido de fresa.",
	},
	{
		id = "cosmic_cocoa",
		name = "Cosmic Cocoa",
		station = "Coffee",
		duration = 4,
		value = 42,
		xp = 18,
		menuLevel = 2,
		color = Color3.fromRGB(150, 110, 220),
		description = "Chocolate caliente con estrellas de marshmallow.",
	},
	{
		id = "mushroom_melt",
		name = "Mushroom Melt",
		station = "Stove",
		duration = 5,
		value = 46,
		xp = 20,
		menuLevel = 3,
		color = Color3.fromRGB(205, 175, 130),
		description = "Sándwich fundido con setas luminosas del jardín.",
	},
}

return table.freeze(Recipes)
