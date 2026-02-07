--[[
    KING V3 - PRISON LIFE EDITION
    - ESP Neon & Anti-AFK
    - Aimbot Smooth (Anti-Ban)
    - Tema Gojo Satoru
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Mouse = lp:GetMouse()
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")

_G.EspActive = false
_G.AimbotEnabled = false
local FOV = 120 -- Tamanho do círculo da mira

-- 1. INTERFACE
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 250)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(138, 43, 226)

-- TÍTULO E ÍCONE
local icon = Instance.new("ImageLabel", main)
icon.Size = UDim2.new(0, 35, 0, 35)
icon.Position = UDim2.new(0, 10, 0, 5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://15115501179"
Instance.new("UICorner", icon)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 50, 0, 0)
title.Text = "KING V3"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1

-- 2. CÍRCULO DO FOV (NEON ROXO)
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 64
fov_circle.Radius = FOV
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.Color = Color3.fromRGB(138, 43, 226)

-- 3. FUNÇÃO AIMBOT
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = FOV

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Team ~= lp.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    closest = v
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    if _G.AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            -- MIRA SUAVE (Smoothing) para evitar ban
            local cam = workspace.CurrentCamera
            local targetPos = cam:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            mousemoverel((targetPos.X - Mouse.X) * 0.25, (targetPos.Y - Mouse.Y) * 0.25)
        end
    end
end)

-- 4. BOTÕES
local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

createBtn("AIMBOT: OFF", UDim2.new(0.075, 0, 0.05, 0), function(self)
    _G.AimbotEnabled = not _G.AimbotEnabled
    fov_circle.Visible = _G.AimbotEnabled
    self.Text = _G.AimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    self.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
end)

createBtn("ESP NEON: OFF", UDim2.new(0.075, 0, 0.25, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "ESP NEON: ON" or "ESP NEON: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
end)

-- Botão Minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 7)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(138, 43, 226)
minBtn.BackgroundTransparency = 1
minBtn.TextSize = 25
minBtn.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
    main:TweenSize(content.Visible and UDim2.new(0, 220, 0, 250) or UDim2.new(0, 220, 0, 45), "Out", "Quad", 0.3, true)
    minBtn.Text = content.Visible and "-" or "+"
end)

-- Loop ESP e Anti-AFK
task.spawn(function()
    while task.wait(0.5) do
        if _G.EspActive then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hl = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    hl.FillColor = (p.Team == lp.Team) and Color3.new(0,1,1) or Color3.fromRGB(138, 43, 226)
                    hl.FillTransparency = 0.5
                end
            end
        end
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end
end)
