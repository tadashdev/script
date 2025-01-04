local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Parâmetros do FOV e a lógica de AimLock
local AIM_FOV = 200  -- FOV (distância máxima de alcance do aimlock)
local AIM_SENSITIVITY = 0.5  -- Sensibilidade do aimlock (ajuste da velocidade)

local selectedPlayers = {}  -- Jogadores atualmente selecionados para o AimLock
local aimlockEnabled = false -- Controle de ativação do AimLock

-- Função para calcular a distância entre o jogador e o inimigo
local function getDistanceToHead(player)
    local character = player.Character
    if character and character:FindFirstChild("Head") then
        local head = character.Head
        return (head.Position - Camera.CFrame.Position).magnitude
    end
    return math.huge -- Retorna um valor infinito se não tiver cabeça
end

-- Função para ativar o Aimlock para jogadores selecionados
local function aimLock()
    for _, player in ipairs(selectedPlayers) do
        if not player.Character or not player.Character:FindFirstChild("Head") then
            continue
        end

        -- Calcular a distância até a cabeça do jogador selecionado
        local enemyHead = player.Character.Head
        local distance = getDistanceToHead(player)

        -- Verificar se o inimigo está dentro do FOV
        if distance <= AIM_FOV then
            -- Ajustar a direção da câmera para mirar no Head do inimigo
            local directionToEnemy = (enemyHead.Position - Camera.CFrame.Position).unit
            local aimDirection = Camera.CFrame.Position + directionToEnemy * distance

            -- Ajuste a posição da câmera para mirar diretamente no Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimDirection)
        end
    end
end

-- Função que executa o aimlock continuamente
RunService.RenderStepped:Connect(function()
    if aimlockEnabled then
        aimLock()
    end
end)

-- Função para criar a interface de seleção de jogador e ativação/desativação do Aimlock
local function createAimlockUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AimlockUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Frame principal
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 250)
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
    AimlockButton.Text = "Aimlock: OFF"
    AimlockButton.Parent = Frame

    -- Lista de jogadores
    local PlayerList = Instance.new("Frame")
    PlayerList.Size = UDim2.new(1, -10, 0, 120)
    PlayerList.Position = UDim2.new(0, 5, 0, 80)
    PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    PlayerList.BorderSizePixel = 0
    PlayerList.Parent = Frame

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Padding = UDim.new(0, 5)
    PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayerListLayout.Parent = PlayerList

    -- Função para atualizar a lista de jogadores
    local function updatePlayerList()
        -- Limpar a lista antes de adicionar novos jogadores
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        -- Atualizar com os jogadores atuais
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local PlayerButton = Instance.new("TextButton")
                PlayerButton.Size = UDim2.new(1, 0, 0, 30)
                PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerButton.Text = player.Name
                PlayerButton.Parent = PlayerList

                -- Ação ao clicar no jogador
                PlayerButton.MouseButton1Click:Connect(function()
                    if table.find(selectedPlayers, player) then
                        -- Desmarcar jogador
                        for i, selected in ipairs(selectedPlayers) do
                            if selected == player then
                                table.remove(selectedPlayers, i)
                                break
                            end
                        end
                        PlayerButton.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Vermelho
                    else
                        -- Marcar jogador
                        table.insert(selectedPlayers, player)
                        PlayerButton.TextColor3 = Color3.fromRGB(0, 255, 0)  -- Verde
                    end
                end)
            end
        end
    end

    -- Atualiza a lista de jogadores a cada vez que a lista de jogadores no servidor muda
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)

    -- Inicializar a lista
    updatePlayerList()

    -- Ação ao clicar no botão de Aimlock
    AimlockButton.MouseButton1Click:Connect(function()
        aimlockEnabled = not aimlockEnabled
        AimlockButton.Text = "Aimlock: " .. (aimlockEnabled and "ON" or "OFF")
    end)
end

-- Inicializa a interface de usuário (UI) e garante que ela não desapareça
createAimlockUI()
