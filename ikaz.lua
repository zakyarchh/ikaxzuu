-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    VIOLENCE DISTRICT V4 - PREMIUM EDITION                    ║
-- ║                         MONOCHROME DARK THEME                                 ║
-- ║                      Minimalist | Professional | Elegant                     ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

-- LOCAL VARIABLES
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

local SAVE_FILE = "vd4_premium_mono.json"
local VERSION = "4.0.0"

-- ══════════════════════════════════════════════════════════════════════════════
-- MONOCHROME COLOR PALETTE - Premium Dark Aesthetic
-- ══════════════════════════════════════════════════════════════════════════════

local col = {
    -- Background layers (from darkest to lightest)
    bg = Color3.fromRGB(8, 8, 8),        -- #080808 - Deepest background
    bgOverlay = Color3.fromRGB(10, 10, 10), -- #0a0a0a - Overlay layer
    bgSoft = Color3.fromRGB(15, 15, 15),  -- #0f0f0f - Main background
    
    -- Surface colors
    surface = Color3.fromRGB(20, 20, 20),    -- #141414 - Cards/panels
    surfaceElevated = Color3.fromRGB(26, 26, 26), -- #1a1a1a - Elevated surfaces
    surfaceMedium = Color3.fromRGB(32, 32, 32), -- #202020 - Medium surfaces
    surfaceLight = Color3.fromRGB(42, 42, 42), -- #2a2a2a - Light surfaces
    
    -- Interactive states
    hover = Color3.fromRGB(38, 38, 38),    -- #262626 - Hover state
    active = Color3.fromRGB(48, 48, 48),   -- #303030 - Active/selected
    
    -- Border colors
    border = Color3.fromRGB(58, 58, 58),   -- #3a3a3a - Subtle border
    borderLight = Color3.fromRGB(70, 70, 70), -- #464646 - Lighter border
    
    -- Text colors
    text = Color3.fromRGB(230, 230, 230),  -- #e6e6e6 - Primary text
    textSecondary = Color3.fromRGB(170, 170, 170), -- #aaaaaa - Secondary text
    textMuted = Color3.fromRGB(110, 110, 110), -- #6e6e6e - Muted text
    textDim = Color3.fromRGB(70, 70, 70),  -- #464646 - Dim text
    
    -- Accent (still monochrome, just lighter)
    accent = Color3.fromRGB(200, 200, 200), -- #c8c8c8 - Soft white accent
    accentDim = Color3.fromRGB(140, 140, 140), -- #8c8c8c - Dim accent
    
    -- Toggle states
    toggleOn = Color3.fromRGB(45, 45, 45),  -- #2d2d2d - On state
    toggleOff = Color3.fromRGB(25, 25, 25), -- #191919 - Off state
    toggleKnob = Color3.fromRGB(200, 200, 200), -- #c8c8c8 - Knob
    
    -- Slider
    sliderTrack = Color3.fromRGB(30, 30, 30), -- #1e1e1e
    sliderFill = Color3.fromRGB(120, 120, 120), -- #787878
    sliderKnob = Color3.fromRGB(230, 230, 230), -- #e6e6e6
    
    -- Shadow
    shadow = Color3.fromRGB(0, 0, 0),
}

-- ══════════════════════════════════════════════════════════════════════════════
-- TWEEN PRESETS - Smooth animations
-- ══════════════════════════════════════════════════════════════════════════════

