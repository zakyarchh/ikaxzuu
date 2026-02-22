--[[
    ╔═══════════════════════════════════════════════════╗
    ║      VIOLENCE DISTRICT MOBILE PREMIUM HACK       ║
    ║          by ikxz - Ultra Premium Edition         ║
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

-- Settings
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

-- Cleanup
if CoreGui:FindFirstChild("ikxzVDMobile") then
    CoreGui:FindFirstChild("ikxzVDMobile"):Destroy()
end

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ikxzVDMobile"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ===== FLOATING ICON BUTTON (MOBILE OPTIMIZED) =====
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Parent = ScreenGui
FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
FloatingButton.BorderSizePixel = 0
FloatingButton.Position = UDim2.new(0, 15, 0.4, 0)
FloatingButton.Size = UDim2.new(0, 80, 0, 80)
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.Text = ""
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextSize = 18
FloatingButton.AutoButtonColor = false
FloatingButton.Active = true
FloatingButton.Draggable = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 16)
FloatCorner.Parent = FloatingButton

local FloatGradient = Instance.new("UIGradient")
FloatGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
}
FloatGradient.Rotation = 45
FloatGradient.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Thickness = 3
FloatStroke.Transparency = 0.3
FloatStroke.Parent = FloatingButton

local FloatShadow = Instance.new("ImageLabel")
FloatShadow.Name = "Shadow"
FloatShadow.Parent = FloatingButton
FloatShadow.BackgroundTransparency = 1
FloatShadow.Position = UDim2.new(0, -15, 0, -15)
FloatShadow.Size = UDim2.new(1, 30, 1, 30)
FloatShadow.ZIndex = 0
FloatShadow.Image = "rbxassetid://6015897843"
FloatShadow.ImageColor3 = Color3.fromRGB(138, 43, 226)
FloatShadow.ImageTransparency = 0.5
FloatShadow.ScaleType = Enum.ScaleType.Slice
FloatShadow.SliceCenter = Rect.new(49, 49, 450, 450)

local FloatIcon = Instance.new("TextLabel")
FloatIcon.Parent = FloatingButton
FloatIcon.BackgroundTransparency = 1
FloatIcon.Size = UDim2.new(1, 0, 0.6, 0)
FloatIcon.Position = UDim2.new(0, 0, 0, 5)
FloatIcon.Font = Enum.Font.GothamBold
FloatIcon.Text = "ikxz"
FloatIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatIcon.TextSize = 22

local FloatText = Instance.new("TextLabel")
FloatText.Parent = FloatingButton
FloatText.BackgroundTransparency = 1
FloatText.Size = UDim2.new(1, 0, 0.35, 0)
FloatText.Position = UDim2.new(0, 0, 0.65, 0)
FloatText.Font = Enum.Font.Gotham
FloatText.Text = "PREMIUM"
FloatText.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatText.TextSize = 11
FloatText.TextTransparency = 0.3

-- Pulse Animation for Float Button
spawn(function()
    while wait() do
        FloatingButton:TweenSize(UDim2.new(0, 85, 0, 85), "Out", "Quad", 0.5, true)
        wait(0.5)
        FloatingButton:TweenSize(UDim2.new(0, 80, 0, 80), "In", "Quad", 0.5, true)
        wait(0.5)
    end
end)

-- ===== MAIN MENU (MOBILE OPTIMIZED) =====
local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Parent = ScreenGui
MainMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainMenu.BorderSizePixel = 0
MainMenu.Position = UDim2.new(0.5, -180, 0.5, -250)
MainMenu.Size = UDim2.new(0, 360, 0, 500)
MainMenu.Visible = false
MainMenu.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainMenu

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 3
MainStroke.Transparency = 0.3
MainStroke.Parent = MainMenu

local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.Parent = MainMenu
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0, -20, 0, -20)
MainShadow.Size = UDim2.new(1, 40, 1, 40)
MainShadow.ZIndex = 0
MainShadow.Image = "rbxassetid://6015897843"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.4
MainShadow.ScaleType = Enum.ScaleType.Slice
MainShadow.SliceCenter = Rect.new(49, 49, 450, 450)

-- Top Bar with Gradient
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainMenu
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 70)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 20)
TopCorner.Parent = TopBar

local TopCover = Instance.new("Frame")
TopCover.Parent = TopBar
TopCover.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopCover.BorderSizePixel = 0
TopCover.Position = UDim2.new(0, 0, 0.6, 0)
TopCover.Size = UDim2.new(1, 0, 0.4, 0)

