--[[
    KING V4 - FINAL BODY RENDER
    - ESP: Highlight (Corpo) + Nome RGB
    - Aimbot: Smooth Agressive
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local SMOOTHNESS = 0.25

-- FUNÇÃO COR ROXA PULSANTE
local function getPurpleRGB()
    local t = tick() * 2.5
    return Color3.fromHSV(0.78, 0.9, 0.4 + math.sin(t) * 0.6)
end

-- LÓGICA DO ESP (CORPO + NOME)
local function applyESP(p)
    if p == lp then return end
    
    local function setup(char)
        -- Remove qualquer ESP antigo
        if char:FindFirstChild("KingHighlight") then char.KingHighlight:Destroy() end
        
        -- HIGHLIGHT (CORPO)
        local hl = Instance.new("Highlight")
        hl.Name = "KingHighlight"
        hl.Parent = char
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.Adornee = char
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ISSO FAZ VER ATRAVÉS DA PAREDE

        -- NOME
        local head = char:WaitForChild("Head", 10)
        if head then
            local bill = head:FindFirstChild("KingName") or Instance.new("BillboardGui", head)
            bill.Name = "KingName"
            bill.Size = UDim2.new(0, 100, 0, 30)
            bill.StudsOffset = Vector3.new(0, 3, 0)
            bill.AlwaysOnTop = true
            
            local lab = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel", bill)
            lab.Size = UDim2.new(1, 0, 1, 0)
            lab.BackgroundTransparency = 1
            lab.Text = p.Name
            lab.Font = Enum.Font.GothamBold
            lab.TextSize = 14
        end

        -- Loop de Cor
        task.spawn(function()
            while char and char.Parent and _G.EspActive do
                local color = getPurpleRGB()
                hl.FillColor = color
                hl.OutlineColor = color
                if char:FindFirstChild("Head") and char.Head:FindFirstChild("KingName") then
                    char.Head.KingName.TextLabel.TextColor3 = color
                end
                task.wait(0.1)
            end
            if hl then hl:Destroy() end
            if head and head:FindFirstChild("KingName") then head.KingName:Destroy() end
        end)
    end

    if p.Character then setup(p.Character) end
    p.CharacterAdded:Connect(setup)
end

-- [O RESTO DO CÓDIGO DA UI SEGUE ABAIXO IGUAL AO ANTERIOR]
-- Certifique-se de manter a parte que cria o menu e os botões.
