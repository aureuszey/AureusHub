--// Aureus Hub | Professional Multi-Tab System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// Logic States
local State = {
    Speed = false, Jump = false, ESP = false, SilentAim = false
}

--// Main UI Creation
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Dragging System
Main.Active = true
Main.Draggable = true

-- Top Title (AUREUS HUB)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "          AUREUS HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar (Left Side for Buttons - Red Box 1)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar)

local TabList = Instance.new("UIListLayout", Sidebar)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Page Holder (Right Side - Red Box 2)
local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -170, 1, -60)
PageHolder.Position = UDim2.new(0, 160, 0, 50)
PageHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", PageHolder)

local Pages = {}

-- Function to Create a New Tab Page
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageHolder)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.white
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        -- Visual feedback for active tab
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(35, 35, 40) end
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        TabBtn.TextColor3 = Color3.black
        delay(0.2, function() TabBtn.TextColor3 = Color3.white end)
    end)
    
    Pages[name] = Page
    return Page
end

-- Helper: Create Toggle
local function AddToggle(parent, text, callback)
    local Tgl = Instance.new("TextButton", parent)
    Tgl.Size = UDim2.new(1, 0, 0, 40)
    Tgl.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Tgl.Text = "  " .. text .. ": OFF"
    Tgl.TextColor3 = Color3.white
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Font = Enum.Font.Gotham
    Instance.new("UICorner", Tgl)
    
    local enabled = false
    Tgl.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tgl.Text = "  " .. text .. ": " .. (enabled and "ON" or "OFF")
        Tgl.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 45)
        callback(enabled)
    end)
end

--// CREATE PAGES (As seen in your red outlines)
local MainTab = CreatePage("Main")
local CombatTab = CreatePage("Knife/Gun")
local VisualsTab = CreatePage("Visuals")
local FarmTab = CreatePage("Autofarm")

-- Default Page
Pages["Main"].Visible = true

--// ADD FEATURES
AddToggle(MainTab, "Speed Hack", function(v) State.Speed = v end)
AddToggle(MainTab, "Jump Hack", function(v) State.Jump = v end)

AddToggle(CombatTab, "Silent Aim", function(v) State.SilentAim = v end)

AddToggle(VisualsTab, "Player ESP", function(v) State.ESP = v end)

AddToggle(FarmTab, "Auto Collect Coins", function(v) State.AutoFarm = v end)

--// RUNTIME ENGINE
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = State.Speed and 100 or 16
        char.Humanoid.JumpPower = State.Jump and 150 or 50
    end
end)

print("Aureus Hub | Professional UI Loaded Successfully")
