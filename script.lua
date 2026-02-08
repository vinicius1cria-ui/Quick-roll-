local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")

local UserInput = UserInputService
local Tween = TweenService

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillAuraGui"
ScreenGui.Parent = PlayersService.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Name = "KillAuraFrame"
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.BackgroundTransparency = 0.5

local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "KillAuraLabel"
TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(0, 200, 0, 20)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Kill Aura"
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.new(1, 1, 1)

local Toggle = Instance.new("TextButton")
Toggle.Name = "KillAuraToggle"
Toggle.Parent = Frame
Toggle.Size = UDim2.new(0, 50, 0, 20)
Toggle.Position = UDim2.new(0, 0, 0, 20)
Toggle.BackgroundTransparency = 0.5
Toggle.Text = "On"
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 14
Toggle.TextColor3 = Color3.new(1, 1, 1)

local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")

local PlayerGui = LocalPlayer.PlayerGui
local KillAuraGui = PlayerGui:WaitForChild("KillAuraGui")

local Function = function()
    Toggle.Text = "Off"
    Toggle.TextColor3 = Color3.new(1, 0, 0)
    local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
    Tween:Play()
end

Toggle.Tapped:Connect(Function)

local Function = function()
    Toggle.Text = "On"
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
    Tween:Play()
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

Toggle.Tapped:Connect(Function)

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
    end
end

local Function = function()
    if Toggle.Text == "On" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 1, 1)})
        Tween:Play()
    elseif Toggle.Text == "Off" then
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local Tween = TweenService:Create(Toggle, TweenInfo, {TextColor3 = Color3.new(1, 0, 0)})
        Tween:Play()
                                                        end