local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
}
TopGradient.Rotation = 90
TopGradient.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 8)
TitleLabel.Size = UDim2.new(0.7, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "VIOLENCE DISTRICT"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextStrokeTransparency = 0.8

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Parent = TopBar
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Position = UDim2.new(0, 20, 0, 33)
SubtitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "PREMIUM MOBILE EDITION"
SubtitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SubtitleLabel.TextSize = 11
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.TextTransparency = 0.4

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Parent = TopBar
VersionLabel.BackgroundTransparency = 1
VersionLabel.Position = UDim2.new(0, 20, 0, 50)
VersionLabel.Size = UDim2.new(0.7, 0, 0, 15)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Text = "by ikxz • v3.5 Mobile"
VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.TextTransparency = 0.5

-- Close Button (MOBILE FRIENDLY)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -55, 0.5, -20)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainMenu
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 15, 0, 85)
ContentFrame.Size = UDim2.new(1, -30, 1, -100)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentFrame
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 12)

-- ===== PREMIUM TOGGLE BUTTON FUNCTION =====
local function CreateToggleCard(title, subtitle, icon, callback)
    local Card = Instance.new("Frame")
    Card.Parent = ContentFrame
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Card.BorderSizePixel = 0
    Card.Size = UDim2.new(1, 0, 0, 75)
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 15)
    CardCorner.Parent = Card
    
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(60, 60, 70)
    CardStroke.Thickness = 1.5
    CardStroke.Transparency = 0.5
    CardStroke.Parent = Card
    
    -- Icon Circle
    local IconCircle = Instance.new("Frame")
    IconCircle.Parent = Card
    IconCircle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    IconCircle.BorderSizePixel = 0
    IconCircle.Position = UDim2.new(0, 12, 0.5, -22)
    IconCircle.Size = UDim2.new(0, 44, 0, 44)
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = IconCircle
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Parent = IconCircle
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = icon
    IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    IconLabel.TextSize = 22
    
    -- Title
    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = Card
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 68, 0, 12)
    TitleText.Size = UDim2.new(0, 180, 0, 20)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = title
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 15
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle
    local SubText = Instance.new("TextLabel")
    SubText.Parent = Card
    SubText.BackgroundTransparency = 1
    SubText.Position = UDim2.new(0, 68, 0, 35)
    SubText.Size = UDim2.new(0, 180, 0, 25)
    SubText.Font = Enum.Font.Gotham
    SubText.Text = subtitle
    SubText.TextColor3 = Color3.fromRGB(180, 180, 190)
    SubText.TextSize = 11
    SubText.TextXAlignment = Enum.TextXAlignment.Left
    SubText.TextWrapped = true
    
    -- Toggle Switch (MOBILE FRIENDLY)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = Card
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -80, 0.5, -18)
    ToggleButton.Size = UDim2.new(0, 65, 0, 36)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Parent = ToggleButton
    ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    ToggleKnob.BorderSizePixel = 0
    ToggleKnob.Position = UDim2.new(0, 4, 0.5, -14)
    ToggleKnob.Size = UDim2.new(0, 28, 0, 28)
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = ToggleKnob
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Parent = Card
    StatusText.BackgroundTransparency = 1
    StatusText.Position = UDim2.new(1, -80, 0, 50)
    StatusText.Size = UDim2.new(0, 65, 0, 15)
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Text = "OFF"
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 160)
    StatusText.TextSize = 10
    
    local state = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        
        if state then
            TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(67, 181, 129)}):Play()
            TweenService:Create(ToggleKnob, TweenInfo.new(0.3), {Position = UDim2.new(1, -32, 0.5, -14), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(CardStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(67, 181, 129), Transparency = 0}):Play()
            TweenService:Create(StatusText, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(67, 181, 129)}):Play()
            StatusText.Text = "ON"
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(ToggleKnob, TweenInfo.new(0.3), {Position = UDim2.new(0, 4, 0.5, -14), BackgroundColor3 = Color3.fromRGB(200, 200, 210)}):Play()
            TweenService:Create(CardStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(60, 60, 70), Transparency = 0.5}):Play()
            TweenService:Create(StatusText, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
            StatusText.Text = "OFF"
        end
        
        callback(state)
    end)
    
    return Card
end

-- ===== CREATE TOGGLE CARDS =====
CreateToggleCard("AIMBOT", "Auto lock to enemy head", "🎯", function(state)
    Config.Aimbot = state
end)

CreateToggleCard("AUTO HIT", "Auto attack in 20 studs", "⚔️", function(state)
    Config.AutoHit = state
end)

