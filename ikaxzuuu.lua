--[[
    ╔═══════════════════════════════════════════════════╗
    ║   VIOLENCE DISTRICT ULTIMATE HACK - ikxz 2025    ║
    ║   Aimbot | ESP | Speed | Teleport | AUTO HIT     ║
    ╚═══════════════════════════════════════════════════╝
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Settings Storage
local Config = {
    Aimbot = false,
    ESP = false,
    Speed = false,
    AutoHit = false,
    SpeedValue = 16,
    FOV = 250,
    Smoothness = 0.08,
    TeamCheck = false,
    AutoHitRange = 20
}

-- Cleanup old GUI
if CoreGui:FindFirstChild("ikxzVDHack") then
    CoreGui:FindFirstChild("ikxzVDHack"):Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ikxzVDHack"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- ===== ICON BUTTON (TOGGLE UI) =====
local IconFrame = Instance.new("Frame")
IconFrame.Name = "IconFrame"
IconFrame.Parent = ScreenGui
IconFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IconFrame.BorderSizePixel = 0
IconFrame.Position = UDim2.new(0.02, 0, 0.45, 0)
IconFrame.Size = UDim2.new(0, 65, 0, 65)
IconFrame.Active = true

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = IconFrame

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 50, 80)
IconStroke.Thickness = 2.5
IconStroke.Parent = IconFrame

local IconButton = Instance.new("TextButton")
IconButton.Parent = IconFrame
IconButton.BackgroundTransparency = 1
IconButton.Size = UDim2.new(1, 0, 1, 0)
IconButton.Font = Enum.Font.GothamBold
IconButton.Text = "ikxz"
IconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IconButton.TextSize = 16
IconButton.TextWrapped = true

local IconSubtext = Instance.new("TextLabel")
IconSubtext.Parent = IconFrame
IconSubtext.BackgroundTransparency = 1
IconSubtext.Position = UDim2.new(0, 0, 0.65, 0)
IconSubtext.Size = UDim2.new(1, 0, 0.3, 0)
IconSubtext.Font = Enum.Font.Gotham
IconSubtext.Text = "VD"
IconSubtext.TextColor3 = Color3.fromRGB(255, 50, 80)
IconSubtext.TextSize = 11

-- ===== MAIN WINDOW =====
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = ScreenGui
MainWindow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainWindow.BorderSizePixel = 0
MainWindow.Position = UDim2.new(0.5, -250, 0.5, -220)
MainWindow.Size = UDim2.new(0, 500, 0, 440)
MainWindow.Visible = false
MainWindow.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 50, 80)
MainStroke.Thickness = 2
MainStroke.Parent = MainWindow

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainWindow
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 50)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 15)
TopCorner.Parent = TopBar

local BottomCover = Instance.new("Frame")
BottomCover.Parent = TopBar
BottomCover.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
BottomCover.BorderSizePixel = 0
BottomCover.Position = UDim2.new(0, 0, 0.7, 0)
BottomCover.Size = UDim2.new(1, 0, 0.3, 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "VIOLENCE DISTRICT HACK"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Parent = TopBar
VersionLabel.BackgroundTransparency = 1
VersionLabel.Position = UDim2.new(0, 20, 0, 28)
VersionLabel.Size = UDim2.new(0, 200, 0, 15)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Text = "by ikxz • v3.0 AUTO HIT"
VersionLabel.TextColor3 = Color3.fromRGB(255, 50, 80)
VersionLabel.TextSize = 11
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -40, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinBtn.BorderSizePixel = 0
MinBtn.Position = UDim2.new(1, -70, 0.5, -12)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Content Area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainWindow
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 15, 0, 65)
ContentFrame.Size = UDim2.new(1, -30, 1, -80)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 720)
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 80)

-- ===== FUNCTIONS TO CREATE UI ELEMENTS =====

local function CreateSection(name, position)
    local Section = Instance.new("Frame")
    Section.Parent = ContentFrame
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Section.BorderSizePixel = 0
    Section.Position = position
    Section.Size = UDim2.new(1, 0, 0, 50)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Section
    
    local SectionStroke = Instance.new("UIStroke")
    SectionStroke.Color = Color3.fromRGB(40, 40, 50)
    SectionStroke.Thickness = 1.5
    SectionStroke.Parent = Section
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Section
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    return Section, Label
end

