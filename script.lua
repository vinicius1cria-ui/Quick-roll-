--[[
    KING V3 - BASE ZERO + SPEED + JUMP + ESP
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGURAÇÕES
_G.SpeedEnabled = false
_G.SpeedValue = 50
_G.JumpEnabled = false
_G.JumpValue = 100
_G.DoubleJumpEnabled = false
_G.EspActive = false

-- Variáveis de controle para o pulo duplo
local canDoubleJump = false
local hasDoubleJumped = false

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_Base") then lp.PlayerGui.KingV3_Base:Destroy() end

-- 2. INTERFACE (ANTI-RESET)
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Base"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 310) -- Aumentado para caber mais botões
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(100, 0, 255)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "KING V3 - MULTI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÃO MINIMIZAR
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minBtn)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main:TweenSize(minimized and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 310), "Out", "Quad", 0.3, true)
    minBtn.Text = minimized and "+" or "-"
end)

-- FUNÇÃO CRIAR BOTÃO
local function createBtn(text, y, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- 3. LOGICA SPEED & JUMP
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        -- Speed
        if _G.SpeedEnabled then hum.WalkSpeed = _G.SpeedValue else hum.WalkSpeed = 16 end
        -- Jump Power
        if _G.JumpEnabled then 
            hum.UseJumpPower = true 
            hum.JumpPower = _G.JumpValue 
        else 
            hum.JumpPower = 50 
        end
    end
end)

-- 4. LOGICA DOUBLE JUMP
UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if hum:GetState() == Enum.HumanoidStateType.Freefall and not hasDoubleJumped then
            hasDoubleJumped = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

lp.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            hasDoubleJumped = false
        end
    end)
end)

-- 5. LOGICA ESP ALL TEAMS
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local char = p.Character
            local hl = char:FindFirstChild("KingHL")
            if _G.EspActive then
                if not hl then
                    hl = Instance.new("Highlight", char)
                    hl.Name = "KingHL"
                end
                hl.FillColor = Color3.fromRGB(100, 0, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- 6. BOTÕES
createBtn("SPEED: OFF", 10, function(btn)
    _G.SpeedEnabled = not _G.SpeedEnabled
    btn.Text = _G.SpeedEnabled and "SPEED: ON" or "SPEED: OFF"
    btn.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(100,0,255) or Color3.fromRGB(30,30,40)
end)

createBtn("JUMP POWER: OFF", 60, function(btn)
    _G.JumpEnabled = not _G.JumpEnabled
    btn.Text = _G.JumpEnabled and "JUMP POWER: ON" or "JUMP POWER: OFF"
    btn.BackgroundColor3 = _G.JumpEnabled and Color3.fromRGB(100,0,255) or Color3.fromRGB(30,30,40)
end)

createBtn("DOUBLE JUMP: OFF", 110, function(btn)
    _G.DoubleJumpEnabled = not _G.DoubleJumpEnabled
    btn.Text = _G.DoubleJumpEnabled and "DOUBLE JUMP: ON" or "DOUBLE JUMP: OFF"
    btn.BackgroundColor3 = _G.DoubleJumpEnabled and Color3.fromRGB(100,0,255) or Color3.fromRGB(30,30,40)
end)

createBtn("ESP ALL TEAMS: OFF", 160, function(btn)
    _G.EspActive = not _G.EspActive
    btn.Text = _G.EspActive and "ESP: ON" or "ESP: OFF"
    btn.BackgroundColor3 = _G.EspActive and Color3.fromRGB(100,0,255) or Color3.fromRGB(30,30,40)
end)