CreateToggleCard("ESP WALLHACK", "See all enemies through walls", "👁️", function(state)
    Config.ESP = state
    if state then EnableESP() else DisableESP() end
end)

CreateToggleCard("SPEED HACK", "Walk faster than normal", "⚡", function(state)
    Config.Speed = state
end)

-- ===== SPEED SLIDER CARD =====
local SliderCard = Instance.new("Frame")
SliderCard.Parent = ContentFrame
SliderCard.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
SliderCard.BorderSizePixel = 0
SliderCard.Size = UDim2.new(1, 0, 0, 90)

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 15)
SliderCorner.Parent = SliderCard

local SliderStroke = Instance.new("UIStroke")
SliderStroke.Color = Color3.fromRGB(60, 60, 70)
SliderStroke.Thickness = 1.5
SliderStroke.Transparency = 0.5
SliderStroke.Parent = SliderCard

local SliderTitle = Instance.new("TextLabel")
SliderTitle.Parent = SliderCard
SliderTitle.BackgroundTransparency = 1
SliderTitle.Position = UDim2.new(0, 15, 0, 12)
SliderTitle.Size = UDim2.new(1, -30, 0, 20)
SliderTitle.Font = Enum.Font.GothamBold
SliderTitle.Text = "SPEED VALUE"
SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderTitle.TextSize = 14
SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

local SliderValue = Instance.new("TextLabel")
SliderValue.Parent = SliderCard
SliderValue.BackgroundTransparency = 1
SliderValue.Position = UDim2.new(1, -70, 0, 12)
SliderValue.Size = UDim2.new(0, 55, 0, 20)
SliderValue.Font = Enum.Font.GothamBold
SliderValue.Text = "16"
SliderValue.TextColor3 = Color3.fromRGB(138, 43, 226)
SliderValue.TextSize = 16

-- Slider Track
local SliderTrack = Instance.new("Frame")
SliderTrack.Parent = SliderCard
SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderTrack.BorderSizePixel = 0
SliderTrack.Position = UDim2.new(0, 15, 0, 50)
SliderTrack.Size = UDim2.new(1, -30, 0, 10)

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

-- Slider Fill
local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderTrack
SliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SliderFill.BorderSizePixel = 0
SliderFill.Size = UDim2.new(0, 0, 1, 0)

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local FillGradient = Instance.new("UIGradient")
FillGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
}
FillGradient.Parent = SliderFill

-- Slider Button (MOBILE FRIENDLY - BIGGER)
local SliderBtn = Instance.new("TextButton")
SliderBtn.Parent = SliderTrack
SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderBtn.BorderSizePixel = 0
SliderBtn.Position = UDim2.new(0, -12, 0.5, -12)
SliderBtn.Size = UDim2.new(0, 24, 0, 24)
SliderBtn.Text = ""
SliderBtn.AutoButtonColor = false

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = SliderBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(138, 43, 226)
BtnStroke.Thickness = 3
BtnStroke.Parent = SliderBtn

-- Slider Logic (MOBILE OPTIMIZED)
local dragging = false

SliderBtn.MouseButton1Down:Connect(function()
    dragging = true
end)

SliderBtn.TouchTap:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos
        if UserInputService.TouchEnabled then
            local touches = UserInputService:GetTouchesInProgress()
            if #touches > 0 then
                mousePos = touches[1].Position.X
            end
        else
            mousePos = UserInputService:GetMouseLocation().X
        end
        
        if mousePos then
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local relPos = math.clamp(mousePos - trackPos, 0, trackSize)
            local percent = relPos / trackSize
            
            SliderBtn.Position = UDim2.new(percent, -12, 0.5, -12)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            
            Config.SpeedValue = math.floor(16 + (percent * 84))
            SliderValue.Text = tostring(Config.SpeedValue)
        end
    end
end)

-- ===== TELEPORT SECTION =====
local TeleportCard = Instance.new("Frame")
TeleportCard.Parent = ContentFrame
TeleportCard.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TeleportCard.BorderSizePixel = 0
TeleportCard.Size = UDim2.new(1, 0, 0, 150)

local TPCorner = Instance.new("UICorner")
TPCorner.CornerRadius = UDim.new(0, 15)
TPCorner.Parent = TeleportCard

local TPStroke = Instance.new("UIStroke")
TPStroke.Color = Color3.fromRGB(60, 60, 70)
TPStroke.Thickness = 1.5
TPStroke.Transparency = 0.5
TPStroke.Parent = TeleportCard

