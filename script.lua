--[[
    HADES RNG - GOJO EDITION HUB (VERSÃO CORRIGIDA)
    - ESP não some ao morrer
    - Botão Ligar/Desligar funcionando
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")

-- VARIÁVEIS DE CONTROLE
_G.Rolling = false
_G.EspActive = false

-- 1. INTERFACE
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "GojoHub"
sg.ResetOnSpawn = false -- Para o menu não sumir quando VOCÊ morrer

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 280)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(138, 43, 226)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "PURPLE HUB v2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- 2. FUNÇÃO PARA CRIAR HIGHLIGHT (O ESP)
local function applyHighlight(player)
    local function create()
        local char = player.Character or player.CharacterAdded:Wait()
        if not char then return end
        
        -- Remove antigo se existir
        local old = char:FindFirstChild("GojoHighlight")
        if old then old:Destroy() end
        
        if _G.EspActive then
            local hl = Instance.new("Highlight")
            hl.Name = "GojoHighlight"
            hl.Parent = char
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            
            -- Cor por Time
            if player.Team == lp.Team then
                hl.FillColor = Color3.fromRGB(0, 255, 255) -- Azul Aliado
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                hl.FillColor = Color3.fromRGB(138, 43, 226) -- Roxo Inimigo
                hl.OutlineColor = Color3.fromRGB(255, 0, 255)
            end
        end
    end
    create()
    player.CharacterAdded:Connect(create) -- REAPLICA QUANDO MORRER
end

-- 3. BOTÕES
local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- Botão Quick Roll
createBtn("QUICK ROLL: OFF", UDim2.new(0.1, 0, 0.2, 0), function(self)
    _G.Rolling = not _G.Rolling
    self.Text = _G.Rolling and "QUICK ROLL: ON" or "QUICK ROLL: OFF"
    self.BackgroundColor3 = _G.Rolling and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 50)
end)

-- Botão ESP (COM FIX)
createBtn("ESP NEON: OFF", UDim2.new(0.1, 0, 0.4, 0), function(self)
    _G.EspActive = not _G.EspActive
    self.Text = _G.EspActive and "ESP NEON: ON" or "ESP NEON: OFF"
    self.BackgroundColor3 = _G.EspActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(40, 40, 50)
    
    -- Atualiza todo mundo na hora
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then applyHighlight(p) end
    end
end)

-- 4. LOGICA DE BACKGROUND E ATUALIZAÇÃO
task.spawn(function()
    -- Ativa o sistema de detecção de personagens para quem entra
    Players.PlayerAdded:Connect(applyHighlight)
    
    while task.wait(0.5) do
        -- Anti-AFK
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
        
        -- Roll Automático
        if _G.Rolling then
            local remote = RS:FindFirstChild("Roll", true) or RS:FindFirstChild("RemoteEvent", true)
            if remote then remote:FireServer() end
        end
    end
end)

print("Hub v2 Atualizado! ESP corrigido.")
