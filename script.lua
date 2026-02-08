local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()

-- Variáveis de controle
local voando = false
local velocidade = 50
local bVelo = nil
local bGyro = nil

-- 1. Criar a interface (Mesmo estilo anterior)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuVoo"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40) -- Azul Escuro
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.new(0,0,0) -- Contorno Preto
stroke.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "SISTEMA DE VOO"
title.BackgroundColor3 = Color3.fromRGB(15, 30, 60)
title.TextColor3 = Color3.new(1,1,1)
title.Parent = mainFrame

-- Botão Ativar/Desativar
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 200, 0, 40)
flyBtn.Position = UDim2.new(0.5, -100, 0, 50)
flyBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
flyBtn.Text = "VOAR: OFF"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Parent = mainFrame

-- Botão Aumentar Velocidade
local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0, 95, 0, 40)
speedUp.Position = UDim2.new(0.5, -100, 0, 100)
speedUp.Text = "VELO +"
speedUp.Parent = mainFrame

-- Botão Diminuir Velocidade
local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0, 95, 0, 40)
speedDown.Position = UDim2.new(0.5, 5, 0, 100)
speedDown.Text = "VELO -"
speedDown.Parent = mainFrame

-- Mostrar Velocidade Atual
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 150)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = "Velocidade: " .. velocidade
speedLabel.Parent = mainFrame

-- LÓGICA DE VOO
local function toggleFly()
    voando = not voando
    character = player.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if voando then
        flyBtn.Text = "VOAR: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Cria as forças físicas para manter o personagem no ar
        bVelo = Instance.new("BodyVelocity")
        bVelo.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bVelo.Velocity = Vector3.new(0,0,0)
        bVelo.Parent = root
        
        bGyro = Instance.new("BodyGyro")
        bGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bGyro.P = 9000
        bGyro.Parent = root
        
        -- Loop de movimento
        spawn(function()
            while voando do
                -- Faz o personagem ir para onde a câmera aponta
                bVelo.Velocity = workspace.CurrentCamera.CFrame.LookVector * velocidade
                bGyro.CFrame = workspace.CurrentCamera.CFrame
                wait()
            end
        end)
    else
        flyBtn.Text = "VOAR: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
        if bVelo then bVelo:Destroy() end
        if bGyro then bGyro:Destroy() end
    end
end

-- Configurar Botões
flyBtn.MouseButton1Click:Connect(toggleFly)

speedUp.MouseButton1Click:Connect(function()
    velocidade = velocidade + 10
    speedLabel.Text = "Velocidade: " .. velocidade
end)

speedDown.MouseButton1Click:Connect(function()
    if velocidade > 10 then
        velocidade = velocidade - 10
        speedLabel.Text = "Velocidade: " .. velocidade
    end
end)
