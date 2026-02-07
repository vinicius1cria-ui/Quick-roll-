--[[
    KING V3 - FULL BODY ESP (RGB EDITION)
    - Aimbot: Semi-Agressivo (0.25)
    - ESP: Nomes RGB + Contorno de Corpo (Highlight Neon)
    - UI: Menu RGB + Foto Gojo
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

-- FUNÇÃO RGB ROXO DINÂMICO
local function getPurpleRGB()
    local t = tick() * 2.5
    local intensity = 0.4 + math.sin(t) * 0.6 
    return Color3.fromHSV(0.78, 0.9, intensity)
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

-- BOTÕES E FUNÇÕES
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1

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

makeBtn("BODY ESP: OFF", UDim2.new(0.075, 0, 0.5, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "BODY ESP: ON" or "BODY ESP: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(30, 30, 40)
end)

-- LOOP DO ESP (NOME + CORPO)
RunService.Heartbeat:Connect(function()
    if _G.EspActive then
        local color = getPurpleRGB()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                -- 1. EFEITO NO CORPO (Highlight)
                local hl = p.Character:FindFirstChild("KingHL") or Instance.new("Highlight", p.Character)
                hl.Name = "KingHL"
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.FillColor = color
                hl.OutlineColor = color
                hl.Enabled = true

                -- 2. NOME ACIMA DA CABEÇA
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local bill = head:FindFirstChild("KingName") or Instance.new("BillboardGui", head)
                    bill.Name = "KingName"
                    bill.Size = UDim2.new(0, 100, 0, 30)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    
                    local lab = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel", bill)
                    lab.Size = UDim2.new(1, 0, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Text = p.Name
                    lab.Font = Enum.Font.GothamBold
                    lab.TextSize = 14
                    lab.TextColor3 = color
                    lab.Enabled = true
                end
            end
        end
    else
        -- Remove o ESP quando desligado
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                if p.Character:FindFirstChild("KingHL") then p.Character.KingHL:Destroy() end
                if p.Character:FindFirstChild("
                            
