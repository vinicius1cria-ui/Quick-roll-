--[[
    KING V3 - ESP PRO (JOGADORES + MONSTROS)
    Com Botão Minimizar e Toggles ON/OFF
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ESTADO INICIAL (TUDO DESLIGADO)
_G.EspPlayers = false
_G.EspMobs = false

-- 1. LIMPEZA DE SCRIPTS ANTIGOS
if lp.PlayerGui:FindFirstChild("KingV3_ESP") then lp.PlayerGui.KingV3_ESP:Destroy() end

-- 2. TELA (SCREEN GUI)
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_ESP"
sg.ResetOnSpawn = false

-- 3. MENU PRINCIPAL
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 240, 0, 180)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true -- Podes arrastar o menu pelo ecrã
main.ZIndex = 10
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255) -- Borda Roxa

-- 4. BOTÃO MINIMIZAR (— / +)
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 35, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0, 5)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.ZIndex = 100
Instance.new("UICorner", minBtn)

-- CONTAINER PARA OS BOTÕES (CONTENT)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.ZIndex = 11

-- LÓGICA DO BOTÃO MINIMIZAR
minBtn.MouseButton1Click:Connect(function()
    local isExpanded = (main.Size.Y.Offset > 50)
    if isExpanded then
        main:TweenSize(UDim2.new(0, 240, 0, 45), "Out", "Quad", 0.3, true)
        minBtn.Text = "+"
        content.Visible = false
    else
        main:TweenSize(UDim2.new(0, 240, 0, 180), "Out", "Quad", 0.3, true)
        minBtn.Text = "—"
        content.Visible = true
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "KING V3 - ESP"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

-- 5. FUNÇÃO PARA CRIAR BOTÕES DE ATIVAR/DESATIVAR
local function createToggle(txt, y, varName)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 15
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        if _G[varName] then
            btn.Text = txt .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(130, 0, 255) -- Fica roxo quando liga
        else
            btn.Text = txt .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40) -- Fica cinza quando desliga
        end
    end)
    return y + 45
end

-- CRIA OS BOTÕES NO MENU
createToggle("ESP JOGADORES", 10, "EspPlayers")
createToggle("ESP MONSTROS", 60, "EspMobs")

-- 6. LÓGICA DO ESP (RODANDO EM BACKGROUND)
RunService.Heartbeat:Connect(function()
    -- ESP PARA JOGADORES
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("PlayerHL")
            if _G.EspPlayers then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "PlayerHL"
                    hl.FillColor = Color3.fromRGB(130, 0, 255)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
            elseif hl then 
                hl:Destroy() 
            end
        end
    end

    -- ESP PARA MONSTROS (MOBS)
    if _G.EspMobs then
        for _, v in pairs(workspace:GetChildren()) do
            -- Procura modelos com Humanoid que não são players
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                local hl = v:FindFirstChild("MobHL")
                if not hl then
                    hl = Instance.new("Highlight", v)
                    hl.Name = "MobHL"
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho para monstros
                end
            end
        end
    else
        -- Remove o ESP dos monstros se desligar
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "MobHL" then v:Destroy() end
        end
    end
end)
