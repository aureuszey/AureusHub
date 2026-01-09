--// Aureus Hub | Final Optimized UI
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

--// UI States
local State = { 
    Visible = true,
    SilentAim = false,
    SavedSize = UDim2.new(0, 520, 0, 360)
}

--// Main Container
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AureusHub_UI"

-- Əsas Çərçivə
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = State.SavedSize
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true -- Aşağı hissənin yox olması üçün vacibdir
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// TOP BAR (Həmişə görünən hissə)
local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0

-- Sürüşdürmə Sistemi
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

--// LOGO VƏ NEON YAZI (Aureus Hub)
local LogoContainer = Instance.new("Frame", TopBar)
LogoContainer.Size = UDim2.new(0.5, 0, 1, 0)
LogoContainer.Position = UDim2.new(0, 15, 0, 0)
LogoContainer.BackgroundTransparency = 1

-- Neon Kölgə (Blur effekti üçün)
local Shadow = Instance.new("TextLabel", LogoContainer)
Shadow.Text = "Aureus Hub"
Shadow.Size = UDim2.new(1, 0, 1, 0)
Shadow.TextColor3 = Color3.fromRGB(255, 0, 0)
Shadow.TextTransparency = 0.6
Shadow.Font = Enum.Font.GothamBold
Shadow.TextSize = 21
Shadow.BackgroundTransparency = 1
Shadow.TextXAlignment = Enum.TextXAlignment.Left

-- Əsas Yazı (Aureus = Qırmızı, Hub = Ağ)
local Title = Instance.new("TextLabel", LogoContainer)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.RichText = true
Title.Text = '<font color="rgb(255,0,0)">Aureus</font> <font color="rgb(255,255,255)">Hub</font>'
Title.TextXAlignment = Enum.TextXAlignment.Left

--// KONTROL DÜYMƏLƏRİ (X və -)
local Controls = Instance.new("Frame", TopBar)
Controls.Size = UDim2.new(0, 80, 0, 30)
Controls.Position = UDim2.new(1, -85, 0.5, -15)
Controls.BackgroundTransparency = 1

local function CreateBtn(txt, xPos, color, callback)
    local btn = Instance.new("TextButton", Controls)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

CreateBtn("X", 45, Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)

local MiniBtn = CreateBtn("-", 5, Color3.fromRGB(255, 255, 255), function(self)
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

--// BODY CONTENT (İçindəki funksiyalar)
local Body = Instance.new("Frame", Main)
Body.Name = "Body"
Body.Size = UDim2.new(1, -20, 1, -65)
Body.Position = UDim2.new(0, 10, 0, 55)
Body.BackgroundTransparency = 1

-- Sol Sidebar
local Sidebar = Instance.new("Frame", Body)
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", Sidebar)

-- Sağ Kontent Sahəsi
local Content = Instance.new("Frame", Body)
Content.Size = UDim2.new(0.68, 0, 1, 0)
Content.Position = UDim2.new(0.32, 0, 0, 0)
Content.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", Content)

-- Nümunə Toggle (Silent Aim)
local SilentToggle = Instance.new("TextButton", Content)
SilentToggle.Size = UDim2.new(0.9, 0, 0, 45)
SilentToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
SilentToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SilentToggle.Text = "Silent Aim: [OFF]"
SilentToggle.TextColor3 = Color3.white
SilentToggle.Font = Enum.Font.Gotham
Instance.new("UICorner", SilentToggle)

SilentToggle.MouseButton1Click:Connect(function()
    State.SilentAim = not State.SilentAim
    SilentToggle.Text = "Silent Aim: [" .. (State.SilentAim and "ON" or "OFF") .. "]"
    SilentToggle.BackgroundColor3 = State.SilentAim and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
end)

print("Aureus Hub Loaded with Logo and Neon!")
