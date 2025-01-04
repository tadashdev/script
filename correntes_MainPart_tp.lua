local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Variáveis para controle do teleporte
local teleporting = false  -- Controla se o processo de teleportação está ativo
local teleportCoroutine = nil  -- Referência para a coroutine que controla os teleportes

-- Função para encontrar todos os objetos chamados 'MainPart' do tipo 'Part'
local function findMainParts()
    local mainParts = {}
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Part") and object.Name == "MainPart" then
            table.insert(mainParts, object)
        end
    end
    return mainParts
end

-- Função para calcular a distância entre o jogador e o objeto
local function getDistanceToMainPart(mainPart)
    return (mainPart.Position - Camera.CFrame.Position).magnitude
end

-- Função para teleportar o jogador para os MainParts mais próximos em ordem crescente
local function teleportToMainParts()
    local mainParts = findMainParts()

    -- Se não houver nenhum MainPart, interrompe
    if #mainParts == 0 then
        print("Nenhum MainPart encontrado.")
        return
    end

    -- Ordenar os objetos por proximidade
    table.sort(mainParts, function(a, b)
        return getDistanceToMainPart(a) < getDistanceToMainPart(b)
    end)

    -- Criar uma tabela de controladores para ignorar objetos já teleportados
    local teleportedParts = {}

    -- Teleportar para os MainParts mais próximos em ordem crescente, sem repetir
    for _, mainPart in ipairs(mainParts) do
        if not table.find(teleportedParts, mainPart) then
            LocalPlayer.Character:MoveTo(mainPart.Position)
            table.insert(teleportedParts, mainPart)
            print("Teleportado para: " .. mainPart.Name)
            wait(2)  -- Aguarda 2 segundos antes de teleportar novamente
        end
    end
end

-- Função para criar a interface de ativação/desativação do teleporte
local function createTeleportButton()
    -- Cria a interface no PlayerGui do jogador
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Frame principal
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
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
    Title.Text = "Teleport Menu"
    Title.TextScaled = true
    Title.Parent = Frame

    -- Botão de Ativar/Desativar
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(1, -10, 0, 40)
    TeleportButton.Position = UDim2.new(0, 5, 0, 40)
    TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.Text = teleporting and "Desativar Teleporte" or "Ativar Teleporte"
    TeleportButton.Parent = Frame

    -- Ação ao clicar no botão
    TeleportButton.MouseButton1Click:Connect(function()
        if teleporting then
            -- Se o teleporte estiver ativo, desative-o
            teleporting = false
            TeleportButton.Text = "Ativar Teleporte"
            if teleportCoroutine then
                -- Interrompe a coroutine se o teleporte for desativado
                coroutine.close(teleportCoroutine)
                teleportCoroutine = nil
            end
        else
            -- Ativa o teleporte
            teleporting = true
            TeleportButton.Text = "Desativar Teleporte"
            teleportCoroutine = coroutine.create(function()
                while teleporting do
                    teleportToMainParts()
                    wait(2)  -- Aguarda 2 segundos antes de reiniciar o processo
                end
            end)
            coroutine.resume(teleportCoroutine)
        end
    end)
end

-- Criar a interface de teleporte quando o jogo começar
createTeleportButton()
