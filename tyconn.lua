local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local teleporting = false -- Controla se o teleporte está ativo
local foundMoneyBoxes = {} -- Lista de MoneyBoxes encontrados
local foundSpawns = {} -- Lista de Spawns encontrados

-- Função para coletar todos os objetos do tipo 'MoneyBox'
local function collectMoneyBoxes()
    local moneyBoxes = {}
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Part") and string.match(object.Name, "^MoneyBox%d*$") then
            table.insert(moneyBoxes, object)
        end
    end

    -- Exibir no console todos os MoneyBoxes encontrados
    print("MoneyBoxes encontrados:")
    for _, moneyBox in ipairs(moneyBoxes) do
        print("- Nome:", moneyBox.Name, "| Posição:", tostring(moneyBox.Position))
    end

    return moneyBoxes
end

-- Função para coletar todos os objetos do tipo 'Spawn'
local function collectSpawns()
    local spawns = {}
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Part") and object.Name == "Spawn" then
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

-- Função para encontrar o MoneyBox mais próximo
local function findClosestMoneyBox(moneyBoxes)
    local closestMoneyBox = nil
    local minDistance = math.huge

    for _, moneyBox in ipairs(moneyBoxes) do
        local distance = (moneyBox.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
        if distance < minDistance then
            minDistance = distance
            closestMoneyBox = moneyBox
        end
    end

    return closestMoneyBox
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

-- Função principal de teleporte
local function startTeleportation()
    while teleporting do
        local moneyBoxes = collectMoneyBoxes()
        local closestMoneyBox = findClosestMoneyBox(moneyBoxes)

        if closestMoneyBox then
            print("Teleportando para MoneyBox:", closestMoneyBox.Name)
            LocalPlayer.Character:MoveTo(closestMoneyBox.Position)
            wait(0.2) -- Aguardar antes de procurar o próximo
        else
            print("Nenhum MoneyBox encontrado.")
            teleporting = false
        end
    end
end

-- Função para criar botão de ativação/desativação
local function createTeleportButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MoneyBoxUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 200)
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
    Title.Text = "MoneyBox Teleport"
    Title.TextScaled = true
    Title.Parent = Frame

    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(1, -10, 0, 40)
    TeleportButton.Position = UDim2.new(0, 5, 0, 40)
    TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.Text = teleporting and "Desativar Teleporte" or "Ativar Teleporte"
    TeleportButton.Parent = Frame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(1, -10, 0, 40)
    CloseButton.Position = UDim2.new(0, 5, 0, 90)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Text = "Fechar"
    CloseButton.Parent = Frame

    local InvasionButton = Instance.new("TextButton")
    InvasionButton.Size = UDim2.new(1, -10, 0, 40)
    InvasionButton.Position = UDim2.new(0, 5, 0, 140)
    InvasionButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    InvasionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    InvasionButton.Text = "Invasão"
    InvasionButton.Parent = Frame

    TeleportButton.MouseButton1Click:Connect(function()
        teleporting = not teleporting
        TeleportButton.Text = teleporting and "Desativar Teleporte" or "Ativar Teleporte"
        if teleporting then
            startTeleportation()
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        teleporting = false
    end)

    InvasionButton.MouseButton1Click:Connect(function()
        local spawns = collectSpawns()
        local closestSpawn = findClosestSpawn(spawns)
        if closestSpawn then
            print("Teleportando para Spawn:", closestSpawn.Name)
            LocalPlayer.Character:MoveTo(closestSpawn.Position)
        else
            print("Nenhum Spawn encontrado.")
        end
    end)
end

-- Criar a interface
createTeleportButton()

-- Monitorar constantemente por novos MoneyBoxes
game:GetService("Workspace").DescendantAdded:Connect(function(child)
    if child:IsA("Part") and string.match(child.Name, "^MoneyBox%d*$") then
        print("Novo MoneyBox encontrado:", child.Name)
        -- Se o teleporte estiver ativado, começa a teletransportar para o novo MoneyBox
        if teleporting then
            startTeleportation()
        end
    end
end)
