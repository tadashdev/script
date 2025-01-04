-- Serviços necessários
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Função para calcular a distância entre dois pontos
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Função para encontrar o Chest mais próximo
local function findClosestChest()
    local closestChest = nil
    local shortestDistance = math.huge
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    if not character:FindFirstChild("HumanoidRootPart") then return end
    local playerPosition = character.HumanoidRootPart.Position

    -- Iterar por todos os objetos no Workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:match("^Chest%d*$") then
            local distance = getDistance(playerPosition, obj.Position)
            if distance < shortestDistance then
                closestChest = obj
                shortestDistance = distance
            end
        end
    end

    return closestChest
end

-- Função para teleportar o jogador
local function teleportToChest(chest)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = chest.CFrame + Vector3.new(0, 3, 0) -- Teleporta acima do Chest
        print("Teleportado para:", chest.Name)
    end
end

-- Função principal para coletar todos os Chests
local function collectAllChests()
    while true do
        local closestChest = findClosestChest()
        if closestChest then
            teleportToChest(closestChest)

            -- Aguarda 1 segundo para simular o tempo de coleta
            task.wait(5)

            -- Remover o Chest coletado (simulação)
            closestChest:Destroy()
        else
            print("Todos os Chests foram coletados!")
            break -- Sai do loop se não houver mais Chests
        end
    end
end

-- Inicia o processo de coleta
collectAllChests()
