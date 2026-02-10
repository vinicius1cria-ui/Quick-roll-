-- SHAROPE KING - OFFICIAL VERSION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Variáveis de Estado
local states = {
    fly = false,
    flySpeed = 50,
    walkSpeed = 16,
    esp = false,
    minimizado = false
}

local bVelo, bGyro

-- Criar Interface
local sg = Instance.new("ScreenGui")
sg.Name = "SharopeKing"
sg.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false

-- Janela Principal
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 250, 0, 320)
main.Position = UDim2.new(0.5, -125, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Preto
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 0, 0) -- Vermelho

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
title.Text = "SHAROPE KING"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Botão Minimizar
local minBtn = Instance.new("TextButton", title)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn)

-- Container dos Botões
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Função para Criar Botão
local function createBtn(txt, callback)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(0, 220, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(100, 0, 0)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

-- 1. FUNÇÃO VOO
local flyB = createBtn("VOAR: OFF", function(self)
    states.fly = not states.fly
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if states.fly then
        self.Text = "VOAR: ON"
        self.TextColor3 = Color3.new(0,1,0)
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
            if bVelo then bVelo:Destroy() end
            if bGyro then bGyro:Destroy() end
        end)
    else
        self.Text = "VOAR: OFF"
        self.TextColor3 = Color3.new(1,1,1)
    end
end)

createBtn("VELO VOO +", function() states.flySpeed = states.flySpeed + 20 end)
createBtn("VELO VOO -", function() states.flySpeed = math.max(10, states.flySpeed - 20) end)

-- 2. FUNÇÃO CORRER
createBtn("CORRER +", function() 
    states.walkSpeed = states.walkSpeed + 20
    player.Character.Humanoid.WalkSpeed = states.walkSpeed
end)

createBtn("CORRER -", function() 
    states.walkSpeed = math.max(16, states.walkSpeed - 20)
    player.Character.Humanoid.WalkSpeed = states.walkSpeed
end)

-- 3. FUNÇÃO ESP ROSA
createBtn("ESP ROSA: OFF", function(self)
    states.esp = not states.esp
    self.Text = states.esp and "ESP ROSA: ON" or "ESP ROSA: OFF"
    self.TextColor3 = states.esp and Color3.fromRGB(255, 105, 180) or Color3.new(1,1,1)
end)

-- Loop do ESP
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local billboard = head:FindFirstChild("KingESP")
            if states.esp then
                if not billboard then
                    billboard = Instance.new("BillboardGui", head)
                    billboard.Name = "KingESP"
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255, 20, 147) -- Rosa Choque
                    label.TextStrokeTransparency = 0
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                    label.Text = p.Name
                end
            else
                if billboard then billboard:Destroy() end
            end
        end
    end
end)

-- Lógica Minimizar
minBtn.MouseButton1Click:Connect(function()
    states.minimizado = not states.minimizado
    content.Visible = not states.minimizado
    main:TweenSize(states.minimizado and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 320), "Out", "Quad", 0.3, true)
    minBtn.Text = states.minimizado and "+" or "-"
end)

print("SHAROPE KING CARREGADO!")