local function CreateToggle(parent, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Toggle.BorderSizePixel = 0
    Toggle.Position = UDim2.new(1, -90, 0.5, -15)
    Toggle.Size = UDim2.new(0, 70, 0, 30)
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Toggle.TextSize = 12
    Toggle.AutoButtonColor = false
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local state = false
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = state and "ON" or "OFF"
        Toggle.BackgroundColor3 = state and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(40, 40, 50)
        Toggle.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        callback(state)
    end)
    
    return Toggle
end

-- ===== CREATE UI SECTIONS =====

-- 1. AIMBOT
local AimbotSection, AimbotLabel = CreateSection("🎯 AIMBOT", UDim2.new(0, 0, 0, 0))
local AimbotToggle = CreateToggle(AimbotSection, function(state)
    Config.Aimbot = state
end)

-- 2. AUTO HIT (NEW!)
local AutoHitSection, AutoHitLabel = CreateSection("⚔️ AUTO HIT (20 Studs)", UDim2.new(0, 0, 0, 60))
local AutoHitToggle = CreateToggle(AutoHitSection, function(state)
    Config.AutoHit = state
end)

-- 3. ESP
local ESPSection, ESPLabel = CreateSection("👁️ ESP WALLHACK", UDim2.new(0, 0, 0, 120))
local ESPToggle = CreateToggle(ESPSection, function(state)
    Config.ESP = state
    if state then
        EnableESP()
    else
        DisableESP()
    end
end)

-- 4. SPEED HACK
local SpeedSection, SpeedLabel = CreateSection("⚡ SPEED HACK", UDim2.new(0, 0, 0, 180))
local SpeedToggle = CreateToggle(SpeedSection, function(state)
    Config.Speed = state
end)

-- Speed Slider
local SliderFrame = Instance.new("Frame")
SliderFrame.Parent = ContentFrame
SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
SliderFrame.BorderSizePixel = 0
SliderFrame.Position = UDim2.new(0, 0, 0, 240)
SliderFrame.Size = UDim2.new(1, 0, 0, 60)

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 10)
SliderCorner.Parent = SliderFrame

local SliderStroke = Instance.new("UIStroke")
SliderStroke.Color = Color3.fromRGB(40, 40, 50)
SliderStroke.Thickness = 1.5
SliderStroke.Parent = SliderFrame

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = SliderFrame
SliderLabel.BackgroundTransparency = 1
SliderLabel.Position = UDim2.new(0, 15, 0, 8)
SliderLabel.Size = UDim2.new(1, -30, 0, 20)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.Text = "Speed: 16"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.TextSize = 13
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBar = Instance.new("Frame")
SliderBar.Parent = SliderFrame
SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderBar.BorderSizePixel = 0
SliderBar.Position = UDim2.new(0, 15, 0, 35)
SliderBar.Size = UDim2.new(1, -30, 0, 8)

local SliderBarCorner = Instance.new("UICorner")
SliderBarCorner.CornerRadius = UDim.new(1, 0)
SliderBarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBar
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
SliderFill.BorderSizePixel = 0
SliderFill.Size = UDim2.new(0, 0, 1, 0)

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Parent = SliderBar
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderSizePixel = 0
SliderButton.Position = UDim2.new(0, -8, 0.5, -8)
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Text = ""
SliderButton.AutoButtonColor = false

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton

local dragging = false
SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = SliderBar.AbsolutePosition.X
        local barSize = SliderBar.AbsoluteSize.X
        local relPos = math.clamp(mousePos - barPos, 0, barSize)
        local percent = relPos / barSize
        
        SliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        
        Config.SpeedValue = math.floor(16 + (percent * 84))
        SliderLabel.Text = "Speed: " .. Config.SpeedValue
    end
end)

-- 5. TELEPORT TO PLAYER
local TeleportSection = Instance.new("Frame")
TeleportSection.Parent = ContentFrame
TeleportSection.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TeleportSection.BorderSizePixel = 0
TeleportSection.Position = UDim2.new(0, 0, 0, 310)
TeleportSection.Size = UDim2.new(1, 0, 0, 150)

