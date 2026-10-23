--!strict
-- Perfiles, guardado y economía base.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local GameConfig = require(Config:WaitForChild("GameConfig"))
local Cryptids = require(Config:WaitForChild("Cryptids"))
local Upgrades = require(Config:WaitForChild("Upgrades"))
local Types = require(Shared:WaitForChild("Types"))

local DataService = {}

local store: DataStore? = nil
local profiles: { [number]: Types.Profile } = {}
local memoryOnly: { [number]: boolean } = {}
local loading: { [number]: boolean } = {}

local function keyFor(userId: number): string
	return "u_" .. tostring(userId)
end

local function defaultProfile(): Types.Profile
	local upgrades: { [string]: number } = {}
	for _, upgrade in Upgrades do
		upgrades[upgrade.id] = 0
	end

	local codex: { [string]: number } = {}
	for _, cryptid in Cryptids do
		codex[cryptid.id] = 0
	end

	return {
		version = GameConfig.ProfileVersion,
		ecto = GameConfig.StartingEcto,
		xp = 0,
		level = 1,
		upgrades = upgrades,
		codex = codex,
		stats = {
			customersServed = 0,
			customersLost = 0,
			customersArrived = 0,
			perfectDishes = 0,
			totalEarned = 0,
			favoriteServed = 0,
			mothmanPity = 0,
		},
		lastSeen = os.time(),
	}
end

local function merge(defaults: any, data: any): any
	for key, value in defaults do
		if type(value) == "table" then
			if type(data[key]) ~= "table" then
				data[key] = {}
			end
			merge(value, data[key])
		elseif data[key] == nil then
			data[key] = value
		end
	end
	return data
end

local function numberOr(value: any, fallback: number, minimum: number?): number
	local n = tonumber(value)
	if not n then
		return fallback
	end
	if minimum and n < minimum then
		return minimum
	end
	return n
end

local function sanitize(profile: Types.Profile): Types.Profile
	profile.ecto = math.floor(numberOr(profile.ecto, GameConfig.StartingEcto, 0))
	profile.xp = math.floor(numberOr(profile.xp, 0, 0))
	profile.level = math.clamp(math.floor(numberOr(profile.level, 1, 1)), 1, 100)
	profile.version = GameConfig.ProfileVersion
	profile.lastSeen = os.time()

	for _, upgrade in Upgrades do
		local level = math.floor(numberOr(profile.upgrades[upgrade.id], 0, 0))
		profile.upgrades[upgrade.id] = math.clamp(level, 0, upgrade.maxLevel)
	end

	for _, cryptid in Cryptids do
		profile.codex[cryptid.id] = math.floor(numberOr(profile.codex[cryptid.id], 0, 0))
	end

	for stat, value in profile.stats do
		profile.stats[stat] = math.floor(numberOr(value, 0, 0))
	end

	return profile
end

local function createLeaderstats(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and not leaderstats:IsA("Folder") then
		leaderstats:Destroy()
		leaderstats = nil
	end
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	for _, name in { "Ecto", "Level", "Sightings" } do
		if not leaderstats:FindFirstChild(name) then
			local value = Instance.new("IntValue")
			value.Name = name
			value.Value = 0
			value.Parent = leaderstats
		end
	end
end

function DataService:start()
	local ok, result = pcall(function()
		return DataStoreService:GetDataStore(GameConfig.DataStoreName)
	end)

	if ok then
		store = result
		print("[Datos] DataStore conectado")
	else
		warn("[Datos] DataStore no disponible; se usará memoria temporal:", result)
	end

	task.spawn(function()
		while true do
			task.wait(60)
			for _, player in Players:GetPlayers() do
				self:save(player)
			end
		end
	end)

	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			self:save(player)
		end
		task.wait(1)
	end)
end

function DataService:load(player: Player): Types.Profile?
	if profiles[player.UserId] then
		return profiles[player.UserId]
	end
	if loading[player.UserId] then
		return nil
	end

	loading[player.UserId] = true
	local profile = defaultProfile()

	if store then
		local ok, data = pcall(function()
			return store:GetAsync(keyFor(player.UserId))
		end)

		if ok then
			if type(data) == "table" then
				profile = merge(profile, data) :: Types.Profile
			end
		else
			memoryOnly[player.UserId] = true
			warn(`[Datos] No se pudo cargar a ${player.Name}; perfil temporal:`, data)
		end
	else
		memoryOnly[player.UserId] = true
	end

	profile = sanitize(profile)
	profiles[player.UserId] = profile
	loading[player.UserId] = nil

	createLeaderstats(player)
	self:updateLeaderstats(player)
	return profile
end

function DataService:getProfile(player: Player): Types.Profile?
	return profiles[player.UserId]
end

function DataService:updateLeaderstats(player: Player)
	local profile = profiles[player.UserId]
	if not profile then
		return
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return
	end

	local ecto = leaderstats:FindFirstChild("Ecto") :: IntValue?
	local level = leaderstats:FindFirstChild("Level") :: IntValue?
	local sightings = leaderstats:FindFirstChild("Sightings") :: IntValue?

	if ecto then
		ecto.Value = profile.ecto
	end
	if level then
		level.Value = profile.level
	end
	if sightings then
		local total = 0
		for _, count in profile.codex do
			total += count
		end
		sightings.Value = total
	end
end

function DataService:addEcto(player: Player, amount: number): number
	local profile = profiles[player.UserId]
	if not profile then
		return 0
	end
	profile.ecto = math.max(0, profile.ecto + math.floor(amount))
	self:updateLeaderstats(player)
	return profile.ecto
end

function DataService:addXp(player: Player, amount: number): (number, number)
	local profile = profiles[player.UserId]
	if not profile then
		return 0, 0
	end

	profile.xp += math.max(0, math.floor(amount))
	local levelsGained = 0
	local reward = 0

	while profile.xp >= GameConfig.getXpForLevel(profile.level) do
		profile.xp -= GameConfig.getXpForLevel(profile.level)
		profile.level += 1
		profile.ecto += GameConfig.XP.LevelUpEcto
		levelsGained += 1
		reward += GameConfig.XP.LevelUpEcto
	end

	self:updateLeaderstats(player)
	return levelsGained, reward
end

function DataService:save(player: Player): boolean
	local profile = profiles[player.UserId]
	if not profile or memoryOnly[player.UserId] or not store then
		return false
	end

	profile.lastSeen = os.time()
	local ok, err = pcall(function()
		store:SetAsync(keyFor(player.UserId), profile)
	end)

	if not ok then
		warn(`[Datos] No se pudo guardar a ${player.Name}:`, err)
	end
	return ok
end

function DataService:unload(player: Player)
	profiles[player.UserId] = nil
	memoryOnly[player.UserId] = nil
	loading[player.UserId] = nil
end

return DataService
