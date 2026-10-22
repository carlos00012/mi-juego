--!strict
-- Punto de entrada del cliente (StarterPlayer.StarterPlayerScripts.Client).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WelcomeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local label = Instance.new("TextLabel")
label.Name = "WelcomeLabel"
label.Size = UDim2.fromScale(0.8, 0.1)
label.Position = UDim2.fromScale(0.1, 0.08)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeTransparency = 0.4
label.Text = string.format("¡Bienvenido a %s, %s!", Config.GameName, player.DisplayName)
label.Parent = screenGui

task.delay(5, function()
	local tween = TweenService:Create(label, TweenInfo.new(1), {
		TextTransparency = 1,
		TextStrokeTransparency = 1,
	})

	tween:Play()
	tween.Completed:Once(function()
		screenGui:Destroy()
	end)
end)

print(`[Cliente] ${Config.GameName} cargado para ${player.Name}`)