local tweenInfo = {
    instant = TweenInfo.new(0, Enum.EasingStyle.Linear),
    fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    medium = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    bounce = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- ══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ══════════════════════════════════════════════════════════════════════════════

local function getParent()
    local success, result = pcall(function() return gethui() end)
    return success and result or CoreGui
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function round(value, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(value * mult + 0.5) / mult
end

local function isAlive(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    return hum and hrp and hum.Health > 0
end

local function getHRP()
    local character = plr.Character or plr.CharacterAdded:Wait()
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- ══════════════════════════════════════════════════════════════════════════════
-- BLUR EFFECT - Soft cinematic blur
-- ══════════════════════════════════════════════════════════════════════════════

local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "VD4_Blur"
blurEffect.Size = 0
blurEffect.Parent = Lighting

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN GUI CONTAINER
-- ══════════════════════════════════════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "VD4_Premium_" .. math.random(10000, 99999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999

-- ══════════════════════════════════════════════════════════════════════════════
-- BACKGROUND IMAGE - Premium dark aesthetic
-- ══════════════════════════════════════════════════════════════════════════════

local background = Instance.new("ImageLabel")
background.Name = "Background"
background.Parent = gui
background.BackgroundColor3 = col.bgSoft
background.BackgroundTransparency = 0
background.Size = UDim2.new(1, 0, 1, 0)
background.Image = "rbxassetid://110880933953206"
background.ImageColor3 = Color3.fromRGB(255, 255, 255)
background.ImageTransparency = 0.4
background.ScaleType = Enum.ScaleType.Crop
background.ZIndex = 0

-- Dark overlay for better text readability
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Parent = background
overlay.BackgroundColor3 = col.bgSoft
overlay.BackgroundTransparency = 0.45
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BorderSizePixel = 0
overlay.ZIndex = 1

-- ══════════════════════════════════════════════════════════════════════════════
-- TOGGLE BUTTON - Using specified icon
-- ══════════════════════════════════════════════════════════════════════════════

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surfaceElevated
toggleBtn.BackgroundTransparency = 0.1
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 20, 0.5, -22)
toggleBtn.Size = UDim2.new(0, 44, 0, 44)
toggleBtn.Image = "rbxassetid://126828045858708"
toggleBtn.ImageColor3 = col.textSecondary
toggleBtn.ScaleType = Enum.ScaleType.Fit
toggleBtn.ZIndex = 100

-- Corner radius
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleBtn

-- Subtle border
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = col.border
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.6
toggleStroke.Parent = toggleBtn

-- Soft shadow
local toggleShadow = Instance.new("ImageLabel")
toggleShadow.Name = "Shadow"
toggleShadow.Parent = toggleBtn
toggleShadow.BackgroundTransparency = 1
toggleShadow.Size = UDim2.new(1, 20, 1, 20)
toggleShadow.Position = UDim2.new(0, -10, 0, -10)
toggleShadow.Image = "rbxassetid://5028857084"
toggleShadow.ImageColor3 = col.shadow
toggleShadow.ImageTransparency = 0.7
toggleShadow.ZIndex = 99

-- Drag system
local toggleDragging = false
local toggleDragStart = nil
local toggleStartPos = nil
local toggleDragMoved = false

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        toggleDragMoved = false
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = false
        if not toggleDragMoved then
            toggleMenu()
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - toggleDragStart
        if delta.Magnitude > 5 then
            toggleDragMoved = true
        end
        local newX = clamp(toggleStartPos.X.Offset + delta.X, 0, cam.ViewportSize.X - 50)
        local newY = clamp(toggleStartPos.Y.Offset + delta.Y, 30, cam.ViewportSize.Y - 70)
        toggleBtn.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- Hover effect
toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, tweenInfo.fast, {
        BackgroundColor3 = col.hover,
        ImageColor3 = col.text
    }):Play()
    TweenService:Create(toggleStroke, tweenInfo.fast, {Color = col.borderLight, Transparency = 0.4}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, tweenInfo.fast, {
        BackgroundColor3 = col.surfaceElevated,
        ImageColor3 = col.textSecondary
    }):Play()
    TweenService:Create(toggleStroke, tweenInfo.fast, {Color = col.border, Transparency = 0.6}):Play()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN MENU FRAME
-- ══════════════════════════════════════════════════════════════════════════════

local mainWidth = 720
local mainHeight = 450
local sidebarWidth = 140
local headerHeight = 48

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = col.bgSoft
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.ZIndex = 50

-- Main corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

-- Main border
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = col.border
mainStroke.Thickness = 1
mainStroke.Transparency = 0.7
mainStroke.Parent = main

-- Main shadow
local mainShadow = Instance.new("ImageLabel")
mainShadow.Name = "Shadow"
mainShadow.Parent = main
mainShadow.BackgroundTransparency = 1
mainShadow.Size = UDim2.new(1, 40, 1, 40)
mainShadow.Position = UDim2.new(0, -20, 0, -20)
mainShadow.Image = "rbxassetid://5028857084"
mainShadow.ImageColor3 = col.shadow
mainShadow.ImageTransparency = 0.8
mainShadow.ZIndex = 49

-- ══════════════════════════════════════════════════════════════════════════════
-- HEADER
-- ══════════════════════════════════════════════════════════════════════════════

local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = main
header.BackgroundColor3 = col.surfaceElevated
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, headerHeight)
header.ZIndex = 55

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

-- Header bottom line
local headerLine = Instance.new("Frame")
headerLine.Parent = header
headerLine.BackgroundColor3 = col.border
headerLine.BackgroundTransparency = 0.8
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.ZIndex = 56

-- Title
local title = Instance.new("TextLabel")
title.Parent = header
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 20, 0, 0)
title.Size = UDim2.new(0, 200, 1, 0)
title.Font = Enum.Font.GothamMedium
title.Text = "VIOLENCE DISTRICT"
title.TextColor3 = col.text
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 57

