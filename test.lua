local VenyxLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Library.lua"))()
local Venyx = VenyxLibrary.new("Universal Vehicle Script", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(61, 60, 124), 
    Glow = Color3.fromRGB(60, 63, 221), 
    Accent = Color3.fromRGB(55, 52, 90), 
    LightContrast = Color3.fromRGB(64, 65, 128), 
    DarkContrast = Color3.fromRGB(32, 33, 64),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

for index, value in pairs(Theme) do
    pcall(Venyx.setTheme, Venyx, index, value)
end

local function GetVehicleFromDescendant(Descendant)
    return
        Descendant:FindFirstAncestor(LocalPlayer.Name .. "\'s Car") or
        (Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
        (Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
        Descendant:FindFirstAncestorWhichIsA("Model")
end

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

-- Adicionando a página e seção para o veículo
local vehiclePage = Venyx:addPage("Vehicle", 8356815386)
local usageSection = vehiclePage:addSection("Usage")
local velocityEnabled = true
usageSection:addToggle("Keybinds Active", velocityEnabled, function(v) velocityEnabled = v end)

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