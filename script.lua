--[[
    KING HUB V2 - EXTREME EDITION
    Design: Glassmorphism / Dark Blue
]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")

-- Variáveis de Estado
local states = {
    fly = false,
    noclip = false,
    speed = 16,
    jump = 50,
    flySpeed = 50
}

-- Criar Interface Principal
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "KingHubV2"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 300)
main.Position = UDim2.new(0.5, -175, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Arredondar Cantos e Borda
local corner = Instance.new("UICorner", main)
corner.CornerRadius = ToolUnit.new(0, 12)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(40, 100, 255)
stroke.Transparency = 0.5

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "♔ KING HUB V2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Container de Botões (Scrolling)
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
container.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Função para criar Botões Estilizados
local function createButton(name, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. BOTÃO FLY
local bVelo, bGyro
createButton("FLY: OFF", function(self)
    states.fly = not states.fly
    if states.fly then
        self.Text = "FLY: ON"
        self.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        bVelo = Instance.new("BodyVelocity", root)
        bVelo.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bGyro = Instance.new("BodyGyro", root)
        bGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        task.spawn(function()
            while states.fly do
                bVelo.Velocity = workspace.CurrentCamera.CFrame.LookVector
                        
