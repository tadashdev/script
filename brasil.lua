local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local teleportingToSpawns = false -- Controla se o teleporte para Spawns está ativo

-- Função para coletar todos os objetos do tipo 'Spawn'
local function collectSpawns()
    local spawns = {}
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("SpawnLocation") then
            table.insert(spawns, object)
        end
    end

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

-- Função para localizar todos os objetos chamados 'hit'
local function collectHitParts()
    local hitParts = {}
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("Part") and object.Name == "Hit" then
            table.insert(hitParts, object)
        end
    end

    print("Partes 'hit' encontradas:", #hitParts)
    return hitParts
end

-- Função para teleportar o jogador para todos os objetos 'hit'
local function teleportToAllHitParts()
    local hitParts = collectHitParts()
    if #hitParts == 0 then
        warn("Nenhum objeto 'hit' encontrado no Workspace.")
        return
    end

    print("Teleportando para todas as partes 'hit'...")
    for _, part in ipairs(hitParts) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
            wait(0.5)
        end
    end
    print("Teleporte concluído.")
end

-- Criar interface com sistema de rolagem e botão fixo
local function createTeleportButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 250, 0, 300)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true -- Permite mover o layout
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Teleport Manager"
    Title.TextScaled = true
    Title.Parent = Frame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(1, 0, 0, 40)
    CloseButton.Position = UDim2.new(0, 0, 1, -40) -- Botão fixo na parte inferior
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Text = "Fechar"
    CloseButton.Parent = Frame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -10, 1, -80) -- Ajusta para não sobrepor o botão "Fechar"
    ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 300) -- Tamanho da área de rolagem
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Parent = Frame

    -- Botão para teleporte ao Spawn mais próximo
    local SpawnTeleportButton = Instance.new("TextButton")
    SpawnTeleportButton.Size = UDim2.new(1, -10, 0, 40)
    SpawnTeleportButton.Position = UDim2.new(0, 5, 0, 5)
    SpawnTeleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    SpawnTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpawnTeleportButton.Text = "Teleportar para Spawn mais próximo"
    SpawnTeleportButton.Parent = ScrollingFrame

    SpawnTeleportButton.MouseButton1Click:Connect(function()
        teleportToClosestSpawn()
    end)

    -- Botão para teleporte para objetos 'hit'
    local HitTeleportButton = Instance.new("TextButton")
    HitTeleportButton.Size = UDim2.new(1, -10, 0, 40)
    HitTeleportButton.Position = UDim2.new(0, 5, 0, 55)
    HitTeleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    HitTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    HitTeleportButton.Text = "Teleportar para todos os 'hit'"
    HitTeleportButton.Parent = ScrollingFrame

    HitTeleportButton.MouseButton1Click:Connect(function()
        teleportToAllHitParts()
    end)
end

-- Criar a interface
createTeleportButton()
