--// Aureus Hub | Final Stable English UI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

--// UI States
local State = { 
    Visible = true,
    SilentAim = false,
    ShootKey = Enum.KeyCode.E, 
    IsBinding = false,
    SavedSize = UDim2.new(0, 520, 0, 360)
}

--// Main UI Creation
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "AureusMain"
Main.Size = State.SavedSize
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Daha tünd qara
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// 1. TOP BAR (Sürüşdürmə pəncərə kiçik olsa da işləyir)
local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0

local dragging, dragStart, startPos
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

--// 2. NEON BLURLU TITLE (Aureus Hub)
-- Blur effekti üçün kölgə qatı
local TitleShadow = Instance.new("TextLabel", TopBar)
TitleShadow.Text = " Aureus Hub"
TitleShadow.Size = UDim2.new(0.5, 0, 1, 0)
TitleShadow.Position = UDim2.new(0, 2, 0, 2)
TitleShadow.TextColor3 = Color3.fromRGB(150, 0, 0) -- Tünd qırmızı blur üçün
TitleShadow.Font = Enum.Font.GothamBold
TitleShadow.TextSize = 20
TitleShadow.BackgroundTransparency = 1
TitleShadow.TextXAlignment = Enum.TextXAlignment.Left

local Title = Instance.new("TextLabel", TopBar)
Title.Text = " Aureus Hub"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(255, 0, 0) -- Parlaq Neon Qırmızı
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

--// 3. CONTROLS (X və - Düymələri)
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
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

CreateBtn("X", 35, Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)

local MiniBtn = CreateBtn("-", 0, Color3.fromRGB(255, 255, 255), function(self)
    State.Visible = not State.Visible
    if not State.Visible then
        State.SavedSize = Main.Size -- Hazırkı ölçünü yadda saxla
        Main:TweenSize(UDim2.new(0, Main.Size.X.Offset, 0, 45), "Out", "Quart", 0.3, true)
        self.Text = "+"
    else
        Main:TweenSize(State.SavedSize, "Out", "Quart", 0.3, true)
        self.Text = "-"
    end
end)

--// 4. BODY CONTENT (Kiçildikdə gizlənəcək hissə)
local Body = Instance.new("Frame", Main)
Body.Name = "Body"
Body.Size = UDim2.new(1, 0, 1, -45)
Body.Position = UDim2.new(0, 0, 0, 45)
Body.BackgroundTransparency = 1

local Sidebar = Instance.new("Frame", Body)
Sidebar.Size = UDim2.new(0.3, -15, 0.9, 0)
Sidebar.Position = UDim2.new(0.02, 0, 0.05, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar)

local Content = Instance.new("Frame", Body)
Content.Size = UDim2.new(0.64, 0, 0.9, 0)
Content.Position = UDim2.new(0.34, 0, 0.05, 0)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Content)

--// 5. FEATURES
local SilentToggle = Instance.new("TextButton", Content)
SilentToggle.Size = UDim2.new(0.9, 0, 0, 45)
SilentToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
SilentToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SilentToggle.Text = "Silent Aim: [OFF]"
SilentToggle.TextColor3 = Color3.white
SilentToggle.Font = Enum.Font.Gotham
Instance.new("UICorner", SilentToggle)

SilentToggle.MouseButton1Click:Connect(function()
    State.SilentAim = not State.SilentAim
    SilentToggle.Text = "Silent Aim: [" .. (State.SilentAim and "ON" or "OFF") .. "]"
    SilentToggle.BackgroundColor3 = State.SilentAim and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(35, 35, 35)
end)

print("Aureus Hub Loaded Successfully")
