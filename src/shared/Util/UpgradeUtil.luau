--!strict
-- Utilidades compartidas para mejoras.

local Upgrades = require(script.Parent.Parent:WaitForChild("Config"):WaitForChild("Upgrades"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

local UpgradeUtil = {}

local byId: { [string]: Types.Upgrade } = {}
for _, upgrade in Upgrades do
	byId[upgrade.id] = upgrade
end

function UpgradeUtil.get(upgradeId: string): Types.Upgrade?
	return byId[upgradeId]
end

function UpgradeUtil.getCost(upgrade: Types.Upgrade, level: number): number
	return math.floor(upgrade.baseCost * upgrade.costMultiplier ^ level)
end

function UpgradeUtil.getLevel(profile: Types.Profile, upgradeId: string): number
	return profile.upgrades[upgradeId] or 0
end

function UpgradeUtil.getTotalLevels(profile: Types.Profile): number
	local total = 0
	for _, level in profile.upgrades do
		total += level
	end
	return total
end

return table.freeze(UpgradeUtil)
