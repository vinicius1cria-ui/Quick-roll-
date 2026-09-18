LocalScript (coloque no StarterPlayerScripts ou StarterGui)
-- ESP DARKzZz

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local espEnabled = true
local espObjects = {}

-- Util: criar gradiente
local function makeGradient(color1, color2, rotation)
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new(color1, color2)
	grad.Rotation = rotation or 0
	return grad
end

-- Util: cantos arredondados
local function makeCorner(radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	return corner
end

-- ===== MENU =====
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DARKzZzEspMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Cores do tema
local C_BG = Color3.fromRGB(15, 15, 20)
local C_BG2 = Color3.fromRGB(25, 25, 35)
local C_ACCENT = Color3.fromRGB(140, 80, 255)
local C_ACCENT2 = Color3.fromRGB(80, 40, 180)
local C_TEXT = Color3.fromRGB(235, 235, 245)
local C_ON = Color3.fromRGB(120, 255, 140)
local C_OFF = Color3.fromRGB(255, 90, 90)

-- Botão para abrir quando minimizado
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 140, 0, 38)
openButton.Position = UDim2.new(0, 12, 0, 12)
openButton.BackgroundColor3 = C_BG
openButton.TextColor3 = C_TEXT
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Text = " ⛧ DARKzZz "
openButton.Visible = false
openButton.Parent = screenGui
makeCorner(10).Parent = openButton
makeGradient(C_ACCENT2, C_BG, 90).Parent = openButton

-- Painel principal
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 240, 0, 150)
menuFrame.Position = UDim2.new(0, 12, 0, 12)
menuFrame.BackgroundColor3 = C_BG
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui
makeCorner(12).Parent = menuFrame
makeGradient(C_BG2, C_BG, 90).Parent = menuFrame

-- Borda accent superior
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.BackgroundColor3 = C_ACCENT
topBar.BorderSizePixel = 0
topBar.Parent = menuFrame
makeGradient(C_ACCENT, C_ACCENT2, 0).Parent = topBar

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 34)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.TextColor3 = C_TEXT
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "⛧ DARKzZz ESP"
title.Parent = menuFrame

-- Botão Minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0, 8)
minimizeBtn.BackgroundColor3 = C_BG2
minimizeBtn.TextColor3 = C_TEXT
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Text = "—"
minimizeBtn.Parent = menuFrame
makeCorner(8).Parent = minimizeBtn

-- Botão Ligar/Desligar
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
makeGradient(C_ACCENT2, C_BG2, 90).Parent = toggleBtn

-- Indicador de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.92, 0, 0, 28)
statusLabel.Position = UDim2.new(0.04, 0, 0, 96)
statusLabel.BackgroundColor3 = C_BG2
statusLabel.TextColor3 = C_ON
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Text = "  ● Status: Ativo"
statusLabel.Parent = menuFrame
makeCorner(8).Parent = statusLabel

-- Footer version
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.TextColor3 = C_ACCENT
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.Text = "v1.0  •  by DARKzZz"
footer.Parent = menuFrame

-- Atualiza visuals do menu
local function updateMenu()
	if espEnabled then
		toggleBtn.Text = "ESP: LIGADO"
		makeGradient(Color3.fromRGB(40, 120, 60), C_BG2, 90).Parent = toggleBtn
		statusLabel.Text = "  ● Status: Ativo"
		statusLabel.TextColor3 = C_ON
	else
		toggleBtn.Text = "ESP: DESLIGADO"
		makeGradient(Color3.fromRGB(120, 30, 30), C_BG2, 90).Parent = toggleBtn
		statusLabel.Text = "  ● Status: Desativado"
		statusLabel.TextColor3 = C_OFF
	end

	for _, esp in pairs(espObjects) do
		esp.frame.Visible = espEnabled
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

-- ===== ESP =====
local function createEsp(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:FindFirstChild("Head")
	local humanoid = character:WaitForChild("Humanoid")
	if not head or not humanoid then return end

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "DARKzZzESP"
	billboardGui.Adornee = head
	billboardGui.Size = UDim2.new(0, 200, 0, 80)
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.MaxDistance = 100
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
	nameLabel.Text = player.Name
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
	healthLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	healthLabel.TextScaled = true
	healthLabel.Font = Enum.Font.GothamSemibold
	healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
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

	espObjects[player.Name] = {
		billboardGui = billboardGui,
		frame = frame,
		nameLabel = nameLabel,
		healthBar = healthBar,
		healthBarBg = healthBarBg,
		healthLabel = healthLabel,
		teamLabel = teamLabel
	}

	humanoid.HealthChanged:Connect(function(newHealth)
		if not espEnabled then return end
		local ratio = math.clamp(newHealth / humanoid.MaxHealth, 0, 1)
		healthBar.Size = UDim2.new(ratio, 0, 1, 0)
		healthBar.BackgroundColor3 = Color3.fromRGB(
			math.floor((1 - ratio) * 255),
			math.floor(ratio * 255),
			0
		)
		healthLabel.Text = "HP: " .. math.floor(newHealth) .. "/" .. math.floor(humanoid.MaxHealth)
	end)

	player.TeamChanged:Connect(function()
		teamLabel.Text = "Team: " .. (player.Team and player.Team.Name or "None")
	end)

	player.CharacterRemoving:Connect(function()
		if espObjects[player.Name] then
			espObjects[player.Name].billboardGui:Destroy()
			espObjects[player.Name] = nil
		end
	end)
end

local function applyEspSafe(player)
	if player == Players.LocalPlayer then return end
	pcall(function()
		if player.Character then
			createEsp(player)
		end
		player.CharacterAdded:Connect(function()
			task.wait(0.5)
			pcall(function()
				createEsp(player)
			end)
		end)
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	applyEspSafe(player)
end

Players.PlayerAdded:Connect(function(player)
	applyEspSafe(player)
end)

-- Atalho RightControl continua funcionando
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		espEnabled = not espEnabled
		updateMenu()
	end
end)
