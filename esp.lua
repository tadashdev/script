-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Jogador local
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis de controle para ESP
local ESP_ENABLED = true
local AUTO_REFRESH = true -- Controla se o ESP será recriado automaticamente a cada rodada

-- Função para criar ESP (local)
local function CreateESP(player)
    if player == LocalPlayer then return end -- Ignorar o próprio jogador

    local character = player.Character
    if character and character:FindFirstChild("Head") and character:FindFirstChild("Humanoid") then
        -- Remover ESP antiga, se existir
        if character.Head:FindFirstChild("ESP") then
            character.Head.ESP:Destroy()
        end

        -- Criar interface de ESP
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = character.Head
        billboard.Size = UDim2.new(4, 0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = character.Head

        -- Nome do jogador
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.Parent = billboard

        -- Barra de vida
        local healthBarBg = Instance.new("Frame")
        healthBarBg.Size = UDim2.new(1, 0, 0.25, 0)
        healthBarBg.Position = UDim2.new(0, 0, 0.75, 0)
        healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        healthBarBg.BorderSizePixel = 0
        healthBarBg.Parent = billboard

        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = healthBarBg

        -- Atualizar barra de vida
        RunService.RenderStepped:Connect(function()
            if character and character:FindFirstChild("Humanoid") then
                local health = character.Humanoid.Health
                local maxHealth = character.Humanoid.MaxHealth
                healthBar.Size = UDim2.new(math.clamp(health / maxHealth, 0, 1), 0, 1, 0)
                healthBar.BackgroundColor3 = health > maxHealth * 0.5 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end)
    end
end

-- Função para remover ESP
local function RemoveESP(player)
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local esp = player.Character.Head:FindFirstChild("ESP")
        if esp then
            esp:Destroy()
        end
    end
end

-- Atualizar ESP para todos os jogadores
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if ESP_ENABLED then
            CreateESP(player)
        else
            RemoveESP(player)
        end
    end
end

-- Monitorar novos jogadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESP_ENABLED then
            CreateESP(player)
        end
    end)
end)

-- Monitorar remoção de jogadores
Players.PlayerRemoving:Connect(RemoveESP)

-- Monitorar mudanças no personagem local
LocalPlayer.CharacterAdded:Connect(function()
    if AUTO_REFRESH then
        wait(1) -- Esperar o carregamento do personagem
        UpdateESP()
    end
end)

-- Interface gráfica para ativar/desativar ESP e auto-refresh
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextScaled = true
ToggleButton.Text = "ESP: ON | Auto: ON"
ToggleButton.Parent = PlayerGui

ToggleButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    AUTO_REFRESH = not AUTO_REFRESH
    UpdateESP()
    ToggleButton.Text = "ESP: " .. (ESP_ENABLED and "ON" or "OFF") .. " | Auto: " .. (AUTO_REFRESH and "ON" or "OFF")
end)

-- Inicializar ESP
UpdateESP()

