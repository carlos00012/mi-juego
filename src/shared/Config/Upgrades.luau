--!strict
-- Mejoras del MVP.

local Types = require(script.Parent.Parent:WaitForChild("Types"))

local Upgrades: { Types.Upgrade } = {
	{
		id = "extra_table",
		name = "Extra Table",
		description = "Añade otra mesa y un asiento más al café.",
		maxLevel = 3,
		baseCost = 150,
		costMultiplier = 2.5,
		effect = "table",
	},
	{
		id = "better_stove",
		name = "Better Stove",
		description = "Cocina un 15% más rápido en la estufa.",
		maxLevel = 3,
		baseCost = 120,
		costMultiplier = 2.4,
		effect = "stove",
	},
	{
		id = "premium_beans",
		name = "Premium Beans",
		description = "Las bebidas de café dan un 10% más de propina.",
		maxLevel = 3,
		baseCost = 100,
		costMultiplier = 2.4,
		effect = "coffee",
	},
	{
		id = "cozy_lanterns",
		name = "Cozy Lanterns",
		description = "Los clientes esperan un 10% más antes de irse.",
		maxLevel = 3,
		baseCost = 120,
		costMultiplier = 2.4,
		effect = "patience",
	},
	{
		id = "menu_board",
		name = "Menu Board",
		description = "Desbloquea una receta nueva en el menú.",
		maxLevel = 3,
		baseCost = 200,
		costMultiplier = 2.5,
		effect = "menu",
	},
	{
		id = "flyer_campaign",
		name = "Flyer Campaign",
		description = "Llegan clientes un 15% más rápido.",
		maxLevel = 3,
		baseCost = 150,
		costMultiplier = 2.5,
		effect = "spawn",
	},
}

return table.freeze(Upgrades)
