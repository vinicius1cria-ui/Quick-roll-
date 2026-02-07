local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Limpar UI antiga
if lp.PlayerGui:FindFirstChild("HadesMinimal") then lp.PlayerGui.HadesMinimal:Destroy() end

local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "HadesMinimal"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 180, 0, 100)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "HADES QUICK ROLL"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12

-- Efeito RGB discreto no título
spawn(function()
    while task.wait() do
        title.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

local rollBtn = Instance.new("TextButton", main)
rollBtn.Size = UDim2.new(0.9, 0, 0, 40)
rollBtn.Position = UDim2.new(0.05, 0, 0, 45)
rollBtn.Text = "ATIVAR QUICK ROLL"
rollBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rollBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", rollBtn)

local active = false
rollBtn.MouseButton1Click:Connect(function()
    active = not active
    rollBtn.Text = active and "QUICK ROLL: ON" or "ATIVAR QUICK ROLL"
    rollBtn.BackgroundColor3 = active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    -- Loop de Giro Rápido
    spawn(function()
        while active do
            -- Procura o evento de Roll em todo o ReplicatedStorage
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Roll", true)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            end
            task.wait(0.05) -- Velocidade de Quick Roll
        end
    end)
end)
