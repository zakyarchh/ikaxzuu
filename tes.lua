-- ikaxzu scripter v3
-- Violence District Ultimate
-- Delta X Mobile

warn("ikaxzu scripter v3 loading...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera

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
local originalFarmPos = nil

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

-- muted dark palette
local col = {
    bg = Color3.fromRGB(12, 12, 14),
    surface = Color3.fromRGB(18, 18, 21),
    card = Color3.fromRGB(22, 22, 26),
    cardHover = Color3.fromRGB(28, 28, 33),
    elevated = Color3.fromRGB(32, 32, 38),
    border = Color3.fromRGB(38, 38, 44),
    borderLight = Color3.fromRGB(48, 48, 55),
    
    text = Color3.fromRGB(220, 220, 225),
    textMuted = Color3.fromRGB(140, 140, 150),
    textDim = Color3.fromRGB(85, 85, 95),
    
    accent = Color3.fromRGB(90, 90, 100),
    accentHover = Color3.fromRGB(110, 110, 120),
    
    on = Color3.fromRGB(75, 180, 95),
    onDim = Color3.fromRGB(45, 120, 60),
    off = Color3.fromRGB(55, 55, 62),
    
    danger = Color3.fromRGB(180, 65, 70),
    warn = Color3.fromRGB(180, 140, 55)
}

local gui = Instance.new("ScreenGui")
gui.Name = "ixv3_" .. tostring(math.random(1000,9999))
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 8, 0.5, -22)
toggleBtn.Size = UDim2.new(0, 44, 0, 44)
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Draggable = true

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = col.border
toggleStroke.Thickness = 1

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Text = "☰"
toggleIcon.TextColor3 = col.textMuted
toggleIcon.TextSize = 18

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = col.borderLight}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.2), {TextColor3 = col.text}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = col.border}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.2), {TextColor3 = col.textMuted}):Play()
end)

-- main panel
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = col.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 520, 0, 320)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = col.border
mainStroke.Thickness = 1

-- header
local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = col.surface
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 40)

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 8)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = col.surface
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -8)
headerFix.Size = UDim2.new(1, 0, 0, 8)

local headerLine = Instance.new("Frame", header)
headerLine.BackgroundColor3 = col.border
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)

local titleLabel = Instance.new("TextLabel", header)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "ikaxzu"
titleLabel.TextColor3 = col.text
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local versionLabel = Instance.new("TextLabel", header)
versionLabel.BackgroundTransparency = 1
versionLabel.Position = UDim2.new(0, 68, 0, 0)
versionLabel.Size = UDim2.new(0, 40, 1, 0)
versionLabel.Font = Enum.Font.Gotham
versionLabel.Text = "v3"
versionLabel.TextColor3 = col.textDim
versionLabel.TextSize = 11
versionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- close btn
local closeBtn = Instance.new("TextButton", header)
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = col.textDim
closeBtn.TextSize = 20
closeBtn.AutoButtonColor = false

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = col.danger}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = col.textDim}):Play()
end)

-- minimize btn
local minBtn = Instance.new("TextButton", header)
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -60, 0, 8)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = col.textDim
minBtn.TextSize = 18
minBtn.AutoButtonColor = false

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), {TextColor3 = col.warn}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), {TextColor3 = col.textDim}):Play()
end)

-- sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = col.surface
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.Size = UDim2.new(0, 110, 1, -40)

local sidebarLine = Instance.new("Frame", sidebar)
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)

local tabList = Instance.new("Frame", sidebar)
tabList.BackgroundTransparency = 1
tabList.Position = UDim2.new(0, 6, 0, 8)
tabList.Size = UDim2.new(1, -12, 1, -16)

local tabListLayout = Instance.new("UIListLayout", tabList)
tabListLayout.Padding = UDim.new(0, 2)

-- content area
local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 118, 0, 48)
content.Size = UDim2.new(1, -126, 1, -56)

