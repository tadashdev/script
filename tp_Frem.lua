local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuração inicial
local teleporting = false -- Controla se o processo está ativo

-- Função para tornar objetos atravessáveis ou removê-los
local function makeObjectsPassThrough()
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Part") and (object.Name == "Frame" or object.Name == "TopLoop" or object.Name == "TopBeams") then
            object.CanCollide = false -- Torna o objeto atravessável
            object.Transparency = 0.5 -- Ajuste de transparência (opcional)
        end
    end
end

-- Função para coletar todos os objetos do tipo 'Flag'
local function collectFlags()
    local flags = {}
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Part") and object.Name == "Flag" then
            table.insert(flags, object)
        end
    end
    return flags
end

-- Função para encontrar o Flag mais distante
local function findMostDistantFlag(flags)
    local mostDistantFlag = nil
    local maxDistance = 0
    for _, flag in ipairs(flags) do
        local distanceFromPlayer = (flag.Position - Camera.CFrame.Position).magnitude
        if distanceFromPlayer > maxDistance then
            maxDistance = distanceFromPlayer
            mostDistantFlag = flag
        end
    end
    return mostDistantFlag
end

-- Função principal de teleporte
local function startTeleportation()
    local flags = collectFlags()

    -- Encontrar o Flag mais distante
    local mostDistantFlag = findMostDistantFlag(flags)
    if mostDistantFlag then
        print("Iniciando teleporte para o Flag mais distante: " .. mostDistantFlag.Name)
        while teleporting do
            LocalPlayer.Character:MoveTo(mostDistantFlag.Position)
            print("Teleportado para Flag mais distante.")
            teleporting = false -- Finaliza o processo após o teleporte
        end
    else
        print("Nenhum Flag encontrado.")
    end
end

-- Função para criar botão de ativação/desativação
local function createTeleportButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0, 20, 0, 100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Draggable = true
    Frame.Active = true
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Teleport Menu"
    Title.TextScaled = true
    Title.Parent = Frame

    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(1, -10, 0, 40)
    TeleportButton.Position = UDim2.new(0, 5, 0, 40)
    TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.Text = teleporting and "Desativar Teleporte" or "Ativar Teleporte"
    TeleportButton.Parent = Frame

    TeleportButton.MouseButton1Click:Connect(function()
        teleporting = not teleporting
        TeleportButton.Text = teleporting and "Desativar Teleporte" or "Ativar Teleporte"
        if teleporting then
            startTeleportation()
        end
    end)
end

-- Tornar os objetos atravessáveis
makeObjectsPassThrough()

-- Criar a interface
createTeleportButton()
