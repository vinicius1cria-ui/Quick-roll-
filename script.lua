--[[
    KING V3 - ULTIMATE EDITION
    - AIMBOT: TODOS OS TIMES (AGRESSIVO 0.25)
    - ESP: BODY HIGHLIGHT ROXO (ALWAYS ON TOP)
    - UI: BOTÃO MINIMIZAR + ANTI-RESET (FICA AO MORRER)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local SMOOTHNESS = 0.25 
local minimized = false

-- COR RGB ROXA ESTILO GOJO
local function getPurpleRGB()
    local t = tick() * 2.5
    return Color3.fromHSV(0.78, 0.9, 0.4 + math.sin(t) * 0.6)
end

-- AIMBOT (FOCO EM TODOS)
local function getClosestPlayer()
    local target = nil
    local dist = 200
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
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
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), SMOOTHNESS)
        end
    end
end)

-- INTERFACE COM ANTI-RESET
if lp.PlayerGui:FindFirstChild("KingV3_Mobile") then lp.PlayerGui.KingV3_Mobile:Destroy() end
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Mobile"
sg.ResetOnSpawn = false -- ISSO FAZ O MENU CONTINUAR QUANDO MORRES

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 210)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
task.spawn(function()
    while main and main.Parent do
        stroke.Color = getPurpleRGB()
        task.wait(0.05)
    end
end)

-- TÍTULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "KING V3 RGB"
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

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    if minimized then
        main:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
        minBtn.Text = "+"
    else
        main:TweenSize(UDim2.new(0, 220, 0, 210), "Out", "Quad", 0.3, true)
        minBtn.Text = "-"
    end
end)

local function makeBtn(text, y, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

makeBtn("LOCK ALL: OFF", 10, function(self)
    _G.AimbotEnabled = not _G.AimbotEnabled
    self.Text = _G.AimbotEnabled and "LOCK ALL: ON" or "LOCK ALL: OFF"
    self.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 30, 35)
end)

makeBtn("BODY ESP: OFF", 60, function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "BODY ESP: ON" or "BODY ESP: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 30, 35)
end)

-- LOOP ESP DE CORPO
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
                hl.FillColor = getPurpleRGB()
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)