-- notif container
local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifs"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -260, 0, 10)
notifContainer.Size = UDim2.new(0, 250, 0, 300)

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 4)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(msg, duration)
    local notif = Instance.new("Frame", notifContainer)
    notif.BackgroundColor3 = col.surface
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 0, 0, 32)
    notif.ClipsDescendants = true

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    
    local nStroke = Instance.new("UIStroke", notif)
    nStroke.Color = col.border
    nStroke.Thickness = 1

    local nText = Instance.new("TextLabel", notif)
    nText.BackgroundTransparency = 1
    nText.Position = UDim2.new(0, 10, 0, 0)
    nText.Size = UDim2.new(1, -20, 1, 0)
    nText.Font = Enum.Font.Gotham
    nText.Text = msg
    nText.TextColor3 = col.textMuted
    nText.TextSize = 11
    nText.TextXAlignment = Enum.TextXAlignment.Left
    nText.TextTransparency = 1

    TweenService:Create(notif, TweenInfo.new(0.25), {Size = UDim2.new(0, 240, 0, 32)}):Play()
    task.delay(0.1, function()
        TweenService:Create(nText, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    end)

    task.delay(duration or 2.5, function()
        TweenService:Create(nText, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        task.wait(0.15)
        TweenService:Create(notif, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 32)}):Play()
        task.wait(0.2)
        notif:Destroy()
    end)
end

-- fov circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = col.textDim
fovCircle.Transparency = 0.6
fovCircle.NumSides = 48
fovCircle.Filled = false

-- tab system
local pages = {}
local tabButtons = {}
local activeTab = nil

local tabs = {
    {id = "home", name = "Home"},
    {id = "combat", name = "Combat"},
    {id = "movement", name = "Movement"},
    {id = "visual", name = "Visual"},
    {id = "esp", name = "ESP"},
    {id = "farm", name = "Farm"}
}

local function createPage(id)
    local page = Instance.new("ScrollingFrame")
    page.Name = id
    page.Parent = content
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = col.border
    page.ScrollBarImageTransparency = 0.3
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 4)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)

    pages[id] = page
    return page
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabList
    btn.BackgroundColor3 = col.card
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. tab.name
    btn.TextColor3 = col.textDim
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = col.text
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.5, -6)
    indicator.Size = UDim2.new(0, 2, 0, 0)

    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 1)

    local page = createPage(tab.id)
    tabButtons[tab.id] = btn

    btn.MouseButton1Click:Connect(function()
        for id, b in pairs(tabButtons) do
            b.BackgroundTransparency = 1
            b.TextColor3 = col.textDim
            TweenService:Create(b.Indicator, TweenInfo.new(0.15), {Size = UDim2.new(0, 2, 0, 0)}):Play()
            pages[id].Visible = false
        end

        btn.BackgroundTransparency = 0.5
        btn.TextColor3 = col.text
        TweenService:Create(indicator, TweenInfo.new(0.15), {Size = UDim2.new(0, 2, 0, 12)}):Play()
        page.Visible = true
        activeTab = tab.id
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
        end
    end)

    if i == 1 then
        btn.BackgroundTransparency = 0.5
        btn.TextColor3 = col.text
        indicator.Size = UDim2.new(0, 2, 0, 12)
        page.Visible = true
        activeTab = tab.id
    end
end

-- ui components
local function sectionHeader(parent, text)
    local container = Instance.new("Frame", parent)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 24)

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 2, 0, 4)
    label.Size = UDim2.new(1, -4, 0, 16)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = col.textDim
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
end

