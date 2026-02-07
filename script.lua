--[[
    KING V3 - REBORN (MINIMIZAR + DOUBLE JUMP FORÇADO)
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
local minimized = false

-- 1. LIMPEZA TOTAL
if lp.PlayerGui:FindFirstChild("KingV3_Final") then lp.PlayerGui.KingV3_Final:Destroy() end

-- 2. TELA PRINCIPAL
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Final"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 3. FRAME DO MENU
local main = Instance.new("Frame", sg)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 240, 0, 380)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Draggable = true
main.ZIndex = 5
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255)

-- CONTAINER DOS BOTÕES (Para sumir ao minimizar)
local content = Instance.new("Frame", main)
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.ZIndex = 6

-- TÍTULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "KING V3 - REBORN"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1
title.ZIndex = 7
title.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÃO MINIMIZAR
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.ZIndex = 8
Instance.new("UICorner", minBtn)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    if minimized then
        main:TweenSize(UDim2.new(0, 240, 0, 40), "Out", "Quad", 0.3, true)
        minBtn.Text = "+"
    else
        main:TweenSize(UDim2.new(0, 240, 0, 380), "Out", "Quad", 0.3, true)
        minBtn.Text = "—"
    end
end)

-- 4. FUNÇÕES DE INTERFACE
local function createToggle(txt, y, var)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
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
    local label = Instance.new("TextLabel", content)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, y)
    label.Text = txt .. ": " .. _G[var]
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.ZIndex = 7

    local m = Instance.new("TextButton", content)
    m.Size = UDim2.new(0, 40, 0, 30)
    m.Position = UDim2.new(0.15, 0, 0, y + 20)
    m.Text = "-"
    m.ZIndex = 8
    Instance.new("UICorner", m)

    local p = Instance.new("TextButton", content)
    p.Size = UDim2.new(0, 40, 0, 30)
    p.Position = UDim2.new(0.7, 0, 0, y + 20)
    p.Text = "+"
    p.ZIndex = 8
    Instance.new("UICorner", p)

    m.MouseButton1Click:Connect(function() _G[var] = math.max(0, _G[var]-5) label.Text = txt .. ": " .. _G[var] end)
    p.MouseButton1Click:Connect(function() _G[var] = _G[var]+5 label.Text = txt .. ": " .. _G[var] end)
    return y + 55
end

-- ORDEM DOS BOTÕES
local posY = 10
posY = createToggle("SPEED", posY, "SpeedEnabled")
posY = createAdjuster("VELOCIDADE", posY, "SpeedValue")
posY = createToggle("JUMP", posY, "JumpEnabled")
posY = createAdjuster("PULO", posY, "JumpValue")
posY = createToggle("DOUBLE JUMP", posY, "DoubleJumpEnabled")
posY = createToggle("ESP ALL", posY, "EspActive")

-- 5. LÓGICA SPEED & JUMP
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if _G.SpeedEnabled then hum.WalkSpeed = _G.SpeedValue end
        if _G.JumpEnabled then hum.UseJumpPower = true hum.JumpPower = _G.JumpValue end
    end
end)

-- 6. LÓGICA DOUBLE JUMP (VERSÃO MOBILE FORÇADA)
UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum and (hum:GetState() == Enum.HumanoidStateType.Freefall or hum:GetState() == Enum.HumanoidStateType.Jumping) and not hasDoubleJumped then
            hasDoubleJumped = true
            
            -- Cria um impulso físico temporário para garantir o pulo
            local vel = Instance.new("BodyVelocity")
            vel.Velocity = Vector3.new(0, _G.JumpValue * 1.2, 0)
            vel.MaxForce = Vector3.new(0, 99999, 0)
            vel.Parent = lp.Character.HumanoidRootPart
            task.wait(0.15)
            vel:Destroy()
        end
    end
end)

-- Reset do Double Jump
RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        if lp.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
            hasDoubleJumped = false
        end
    end
    -- ESP LOGIC
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
