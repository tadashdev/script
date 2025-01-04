local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Parâmetros do FOV e a lógica de AimLock
local AIM_FOV = 200  -- FOV (distância máxima de alcance do aimlock)
local AIM_SENSITIVITY = 0.5  -- Sensibilidade do aimlock (ajuste da velocidade)

-- Função para calcular a distância entre o jogador e o inimigo
local function getDistanceToHead(player)
    local character = player.Character
    if character and character:FindFirstChild("Head") then
        local head = character.Head
        return (head.Position - Camera.CFrame.Position).magnitude
    end
    return math.huge -- Retorna um valor infinito se não tiver cabeça
end

-- Função para ativar o Aimlock
local function aimLock()
    local closestPlayer = nil
    local closestDistance = AIM_FOV  -- Define a distância máxima de visão para o aimlock

    -- Encontrar o inimigo mais próximo dentro do FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = getDistanceToHead(player)

            -- Verifica se o inimigo está dentro do FOV e se é o mais próximo
            if distance <= AIM_FOV and distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    -- Se encontrar um inimigo, ajusta a mira para o Head
    if closestPlayer then
        local enemyHead = closestPlayer.Character.Head
        local directionToEnemy = (enemyHead.Position - Camera.CFrame.Position).unit
        local aimDirection = Camera.CFrame.Position + directionToEnemy * closestDistance

        -- Ajuste a posição da câmera para mirar diretamente no Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimDirection)
    end
end

-- Função que executa o aimlock continuamente
RunService.RenderStepped:Connect(function()
    aimLock()
end)

-- Cria a UI para ativar/desativar o Aimlock
local function createAimlockUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AimlockUI"
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
    Title.Text = "Aimlock Menu"
    Title.TextScaled = true
    Title.Parent = Frame

    -- Botão para ativar/desativar Aimlock
    local AimlockButton = Instance.new("TextButton")
    AimlockButton.Size = UDim2.new(1, -10, 0, 30)
    AimlockButton.Position = UDim2.new(0, 5, 0, 40)
    AimlockButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AimlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimlockButton.Text = "Aimlock: ON"
    AimlockButton.Parent = Frame

    local aimlockEnabled = true

    AimlockButton.MouseButton1Click:Connect(function()
        aimlockEnabled = not aimlockEnabled
        AimlockButton.Text = "Aimlock: " .. (aimlockEnabled and "ON" or "OFF")
    end)

    -- Conectar a função de Aimlock com a ativação/desativação
    RunService.RenderStepped:Connect(function()
        if aimlockEnabled then
            aimLock()
        end
    end)
end

-- Inicializa a interface de usuário (UI)
createAimlockUI()
