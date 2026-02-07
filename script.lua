-- ESP VAZIO INFINITO (TEAM COLOR + NEON)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function applyESP(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5) -- Espera o personagem carregar totalmente
        
        -- Se já tiver um ESP, remove para não bugar
        if char:FindFirstChild("GojoHighlight") then
            char.GojoHighlight:Destroy()
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "GojoHighlight"
        highlight.Parent = char
        highlight.Adornee = char
        
        -- CONFIGURAÇÃO VISUAL
        highlight.FillTransparency = 0.5 -- Transparência do corpo
        highlight.OutlineTransparency = 0 -- Contorno bem visível
        
        -- LÓGICA DE CORES POR TIME
        if player.Team == lp.Team then
            -- TIME ALIADO (Azul/Ciano Neon)
            highlight.FillColor = Color3.fromRGB(0, 255, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        else
            -- TIME INIMIGO (Roxo Vazio do Gojo)
            highlight.FillColor = Color3.fromRGB(138, 43, 226) -- Roxo forte
            highlight.OutlineColor = Color3.fromRGB(255, 0, 255) -- Neon Rosa/Roxo
        end

        -- SE O JOGO NÃO TIVER TIME, USA A COR DO TIME PADRÃO DO ROBLOX
        if player.TeamColor then
            highlight.OutlineColor = player.TeamColor.Color
        end
    end)
end

-- Ativa para quem já está no servidor
for _, player in pairs(Players:GetPlayers()) do
    if player ~= lp then
        if player.Character then
            -- Chama a função manualmente para quem já nasceu
            applyESP(player)
            -- Força a criação se já tiver char
            local char = player.Character
            local hl = Instance.new("Highlight", char)
            hl.FillColor = (player.Team == lp.Team) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(138, 43, 226)
            hl.OutlineColor = player.TeamColor.Color
            hl.FillTransparency = 0.5
        end
        applyESP(player)
    end
end

-- Ativa para quem entrar depois
Players.PlayerAdded:Connect(applyESP)

print("ESP Vazio Roxo ativado com sucesso!")
