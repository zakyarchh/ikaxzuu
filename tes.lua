--- ikaxzu scripter PREMIUM
-- Violence District - Professional UI
-- Delta X Mobile Optimized

warn("Loading ikaxzu scripter PREMIUM...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera

-- Config
local cfg = {
    esp = false, espMode = 1, espRgb = false,
    speed = 16, jump = 50, noclip = false, fly = false, flyspeed = 50,
    god = false, aim = false, aimfov = 100, showfov = false,
    killaura = false, farmDivine = false, farmCelestial = false, farmInfinity = false,
    vip = false, wings = false, halo = false, invisible = false,
    fog = false, bright = false, fov = 70, antiAfk = false
}

local conn = {}
local espData = {}
local farmingItems = {}
local removedObjects = {}
local wingsModel, haloModel = nil, nil
local immortal = false

-- Parent
local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

-- Modern Colors
local theme = {
    bg = Color3.fromRGB(10, 10, 15),
    surface = Color3.fromRGB(16, 16, 22),
    card = Color3.fromRGB(20, 20, 28),
    accent = Color3.fromRGB(138, 100, 255),
    accentHover = Color3.fromRGB(158, 120, 255),
    success = Color3.fromRGB(100, 220, 150),
    danger = Color3.fromRGB(255, 100, 120),
    text = Color3.fromRGB(250, 250, 255),
    textDim = Color3.fromRGB(140, 140, 160),
    border = Color3.fromRGB(40, 40, 50)
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ikaxzuPremium"
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Notification Container
local notifContainer = Instance.new("Frame")
notifContainer.Name = "Notifications"
notifContainer.Parent = gui
notifContainer.AnchorPoint = Vector2.new(1, 0)
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -20, 0, 20)
notifContainer.Size = UDim2.new(0, 280, 1, -40)

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Notification System
local function notify(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Parent = notifContainer
    notif.BackgroundColor3 = theme.card
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.ClipsDescendants = true
    
    local nc = Instance.new("UICorner", notif)
    nc.CornerRadius = UDim.new(0, 10)
    
    local ns = Instance.new("UIStroke", notif)
    ns.Color = theme.border
    ns.Thickness = 1
    
    local grad = Instance.new("UIGradient", notif)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.card),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    }
    grad.Rotation = 90
    
    local icon = Instance.new("TextLabel", notif)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 12, 0, 8)
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Font = Enum.Font.GothamBlack
    icon.Text = "VD"
    icon.TextColor3 = theme.accent
    icon.TextSize = 12
    
    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 42, 0, 8)
    titleLabel.Size = UDim2.new(1, -52, 0, 16)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.text
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local textLabel = Instance.new("TextLabel", notif)
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 42, 0, 26)
    textLabel.Size = UDim2.new(1, -52, 0, 28)
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text
    textLabel.TextColor3 = theme.textDim
    textLabel.TextSize = 10
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local progressBar = Instance.new("Frame", notif)
    progressBar.AnchorPoint = Vector2.new(0, 1)
    progressBar.BackgroundColor3 = theme.accent
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 1, 0)
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 62)}):Play()
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(duration or 3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
    progressTween:Play()
    
    task.delay(duration or 3, function()
        TweenService:Create(notif, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.2)
        notif:Destroy()
    end)
end

-- Toggle Button (Floating)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
toggleBtn.BackgroundColor3 = theme.card
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 15, 0.5, 0)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.Text = ""
toggleBtn.Active = true
toggleBtn.Draggable = true

local toggleC = Instance.new("UICorner", toggleBtn)
toggleC.CornerRadius = UDim.new(0, 14)

local toggleS = Instance.new("UIStroke", toggleBtn)
toggleS.Color = theme.accent
toggleS.Thickness = 2
toggleS.Transparency = 0.3

local toggleGrad = Instance.new("UIGradient", toggleBtn)
toggleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.card),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
toggleGrad.Rotation = 45

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBlack
toggleIcon.Text = "VD"
toggleIcon.TextColor3 = theme.accent
toggleIcon.TextSize = 18

-- Pulse Animation
local function pulseButton()
    while task.wait(2) do
        if not toggleBtn.Parent then break end
        TweenService:Create(toggleIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextSize = 20}):Play()
        task.wait(0.5)
        TweenService:Create(toggleIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextSize = 18}):Play()
    end
end
task.spawn(pulseButton)

-- Main Frame (Professional 16:9)
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = theme.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true

local mainC = Instance.new("UICorner", main)
mainC.CornerRadius = UDim.new(0, 16)

local mainS = Instance.new("UIStroke", main)
mainS.Color = theme.border
mainS.Thickness = 1

-- Drop Shadow Effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = main
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(100, 100, 100, 100)

