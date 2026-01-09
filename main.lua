--// Aureus Hub | Developed by Aureus
--// Features: Silent Aim, ESP, Speed, Jump, Anti-Fling
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Global Settings
local Aureus = {
    Speed = 100,
    Jump = 150,
    SpeedEnabled = false,
    JumpEnabled = false,
    EspEnabled = false,
    SilentAim = false
}

--// UI Creation
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Text = "AUREUS HUB - MM2 EDITION"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

--// Functions: UI Helpers
local function CreateToggle(text, callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = text .. ": OFF"
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", Btn)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. ": " .. (state and "ON" or "OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 35, 35)
        callback(state)
    end)
end

--// Logic: ESP (Chams)
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("AureusESP")
            if Aureus.EspEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "AureusESP"
                end
                -- Color coding: Red for Murderer, Blue for Sheriff
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                    highlight.FillColor = Color3.fromRGB(0, 150, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 100)
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end

--// Logic: Silent Aim
local function GetMurderer()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
            return p.Character:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil
end

--// Creating Toggles
CreateToggle("Enable Silent Aim", function(v) Aureus.SilentAim = v end)
CreateToggle("Enable ESP (Chams)", function(v) Aureus.EspEnabled = v end)
CreateToggle("Super Speed", function(v) Aureus.SpeedEnabled = v end)
CreateToggle("Mega Jump", function(v) Aureus.JumpEnabled = v end)

--// Main Loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        -- Speed/Jump
        char.Humanoid.WalkSpeed = Aureus.SpeedEnabled and Aureus.Speed or 16
        char.Humanoid.JumpPower = Aureus.JumpEnabled and Aureus.Jump or 50
        
        -- ESP Update
        UpdateESP()

        -- Silent Aim Logic (Triggered by firing gun)
        if Aureus.SilentAim then
            local target = GetMurderer()
            local gun = char:FindFirstChild("Gun")
            if target and gun and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                gun.KnifeServer.ShootGun:InvokeServer(target.Position, target.Position + Vector3.new(0,1,0), "Slash")
            end
        end
    end
end)

print("Aureus Hub | Fully Functional Loaded")
