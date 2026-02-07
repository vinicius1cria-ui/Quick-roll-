--[[
    KING V3 - FIX TOTAL (BOTÕES VISÍVEIS)
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

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_Fixed") then lp.PlayerGui.KingV3_Fixed:Destroy() end

-- 2. INTERFACE
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Fixed"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 230, 0, 360) -- Tamanho fixo garantido
main.Position = UDim2.new(0.1, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(100, 0, 255)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "KING V3 - CONTROLS"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

-- 3. FUNÇÃO CRIAR BOTÕES DE AJUSTE (VISÍVEIS)
local function createAdjuster(text, y, varName)
    local label = Instance.new("TextLabel", main)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, y)
    label.Text = text .. ": " .. _G[varName]
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12

    local btnMinus = Instance.new("TextButton", main)
    btnMinus.Size = UDim2.new(0, 35, 0, 30)
    btnMinus.Position = UDim2.new(0.15, 0, 0, y + 20)
    btnMinus.Text = "-"
    btnMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btnMinus.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btnMinus)

    local btnPlus = Instance.new("TextButton", main)
    btnPlus.Size = UDim2.new(0, 35, 0, 30)
    btnPlus.Position = UDim2.new(0.7, 0, 0, y + 20)
    btnPlus.Text = "+"
    btnPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btnPlus.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btnPlus)

    btnMinus.MouseButton1Click:Connect(function()
        _G[varName] = math.max(0, _G[varName] - 5)
        label.Text = text .. ": " .. _G[varName]
    end)
    btnPlus.MouseButton1Click:Connect(function()
        _G[varName] = _G[varName] + 5
        label.Text = text .. ": " .. _G[varName]
    end)
    return y + 55
end

local function createToggle(text, y, varName)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. ": " .. (_G[varName] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(100, 0, 255) or Color3.fromRGB(30, 30, 40)
    end)
    return y + 40
end

-- 4. POSICIONAMENTO DOS ITENS
local currentY = 50
currentY = createToggle("SPEED", currentY, "SpeedEnabled")
currentY = createAdjuster("VELOCIDADE", currentY, "SpeedValue")
currentY = createToggle("JUMP", currentY, "JumpEnabled")
currentY = createAdjuster("PULO", currentY, "JumpValue")
currentY = createToggle("DOUBLE JUMP", currentY, "DoubleJumpEnabled")
currentY = createToggle("ESP ALL", currentY, "EspActive")

-- 5. LÓGICA DE MOVIMENTO E ESP
RunService.Stepped:Connect(function()
    if lp.
            
