-- LocalScript (coloque no StarterPlayerScripts ou StarterGui)

local Players = game:GetService("Players")  
local RunService = game:GetService("RunService")  
local UserInputService = game:GetService("UserInputService")

local espEnabled = true

-- Função para criar um BillboardGui com o nome, HP e time  
local function createEsp(player)  
    local character = player.Character or player.CharacterAdded:Wait()  
    local humanoid = character:WaitForChild("Humanoid")

    -- BillboardGui para mostrar info  
    local billboardGui = Instance.new("BillboardGui")  
    billboardGui.Name = "PlayerESP"  
    billboardGui.Adornee = character:FindFirstChild("Head")  
    billboardGui.Size = UDim2.new(0, 200, 0, 80)  
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)  
    billboardGui.AlwaysOnTop = true  
    billboardGui.MaxDistance = 100

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

    -- Health bar  
    local healthBarBg = Instance.new("Frame")  
    healthBarBg.Size = UDim2.new(0.9, 0, 0.25, 0)  
    healthBarBg.Position = UDim2.new(0.05, 0, 0.35, 0)  
    healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  
    healthBarBg.BorderSizePixel = 0  
    healthBarBg.Parent = frame

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

    billboardGui.Parent = character:WaitForChild("Head")

    -- Atualizar informações  
    humanoid.HealthChanged:Connect(function(newHealth)  
        if espEnabled then  
            healthBar.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)  
            healthBar.BackgroundColor3 = Color3.fromRGB(  
                math.min(255, (1 - humanoid.Health / humanoid.MaxHealth) * 255),  
                math.min(255, (humanoid.Health / humanoid.MaxHealth) * 255),  
                0  
            )  
            healthLabel.Text = "HP: " .. math.floor(newHealth) .. "/" .. humanoid.MaxHealth  
        end  
    end)

    player.TeamChanged:Connect(function()  
        teamLabel.Text = "Team: " .. (player.Team and player.Team.Name or "None")  
    end)

    -- Remover ESP quando o jogador sair ou morrer (despawn)  
    player.CharacterRemoving:Connect(function()  
        billboardGui:Destroy()  
    end)  
end

-- Aplicar ESP em todos os jogadores atuais  
for _, player in ipairs(Players:GetPlayers()) do  
    if player ~= Players.LocalPlayer then  
        if player.Character then  
            createEsp(player)  
        end  
        player.CharacterAdded:Connect(function()  
            task.wait(0.5)  
            createEsp(player)  
        end)  
    end  
end

-- Quando um novo jogador entrar  
Players.PlayerAdded:Connect(function(player)  
    player.CharacterAdded:Connect(function()  
        task.wait(0.5)  
        createEsp(player)  
    end)  
end)

-- Toggle com tecla (ex: F6 liga/desliga)  
UserInputService.InputBegan:Connect(function(input, processed)  
    if processed then return end  
    if input.KeyCode == Enum.KeyCode.F6 then  
        espEnabled = not espEnabled  
        for _, player in ipairs(Players:GetPlayers()) do  
            if player ~= Players.LocalPlayer then  
                local char = player.Character  
                if char then  
                    local esp = char:FindFirstChild(" Head") and char.Head:FindFirstChild("PlayerESP")  
                    if esp then  
                        esp.Enabled = espEnabled  
                    end  
                end  
            end  
        end  
        print("ESP " .. (espEnabled and "ligado" or "desligado"))  
    end  
end)

-- Remover ESP quando sair do jogo ou reset  
game:BindToClose(function()  
    -- Limpar tudo  
end)  