local function createToggle(parent, text, callback)
    local state = false

    local container = Instance.new("TextButton", parent)
    container.BackgroundColor3 = col.card
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 36)
    container.Text = ""
    container.AutoButtonColor = false

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = col.textMuted
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame", container)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = col.off
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -10, 0.5, 0)
    switch.Size = UDim2.new(0, 32, 0, 16)

    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = col.textDim
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)

    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    container.MouseButton1Click:Connect(function()
        state = not state

        if state then
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = col.onDim}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = col.on}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = col.text}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = col.off}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = col.textDim}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = col.textMuted}):Play()
        end

        pcall(callback, state)
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.1), {BackgroundColor3 = col.cardHover}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.1), {BackgroundColor3 = col.card}):Play()
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local dragging = false

    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 48)

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 6)
    label.Size = UDim2.new(0.6, 0, 0, 14)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = col.textMuted
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -50, 0, 6)
    valueLabel.Size = UDim2.new(0, 38, 0, 14)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = col.text
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", container)
    track.BackgroundColor3 = col.elevated
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 12, 0, 28)
    track.Size = UDim2.new(1, -24, 0, 8)

    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = col.textDim
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local hitbox = Instance.new("TextButton", track)
    hitbox.BackgroundTransparency = 1
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.Text = ""

    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        pcall(callback, value)
    end

    hitbox.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    hitbox.InputBegan:Connect(function(input)
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

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = col.card
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = col.textMuted
    btn.TextSize = 11
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = col.border
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.05), {BackgroundColor3 = col.elevated}):Play()
        task.wait(0.05)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = col.card}):Play()
        pcall(callback)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = col.cardHover, TextColor3 = col.text}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), {Color = col.borderLight}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = col.card, TextColor3 = col.textMuted}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), {Color = col.border}):Play()
    end)
end

-- FUNCTIONS
local function enableGod()
    if immortal then return end
    immortal = true

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.Name = "Hum_" .. tostring(math.random(100,999))
    hum.BreakJointsOnDeath = false

    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function() hum:SetStateEnabled(state, false) end)
    end
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    conn.godHealth = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
    end)

    conn.godLoop = RunService.Heartbeat:Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    local safePos = hrp.CFrame
    conn.godFall = RunService.Heartbeat:Connect(function()
        if hrp.Position.Y > -50 then safePos = hrp.CFrame end
        if hrp.Position.Y < -100 then hrp.CFrame = safePos end
    end)

    notify("god mode enabled")
end

local function disableGod()
    if not immortal then return end
    immortal = false

    if conn.godHealth then conn.godHealth:Disconnect() end
    if conn.godLoop then conn.godLoop:Disconnect() end
    if conn.godFall then conn.godFall:Disconnect() end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Name = "Humanoid"
        hum.MaxHealth = 100
        hum.Health = 100
    end

    notify("god mode disabled")
end

local function detectRarity(obj)
    local name = obj.Name:lower()
    if name:find("divine") then return "Divine" end
    if name:find("celestial") then return "Celestial" end
    if name:find("infinity") then return "Infinity" end

    for _, attr in pairs(obj:GetAttributes()) do
        local a = tostring(attr):lower()
        if a:find("divine") then return "Divine" end
        if a:find("celestial") then return "Celestial" end
        if a:find("infinity") then return "Infinity" end
    end

    return nil
end

local function collectItem(item)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not item or not item.Parent then return end

    pcall(function()
        -- save original position
        originalFarmPos = hrp.CFrame
        
        -- get item position
        local itemPos
        if item:IsA("Model") and item.PrimaryPart then
            itemPos = item.PrimaryPart.Position
        elseif item:IsA("BasePart") then
            itemPos = item.Position
        else
            return
        end
        
        -- teleport below item (45 studs down)
        hrp.CFrame = CFrame.new(itemPos.X, itemPos.Y - 45, itemPos.Z)
        task.wait(0.08)
        
        -- teleport to item
        hrp.CFrame = CFrame.new(itemPos + Vector3.new(0, 2, 0))
        task.wait(0.05)

        -- collect
        if item:FindFirstChild("ClickDetector") then
            fireclickdetector(item.ClickDetector)
        end
        if item:FindFirstChild("ProximityPrompt") then
            fireproximityprompt(item.ProximityPrompt)
        end

        hrp.CFrame = CFrame.new(itemPos)
        task.wait(0.05)

        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local rname = remote.Name:lower()
                if rname:find("collect") or rname:find("pickup") or rname:find("grab") then
                    pcall(function() remote:FireServer(item) end)
                end
            end
        end

        task.wait(0.05)
        
        -- return underground first (go down 45 studs from original position)
        local undergroundPos = CFrame.new(originalFarmPos.X, originalFarmPos.Y - 45, originalFarmPos.Z)
        hrp.CFrame = undergroundPos
        task.wait(0.08)
        
        -- move towards original position while still underground
        local distance = (Vector3.new(originalFarmPos.X, undergroundPos.Y, originalFarmPos.Z) - hrp.Position).Magnitude
        
        -- fast approach while underground
        for i = 1, 3 do
            local progress = i / 3
            local approachPos = undergroundPos:Lerp(CFrame.new(originalFarmPos.X, originalFarmPos.Y - 45 + (45 * progress), originalFarmPos.Z), progress)
            hrp.CFrame = approachPos
            task.wait(0.03)
        end
        
        -- rise up to normal position
        hrp.CFrame = originalFarmPos
        
        notify("collected: " .. item.Name)
    end)