-- Animated Background
local bgEffect = Instance.new("Frame", main)
bgEffect.Name = "BGEffect"
bgEffect.BackgroundColor3 = theme.accent
bgEffect.BackgroundTransparency = 0.95
bgEffect.BorderSizePixel = 0
bgEffect.Size = UDim2.new(1, 0, 1, 0)
bgEffect.ZIndex = 0

local bgC = Instance.new("UICorner", bgEffect)
bgC.CornerRadius = UDim.new(0, 16)

local bgGrad = Instance.new("UIGradient", bgEffect)
bgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.accent),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 60, 200))
}
bgGrad.Rotation = 45

task.spawn(function()
    while task.wait(0.05) do
        if not bgGrad.Parent then break end
        bgGrad.Rotation = (bgGrad.Rotation + 1) % 360
    end
end)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = main
header.BackgroundColor3 = theme.surface
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 50)
header.ZIndex = 1

local headerC = Instance.new("UICorner", header)
headerC.CornerRadius = UDim.new(0, 16)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = theme.surface
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.Size = UDim2.new(1, 0, 0, 16)

local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.surface),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 32))
}
headerGrad.Rotation = 90

-- Logo Container
local logoContainer = Instance.new("Frame", header)
logoContainer.BackgroundColor3 = theme.accent
logoContainer.BorderSizePixel = 0
logoContainer.Position = UDim2.new(0, 14, 0.5, 0)
logoContainer.AnchorPoint = Vector2.new(0, 0.5)
logoContainer.Size = UDim2.new(0, 36, 0, 36)

local logoC = Instance.new("UICorner", logoContainer)
logoC.CornerRadius = UDim.new(0, 10)

local logoGrad = Instance.new("UIGradient", logoContainer)
logoGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.accent),
    ColorSequenceKeypoint.new(1, theme.accentHover)
}
logoGrad.Rotation = 45

local logo = Instance.new("TextLabel", logoContainer)
logo.BackgroundTransparency = 1
logo.Size = UDim2.new(1, 0, 1, 0)
logo.Font = Enum.Font.GothamBlack
logo.Text = "VD"
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.TextSize = 16

-- Title
local titleContainer = Instance.new("Frame", header)
titleContainer.BackgroundTransparency = 1
titleContainer.Position = UDim2.new(0, 58, 0, 8)
titleContainer.Size = UDim2.new(0, 200, 0, 34)

local title = Instance.new("TextLabel", titleContainer)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 18)
title.Font = Enum.Font.GothamBlack
title.Text = "ikaxzu scripter"
title.TextColor3 = theme.text
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", titleContainer)
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 0, 0, 18)
subtitle.Size = UDim2.new(1, 0, 0, 14)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Violence District Premium"
subtitle.TextColor3 = theme.textDim
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Status Indicator
local statusDot = Instance.new("Frame", header)
statusDot.BackgroundColor3 = theme.success
statusDot.BorderSizePixel = 0
statusDot.Position = UDim2.new(1, -120, 0.5, 0)
statusDot.AnchorPoint = Vector2.new(0, 0.5)
statusDot.Size = UDim2.new(0, 6, 0, 6)

local dotC = Instance.new("UICorner", statusDot)
dotC.CornerRadius = UDim.new(1, 0)

local statusText = Instance.new("TextLabel", header)
statusText.BackgroundTransparency = 1
statusText.Position = UDim2.new(1, -108, 0.5, 0)
statusText.AnchorPoint = Vector2.new(0, 0.5)
statusText.Size = UDim2.new(0, 60, 0, 20)
statusText.Font = Enum.Font.GothamBold
statusText.Text = "ACTIVE"
statusText.TextColor3 = theme.success
statusText.TextSize = 9
statusText.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize & Close Buttons
local minBtn = Instance.new("TextButton")
minBtn.Name = "Min"
minBtn.Parent = header
minBtn.AnchorPoint = Vector2.new(1, 0.5)
minBtn.BackgroundColor3 = theme.card
minBtn.BorderSizePixel = 0
minBtn.Position = UDim2.new(1, -44, 0.5, 0)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "—"
minBtn.TextColor3 = theme.textDim
minBtn.TextSize = 14
minBtn.AutoButtonColor = false

local minC = Instance.new("UICorner", minBtn)
minC.CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Parent = header
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.BackgroundColor3 = theme.card
closeBtn.BorderSizePixel = 0
closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = theme.danger
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false

local closeC = Instance.new("UICorner", closeBtn)
closeC.CornerRadius = UDim.new(0, 8)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.surface}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.card}):Play()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 25, 28)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.card}):Play()
end)