-- Version
local version = Instance.new("TextLabel")
version.Parent = header
version.BackgroundTransparency = 1
version.Position = UDim2.new(0, 20, 0, 24)
version.Size = UDim2.new(0, 200, 0, 18)
version.Font = Enum.Font.Gotham
version.Text = "PREMIUM EDITION • v" .. VERSION
version.TextColor3 = col.textMuted
version.TextSize = 9
version.TextXAlignment = Enum.TextXAlignment.Left
version.ZIndex = 57

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = header
closeBtn.BackgroundColor3 = col.surfaceLight
closeBtn.BackgroundTransparency = 0.3
closeBtn.Position = UDim2.new(1, -38, 0.5, -12)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamMedium
closeBtn.Text = "✕"
closeBtn.TextColor3 = col.textMuted
closeBtn.TextSize = 12
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 58

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, tweenInfo.fast, {
        BackgroundTransparency = 0.1,
        TextColor3 = col.text
    }):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, tweenInfo.fast, {
        BackgroundTransparency = 0.3,
        TextColor3 = col.textMuted
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    closeMenu()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- SIDEBAR
-- ══════════════════════════════════════════════════════════════════════════════

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Parent = main
sidebar.BackgroundColor3 = col.surface
sidebar.BackgroundTransparency = 0.15
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, headerHeight)
sidebar.Size = UDim2.new(0, sidebarWidth, 1, -headerHeight)
sidebar.ZIndex = 52

-- Sidebar line
local sidebarLine = Instance.new("Frame")
sidebarLine.Parent = sidebar
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BackgroundTransparency = 0.8
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.ZIndex = 53

-- Tab container
local tabContainer = Instance.new("Frame")
tabContainer.Parent = sidebar
tabContainer.BackgroundTransparency = 1
tabContainer.Position = UDim2.new(0, 8, 0, 12)
tabContainer.Size = UDim2.new(1, -16, 1, -24)
tabContainer.ZIndex = 54

local tabList = Instance.new("ScrollingFrame")
tabList.Parent = tabContainer
tabList.BackgroundTransparency = 1
tabList.Size = UDim2.new(1, 0, 1, 0)
tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
tabList.ScrollBarThickness = 0
tabList.ScrollingDirection = Enum.ScrollingDirection.Y
tabList.ZIndex = 55

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabList
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 8)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- CONTENT AREA
-- ══════════════════════════════════════════════════════════════════════════════

