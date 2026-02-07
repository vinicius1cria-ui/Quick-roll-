local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local SMOOTHNESS = 0.25 

-- COR RGB ROXA ESTILO GOJO
local function getPurpleRGB()
    local t = tick() * 2.5
    return Color3.fromHSV(0.78, 0.9, 0.4 + math.sin(t) * 0.6)
end

-- AIMBOT
local function getClosestPlayer()
    local target = nil
    local dist = 150
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
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), SMOOTHNESS)
        end
    end
end)

-- INTERFACE
if lp.PlayerGui:FindFirstChild("KingV3_Mobile") then lp.PlayerGui.KingV3_Mobile:Destroy() end
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Mobile"

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

local function makeBtn(text, y, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

makeBtn("LOCK AIMBOT: OFF", 50, function(self)
    _G.AimbotEnabled = not _G.AimbotEnabled
    self.Text = _G.AimbotEnabled and "LOCK AIMBOT: ON" or "LOCK AIMBOT: OFF"
end)

makeBtn("BODY ESP: OFF", 110, function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "BODY ESP: ON" or "BODY ESP: OFF"
end)

-- LOOP ESP DE CORPO (HIGHLIGHT)
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
                hl.OutlineColor = Color3.new(1,1,1)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)
