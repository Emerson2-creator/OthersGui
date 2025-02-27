-- Carrega a biblioteca Emerson2Library a partir de uma URL e cria uma nova instância
-- Feito por BOITONETO 
local Emerson2Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Emerson2-creator/UniversalVehicleScript/refs/heads/main/GUI/src/raw-gui-code/VehicleScript.lua"))()
local Emerson2 = Emerson2Library.new("Universal Vehicle Script", 5013109572)

-- Notificação para o jogador sobre a keybind padrão
Emerson2:Notify("Information", "The keybind to open/close the GUI is RightAlt (I recommend not changing it)")

-- Executa a notificação de criação do script em paralelo
spawn(function()
    wait(60)
    Emerson2:Notify("Information", "Created by BOITONETO(Roblox nickname) Enjoy the script!")
end)

-- Obtém serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

-- Função para obter o veículo a partir de um descendente
local function GetVehicleFromDescendant(Descendant)
    return
        Descendant:FindFirstAncestor(LocalPlayer.Name .. "\'s Car") or
        (Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
        (Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
        Descendant:FindFirstAncestorWhichIsA("Model")
end

-- Função para teletransportar o veículo para uma nova posição
local function TeleportVehicle(CoordinateFrame)
    local Parent = LocalPlayer.Character.Parent
    local Vehicle = GetVehicleFromDescendant(LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").SeatPart)
    LocalPlayer.Character.Parent = Vehicle
    local success, response = pcall(function()
        return Vehicle:SetPrimaryPartCFrame(CoordinateFrame)
    end)
    if not success then
        return Vehicle:MoveTo(CoordinateFrame.Position)
    end
end

-- Adiciona uma página e seção para o veículo
local vehiclePage = Emerson2:addPage("Vehicle", 8356815386)
local usageSection = vehiclePage:addSection("Usage")
local velocityEnabled = true
usageSection:addToggle("Keybinds Active", velocityEnabled, function(v) velocityEnabled = v end)

-- Função para adicionar o slider e keybind de multiplicador de velocidade
local function Multiplier()
    local velocityMult = 0.025
    local velocityEnabledKeyCode = Enum.KeyCode.W

    local speedSection = vehiclePage:addSection("Acceleration")
    speedSection:addSlider("Multiplier (Thousandths)", 25, 0, 50, function(v) velocityMult = v / 1000 end)
    speedSection:addKeybind("Velocity Enabled", velocityEnabledKeyCode, function()
        if not velocityEnabled then
            return
        end
        while UserInputService:IsKeyDown(velocityEnabledKeyCode) do
            task.wait(0)
            local Character = LocalPlayer.Character
            if Character and typeof(Character) == "Instance" then
                local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if Humanoid and typeof(Humanoid) == "Instance" then
                    local SeatPart = Humanoid.SeatPart
                    if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                        SeatPart.AssemblyLinearVelocity *= Vector3.new(1 + velocityMult, 1, 1 + velocityMult)
                    end
                end
            end
            if not velocityEnabled then
                break
            end
        end
    end, function(v) velocityEnabledKeyCode = v.KeyCode end)
end

-- Chamando a função Multiplier para adicionar o slider e keybind
Multiplier()

-- Função para adicionar a seção de desaceleração
local function Deceleration()
    local decelerateSelection = vehiclePage:addSection("Deceleration")
    local qbEnabledKeyCode = Enum.KeyCode.S
    local velocityMult2 = 150e-3
    decelerateSelection:addSlider("Brake Force (Thousandths)", velocityMult2 * 1e3, 0, 300, function(v) velocityMult2 = v / 1000 end)
    decelerateSelection:addKeybind("Quick Brake Enabled", qbEnabledKeyCode, function()
        if not velocityEnabled then
            return
        end
        while UserInputService:IsKeyDown(qbEnabledKeyCode) do
            task.wait(0)
            local Character = LocalPlayer.Character
            if Character and typeof(Character) == "Instance" then
                local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if Humanoid and typeof(Humanoid) == "Instance" then
                    local SeatPart = Humanoid.SeatPart
                    if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                        SeatPart.AssemblyLinearVelocity *= Vector3.new(1 - velocityMult2, 1, 1 - velocityMult2)
                    end
                end
            end
            if not velocityEnabled then
                break
            end
        end
    end, function(v) qbEnabledKeyCode = v.KeyCode end)

    decelerateSelection:addKeybind("Stop the Vehicle", Enum.KeyCode.P, function(v)
        if not velocityEnabled then
            return
        end
        local Character = LocalPlayer.Character
        if Character and typeof(Character) == "Instance" then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid and typeof(Humanoid) == "Instance" then
                local SeatPart = Humanoid.SeatPart
                if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                    SeatPart.AssemblyLinearVelocity *= Vector3.new(0, 0, 0)
                    SeatPart.AssemblyAngularVelocity *= Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end

-- Chamando a função Deceleration para adicionar a seção de desaceleração
Deceleration()

-- Função para adicionar a seção de voo
local function Flight()
    local flightSection = vehiclePage:addSection("Flight")
    local flightEnabled = false
    local flightSpeed = 1
    flightSection:addToggle("Enabled", false, function(v) flightEnabled = v end)
    flightSection:addSlider("Speed", 100, 0, 800, function(v) flightSpeed = v / 100 end)
    local defaultCharacterParent 
    RunService.Stepped:Connect(function()
        local Character = LocalPlayer.Character
        if flightEnabled == true then
            if Character and typeof(Character) == "Instance" then
                local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if Humanoid and typeof(Humanoid) == "Instance" then
                    local SeatPart = Humanoid.SeatPart
                    if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                        local Vehicle = GetVehicleFromDescendant(SeatPart)
                        if Vehicle and Vehicle:IsA("Model") then
                            Character.Parent = Vehicle
                            if not Vehicle.PrimaryPart then
                                if SeatPart.Parent == Vehicle then
                                    Vehicle.PrimaryPart = SeatPart
                                else
                                    Vehicle.PrimaryPart = Vehicle:FindFirstChildWhichIsA("BasePart")
                                end
                            end
                            local PrimaryPartCFrame = Vehicle:GetPrimaryPartCFrame()
                            Vehicle:SetPrimaryPartCFrame(CFrame.new(PrimaryPartCFrame.Position, PrimaryPartCFrame.Position + workspace.CurrentCamera.CFrame.LookVector) * (UserInputService:GetFocusedTextBox() and CFrame.new(0, 0, 0) or CFrame.new((UserInputService:IsKeyDown(Enum.KeyCode.D) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -flightSpeed) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.E) and flightSpeed / 2) or (UserInputService:IsKeyDown(Enum.KeyCode.Q) and -flightSpeed / 2) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.S) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -flightSpeed) or 0)))
                            SeatPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            SeatPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        else
            if Character and typeof(Character) == "Instance" then
                Character.Parent = defaultCharacterParent or Character.Parent
                defaultCharacterParent = Character.Parent
            end
        end
    end)