-- Sidebar Navigation
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Parent = main
sidebar.BackgroundColor3 = theme.surface
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.Size = UDim2.new(0, 100, 1, -50)
sidebar.ZIndex = 1

local sidebarC = Instance.new("UICorner", sidebar)
sidebarC.CornerRadius = UDim.new(0, 16)

local sidebarFixTop = Instance.new("Frame", sidebar)
sidebarFixTop.BackgroundColor3 = theme.surface
sidebarFixTop.BorderSizePixel = 0
sidebarFixTop.Size = UDim2.new(1, 0, 0, 16)

local sidebarFixRight = Instance.new("Frame", sidebar)
sidebarFixRight.BackgroundColor3 = theme.surface
sidebarFixRight.BorderSizePixel = 0
sidebarFixRight.Position = UDim2.new(1, -16, 0, 0)
sidebarFixRight.Size = UDim2.new(0, 16, 1, 0)

local sidebarGrad = Instance.new("UIGradient", sidebar)
sidebarGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.surface),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 25))
}
sidebarGrad.Rotation = 90

local tabList = Instance.new("Frame", sidebar)
tabList.BackgroundTransparency = 1
tabList.Position = UDim2.new(0, 0, 0, 10)
tabList.Size = UDim2.new(1, 0, 1, -10)

local tabLayout = Instance.new("UIListLayout", tabList)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 4)

local tabPadding = Instance.new("UIPadding", tabList)
tabPadding.PaddingLeft = UDim.new(0, 8)
tabPadding.PaddingRight = UDim.new(0, 8)

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Name = "Content"
contentArea.Parent = main
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0, 110, 0, 60)
contentArea.Size = UDim2.new(1, -120, 1, -70)
contentArea.ZIndex = 1

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Color = theme.accent
fovCircle.Transparency = 0.8
fovCircle.NumSides = 64
fovCircle.Filled = false

-- Tab System
local activeTab = nil
local pages = {}

local tabIcons = {
    Combat = "⚔",
    Move = "➤",
    Visual = "◆",
    ESP = "●",
    Farm = "◉",
    Misc = "⚙"
}

local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Parent = tabList
    tabBtn.BackgroundColor3 = theme.card
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(1, 0, 0, 42)
    tabBtn.AutoButtonColor = false
    tabBtn.Text = ""
    
    local tabC = Instance.new("UICorner", tabBtn)
    tabC.CornerRadius = UDim.new(0, 10)
    
    local indicator = Instance.new("Frame", tabBtn)
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.Size = UDim2.new(0, 3, 0.7, 0)
    indicator.Visible = false
    
    local indC = Instance.new("UICorner", indicator)
    indC.CornerRadius = UDim.new(0, 2)
    
    local iconLabel = Instance.new("TextLabel", tabBtn)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.Size = UDim2.new(0, 24, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = tabIcons[name] or "●"
    iconLabel.TextColor3 = theme.textDim
    iconLabel.TextSize = 14
    
    local nameLabel = Instance.new("TextLabel", tabBtn)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 38, 0, 0)
    nameLabel.Size = UDim2.new(1, -38, 1, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = name
    nameLabel.TextColor3 = theme.textDim
    nameLabel.TextSize = 11
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = contentArea
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = theme.accent
    page.ScrollBarImageTransparency = 0.5
    page.Visible = false
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    
    local pagePadding = Instance.new("UIPadding", page)
    pagePadding.PaddingRight = UDim.new(0, 6)
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
    end)
    
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundTransparency = 1
                btn:FindFirstChild("Indicator").Visible = false
                for _, child in pairs(btn:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child.TextColor3 = theme.textDim
                    end
                end
            end
        end
        for _, pg in pairs(pages) do
            pg.Visible = false
        end
        
        tabBtn.BackgroundTransparency = 0
        indicator.Visible = true
        iconLabel.TextColor3 = theme.accent
        nameLabel.TextColor3 = theme.text
        page.Visible = true
        activeTab = name
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if activeTab ~= name then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if activeTab ~= name then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end)
    
    if not activeTab then
        tabBtn.BackgroundTransparency = 0
        indicator.Visible = true
        iconLabel.TextColor3 = theme.accent
        nameLabel.TextColor3 = theme.text
        page.Visible = true
        activeTab = name
    end
    
    return page
end

-- UI Components
local function section(parent, text)
    local sec = Instance.new("Frame")
    sec.Parent = parent
    sec.BackgroundColor3 = theme.card
    sec.BorderSizePixel = 0
    sec.Size = UDim2.new(1, 0, 0, 26)
    
    local secC = Instance.new("UICorner", sec)
    secC.CornerRadius = UDim.new(0, 8)
    
    local line = Instance.new("Frame", sec)
    line.BackgroundColor3 = theme.accent
    line.BorderSizePixel = 0
    line.Size = UDim2.new(0, 3, 1, 0)
    
    local lineC = Instance.new("UICorner", line)
    lineC.CornerRadius = UDim.new(0, 2)
    
    local label = Instance.new("TextLabel", sec)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = theme.accent
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
end

