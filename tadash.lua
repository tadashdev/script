-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Variáveis de controle
local ESP_ENABLED = true
local SHOW_NAMES = true
local LINE_COLOR = Color3.fromRGB(255, 0, 0) -- Cor padrão: Vermelho

-- Tabela para armazenar linhas e nomes
local lines = {}
local names = {}

-- UI Principal (Floating Layout)
local function createFloatingUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPMenu"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Frame principal
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0, 20, 0, 100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Draggable = true
    Frame.Active = true
    Frame.Parent = ScreenGui

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "ESP Menu"
    Title.TextScaled = true
    Title.Parent = Frame

    -- Botão de Mostrar/Esconder Linhas
    local LineButton = Instance.new("TextButton")
    LineButton.Size = UDim2.new(1, -10, 0, 30)
    LineButton.Position = UDim2.new(0, 5, 0, 40)
    LineButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LineButton.Text = "Linhas: ON"
    LineButton.Parent = Frame

    LineButton.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        LineButton.Text = "Linhas: " .. (ESP_ENABLED and "ON" or "OFF")
    end)

    -- Botão de Mostrar/Esconder Nomes
    local NameButton = Instance.new("TextButton")
    NameButton.Size = UDim2.new(1, -10, 0, 30)
    NameButton.Position = UDim2.new(0, 5, 0, 80)
    NameButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameButton.Text = "Nomes: ON"
    NameButton.Parent = Frame

    NameButton.MouseButton1Click:Connect(function()
        SHOW_NAMES = not SHOW_NAMES
        NameButton.Text = "Nomes: " .. (SHOW_NAMES and "ON" or "OFF")
    end)

    -- Botão de Mudar Cor da Linha
    local ColorButton = Instance.new("TextButton")
    ColorButton.Size = UDim2.new(1, -10, 0, 30)
    ColorButton.Position = UDim2.new(0, 5, 0, 120)
    ColorButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorButton.Text = "Mudar Cor"
    ColorButton.Parent = Frame

    ColorButton.MouseButton1Click:Connect(function()
        -- Altera entre três cores (Vermelho, Verde, Azul)
        if LINE_COLOR == Color3.fromRGB(255, 0, 0) then
            LINE_COLOR = Color3.fromRGB(0, 255, 0) -- Verde
        elseif LINE_COLOR == Color3.fromRGB(0, 255, 0) then
            LINE_COLOR = Color3.fromRGB(0, 0, 255) -- Azul
        else
            LINE_COLOR = Color3.fromRGB(255, 0, 0) -- Vermelho
        end
    end)
end

-- Cria ou atualiza as linhas e nomes
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart

            -- Linhas
            if ESP_ENABLED then
                if not lines[player] then
                    lines[player] = Drawing.new("Line")
                    lines[player].Thickness = 2
                end
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    lines[player].Visible = true
                    lines[player].Color = LINE_COLOR
                    lines[player].From = Vector2.new(Camera.ViewportSize.X / 2, 0) -- Parte superior da tela
                    lines[player].To = Vector2.new(screenPos.X, screenPos.Y)
                else
                    lines[player].Visible = false
                end
            elseif lines[player] then
                lines[player].Visible = false
            end

            -- Nomes
            if SHOW_NAMES then
                if not names[player] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "PlayerNameESP"
                    billboard.Size = UDim2.new(4, 0, 1, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Adornee = rootPart

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    textLabel.TextScaled = true
                    textLabel.Text = player.Name
                    textLabel.Parent = billboard

                    billboard.Parent = player.Character:FindFirstChild("Head")
                    names[player] = billboard
                end
            elseif names[player] then
                names[player]:Destroy()
                names[player] = nil
            end
        end
    end
end

-- Limpeza ao sair
Players.PlayerRemoving:Connect(function(player)
    if lines[player] then
        lines[player]:Remove()
        lines[player] = nil
    end
    if names[player] then
        names[player]:Destroy()
        names[player] = nil
    end
end)

-- Inicializa a UI e atualiza ESP
createFloatingUI()
RunService.RenderStepped:Connect(updateESP)
