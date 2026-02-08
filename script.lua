local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Variáveis de controle de voo
local voando = false
local velocidade = 50
local bVelo = nil
local bGyro = nil
local minimizado = false

-- 1. Criar a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KingFlySystem"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Função para contorno
local function addStroke(obj)
    local s = Instance.new("UIStroke")
    s.Thickness = 2
    s.Color = Color3.new(0,0,0)
    s.Parent = obj
end

-- 2. Janela Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui
addStroke(mainFrame)

-- 3. Barra de Título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 30, 60)
titleBar.Parent = mainFrame
addStroke(titleBar)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "KING FLY V1"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextSize = 14
titleText.Parent = title
