local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- Limpeza de UI
if lp.PlayerGui:FindFirstChild("HadesFix") then lp.PlayerGui.HadesFix:Destroy() end

local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "HadesFix"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 180, 0, 100)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "QUICK ROLL FIX"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

-- Efeito RGB
spawn(function()
    while task.wait() do
        title.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

local rollBtn = Instance.new("TextButton", main)
rollBtn.Size = UDim2.new(0.9, 0, 0, 40)
rollBtn.Position = UDim2.new(0.05, 0, 0, 45)
rollBtn.Text = "ATIVAR"
rollBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
rollBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", rollBtn)

local active = false
rollBtn.MouseButton1Click:Connect(function()
    active = not active
    rollBtn.Text = active and "ON (RÁPIDO)" or "ATIVAR"
    rollBtn.BackgroundColor3 = active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(45, 45, 45)
    
    spawn(function()
        while active do
            -- Tenta encontrar o evento de Roll por nome ou função
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:find("Roll") or v.Name:find("Spin") or v.Name:find("Girar")) then
                    v:FireServer()
                end
            end
            
            -- Se o jogo usa botões na tela em vez de remotes diretos
            pcall(function()
                local gui = lp.PlayerGui:FindFirstChild("Main") or lp.PlayerGui:FindFirstChild("Gui")
                local rollUI = gui:FindFirstChild("Roll", true) or gui:FindFirstChild("Spin", true)
                if rollUI and rollUI:IsA("TextButton") then
                    for _, connection in pairs(getconnections(rollUI.MouseButton1Click)) do
                        connection:Fire()
                    end
                end
            end)
            
            task.wait(0.1) -- Tempo seguro para o Quick Roll não dar erro
        end
    end)
end)
