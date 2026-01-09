--// Aureus Hub | Developed by Aureus
--// Professional Multi-Tab Interface

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local AureusState = {
    WalkSpeed = 16, JumpPower = 50, SpeedEnabled = false, JumpEnabled = false, AntiFling = false,
    ChamsEnabled = false, SilentAim = false, AutoShoot = false, ShootKeybind = Enum.KeyCode.C,
    SettingKey = false, AutoCollect = false
}

--// UI Yaradılması (Şəkildəki Dizayn)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Sol Menyü
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "Aureus Hub v0.1"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 120) -- Yaşıl rəng v0.1 üçün
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)

-- Sağ Tərəf (Səhifələr)
local PageHolder = Instance.new("Frame", Main)
PageHolder.Position = UDim2.new(0, 170, 0, 10)
PageHolder.Size = UDim2.new(1, -180, 1, -20)
PageHolder.BackgroundTransparency = 1

local Pages = {}

--// Funksiya: Yeni Səhifə (Tab) Yaratmaq
local function NewTab(name, icon)
    local Page = Instance.new("ScrollingFrame", PageHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", Page)
    layout.Padding = UDim.new(0, 10)

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.Text = "   " .. name
    TabBtn.TextColor3 = Color3.white
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Font = Enum.Font.Gotham
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)

    Pages[name] = Page
    return Page
end

--// Funksiya: Toggle Yaratmaq
local function AddToggle(parent, text, callback)
    local TglFrame = Instance.new("Frame", parent)
    TglFrame.Size = UDim2.new(1, 0, 0, 45)
    TglFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Instance.new("UICorner", TglFrame)

    local Label = Instance.new("TextLabel", TglFrame)
    Label.Text = "  " .. text
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextColor3 = Color3.white
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Btn = Instance.new("TextButton", TglFrame)
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -50, 0.5, -10)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.Text = ""
    local Corn = Instance.new("UICorner", Btn)
    Corn.CornerRadius = UDim.new(1, 0)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

--// TABLARI YARAT (Şəkildəki ardıcıllıqla)
local PlayerTab = NewTab("Player")
local ChamsTab = NewTab("Chams & info")
local GunTab = NewTab("Gun")
local KnifeTab = NewTab("Knife")
local FarmTab = NewTab("Autofarm")

Pages["Player"].Visible = true -- Default səhifə

-- PLAYER FUNKSİYALARI
AddToggle(PlayerTab, "Anti Fling", function(v) AureusState.AntiFling = v end)
AddToggle(PlayerTab, "Enable Speed", function(v) AureusState.SpeedEnabled = v end)

-- GUN FUNKSİYALARI (Teleport Shoot & Keybind)
AddToggle(GunTab, "Auto-Shoot Murderer", function(v) AureusState.AutoShoot = v end)

local KeyBtn = Instance.new("TextButton", GunTab)
KeyBtn.Size = UDim2.new(1, 0, 0, 45)
KeyBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
KeyBtn.Text = "  Shoot Keybind: [" .. AureusState.ShootKeybind.Name .. "]"
KeyBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
Instance.new("UICorner", KeyBtn)

KeyBtn.MouseButton1Click:Connect(function()
    AureusState.SettingKey = true
    KeyBtn.Text = "  ...Press Any Key..."
end)

--// LOOPS & LOGIC
UserInputService.InputBegan:Connect(function(input)
    if AureusState.SettingKey and input.UserInputType == Enum.UserInputType.Keyboard then
        AureusState.ShootKeybind = input.KeyCode
        KeyBtn.Text = "  Shoot Keybind: [" .. input.KeyCode.Name .. "]"
        AureusState.SettingKey = false
    end
end)

print("Aureus Hub v0.1 Loaded Successfully!")
