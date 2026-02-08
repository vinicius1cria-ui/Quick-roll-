--[[
    KING HUB V2 - ANTI-FAIL VERSION
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Proteção para o script não quebrar se o personagem sumir
local character = player.Character or player.CharacterAdded:Wait()

-- Remover menu antigo se existir para não acumular
if pgui:FindFirstChild("KingHubV2") then
    pgui.KingHubV2:Destroy()
end

-- Variáveis
local states = { fly = false, noclip = false, speed = 16, flySpeed = 50 }
local bVelo, bGyro

-- Criar Interface
local sg = Instance.new("ScreenGui")
sg.Name = "KingHubV2"
sg.Parent = pgui
sg.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 280, 0, 320)
main.Position = UDim2.new(0.5, -140, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg

-- Bordas Arredondadas (Versão Compatível)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 120, 255)
stroke.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "KING HUB V2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

-- Função para botões
local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = main
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- Botões
createBtn("VOAR: OFF", UDim2.new(0, 20, 0, 50), function(self)
    states.fly = not states.fly
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if states.fly then
        self.Text = "VOAR: ON"
        self.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        bVelo = Instance.new("BodyVelocity", root)
        bVelo.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bGyro = Instance.new("BodyGyro", root)
        bGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        task.spawn(function()
            while states.fly do
                bVelo.Velocity = workspace.CurrentCamera.CFrame.LookVector * states.flySpeed
                bGyro.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
    else
        self.Text = "VOAR: OFF"
        self.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
        if bVelo then bVelo:Destroy() end
        if bGyro then bGyro:Destroy() end
    end
end)

createBtn("ATRAVESSAR PAREDE", UDim2.new(0, 20, 0, 100), function(self)
    states.noclip = not states.noclip
    self.BackgroundColor3 = states.noclip and Color3.fromRGB(150, 100, 0) or Color3.fromRGB(20, 30, 50)
end)

createBtn("VELOCIDADE +", UDim2.new(0, 20, 0, 150), function()
    states.speed = states.speed + 20
    player.Character.Humanoid.WalkSpeed = states.speed
end)

createBtn("FECHAR MENU", UDim2.new(0, 20, 0, 250), function()
    states.fly = false
    states.noclip = false
    sg:Destroy()
end)

-- Loop do Noclip (Atravessar paredes)
RunService.Stepped:Connect(function()
    if states.noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

print("King Hub V2 Executado!")
