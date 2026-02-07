--[[
    KING V3 - RGB EDITION
    - AIMBOT: SEMI-AGRESSIVO (0.25)
    - ESP: NOMES RGB ROXO
    - MENU: CONTORNO RGB + FOTO GOJO
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 
local SMOOTHNESS = 0.25
local minimized = false

-- FUNÇÃO RGB ROXO
local function getPurpleRGB()
    local t = tick() * 2.5
    local neonPurity = 0.4 + math.sin(t) * 0.6 
    return Color3.fromHSV(0.78, 0.9, neonPurity)
end

-- LÓGICA DO AIMBOT
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

-- INTERFACE
if lp.PlayerGui:FindFirstChild("KingV3_Mobile") then lp.PlayerGui.KingV3_Mobile:Destroy() end

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

local borderStroke = Instance.new("UIStroke", main)
borderStroke.Thickness = 3
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    while main and main.Parent do
        borderStroke.Color = getPurpleRGB()
        task.wait(0.05)
    end
end)

local icon = Instance.new("ImageLabel", main)
icon.Size = UDim2.new(0, 35, 0, 35)
icon.Position = UDim2.new(0, 10, 0, 5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://15115501179"
Instance.new("UICorner", icon)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -80, 0, 45)
title.Position = UDim2.new(0, 50, 0, 0)
title.Text = "KING V3 RGB"
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
minBtn.TextColor3 = Color3.new(1,1,1)
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
    self.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 30, 40)
end)

makeBtn("FULL ESP: OFF", UDim2.new(0.075, 0, 0.5, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "FULL ESP: ON" or "FULL ESP: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 30, 40)
    if _G.EspActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then
                task.spawn(function()
                    local char = p.Character or p.CharacterAdded:Wait()
                    local head = char:WaitForChild("Head", 5)
                    local bill = Instance.new("BillboardGui", head)
                    bill.Size = UDim2.new(0, 100, 0, 30)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    local lab = Instance.new("TextLabel", bill)
                    lab.Size = UDim2.new(1, 0, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Text = p.Name
                    lab.Font = Enum.Font.GothamBold
                    lab.TextSize = 14
                    while char and char.Parent and _G.EspActive do
                        lab.TextColor3 = getPurpleRGB()
                        task.wait(0.1)
                    end
                    bill:Destroy()
                end)
            end
        end
    end
end)