local TPCorner = Instance.new("UICorner")
TPCorner.CornerRadius = UDim.new(0, 10)
TPCorner.Parent = TeleportSection

local TPStroke = Instance.new("UIStroke")
TPStroke.Color = Color3.fromRGB(40, 40, 50)
TPStroke.Thickness = 1.5
TPStroke.Parent = TeleportSection

local TPTitle = Instance.new("TextLabel")
TPTitle.Parent = TeleportSection
TPTitle.BackgroundTransparency = 1
TPTitle.Position = UDim2.new(0, 15, 0, 10)
TPTitle.Size = UDim2.new(1, -30, 0, 25)
TPTitle.Font = Enum.Font.GothamBold
TPTitle.Text = "🌀 TELEPORT TO PLAYER"
TPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TPTitle.TextSize = 14
TPTitle.TextXAlignment = Enum.TextXAlignment.Left

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Parent = TeleportSection
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PlayerDropdown.BorderSizePixel = 0
PlayerDropdown.Position = UDim2.new(0, 15, 0, 45)
PlayerDropdown.Size = UDim2.new(1, -30, 0, 35)
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.Text = "Select Player..."
PlayerDropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
PlayerDropdown.TextSize = 13
PlayerDropdown.TextXAlignment = Enum.TextXAlignment.Left
PlayerDropdown.TextPadding = UDim.new(0, 10)

local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 8)
DropCorner.Parent = PlayerDropdown

local DropArrow = Instance.new("TextLabel")
DropArrow.Parent = PlayerDropdown
DropArrow.BackgroundTransparency = 1
DropArrow.Position = UDim2.new(1, -30, 0, 0)
DropArrow.Size = UDim2.new(0, 30, 1, 0)
DropArrow.Font = Enum.Font.GothamBold
DropArrow.Text = "▼"
DropArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
DropArrow.TextSize = 12

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Parent = TeleportSection
TeleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Position = UDim2.new(0, 15, 0, 95)
TeleportBtn.Size = UDim2.new(1, -30, 0, 40)
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.Text = "TELEPORT NOW"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextSize = 14
TeleportBtn.AutoButtonColor = false

local TPBtnCorner = Instance.new("UICorner")
TPBtnCorner.CornerRadius = UDim.new(0, 8)
TPBtnCorner.Parent = TeleportBtn

-- Player List Dropdown
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Parent = TeleportSection
DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DropdownList.BorderSizePixel = 0
DropdownList.Position = UDim2.new(0, 15, 0, 85)
DropdownList.Size = UDim2.new(1, -30, 0, 0)
DropdownList.Visible = false
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 4
DropdownList.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 80)
DropdownList.ZIndex = 10

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = DropdownList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = DropdownList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)

local selectedPlayer = nil

local function UpdatePlayerList()
    for _, child in pairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local count = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            count = count + 1
            local PlayerBtn = Instance.new("TextButton")
            PlayerBtn.Parent = DropdownList
            PlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            PlayerBtn.BorderSizePixel = 0
            PlayerBtn.Size = UDim2.new(1, -8, 0, 30)
            PlayerBtn.Font = Enum.Font.Gotham
            PlayerBtn.Text = player.Name
            PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerBtn.TextSize = 12
            PlayerBtn.TextXAlignment = Enum.TextXAlignment.Left
            PlayerBtn.TextPadding = UDim.new(0, 10)
            PlayerBtn.AutoButtonColor = false
            
            PlayerBtn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                PlayerDropdown.Text = player.Name
                DropdownList.Visible = false
                DropArrow.Text = "▼"
            end)
            
            PlayerBtn.MouseEnter:Connect(function()
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
            end)
            
            PlayerBtn.MouseLeave:Connect(function()
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end)
        end
    end
    
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, count * 32)
end

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    DropArrow.Text = DropdownList.Visible and "▲" or "▼"
    if DropdownList.Visible then
        DropdownList.Size = UDim2.new(1, -30, 0, math.min(#Players:GetPlayers() * 32, 120))
        UpdatePlayerList()
    else
        DropdownList.Size = UDim2.new(1, -30, 0, 0)
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "ikxz Teleport";
                Text = "Teleported to " .. selectedPlayer.Name;
                Duration = 2;
            })
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "ikxz Teleport";
            Text = "Please select a player first!";
            Duration = 2;
        })
    end
