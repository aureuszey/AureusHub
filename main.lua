--// Aureus Hub | Professional UI Design
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

--// UI States
local State = { 
    Visible = true,
    SilentAim = false,
    ShootKey = Enum.KeyCode.E, 
    IsBinding = false
}

--// Main UI Creation
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "AureusMain"
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

--// 1. TOP BAR (Sadece buradan tutub move etmek olar)
local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 10

-- Sürüşdürmə Sistemi (Yalnız TopBar üçün limitli)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--// 2. MODERN RESIZE SYSTEM (Sağ aşağı künc)
local Resizer = Instance.new("Frame", Main)
Resizer.Size = UDim2.new(0, 15, 0, 15)
Resizer.Position = UDim2.new(1, -15, 1, -15)
Resizer.BackgroundTransparency = 1 -- Gizli qalsın amma tutmaq olsun
Resizer.ZIndex = 20

local resizing = false
local resizeStartPos, startSize

Resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStartPos = input.Position
        startSize = Main.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStartPos
        -- Argon Hub kimi stabil limitlər: min 450x320
        Main.Size = UDim2.new(0, math.max(450, startSize.X.Offset + delta.X), 0, math.max(320, startSize.Y.Offset + delta.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)

--// 3. FIXED LAYOUT (Tərpənməyən hissələr)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.28, 0, 0.82, 0)
Sidebar.Position = UDim2.new(0.02, 0, 0.14, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Name = "Content"
ContentContainer.Size = UDim2.new(0.66, 0, 0.82, 0)
ContentContainer.Position = UDim2.new(0.32, 0, 0.14, 0)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 8)

local PageList = Instance.new("UIListLayout", ContentContainer)
PageList.Padding = UDim.new(0, 12)
PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// 4. HEADER & CONTROLS (Argon Hub stili)
local Title = Instance.new("TextLabel", TopBar)
Title.Text = "AUREUS HUB"
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local Controls = Instance.new("Frame", TopBar)
Controls.Size = UDim2.new(0, 80, 0, 30)
Controls.Position = UDim2.new(1, -85, 0.5, -15)
Controls.BackgroundTransparency = 1

local function CreateBtn(txt, xPos, color, callback)
    local btn = Instance.new("TextButton", Controls)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = txt
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end)
    btn.MouseButton1Click:Connect(callback)
end

CreateBtn("✕", 45, Color3.fromRGB(255, 70, 70), function() ScreenGui:Destroy() end)
CreateBtn("—", 5, Color3.fromRGB(200, 200, 200), function()
    State.Visible = not State.Visible
    Main:TweenSize(State.Visible and UDim2.new(0, Main.Size.X.Offset, 0, Main.Size.Y.Offset) or UDim2.new(0, Main.Size.X.Offset, 0, 50), "Out", "Quart", 0.3, true)
end)

--// 5. BUTTONS & TOGGLES (Argon Style)
local MainTab = Instance.new("TextButton", Sidebar)
MainTab.Size = UDim2.new(0.9, 0, 0, 38)
MainTab.Position = UDim2.new(0.05, 0, 0, 10)
MainTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainTab.Text = "Main"
MainTab.TextColor3 = Color3.white
MainTab.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", MainTab)

-- ÖRNƏK TOGGLE (Şəkildəki kimi müasir)
local function CreateToggle(parent, text, default, callback)
    local ToggleBtn = Instance.new("TextButton", parent)
    ToggleBtn.Size = UDim2.new(0.92, 0, 0, 45)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.Text = "  " .. text
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.TextSize = 14
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", ToggleBtn)

    local Status = Instance.new("Frame", ToggleBtn)
    Status.Size = UDim2.new(0, 34, 0, 18)
    Status.Position = UDim2.new(1, -45, 0.5, -9)
    Status.BackgroundColor3 = default and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Status)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.white
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    ToggleBtn.MouseButton1Click:Connect(function()
        default = not default
        TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = default and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        callback(default)
    end)
end

CreateToggle(ContentContainer, "Silent Aim", State.SilentAim, function(v) State.SilentAim = v end)
CreateToggle(ContentContainer, "Auto Shoot", false, function(v) print("Auto Shoot:", v) end)

print("Aureus Hub: Professional Edition Loaded")
