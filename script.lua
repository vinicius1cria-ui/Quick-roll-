-- LocalScript (coloque no StarterPlayerScripts ou StarterGui)

local Players = game:GetService("Players")  
local UserInputService = game:GetService("UserInputService")

local espEnabled = true  
local espObjects = {}

-- Função para criar um BillboardGui com o nome, HP e team  
local function createEsp(player)  
	local character = player.Character or player.CharacterAdded:Wait()  
	local head = character:FindFirstChild("Head")  
	local humanoid = character:WaitForChild("Humanoid")  
	if not head or not humanoid then return end

	-- BillboardGui para mostrar info  
	local billboardGui = Instance.new("BillboardGui")  
	billboardGui.Name = "PlayerESP"  
	billboardGui.Adornee = head  
	billboardGui.Size = UDim2.new(0, 200, 0, 80)  
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)  
	billboardGui.AlwaysOnTop = true  
	billboardGui.MaxDistance = 100  
	billboardGui.Parent = head

	-- Frame de fundo  
	local frame = Instance.new("Frame")  
	frame.Size = UDim2.new(1, 0, 1, 0)  
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
	frame.BackgroundTransparency = 0.3  
	frame.BorderSizePixel = 0  
	frame.Parent = billboardGui

	-- Nome do jogador  
	local nameLabel = Instance.new("TextLabel")  
	nameLabel.Size = UDim2.new(1, 0, 0.33, 0)  
	nameLabel.Position = UDim2.new(0, 0, 0, 0)  
	nameLabel.BackgroundTransparency = 1  
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  
	nameLabel.TextScaled = true  
	nameLabel.Font = Enum.Font.GothamBold  
	nameLabel.Text = player.Name  
	nameLabel.Parent = frame

	-- Health bar bg  
	local healthBarBg = Instance.new("Frame")  
	healthBarBg.Size = UDim2.new(0.9, 0, 0.25, 0)  
	healthBarBg.Position = UDim2.new(0.05, 0, 0.35, 0)  
	healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  
	healthBarBg.BorderSizePixel = 0  
	healthBarBg.Parent = frame

	-- Health bar fill  
	local healthBar = Instance.new("Frame")  
	healthBar.Size = UDim2.new(1, 0, 1, 0)  
	healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  
	healthBar.BorderSizePixel = 0  
	healthBar.Parent = healthBarBg

	-- HP Text  
	local healthLabel = Instance.new("TextLabel")  
	healthLabel.Size = UDim2.new(1, 0, 1, 0)  
	healthLabel.BackgroundTransparency = 1  
	healthLabel.TextColor3 = Color3.fromRGB(0, 0, 0)  
	healthLabel.TextScaled = true  
	healthLabel.Font = Enum.Font.GothamSemibold  
	healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth  
	healthLabel.Parent = healthBarBg

	-- Team label  
	local teamLabel = Instance.new("TextLabel")  
	teamLabel.Size = UDim2.new(1, 0, 0.35, 0)  
	teamLabel.Position = UDim2.new(0, 0, 0.7, 0)  
	teamLabel.BackgroundTransparency = 1  
	teamLabel.TextColor3 = Color3.fromRGB(200, 200, 255)  
	teamLabel.TextScaled = true  
	teamLabel.Font = Enum.Font.Gotham  
	teamLabel.Text = "Team: " .. (player.Team and player.Team.Name or "None")  
	teamLabel.Parent = frame

	-- Armazenar referência  
	espObjects[player.Name] = {  
		billboardGui = billboardGui,  
		frame = frame,  
		nameLabel = nameLabel,  
		healthBar = healthBar,  
		healthBarBg = healthBarBg,  
		healthLabel = healthLabel,  
		teamLabel = teamLabel  
	}

	-- Atualizar informações  
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

	-- Remover ESP quando o jogador sair  
	player.CharacterRemoving:Connect(function()  
		if espObjects[player.Name] then  
			espObjects[player.Name].billboardGui:Destroy()  
			espObjects[player.Name] = nil  
		end  
	end)  
end

-- Função pra aplicar ESP com segurança  
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

-- Aplicar ESP em jogadores atuais  
for _, player in ipairs(Players:GetPlayers()) do  
	applyEspSafe(player)  
end

-- Quando novo jogador entrar  
Players.PlayerAdded:Connect(function(player)  
	applyEspSafe(player)  
end)

-- Toggle com RightControl  
UserInputService.InputBegan:Connect(function(input, processed)  
	if processed then return end  
	if input.KeyCode == Enum.KeyCode.RightControl then  
		espEnabled = not espEnabled

		for _, esp in pairs(espObjects) do  
			if espEnabled then  
				esp.billboardGui.Parent = esp.billboardGui.Parent -- re-parentar pra garantir visibilidade  
				esp.frame.Visible = true  
				esp.nameLabel.Visible = true  
				esp.healthBar.Parent = esp.healthBarBg Parent -- correção abaixo  
				esp.healthLabel.Visible = true  
				esp.teamLabel.Visible = true  
			else  
				esp.frame.Visible = false  
				esp.nameLabel.Visible = false  
				esp.healthBar.Visible = false  
				esp.healthBarBg.Visible = false  
				esp.healthLabel.Visible = false  
				esp.teamLabel.Visible = false  
			end  
		end

		print("ESP " .. (espEnabled and "ligado" or "desligado"))  
	end  
end)  
