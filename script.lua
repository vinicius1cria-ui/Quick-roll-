
```lua
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local espEnabled = true
local espObjects = {}

local C_BG = Color3.fromRGB(15, 15, 20)
local C_BG2 = Color3.fromRGB(25, 25, 35)
local C_ACCENT = Color3.fromRGB(140, 80, 255)
local C_ACCENT2 = Color3.fromRGB(80, 40, 180)
local C_TEXT = Color3.fromRGB(235, 235, 245)
local C_ON = Color3.fromRGB(120, 255, 140)
local C_OFF = Color3.fromRGB(255, 90, 90)

local function makeGradient(color1, color2, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(color1, color2)
    grad.Rotation = rotation or 0
    return grad
end

local function makeCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function clearEsp(player)
    local esp = espObjects[player]
    if not esp then return end
    if esp.connections then
        for _, conn in ipairs(esp.connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
    end
    if esp.billboardGui then
        esp.billboardGui:Destroy()
    end
    espObjects[player] = nil
end

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DARKzZzEspMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 140, 0, 38)
openButton.Position = UDim2.new(0, 12, 0, 12)
openButton.BackgroundColor3 = C_BG
openButton.TextColor3 = C_TEXT
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Text = " DARKzZz "
openButton.Visible = false
openButton.Parent = screenGui
makeCorner(10).Parent = openButton
makeGradient(C_ACCENT2, C_BG, 90).Parent = openButton

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 240, 0, 150)
menuFrame.Position = UDim2.new(0, 12, 0, 12)
menuFrame.BackgroundColor3 = C_BG
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui
makeCorner(12).Parent = menuFrame
makeGradient(C_BG2, C_BG, 90).Parent = menuFrame

local activeDrag = false
local dragStart, startPos

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        activeDrag = true
        dragStart = input.Position
        startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                activeDrag = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.BackgroundColor3 = C_ACCENT
topBar.BorderSizePixel = 0
topBar.Parent = menuFrame
makeGradient(C_ACCENT, C_ACCENT2, 0).Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 34)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.TextColor3 = C_TEXT
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "DARKzZz ESP"
title.Parent = menuFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0, 8)
minimizeBtn.BackgroundColor3 = C_BG2
minimizeBtn.TextColor3 = C_TEXT
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Text = "-"
minimizeBtn.Parent = menuFrame
makeCorner(8).Parent = minimizeBtn

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.92, 0, 0, 38)
toggleBtn.Position = UDim2.new(0.04, 0, 0, 48)
toggleBtn.BackgroundColor3 = C_BG2
toggleBtn.TextColor3 = C_TEXT
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "ESP: LIGADO"
toggleBtn.Parent = menuFrame
makeCorner(10).Parent = toggleBtn

local toggleGradient = makeGradient(Color3.fromRGB(40, 120, 60), C_BG2, 90)
toggleGradient.Parent = toggleBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.92, 0, 0, 28)
statusLabel.Position = UDim2.new(0.04, 0, 0, 96)
statusLabel.BackgroundColor3 = C_BG2
statusLabel.TextColor3 = C_ON
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Text = "  Status: Ativo"
statusLabel.Parent = menuFrame
makeCorner(8).Parent = statusLabel

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.TextColor3 = C_ACCENT
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.Text = "v1.2 by DARKzZz"
footer.Parent = menuFrame

local function updateMenu()
    if espEnabled then
        toggleBtn.Text = "ESP: LIGADO"
        toggleGradient.Color = ColorSequence.new(Color3.fromRGB(40, 120, 60), C_BG2)
        statusLabel.Text = "  Status: Ativo"
        statusLabel.TextColor3 = C_ON
    else
        toggleBtn.Text = "ESP: DESLIGADO"
        toggleGradient.Color = ColorSequence.new(Color3.fromRGB(120, 30, 30), C_BG2)
        statusLabel.Text = "  Status: Desativado"
        statusLabel.TextColor3 = C_OFF
    end
    for _, esp in pairs(espObjects) do
        if esp.frame then
            esp.frame.Visible = espEnabled
        end
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateMenu()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = true
    openButton.Visible = false
end)

local function createEsp(player)
    clearEsp(player)
    local character = player.Character
    if not character then return end
    local head = character:WaitForChild("Head", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not head or not humanoid then return end
    local connections = {}

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "DARKzZzESP"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 180, 0, 70)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.MaxDistance = 250
    billboardGui.Parent = head

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = C_BG
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Visible = espEnabled
    frame.Parent = billboardGui
    makeCorner(8).Parent = frame
    makeGradient(C_BG2, C_BG, 90).Parent = frame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = C_ACCENT
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.DisplayName or player.Name
    nameLabel.Parent = frame

    local healthBarBg = Instance.new("Frame")
    healthBarBg.Size = UDim2.new(0.9, 0, 0.25, 0)
    healthBarBg.Position = UDim2.new(0.05, 0, 0.35, 0)
    healthBarBg.BackgroundColor3 = C_BG2
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = frame
    makeCorner(6).Parent = healthBarBg

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg
    makeCorner(6).Parent = healthBar

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.GothamSemibold
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.Parent = healthBarBg

    local teamLabel = Instance.new("TextLabel")
    teamLabel.Size = UDim2.new(1, 0, 0.35, 0)
    teamLabel.Position = UDim2.new(0, 0, 0.7, 0)
    teamLabel.BackgroundTransparency = 1
    teamLabel.TextColor3 = C_TEXT
    teamLabel.TextScaled = true
    teamLabel.Font = Enum.Font.Gotham
    teamLabel.Text = "Team: " .. (player.Team and player.Team.Name or "None")
    teamLabel.Parent = frame

    espObjects[player] = {
        billboardGui = billboardGui,
        frame = frame,
        connections = connections,
    }

    local function updateHealth(currentHealth)
        local maxHealth = humanoid.MaxHealth
        if maxHealth <= 0 then return end
        local ratio = math.clamp(currentHealth / maxHealth, 0, 1)
        healthBar.Size = UDim2.new(ratio, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(
            math.floor((1 - ratio) * 255),
            math.floor(ratio * 255),
            0
        )
        healthLabel.Text = "HP: " .. math.floor(currentHealth) .. "/" .. math.floor(maxHealth)
    end

    updateHealth(humanoid.Health)

    table.insert(connections, humanoid.HealthChanged:Connect(function(newHealth)
        updateHealth(newHealth)
    end))

    table.insert(connections, player:GetPropertyChangedSignal("Team"):Connect(function()
        teamLabel.Text = "Team: " .. (player.Team and player.Team.Name or "None")
    end))

    table.insert(connections, player.CharacterRemoving:Connect(function()
        clearEsp(player)
    end))
end

local function applyEspSafe(player)
    if player == Players.LocalPlayer then return end
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        pcall(createEsp, player)
    end)
    if player.Character then
        task.wait(0.5)
        pcall(createEsp, player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    applyEspSafe(player)
end

Players.PlayerAdded:Connect(applyEspSafe)
Players.PlayerRemoving:Connect(clearEsp)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        espEnabled = not espEnabled
        updateMenu()
    end
end)

print("DARKzZz ESP v1.2 carregado com sucesso!")
```

---

### Passos para funcionar:

1. Vai no seu GitHub no arquivo `script.lua`
2. Clica no **lapizinho (Edit)** 
3. **Apaga TUDO** que tem la dentro
4. **Cola esse codigo** acima inteiro
5. Clica em **Commit changes**
6. Espera **1 minuto** pro GitHub atualizar
7. No executor cola isso:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/vinicius1cria-ui/Quick-roll-/main/script.lua", true))()
```

8. Aperta **F9** e procura a mensagem verde: `DARKzZz ESP v1.2 carregado com sucesso!`