local content = Instance.new("Frame")
content.Name = "Content"
content.Parent = main
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, sidebarWidth + 12, 0, headerHeight + 12)
content.Size = UDim2.new(1, -(sidebarWidth + 24), 1, -(headerHeight + 24))
content.ZIndex = 52
content.ClipsDescendants = true

-- ══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

local notifContainer = Instance.new("Frame")
notifContainer.Name = "Notifications"
notifContainer.Parent = gui
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -280, 0, 20)
notifContainer.Size = UDim2.new(0, 260, 0, 300)
notifContainer.ZIndex = 200

local notifLayout = Instance.new("UIListLayout")
notifLayout.Parent = notifContainer
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function notify(message, duration, notifType)
    duration = duration or 3
    
    local notif = Instance.new("Frame")
    notif.Parent = notifContainer
    notif.BackgroundColor3 = col.surfaceElevated
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 0, 0, 0)
    notif.ClipsDescendants = true
    notif.ZIndex = 201
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = col.borderLight
    notifStroke.Thickness = 1
    notifStroke.Transparency = 0.6
    notifStroke.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Parent = notif
    messageLabel.BackgroundTransparency = 1
    messageLabel.Position = UDim2.new(0, 14, 0, 12)
    messageLabel.Size = UDim2.new(1, -28, 0, 16)
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.Text = message
    messageLabel.TextColor3 = col.text
    messageLabel.TextSize = 12
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextTransparency = 1
    messageLabel.ZIndex = 202
    
    -- Animate in
    TweenService:Create(notif, tweenInfo.medium, {Size = UDim2.new(0, 240, 0, 40)}):Play()
    task.delay(0.1, function()
        TweenService:Create(messageLabel, tweenInfo.fast, {TextTransparency = 0}):Play()
    end)
    
    -- Animate out
    task.delay(duration, function()
        TweenService:Create(messageLabel, tweenInfo.fast, {TextTransparency = 1}):Play()
        TweenService:Create(notif, tweenInfo.medium, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.25)
        notif:Destroy()
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- UI COMPONENT FACTORY
-- ══════════════════════════════════════════════════════════════════════════════

local pages = {}
local tabButtons = {}
local activeTab = nil

-- Create page
local function createPage(id)
    local page = Instance.new("ScrollingFrame")
    page.Name = id
    page.Parent = content
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = col.textMuted
    page.ScrollBarImageTransparency = 0.7
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.Visible = false
    page.ZIndex = 53
    
    local padding = Instance.new("UIPadding")
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = page
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)
    
    pages[id] = page
    return page
end

-- Section label
local function createSection(parent, text)
    local container = Instance.new("Frame")
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 28)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 4, 0, 4)
    label.Size = UDim2.new(1, -8, 0, 16)
    label.Font = Enum.Font.GothamMedium
    label.Text = text:upper()
    label.TextColor3 = col.textMuted
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local line = Instance.new("Frame")
    line.Parent = container
    line.BackgroundColor3 = col.border
    line.BackgroundTransparency = 0.8
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 4, 1, -1)
    line.Size = UDim2.new(1, -8, 0, 1)
    
    return container
end