end

-- Chamando a função Flight para adicionar a seção de voo
Flight()

-- Adiciona uma página de configurações
local settingsPage = Emerson2:addPage("Settings", 5012544693)
local settingsSection = settingsPage:addSection("General Settings")

-- Variável para armazenar a keybind para abrir/fechar o GUI
local toggleKeybind = Enum.KeyCode.RightAlt

-- Função para fechar e abrir o GUI
local function CloseGUI()
    Emerson2:toggle()
end

-- Conecta o evento de entrada do usuário para a keybind de abrir/fechar o GUI
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == toggleKeybind then
        CloseGUI()
    end
end)

-- Adiciona um input text para o jogador escolher a keybind de abrir/fechar o GUI
settingsSection:addTextbox("Keybind to Open/Close GUI", "RightAlt", function(value)
    local newKeyCode = Enum.KeyCode[value]
    if newKeyCode then
        toggleKeybind = newKeyCode
    else
        print("Invalid KeyCode: " .. value)
    end
end)

-- Função para reentrar no servidor
local function Rejoin()
    if #Players:GetPlayers() <= 1 then
        Players.LocalPlayer:Kick("\nRejoining...")
        wait()
        TeleportService:Teleport(PlaceId, Players.LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
    end
end

-- Adiciona um botão para reentrar no servidor na página de configurações
settingsSection:addButton("Rejoin Server", Rejoin)

-- Nova página de créditos

local infoPage = Emerson2:addPage("Information", 8356778308)

--Roblox section

local robloxSection = infoPage:addSection("Roblox")
robloxSection:addButton(syn and "Follow me on Roblox" or "Copy Roblox profile link", function()
    setclipboard("https://www.roblox.com/users/4111130929/profile")
end)

--GitHub section

local githubSection = infoPage:addSection("GitHub")
githubSection:addButton("Copy GitHub Profile Link", function()
    setclipboard("https://github.com/Emerson2-creator")
end)
