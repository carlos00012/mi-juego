--!strict
-- Configuración compartida entre cliente y servidor.
-- Rojo la publica en ReplicatedStorage.Shared.Config.

local Config = {
	GameName = "mi-juego",
	WalkSpeed = 20,
	StartingCoins = 0,
}

return table.freeze(Config)
