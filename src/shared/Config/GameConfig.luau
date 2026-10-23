--!strict
-- Configuración global del juego.

local GameConfig = {
	GameName = "Cryptid Café",
	DataStoreName = "CryptidCafe_Profiles_v1",
	ProfileVersion = 1,
	StartingEcto = 50,
	WalkSpeed = 20,

	PlotCount = 6,
	PlotPositions = {
		Vector3.new(-180, 0, -120),
		Vector3.new(0, 0, -120),
		Vector3.new(180, 0, -120),
		Vector3.new(-180, 0, 120),
		Vector3.new(0, 0, 120),
		Vector3.new(180, 0, 120),
	},

	Customer = {
		BaseSpawnInterval = 14,
		MinSpawnInterval = 6,
		FirstSpawnDelay = 4,
		BasePatience = 45,
		EatDuration = 3,
		FreshnessWindow = 15,
		FreshnessDecay = 30,
		TipRate = 0.15,
		FavoriteTipMultiplier = 1.5,
		WalkSpeed = 12,
		SpawnCooldownWhenFull = 2,
		MothmanPity = 6,
	},

	Cooking = {
		StoveTimeReduction = 0.15,
	},

	Upgrades = {
		CoffeeTipBonus = 0.1,
		PatienceBonus = 0.1,
		SpawnBonus = 0.15,
	},

	XP = {
		Base = 100,
		Exponent = 1.5,
		LevelUpEcto = 25,
	},
}

function GameConfig.getXpForLevel(level: number): number
	return math.floor(GameConfig.XP.Base * level ^ GameConfig.XP.Exponent)
end

return table.freeze(GameConfig)
