--!strict
-- Crea y expone los remotes del juego.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteService = {
	ProfileSync = nil :: RemoteEvent?,
	Notify = nil :: RemoteEvent?,
	PurchaseUpgrade = nil :: RemoteFunction?,
	RequestProfile = nil :: RemoteFunction?,
}

local function make(className: string, name: string, parent: Instance): Instance
	local remote = Instance.new(className)
	remote.Name = name
	remote.Parent = parent
	return remote
end

function RemoteService:start()
	local existing = ReplicatedStorage:FindFirstChild("Remotes")
	if existing then
		existing:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = "Remotes"
	folder.Parent = ReplicatedStorage

	self.ProfileSync = make("RemoteEvent", "ProfileSync", folder) :: RemoteEvent
	self.Notify = make("RemoteEvent", "Notify", folder) :: RemoteEvent
	self.PurchaseUpgrade = make("RemoteFunction", "PurchaseUpgrade", folder) :: RemoteFunction
	self.RequestProfile = make("RemoteFunction", "RequestProfile", folder) :: RemoteFunction
end

return RemoteService