local TPTitle = Instance.new("TextLabel")
TPTitle.Parent = TeleportCard
TPTitle.BackgroundTransparency = 1
TPTitle.Position = UDim2.new(0, 15, 0, 12)
TPTitle.Size = UDim2.new(1, -30, 0, 25)
TPTitle.Font = Enum.Font.GothamBold
TPTitle.Text = "🌀 TELEPORT TO PLAYER"
TPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TPTitle.TextSize = 15
TPTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown Button (MOBILE FRIENDLY)
local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Parent = TeleportCard
DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DropdownBtn.BorderSizePixel = 0
DropdownBtn.Position = UDim2.new(0, 15, 0, 45)
DropdownBtn.Size = UDim2.new(1, -30, 0, 45)
DropdownBtn.Font = Enum.Font.Gotham
DropdownBtn.Text = "  Select Player..."
DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownBtn.TextSize = 13
DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
DropdownBtn.AutoButtonColor = false

local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 10)
DropCorner.Parent = DropdownBtn

local DropArrow = Instance.new("TextLabel")
DropArrow.Parent = DropdownBtn
DropArrow.BackgroundTransparency = 1
DropArrow.Position = UDim2.new(1, -40, 0, 0)
DropArrow.Size = UDim2.new(0, 40, 1, 0)
DropArrow.Font = Enum.Font.GothamBold
DropArrow.Text = "▼"
DropArrow.TextColor3 = Color3.fromRGB(138, 43, 226)
DropArrow.TextSize = 14

-- Teleport Button (MOBILE FRIENDLY)
local TPBtn = Instance.new("TextButton")
TPBtn.Parent = TeleportCard
TPBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
TPBtn.BorderSizePixel = 0
TPBtn.Position = UDim2.new(0, 15, 0, 100)
TPBtn.Size = UDim2.new(1, -30, 0, 45)
TPBtn.Font = Enum.Font.GothamBold
TPBtn.Text = "TELEPORT NOW"
TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBtn.TextSize = 15
TPBtn.AutoButtonColor = false

local TPBtnCorner = Instance.new("UICorner")
TPBtnCorner.CornerRadius = UDim.new(0, 10)
TPBtnCorner.Parent = TPBtn

local TPGradient = Instance.new("UIGradient")
TPGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
}
TPGradient.Rotation = 45
TPGradient.Parent = TPBtn

-- Dropdown List
local DropList = Instance.new("ScrollingFrame")
DropList.Parent = TeleportCard
DropList.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
DropList.BorderSizePixel = 0
DropList.Position = UDim2.new(0, 15, 0, 95)
DropList.Size = UDim2.new(1, -30, 0, 0)
DropList.Visible = false
DropList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropList.ScrollBarThickness = 5
DropList.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
DropList.ZIndex = 100
DropList.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 10)
ListCorner.Parent = DropList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = DropList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)

local selectedPlayer = nil

local function UpdatePlayerList()
    for _, child in pairs(DropList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerBtn = Instance.new("TextButton")
            PlayerBtn.Parent = DropList
            PlayerBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            PlayerBtn.BorderSizePixel = 0
            PlayerBtn.Size = UDim2.new(1, -10, 0, 40)
            PlayerBtn.Font = Enum.Font.Gotham
            PlayerBtn.Text = "  " .. player.Name
            PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerBtn.TextSize = 13
            PlayerBtn.TextXAlignment = Enum.TextXAlignment.Left
            PlayerBtn.AutoButtonColor = false
            
            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 8)
            PCorner.Parent = PlayerBtn
            
            PlayerBtn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                DropdownBtn.Text = "  " .. player.Name
                DropList.Visible = false
                DropArrow.Text = "▼"
                TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
            end)
            
            PlayerBtn.MouseEnter:Connect(function()
                TweenService:Create(PlayerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226)}):Play()
            end)
            
            PlayerBtn.MouseLeave:Connect(function()
                TweenService:Create(PlayerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
            end)
        end
    end
end

DropdownBtn.MouseButton1Click:Connect(function()
    DropList.Visible = not DropList.Visible
    if DropList.Visible then
        DropArrow.Text = "▲"
        UpdatePlayerList()
        local playerCount = #Players:GetPlayers() - 1
        local height = math.min(playerCount * 43, 180)
        TweenService:Create(DropList, TweenInfo.new(0.3), {Size = UDim2.new(1, -30, 0, height)}):Play()
    else
        DropArrow.Text = "▼"
        TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
    end
end)

TPBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "✅ Teleport Success";
                Text = "Teleported to " .. selectedPlayer.Name;
                Duration = 2;
            })
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "❌ Error";
            Text = "Please select a player first!";
            Duration = 2;
        })
    end
end)