end)

TeleportBtn.MouseEnter:Connect(function()
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
end)

TeleportBtn.MouseLeave:Connect(function()
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
end)

-- 6. CREDITS
local CreditsSection = Instance.new("Frame")
CreditsSection.Parent = ContentFrame
CreditsSection.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
CreditsSection.BorderSizePixel = 0
CreditsSection.Position = UDim2.new(0, 0, 0, 470)
CreditsSection.Size = UDim2.new(1, 0, 0, 80)

local CreditCorner = Instance.new("UICorner")
CreditCorner.CornerRadius = UDim.new(0, 10)
CreditCorner.Parent = CreditsSection

local CreditStroke = Instance.new("UIStroke")
CreditStroke.Color = Color3.fromRGB(40, 40, 50)
CreditStroke.Thickness = 1.5
CreditStroke.Parent = CreditsSection

local CreditTitle = Instance.new("TextLabel")
CreditTitle.Parent = CreditsSection
CreditTitle.BackgroundTransparency = 1
CreditTitle.Position = UDim2.new(0, 0, 0, 10)
CreditTitle.Size = UDim2.new(1, 0, 0, 25)
CreditTitle.Font = Enum.Font.GothamBold
CreditTitle.Text = "💎 CREATED BY ikxz"
CreditTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditTitle.TextSize = 14

local CreditDesc = Instance.new("TextLabel")
CreditDesc.Parent = CreditsSection
CreditDesc.BackgroundTransparency = 1
CreditDesc.Position = UDim2.new(0, 0, 0, 40)
CreditDesc.Size = UDim2.new(1, 0, 0, 30)
CreditDesc.Font = Enum.Font.Gotham
CreditDesc.Text = "Violence District Ultimate v3.0 - AUTO HIT UPDATE"
CreditDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
CreditDesc.TextSize = 11

-- ===== DRAG FUNCTIONALITY =====

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(MainWindow, TopBar)
MakeDraggable(IconFrame, IconFrame)

-- ===== TOGGLE UI =====

local uiOpen = false
IconButton.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen
    if uiOpen then
        MainWindow.Visible = true
        MainWindow.Size = UDim2.new(0, 0, 0, 0)
        MainWindow:TweenSize(UDim2.new(0, 500, 0, 440), "Out", "Quad", 0.3, true)
    else
        MainWindow:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quad", 0.3, true, function()
            MainWindow.Visible = false
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainWindow:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quad", 0.3, true, function()
        MainWindow.Visible = false
        uiOpen = false
    end)
end)

MinBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    uiOpen = false
end)

-- ===== AIMBOT LOGIC =====

local function GetBestPart(character)
    local parts = {"Head", "UpperTorso", "HumanoidRootPart"}
    for _, partName in pairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then return part end
    end
    return nil
end

local function IsAlive(player)
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetClosestTarget()
    local closest = nil
    local shortestDist = Config.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local targetPart = GetBestPart(player.Character)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance < shortestDist then
                        shortestDist = distance
                        closest = targetPart
                    end
                end
            end
        end
    end
    
    return closest
end

RunService.RenderStepped:Connect(function()
    if Config.Aimbot then
        local target = GetClosestTarget()
        if target then
            local targetPos = target.Position
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.new(currentCFrame.Position, targetPos)
            Camera.CFrame = currentCFrame:Lerp(newCFrame, Config.Smoothness)
        end
    end
end)

-- ===== AUTO HIT LOGIC (NEW!) =====

local function GetClosestPlayerInRange()
    local closest = nil
    local shortestDist = Config.AutoHitRange
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                if distance < shortestDist then
                    shortestDist = distance
                    closest = player
                end
            end
        end
    end
    
    return closest, shortestDist
end

-- Auto Hit System (Universal for all Violence District weapons)
local lastHitTime = 0
local hitCooldown = 0.3 -- Cooldown antar hit (bisa disesuaikan)

