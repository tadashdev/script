-- Serviços necessários
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

-- Criação de uma GUI para monitoramento e armazenamento
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ActionMonitor"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Janela para monitorar em tempo real
    local MonitorFrame = Instance.new("Frame")
    MonitorFrame.Size = UDim2.new(0, 500, 0, 300)
    MonitorFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MonitorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MonitorFrame.BorderSizePixel = 0
    MonitorFrame.Parent = ScreenGui

    local MonitorTitle = Instance.new("TextLabel")
    MonitorTitle.Size = UDim2.new(1, 0, 0, 40)
    MonitorTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MonitorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MonitorTitle.Text = "Monitoramento em Tempo Real"
    MonitorTitle.TextScaled = true
    MonitorTitle.Parent = MonitorFrame

    local MonitorInfo = Instance.new("TextLabel")
    MonitorInfo.Size = UDim2.new(1, -10, 1, -50)
    MonitorInfo.Position = UDim2.new(0, 5, 0, 45)
    MonitorInfo.BackgroundTransparency = 1
    MonitorInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    MonitorInfo.Text = "Monitorando ações..."
    MonitorInfo.TextScaled = true
    MonitorInfo.TextWrapped = true
    MonitorInfo.Parent = MonitorFrame

    -- Janela para armazenar eventos únicos
    local StorageFrame = Instance.new("ScrollingFrame")
    StorageFrame.Size = UDim2.new(0, 500, 0, 300)
    StorageFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
    StorageFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    StorageFrame.BorderSizePixel = 0
    StorageFrame.ScrollBarThickness = 8
    StorageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    StorageFrame.Parent = ScreenGui

    local StorageTitle = Instance.new("TextLabel")
    StorageTitle.Size = UDim2.new(1, 0, 0, 40)
    StorageTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    StorageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    StorageTitle.Text = "Armazenamento de Eventos Únicos"
    StorageTitle.TextScaled = true
    StorageTitle.Parent = StorageFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = StorageFrame

    return MonitorInfo, StorageFrame
end

-- Adicionar um evento ao layout de armazenamento
local storedEvents = {} -- Conjunto para evitar duplicação

local function addEventToStorage(storageFrame, text)
    if not storedEvents[text] then
        storedEvents[text] = true

        local EventLabel = Instance.new("TextLabel")
        EventLabel.Size = UDim2.new(1, -10, 0, 30)
        EventLabel.BackgroundTransparency = 1
        EventLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        EventLabel.Text = text
        EventLabel.TextScaled = true
        EventLabel.TextWrapped = true
        EventLabel.Parent = storageFrame

        -- Atualizar o tamanho do canvas para comportar novos eventos
        local currentCanvasSize = storageFrame.CanvasSize.Y.Offset
        storageFrame.CanvasSize = UDim2.new(0, 0, 0, currentCanvasSize + 35)
    end
end

local MonitorInfo, StorageFrame = createGUI()

-- Monitoramento em tempo real e armazenamento
local function monitorGameEvents()
    -- Monitoramento de interações
    mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target then
            local text = string.format(
                "Interação detectada!\nObjeto: %s\nTipo: %s\nPosição: (%.2f, %.2f, %.2f)",
                target.Name,
                target.ClassName,
                target.Position.X,
                target.Position.Y,
                target.Position.Z
            )
            MonitorInfo.Text = text
            addEventToStorage(StorageFrame, text)
        end
    end)

    -- Monitoramento de projéteis e tiros
    Workspace.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") and child.Name:lower():find("projectile") then
            local shooter = child:GetAttribute("Shooter") or "Desconhecido"
            local text = string.format(
                "Tiro detectado!\nObjeto: %s\nAtirador: %s\nPosição: (%.2f, %.2f, %.2f)",
                child.Name,
                tostring(shooter),
                child.Position.X,
                child.Position.Y,
                child.Position.Z
            )
            MonitorInfo.Text = text
            addEventToStorage(StorageFrame, text)
        end
    end)

    -- Monitoramento de armas
    LocalPlayer.CharacterAdded:Connect(function(character)
        local backpack = LocalPlayer:WaitForChild("Backpack")
        backpack.ChildAdded:Connect(function(weapon)
            if weapon:IsA("Tool") then
                local text = string.format("Arma equipada: %s", weapon.Name)
                MonitorInfo.Text = text
                addEventToStorage(StorageFrame, text)
            end
        end)

        backpack.ChildRemoved:Connect(function(weapon)
            if weapon:IsA("Tool") then
                local text = string.format("Arma removida: %s", weapon.Name)
                MonitorInfo.Text = text
                addEventToStorage(StorageFrame, text)
            end
        end)
    end)

    -- Monitoramento de objetos adicionados
    Workspace.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") then
            local text = string.format(
                "Novo objeto detectado: %s\nPosição: (%.2f, %.2f, %.2f)", 
                child.Name, child.Position.X, child.Position.Y, child.Position.Z
            )
            MonitorInfo.Text = text
            addEventToStorage(StorageFrame, text)
        end
    end)
end

-- Iniciar monitoramento
monitorGameEvents()
