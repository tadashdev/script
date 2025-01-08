local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local teleportingToSpawns = false -- Controla se o teleporte para Spawns está ativo

-- Função para coletar todos os objetos do tipo 'Spawn'
local function collectSpawns()
    local spawns = {}
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("SpawnLocation") then
            table.insert(spawns, object)
        end
    end

    -- Exibir no console todos os Spawns encontrados
    print("Spawns encontrados:")
    for _, spawn in ipairs(spawns) do
        print("- Nome:", spawn.Name, "| Posição:", tostring(spawn.Position))
    end

    return spawns
end

-- Função para encontrar o Spawn mais próximo
local function findClosestSpawn(spawns)
    local closestSpawn = nil
    local minDistance = math.huge

    for _, spawn in ipairs(spawns) do
        local distance = (spawn.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
        if distance < minDistance then
            minDistance = distance
            closestSpawn = spawn
        end
    end

    return closestSpawn
end

-- Função de teleporte para o Spawn mais próximo
local function teleportToClosestSpawn()
    local spawns = collectSpawns()
    local closestSpawn = findClosestSpawn(spawns)

    if closestSpawn then
        print("Teleportando para Spawn:", closestSpawn.Name)
        LocalPlayer.Character:MoveTo(closestSpawn.Position)
    else
        print("Nenhum Spawn encontrado.")
    end
end

-- Adicionar um botão para teleporte ao Spawn mais próximo
local function createSpawnTeleportButton(parentFrame)
    local SpawnTeleportButton = Instance.new("TextButton")
    SpawnTeleportButton.Size = UDim2.new(1, -10, 0, 40)
    SpawnTeleportButton.Position = UDim2.new(0, 5, 0, 90)
    SpawnTeleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    SpawnTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpawnTeleportButton.Text = "Teleportar para Spawn mais próximo"
    SpawnTeleportButton.Parent = parentFrame

    SpawnTeleportButton.MouseButton1Click:Connect(function()
        teleportToClosestSpawn()
    end)
end

-- Criar interface
local function createTeleportButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 150)
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
    Title.Text = "Teleport Manager"
    Title.TextScaled = true
    Title.Parent = Frame

    createSpawnTeleportButton(Frame)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(1, -10, 0, 40)
    CloseButton.Position = UDim2.new(0, 5, 0, 140)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Text = "Fechar"
    CloseButton.Parent = Frame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end

-- Criar a interface
createTeleportButton()
