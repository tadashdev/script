-- Espera o jogador e o personagem ficarem disponíveis
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")

-- Criação da interface (ScreenGui) e botões
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ajuste o tamanho do frame para acomodar todos os botões
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 420)
frame.Position = UDim2.new(0.5, -120, 0.5, -210)
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

-- Botão para iniciar o teleporte automático para OuterOrb
local tpOrbButton = Instance.new("TextButton")
tpOrbButton.Size = UDim2.new(1, -20, 0, 40)
tpOrbButton.Position = UDim2.new(0, 10, 0, 110)
tpOrbButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
tpOrbButton.Text = "TP Orb"
tpOrbButton.Parent = frame

-- Botão para teletransportar uma vez para o JungleEgg
local tpEggButton = Instance.new("TextButton")
tpEggButton.Size = UDim2.new(1, -20, 0, 40)
tpEggButton.Position = UDim2.new(0, 10, 0, 160)
tpEggButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
tpEggButton.Text = "TP Egg"
tpEggButton.Parent = frame

-- Botão para teletransportar para o finishPart mais próximo
local tpFinalButton = Instance.new("TextButton")
tpFinalButton.Size = UDim2.new(1, -20, 0, 40)
tpFinalButton.Position = UDim2.new(0, 10, 0, 210)
tpFinalButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
tpFinalButton.Text = "TP Final"
tpFinalButton.Parent = frame

-- Botão para parar todos os ciclos de teleporte
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, -20, 0, 40)
stopButton.Position = UDim2.new(0, 10, 0, 260)
stopButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
stopButton.Text = "Stop TP"
stopButton.Parent = frame

-- Botão para fechar a interface
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(1, -20, 0, 40)
closeButton.Position = UDim2.new(0, 10, 0, 310)
closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeButton.Text = "Close"
closeButton.Parent = frame

------------------------------------------------------
-- Lógica para OuterGem Teleport (com armazenamento)
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
            wait(0.1)
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
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("MeshPart") and obj.Name == "Hoop" then
                    table.insert(hoops, obj)
                end
            end
            if #hoops > 0 then
                for _, hoop in ipairs(hoops) do
                    if not isTeleportingHoop then break end
                    humanoidRootPart.CFrame = CFrame.new(hoop.Position + Vector3.new(0, 5, 0))
                    print("Teleported to Hoop: " .. hoop:GetFullName())
                    wait(0.1)
                end
            else
                print("Nenhum Hoop encontrado no Workspace.")
                wait(1)
            end
        end
    end)
end

------------------------------------------------------
-- Lógica para OuterOrb Teleport (sem armazenamento; teleporta para todas as orbs)
------------------------------------------------------
local isTeleportingOrb = false

local function startOuterOrbTeleportCycle()
    if isTeleportingOrb then
        print("Teleporte de OuterOrb já está ativo.")
        return
    end
    isTeleportingOrb = true
    print("Ciclo de teleporte de OuterOrb iniciado.")
    spawn(function()
        while isTeleportingOrb do
            local orbs = {}
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") and obj.Name == "outerOrb" then
                    table.insert(orbs, obj)
                end
            end
            if #orbs > 0 then
                for _, orb in ipairs(orbs) do
                    if not isTeleportingOrb then break end
                    humanoidRootPart.CFrame = CFrame.new(orb.Position + Vector3.new(0, 5, 0))
                    print("Teleported to outerOrb: " .. orb:GetFullName())
                    wait(0.1)
                end
            else
                print("Nenhum outerOrb encontrado no Workspace.")
                wait(1)
            end
        end
    end)
end

------------------------------------------------------
-- Lógica para TP Egg (teleporta uma única vez para JungleEgg_Cube.001)
------------------------------------------------------
local function tpEgg()
    local meshesFolder = Workspace:FindFirstChild("Meshes")
    if meshesFolder then
        local jungleEgg = meshesFolder:FindFirstChild("JungleEgg_Cube.001")
        if jungleEgg and jungleEgg:IsA("MeshPart") then
            humanoidRootPart.CFrame = CFrame.new(jungleEgg.Position + Vector3.new(0, 5, 0))
            print("Teleported to JungleEgg_Cube.001")
        else
            print("JungleEgg_Cube.001 não encontrado ou não é um MeshPart.")
        end
    else
        print("Pasta 'Meshes' não encontrada no Workspace.")
    end
end

------------------------------------------------------
-- Lógica para TP Final (teleporta para o finishPart mais próximo)
------------------------------------------------------
local function tpFinal()
    local closestFinish = nil
    local minDistance = math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "finishPart" then
            local distance = (obj.Position - humanoidRootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestFinish = obj
            end
        end
    end
    if closestFinish then
        humanoidRootPart.CFrame = CFrame.new(closestFinish.Position + Vector3.new(0, 5, 0))
        print("Teleported to finishPart: " .. closestFinish:GetFullName())
    else
        print("Nenhum finishPart encontrado no Workspace.")
    end
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

tpOrbButton.MouseButton1Click:Connect(function()
    startOuterOrbTeleportCycle()
end)

tpEggButton.MouseButton1Click:Connect(function()
    tpEgg()
end)

tpFinalButton.MouseButton1Click:Connect(function()
    tpFinal()
end)

stopButton.MouseButton1Click:Connect(function()
    isTeleportingOuterGem = false
    isTeleportingHoop = false
    isTeleportingOrb = false
    print("Todos os ciclos de teleporte parados.")
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