-- Toggle button (monochrome style)
local function createToggle(parent, text, defaultState, callback)
    local state = defaultState or false
    
    local container = Instance.new("TextButton")
    container.Parent = parent
    container.BackgroundColor3 = col.surface
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 38)
    container.Text = ""
    container.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local switch = Instance.new("Frame")
    switch.Parent = container
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = col.toggleOff
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -14, 0.5, 0)
    switch.Size = UDim2.new(0, 36, 0, 18)
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Parent = switch
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = col.textDim
    knob.BorderSizePixel = 0
    knob.Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local function updateVisual(animate)
        local tween = animate and tweenInfo.medium or tweenInfo.instant
        
        if state then
            TweenService:Create(switch, tween, {BackgroundColor3 = col.toggleOn}):Play()
            TweenService:Create(knob, tween, {
                Position = UDim2.new(1, -15, 0.5, 0),
                BackgroundColor3 = col.text
            }):Play()
            TweenService:Create(label, tween, {TextColor3 = col.text}):Play()
        else
            TweenService:Create(switch, tween, {BackgroundColor3 = col.toggleOff}):Play()
            TweenService:Create(knob, tween, {
                Position = UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = col.textDim
            }):Play()
            TweenService:Create(label, tween, {TextColor3 = col.textSecondary}):Play()
        end
    end
    
    local function toggle()
        state = not state
        updateVisual(true)
        if callback then
            pcall(callback, state)
        end
    end
    
    container.MouseButton1Click:Connect(toggle)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweenInfo.fast, {BackgroundColor3 = col.hover}):Play()
        TweenService:Create(stroke, tweenInfo.fast, {Color = col.borderLight, Transparency = 0.5}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweenInfo.fast, {BackgroundColor3 = col.surface}):Play()
        TweenService:Create(stroke, tweenInfo.fast, {Color = col.border, Transparency = 0.7}):Play()
    end)
    
    updateVisual(false)
    
    return {
        setState = function(v)
            state = v
            updateVisual(true)
        end,
        getState = function() return state end
    }
end

-- Slider
local function createSlider(parent, text, min, max, defaultValue, suffix, callback)
    local value = defaultValue or min
    local dragging = false
    
    local container = Instance.new("Frame")
    container.Parent = parent
    container.BackgroundColor3 = col.surface
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 52)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 8)
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = container
    valueLabel.BackgroundColor3 = col.surfaceLight
    valueLabel.BackgroundTransparency = 0.3
    valueLabel.Position = UDim2.new(1, -60, 0, 8)
    valueLabel.Size = UDim2.new(0, 48, 0, 18)
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.Text = tostring(value) .. (suffix or "")
    valueLabel.TextColor3 = col.text
    valueLabel.TextSize = 10
    
    local valueCorner = Instance.new("UICorner")
    valueCorner.CornerRadius = UDim.new(0, 6)
    valueCorner.Parent = valueLabel
    
    local track = Instance.new("Frame")
    track.Parent = container
    track.BackgroundColor3 = col.sliderTrack
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 14, 0, 34)
    track.Size = UDim2.new(1, -28, 0, 6)
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = col.sliderFill
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Parent = fill
    knob.AnchorPoint = Vector2.new(1, 0.5)
    knob.BackgroundColor3 = col.sliderKnob
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local hitbox = Instance.new("TextButton")
    hitbox.Parent = track
    hitbox.BackgroundTransparency = 1
    hitbox.Size = UDim2.new(1, 0, 1, 12)
    hitbox.Position = UDim2.new(0, 0, 0, -3)
    hitbox.Text = ""
    hitbox.ZIndex = 60
    
    local function updateValue(inputPos)
        local pos = clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = round(min + (max - min) * pos, 0)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value) .. (suffix or "")
        
        if callback then
            pcall(callback, value)
        end
    end
    
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input.Position.X)
            TweenService:Create(knob, tweenInfo.fast, {Size = UDim2.new(0, 14, 0, 14)}):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            TweenService:Create(knob, tweenInfo.fast, {Size = UDim2.new(0, 12, 0, 12)}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)
    
    return {
        setValue = function(v)
            value = clamp(v, min, max)
            local pos = (value - min) / (max - min)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            valueLabel.Text = tostring(value) .. (suffix or "")
        end
    }
end