RunService.Heartbeat:Connect(function()
    if not Config.AutoHit then return end
    
    local targetPlayer, distance = GetClosestPlayerInRange()
    
    if targetPlayer and tick() - lastHitTime >= hitCooldown then
        if LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            
            if tool then
                -- Method 1: Fire RemoteEvent (untuk knife, melee weapons)
                local remotes = tool:GetDescendants()
                for _, remote in pairs(remotes) do
                    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("hit") or remote.Name:lower():find("attack") or remote.Name:lower():find("damage")) then
                        pcall(function()
                            remote:FireServer(targetPlayer.Character.Head)
                        end)
                        pcall(function()
                            remote:FireServer(targetPlayer.Character)
                        end)
                    end
                end
                
                -- Method 2: Activate tool (untuk weapons yang pake Activated event)
                pcall(function()
                    tool:Activate()
                end)
                
                -- Method 3: Fire Gun RemoteEvents
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("shoot") or v.Name:lower():find("fire") or v.Name:lower():find("damage")) then
                        pcall(function()
                            v:FireServer(targetPlayer.Character.Head.Position, targetPlayer.Character.Head)
                        end)
                    end
                end
                
                lastHitTime = tick()
                
                -- Visual feedback
                local indicator = Instance.new("Part")
                indicator.Parent = workspace
                indicator.Anchored = true
                indicator.CanCollide = false
                indicator.Size = Vector3.new(1, 1, 1)
                indicator.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                indicator.BrickColor = BrickColor.new("Really red")
                indicator.Material = Enum.Material.Neon
                indicator.Transparency = 0.5
                
                game:GetService("Debris"):AddItem(indicator, 0.2)
            end
        end
    end
end)

-- ===== ESP LOGIC =====

local ESPObjects = {}

function EnableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
end

function CreateESP(player)
    if not player.Character or ESPObjects[player] then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Parent = hrp
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = Billboard
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 50, 80)
    NameLabel.TextSize = 14
    NameLabel.TextStrokeTransparency = 0.5
    
    local DistLabel = Instance.new("TextLabel")
    DistLabel.Parent = Billboard
    DistLabel.BackgroundTransparency = 1
    DistLabel.Position = UDim2.new(0, 0, 0.5, 0)
    DistLabel.Size = UDim2.new(1, 0, 0.5, 0)
    DistLabel.Font = Enum.Font.Gotham
    DistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistLabel.TextSize = 12
    DistLabel.TextStrokeTransparency = 0.5
    
    local Highlight = Instance.new("Highlight")
    Highlight.Parent = player.Character
    Highlight.FillColor = Color3.fromRGB(255, 50, 80)
    Highlight.FillTransparency = 0.7
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.OutlineTransparency = 0
    
    ESPObjects[player] = {Billboard, Highlight, DistLabel}
    
    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            DistLabel.Text = math.floor(dist) .. "m"
            
            -- Change color if in auto-hit range
            if Config.AutoHit and dist <= Config.AutoHitRange then
                DistLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                Highlight.FillColor = Color3.fromRGB(0, 255, 0)
            else
                DistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                Highlight.FillColor = Color3.fromRGB(255, 50, 80)
            end
        end
    end)
end

function DisableESP()
    for player, objects in pairs(ESPObjects) do
        for _, obj in pairs(objects) do
            if obj then obj:Destroy() end
        end
    end
    ESPObjects = {}
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if Config.ESP then
            CreateESP(player)
        end
    end)
end)

-- ===== SPEED HACK =====

RunService.RenderStepped:Connect(function()
    if Config.Speed and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.SpeedValue
        end
    end
end)

-- ===== NOTIFICATIONS =====

game.StarterGui:SetCore("SendNotification", {
    Title = "ikxz Violence District v3.0";
    Text = "AUTO HIT UPDATE LOADED! Click ikxz to open";
    Duration = 5;
})

wait(2)

game.StarterGui:SetCore("SendNotification", {
    Title = "Features Active";
    Text = "Aimbot • ESP • Speed • Teleport • AUTO HIT";
    Duration = 4;
})

print("===================================")
print("ikxz Violence District Hack v3.0")
print("AUTO HIT FEATURE ENABLED!")
print("All features loaded successfully!")
print("===================================")