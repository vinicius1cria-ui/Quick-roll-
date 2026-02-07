--[[
    KING V3 - FULL ESP & LOCK (MOBILE)
    - Aimbot: Invisible Lock
    - ESP: Neon + Nome + Vida (HP)
    - Tema: Gojo Satoru / Vazio Roxo
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 
local minimized = false

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

RunService.Heartbeat:Connect(function()
    if _G.AimbotEnabled then
        local targetHead = getClosestPlayer()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- 2. FUNÇÃO PARA CRIAR NOME E VIDA (TEXT ESP)
local function createTextESP(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 5)
    if not head then return end

    -- Remove antigo se existir
    if head:FindFirstChild("KingTextESP") then head.KingTextESP:Destroy() end

    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "KingTextESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0

    -- Atualização em Tempo Real (Vida e Distância)
    task.spawn(function()
        while char and char:Parent() and _G.EspActive do
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local hp = math.floor(hum.Health)
                textLabel.Text = string.format("%s\n[HP: %d]", player.Name, hp)
                
                -- Cor do texto baseada na vida
                if hp > 50 then textLabel.TextColor3 = Color3.new(0, 1, 0) -- Verde
                elseif hp > 20 then textLabel.TextColor3 = Color3.new(1, 0.5, 0) -- Laranja
                else textLabel.TextColor3 = Color3.new(1, 0, 0) end -- Vermelho
            end
            task.wait(0.1)
        end
        billboard:Destroy()
    end)
end

-- 3. INTERFACE KING V3
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "King v7"
sg.
