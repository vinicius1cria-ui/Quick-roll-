--[[
    KING V3 - PURPLE RGB (SEMI-AGRESSIVE)
    - Aimbot: Smooth Lock-on (Mais Rápido / 0.25)
    - ESP: Nomes RGB Roxo Dinâmico
    - UI: Menu RGB Animado + Gojo
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 
local SMOOTHNESS = 0.25 -- Aumentado de 0.15 para 0.25 (Mais agressivo)
local minimized = false

-- 1. LIMPEZA DE GUI ANTIGA
if lp.PlayerGui:FindFirstChild("KingV3_Mobile") then
    lp.PlayerGui.KingV3_Mobile:Destroy()
end

-- 2. FUNÇÃO RGB ROXO (DINÂMICO)
local function getPurpleRGB()
    local t = tick() * 2.5 -- Velocidade da animação
    local neonPurity = 0.4 + math.sin(t) * 0.6 
    return Color3.fromHSV(0.78, 0.9, neonPurity)
end

-- 3. LÓGICA DO AIMBOT
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
            -- Interpolação mais rápida para o alvo
            local targetPos = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, SMOOTHNESS)
        end
    end
end)

-- 4. ESP (NOMES RGB ROXO)
local function createESP(player)
    local function apply()
        local char = player.Character or player.CharacterAdded:Wait()
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        if head
            
