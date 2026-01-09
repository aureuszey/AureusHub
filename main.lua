--// Aureus Hub | Final Professional Build
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// State
local State = {
    Speed = 16,
    SpeedEnabled = false,
    JumpPower = 50,
    JumpEnabled = false
}

--// UI Baza
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Köhnə sistemlərdə sürüşdürmə üçün

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 10)

-- Sol Menyü
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "AUREUS HUB"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- Səhifə Sahəsi
local PageContainer = Instance.new("Frame", Main)
PageContainer.Position = UDim2.new(0, 140, 0, 10)
PageContainer.Size = UDim2.new(1, -150, 1, -20)
PageContainer.BackgroundTransparency = 1

--// Funksiya: Düymə Yaratmaq (Toggle)
local function CreateToggle(parent, name, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.Text = name .. ": OFF"
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)

    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
end

--// Səhifəni Doldur (Hələlik hər şey bir səhifədə ki, xəta olmasın)
local List = Instance.new("UIListLayout", PageContainer)
List.Padding = UDim.new(0, 10)

CreateToggle(PageContainer, "WalkSpeed (100)", function(v)
    State.SpeedEnabled = v
end)

CreateToggle(PageContainer, "High Jump (150)", function(v)
    State.JumpEnabled = v
end)

CreateToggle(PageContainer, "Auto Collect", function(v)
    print("Auto Collect: ", v)
end)

--// LOOPS (Bu hissə funksiyaları işlədir)
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if State.SpeedEnabled then
                char.Humanoid.WalkSpeed = 100
            else
                char.Humanoid.WalkSpeed = 16
            end
            
            if State.JumpEnabled then
                char.Humanoid.JumpPower = 150
            else
                char.Humanoid.JumpPower = 50
            end
        end
    end)
end)

print("Aureus Hub Final v1.0 Loaded!")
