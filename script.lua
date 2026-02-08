--[[
    KING V3 - SOLO HUNTER (KILL AURA & REMOTES)
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGS
_G.KillAura = false
_G.AuraRange = 60
_G.SpeedEnabled = false
_G.SpeedValue = 25
_G.JumpEnabled = false
_G.JumpValue = 60
_G.DoubleJumpEnabled = false
_G.EspActive = false

local hasDoubleJumped = false
local minimized = false

-- 1. LIMPEZA
if lp.PlayerGui:FindFirstChild("KingV3_SoloHunter") then lp.PlayerGui.KingV3_SoloHunter:Destroy() end

-- 2. TELA PRINCIPAL
local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "KingV3_SoloHunter"
sg.ResetOnSpawn = false

-- 3. FRAME
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 240, 0, 400)
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
    main:TweenSize(minimized and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 400), "Out", "Quad", 0.3, true)
    minBtn.Text = minimized and "+" or "—"
end)

-- 4. FUNÇÃO TOGGLE
local function createToggle(txt, y, var)
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
        _G[var] = not _G[var]
        btn.Text = txt .. ": " .. (_G[var] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(30, 30, 40)
    end)
    return y + 45
end

-- 5. LÓGICA KILL AURA (SOLO HUNTER)
-- Tentamos atacar mobs e jogadores próximos
task.spawn(function()
    while task.wait(0.2) do
        if _G.KillAura and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    -- Verifica se é um NPC/Bicho ou Player com vida
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= lp.Character then
                        local mag = (lp.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if mag <= _G.AuraRange and v.Humanoid.Health > 0 then
                            -- Ataca o bicho enviando um sinal de toque/combate
                            local tool = lp.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                -- Forçamos a animação e o hit
                                tool:Activate()
                                firetouchinterest(v.HumanoidRootPart, tool.Handle, 0)
                                firetouchinterest(v.HumanoidRootPart, tool.Handle, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 6. BOTÕES
local posY = 10
posY = createToggle("KILL AURA (MOBS)", posY, "KillAura")
posY = createToggle("ESP ALL", posY, "EspActive")
posY = createToggle("SPEED", posY, "SpeedEnabled")
posY = createToggle("JUMP POWER", posY, "JumpEnabled")
posY = createToggle("DOUBLE JUMP", posY, "DoubleJumpEnabled")

-- MOVIMENTO
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if _G.SpeedEnabled then lp.Character.Humanoid.WalkSpeed = _G.SpeedValue end
        if _G.JumpEnabled then lp.Character.Humanoid.UseJumpPower = true lp.Character.Humanoid.JumpPower = _G.JumpValue end
    end
end)

-- DOUBLE JUMP
UserInputService.JumpRequest:Connect(function()
    if _G.DoubleJumpEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local h = lp.Character.Humanoid
        if h:GetState() == Enum.HumanoidStateType.Freefall and not hasDoubleJumped then
            hasDoubleJumped = true
            local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
            bv.Velocity = Vector3.new(0, _G.JumpValue * 1.3, 0)
            bv.MaxForce = Vector3.new(0, 99999, 0)
            task.wait(0.1)
            bv:Destroy()
        end
    end
end)

-- ESP E RESET
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
