--[[
    KING V3 - MOBILE SHIFT-LOCK (NO FOV VERSION)
    - Aimbot: Camera Lock-on (Sem Bola Roxa)
    - Anti-AFK: Ativo
    - ESP: Neon
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 -- Distância da trava (invisível)

-- 1. FUNÇÃO DE BUSCA DO ALVO
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

-- 2. LOOP DE TRAVA (SEM DESENHO NA TELA)
RunService.Heartbeat:Connect(function()
    if _G.AimbotEnabled then
        local targetHead = getClosestPlayer()
        if targetHead then
            -- Força a mira na cabeça ignorando o Shift Lock
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- 3. INTERFACE KING V3
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3Mobile"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 200, 0, 180)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(138, 43, 226)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "KING V3 - CLEAN"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton", main)
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

createBtn("LOCK AIMBOT: OFF", UDim2.new(0.075, 0, 0.3, 0), function(self)
    _G.AimbotEnabled = not _G.AimbotEnabled
    self.Text = _G.AimbotEnabled and "LOCK AIMBOT: ON" or "LOCK AIMBOT: OFF"
    self.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
end)

createBtn("ESP NEON: OFF", UDim2.new(0.075, 0, 0.6, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "ESP NEON: ON" or "ESP NEON: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
end)

-- 4. LOOP ESP
task.spawn(function()
    while task.wait(1) do
        if _G.EspActive then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hl = p.Character:FindFirstChild("KingHighlight") or Instance.new("Highlight", p.Character)
                    hl.Name = "KingHighlight"
                    hl.FillColor = (p.Team == lp.Team) and Color3.new(0,1,1) or Color3.fromRGB(138, 43, 226)
                    hl.FillTransparency = 0.5
                end
            end
        end
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)
