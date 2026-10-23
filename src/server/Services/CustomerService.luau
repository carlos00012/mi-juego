--!strict
-- Clientes críptidos, pedidos, cocina y servicio.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local GameConfig = require(Config:WaitForChild("GameConfig"))
local Recipes = require(Config:WaitForChild("Recipes"))
local Cryptids = require(Config:WaitForChild("Cryptids"))
local Types = require(Shared:WaitForChild("Types"))
local UpgradeUtil = require(Shared:WaitForChild("Util"):WaitForChild("UpgradeUtil"))

local DataService = require(script.Parent:WaitForChild("DataService"))
local PlotService = require(script.Parent:WaitForChild("PlotService"))
local SyncService = require(script.Parent:WaitForChild("SyncService"))
local CustomerModelBuilder =
	require(script.Parent.Parent:WaitForChild("World"):WaitForChild("CustomerModelBuilder"))

type CustomerRecord = {
	id: number,
	orderId: number,
	plot: Types.PlotRecord,
	player: Player,
	model: Model,
	root: Part,
	head: Part,
	billboard: BillboardGui,
	prompt: ProximityPrompt,
	orderLabel: TextLabel,
	patienceFill: Frame,
	seat: Types.TableRecord,
	cryptid: Types.Cryptid,
	recipe: Types.Recipe,
	state: string,
	patienceEndsAt: number,
	patienceTotal: number,
	cooking: boolean,
	carried: boolean,
	cookedAt: number?,
	stateUntil: number?,
}

type StationState = {
	customer: CustomerRecord,
	recipe: Types.Recipe,
	player: Player,
	startedAt: number,
	duration: number,
	endsAt: number,
	billboard: BillboardGui?,
	fill: Frame?,
}

local CustomerService = {}

local customers: { [number]: CustomerRecord } = {}
local plotCustomers: { [number]: { [number]: CustomerRecord } } = {}
local plotNextSpawn: { [number]: number } = {}
local stationStates: { [number]: { [string]: StationState } } = {}
local nextCustomerId = 0
local nextOrderId = 0

local recipeById: { [string]: Types.Recipe } = {}
for _, recipe in Recipes do
	recipeById[recipe.id] = recipe
end

local cryptidById: { [string]: Types.Cryptid } = {}
for _, cryptid in Cryptids do
	cryptidById[cryptid.id] = cryptid
end

local function getPlotCustomers(plotIndex: number): { [number]: CustomerRecord }
	local list = plotCustomers[plotIndex]
	if not list then
		list = {}
		plotCustomers[plotIndex] = list
	end
	return list
end

local function getStationStates(plotIndex: number): { [string]: StationState }
	local list = stationStates[plotIndex]
	if not list then
		list = {}
		stationStates[plotIndex] = list
	end
	return list
end

local function tweenTo(root: Part, target: CFrame, duration: number)
	local tween = TweenService:Create(
		root,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{ CFrame = target }
	)
	tween:Play()
	tween.Completed:Wait()
end

local function walkSegment(record: CustomerRecord, targetPosition: Vector3, speed: number): boolean
	if record.state ~= "walking" or not record.model.Parent then
		return false
	end

	local current = record.root.Position
	local flatTarget = Vector3.new(targetPosition.X, 0.5, targetPosition.Z)
	local delta = flatTarget - current
	if delta.Magnitude < 0.1 then
		return true
	end

	local lookTarget = flatTarget + delta.Unit
	local duration = math.max(0.25, delta.Magnitude / speed)
	tweenTo(record.root, CFrame.lookAt(flatTarget, lookTarget), duration)
	return record.state == "walking" and record.model.Parent ~= nil
end

