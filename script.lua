--[[
    KING V3 - SHAROPIN GOD EDITION (FIXED & UPDATED)
    - Funções: Fly, Speed Control, Team ESP, Teleport
    - Título: sharopin god (RGB)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGS GLOBAIS
_G.TeamEspActive = false
_G.FlyEnabled = false
_G.WalkSpeedValue = 16
_G.FlySpeed = 50

-- 1. LIMPEZA TOTAL
if lp.PlayerGui:FindFirstChild("KingV3_Final") then lp.PlayerGui.KingV3_Final:Destroy() end

-- 2. TELA
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_Final"
sg.ResetOnSpawn = false

-- 3. FRAME PRINCIPAL
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 380)
main.Position = UDim2.new(0.5, -130, 0.4, -190)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
main.ZIndex = 10
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255)

-- TÍTULO RGB: sharopin god
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "sharopin god"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        title.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end
end)

-- BOTÃO MINIMIZAR
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 35, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0, 7)
minBtn.Text = "—"
minBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.ZIndex = 100
Instance.new("UICorner", minBtn)

-- CONTEÚDO (ROLÁVEL)
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -10, 1, -55)
content.Position = UDim2.new(0, 5, 0, 50)
content.BackgroundTransparency = 1
content.ZIndex = 11
content.ScrollBarThickness = 2
content.CanvasSize = UDim2.new(0, 0, 0, 600) -- Espaço extra para não ficar invisível

local listLayout = Instance.new("UIListLayout", content)
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- LÓGICA MINIMIZAR
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main:TweenSize(minimized and UDim2.new(0, 260, 0, 45) or UDim2.new(0, 260, 0, 380), "Out", "Quad", 0.3, true)
    minBtn.Text = minimized and "+" or "—"
end)

-- FUNÇÃO PARA CRIAR BOTÕES
local function createToggle(txt, varName)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = txt .. ": " .. (_G[varName] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(30, 30, 40)
    end)
    return btn
end

-- 4. ADICIONANDO AS FUNÇÕES
createToggle("VOAR (FLY)", "FlyEnabled")
createToggle("ESP TIME ROXO", "TeamEspActive")

-- AJUSTE DE VELOCIDADE
local speedFrame = Instance.new("Frame", content)
speedFrame.Size = UDim2.new(0.9, 0, 0, 60)
speedFrame.BackgroundTransparency = 1

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Text = "VELOCIDADE: " .. _G.WalkSpeedValue
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.BackgroundTransparency = 1

local btnLess = Instance.new("TextButton", speedFrame)
btnLess.Size = UDim2.new(0.4, 0, 0, 30)
btnLess.Position = UDim2.new(0, 0, 0, 25)
btnLess.Text = "-"
btnLess.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
btnLess.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnLess)

local btnMore = Instance.new("TextButton", speedFrame)
btnMore.Size = UDim2.new(0.4, 0, 0, 30)
btnMore.Position = UDim2.new(0.6, 0, 0, 25)
btnMore.Text = "+"
btnMore.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
btnMore.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnMore)

btnLess.MouseButton1Click:Connect(function()
    _G.WalkSpeedValue = math.max(16, _G.WalkSpeedValue - 5)
    speedLabel.Text = "VELOCIDADE: " .. _G.WalkSpeedValue
end)

btnMore.MouseButton1Click:Connect(function()
    _G.WalkSpeedValue = _G.WalkSpeedValue + 10
    speedLabel.Text = "VELOCIDADE: " .. _G.WalkSpeedValue
end)

-- TELEPORTS
local tpLabel = Instance.new("TextLabel", content)
tpLabel.Size = UDim2.new(0.9, 0, 0, 20)
tpLabel.Text = "—— TELEPORTS ——"
tpLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
tpLabel.BackgroundTransparency = 1
tpLabel.Font = Enum.Font.GothamBold

-- 5. LÓGICA DE MOVIMENTO (SPEED & FLY)
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
    end
end)

-- LÓGICA FLY (VOAR)
local bv, bg
task.spawn(function()
    while task.wait() do
        if _G.FlyEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            if not bv then
                bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bg = Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            end
            bg.CFrame = workspace.CurrentCamera.CFrame
            local direction = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
            bv.Velocity = direction * _G.FlySpeed
        else
            if bv then bv:Destroy() bv = nil end
            if bg then bg:Destroy() bg = nil end
        end
    end
end)

-- LÓGICA ESP TEAM
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

-- LISTA DE TELEPORT
local function updateTP()
    for _, c in pairs(content:GetChildren()) do if c.Name == "TPBtn" then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", content)
            b.Name = "TPBtn"
            b.Size = UDim2.new(0.9, 0, 0, 30)
            b.Text = "Ir para: " .. p.DisplayName
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end
task.spawn(function() while task.wait(5) do updateTP() end end)
updateTP()
