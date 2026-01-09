--// Aureus Hub | Custom UI Structure
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// Settings State
local State = {
    Speed = false, Jump = false, ESP = false, SilentAim = false, AutoFarm = false
}

--// UI Creation
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Header (Title)
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "AUREUS HUB"
Header.TextColor3 = Color3.fromRGB(0, 255, 140)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.BackgroundTransparency = 1
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Position = UDim2.new(0, 15, 0, 0)

-- Sidebar (Left side for Tabs)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local TabList = Instance.new("UIListLayout", Sidebar)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Area (Right side for Buttons)
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -160, 1, -50)
Content.Position = UDim2.new(0, 150, 0, 45)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content)

local Pages = {}

-- Function to Create a Page (Tab)
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.white
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

-- Function to Create a Toggle
local function AddToggle(parent, text, callback)
    local Tgl = Instance.new("TextButton", parent)
    Tgl.Size = UDim2.new(1, 0, 0, 40)
    Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tgl.Text = "  " .. text .. ": OFF"
    Tgl.TextColor3 = Color3.white
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Font = Enum.Font.Gotham
    Instance.new("UICorner", Tgl)
    
    local enabled = false
    Tgl.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tgl.Text = "  " .. text .. ": " .. (enabled and "ON" or "OFF")
        Tgl.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 35, 35)
        callback(enabled)
    end)
end

--// PAGES (TABS)
local MainTab = CreatePage("Main")
local CombatTab = CreatePage("Knife/Gun")
local VisualsTab = CreatePage("Visuals")
local FarmTab = CreatePage("Autofarm")

-- Default Page
Pages["Main"].Visible = true

--// FEATURES
AddToggle(MainTab, "Speed Hack", function(v) State.Speed = v end)
AddToggle(MainTab, "Jump Hack", function(v) State.Jump = v end)

AddToggle(CombatTab, "Silent Aim", function(v) State.SilentAim = v end)

AddToggle(VisualsTab, "Player ESP", function(v) State.ESP = v end)

AddToggle(FarmTab, "Auto Collect Coins", function(v) State.AutoFarm = v end)

--// RUNTIME LOGIC
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = State.Speed and 80 or 16
        char.Humanoid.JumpPower = State.Jump and 120 or 50
    end
end)

print("Aureus Hub | Custom UI Loaded")
