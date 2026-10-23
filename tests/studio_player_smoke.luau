local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

RunService:Run()
task.wait(2)

local ok, player = pcall(function()
	return Players:CreateLocalPlayer(12345)
end)
print("CREATE", ok, player)

if ok and player then
	local loaded, err = pcall(function()
		player:LoadCharacter()
	end)
	print("LOAD", loaded, err)
	task.wait(8)
	local plots = workspace:FindFirstChild("Plots")
	if plots then
		for _, plot in plots:GetChildren() do
			local owner = plot:GetAttribute("OwnerUserId")
			local customers = plot:FindFirstChild("Customers")
			print(
				"PLOT",
				plot.Name,
				"owner",
				owner,
				"customers",
				customers and #customers:GetChildren() or -1
			)
		end
	end
	print("PLAYER_POS", player.Character and player.Character:GetPivot().Position)
end

RunService:Stop()
print("PLAYER_SMOKE_DONE")