end

local function startFarming()
    if conn.farming then return end
    
    conn.farming = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model")) and not farmingItems[obj] then
                local rarity = detectRarity(obj)
                if rarity then
                    local shouldFarm = false
                    if rarity == "Divine" and cfg.farmDivine then shouldFarm = true end
                    if rarity == "Celestial" and cfg.farmCelestial then shouldFarm = true end
                    if rarity == "Infinity" and cfg.farmInfinity then shouldFarm = true end

                    if shouldFarm then
                        farmingItems[obj] = true
                        task.spawn(function()
                            collectItem(obj)
                            task.wait(1.5)
                            farmingItems[obj] = nil
                        end)
                    end
                end
            end
        end
    end)
end

local function stopFarming()
    if conn.farming then
        conn.farming:Disconnect()
        conn.farming = nil
    end
    farmingItems = {}
end

local function enableVIPBypass()
    conn.vipBypass = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model")) and not removedObjects[obj] then
                local name = obj.Name:lower()
                if name:find("vip") or name:find("premium") or name:find("gamepass") then
                    pcall(function()
                        if obj:IsA("BasePart") then
                            obj.Transparency = 1
                            obj.CanCollide = false
                            obj.CanTouch = false
                        else
                            for _, part in pairs(obj:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Transparency = 1
                                    part.CanCollide = false
                                    part.CanTouch = false
                                end
                            end
                        end
                        removedObjects[obj] = true
                    end)
                end
            end
        end
    end)
    notify("vip bypass enabled")
end

local function disableVIPBypass()
    if conn.vipBypass then
        conn.vipBypass:Disconnect()
        conn.vipBypass = nil
    end
    removedObjects = {}
end

local function addWings()
    if wingsModel then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    wingsModel = Instance.new("Model", char)
    wingsModel.Name = "Wings"

    for i = 1, 2 do
        local wing = Instance.new("Part", wingsModel)
        wing.Size = Vector3.new(0.1, 3, 1.5)
        wing.Material = Enum.Material.SmoothPlastic
        wing.Color = col.textDim
        wing.Transparency = 0.4
        wing.CanCollide = false
        wing.Massless = true

        local weld = Instance.new("Weld", wing)
        weld.Part0 = hrp
        weld.Part1 = wing
        weld.C0 = CFrame.new(i == 1 and -0.8 or 0.8, 0.3, -0.4) * CFrame.Angles(0, math.rad(i == 1 and 20 or -20), 0)
    end

    conn.wingAnim = RunService.RenderStepped:Connect(function()
        if not wingsModel then return end
        local wave = math.sin(tick() * 4) * 0.15
        for idx, wing in pairs(wingsModel:GetChildren()) do
            local weld = wing:FindFirstChildOfClass("Weld")
            if weld then
                local side = idx == 1 and 1 or -1
                weld.C0 = CFrame.new(side * -0.8, 0.3, -0.4) * CFrame.Angles(0, math.rad(side * 20), wave * side)
            end
        end
    end)

    notify("wings enabled")
end

local function removeWings()
    if wingsModel then wingsModel:Destroy() wingsModel = nil end
    if conn.wingAnim then conn.wingAnim:Disconnect() conn.wingAnim = nil end
end

local function addHalo()
    if haloModel then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    haloModel = Instance.new("Part", char)
    haloModel.Name = "Halo"
    haloModel.Size = Vector3.new(1.6, 0.1, 1.6)
    haloModel.Shape = Enum.PartType.Cylinder
    haloModel.Material = Enum.Material.SmoothPlastic
    haloModel.Color = col.textDim
    haloModel.Transparency = 0.3
    haloModel.CanCollide = false
    haloModel.Massless = true

    local weld = Instance.new("Weld", haloModel)
    weld.Part0 = head
    weld.Part1 = haloModel
    weld.C0 = CFrame.new(0, 0.8, 0) * CFrame.Angles(0, 0, math.rad(90))

    conn.haloSpin = RunService.RenderStepped:Connect(function()
        if weld then
            weld.C0 = weld.C0 * CFrame.Angles(0, math.rad(1), 0)
        end
    end)

    notify("halo enabled")
