--// Aureus Hub | Resizable UI Professional Version
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

--// UI States
local State = { 
    Visible = true,
    SilentAim = false,
    ShootKey = Enum.KeyCode.E, 
    IsBinding = false
}

--// Main UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// 1. Dragging System (Movable)
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--// 2. RESIZE SYSTEM (Yeni Elave Edildi)
local Resizer = Instance.new("Frame", Main)
Resizer.Size = UDim2.new(0, 20, 0, 20)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
Resizer.BackgroundTransparency = 0.8
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
        Main.Size = UDim2.new(0, math.max(300, startSize.X.Offset + delta.X), 0, math.max(200, startSize.Y.Offset + delta.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

--// 3. Window Controls
local Controls = Instance.new("Frame", Main)
Controls.Size = UDim2.new(0, 70, 0, 30)
Controls.Position = UDim2.new(1, -75, 0, 5)
Controls.BackgroundTransparency = 1

local function CreateControlBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton", Controls)
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

CreateControlBtn("X", UDim2.new(0.5, 5, 0, 0), Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)
CreateControlBtn("-", UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), function()
    State.Visible = not State.Visible
    Main:TweenSize(State.Visible and UDim2.new(0, Main.Size.X.Offset, 0, Main.Size.Y.Offset) or UDim2.new(0, Main.Size.X.Offset, 0, 40), "Out", "Quart", 0.3, true)
end)

--// 4. UI Structure (Sidebar & Content)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -170, 1, -60)
Content.Position = UDim2.new(0, 160, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Content)

local PageList = Instance.new("UIListLayout", Content)
PageList.Padding = UDim.new(0, 10)
PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Title = Instance.new("TextLabel", Main)
Title.Text = "  AUREUS HUB"
Title.Size = UDim2.new(0, 200, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

--// 5. MAIN TAB & Features
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
        print("Aureus Hub: Auto-Shooting with Key " .. State.ShootKey.Name)
    end
end)

print("Aureus Hub | Resizable UI Loaded")