local function createCustomerBillboard(
	head: Part,
	cryptid: Types.Cryptid
): (BillboardGui, TextLabel, Frame)
	local gui = Instance.new("BillboardGui")
	gui.Name = "CustomerBillboard"
	gui.Size = UDim2.fromOffset(230, 104)
	gui.StudsOffset = Vector3.new(0, 3.1, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 90
	gui.Adornee = head
	gui.Parent = head

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(22, 34, 50)
	frame.BackgroundTransparency = 0.12
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.fromScale(0.92, 0.34)
	nameLabel.Position = UDim2.fromScale(0.04, 0.05)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextScaled = true
	nameLabel.TextColor3 = cryptid.eyeColor
	nameLabel.Text = cryptid.name .. " · " .. cryptid.rarity
	nameLabel.Parent = frame

	local orderLabel = Instance.new("TextLabel")
	orderLabel.Name = "Order"
	orderLabel.BackgroundTransparency = 1
	orderLabel.Size = UDim2.fromScale(0.92, 0.34)
	orderLabel.Position = UDim2.fromScale(0.04, 0.39)
	orderLabel.Font = Enum.Font.Gotham
	orderLabel.TextScaled = true
	orderLabel.TextColor3 = Color3.fromRGB(245, 233, 216)
	orderLabel.Text = "Wants: ..."
	orderLabel.Parent = frame

	local barBack = Instance.new("Frame")
	barBack.Name = "BarBack"
	barBack.Size = UDim2.fromScale(0.92, 0.12)
	barBack.Position = UDim2.fromScale(0.04, 0.82)
	barBack.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
	barBack.BorderSizePixel = 0
	barBack.Parent = frame

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 6)
	barCorner.Parent = barBack

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(1, 1)
	fill.BackgroundColor3 = Color3.fromRGB(110, 200, 140)
	fill.BorderSizePixel = 0
	fill.Parent = barBack

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 6)
	fillCorner.Parent = fill

	return gui, orderLabel, fill
end

local function findFreeSeat(plot: Types.PlotRecord): Types.TableRecord?
	for _, record in plot.tables do
		if not record.occupiedBy then
			return record
		end
	end
	return nil
end

local function chooseCryptid(profile: Types.Profile): Types.Cryptid
	local pity = profile.stats.mothmanPity or 0
	if (profile.codex.mothman or 0) == 0 and pity >= GameConfig.Customer.MothmanPity then
		profile.stats.mothmanPity = 0
		return cryptidById.mothman
	end

	local total = 0
	for _, cryptid in Cryptids do
		total += cryptid.weight
	end

	local roll = math.random() * total
	local chosen = Cryptids[1]
	for _, cryptid in Cryptids do
		roll -= cryptid.weight
		if roll <= 0 then
			chosen = cryptid
			break
		end
	end

	if chosen.id == "mothman" then
		profile.stats.mothmanPity = 0
	else
		profile.stats.mothmanPity = pity + 1
	end

	return chosen
end

