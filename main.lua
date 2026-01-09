--// Aureus Hub | Stable Neon UI
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

--// Main Container
local ScreenGui = Instance.new("ScreenGui", CoreGui)

-- Əsas Pəncərə (Body)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "AureusMain"
Main.Size = State.SavedSize
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true -- Bu artıq ancaq Body hissəni kəsəcək
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// TOP BAR (Main-in daxilində deyil, birbaşa ScreenGui-də ki, yox olmasın)
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(0, 520, 0, 45)
TopBar.Position = Main.Position
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

-- TopBar və Main-i bir-birinə bağlayan sürüşdürmə sistemi
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = TopBar.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TopBar.Position = newPos
        Main.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--// NEON BLURLU TITLE (Aureus Hub)
local function CreateNeonTitle(text)
    -- Blur effekti (Kölgə)
    for i = 1, 3 do
        local Shadow = Instance.new("TextLabel", TopBar)
        Shadow.Text = text
        Shadow.Size = UDim2.new(0.5, 0, 1, 0)
        Shadow.Position = UDim2.new(0, 15, 0, 0)
        Shadow.TextColor3 = Color3.fromRGB(255, 0, 0)
        Shadow.TextTransparency = 0.7
        Shadow.Font = Enum.Font.GothamBold
        Shadow.TextSize = 20 + i
        Shadow.BackgroundTransparency = 1
        Shadow.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    -- Əsas Yazı
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = text
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 6
    
    -- "Aureus" sözünü qırmızı etmək üçün
    Title.RichText = true
    Title.Text = '<font color="rgb(255,0,0)">Aureus</font> Hub'
end

CreateNeonTitle("Aureus Hub")

--// CONTROLS (X və -)
local Controls = Instance.new("Frame", TopBar)
Controls.Size = UDim2.new(0, 70, 0, 30)
Controls.Position = UDim2.new(1, -75, 0.5, -15)
Controls.BackgroundTransparency = 1
Controls.ZIndex = 7

local function CreateBtn(txt, xPos, color, callback)
    local btn = Instance.new("TextButton", Controls)
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
        State.SavedSize = Main.Size
        Main:TweenSize(UDim2.new(0, Main.Size.X.Offset, 0, 0), "Out", "Quart", 0.3, true)
        self.Text = "+"
    else
        Main:TweenSize(State.SavedSize, "Out", "Quart", 0.3, true)
        self.Text = "-"
    end
end)

--// 3. BODY ELEMENTS (Sidebar & Content)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.3, -15, 1, -65)
Sidebar.Position = UDim2.new(0.02, 0, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Sidebar)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(0.64, 0, 1, -65)
Content.Position = UDim2.new(0.34, 0, 0, 55)
Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Content)

local SilentToggle = Instance.new("TextButton", Content)
SilentToggle.Size = UDim2.new(0.9, 0, 0, 45)
SilentToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
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

print("Aureus Hub Ready!")
