-- Serviços necessários
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

-- Criação de uma GUI para exibir informações
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ActionMonitor"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 500, 0, 300)
    Frame.Position = UDim2.new(0.5, -250, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Explorador de Ações"
    Title.TextScaled = true
    Title.Parent = Frame

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, -10, 1, -50)
    InfoLabel.Position = UDim2.new(0, 5, 0, 45)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.Text = "Monitorando ações..."
    InfoLabel.TextScaled = true
    InfoLabel.TextWrapped = true
    InfoLabel.Parent = Frame

    return InfoLabel
end

local InfoLabel = createGUI()

-- Monitoramento de Movimentação do Jogador (andar)
local function monitorMovement()
    LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoid.Running:Connect(function(speed)
            if speed > 0 then
                InfoLabel.Text = string.format("Jogador em movimento.\nVelocidade: %.2f", speed)
            end
        end)
    end)
end

-- Monitoramento de Troca de Arma e Ações com Arma
local function monitorWeaponActions()
    LocalPlayer.CharacterAdded:Connect(function(character)
        local backpack = LocalPlayer:WaitForChild("Backpack")

        -- Troca de armas
        backpack.ChildAdded:Connect(function(weapon)
            if weapon:IsA("Tool") then
                InfoLabel.Text = string.format("Arma equipada: %s", weapon.Name)
            end
        end)

        backpack.ChildRemoved:Connect(function(weapon)
            if weapon:IsA("Tool") then
                InfoLabel.Text = string.format("Arma removida: %s", weapon.Name)
            end
        end)
    end)
end

-- Monitoramento de Tiros e Projetéis
local function monitorShots()
    Workspace.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") and child.Name:lower():find("projectile") then
            -- O projétil deve ter um atributo de atirador (Shooter)
            local shooter = child:GetAttribute("Shooter") or "Desconhecido"
            InfoLabel.Text = string.format(
                "Tiro detectado!\nObjeto: %s\nAtirador: %s\nPosição: (%.2f, %.2f, %.2f)",
                child.Name,
                tostring(shooter),
                child.Position.X,
                child.Position.Y,
                child.Position.Z
            )
        end
    end)
end

-- Monitoramento de Clques e Interações
local function monitorInteractions()
    mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target then
            InfoLabel.Text = string.format(
                "Interação detectada!\nObjeto: %s\nTipo: %s\nPosição: (%.2f, %.2f, %.2f)",
                target.Name,
                target.ClassName,
                target.Position.X,
                target.Position.Y,
                target.Position.Z
            )
        end
    end)
end

-- Monitoramento de Mudanças no Jogo (Objetos que entram ou saem)
local function monitorGameObjects()
    Workspace.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") then
            InfoLabel.Text = string.format("Novo objeto detectado: %s\nPosição: (%.2f, %.2f, %.2f)", 
                child.Name, child.Position.X, child.Position.Y, child.Position.Z)
        end
    end)
end

-- Monitoramento de Eventos de Dano
local function monitorDamage()
    Workspace.DescendantAdded:Connect(function(child)
        if child:IsA("Humanoid") then
            child.HealthChanged:Connect(function(health)
                InfoLabel.Text = string.format("Dano recebido! Novo valor de saúde: %.2f", health)
            end)
        end
    end)
end

-- Iniciar monitoramento
monitorMovement()
monitorWeaponActions()
monitorShots()
monitorInteractions()
monitorGameObjects()
monitorDamage()
