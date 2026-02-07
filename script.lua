--[[
    KING V3 - GOD MODE EDITION (PRISON LIFE)
    - Aimbot: Lock-on Head (Gruda na Cabeça)
    - FOV: Círculo Roxo Neon
    - ESP: Neon Team Based
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Mouse = lp:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

_G.AimbotEnabled = false
_G.EspActive = false
local FOV_RADIUS = 150 -- Tamanho do círculo de trava

-- 1. DESENHO DO CÍRCULO (CROSSHAIR)
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 2
fov_circle.NumSides = 100
fov_circle.Radius = FOV_RADIUS
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.Color = Color3.fromRGB(138, 43, 226)

-- 2. FUNÇÃO DE TRAVA NA CABEÇA
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Team ~= lp.Team and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mouseDist < dist then
                    target = v.Character.Head
                    dist = mouseDist
                end
            end
        end
    end
    return target
end

-- LOOP DO AIMBOT (Roda a cada frame)
RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    
    if _G.AimbotEnabled then
        local head = getClosestPlayer()
        if head then
            -- Trava direta na cabeça (Ajuste de 0.6 para ser mais forte que o anterior)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)

-- 3. INTERFACE KING V3
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 220)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(138, 43, 226)

-- ÍCONE E TÍTULO
local icon = Instance.new("ImageLabel", main)
icon.Size = UDim2.new(0, 35, 0, 35)
icon.Position = UDim2.new(0, 10, 0, 5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://15115501179"
Instance.new("UICorner", icon)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.new(0, 50, 0, 0)
title.Text = "KING V3 - LOCK"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- BOTÕES
local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    Instance
    