local function toggle(parent, text, callback)
    local state = false
    
    local frame = Instance.new("TextButton")
    frame.Parent = parent
    frame.BackgroundColor3 = theme.card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.AutoButtonColor = false
    frame.Text = ""
    
    local frameC = Instance.new("UICorner", frame)
    frameC.CornerRadius = UDim.new(0, 8)
    
    local frameS = Instance.new("UIStroke", frame)
    frameS.Color = theme.border
    frameS.Thickness = 1
    frameS.Transparency = 0.5
    
    local txt = Instance.new("TextLabel", frame)
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 12, 0, 0)
    txt.Size = UDim2.new(1, -55, 1, 0)
    txt.Font = Enum.Font.GothamBold
    txt.Text = text
    txt.TextColor3 = theme.textDim
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local switch = Instance.new("Frame", frame)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -10, 0.5, 0)
    switch.Size = UDim2.new(0, 36, 0, 18)
    
    local switchC = Instance.new("UICorner", switch)
    switchC.CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", switch)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = theme.textDim
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0, 2, 0.5, 0)
    dot.Size = UDim2.new(0, 14, 0, 14)
    
    local dotC = Instance.new("UICorner", dot)
    dotC.CornerRadius = UDim.new(1, 0)
    
    frame.MouseButton1Click:Connect(function()
        state = not state
        
        if state then
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = theme.text}):Play()
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = theme.success}):Play()
            TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = theme.text}):Play()
            TweenService:Create(frameS, TweenInfo.new(0.2), {Color = theme.success, Transparency = 0}):Play()
        else
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = theme.textDim}):Play()
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = theme.textDim}):Play()
            TweenService:Create(frameS, TweenInfo.new(0.2), {Color = theme.border, Transparency = 0.5}):Play()
        end
        
        pcall(callback, state)
    end)
    
    frame.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
    end)
    
    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = theme.card}):Play()
    end)
end

local function slider(parent, text, min, max, def, callback)
    local val = def
    local dragging = false
    
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = theme.card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 50)
    
    local frameC = Instance.new("UICorner", frame)
    frameC.CornerRadius = UDim.new(0, 8)
    
    local frameS = Instance.new("UIStroke", frame)
    frameS.Color = theme.border
    frameS.Thickness = 1
    frameS.Transparency = 0.5
    
    local txt = Instance.new("TextLabel", frame)
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 12, 0, 6)
    txt.Size = UDim2.new(0.6, 0, 0, 16)
    txt.Font = Enum.Font.GothamBold
    txt.Text = text
    txt.TextColor3 = theme.text
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local value = Instance.new("TextLabel", frame)
    value.BackgroundColor3 = theme.accent
    value.BorderSizePixel = 0
    value.Position = UDim2.new(1, -52, 0, 6)
    value.Size = UDim2.new(0, 40, 0, 16)
    value.Font = Enum.Font.GothamBlack
    value.Text = tostring(def)
    value.TextColor3 = theme.text
    value.TextSize = 10
    
    local valueC = Instance.new("UICorner", value)
    valueC.CornerRadius = UDim.new(0, 6)
    
    local track = Instance.new("Frame", frame)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 12, 0, 30)
    track.Size = UDim2.new(1, -24, 0, 10)
    
    local trackC = Instance.new("UICorner", track)
    trackC.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = theme.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    
    local fillC = Instance.new("UICorner", fill)
    fillC.CornerRadius = UDim.new(1, 0)
    
    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.accent),
        ColorSequenceKeypoint.new(1, theme.accentHover)
    }
    
    local btn = Instance.new("TextButton", track)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    
    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pos)
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        value.Text = tostring(val)
        pcall(callback, val)
    end
    
    btn.MouseButton1Down:Connect(function() dragging = true end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            update(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function button(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = theme.accent
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBlack
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = 11
    
    local btnC = Instance.new("UICorner", btn)
    btnC.CornerRadius = UDim.new(0, 8)
    
    local btnGrad = Instance.new("UIGradient", btn)
    btnGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.accent),
        ColorSequenceKeypoint.new(1, theme.accentHover)
    }
    btnGrad.Rotation = 45
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = theme.accentHover}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = theme.accent}):Play()
        pcall(callback)
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 38)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    end)
end

