-- Espera o jogador e o personagem ficarem disponíveis
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")

-- Criação da interface (ScreenGui) e botões
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 210)
frame.Position = UDim2.new(0.5, -120, 0.5, -105)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui

-- Botão para iniciar o teleporte automático para outerGem
local tpOuterGemButton = Instance.new("TextButton")
tpOuterGemButton.Size = UDim2.new(1, -20, 0, 40)
tpOuterGemButton.Position = UDim2.new(0, 10, 0, 10)
tpOuterGemButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
tpOuterGemButton.Text = "TP OuterGem"
tpOuterGemButton.Parent = frame

-- Botão para iniciar o teleporte automático para Hoop
local tpHoopButton = Instance.new("TextButton")
tpHoopButton.Size = UDim2.new(1, -20, 0, 40)
tpHoopButton.Position = UDim2.new(0, 10, 0, 60)
tpHoopButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
tpHoopButton.Text = "TP Hoop"
tpHoopButton.Parent = frame

-- Botão para parar os ciclos de teleporte
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, -20, 0, 40)
stopButton.Position = UDim2.new(0, 10, 0, 110)
stopButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
stopButton.Text = "Stop TP"
stopButton.Parent = frame

-- Botão para fechar a interface
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(1, -20, 0, 40)
closeButton.Position = UDim2.new(0, 10, 0, 160)
closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeButton.Text = "Close"
closeButton.Parent = frame

------------------------------------------------------
-- Lógica para OuterGem Teleport (mantém a lógica anterior com armazenamento)
------------------------------------------------------
local visitedOuterGems = {}

local function isOuterGemVisited(gem)
    for _, v in ipairs(visitedOuterGems) do
        if v == gem then
            return true
        end
    end
    return false
end

local function teleportToNextOuterGem()
    local nextGem = nil

    -- Procura por MeshPart com o nome "outerGem" que não foi visitado
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("MeshPart") and obj.Name == "outerGem" and not isOuterGemVisited(obj) then
            nextGem = obj
            break
        end
    end

    if nextGem then
        table.insert(visitedOuterGems, nextGem)
        humanoidRootPart.CFrame = CFrame.new(nextGem.Position + Vector3.new(0, 5, 0))
        print("Teleported to outerGem: " .. nextGem:GetFullName())
    else
        print("Todos os outerGem já foram visitados.")
    end
end

local isTeleportingOuterGem = false

local function startOuterGemTeleportCycle()
    if isTeleportingOuterGem then
        print("Teleporte de outerGem já está ativo.")
        return
    end
    isTeleportingOuterGem = true
    print("Ciclo de teleporte de outerGem iniciado.")
    spawn(function()
        while isTeleportingOuterGem do
            teleportToNextOuterGem()
            wait(0.1) -- Teleporte muito rápido
        end
    end)
end

------------------------------------------------------
-- Lógica para Hoop Teleport (sem armazenamento; repete em loop)
------------------------------------------------------
local isTeleportingHoop = false

local function startHoopTeleportCycle()
    if isTeleportingHoop then
        print("Teleporte de Hoop já está ativo.")
        return
    end
    isTeleportingHoop = true
    print("Ciclo de teleporte de Hoop iniciado.")
    spawn(function()
        while isTeleportingHoop do
            local hoops = {}
            -- Coleta todos os Hoop disponíveis
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("MeshPart") and obj.Name == "Hoop" then
                    table.insert(hoops, obj)
                end
            end
            -- Se houver Hoop, percorre todos eles em sequência
            if #hoops > 0 then
                for _, hoop in ipairs(hoops) do
                    if not isTeleportingHoop then break end
                    humanoidRootPart.CFrame = CFrame.new(hoop.Position + Vector3.new(0, 5, 0))
                    print("Teleported to Hoop: " .. hoop:GetFullName())
                    wait(0.1)  -- Intervalo entre cada teleporte
                end
            else
                print("Nenhum Hoop encontrado no Workspace.")
                wait(1)  -- Espera mais se não encontrar nenhum Hoop
            end
        end
    end)
end

------------------------------------------------------
-- Conexões dos Botões
------------------------------------------------------
tpOuterGemButton.MouseButton1Click:Connect(function()
    startOuterGemTeleportCycle()
end)

tpHoopButton.MouseButton1Click:Connect(function()
    startHoopTeleportCycle()
end)

stopButton.MouseButton1Click:Connect(function()
    isTeleportingOuterGem = false
    isTeleportingHoop = false
    print("Ciclos de teleporte parados.")
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
