--!strict
-- Tipos compartidos entre cliente y servidor.

export type Recipe = {
	id: string,
	name: string,
	station: string,
	duration: number,
	value: number,
	xp: number,
	menuLevel: number,
	color: Color3,
	description: string,
}

export type Cryptid = {
	id: string,
	name: string,
	rarity: string,
	weight: number,
	favoriteRecipe: string,
	patienceMultiplier: number,
	payoutMultiplier: number,
	bodyColor: Color3,
	eyeColor: Color3,
	shape: string,
	description: string,
}

export type Upgrade = {
	id: string,
	name: string,
	description: string,
	maxLevel: number,
	baseCost: number,
	costMultiplier: number,
	effect: string,
}

export type Profile = {
	version: number,
	ecto: number,
	xp: number,
	level: number,
	upgrades: { [string]: number },
	codex: { [string]: number },
	stats: { [string]: number },
	lastSeen: number,
}

export type TableRecord = {
	index: number,
	model: Model,
	seat: Part,
	seatCFrame: CFrame,
	approachPosition: Vector3,
	occupiedBy: number?,
}

export type PlotRecord = {
	index: number,
	origin: Vector3,
	model: Model,
	spawn: SpawnLocation,
	customerSpawn: Part,
	doorInside: Part,
	doorOutside: Part,
	stations: { [string]: Part },
	tables: { TableRecord },
	ownerUserId: number,
	ownerName: string,
	signLabel: TextLabel,
	ownerLabel: TextLabel,
}

return {}