-- GOD MODE
local function enableGod()
    if immortal then return end
    immortal = true
    
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    hum.Name = "RealHumanoid"
    hum.BreakJointsOnDeath = false
    
    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function() hum:SetStateEnabled(state, false) end)
    end
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    
    local barrier = Instance.new("Part")
    barrier.Name = "Shield"
    barrier.Parent = char
    barrier.Size = Vector3.new(8, 8, 8)
    barrier.Shape = Enum.PartType.Ball
    barrier.Transparency = 0.95
    barrier.Material = Enum.Material.ForceField
    barrier.Color = theme.accent
    barrier.CanCollide = false
    barrier.Anchored = false
    barrier.Massless = true
    
    local weld = Instance.new("WeldConstraint", barrier)
    weld.Part0 = hrp
    weld.Part1 = barrier
    
    conn.godHealth = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
    end)
    
    conn.godClean = RunService.Heartbeat:Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
        for _, v in pairs(hum:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("StringValue") then v:Destroy() end
        end
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    
    conn.godPart = RunService.Stepped:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:match("kill") or n:match("death") or n:match("lava") or n:match("trap") or n:match("spike") then
                    pcall(function() obj.CanTouch = false; obj.CanCollide = false end)
                end
            end
        end
    end)
    
    local lastPos = hrp.CFrame
    conn.godVoid = RunService.Heartbeat:Connect(function()
        if hrp.Position.Y > -50 then lastPos = hrp.CFrame end
        if hrp.Position.Y < -100 then hrp.CFrame = lastPos end
    end)
    
    conn.godTouch = barrier.Touched:Connect(function(hit)
        if hit and hit.Parent and not hit.Parent:FindFirstChild("Humanoid") then
            pcall(function() hit.CanTouch = false end)
        end
    end)
    
    notify("God Mode", "Immortality activated", 2)
end

local function disableGod()
    if not immortal then return end
    immortal = false
    
    for name, c in pairs(conn) do
        if c then pcall(function() c:Disconnect() end) end
        conn[name] = nil
    end
    
    local hum = char:FindFirstChild("RealHumanoid")
    if hum then hum.Name = "Humanoid"; hum.Health = 100; hum.MaxHealth = 100 end
    
    local shield = char:FindFirstChild("Shield")
    if shield then shield:Destroy() end
    
    notify("God Mode", "Immortality deactivated", 2)
end

-- AUTO FARM RARITY (Same as before)
local function isRareItem(obj)
    local n = obj.Name:lower()
    if n:match("divine") then return "Divine" end
    if n:match("celestial") then return "Celestial" end
    if n:match("infinity") or n:match("infinite") then return "Infinity" end
    
    for _, attr in pairs(obj:GetAttributes()) do
        local a = tostring(attr):lower()
        if a:match("divine") then return "Divine" end
        if a:match("celestial") then return "Celestial" end
        if a:match("infinity") then return "Infinity" end
    end
    
    for _, child in pairs(obj:GetChildren()) do
        if child:IsA("StringValue") then
            local v = tostring(child.Value):lower()
            if v:match("divine") then return "Divine" end
            if v:match("celestial") then return "Celestial" end
            if v:match("infinity") then return "Infinity" end
        end
    end
    
    return nil
end

local function farmItem(item)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not item or not item.Parent then return end
    
    pcall(function()
        local pos = item:IsA("Model") and item:GetPrimaryPartCFrame().Position or item.Position
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        task.wait(0.1)
        
        if item:FindFirstChild("ClickDetector") then fireclickdetector(item.ClickDetector) end
        if item:FindFirstChild("ProximityPrompt") then fireproximityprompt(item.ProximityPrompt) end
        
        hrp.CFrame = item:IsA("Model") and item:GetPrimaryPartCFrame() or item.CFrame
        
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local rn = v.Name:lower()
                if rn:match("collect") or rn:match("pickup") or rn:match("take") then
                    v:FireServer(item)
                end
            end
        end
        
        notify("Farm", "Collected: " .. item.Name, 2)
    end)
end

local function startFarm()
    conn.farm = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local rarity = isRareItem(obj)
                if rarity then
                    local shouldFarm = false
                    if rarity == "Divine" and cfg.farmDivine then shouldFarm = true end
                    if rarity == "Celestial" and cfg.farmCelestial then shouldFarm = true end
                    if rarity == "Infinity" and cfg.farmInfinity then shouldFarm = true end
                    
                    if shouldFarm and not farmingItems[obj] then
                        farmingItems[obj] = true
                        task.spawn(function()
                            farmItem(obj)
                            task.wait(1)
                            farmingItems[obj] = nil
                        end)
                    end
                end
            end
        end
    end)
end

local function stopFarm()
    if conn.farm then conn.farm:Disconnect(); conn.farm = nil end
    farmingItems = {}
end

