--[[
    KING V3 - FINAL VERSION (SPEED/JUMP CONTROLS + DOUBLE JUMP FIX)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGURAÇÕES INICIAIS
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.JumpEnabled = false
_G.JumpValue = 50
_G.DoubleJumpEnabled = false
_G.EspActive = false

local hasDoubleJumped = false

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_Base") then lp.PlayerGui.KingV3_Base:Destroy() end

-- 2. INTERFACE (ANTI-RESET)
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Base"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 350)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(100, 0, 255)

-- BOTÃO MINIMIZAR
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minBtn)

local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.CanvasSize = UDim2.new(0, 0, 1.2, 0)
content.ScrollBarTransparency = 1

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main:TweenSize(minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 350), "Out", "Quad", 0.3, true)
    minBtn.Text = minimized and "+" or "-"
end)

-- FUNÇÃO CRIAR CONTROLE (TEXTO + BOTÕES +/-)
local function createControl(title, startY, varName, globalVar)
    local label = Instance.new("TextLabel", content)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, startY)
    label.Text = title .. ": " .. _G[globalVar]
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold

    local minus = Instance.new("TextButton", content)
    minus.Size = UDim2.new(0, 40, 0, 30)
    minus.Position = UDim2.new(0.1, 0, 0, startY + 25)
    minus.Text = "-"
    minus.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    minus.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", minus)

    local plus = Instance.new("TextButton", content)
    plus.Size = UDim2.new(0, 40, 0, 30)
    plus.Position = UDim2.new(0.7, 0, 0, startY + 25)
    plus.Text = "+"
    plus.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    plus.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", plus)

    minus.MouseButton1Click:Connect(function()
        _G[globalVar] = math.max(0, _G[globalVar] - 5)
        label.Text = title .. ": " .. _G[globalVar]
    end)
    plus.MouseButton1Click:Connect(function()
        _G[globalVar] = _G[globalVar] + 5
        label.Text = title .. ": " .. _G[globalVar]
    end)
    return startY + 65
end

-- FUNÇÃO CRIAR BOTÃO ON/OFF
local function createToggle(text, y, globalVar)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        btn.Text = text .. ": " .. (_G[globalVar] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[globalVar] and Color3.fromRGB(100,0,255) or Color3.fromRGB(30,30,40)
    end)
    return y + 45
end

-- 3. MONTAGEM DO MENU
local nextY = 10
nextY = createToggle("ATIVAR SPEED", nextY, "SpeedEnabled")
nextY = createControl("VELOCIDADE", nextY, "Speed", "SpeedValue")
nextY = createToggle("ATIVAR JUMP", nextY, "JumpEnabled")
nextY = createControl("PULO", nextY, "Jump", "JumpValue")
nextY = createToggle("PULO DUPLO", nextY, "DoubleJumpEnabled")
nextY = createToggle("ESP TODOS", nextY, "EspActive")

-- 4. LOGICA SPEED & JUMP
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if _G.SpeedEnabled then hum.WalkSpeed = _G.SpeedValue end
        if _G.JumpEnabled then 
            hum.UseJumpPower = true 
            hum.JumpPower = _G.JumpValue 
        end
    end
end)

-- 5. FIX PULO DUPLO (MOBILE & PC)
UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        local state = hum:GetState()
        if (state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping) and not hasDoubleJumped then
            hasDoubleJumped = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            -- Força um impulso para cima para o pulo duplo funcionar em qualquer jogo
            lp.Character.PrimaryPart.Velocity = Vector3.new(lp.Character.PrimaryPart.Velocity.X, _G.JumpValue, lp.Character.PrimaryPart.Velocity.Z)
        end
    end
end)

-- Reset do pulo duplo ao tocar o chão
RunService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if lp.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
            hasDoubleJumped = false
        end
    end
end)

-- 6. ESP LOGIC
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("KingHL")
            if _G.EspActive then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "KingHL" end
                hl.FillColor = Color3.fromRGB(100, 0, 255); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)
