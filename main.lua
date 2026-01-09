--// Aureus Hub | Final UI with Window Controls
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

--// UI States
local State = { Speed = false, Jump = false, Visible = true }

--// Main UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// 1. Sürüşdürmə Sistemi (Modern Dragging)
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

--// 2. Sağ Yuxarı Düymələr (-, [], X)
local Controls = Instance.new("Frame", Main)
Controls.Size = UDim2.new(0, 100, 0, 30)
Controls.Position = UDim2.new(1, -105, 0, 5)
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

-- Close (X)
CreateControlBtn("X", UDim2.new(0.7, 0, 0, 0), Color3.fromRGB(255, 80, 80), function()
    ScreenGui:Destroy()
end)

-- Maximize/Square ([])
CreateControlBtn("▢", UDim2.new(0.35, 0, 0, 0), Color3.fromRGB(200, 200, 200), function()
    Main.Size = (Main.Size == UDim2.new(0, 520, 0, 360)) and UDim2.new(0, 600, 0, 400) or UDim2.new(0, 520, 0, 360)
end)

-- Minimize (-)
CreateControlBtn("-", UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), function()
    State.Visible = not State.Visible
    Main:TweenSize(State.Visible and UDim2.new(0, 520, 0, 360) or UDim2.new(0, 520, 0, 40), "Out", "Quart", 0.3, true)
end)

--// 3. Digər Elementlər (Sidebar & Content)
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

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Text = "  AUREUS HUB"
Title.Size = UDim2.new(0, 200, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

print("Aureus Hub | Window Controls Added")
