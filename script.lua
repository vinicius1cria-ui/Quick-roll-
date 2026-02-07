--[[
    KING V3 - RECONSTRUÇÃO TOTAL (VISIBILIDADE GARANTIDA)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGURAÇÕES
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.JumpEnabled = false
_G.JumpValue = 50
_G.DoubleJumpEnabled = false
_G.EspActive = false
local hasDoubleJumped = false

-- 1. LIMPEZA TOTAL
if lp.PlayerGui:FindFirstChild("KingV3_Final") then lp.PlayerGui.KingV3_Final:Destroy() end

-- 2. TELA PRINCIPAL
local sg = Instance.new("ScreenGui")
sg.Name = "KingV3_Final"
sg.Parent = lp.PlayerGui
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 3. FRAME DO MENU
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Parent = sg
main.Size = UDim2.new(0, 240, 0, 380)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Draggable = true
main.ZIndex = 5

local corner = Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255)

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "KING V3 - REBORN"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.ZIndex = 6

-- 4. FUNÇÃO PARA CRIAR BOTÕES QUE APARECEM DE VERDADE
local function createToggle(txt, y, var)
    local btn = Instance.new("TextButton")
    btn.Name = txt .. "Btn"
    btn.Parent = main -- DIRETO NO MAIN
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 7
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.Text = txt .. ": " .. (_G[var] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(40, 40, 50)
    end)
    return y + 40
end

local function createAdjuster(txt, y, var)
    local label = Instance.new("TextLabel", main)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, y)
    label.Text = txt .. ": " .. _G[var]
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.ZIndex = 7

    local m = Instance.new("TextButton", main)
    m.Size = UDim2.new(0, 40, 0, 30)
    m.Position = UDim2.new(0.15, 0, 0, y + 20)
    m.Text = "-"
    m.ZIndex = 8
    Instance.new("UICorner", m)

    local p = Instance.new("TextButton", main)
    p.Size = UDim2.new(0, 40, 0, 30)
    p.Position = UDim2.new(0.7, 0, 0, y + 20)
    p.Text = "+"
    p.ZIndex = 8
    Instance.new("UICorner", p)

    m.MouseButton1Click:Connect(function() _G[var] = math.max(0, _G[var]-5) label.Text = txt .. ": " .. _G[var] end)
    p.MouseButton1Click:Connect(function() _G[var] = _G[var]+5 label.Text = txt .. ": " .. _G[var] end)
    return y + 55
end

-- 5. ORDEM DOS BOTÕES
local posY = 50
posY = createToggle("SPEED", posY, "SpeedEnabled")
posY = createAdjuster("VELOCIDADE", posY, "SpeedValue")
posY = createToggle("JUMP", posY, "JumpEnabled")
posY = createAdjuster("PULO", posY, "JumpValue")
posY = createToggle("DOUBLE JUMP", posY, "DoubleJumpEnabled")
posY = createToggle("ESP BRILHO", posY, "EspActive")

-- 6. LÓGICA (MESMA ANTERIOR, MAS ESTÁVEL)
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if _G.SpeedEnabled then hum.WalkSpeed = _G.SpeedValue end
        if _G.JumpEnabled then hum.UseJumpPower = true hum.JumpPower = _G.JumpValue end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if (hum:GetState() == Enum.HumanoidStateType.Freefall or hum:GetState() == Enum.HumanoidStateType.Jumping) and not hasDoubleJumped then
            hasDoubleJumped = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            lp.Character.PrimaryPart.Velocity = Vector3.new(lp.Character.PrimaryPart.Velocity.X, _G.JumpValue, lp.Character.PrimaryPart.Velocity.Z)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
        hasDoubleJumped = false
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("KingHL")
            if _G.EspActive then
                if not hl then hl = Instance.new("Highlight", p.Character) hl.Name = "KingHL" end
                hl.FillColor = Color3.fromRGB(130, 0, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            elseif hl then hl:Destroy() end
        end
    end
end)