end

local function removeHalo()
    if haloModel then haloModel:Destroy() haloModel = nil end
    if conn.haloSpin then conn.haloSpin:Disconnect() conn.haloSpin = nil end
end

local function clearAllESP()
    for _, data in pairs(espData) do
        if data.obj then pcall(function() data.obj:Destroy() end) end
    end
    espData = {}
end

local function createESPFor(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if cfg.espMode == 1 then
        local billboard = Instance.new("BillboardGui", hrp)
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 70, 0, 24)
        billboard.StudsOffset = Vector3.new(0, 2.2, 0)

        local bg = Instance.new("Frame", billboard)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = col.bg
        bg.BackgroundTransparency = 0.3
        bg.BorderSizePixel = 0

        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

        local nameLabel = Instance.new("TextLabel", bg)
        nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = col.text
        nameLabel.TextSize = 9
        nameLabel.TextScaled = true

        local distLabel = Instance.new("TextLabel", bg)
        distLabel.Position = UDim2.new(0, 0, 0.6, 0)
        distLabel.Size = UDim2.new(1, 0, 0.4, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextColor3 = col.textDim
        distLabel.TextSize = 8
        distLabel.TextScaled = true

        espData[player] = {obj = billboard, dist = distLabel}

    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = col.textDim
        box.Transparency = 0.6

        espData[player] = {obj = box}

    elseif cfg.espMode == 3 then
        local highlight = Instance.new("Highlight", ch)
        highlight.FillColor = col.textDim
        highlight.OutlineColor = col.textMuted
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0.3

        espData[player] = {obj = highlight}
    end
end

local function updateAllESP()
    for player, data in pairs(espData) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if data.dist then
                data.dist.Text = math.floor(dist) .. "m"
            end

            if cfg.espRgb then
                local hue = tick() % 6 / 6
                local rainbow = Color3.fromHSV(hue, 0.5, 0.8)
                if data.obj and data.obj:IsA("BoxHandleAdornment") then
                    data.obj.Color3 = rainbow
                elseif data.obj and data.obj:IsA("Highlight") then
                    data.obj.FillColor = rainbow
                    data.obj.OutlineColor = rainbow
                end
            end
        end
    end
end

local function getClosestTarget()
    local closest = nil
    local minDist = cfg.aimfov
    local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, visible = cam:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if dist < minDist then
                        closest = player
                        minDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local function setupAntiAFK()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    notify("anti afk enabled")
end

-- HOME TAB
local homePage = pages["home"]

sectionHeader(homePage, "PLAYER")

local playerCard = Instance.new("Frame", homePage)
playerCard.BackgroundColor3 = col.card
playerCard.BorderSizePixel = 0
playerCard.Size = UDim2.new(1, 0, 0, 56)

Instance.new("UICorner", playerCard).CornerRadius = UDim.new(0, 6)

local avatarImg = Instance.new("ImageLabel", playerCard)
avatarImg.BackgroundColor3 = col.elevated
avatarImg.BorderSizePixel = 0
avatarImg.Position = UDim2.new(0, 10, 0.5, 0)
avatarImg.AnchorPoint = Vector2.new(0, 0.5)
avatarImg.Size = UDim2.new(0, 36, 0, 36)

Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 6)