TPBtn.MouseEnter:Connect(function()
    TweenService:Create(TPBtn, TweenInfo.new(0.2), {Size = UDim2.new(1, -25, 0, 45)}):Play()
end)

TPBtn.MouseLeave:Connect(function()
    TweenService:Create(TPBtn, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 45)}):Play()
end)

-- ===== CREDITS CARD =====
local CreditsCard = Instance.new("Frame")
CreditsCard.Parent = ContentFrame
CreditsCard.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
CreditsCard.BorderSizePixel = 0
CreditsCard.Size = UDim2.new(1, 0, 0, 70)

local CreditCorner = Instance.new("UICorner")
CreditCorner.CornerRadius = UDim.new(0, 15)
CreditCorner.Parent = CreditsCard

local CreditStroke = Instance.new("UIStroke")
CreditStroke.Color = Color3.fromRGB(60, 60, 70)
CreditStroke.Thickness = 1.5
CreditStroke.Transparency = 0.5
CreditStroke.Parent = CreditsCard

local CreditGradient = Instance.new("UIGradient")
CreditGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
}
CreditGradient.Rotation = 45
CreditGradient.Transparency = NumberSequence.new(0.9)
CreditGradient.Parent = CreditsCard

local CreditTitle = Instance.new("TextLabel")
CreditTitle.Parent = CreditsCard
CreditTitle.BackgroundTransparency = 1
CreditTitle.Size = UDim2.new(1, 0, 0, 30)
CreditTitle.Position = UDim2.new(0, 0, 0, 10)
CreditTitle.Font = Enum.Font.GothamBold
CreditTitle.Text = "💎 CREATED BY ikxz"
CreditTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditTitle.TextSize = 14

local CreditDesc = Instance.new("TextLabel")
CreditDesc.Parent = CreditsCard
CreditDesc.BackgroundTransparency = 1
CreditDesc.Position = UDim2.new(0, 0, 0, 40)
CreditDesc.Size = UDim2.new(1, 0, 0, 20)
CreditDesc.Font = Enum.Font.Gotham
CreditDesc.Text = "Violence District Mobile Premium v3.5"
CreditDesc.TextColor3 = Color3.fromRGB(150, 150, 160)
CreditDesc.TextSize = 11

-- ===== TOGGLE MENU =====
local menuOpen = false

FloatingButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        MainMenu.Visible = true
        MainMenu.Size = UDim2.new(0, 0, 0, 0)
        MainMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainMenu, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 360, 0, 500),
            Position = UDim2.new(0.5, -180, 0.5, -250)
        }):Play()
    else
        TweenService:Create(MainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        MainMenu.Visible = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    wait(0.3)
    MainMenu.Visible = false
    menuOpen = false
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

-- ===== AUTO HIT LOGIC =====
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

local lastHitTime = 0
local hitCooldown = 0.3

RunService.Heartbeat:Connect(function()
    if not Config.AutoHit then return end
    
    local targetPlayer, distance = GetClosestPlayerInRange()
    
    if targetPlayer and tick() - lastHitTime >= hitCooldown then
        if LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            
            if tool then
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
                
                pcall(function()
                    tool:Activate()
                end)
                
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("shoot") or v.Name:lower():find("fire") or v.Name:lower():find("damage")) then
                        pcall(function()
                            v:FireServer(targetPlayer.Character.Head.Position, targetPlayer.Character.Head)
                        end)
                    end
                end
                
                lastHitTime = tick()
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
    NameLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
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
    Highlight.FillColor = Color3.fromRGB(138, 43, 226)
    Highlight.FillTransparency = 0.7
    Highlight.OutlineColor = Color3.fromRGB(255, 20, 147)
    Highlight.OutlineTransparency = 0
    
    ESPObjects[player] = {Billboard, Highlight, DistLabel}
    
    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            DistLabel.Text = math.floor(dist) .. "m"
            
            if Config.AutoHit and dist <= Config.AutoHitRange then
                DistLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                Highlight.FillColor = Color3.fromRGB(0, 255, 0)
            else
                DistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                Highlight.FillColor = Color3.fromRGB(138, 43, 226)
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
    Title = "✅ ikxz Premium Mobile";
    Text = "Successfully loaded! Tap ikxz button";
    Duration = 5;
})

wait(2)

game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 All Features Ready";
    Text = "Aimbot • ESP • Speed • Auto Hit • Teleport";
    Duration = 4;
})

print("===================================")
print("ikxz Violence District Mobile v3.5")
print("PREMIUM MOBILE EDITION LOADED!")
print("===================================")