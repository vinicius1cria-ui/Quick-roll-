--[[
    KING V3 - ULTIMATE SMOOTH & VISUAL ESP
    - Aimbot: Smooth Lock (Suave para trocar de alvo)
    - ESP: Nomes Reais + Barra de Vida Colorida + Neon
    - UI: Gojo + Minimizar
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 
local SMOOTHNESS = 0.15 -- Ajuste entre 0.1 e 0.3 para não ficar "preso"
local minimized = false

-- 1. LIMPEZA DE GUI ANTIGA
if lp.PlayerGui:FindFirstChild("KingV3_Mobile") then
    lp.PlayerGui.KingV3_Mobile:Destroy()
end

-- 2. LÓGICA DO AIMBOT SUAVE
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Team ~= lp.Team and v.Character and v.Character:FindFirstChild("Head") then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if mouseDist < dist then
                        target = v.Character.Head
                        dist = mouseDist
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local targetHead = getClosestPlayer()
        if targetHead then
            local targetPos = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, SMOOTHNESS)
        end
    end
end)

-- 3. FUNÇÃO DE ESP (NOME REAL E BARRA DE VIDA)
local function createESP(player)
    local function apply()
        local char = player.Character or player.CharacterAdded:Wait()
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        if head:FindFirstChild("KingVisualESP") then head.KingVisualESP:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "KingVisualESP"
        bill.Size = UDim2.new(0, 100, 0, 60)
        bill.StudsOffset = Vector3.new(0, 3, 0)
        bill.AlwaysOnTop = true
        
        -- Nome do Jogador
        local nameLabel = Instance.new("TextLabel", bill)
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name -- AGORA MOSTRA O NOME REAL
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 12
        nameLabel.TextStrokeTransparency = 0

        -- Fundo da Barra de Vida
        local healthBack = Instance.new("Frame", bill)
        healthBack.Size = UDim2.new(0.8, 0, 0, 5)
        healthBack.Position = UDim2.new(0.1, 0, 0.4, 0)
        healthBack.BackgroundColor3 = Color3.new(0, 0, 0)
        healthBack.BorderSizePixel = 0

        -- Barra de Vida Atual
        local healthBar = Instance.new("Frame", healthBack)
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
        healthBar.BorderSizePixel = 0

        task.spawn(function()
            while char and char:Parent() and _G.EspActive do
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
                    -- Muda cor: Verde -> Amarelo -> Vermelho
                    healthBar.BackgroundColor3 = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                end
                task.wait(0.2)
            end
            bill:Destroy()
        end)
    end
    apply()
    player.CharacterAdded:Connect(apply)
end

-- 4. INTERFACE KING V3
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Mobile"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 210)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(138, 43, 226)

-- Foto Gojo
local icon = Instance.new("ImageLabel", main)
icon.Size = UDim2.new(0, 35, 0, 35)
icon.Position = UDim2.new(0, 10, 0, 5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://15115501179"
Instance.new("UICorner", icon)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -80, 0, 45)
title.Position = UDim2.new(0, 50, 0, 0)
title.Text = "KING V3"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 7)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minBtn.TextColor3 = Color3.fromRGB(138, 43, 226)
minBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minBtn)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main:TweenSize(minimized and UDim2.new(0, 220, 0, 45) or UDim2.new(0, 220, 0, 210), "Out", "Quad", 0.3, true)
    content.Visible = not minimized
    minBtn.Text = minimized and "+" or "-"
end)

local function makeBtn(text, pos, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

makeBtn("LOCK AIMBOT: OFF", UDim2.new(0.075, 0, 0.1, 0), function(self)
    _G.AimbotEnabled = not _G.AimbotEnabled
    self.Text = _G.AimbotEnabled and "LOCK AIMBOT: ON" or "LOCK AIMBOT: OFF"
    self.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
end)

makeBtn("FULL ESP: OFF", UDim2.new(0.075, 0, 0.5, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "FULL ESP: ON" or "FULL ESP: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
    if _G.EspActive then
        for _, p in pairs(Players:GetPlayers()) do if p ~= lp then createESP(p) end end
    end
end)

-- Loop Highlight Neon
task.spawn(function()
    while task.wait(1) do
        if _G.EspActive then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hl = p.Character:FindFirstChild("KingHL") or Instance.new("Highlight", p.Character)
                    hl.Name = "KingHL"
                    hl.FillColor = (p.Team == lp.Team) and Color3.new(0,1,1) or Color3.fromRGB(138, 43, 226)
                    hl.FillTransparency = 0.5
                end
            end
        end
    end
end)