pcall(function()
    avatarImg.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local playerNameLabel = Instance.new("TextLabel", playerCard)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Position = UDim2.new(0, 54, 0, 10)
playerNameLabel.Size = UDim2.new(1, -64, 0, 16)
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.Text = plr.Name
playerNameLabel.TextColor3 = col.text
playerNameLabel.TextSize = 12
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local gameNameLabel = Instance.new("TextLabel", playerCard)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.Position = UDim2.new(0, 54, 0, 28)
gameNameLabel.Size = UDim2.new(1, -64, 0, 14)
gameNameLabel.Font = Enum.Font.Gotham
gameNameLabel.Text = "Violence District"
gameNameLabel.TextColor3 = col.textDim
gameNameLabel.TextSize = 10
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left

sectionHeader(homePage, "INFO")

local infoCard = Instance.new("Frame", homePage)
infoCard.BackgroundColor3 = col.card
infoCard.BorderSizePixel = 0
infoCard.Size = UDim2.new(1, 0, 0, 64)

Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)

local infoGrid = Instance.new("UIGridLayout", infoCard)
infoGrid.CellSize = UDim2.new(0.333, -8, 1, -12)
infoGrid.CellPadding = UDim2.new(0, 6, 0, 0)
infoGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
infoGrid.VerticalAlignment = Enum.VerticalAlignment.Center

local function createInfoItem(val, label)
    local item = Instance.new("Frame", infoCard)
    item.BackgroundColor3 = col.elevated
    item.BorderSizePixel = 0

    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)

    local valLabel = Instance.new("TextLabel", item)
    valLabel.BackgroundTransparency = 1
    valLabel.Position = UDim2.new(0, 0, 0, 8)
    valLabel.Size = UDim2.new(1, 0, 0, 18)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.Text = val
    valLabel.TextColor3 = col.text
    valLabel.TextSize = 14

    local nameLabel = Instance.new("TextLabel", item)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 0, 0, 28)
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Text = label
    nameLabel.TextColor3 = col.textDim
    nameLabel.TextSize = 9
end

createInfoItem("20+", "features")
createInfoItem("v3", "version")
createInfoItem("ok", "status")

sectionHeader(homePage, "CREDITS")

local creditsCard = Instance.new("Frame", homePage)
creditsCard.BackgroundColor3 = col.card
creditsCard.BorderSizePixel = 0
creditsCard.Size = UDim2.new(1, 0, 0, 40)

Instance.new("UICorner", creditsCard).CornerRadius = UDim.new(0, 6)

local creditsLabel = Instance.new("TextLabel", creditsCard)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Size = UDim2.new(1, 0, 1, 0)
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Text = "made by ikaxzu"
creditsLabel.TextColor3 = col.textDim
creditsLabel.TextSize = 10

-- COMBAT TAB
local combatPage = pages["combat"]

sectionHeader(combatPage, "PROTECTION")
createToggle(combatPage, "God Mode", function(v)
    cfg.god = v
    if v then enableGod() else disableGod() end
end)

sectionHeader(combatPage, "AIMBOT")
createToggle(combatPage, "Auto Aim", function(v)
    cfg.aim = v
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if conn.aim then conn.aim:Disconnect() conn.aim = nil end
    end
end)

createToggle(combatPage, "Show FOV", function(v)
    cfg.showfov = v
    fovCircle.Visible = v
end)

createSlider(combatPage, "FOV Size", 50, 400, 100, function(v) cfg.aimfov = v end)

createToggle(combatPage, "Kill Aura", function(v)
    cfg.killaura = v
    if v then
        conn.aura = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < 15 then
                        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("attack") then
                                pcall(function() remote:FireServer(player.Character) end)
                            end
                        end
                    end
                end
            end
        end)
    else
        if conn.aura then conn.aura:Disconnect() conn.aura = nil end
    end
end)

-- MOVEMENT TAB
local movementPage = pages["movement"]

sectionHeader(movementPage, "SPEED")
createSlider(movementPage, "Walk Speed", 16, 400, 16, function(v) cfg.speed = v end)
createSlider(movementPage, "Jump Power", 50, 400, 50, function(v) cfg.jump = v end)

sectionHeader(movementPage, "MOVEMENT")
createToggle(movementPage, "Noclip", function(v)
    cfg.noclip = v
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        notify("noclip enabled")
    else
        if conn.noclip then conn.noclip:Disconnect() conn.noclip = nil end
        notify("noclip disabled")
    end
end)

createToggle(movementPage, "Fly", function(v)
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
        notify("fly enabled")
    else
        if conn.fly then conn.fly:Disconnect() conn.fly = nil end
        for _, v in pairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
        notify("fly disabled")
    end
end)

