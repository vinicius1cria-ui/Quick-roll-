--[[
    KING V3 - THE HONORED ONE
    - Tema: Gojo Satoru (Vazio Roxo)
    - Funções: ESP Neon (Team Color) & Anti-AFK
    - Sistema de Minimizar Incluso
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local VU = game:GetService("VirtualUser")

_G.EspActive = false
local minimized = false

-- 1. INTERFACE PRINCIPAL
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 220, 0, 200)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(138, 43, 226) -- Neon Roxo

-- ÍCONE DO GOJO
local icon = Instance.new("ImageLabel", main)
icon.Size = UDim2.new(0, 35, 0, 35)
icon.Position = UDim2.new(0, 10, 0, 5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://15115501179" -- Imagem épica do Gojo
Instance.new("UICorner", icon)

-- TÍTULO KING V3
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -80, 0, 45)
title.Position = UDim2.new(0, 50, 0, 0)
title.Text = "KING V3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- BOTÃO MINIMIZAR
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 7)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minBtn.TextColor3 = Color3.fromRGB(138, 43, 226)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
Instance.new("UICorner", minBtn)

-- Conteúdo do Menu (para sumir ao minimizar)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1

-- LOGICA DE MINIMIZAR
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main:TweenSize(UDim2.new(0, 220, 0, 45), "Out", "Quad", 0.3, true)
        content.Visible = false
        minBtn.Text = "+"
    else
        main:TweenSize(UDim2.new(0, 220, 0, 200), "Out", "Quad", 0.3, true)
        content.Visible = true
        minBtn.Text = "-"
    end
end)

-- 2. FUNÇÃO ESP (FIXED)
local function applyHighlight(player)
    local function create()
        if not _G.EspActive then return end
        local char = player.Character or player.CharacterAdded:Wait()
        task.wait(0.1)
        
        local hl = char:FindFirstChild("KingHighlight") or Instance.new("Highlight", char)
        hl.Name = "KingHighlight"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.FillColor = (player.Team == lp.Team) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(138, 43, 226)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
    player.CharacterAdded:Connect(create)
    create()
end

-- 3. BOTÃO ESP
local espBtn = Instance.new("TextButton", content)
espBtn.Size = UDim2.new(0.85, 0, 0, 40)
espBtn.Position = UDim2.new(0.075, 0, 0.1, 0)
espBtn.Text = "ESP NEON: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", espBtn)

espBtn.MouseButton1Click:Connect(function()
    _G.EspActive = not _G.EspActive
    espBtn.Text = _G.EspActive and "ESP NEON: ON" or "ESP NEON: OFF"
    espBtn.BackgroundColor3 = _G.EspActive and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 40)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            if _G.EspActive then applyHighlight(p) 
            else 
                local h = p.Character and p.Character:FindFirstChild("KingHighlight")
                if h then h:Destroy() end
            end
        end
    end
end)

-- Status Anti-AFK
local afkLabel = Instance.new("TextLabel", content)
afkLabel.Size = UDim2.new(1, 0, 0, 30)
afkLabel.Position = UDim2.new(0, 0, 0.6, 0)
afkLabel.Text = "STATUS: ANTI-AFK ATIVO"
afkLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
afkLabel.Font = Enum.Font.Gotham
afkLabel.BackgroundTransparency = 1

-- 4. LOOPS
task.spawn(function()
    Players.PlayerAdded:Connect(applyHighlight)
    while task.wait(1) do
        -- Anti-AFK Real
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end
end)

print("KING V3 Carregado com Sucesso!")