-- VIP REMOVER
local function enableVIP()
    conn.vip = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:match("vip") or n:match("premium") or n:match("gamepass") or n:match("robux") then
                    if not removedObjects[obj] then
                        pcall(function()
                            if obj:IsA("BasePart") then
                                obj.Transparency = 1
                                obj.CanCollide = false
                                obj.CanTouch = false
                            else
                                for _, p in pairs(obj:GetDescendants()) do
                                    if p:IsA("BasePart") then
                                        p.Transparency = 1
                                        p.CanCollide = false
                                        p.CanTouch = false
                                    end
                                end
                            end
                            removedObjects[obj] = true
                        end)
                    end
                end
            end
        end
    end)
    notify("VIP Remover", "All VIP objects removed", 2)
end

local function disableVIP()
    if conn.vip then conn.vip:Disconnect(); conn.vip = nil end
    removedObjects = {}
end

-- WINGS & HALO
local function createWings()
    if wingsModel then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    wingsModel = Instance.new("Model", char)
    wingsModel.Name = "Wings"
    
    for i = 1, 2 do
        local wing = Instance.new("Part", wingsModel)
        wing.Size = Vector3.new(0.2, 4, 2)
        wing.Material = Enum.Material.Neon
        wing.Color = theme.accent
        wing.Transparency = 0.3
        wing.CanCollide = false
        wing.Massless = true
        
        local mesh = Instance.new("SpecialMesh", wing)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://2520762076"
        mesh.Scale = Vector3.new(1.5, 1.5, 1.5)
        
        local weld = Instance.new("Weld", wing)
        weld.Part0 = hrp
        weld.Part1 = wing
        weld.C0 = CFrame.new(i == 1 and -1 or 1, 0.5, -0.5) * CFrame.Angles(0, math.rad(i == 1 and 15 or -15), 0)
    end
    
    conn.wings = RunService.RenderStepped:Connect(function()
        local wave = math.sin(tick() * 3) * 0.2
        for i, wing in pairs(wingsModel:GetChildren()) do
            local weld = wing:FindFirstChildOfClass("Weld")
            if weld then
                local dir = i == 1 and 1 or -1
                weld.C0 = CFrame.new(dir * -1, 0.5, -0.5) * CFrame.Angles(0, math.rad(dir * (15 + wave * 10)), wave * 0.5 * dir)
            end
        end
    end)
    
    notify("Wings", "Angel wings equipped", 2)
end

local function removeWings()
    if wingsModel then wingsModel:Destroy(); wingsModel = nil end
    if conn.wings then conn.wings:Disconnect(); conn.wings = nil end
end

local function createHalo()
    if haloModel then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    haloModel = Instance.new("Part", char)
    haloModel.Name = "Halo"
    haloModel.Size = Vector3.new(2, 0.2, 2)
    haloModel.Shape = Enum.PartType.Cylinder
    haloModel.Material = Enum.Material.Neon
    haloModel.Color = theme.accent
    haloModel.Transparency = 0.2
    haloModel.CanCollide = false
    haloModel.Massless = true
    
    local light = Instance.new("PointLight", haloModel)
    light.Brightness = 2
    light.Color = theme.accent
    light.Range = 10
    
    local weld = Instance.new("Weld", haloModel)
    weld.Part0 = head
    weld.Part1 = haloModel
    weld.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, math.rad(90))
    
    conn.halo = RunService.RenderStepped:Connect(function()
        weld.C0 = weld.C0 * CFrame.Angles(0, math.rad(2), 0)
    end)
    
    notify("Halo", "Angel halo equipped", 2)
end

local function removeHalo()
    if haloModel then haloModel:Destroy(); haloModel = nil end
    if conn.halo then conn.halo:Disconnect(); conn.halo = nil end
end

-- ESP
local function clearESP()
    for _, data in pairs(espData) do
        if data.obj then data.obj:Destroy() end
    end
    espData = {}
end

