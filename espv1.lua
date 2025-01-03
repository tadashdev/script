-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variáveis de controle
local ESP_ENABLED = false -- Começa desativado
local lines = {}
local aura = {}
local healthBars = {}

-- Função para ativar/desativar a ESP
local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED
end

-- Função para criar a linha de ESP
local function createESP(player)
    if not lines[player] then
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.fromRGB(255, 0, 0) -- Vermelho
        lines[player] = line
    end
end

-- Função para criar a aura
local function createAura(player)
    if not aura[player] then
        local circle = Drawing.new("Circle")
        circle.Radius = 15 -- Tamanho da aura
        circle.Thickness = 3
        circle.Color = Color3.fromRGB(255, 0, 0) -- Vermelho
        circle.Filled = false
        aura[player] = circle
    end
end

-- Função para criar a barra de vida
local function createHealthBar(player)
    if not healthBars[player] then
        local bar = Drawing.new("Line")
        bar.Thickness = 4
        bar.Color = Color3.fromRGB(0, 255, 0) -- Verde
        healthBars[player] = bar
    end
end

-- Função para atualizar a ESP (linha, aura e barra de vida)
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild("Humanoid")

            createESP(player)
            createAura(player)
            createHealthBar(player)

            -- Calcula posições na tela
            local screenPosRoot, onScreenRoot = Camera:WorldToViewportPoint(rootPart.Position)
            local screenPosHead, onScreenHead = Camera:WorldToViewportPoint(head.Position)

            if ESP_ENABLED and onScreenRoot and onScreenHead then
                -- Atualiza a linha
                lines[player].Visible = true
                lines[player].From = Vector2.new(Camera.ViewportSize.X / 2, 0) -- Topo da tela
                lines[player].To = Vector2.new(screenPosRoot.X, screenPosRoot.Y)

                -- Atualiza a aura (na cabeça)
                aura[player].Visible = true
                aura[player].Position = Vector2.new(screenPosHead.X, screenPosHead.Y)

                -- Atualiza a barra de vida (ao lado da cabeça)
                if humanoid then
                    healthBars[player].Visible = true
                    healthBars[player].From = Vector2.new(screenPosHead.X + 20, screenPosHead.Y - 10)
                    healthBars[player].To = Vector2.new(
                        screenPosHead.X + 20,
                        screenPosHead.Y - 10 + (30 * (humanoid.Health / humanoid.MaxHealth))
                    )

                    -- Atualiza a cor da barra de vida
                    healthBars[player].Color = Color3.fromRGB(
                        255 - (255 * (humanoid.Health / humanoid.MaxHealth)),
                        255 * (humanoid.Health / humanoid.MaxHealth),
                        0
                    )
                end
            else
                -- Esconde os elementos se não estiverem na tela ou se ESP estiver desativado
                lines[player].Visible = false
                aura[player].Visible = false
                healthBars[player].Visible = false
            end
        end
    end
end

-- Função para limpar os objetos quando o jogador sai
Players.PlayerRemoving:Connect(function(player)
    if lines[player] then
        lines[player]:Remove()
        lines[player] = nil
    end
    if aura[player] then
        aura[player]:Remove()
        aura[player] = nil
    end
    if healthBars[player] then
        healthBars[player]:Remove()
        healthBars[player] = nil
    end
end)

-- Criar o botão de ativar/desativar ESP
local function createButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 200, 0, 50)
    Button.Position = UDim2.new(0, 20, 0, 100)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = "ESP: OFF"
    Button.Parent = ScreenGui

    Button.MouseButton1Click:Connect(function()
        toggleESP() -- Alterna o estado do ESP
        Button.Text = "ESP: " .. (ESP_ENABLED and "ON" or "OFF")
    end)
end

-- Inicializa o botão e atualiza a ESP
createButton()
RunService.RenderStepped:Connect(updateESP)
