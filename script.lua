--[[
    KING V3 - FIX DEFINITIVO (BOTÃO MINIMIZAR VISÍVEL)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGS
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.JumpEnabled = false
_G.JumpValue = 50
_G.DoubleJumpEnabled = false
_G.EspActive = false
local hasDoubleJumped = false
local minimized = false

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_Final") then lp.PlayerGui.KingV3_Final:Destroy() end

-- 2. TELA
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Final"
sg.ResetOnSpawn = false

-- 3. FRAME PRINCIPAL
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 240, 0, 380)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
main.ZIndex = 10 -- Base
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255)

-- BOTÃO MINIMIZAR (FORÇADO NO TOPO)
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 35, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0, 5)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255) -- Roxo para destacar
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.ZIndex = 100 -- Nível máximo para nunca ficar atrás de nada
Instance.new("UICorner", minBtn)

-- CONTAINER DOS BOTÕES
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.ZIndex = 11

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    if minimized then
        main:TweenSize(UDim2.new(0, 240, 0, 45), "Out", "Quad", 0.3, true)
        minBtn.Text = "+"
    else
        main:TweenSize(UDim2.new(0, 240, 0, 380), "Out", "Quad", 0.3, true)
        minBtn.Text = "—"
    end
end)

-- TÍTULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "KING V3 REBORN"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

-- 4. FUNÇÕES DE INTERFACE
local function createToggle(txt, y, var)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 15
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.Text = txt .. ": " .. (_G[var] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(35, 35, 45)
    end)
    return y + 40
end

local function createAdjuster(txt, y, var)
    local label = Instance.new("TextLabel", content)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, y)
    label.Text = txt .. ": " .. _G[var]
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.ZIndex = 15

    local m = Instance.new("TextButton", content)
    m.Size = UDim2.new(0, 45, 0, 30)
    m.Position = UDim2.new(0.15, 0, 0, y + 25)
    m.Text = "-"
    m.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    m.TextColor3 = Color3.new(1,1,1)
    m.ZIndex = 16
    Instance.new("UICorner", m)

    local p = Instance.new("TextButton", content)
    p.Size = UDim2.new(0, 45, 0, 30)
    p.Position = UDim2.new(0.7, 0, 0, y + 25)
    p.Text = "+"
    p.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    p.TextColor3 = Color3.new(1,1,1)
    p.ZIndex = 16
    Instance.new("UICorner", p)

    m.MouseButton1Click:Connect(function() _G[var] = math.max(0, _G[var]-5) label.Text = txt .. ": " .. _G[var] end)
    p.MouseButton1Click:Connect(function() _G[var] = _G[var]+5 label.Text = txt .. ": " .. _G[var] end)
    return y + 60
end

-- ORDEM DOS BOTÕES
local posY = 10
posY = createToggle("SPEED", posY, "SpeedEnabled")
posY = createAdjuster("VELOCIDADE", posY, "SpeedValue")
posY = createToggle("JUMP", posY, "JumpEnabled")
posY = createAdjuster("PULO", posY, "JumpValue")
posY = createToggle("DOUBLE JUMP", posY, "DoubleJumpEnabled")
posY = createToggle("ESP ALL", posY, "EspActive")

-- 5. LÓGICA (SPEED/JUMP/ESP)
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if _G.SpeedEnabled then hum.WalkSpeed = _G.SpeedValue end
        if _G.JumpEnabled then hum.UseJumpPower = true hum.JumpPower = _G.JumpValue end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum and (hum:GetState() == Enum.HumanoidStateType.Freefall or hum:GetState() == Enum.HumanoidStateType.Jumping) and not hasDoubleJumped then
            hasDoubleJumped = true
            local v = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
            v.Velocity = Vector3.new(0, _G.JumpValue * 1.25, 0)
            v.MaxForce = Vector3.new(0, 99999, 0)
            task.wait(0.15)
            v:Destroy()
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        if lp.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
            hasDoubleJumped = false
        end
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