local function createESP(player)
    if espData[player] or not player.Character then return end
    local c = player.Character
    local h = c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    
    if cfg.espMode == 1 then
        local b = Instance.new("BillboardGui", h)
        b.AlwaysOnTop = true
        b.Size = UDim2.new(0, 90, 0, 36)
        b.StudsOffset = Vector3.new(0, 2.5, 0)
        
        local f = Instance.new("Frame", b)
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = theme.card
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        
        local fC = Instance.new("UICorner", f)
        fC.CornerRadius = UDim.new(0, 6)
        
        local fS = Instance.new("UIStroke", f)
        fS.Color = theme.accent
        fS.Thickness = 1
        
        local n = Instance.new("TextLabel", f)
        n.Size = UDim2.new(1, 0, 0.5, 0)
        n.BackgroundTransparency = 1
        n.Font = Enum.Font.GothamBold
        n.Text = player.Name
        n.TextColor3 = theme.text
        n.TextSize = 11
        n.TextScaled = true
        
        local d = Instance.new("TextLabel", f)
        d.Position = UDim2.new(0, 0, 0.5, 0)
        d.Size = UDim2.new(1, 0, 0.5, 0)
        d.BackgroundTransparency = 1
        d.Font = Enum.Font.Gotham
        d.TextColor3 = theme.textDim
        d.TextSize = 10
        d.TextScaled = true
        
        espData[player] = {obj = b, dist = d, frame = f, stroke = fS}
        
    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", h)
        box.Size = c:GetExtentsSize()
        box.Adornee = h
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = theme.accent
        box.Transparency = 0.5
        
        espData[player] = {obj = box}
        
    elseif cfg.espMode == 3 then
        local hl = Instance.new("Highlight", c)
        hl.FillColor = theme.accent
        hl.OutlineColor = theme.text
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        
        espData[player] = {obj = hl}
    end
end

local function updateESP()
    for player, data in pairs(espData) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            
            if data.dist then data.dist.Text = math.floor(dist) .. "m" end
            
            if cfg.espRgb then
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                if data.stroke then data.stroke.Color = color end
                if data.obj and data.obj:IsA("BoxHandleAdornment") then data.obj.Color3 = color end
                if data.obj and data.obj:IsA("Highlight") then data.obj.FillColor = color; data.obj.OutlineColor = color end
            end
        end
    end
end

-- AIM
local function getClosestInFOV()
    local closest = nil
    local minDist = cfg.aimfov
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < minDist then
                    closest = p
                    minDist = dist
                end
            end
        end
    end
    return closest
end

-- ANTI AFK
local function enableAntiAfk()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    notify("Anti AFK", "Protection enabled", 2)
end

-- CREATE TABS
local combatPage = createTab("Combat")
local movePage = createTab("Move")
local visualPage = createTab("Visual")
local espPage = createTab("ESP")
local farmPage = createTab("Farm")
local miscPage = createTab("Misc")

-- COMBAT TAB
section(combatPage, "PROTECTION")
toggle(combatPage, "God Mode", function(v)
    cfg.god = v
    if v then enableGod() else disableGod() end
end)

section(combatPage, "AIMBOT")
toggle(combatPage, "Auto Aim", function(v)
    cfg.aim = v
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if conn.aim then conn.aim:Disconnect() end
    end
end)

toggle(combatPage, "Show FOV Circle", function(v)
    cfg.showfov = v
    fovCircle.Visible = v
end)

slider(combatPage, "FOV Size", 50, 500, 100, function(v)
    cfg.aimfov = v
end)

toggle(combatPage, "Kill Aura", function(v)
    cfg.killaura = v
    if v then
        conn.aura = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < 15 then
                        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                            if v:IsA("RemoteEvent") and v.Name:lower():match("attack") then
                                v:FireServer(p.Character)
                            end
                        end
                    end
                end
            end
        end)
    else
        if conn.aura then conn.aura:Disconnect() end
    end
end)

-- MOVEMENT TAB
section(movePage, "SPEED CONTROL")
slider(movePage, "Walk Speed", 16, 500, 16, function(v) cfg.speed = v end)
slider(movePage, "Jump Power", 50, 500, 50, function(v) cfg.jump = v end)

section(movePage, "MOVEMENT MODES")
toggle(movePage, "Noclip", function(v)
    cfg.noclip = v
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        if conn.noclip then conn.noclip:Disconnect() end
    end
end)

toggle(movePage, "Fly Mode", function(v)
    cfg.fly = v
    if v then
        local hrp = char.HumanoidRootPart
        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        conn.fly = RunService.RenderStepped:Connect(function()
            bg.CFrame = cam.CFrame
            local vel = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, cfg.flyspeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, cfg.flyspeed, 0) end
            bv.Velocity = vel
        end)
    else
        if conn.fly then conn.fly:Disconnect() end
        for _, v in pairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end)

slider(movePage, "Fly Speed", 10, 200, 50, function(v) cfg.flyspeed = v end)

-- VISUAL TAB
section(visualPage, "ENVIRONMENT")
toggle(visualPage, "No Fog", function(v)
    cfg.fog = v
    Lighting.FogEnd = v and 100000 or 1000
end)

