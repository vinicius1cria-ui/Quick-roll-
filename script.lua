--[[
    KING V3 - SOLO HUNTER (KILL AURA EDITION)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGS
_G.KillAura = false
_G.AuraRange = 50
_G.SpeedEnabled = false
_G.SpeedValue = 25
_G.JumpEnabled = false
_G.JumpValue = 60
_G.DoubleJumpEnabled = false
_G.EspActive = false
_G.AimbotEnabled = false

local hasDoubleJumped = false
local minimized = false

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_SoloHunter") then lp.PlayerGui.KingV3_SoloHunter:Destroy() end

-- 2. TELA
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_SoloHunter"
sg.ResetOnSpawn = false

-- 3. FRAME PRINCIPAL
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 240, 0, 450)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
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

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.ZIndex = 11

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main:TweenSize(minimized and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 450), "Out", "Quad", 0.3, true)
    minBtn.Text = minimized and "+" or "—"
end)

-- 4. FUNÇÕES DE INTERFACE
local function createToggle(txt, y, var)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 15
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.Text = txt .. ": " .. (_G[var] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(30, 30, 40)
    end)
    return y + 38
end

-- 5. LÓGICA KILL AURA (Mata mobs de longe)
task.spawn(function()
    while task.wait(0.1) do
        if _G.KillAura then
            pcall(function()
                -- Procura no Workspace por inimigos (ajustado para Solo Hunter)
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= lp.Name then
                        local dist = (lp.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < _G.AuraRange and v.Humanoid.Health > 0 then
                            -- Simula o ataque (pode variar dependendo da ferramenta do jogo)
                            local tool = lp.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                                -- Se o jogo usar Remotes, o script pode ser otimizado aqui
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ORDEM DOS BOTÕES NO MENU
local posY = 5
posY = createToggle("KILL AURA (MOBS)", posY, "KillAura")
posY = createToggle("AIMBOT (PLAYERS)", posY, "AimbotEnabled")
posY = createToggle("ESP BRILHO", posY, "EspActive")
posY = createToggle("SPEED", posY, "SpeedEnabled")
posY = createToggle("JUMP", posY, "JumpEnabled")
posY = createToggle("DOUBLE JUMP", posY, "DoubleJumpEnabled")

-- [LÓGICA DE MOVIMENTO E ESP MANTIDAS]
RunService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if _G.SpeedEnabled then lp.Character.Humanoid.WalkSpeed = _G.SpeedValue end
        if _G.JumpEnabled then lp.Character.Humanoid.UseJumpPower = true lp.Character.Humanoid.JumpPower = _G.JumpValue end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        if lp.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and not hasDoubleJumped then
            hasDoubleJumped = true
            local v = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
            v.Velocity = Vector3.new(0, _G.JumpValue * 1.3, 0)
            v.MaxForce = Vector3.new(0, 99999, 0)
            task.wait(0.1)
            v:Destroy()
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
        hasDoubleJumped = false
    end
    if _G.EspActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hl = p.Character:FindFirstChild("KingHL") or Instance.new("Highlight", p.Character)
                hl.Name = "KingHL"
                hl.FillColor = Color3.fromRGB(130, 0, 255)
            end
        end
    end
end)
