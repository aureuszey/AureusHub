--// Aureus Hub | Final Stable English UI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// 1. TOP BAR (Sadece burdan tutub terpenmek olar)
local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

-- Sürüşdürmə Sistemi (Yalnız TopBar üçün)
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

--// 2. PERFECT RESIZE SYSTEM (Aşağı küncdəki yaşıl nöqtə)
local Resizer = Instance.new("Frame", Main)
Resizer.Size = UDim2.new(0, 12, 0, 12)
Resizer.Position = UDim2.new(1, -12, 1, -12)
Resizer.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
Resizer.ZIndex = 5
Instance.new("UICorner", Resizer).CornerRadius = UDim.new(1, 0)

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
        Main.Size = UDim2.new(0, math.max(400, startSize.X.Offset + delta.X), 0, math.max(300, startSize.Y.Offset + delta.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)

--// 3. FIXED SCALING LAYOUT
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.3, -15, 0.8, 0)
Sidebar.Position = UDim2.new(0.02, 0, 0.15, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(0.64, 0, 0.8, 0)
Content.Position = UDim2.new(0.34, 0, 0.15, 0)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Content)

local PageList = Instance.new("UIListLayout", Content)
PageList.Padding = UDim.new(0, 10)
PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// 4. HEADER ELEMENTS
local Title = Instance.new("TextLabel", TopBar)
Title.Text = "  AUREUS HUB"
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local Controls = Instance.new("Frame", TopBar)
Controls.Size = UDim2.new(0, 70, 0, 30)
Controls.Position = UDim2.new(1, -75, 0.5, -15)
Controls.BackgroundTransparency = 1

local function CreateBtn(txt, xPos, color, callback)
    local btn = Instance.new("TextButton", Controls)
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

CreateBtn("X", 35, Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)
CreateBtn("-", 0, Color3.fromRGB(255, 255, 255), function()
    State.Visible = not State.Visible
    Main:TweenSize(State.Visible and UDim2.new(0, Main.Size.X.Offset, 0, Main.Size.Y.Offset) or UDim2.new(0, Main.Size.X.Offset, 0, 45), "Out", "Quart", 0.3, true)
end)

--// 5. FEATURES
local MainTabBtn = Instance.new("TextButton", Sidebar)
MainTabBtn.Size = UDim2.new(0.9, 0, 0, 40)
MainTabBtn.Position = UDim2.new(0.05, 0, 0, 10)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainTabBtn.Text = "Main"
MainTabBtn.TextColor3 = Color3.white
MainTabBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", MainTabBtn)

local SilentToggle = Instance.new("TextButton", Content)
SilentToggle.Size = UDim2.new(0.9, 0, 0, 45)
SilentToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SilentToggle.Text = "Silent Aim: [OFF]"
SilentToggle.TextColor3 = Color3.white
SilentToggle.Font = Enum.Font.Gotham
Instance.new("UICorner", SilentToggle)

SilentToggle.MouseButton1Click:Connect(function()
    State.SilentAim = not State.SilentAim
    SilentToggle.Text = "Silent Aim: [" .. (State.SilentAim and "ON" or "OFF") .. "]"
    SilentToggle.BackgroundColor3 = State.SilentAim and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 35, 35)
end)

local KeybindBtn = Instance.new("TextButton", Content)
KeybindBtn.Size = UDim2.new(0.9, 0, 0, 45)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeybindBtn.Text = "Shoot Key: [" .. State.ShootKey.Name .. "]"
KeybindBtn.TextColor3 = Color3.white
KeybindBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", KeybindBtn)

KeybindBtn.MouseButton1Click:Connect(function()
    State.IsBinding = true
    KeybindBtn.Text = "... Press Any Key ..."
end)

UserInputService.InputBegan:Connect(function(input)
    if State.IsBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        State.ShootKey = input.KeyCode
        KeybindBtn.Text = "Shoot Key: [" .. State.ShootKey.Name .. "]"
        State.IsBinding = false
    elseif not State.IsBinding and input.KeyCode == State.ShootKey and State.SilentAim then
        print("Aureus Hub: Auto-Shooting Activated!")
    end
end)

print("Aureus Hub is Ready")
