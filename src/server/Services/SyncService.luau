--!strict
-- Sincroniza el perfil y los avisos con el cliente.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Types = require(Shared:WaitForChild("Types"))

local DataService = require(script.Parent:WaitForChild("DataService"))
local RemoteService = require(script.Parent:WaitForChild("RemoteService"))

local SyncService = {}

function SyncService:start()
	local request = RemoteService.RequestProfile
	if request then
		request.OnServerInvoke = function(player: Player): Types.Profile?
			return DataService:getProfile(player)
		end
	end
end

function SyncService:push(player: Player)
	local profile = DataService:getProfile(player)
	local remote = RemoteService.ProfileSync
	if profile and remote and player.Parent then
		remote:FireClient(player, profile)
	end
end

function SyncService:notify(player: Player, text: string, kind: string?)
	local remote = RemoteService.Notify
	if remote and player.Parent then
		remote:FireClient(player, text, kind or "info")
	end
end

function SyncService:pushAll()
	for _, player in game:GetService("Players"):GetPlayers() do
		self:push(player)
	end
end

return SyncService