-- Button
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = col.surface
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = col.textSecondary
    btn.TextSize = 12
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, tweenInfo.fast, {BackgroundColor3 = col.active}):Play()
        task.wait(0.1)
        TweenService:Create(btn, tweenInfo.fast, {BackgroundColor3 = col.surface}):Play()
        if callback then pcall(callback) end
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, tweenInfo.fast, {
            BackgroundColor3 = col.hover,
            TextColor3 = col.text
        }):Play()
        TweenService:Create(stroke, tweenInfo.fast, {Color = col.borderLight, Transparency = 0.5}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, tweenInfo.fast, {
            BackgroundColor3 = col.surface,
            TextColor3 = col.textSecondary
        }):Play()
        TweenService:Create(stroke, tweenInfo.fast, {Color = col.border, Transparency = 0.7}):Play()
    end)
    
    return btn
end

-- ══════════════════════════════════════════════════════════════════════════════
-- CREATE TABS
-- ══════════════════════════════════════════════════════════════════════════════

local tabs = {
    {id = "home", name = "HOME"},
    {id = "combat", name = "COMBAT"},
    {id = "movement", name = "MOVEMENT"},
    {id = "visual", name = "VISUAL"},
    {id = "player", name = "PLAYER"},
    {id = "utility", name = "UTILITY"},
}

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabList
    btn.BackgroundColor3 = col.surfaceMedium
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = ""
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = col.text
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.5, -8)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator
    
    local label = Instance.new("TextLabel")
    label.Parent = btn
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = tab.name
    label.TextColor3 = col.textDim
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local page = createPage(tab.id)
    tabButtons[tab.id] = {btn = btn, label = label, indicator = indicator}
    
    btn.MouseButton1Click:Connect(function()
        for id, data in pairs(tabButtons) do
            TweenService:Create(data.btn, tweenInfo.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.label, tweenInfo.fast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.indicator, tweenInfo.medium, {Size = UDim2.new(0, 3, 0, 0)}):Play()
            pages[id].Visible = false
        end
        
        TweenService:Create(btn, tweenInfo.fast, {BackgroundTransparency = 0.7}):Play()
        TweenService:Create(label, tweenInfo.fast, {TextColor3 = col.text}):Play()
        TweenService:Create(indicator, tweenInfo.bounce, {Size = UDim2.new(0, 3, 0, 16)}):Play()
        page.Visible = true
        activeTab = tab.id
    end)
    
    if i == 1 then
        btn.BackgroundTransparency = 0.7
        label.TextColor3 = col.text
        indicator.Size = UDim2.new(0, 3, 0, 16)
        page.Visible = true
        activeTab = tab.id
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- POPULATE HOME PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local homePage = pages["home"]

-- Stats row
local statsRow = Instance.new("Frame")
statsRow.Parent = homePage
statsRow.BackgroundTransparency = 1
statsRow.Size = UDim2.new(1, 0, 0, 80)

local stat1 = Instance.new("Frame")
stat1.Parent = statsRow
stat1.BackgroundColor3 = col.surface
stat1.BackgroundTransparency = 0.15
stat1.Position = UDim2.new(0, 0, 0, 0)
stat1.Size = UDim2.new(0.48, 0, 1, 0)

local stat1Corner = Instance.new("UICorner")
stat1Corner.CornerRadius = UDim.new(0, 12)
stat1Corner.Parent = stat1

local stat1Title = Instance.new("TextLabel")
stat1Title.Parent = stat1
stat1Title.BackgroundTransparency = 1
stat1Title.Position = UDim2.new(0, 14, 0, 14)
stat1Title.Size = UDim2.new(1, -28, 0, 20)
stat1Title.Font = Enum.Font.Gotham
stat1Title.Text = "PLAYER"
stat1Title.TextColor3 = col.textMuted
stat1Title.TextSize = 11
stat1Title.TextXAlignment = Enum.TextXAlignment.Left

local stat1Value = Instance.new("TextLabel")
stat1Value.Parent = stat1
stat1Value.BackgroundTransparency = 1
stat1Value.Position = UDim2.new(0, 14, 0, 38)
stat1Value.Size = UDim2.new(1, -28, 0, 24)
stat1Value.Font = Enum.Font.GothamMedium
stat1Value.Text = plr.DisplayName
stat1Value.TextColor3 = col.text
stat1Value.TextSize = 16
stat1Value.TextXAlignment = Enum.TextXAlignment.Left