createSlider(movementPage, "Fly Speed", 10, 150, 50, function(v) cfg.flyspeed = v end)

-- VISUAL TAB
local visualPage = pages["visual"]

sectionHeader(visualPage, "WORLD")
createToggle(visualPage, "No Fog", function(v)
    cfg.fog = v
    Lighting.FogEnd = v and 100000 or 1000
end)

createToggle(visualPage, "Full Bright", function(v)
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

createSlider(visualPage, "Field of View", 70, 120, 70, function(v)
    cfg.fov = v
    cam.FieldOfView = v
end)

sectionHeader(visualPage, "CHARACTER")
createToggle(visualPage, "Wings", function(v)
    cfg.wings = v
    if v then addWings() else removeWings() end
end)

createToggle(visualPage, "Halo", function(v)
    cfg.halo = v
    if v then addHalo() else removeHalo() end
end)

createToggle(visualPage, "Invisible", function(v)
    cfg.invisible = v
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = v and 1 or 0
        end
    end
end)

sectionHeader(visualPage, "MISC")
createToggle(visualPage, "Anti AFK", function(v)
    cfg.antiAfk = v
    if v then setupAntiAFK() end
end)

-- ESP TAB
local espPage = pages["esp"]

sectionHeader(espPage, "PLAYER ESP")
createToggle(espPage, "Enable ESP", function(v)
    cfg.esp = v
    if v then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESPFor(player) end
        end
    else
        clearAllESP()
    end
end)

createToggle(espPage, "RGB Effect", function(v) cfg.espRgb = v end)

sectionHeader(espPage, "ESP MODE")
createButton(espPage, "Simple (Nametag)", function()
    cfg.espMode = 1
    clearAllESP()
    if cfg.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESPFor(player) end
        end
    end
    notify("esp mode: simple")
end)

createButton(espPage, "Box", function()
    cfg.espMode = 2
    clearAllESP()
    if cfg.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESPFor(player) end
        end
    end
    notify("esp mode: box")
end)

createButton(espPage, "Highlight", function()
    cfg.espMode = 3
    clearAllESP()
    if cfg.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESPFor(player) end
        end
    end
    notify("esp mode: highlight")
end)

-- FARM TAB
local farmPage = pages["farm"]

sectionHeader(farmPage, "AUTO FARM")
createToggle(farmPage, "Farm Divine", function(v)
    cfg.farmDivine = v
    if cfg.farmDivine or cfg.farmCelestial or cfg.farmInfinity then
        startFarming()
    else
        stopFarming()
    end
end)

createToggle(farmPage, "Farm Celestial", function(v)
    cfg.farmCelestial = v
    if cfg.farmDivine or cfg.farmCelestial or cfg.farmInfinity then
        startFarming()
    else
        stopFarming()
    end
end)

createToggle(farmPage, "Farm Infinity", function(v)
    cfg.farmInfinity = v
    if cfg.farmDivine or cfg.farmCelestial or cfg.farmInfinity then
        startFarming()
    else
        stopFarming()
    end
end)

sectionHeader(farmPage, "BYPASS")
createToggle(farmPage, "VIP Remover", function(v)
    cfg.vip = v
    if v then enableVIPBypass() else disableVIPBypass() end
end)

-- EVENTS
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.new(0, 520, 0, 320)
        main.BackgroundTransparency = 0
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

RunService.RenderStepped:Connect(function()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = cfg.speed
        hum.JumpPower = cfg.jump
    end

    if cfg.showfov then
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = cfg.aimfov
    end

    if cfg.esp then updateAllESP() end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESPFor(player) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if espData[player] then
        if espData[player].obj then
            pcall(function() espData[player].obj:Destroy() end)
        end
        espData[player] = nil
    end
end)

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    task.wait(1)

    if cfg.god then enableGod() end
    if cfg.noclip then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
    if cfg.wings then addWings() end
    if cfg.halo then addHalo() end
    if cfg.vip then enableVIPBypass() end
end)

-- init
task.wait(0.2)
notify("ikaxzu v3 loaded")
warn("ikaxzu scripter v3 ready")
