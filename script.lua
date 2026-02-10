--[[
    KING V3 - SHAROPIN GOD EDITION (RGB TITLE)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- CONFIGS
_G.TeamEspActive = false

-- 1. LIMPEZA TOTAL
if lp.PlayerGui:FindFirstChild("KingV3_Final") then lp.PlayerGui.KingV3_Final:Destroy() end

-- 2. TELA
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Final"
sg.ResetOnSpawn = false

-- 3. FRAME PRINCIPAL
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 350)
main.Position = UDim2.new(0.5, -125, 0.4, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
main.ZIndex = 10
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255)

-- TÍTULO COM NOME PERSONALIZADO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "sharopin god" -- Nome que pediste
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

-- LÓGICA RGB PARA O TÍTULO
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        title.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end
end)

-- BOTÃO MINIMIZAR
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 35, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0, 5)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.ZIndex = 100
Instance.new("UICorner", minBtn)

local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.ZIndex = 11
content.CanvasSize = UDim2.new(0, 0, 2, 0)
content.ScrollBarThickness = 2

local listLayout = Instance.new("UIListLayout", content)
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- LÓGICA MINIMIZAR
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 350), "Out", "Quad", 0.3, true)
    minBtn.Text = minimized and "+" or "—"
end)

-- BOTÃO ESP TEAM
local espBtn = Instance.new("TextButton", content)
espBtn.Size = UDim2.new(0.9, 0, 0, 35)
espBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
espBtn.Text = "ESP TEAM ROXO: OFF"
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", espBtn)

espBtn.MouseButton1Click:Connect(function()
    _G.TeamEspActive = not _G.TeamEspActive
    espBtn.Text = "ESP TEAM ROXO: " .. (_G.TeamEspActive and "ON" or "OFF")
    espBtn.BackgroundColor3 = _G.TeamEspActive and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(30, 30, 40)
end)

-- SISTEMA DE TELEPORT
local function createTP()
    for _, child in pairs(content:GetChildren()) do
        if child.Name == "TPPlayer" then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", content)
            b.Name = "TPPlayer"
            b.Size = UDim2.new(0.9, 0, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            b.Text = "Ir para: " .. p.DisplayName
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.Gotham
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
            end)
        end
    end
end

-- ESP TEAM ROXO
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("TeamHL")
            if _G.TeamEspActive and p.Team == lp.Team then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "TeamHL"
                    hl.FillColor = Color3.fromRGB(130, 0, 255)
                end
            elseif hl then hl:Destroy() end
        end
    end
end)

-- ATUALIZAÇÃO DA LISTA
task.spawn(function()
    while task.wait(5) do createTP() end
end)
createTP()