local stat2 = Instance.new("Frame")
stat2.Parent = statsRow
stat2.BackgroundColor3 = col.surface
stat2.BackgroundTransparency = 0.15
stat2.Position = UDim2.new(0.52, 0, 0, 0)
stat2.Size = UDim2.new(0.48, 0, 1, 0)

local stat2Corner = Instance.new("UICorner")
stat2Corner.CornerRadius = UDim.new(0, 12)
stat2Corner.Parent = stat2

local stat2Title = Instance.new("TextLabel")
stat2Title.Parent = stat2
stat2Title.BackgroundTransparency = 1
stat2Title.Position = UDim2.new(0, 14, 0, 14)
stat2Title.Size = UDim2.new(1, -28, 0, 20)
stat2Title.Font = Enum.Font.Gotham
stat2Title.Text = "PING"
stat2Title.TextColor3 = col.textMuted
stat2Title.TextSize = 11
stat2Title.TextXAlignment = Enum.TextXAlignment.Left

local stat2Value = Instance.new("TextLabel")
stat2Value.Parent = stat2
stat2Value.BackgroundTransparency = 1
stat2Value.Position = UDim2.new(0, 14, 0, 38)
stat2Value.Size = UDim2.new(1, -28, 0, 24)
stat2Value.Font = Enum.Font.GothamMedium
stat2Value.Text = "0ms"
stat2Value.TextColor3 = col.text
stat2Value.TextSize = 16
stat2Value.TextXAlignment = Enum.TextXAlignment.Left

createSection(homePage, "QUICK ACTIONS")

createButton(homePage, "Reset Character", function()
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = 0
        notify("Character reset", 2)
    end
end)

createButton(homePage, "Server Rejoin", function()
    notify("Rejoining...", 2)
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- POPULATE COMBAT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local combatPage = pages["combat"]

createSection(combatPage, "AIMBOT")
createToggle(combatPage, "Auto Aim", false)
createToggle(combatPage, "Show FOV", false)
createSlider(combatPage, "FOV Size", 50, 300, 150, "px")
createSlider(combatPage, "Smoothness", 0.1, 1, 0.5, "", function() end)

createSection(combatPage, "KILLAURA")
createToggle(combatPage, "Kill Aura", false)
createToggle(combatPage, "Show Range", false)
createSlider(combatPage, "Range", 5, 30, 15, "s")

createSection(combatPage, "PROTECTION")
createToggle(combatPage, "God Mode", false)
createToggle(combatPage, "No Ragdoll", false)

-- ══════════════════════════════════════════════════════════════════════════════
-- POPULATE MOVEMENT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local movementPage = pages["movement"]

createSection(movementPage, "SPEED")
createToggle(movementPage, "Speed Hack", false)
createSlider(movementPage, "Walk Speed", 16, 200, 50, "")

createSection(movementPage, "FLIGHT")
createToggle(movementPage, "Fly", false)
createToggle(movementPage, "Noclip", false)
createSlider(movementPage, "Fly Speed", 20, 200, 80, "")

createSection(movementPage, "JUMP")
createToggle(movementPage, "Infinite Jump", false)
createToggle(movementPage, "Moon Jump", false)
createSlider(movementPage, "Jump Power", 50, 200, 50, "")

-- ══════════════════════════════════════════════════════════════════════════════
-- POPULATE VISUAL PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local visualPage = pages["visual"]

createSection(visualPage, "ESP")
createToggle(visualPage, "Enable ESP", false)
createToggle(visualPage, "Show Health", true)
createToggle(visualPage, "Show Distance", true)
createSlider(visualPage, "Max Distance", 100, 2000, 1000, "m")

createSection(visualPage, "WORLD")
createToggle(visualPage, "Fullbright", false)
createToggle(visualPage, "Remove Fog", false)
createToggle(visualPage, "X-Ray", false)

createSection(visualPage, "CHARACTER")
createToggle(visualPage, "Invisible", false)
createToggle(visualPage, "Forcefield", false)

-- ══════════════════════════════════════════════════════════════════════════════
-- POPULATE PLAYER PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local playerPage = pages["player"]

createSection(playerPage, "PLAYER LIST")

local listContainer = Instance.new("Frame")
listContainer.Parent = playerPage
listContainer.BackgroundColor3 = col.surface
listContainer.BackgroundTransparency = 0.15
listContainer.Size = UDim2.new(1, 0, 0, 120)

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 12)
listCorner.Parent = listContainer

