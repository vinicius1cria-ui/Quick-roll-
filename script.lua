--[[
    KING V3 - TELEPORT & TEAM ESP
    - ESP Team (Roxo) com Toggle
    - Teleport Players (Dropdown/Botões)
    - Botão Minimizar [— / +]
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- CONFIGS
_G.TeamEspActive = false
local minimized = false

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_Final") then lp.PlayerGui.KingV3_Final:Destroy() end

-- 2. TELA
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "SHAROPIN GOD"
sg.ResetOnSpawn = false

-- 3. FRAME PRINCIPAL
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 350)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
main.ZIndex = 10
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(130, 0, 255)

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
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 2, 0)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0,
                
