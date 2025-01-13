-- Serviços necessários
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Coordenadas do destino fixo
local teleportPositions = {
    Normal = Vector3.new(-743.93, -3.60, -553.49),
    Portal = Vector3.new(-980.49, 103.60, 1246.07)
}

-- Variável para controlar o teletransporte contínuo
local teleportActive = false
local teleportLoop

-- Função para criar a interface gráfica com movimentação
local function createTeleportGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Criar frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- Permite movimentar o layout
    MainFrame.Parent = ScreenGui

    -- Título do painel
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Painel de Teletransporte"
    Title.TextScaled = true
    Title.Parent = MainFrame

    -- Botão de teletransporte contínuo
    local ActivateButton = Instance.new("TextButton")
    ActivateButton.Size = UDim2.new(0, 200, 0, 50)
    ActivateButton.Position = UDim2.new(0.5, -100, 0, 60)
    ActivateButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActivateButton.Text = "Ativar TP Contínuo"
    ActivateButton.TextScaled = true
    ActivateButton.Parent = MainFrame

    -- Botão de desativar teletransporte contínuo
    local DeactivateButton = Instance.new("TextButton")
    DeactivateButton.Size = UDim2.new(0, 200, 0, 50)
    DeactivateButton.Position = UDim2.new(0.5, -100, 0, 120)
    DeactivateButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    DeactivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DeactivateButton.Text = "Desativar TP Contínuo"
    DeactivateButton.TextScaled = true
    DeactivateButton.Parent = MainFrame

    -- Botão de TP para portal
    local PortalButton = Instance.new("TextButton")
    PortalButton.Size = UDim2.new(0, 200, 0, 50)
    PortalButton.Position = UDim2.new(0.5, -100, 0, 180)
    PortalButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    PortalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PortalButton.Text = "TP Portal"
    PortalButton.TextScaled = true
    PortalButton.Parent = MainFrame

    -- Botão de fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 200, 0, 50)
    CloseButton.Position = UDim2.new(0.5, -100, 0, 240)
    CloseButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Text = "Fechar"
    CloseButton.TextScaled = true
    CloseButton.Parent = MainFrame

    return ScreenGui, ActivateButton, DeactivateButton, PortalButton, CloseButton
end

-- Função para teletransportar o jogador para uma posição específica
local function teleportToPosition(position)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Certifique-se de que o personagem tenha um HumanoidRootPart
    humanoidRootPart.CFrame = CFrame.new(position) -- Define a posição para o jogador
end

-- Lógica do teletransporte contínuo
local function startTeleportLoop()
    if not teleportActive then
        teleportActive = true
        teleportLoop = coroutine.create(function()
            while teleportActive do
                teleportToPosition(teleportPositions.Normal)
                wait(0.5) -- Intervalo entre os teleportes
            end
        end)
        coroutine.resume(teleportLoop)
    end
end

local function stopTeleportLoop()
    teleportActive = false
end

-- Criar GUI e conectar eventos
local ScreenGui, ActivateButton, DeactivateButton, PortalButton, CloseButton = createTeleportGUI()

ActivateButton.MouseButton1Click:Connect(startTeleportLoop)
DeactivateButton.MouseButton1Click:Connect(stopTeleportLoop)

PortalButton.MouseButton1Click:Connect(function()
    teleportToPosition(teleportPositions.Portal)
end)

CloseButton.MouseButton1Click:Connect(function()
    stopTeleportLoop()
    ScreenGui:Destroy() -- Remove a interface gráfica
end)