local function chooseRecipe(profile: Types.Profile, cryptid: Types.Cryptid): Types.Recipe
	local menuLevel = UpgradeUtil.getLevel(profile, "menu_board")
	local unlocked: { Types.Recipe } = {}
	for _, recipe in Recipes do
		if recipe.menuLevel <= menuLevel then
			table.insert(unlocked, recipe)
		end
	end

	if #unlocked == 0 then
		return Recipes[1]
	end

	local favorite = recipeById[cryptid.favoriteRecipe]
	if favorite and favorite.menuLevel <= menuLevel and math.random() < 0.5 then
		return favorite
	end

	return unlocked[math.random(1, #unlocked)]
end

local function spawnInterval(profile: Types.Profile): number
	local flyer = UpgradeUtil.getLevel(profile, "flyer_campaign")
	local interval = GameConfig.Customer.BaseSpawnInterval
		/ (1 + GameConfig.Upgrades.SpawnBonus * flyer)
	return math.max(GameConfig.Customer.MinSpawnInterval, interval) + math.random() * 2 - 1
end

local function updateCustomerBillboard(record: CustomerRecord, now: number)
	if record.state ~= "waiting" then
		return
	end

	if record.carried then
		record.orderLabel.Text = "Ready to serve!"
	elseif record.cooking then
		record.orderLabel.Text = "Cooking: " .. record.recipe.name
	else
		record.orderLabel.Text = "Wants: " .. record.recipe.name
	end

	local ratio = math.clamp((record.patienceEndsAt - now) / record.patienceTotal, 0, 1)
	record.patienceFill.Size = UDim2.fromScale(ratio, 1)

	if ratio > 0.5 then
		record.patienceFill.BackgroundColor3 = Color3.fromRGB(110, 200, 140)
	elseif ratio > 0.25 then
		record.patienceFill.BackgroundColor3 = Color3.fromRGB(240, 190, 90)
	else
		record.patienceFill.BackgroundColor3 = Color3.fromRGB(230, 100, 100)
	end
end

local function sitCustomer(record: CustomerRecord)
	if record.state ~= "walking" or not record.model.Parent then
		return
	end
	if record.model.Parent == nil then
		return
	end

	local profile = DataService:getProfile(record.player)
	if not profile then
		return
	end

	record.orderId = nextOrderId
	nextOrderId += 1

	local patienceBonus = 1
		+ GameConfig.Upgrades.PatienceBonus * UpgradeUtil.getLevel(profile, "cozy_lanterns")
	record.patienceTotal = GameConfig.Customer.BasePatience
		* record.cryptid.patienceMultiplier
		* patienceBonus
	record.patienceEndsAt = os.clock() + record.patienceTotal
	record.state = "waiting"
	record.cooking = false
	record.carried = false
	record.cookedAt = nil

	record.model:SetAttribute("OrderId", record.orderId)
	record.model:SetAttribute("RecipeId", record.recipe.id)
	record.model:SetAttribute("CryptidId", record.cryptid.id)

	record.prompt.Enabled = true
	record.orderLabel.Text = "Wants: " .. record.recipe.name
	record.patienceFill.Size = UDim2.fromScale(1, 1)
	profile.stats.customersArrived = (profile.stats.customersArrived or 0) + 1

	SyncService:notify(record.player, `{record.cryptid.name} quiere {record.recipe.name}`, "info")
end

local function walkToSeat(record: CustomerRecord)
	local plot = record.plot
	local seat = record.seat
	local aisleZ = seat.seatCFrame.Position.Z

	local waypoints = {
		plot.doorInside.Position,
		Vector3.new(plot.origin.X, 0.5, aisleZ),
		seat.approachPosition,
	}

	for _, waypoint in waypoints do
		if not walkSegment(record, waypoint, GameConfig.Customer.WalkSpeed) then
			return
		end
	end

	if record.state ~= "walking" or not record.model.Parent then
		return
	end

	tweenTo(record.root, seat.seatCFrame, 0.35)
	sitCustomer(record)
end

local function spawnCustomer(plot: Types.PlotRecord, player: Player, profile: Types.Profile)
	local seat = findFreeSeat(plot)
	if not seat then
		return
	end

	local cryptid = chooseCryptid(profile)
	local recipe = chooseRecipe(profile, cryptid)
	local id = nextCustomerId
	nextCustomerId += 1

	local model, root, head = CustomerModelBuilder.build(cryptid, plot.customerSpawn.Position)
	local body = model:FindFirstChild("Body") :: Part

	local billboard, orderLabel, patienceFill = createCustomerBillboard(head, cryptid)

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "ServePrompt"
	prompt.ActionText = "Serve"
	prompt.ObjectText = cryptid.name
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Enabled = false
	prompt.Parent = body

	model:SetAttribute("CustomerId", id)
	model:SetAttribute("PlotIndex", plot.index)
	model.Parent = plot.model:WaitForChild("Customers")

	seat.occupiedBy = id
	seat.seat:SetAttribute("OccupiedBy", id)

	local record: CustomerRecord = {
		id = id,
		orderId = 0,
		plot = plot,
		player = player,
		model = model,
		root = root,
		head = head,
		billboard = billboard,
		prompt = prompt,
		orderLabel = orderLabel,
		patienceFill = patienceFill,
		seat = seat,
		cryptid = cryptid,
		recipe = recipe,
		state = "walking",
		patienceEndsAt = 0,
		patienceTotal = 1,
		cooking = false,
		carried = false,
		cookedAt = nil,
		stateUntil = nil,
	}

	customers[id] = record
	getPlotCustomers(plot.index)[id] = record

	prompt.Triggered:Connect(function(triggeringPlayer: Player)
		CustomerService:serve(triggeringPlayer, record)
	end)

	task.spawn(walkToSeat, record)
end

local function createStationBillboard(station: Part, recipe: Types.Recipe): (BillboardGui, Frame)
	local gui = Instance.new("BillboardGui")
	gui.Name = "CookingBillboard"
	gui.Size = UDim2.fromOffset(190, 58)
	gui.StudsOffset = Vector3.new(0, 3.4, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 70
	gui.Adornee = station
	gui.Parent = station

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(22, 34, 50)
	frame.BackgroundTransparency = 0.12
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(0.92, 0.5)
	label.Position = UDim2.fromScale(0.04, 0.08)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 210, 150)
	label.Text = "Cooking " .. recipe.name
	label.Parent = frame

	local barBack = Instance.new("Frame")
	barBack.Size = UDim2.fromScale(0.92, 0.2)
	barBack.Position = UDim2.fromScale(0.04, 0.66)
	barBack.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
	barBack.BorderSizePixel = 0
	barBack.Parent = frame

	local backCorner = Instance.new("UICorner")
	backCorner.CornerRadius = UDim.new(0, 6)
	backCorner.Parent = barBack

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = Color3.fromRGB(255, 180, 92)
	fill.BorderSizePixel = 0
	fill.Parent = barBack

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 6)
	fillCorner.Parent = fill

	return gui, fill
end

local function clearStationForCustomer(record: CustomerRecord)
	local states = getStationStates(record.plot.index)
	for stationType, state in states do
		if state.customer == record then
			states[stationType] = nil
			local station = record.plot.stations[stationType]
			if station then
				local prompt = station:FindFirstChild("CookPrompt") :: ProximityPrompt?
				if prompt then
					prompt.Enabled = true
				end
			end
			if state.billboard then
				state.billboard:Destroy()
			end
		end
	end
end

local function destroyCustomer(record: CustomerRecord)
	customers[record.id] = nil
	local list = plotCustomers[record.plot.index]
	if list then
		list[record.id] = nil
	end

	record.seat.occupiedBy = nil
	record.seat.seat:SetAttribute("OccupiedBy", 0)

	if record.model.Parent then
		record.model:Destroy()
	end
end

local function leaveCustomer(record: CustomerRecord, reason: string)
	if record.state == "leaving" then
		return
	end

	record.state = "leaving"
	record.cooking = false
	clearStationForCustomer(record)

	if record.carried then
		if
			record.player.Parent
			and record.player:GetAttribute("CarryingOrderId") == record.orderId
		then
			record.player:SetAttribute("CarryingOrderId", nil)
			record.player:SetAttribute("CarryingRecipeId", nil)
			record.player:SetAttribute("CarryingCustomerId", nil)
		end
	end

	record.prompt.Enabled = false
	record.patienceFill.Size = UDim2.fromScale(0, 1)
	record.orderLabel.Text = reason == "impatient" and "Left without paying..."
		or "Thanks for visiting!"

	if reason == "impatient" then
		local profile = DataService:getProfile(record.player)
		if profile then
			profile.stats.customersLost = (profile.stats.customersLost or 0) + 1
		end
		SyncService:notify(record.player, `{record.cryptid.name} se fue sin pagar.`, "error")
	end

	local plot = record.plot
	task.spawn(function()
		if not record.model.Parent then
			destroyCustomer(record)
			return
		end

		local inside = Vector3.new(plot.origin.X, 0.5, plot.doorInside.Position.Z)
		local outside = Vector3.new(plot.origin.X, 0.5, plot.doorOutside.Position.Z)
		local current = record.root.Position
		local duration = math.max(0.3, (current - inside).Magnitude / GameConfig.Customer.WalkSpeed)
		tweenTo(record.root, CFrame.lookAt(inside, inside + Vector3.new(0, 0, 1)), duration)
		if record.model.Parent then
			local outDuration =
				math.max(0.3, (inside - outside).Magnitude / GameConfig.Customer.WalkSpeed)
			tweenTo(
				record.root,
				CFrame.lookAt(outside, outside + Vector3.new(0, 0, 1)),
				outDuration
			)
		end
		destroyCustomer(record)
	end)
end

function CustomerService:serve(player: Player, record: CustomerRecord)
	if record.state ~= "waiting" or not record.model.Parent then
		return
	end
	if record.plot.ownerUserId ~= player.UserId then
		SyncService:notify(player, "Esta cafetería no es tuya.", "error")
		return
	end

	local now = os.clock()
	if now >= record.patienceEndsAt then
		leaveCustomer(record, "impatient")
		return
	end

	local carrying = player:GetAttribute("CarryingOrderId")
	if carrying == nil then
		SyncService:notify(player, "Primero recoge el plato en la estación.", "error")
		return
	end
	if carrying ~= record.orderId or not record.carried then
		SyncService:notify(player, "Ese plato no es para este cliente.", "error")
		return
	end

	local profile = DataService:getProfile(player)
	if not profile then
		return
	end

	local age = record.cookedAt and (now - record.cookedAt) or 999
	local quality = 0.85
	if age <= GameConfig.Customer.FreshnessWindow then
		quality = 1.2
	elseif age <= GameConfig.Customer.FreshnessDecay then
		quality = 1.0
	end

	local favorite = record.recipe.id == record.cryptid.favoriteRecipe
	local coffeeLevel = UpgradeUtil.getLevel(profile, "premium_beans")
	local coffeeBonus = record.recipe.station == "Coffee"
			and (1 + GameConfig.Upgrades.CoffeeTipBonus * coffeeLevel)
		or 1
	local patienceFactor = math.clamp((record.patienceEndsAt - now) / record.patienceTotal, 0, 1)
	local base = record.recipe.value * record.cryptid.payoutMultiplier * quality * coffeeBonus
	local tip = base * GameConfig.Customer.TipRate * patienceFactor
	if favorite then
		tip *= GameConfig.Customer.FavoriteTipMultiplier
	end
	local total = math.floor(base + tip)

	DataService:addEcto(player, total)
	local levels, reward = DataService:addXp(player, record.recipe.xp)

	profile.stats.customersServed = (profile.stats.customersServed or 0) + 1
	profile.stats.totalEarned = (profile.stats.totalEarned or 0) + total
	if quality >= 1.2 then
		profile.stats.perfectDishes = (profile.stats.perfectDishes or 0) + 1
	end
	if favorite then
		profile.stats.favoriteServed = (profile.stats.favoriteServed or 0) + 1
	end

	local firstDiscovery = (profile.codex[record.cryptid.id] or 0) == 0
	profile.codex[record.cryptid.id] = (profile.codex[record.cryptid.id] or 0) + 1

	player:SetAttribute("CarryingOrderId", nil)
	player:SetAttribute("CarryingRecipeId", nil)
	player:SetAttribute("CarryingCustomerId", nil)

	record.carried = false
	record.cooking = false
	record.state = "eating"
	record.stateUntil = now + GameConfig.Customer.EatDuration
	record.prompt.Enabled = false
	record.orderLabel.Text = `Enjoying {record.recipe.name} · +Ɛ{total}`
	record.patienceFill.Size = UDim2.fromScale(0, 1)

	if quality >= 1.2 then
		SyncService:notify(player, `¡Servicio perfecto! +Ɛ{total}`, "success")
	else
		SyncService:notify(player, `+Ɛ{total} · {record.recipe.name}`, "success")
	end
	if favorite then
		SyncService:notify(player, "¡Plato favorito! Propina extra.", "success")
	end
	if firstDiscovery then
		SyncService:notify(player, `Nueva entrada en el códice: {record.cryptid.name}`, "codex")
	end
	if levels > 0 then
		SyncService:notify(player, `¡Nivel {profile.level}! +Ɛ{reward}`, "success")
	end

	DataService:updateLeaderstats(player)
	SyncService:push(player)
end

function CustomerService:clearPlot(plot: Types.PlotRecord)
	local list = plotCustomers[plot.index]
	if list then
		local snapshot = {}
		for _, record in list do
			table.insert(snapshot, record)
		end
		for _, record in snapshot do
			record.state = "leaving"
			record.prompt.Enabled = false
			destroyCustomer(record)
		end
	end

	local states = stationStates[plot.index]
	if states then
		for stationType, state in states do
			states[stationType] = nil
			local station = plot.stations[stationType]
			if station then
				local prompt = station:FindFirstChild("CookPrompt") :: ProximityPrompt?
				if prompt then
					prompt.Enabled = true
				end
			end
			if state.billboard then
				state.billboard:Destroy()
			end
		end
	end

	plotNextSpawn[plot.index] = nil
end

function CustomerService:onStationTriggered(player: Player, station: Part)
	local plotIndex = station:GetAttribute("PlotIndex")
	local stationType = station:GetAttribute("StationType")
	if type(plotIndex) ~= "number" or type(stationType) ~= "string" then
		return
	end

	local plot = PlotService:getPlotByIndex(plotIndex)
	if not plot then
		return
	end
	if plot.ownerUserId ~= player.UserId then
		SyncService:notify(player, "Esta cocina no es tuya.", "error")
		return
	end

	local profile = DataService:getProfile(player)
	if not profile then
		return
	end

	local carrying = player:GetAttribute("CarryingOrderId")
	if carrying ~= nil then
		SyncService:notify(player, "Ya llevas un plato. Sírvelo primero.", "error")
		return
	end

	local states = getStationStates(plotIndex)
	if states[stationType] then
		SyncService:notify(player, `La estación de {stationType} está ocupada.`, "error")
		return
	end

	local best: CustomerRecord? = nil
	for _, record in getPlotCustomers(plotIndex) do
		if
			record.state == "waiting"
			and not record.cooking
			and not record.carried
			and record.recipe.station == stationType
		then
			if not best or record.patienceEndsAt < best.patienceEndsAt then
				best = record
			end
		end
	end

	if not best then
		SyncService:notify(player, `No hay pedidos pendientes para {stationType}.`, "info")
		return
	end

	local betterStove = UpgradeUtil.getLevel(profile, "better_stove")
	local duration = best.recipe.duration
	if stationType == "Stove" then
		duration *= 1 - GameConfig.Cooking.StoveTimeReduction * betterStove
	end

	best.cooking = true
	local billboard, fill = createStationBillboard(station, best.recipe)
	local prompt = station:FindFirstChild("CookPrompt") :: ProximityPrompt?
	if prompt then
		prompt.Enabled = false
	end

	states[stationType] = {
		customer = best,
		recipe = best.recipe,
		player = player,
		startedAt = os.clock(),
		duration = duration,
		endsAt = os.clock() + duration,
		billboard = billboard,
		fill = fill,
	}

	SyncService:notify(player, `Cocinando {best.recipe.name}...`, "info")
end

local function completeCooking(plot: Types.PlotRecord, stationType: string, state: StationState)
	local states = getStationStates(plot.index)
	states[stationType] = nil

	local station = plot.stations[stationType]
	if station then
		local prompt = station:FindFirstChild("CookPrompt") :: ProximityPrompt?
		if prompt then
			prompt.Enabled = true
		end
	end
	if state.billboard then
		state.billboard:Destroy()
	end

	local record = state.customer
	record.cooking = false

	if record.state ~= "waiting" or not record.model.Parent then
		return
	end
	if state.player.Parent == nil then
		return
	end

	record.carried = true
	record.cookedAt = os.clock()

	state.player:SetAttribute("CarryingOrderId", record.orderId)
	state.player:SetAttribute("CarryingRecipeId", record.recipe.id)
	state.player:SetAttribute("CarryingCustomerId", record.id)

	record.orderLabel.Text = "Ready to serve!"
	SyncService:notify(
		state.player,
		`Listo: {record.recipe.name}. Sirve a {record.cryptid.name}.`,
		"success"
	)
end

function CustomerService:start()
	for _, plot in PlotService:getAllPlots() do
		for _, station in plot.stations do
			local prompt = station:FindFirstChild("CookPrompt") :: ProximityPrompt?
			if prompt then
				prompt.Triggered:Connect(function(player: Player)
					self:onStationTriggered(player, station)
				end)
			end
		end
	end

	local accumulator = 0
	RunService.Heartbeat:Connect(function(dt: number)
		accumulator += dt
		if accumulator < 0.2 then
			return
		end
		accumulator = 0

		local now = os.clock()

		for _, plot in PlotService:getAllPlots() do
			if plot.ownerUserId ~= 0 then
				local owner = Players:GetPlayerByUserId(plot.ownerUserId)
				local profile = owner and DataService:getProfile(owner) or nil

				if owner and profile then
					local nextAt = plotNextSpawn[plot.index]
					if not nextAt then
						nextAt = now + GameConfig.Customer.FirstSpawnDelay
						plotNextSpawn[plot.index] = nextAt
					end

					if now >= nextAt then
						if findFreeSeat(plot) then
							spawnCustomer(plot, owner, profile)
							plotNextSpawn[plot.index] = now + spawnInterval(profile)
						else
							plotNextSpawn[plot.index] = now
								+ GameConfig.Customer.SpawnCooldownWhenFull
						end
					end
				end

				local list = getPlotCustomers(plot.index)
				local snapshot = {}
				for _, record in list do
					table.insert(snapshot, record)
				end

				for _, record in snapshot do
					if record.state == "waiting" then
						updateCustomerBillboard(record, now)
						if now >= record.patienceEndsAt then
							leaveCustomer(record, "impatient")
						end
					elseif record.state == "eating" then
						if record.stateUntil and now >= record.stateUntil then
							leaveCustomer(record, "served")
						end
					end
				end

				local states = getStationStates(plot.index)
				for stationType, state in states do
					local progress = math.clamp((now - state.startedAt) / state.duration, 0, 1)
					if state.fill then
						state.fill.Size = UDim2.fromScale(progress, 1)
					end
					if now >= state.endsAt then
						completeCooking(plot, stationType, state)
					end
				end
			end
		end
	end)

	print("[Clientes] Sistema de clientes iniciado")
end

return CustomerService