toggle(visualPage, "Full Bright", function(v)
    cfg.bright = v
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

slider(visualPage, "Field of View", 70, 120, 70, function(v)
    cfg.fov = v
    cam.FieldOfView = v
end)

section(visualPage, "CHARACTER")
toggle(visualPage, "Angel Wings", function(v)
    cfg.wings = v
    if v then createWings() else removeWings() end
end)

toggle(visualPage, "Angel Halo", function(v)
    cfg.halo = v
    if v then createHalo() else removeHalo() end
end)

toggle(visualPage, "Invisible", function(v)
    cfg.invisible = v
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = v and 1 or 0
        end
    end
end)

-- ESP TAB
section(espPage, "PLAYER ESP")
toggle(espPage, "Enable ESP", function(v)
    cfg.esp = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    else
        clearESP()
    end
end)

toggle(espPage, "RGB Mode", function(v) cfg.espRgb = v end)

section(espPage, "ESP MODES")
button(espPage, "Mode: Simple", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

button(espPage, "Mode: Box", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

button(espPage, "Mode: Highlight", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

-- FARM TAB
section(farmPage, "AUTO FARM RARITY")
toggle(farmPage, "Farm Divine", function(v)
    cfg.farmDivine = v
    if cfg.farmDivine or cfg.farmCelestial or cfg.farmInfinity then
        startFarm()
    else
        stopFarm()
    end
end)

toggle(farmPage, "Farm Celestial", function(v)
    cfg.farmCelestial = v
    if cfg.farmDivine or cfg.farmCelestial or cfg.farmInfinity then
        startFarm()
    else
        stopFarm()
    end
end)

toggle(farmPage, "Farm Infinity", function(v)
    cfg.farmInfinity = v
    if cfg.farmDivine or cfg.farmCelestial or cfg.farmInfinity then
        startFarm()
    else
        stopFarm()
    end
end)

section(farmPage, "ikaxzu VIP")
toggle(farmPage, "VIP Object Remover", function(v)
    cfg.vip = v
    if v then enableVIP() else disableVIP() end
end)

section(farmPage, "TELEPORT")
button(farmPage, "Teleport to Closest", function()
    local target = getClosestInFOV()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        notify("Teleport", "Teleported to " .. target.Name, 2)
    end
end)

button(farmPage, "Teleport to Random", function()
    local ps = Players:GetPlayers()
    if #ps > 1 then
        local rnd = ps[math.random(1, #ps)]
        if rnd ~= plr and rnd.Character and rnd.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = rnd.Character.HumanoidRootPart.CFrame
            notify("Teleport", "Teleported to " .. rnd.Name, 2)
        end
    end
end)

-- MISC TAB
section(miscPage, "SAFETY")
toggle(miscPage, "Anti AFK", function(v)
    cfg.antiAfk = v
    if v then enableAntiAfk() end
end)

section(miscPage, "SERVER UTILITIES")
button(miscPage, "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

button(miscPage, "Copy Game ID", function()
    setclipboard(tostring(game.PlaceId))
    notify("Clipboard", "Game ID copied!", 2)
end)

section(miscPage, "ABOUT")
local creditFrame = Instance.new("Frame")
creditFrame.Parent = miscPage
creditFrame.BackgroundColor3 = theme.card
creditFrame.BorderSizePixel = 0
creditFrame.Size = UDim2.new(1, 0, 0, 60)

local creditC = Instance.new("UICorner", creditFrame)
creditC.CornerRadius = UDim.new(0, 8)

local creditGrad = Instance.new("UIGradient", creditFrame)
creditGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.card),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
creditGrad.Rotation = 45

local creditText = Instance.new("TextLabel", creditFrame)
creditText.BackgroundTransparency = 1
creditText.Size = UDim2.new(1, 0, 1, 0)
creditText.Font = Enum.Font.Gotham
creditText.Text = "ikaxzu scripter PREMIUM\nMade for Violence District\nDelta X Mobile Edition"
creditText.TextColor3 = theme.textDim
creditText.TextSize = 10

-- EVENTS
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 340)}):Play()
        notify("Welcome", "ikaxzu scripter loaded!", 2)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    main.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    main.Visible = false
end)

RunService.RenderStepped:Connect(function()
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = cfg.speed
        char.Humanoid.JumpPower = cfg.jump
    end
    
    if cfg.showfov then
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = cfg.aimfov
    end
    
    if cfg.esp then updateESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESP(p) end
    end)
end)

plr.CharacterAdded:Connect(function(c)
    char = c
    task.wait(1)
    
    if cfg.god then enableGod() end
    if cfg.noclip then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
    if cfg.wings then createWings() end
    if cfg.halo then createHalo() end
    if cfg.vip then enableVIP() end
end)

-- Load Notification
task.wait(0.5)
notify("ikaxzu scripter", "Successfully loaded!", 3)

warn("ikaxzu scripter PREMIUM loaded!")
warn("UI: 16:9 Professional | 600x340")
warn("All features ready!")
