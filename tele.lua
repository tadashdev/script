local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Parâmetros para o teleporte e a lógica de seguir
local teleporting = false
local followPlayer = nil

-- Função para criar a interface de seleção de jogador e ativação do teleporte
local function createTeleportUI()
    -- Cria a interface no PlayerGui do jogador
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Frame principal
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 300)
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

    -- Criar o ScrollingFrame para permitir rolagem
    local PlayerListScroll = Instance.new("ScrollingFrame")
    PlayerListScroll.Size = UDim2.new(1, -10, 0, 200)
    PlayerListScroll.Position = UDim2.new(0, 5, 0, 40)
    PlayerListScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    PlayerListScroll.BorderSizePixel = 0
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Inicialmente, o tamanho do canvas é 0
    PlayerListScroll.ScrollBarThickness = 10  -- Espessura da barra de rolagem
    PlayerListScroll.Parent = Frame

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Padding = UDim.new(0, 5)
    PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayerListLayout.Parent = PlayerListScroll

    -- Função para atualizar a lista de jogadores
    local function updatePlayerList()
        -- Limpar a lista antes de adicionar novos jogadores
        for _, child in ipairs(PlayerListScroll:GetChildren()) do
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
                PlayerButton.Parent = PlayerListScroll

                -- Ação ao clicar no jogador
                PlayerButton.MouseButton1Click:Connect(function()
                    -- Teleportar para o jogador selecionado
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
                        -- Começar a seguir o jogador
                        followPlayer = player
                        teleporting = true
                    end
                end)
            end
        end

        -- Atualizar o tamanho do canvas para permitir a rolagem
        PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListScroll.UIListLayout.AbsoluteContentSize.Y)
    end

    -- Atualiza a lista de jogadores a cada vez que a lista de jogadores no servidor muda
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)

    -- Inicializar a lista
    updatePlayerList()
end

-- Função para seguir o jogador
local function followPlayerLogic()
    if followPlayer and followPlayer.Character and followPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Seguir o jogador
        LocalPlayer.Character:SetPrimaryPartCFrame(followPlayer.Character.HumanoidRootPart.CFrame)
    end
end

-- Iniciar a criação da interface de teleporte
createTeleportUI()

-- Função para atualizar o jogador que está sendo seguido
RunService.Heartbeat:Connect(function()
    if teleporting then
        followPlayerLogic()
    end
end)
