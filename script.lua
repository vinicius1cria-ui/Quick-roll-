--[[
    KING V3 - FULL FIXED (MOBILE)
    - Correção: Menu Invisível / Conflito de GUI
    - Funções: Lock Aimbot (Clean) + ESP Full (Nome/HP)
    - Tema: Gojo Satoru
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 
local minimized = false

-- 1. LIMPEZA DE GUIS ANTIGAS (Para não bugar)
if lp.PlayerGui:FindFirstChild("KingV3Mobile") then
    lp.PlayerGui.KingV3Mobile:Destroy()
end

-- 2. FUNÇÃO DE BUSCA (LOCK-ON)
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

RunService.Heartbeat:Connect(function()
    if _G.AimbotEnabled then
        local targetHead = getClosestPlayer()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- 3. INTERFACE (REFEITA PARA NÃO SUMIR)
local sg = Instance.new("ScreenGui")
sg.Name = "KingV3Mobile"
sg.Parent = lp.PlayerGui
sg.ResetOnSpawn = false
sg.Enabled = true -- Garante que está ligado

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 210)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(138, 43, 226)

-- FOTO E TÍTULO
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

-- BOTÃO MINIMIZAR
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

-- FUNÇÃO ESP TEXTO (NOME/HP)
local function createTextESP(player)
    local function apply()
        local char = player.Character or player.CharacterAdded:Wait()
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        if head:FindFirstChild("KingTextESP") then head.KingTextESP:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "KingTextESP"
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.StudsOffset = Vector3.new(0, 3, 0)
        bill.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextStrokeTransparency = 0

        task.spawn(function()
            while char and char:Parent() and _G.EspActive do
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local hp = math.floor(hum.Health)
                    label.Text = string.format("%s\n%d HP", player.Name, hp)
                    label.TextColor3 = hp > 50 and Color3.new(0,1,0) or (hp > 20 and Color3.new(1,0.5,0) or Color3.new(1,0,0))
                end
                task.wait(0.2)
            end
            bill:Destroy()
        end)
    end
    apply()
    player.CharacterAdded:Connect(apply)
end

-- 4. BOTÕES DO MENU
local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

createBtn("LOCK AIMBOT: OFF", UDim2.new(0.075, 0, 0.1, 0), function(self)
    _G.AimbotEnabled = not _G.AimbotEnabled
    self.Text = _G.AimbotEnabled and "LOCK AIMBOT: ON" or "LOCK AIMBOT: OFF"
    self.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
end)

createBtn("FULL ESP: OFF", UDim2.new(0.075, 0, 0.45, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "FULL ESP: ON" or "FULL ESP: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
    
    if _G.EspActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then createTextESP(p) end
        end
    end
end)

-- LOOP HIGHLIGHTS
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