local listScroll = Instance.new("ScrollingFrame")
listScroll.Parent = listContainer
listScroll.BackgroundTransparency = 1
listScroll.Position = UDim2.new(0, 6, 0, 6)
listScroll.Size = UDim2.new(1, -12, 1, -12)
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
listScroll.ScrollBarThickness = 3
listScroll.ScrollBarImageColor3 = col.textMuted
listScroll.ScrollBarImageTransparency = 0.7

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = listScroll
listLayout.Padding = UDim.new(0, 4)

createSection(playerPage, "ACTIONS")
createButton(playerPage, "Teleport to Selected", function() notify("Teleported", 2) end)
createButton(playerPage, "Spectate", function() notify("Spectating", 2) end)

-- ══════════════════════════════════════════════════════════════════════════════
-- POPULATE UTILITY PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local utilityPage = pages["utility"]

createSection(utilityPage, "ANTI")
createToggle(utilityPage, "Anti AFK", false)
createToggle(utilityPage, "Anti Kick", false)

createSection(utilityPage, "AUTO")
createToggle(utilityPage, "Auto Farm", false)
createToggle(utilityPage, "Auto Collect", false)

createSection(utilityPage, "MISC")
createButton(utilityPage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied", 2)
    end
end)

createButton(utilityPage, "Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- MENU ANIMATION
-- ══════════════════════════════════════════════════════════════════════════════

local menuOpen = false
local menuAnimating = false

function openMenu()
    if menuOpen or menuAnimating then return end
    menuAnimating = true
    menuOpen = true
    
    main.Visible = true
    main.BackgroundTransparency = 0.15
    main.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(blurEffect, tweenInfo.slow, {Size = 8}):Play()
    TweenService:Create(main, tweenInfo.bounce, {
        Size = UDim2.new(0, mainWidth, 0, mainHeight)
    }):Play()
    
    task.delay(0.35, function()
        menuAnimating = false
    end)
end

function closeMenu()
    if not menuOpen or menuAnimating then return end
    menuAnimating = true
    menuOpen = false
    
    TweenService:Create(blurEffect, tweenInfo.medium, {Size = 0}):Play()
    TweenService:Create(main, tweenInfo.medium, {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.delay(0.25, function()
        main.Visible = false
        menuAnimating = false
    end)
end

function toggleMenu()
    if menuOpen then closeMenu() else openMenu() end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- KEYBIND
-- ══════════════════════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- UPDATE LOOP
-- ══════════════════════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    if stat2Value then
        local ping = math.floor(plr:GetNetworkPing() * 1000)
        stat2Value.Text = ping .. "ms"
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- CLEANUP
-- ══════════════════════════════════════════════════════════════════════════════

gui.Destroying:Connect(function()
    blurEffect:Destroy()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- WELCOME NOTIFICATION
-- ══════════════════════════════════════════════════════════════════════════════

task.wait(1)
notify("Violence District V4 Premium loaded", 3)
print("╔══════════════════════════════════════════════════════════════╗")
print("║         Violence District V4 Premium - Loaded               ║")
print("║         Press RightShift to toggle menu                     ║")
print("╚══════════════════════════════════════════════════════════════╝")
