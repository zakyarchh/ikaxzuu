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
    speed = 16, jump = 50, noclip = false,
    god = false, aim = false, aimfov = 100, showfov = false,
    killaura = false,
    vip = false, invisible = false,
    fog = false, bright = false, fov = 70, antiAfk = false,
    selectedPlayer = nil
}

local conn = {}
local espData = {}
local removedObjects = {}
local immortal = false

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

local col = {
    bg = Color3.fromRGB(13, 13, 15),
    surface = Color3.fromRGB(19, 19, 22),
    card = Color3.fromRGB(24, 24, 28),
    cardHover = Color3.fromRGB(30, 30, 35),
    elevated = Color3.fromRGB(34, 34, 40),
    border = Color3.fromRGB(40, 40, 46),
    borderLight = Color3.fromRGB(52, 52, 60),
    text = Color3.fromRGB(215, 215, 220),
    textMuted = Color3.fromRGB(135, 135, 145),
    textDim = Color3.fromRGB(80, 80, 90),
    on = Color3.fromRGB(70, 160, 85),
    onDim = Color3.fromRGB(40, 100, 55),
    off = Color3.fromRGB(50, 50, 58),
    danger = Color3.fromRGB(160, 60, 65),
    warn = Color3.fromRGB(160, 130, 50),
    health = Color3.fromRGB(0, 255, 100),
    enemy = Color3.fromRGB(255, 50, 50),
    friendly = Color3.fromRGB(50, 255, 50),
    cyan = Color3.fromRGB(0, 255, 255),
    purple = Color3.fromRGB(180, 100, 255),
    orange = Color3.fromRGB(255, 150, 0),
    pink = Color3.fromRGB(255, 100, 200),
    selected = Color3.fromRGB(255, 215, 0)
}

local gui = Instance.new("ScreenGui")
gui.Name = "ixv3" .. math.random(1000, 9999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 10, 0.5, -20)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Draggable = true

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = col.border
toggleStroke.Thickness = 1

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Text = "VD"
toggleIcon.TextColor3 = col.textMuted
toggleIcon.TextSize = 20

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Color = col.borderLight}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.15), {TextColor3 = col.text}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Color = col.border}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.15), {TextColor3 = col.textMuted}):Play()
end)

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = col.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 520, 0, 340)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = col.border
mainStroke.Thickness = 1

local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = col.surface
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 36)

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = col.surface
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -6)
headerFix.Size = UDim2.new(1, 0, 0, 6)

local headerLine = Instance.new("Frame", header)
headerLine.BackgroundColor3 = col.border
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)

local titleLabel = Instance.new("TextLabel", header)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.Size = UDim2.new(0, 100, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "ikaxzu"
titleLabel.TextColor3 = col.text
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local versionLabel = Instance.new("TextLabel", header)
versionLabel.BackgroundTransparency = 1
versionLabel.Position = UDim2.new(0, 60, 0, 0)
versionLabel.Size = UDim2.new(0, 30, 1, 0)
versionLabel.Font = Enum.Font.Gotham
versionLabel.Text = "v3"
versionLabel.TextColor3 = col.textDim
versionLabel.TextSize = 10
versionLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = col.textDim
closeBtn.TextSize = 18
closeBtn.AutoButtonColor = false

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), {TextColor3 = col.danger}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), {TextColor3 = col.textDim}):Play()
end)

local minBtn = Instance.new("TextButton", header)
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -56, 0, 6)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = col.textDim
minBtn.TextSize = 16
minBtn.AutoButtonColor = false

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.1), {TextColor3 = col.warn}):Play()
end)

minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.1), {TextColor3 = col.textDim}):Play()
end)

local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = col.surface
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.Size = UDim2.new(0, 100, 1, -36)

local sidebarLine = Instance.new("Frame", sidebar)
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)

local tabList = Instance.new("Frame", sidebar)
tabList.BackgroundTransparency = 1
tabList.Position = UDim2.new(0, 4, 0, 6)
tabList.Size = UDim2.new(1, -8, 1, -12)

local tabListLayout = Instance.new("UIListLayout", tabList)
tabListLayout.Padding = UDim.new(0, 2)

local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 108, 0, 44)
content.Size = UDim2.new(1, -116, 1, -52)

local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifs"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -250, 0, 8)
notifContainer.Size = UDim2.new(0, 240, 0, 250)

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 3)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(msg, dur)
    local n = Instance.new("Frame", notifContainer)
    n.BackgroundColor3 = col.surface
    n.BorderSizePixel = 0
    n.Size = UDim2.new(0, 0, 0, 28)
    n.ClipsDescendants = true

    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", n).Color = col.border

    local t = Instance.new("TextLabel", n)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 8, 0, 0)
    t.Size = UDim2.new(1, -16, 1, 0)
    t.Font = Enum.Font.Gotham
    t.Text = msg
    t.TextColor3 = col.textMuted
    t.TextSize = 10
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTransparency = 1

    TweenService:Create(n, TweenInfo.new(0.2), {Size = UDim2.new(0, 220, 0, 28)}):Play()
    task.delay(0.08, function()
        TweenService:Create(t, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
    end)

    task.delay(dur or 2, function()
        TweenService:Create(t, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
        task.wait(0.1)
        TweenService:Create(n, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0, 28)}):Play()
        task.wait(0.15)
        n:Destroy()
    end)
end

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = col.textDim
fovCircle.Transparency = 0.5
fovCircle.NumSides = 40
fovCircle.Filled = false

local pages = {}
local tabButtons = {}
local activeTab = nil

local tabs = {
    {id = "home", name = "Home"},
    {id = "combat", name = "Combat"},
    {id = "move", name = "Move"},
    {id = "visual", name = "Visual"},
    {id = "esp", name = "ESP"},
    {id = "players", name = "Players"},
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
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = col.border
    page.ScrollBarImageTransparency = 0.2
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 3)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
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
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.Font = Enum.Font.Gotham
    btn.Text = " " .. tab.name
    btn.TextColor3 = col.textDim
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local ind = Instance.new("Frame", btn)
    ind.Name = "Ind"
    ind.BackgroundColor3 = col.text
    ind.BorderSizePixel = 0
    ind.Position = UDim2.new(0, 0, 0.5, -5)
    ind.Size = UDim2.new(0, 2, 0, 0)

    Instance.new("UICorner", ind).CornerRadius = UDim.new(0, 1)

    local page = createPage(tab.id)
    tabButtons[tab.id] = btn

    btn.MouseButton1Click:Connect(function()
        for id, b in pairs(tabButtons) do
            b.BackgroundTransparency = 1
            b.TextColor3 = col.textDim
            TweenService:Create(b.Ind, TweenInfo.new(0.12), {Size = UDim2.new(0, 2, 0, 0)}):Play()
            pages[id].Visible = false
        end

        btn.BackgroundTransparency = 0.6
        btn.TextColor3 = col.text
        TweenService:Create(ind, TweenInfo.new(0.12), {Size = UDim2.new(0, 2, 0, 10)}):Play()
        page.Visible = true
        activeTab = tab.id
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.75}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 1}):Play()
        end
    end)

    if i == 1 then
        btn.BackgroundTransparency = 0.6
        btn.TextColor3 = col.text
        ind.Size = UDim2.new(0, 2, 0, 10)
        page.Visible = true
        activeTab = tab.id
    end
end

local function sectionLabel(parent, text)
    local c = Instance.new("Frame", parent)
    c.BackgroundTransparency = 1
    c.Size = UDim2.new(1, 0, 0, 20)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 2, 0, 2)
    l.Size = UDim2.new(1, -4, 0, 14)
    l.Font = Enum.Font.GothamBold
    l.Text = text
    l.TextColor3 = col.textDim
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
end

local function createToggle(parent, text, callback)
    local state = false

    local c = Instance.new("TextButton", parent)
    c.BackgroundColor3 = col.card
    c.BorderSizePixel = 0
    c.Size = UDim2.new(1, 0, 0, 32)
    c.Text = ""
    c.AutoButtonColor = false

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 5)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Font = Enum.Font.Gotham
    l.Text = text
    l.TextColor3 = col.textMuted
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left

    local sw = Instance.new("Frame", c)
    sw.AnchorPoint = Vector2.new(1, 0.5)
    sw.BackgroundColor3 = col.off
    sw.BorderSizePixel = 0
    sw.Position = UDim2.new(1, -8, 0.5, 0)
    sw.Size = UDim2.new(0, 28, 0, 14)

    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local k = Instance.new("Frame", sw)
    k.AnchorPoint = Vector2.new(0, 0.5)
    k.BackgroundColor3 = col.textDim
    k.BorderSizePixel = 0
    k.Position = UDim2.new(0, 2, 0.5, 0)
    k.Size = UDim2.new(0, 10, 0, 10)

    Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)

    c.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(sw, TweenInfo.new(0.12), {BackgroundColor3 = col.onDim}):Play()
            TweenService:Create(k, TweenInfo.new(0.12), {Position = UDim2.new(1, -12, 0.5, 0), BackgroundColor3 = col.on}):Play()
            TweenService:Create(l, TweenInfo.new(0.12), {TextColor3 = col.text}):Play()
        else
            TweenService:Create(sw, TweenInfo.new(0.12), {BackgroundColor3 = col.off}):Play()
            TweenService:Create(k, TweenInfo.new(0.12), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = col.textDim}):Play()
            TweenService:Create(l, TweenInfo.new(0.12), {TextColor3 = col.textMuted}):Play()
        end
        pcall(callback, state)
    end)

    c.MouseEnter:Connect(function()
        TweenService:Create(c, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover}):Play()
    end)
    c.MouseLeave:Connect(function()
        TweenService:Create(c, TweenInfo.new(0.08), {BackgroundColor3 = col.card}):Play()
    end)
end

local function createSlider(parent, text, min, max, def, callback)
    local val = def
    local drag = false

    local c = Instance.new("Frame", parent)
    c.BackgroundColor3 = col.card
    c.BorderSizePixel = 0
    c.Size = UDim2.new(1, 0, 0, 42)

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 5)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 4)
    l.Size = UDim2.new(0.6, 0, 0, 12)
    l.Font = Enum.Font.Gotham
    l.Text = text
    l.TextColor3 = col.textMuted
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left

    local v = Instance.new("TextLabel", c)
    v.BackgroundTransparency = 1
    v.Position = UDim2.new(1, -40, 0, 4)
    v.Size = UDim2.new(0, 30, 0, 12)
    v.Font = Enum.Font.GothamBold
    v.Text = tostring(def)
    v.TextColor3 = col.text
    v.TextSize = 10
    v.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", c)
    track.BackgroundColor3 = col.elevated
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 10, 0, 24)
    track.Size = UDim2.new(1, -20, 0, 6)

    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = col.textDim
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)

    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local hit = Instance.new("TextButton", track)
    hit.BackgroundTransparency = 1
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.Text = ""

    local function upd(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        v.Text = tostring(val)
        pcall(callback, val)
    end

    hit.MouseButton1Down:Connect(function() drag = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            upd(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            upd(input)
        end
    end)
end

local function createButton(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3 = col.card
    b.BorderSizePixel = 0
    b.Size = UDim2.new(1, 0, 0, 28)
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = col.textMuted
    b.TextSize = 10
    b.AutoButtonColor = false

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

    local s = Instance.new("UIStroke", b)
    s.Color = col.border
    s.Thickness = 1

    b.MouseButton1Click:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.04), {BackgroundColor3 = col.elevated}):Play()
        task.wait(0.04)
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = col.card}):Play()
        pcall(callback)
    end)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover, TextColor3 = col.text}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = col.card, TextColor3 = col.textMuted}):Play()
    end)

    return b
end

local function createDropdown(parent, text, options, callback)
    local opened = false
    local selected = options[1] or "None"
    
    local container = Instance.new("Frame", parent)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 32)
    
    local main = Instance.new("TextButton", container)
    main.BackgroundColor3 = col.card
    main.BorderSizePixel = 0
    main.Size = UDim2.new(1, 0, 0, 32)
    main.Text = ""
    main.AutoButtonColor = false
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel", main)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = col.textMuted
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local value = Instance.new("TextLabel", main)
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(0.5, 0, 0, 0)
    value.Size = UDim2.new(0.5, -30, 1, 0)
    value.Font = Enum.Font.GothamBold
    value.Text = selected
    value.TextColor3 = col.text
    value.TextSize = 10
    value.TextXAlignment = Enum.TextXAlignment.Right
    
    local arrow = Instance.new("TextLabel", main)
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = col.textDim
    arrow.TextSize = 8
    
    local list = Instance.new("Frame", container)
    list.BackgroundColor3 = col.elevated
    list.BorderSizePixel = 0
    list.Position = UDim2.new(0, 0, 0, 34)
    list.Size = UDim2.new(1, 0, 0, 0)
    list.ClipsDescendants = true
    list.Visible = false
    
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 5)
    
    local listLayout = Instance.new("UIListLayout", list)
    listLayout.Padding = UDim.new(0, 1)
    
    for _, option in ipairs(options) do
        local opt = Instance.new("TextButton", list)
        opt.BackgroundColor3 = col.card
        opt.BorderSizePixel = 0
        opt.Size = UDim2.new(1, 0, 0, 26)
        opt.Font = Enum.Font.Gotham
        opt.Text = " " .. option
        opt.TextColor3 = col.textMuted
        opt.TextSize = 9
        opt.TextXAlignment = Enum.TextXAlignment.Left
        opt.AutoButtonColor = false
        
        opt.MouseButton1Click:Connect(function()
            selected = option
            value.Text = option
            opened = false
            TweenService:Create(list, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
            task.wait(0.15)
            list.Visible = false
            container.Size = UDim2.new(1, 0, 0, 32)
            pcall(callback, option)
        end)
        
        opt.MouseEnter:Connect(function()
            TweenService:Create(opt, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover}):Play()
        end)
        opt.MouseLeave:Connect(function()
            TweenService:Create(opt, TweenInfo.new(0.08), {BackgroundColor3 = col.card}):Play()
        end)
    end
    
    main.MouseButton1Click:Connect(function()
        opened = not opened
        if opened then
            list.Visible = true
            local targetSize = #options * 27
            container.Size = UDim2.new(1, 0, 0, 32 + targetSize + 2)
            TweenService:Create(list, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, targetSize)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 180}):Play()
        else
            TweenService:Create(list, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
            task.wait(0.15)
            list.Visible = false
            container.Size = UDim2.new(1, 0, 0, 32)
        end
    end)
    
    main.MouseEnter:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover}):Play()
    end)
    main.MouseLeave:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.08), {BackgroundColor3 = col.card}):Play()
    end)
end

-- FUNCTIONS

local function clearESP()
    for player, data in pairs(espData) do
        if data.obj then
            if typeof(data.obj) == "Instance" then
                pcall(function() data.obj:Destroy() end)
            else
                pcall(function() data.obj:Remove() end)
            end
        end
        if data.bones then
            for _, bone in ipairs(data.bones) do
                pcall(function() bone.line:Remove() end)
            end
        end
        if data.corners then
            for _, corner in ipairs(data.corners) do
                pcall(function() corner[1]:Remove() end)
                pcall(function() corner[2]:Remove() end)
            end
        end
        if data.chams then
            for _, cham in ipairs(data.chams) do
                pcall(function() cham:Destroy() end)
            end
        end
        if data.circle then pcall(function() data.circle:Remove() end) end
        if data.name then pcall(function() data.name:Remove() end) end
        if data.att0 then pcall(function() data.att0:Destroy() end) end
        if data.att1 then pcall(function() data.att1:Destroy() end) end
        if data.head then pcall(function() data.head:Remove() end) end
        if data.tracer then pcall(function() data.tracer:Remove() end) end
    end
    espData = {}
end

local function enableGod()
    if immortal then return end
    immortal = true

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.Name = "H_" .. math.random(100, 999)
    hum.BreakJointsOnDeath = false

    for _, st in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function() hum:SetStateEnabled(st, false) end)
    end
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    conn.godH = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
    end)

    conn.godL = RunService.Heartbeat:Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    local safe = hrp.CFrame
    conn.godF = RunService.Heartbeat:Connect(function()
        if hrp.Position.Y > -50 then safe = hrp.CFrame end
        if hrp.Position.Y < -100 then hrp.CFrame = safe end
    end)

    notify("god mode on")
end

local function disableGod()
    if not immortal then return end
    immortal = false

    if conn.godH then conn.godH:Disconnect() end
    if conn.godL then conn.godL:Disconnect() end
    if conn.godF then conn.godF:Disconnect() end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Name = "Humanoid"
        hum.MaxHealth = 100
        hum.Health = 100
    end

    notify("god mode off")
end

local function enableVIP()
    conn.vip = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model")) and not removedObjects[obj] then
                local n = obj.Name:lower()
                if n:find("vip") or n:find("premium") or n:find("gamepass") then
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
    end)
    notify("vip bypass on")
end

local function disableVIP()
    if conn.vip then
        conn.vip:Disconnect()
        conn.vip = nil
    end
    removedObjects = {}
end

-- ══════════════════════════════════════════════════════════════
-- 20 JENIS ESP DENGAN SELECTION
-- ══════════════════════════════════════════════════════════════

local function createESP(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChild("Humanoid")
    local head = ch:FindFirstChild("Head")
    if not hrp then return end

    local isSelected = (cfg.selectedPlayer == player)
    
    -- MODE 1: Name Tag ESP
    if cfg.espMode == 1 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.Name = "NameTagESP"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 60, 0, 20)
        bb.StudsOffset = Vector3.new(0, 2, 0)

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = isSelected and col.selected or col.bg
        bg.BackgroundTransparency = 0.35
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 3)

        local nm = Instance.new("TextLabel", bg)
        nm.Size = UDim2.new(1, 0, 0.55, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBold
        nm.Text = player.Name
        nm.TextColor3 = col.text
        nm.TextScaled = true

        local dst = Instance.new("TextLabel", bg)
        dst.Position = UDim2.new(0, 0, 0.55, 0)
        dst.Size = UDim2.new(1, 0, 0.45, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textDim
        dst.TextScaled = true

        espData[player] = {obj = bb, dist = dst, bg = bg, type = "nametag"}

    -- MODE 2: Box ESP
    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Name = "BoxESP"
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSelected and col.selected or col.textDim
        box.Transparency = 0.65

        espData[player] = {obj = box, type = "box"}

    -- MODE 3: Highlight ESP
    elseif cfg.espMode == 3 then
        local hl = Instance.new("Highlight", ch)
        hl.Name = "HighlightESP"
        hl.FillColor = isSelected and col.selected or col.textDim
        hl.OutlineColor = col.textMuted
        hl.FillTransparency = 0.75
        hl.OutlineTransparency = 0.4

        espData[player] = {obj = hl, type = "highlight"}

    -- MODE 4: Tracer ESP
    elseif cfg.espMode == 4 then
        local tracer = Drawing.new("Line")
        tracer.Visible = true
        tracer.Color = isSelected and col.selected or col.cyan
        tracer.Thickness = isSelected and 2.5 or 1.5
        tracer.Transparency = 0.8

        espData[player] = {obj = tracer, hrp = hrp, type = "tracer"}

    -- MODE 5: Dot ESP
    elseif cfg.espMode == 5 then
        local dot = Drawing.new("Circle")
        dot.Visible = true
        dot.Color = isSelected and col.selected or col.enemy
        dot.Radius = isSelected and 8 or 5
        dot.Filled = true
        dot.Thickness = 1
        dot.Transparency = 0.9

        espData[player] = {obj = dot, head = head, type = "dot"}

    -- MODE 6: Health Bar ESP
    elseif cfg.espMode == 6 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.Name = "HealthBarESP"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 80, 0, 35)
        bb.StudsOffset = Vector3.new(0, 3, 0)

        local container = Instance.new("Frame", bb)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundColor3 = isSelected and col.selected or col.bg
        container.BackgroundTransparency = 0.3
        container.BorderSizePixel = 0
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 5)

        local nm = Instance.new("TextLabel", container)
        nm.Size = UDim2.new(1, 0, 0.4, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBold
        nm.Text = player.Name
        nm.TextColor3 = col.text
        nm.TextScaled = true

        local hpBg = Instance.new("Frame", container)
        hpBg.Position = UDim2.new(0.1, 0, 0.5, 0)
        hpBg.Size = UDim2.new(0.8, 0, 0.15, 0)
        hpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        hpBg.BorderSizePixel = 0
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 3)

        local hpBar = Instance.new("Frame", hpBg)
        hpBar.Size = UDim2.new(1, 0, 1, 0)
        hpBar.BackgroundColor3 = col.health
        hpBar.BorderSizePixel = 0
        Instance.new("UICorner", hpBar).CornerRadius = UDim.new(0, 3)

        local dst = Instance.new("TextLabel", container)
        dst.Position = UDim2.new(0, 0, 0.7, 0)
        dst.Size = UDim2.new(1, 0, 0.3, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textDim
        dst.TextScaled = true

        espData[player] = {obj = bb, dist = dst, hpBar = hpBar, hum = hum, container = container, type = "healthbar"}

    -- MODE 7: Skeleton ESP
    elseif cfg.espMode == 7 then
        local bones = {}
        local boneConnections = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"},
            {"UpperTorso", "RightUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"},
            {"RightUpperArm", "RightLowerArm"},
            {"LeftLowerArm", "LeftHand"},
            {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"},
            {"LowerTorso", "RightUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"RightUpperLeg", "RightLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"},
            {"RightLowerLeg", "RightFoot"}
        }

        for _, conn in ipairs(boneConnections) do
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = isSelected and col.selected or col.text
            line.Thickness = isSelected and 2.5 or 1.5
            line.Transparency = 0.9
            table.insert(bones, {line = line, part1 = conn[1], part2 = conn[2]})
        end

        espData[player] = {bones = bones, char = ch, type = "skeleton"}

    -- MODE 8: Circle ESP
    elseif cfg.espMode == 8 then
        local circle = Instance.new("CylinderHandleAdornment", hrp)
        circle.Name = "CircleESP"
        circle.Height = 0.1
        circle.Radius = isSelected and 4 or 3
        circle.Adornee = hrp
        circle.AlwaysOnTop = true
        circle.Color3 = isSelected and col.selected or col.cyan
        circle.Transparency = 0.5
        circle.CFrame = CFrame.new(0, -3, 0)

        espData[player] = {obj = circle, type = "circle"}

    -- MODE 9: Arrow ESP
    elseif cfg.espMode == 9 then
        local arrow = Drawing.new("Triangle")
        arrow.Visible = true
        arrow.Color = isSelected and col.selected or col.warn
        arrow.Filled = true
        arrow.Thickness = 1
        arrow.Transparency = 0.9

        espData[player] = {obj = arrow, hrp = hrp, type = "arrow"}

    -- MODE 10: Beam ESP
    elseif cfg.espMode == 10 then
        local att0 = Instance.new("Attachment", hrp)
        att0.Position = Vector3.new(0, 0, 0)
        
        local att1 = Instance.new("Attachment", hrp)
        att1.Position = Vector3.new(0, 50, 0)

        local beam = Instance.new("Beam", hrp)
        beam.Name = "BeamESP"
        beam.Attachment0 = att0
        beam.Attachment1 = att1
        beam.Width0 = isSelected and 1 or 0.5
        beam.Width1 = isSelected and 1 or 0.5
        beam.Color = ColorSequence.new(isSelected and col.selected or col.purple)
        beam.Transparency = NumberSequence.new(0.3)
        beam.LightEmission = 1
        beam.FaceCamera = true

        espData[player] = {obj = beam, att0 = att0, att1 = att1, type = "beam"}

    -- MODE 11: Corner Box ESP
    elseif cfg.espMode == 11 then
        local corners = {}
        for i = 1, 8 do
            local line1 = Drawing.new("Line")
            line1.Visible = true
            line1.Color = isSelected and col.selected or col.enemy
            line1.Thickness = isSelected and 3 or 2
            line1.Transparency = 0.9
            
            local line2 = Drawing.new("Line")
            line2.Visible = true
            line2.Color = isSelected and col.selected or col.enemy
            line2.Thickness = isSelected and 3 or 2
            line2.Transparency = 0.9
            
            table.insert(corners, {line1, line2})
        end

        espData[player] = {corners = corners, char = ch, type = "cornerbox"}

    -- MODE 12: Head Circle ESP
    elseif cfg.espMode == 12 then
        local headCircle = Drawing.new("Circle")
        headCircle.Visible = true
        headCircle.Color = isSelected and col.selected or col.pink
        headCircle.Radius = isSelected and 15 or 10
        headCircle.Filled = false
        headCircle.Thickness = isSelected and 3 or 2
        headCircle.Transparency = 0.9

        local nameText = Drawing.new("Text")
        nameText.Visible = true
        nameText.Color = col.text
        nameText.Text = player.Name
        nameText.Size = 14
        nameText.Center = true
        nameText.Outline = true

        espData[player] = {circle = headCircle, name = nameText, head = head, type = "headcircle"}

    -- MODE 13: Glow Sphere ESP
    elseif cfg.espMode == 13 then
        local sphere = Instance.new("SphereHandleAdornment", hrp)
        sphere.Name = "SphereESP"
        sphere.Radius = isSelected and 5 or 4
        sphere.Adornee = hrp
        sphere.AlwaysOnTop = true
        sphere.Color3 = isSelected and col.selected or col.cyan
        sphere.Transparency = 0.7

        espData[player] = {obj = sphere, type = "sphere"}

    -- MODE 14: Full Info ESP
    elseif cfg.espMode == 14 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.Name = "FullInfoESP"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 120, 0, 80)
        bb.StudsOffset = Vector3.new(0, 4, 0)

        local container = Instance.new("Frame", bb)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundColor3 = isSelected and col.selected or col.bg
        container.BackgroundTransparency = 0.2
        container.BorderSizePixel = 0
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", container)
        stroke.Color = isSelected and col.selected or col.cyan
        stroke.Thickness = isSelected and 3 or 2

        local nm = Instance.new("TextLabel", container)
        nm.Size = UDim2.new(1, 0, 0.25, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBlack
        nm.Text = player.Name
        nm.TextColor3 = col.cyan
        nm.TextScaled = true

        local hpLabel = Instance.new("TextLabel", container)
        hpLabel.Position = UDim2.new(0, 0, 0.25, 0)
        hpLabel.Size = UDim2.new(1, 0, 0.2, 0)
        hpLabel.BackgroundTransparency = 1
        hpLabel.Font = Enum.Font.Gotham
        hpLabel.Text = "HP: 100/100"
        hpLabel.TextColor3 = col.health
        hpLabel.TextScaled = true

        local hpBg = Instance.new("Frame", container)
        hpBg.Position = UDim2.new(0.05, 0, 0.48, 0)
        hpBg.Size = UDim2.new(0.9, 0, 0.1, 0)
        hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        hpBg.BorderSizePixel = 0
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 3)

        local hpBar = Instance.new("Frame", hpBg)
        hpBar.Size = UDim2.new(1, 0, 1, 0)
        hpBar.BackgroundColor3 = col.health
        hpBar.BorderSizePixel = 0
        Instance.new("UICorner", hpBar).CornerRadius = UDim.new(0, 3)

        local dst = Instance.new("TextLabel", container)
        dst.Position = UDim2.new(0, 0, 0.6, 0)
        dst.Size = UDim2.new(1, 0, 0.2, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textDim
        dst.TextScaled = true

        local toolLabel = Instance.new("TextLabel", container)
        toolLabel.Position = UDim2.new(0, 0, 0.8, 0)
        toolLabel.Size = UDim2.new(1, 0, 0.2, 0)
        toolLabel.BackgroundTransparency = 1
        toolLabel.Font = Enum.Font.Gotham
        toolLabel.Text = "🔫 None"
        toolLabel.TextColor3 = col.warning
        toolLabel.TextScaled = true

        espData[player] = {
            obj = bb, 
            dist = dst, 
            hpBar = hpBar, 
            hpLabel = hpLabel, 
            toolLabel = toolLabel,
            hum = hum, 
            char = ch,
            container = container,
            stroke = stroke,
            type = "fullinfo"
        }

    -- MODE 15: Chams ESP
    elseif cfg.espMode == 15 then
        local chams = {}
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local box = Instance.new("BoxHandleAdornment", part)
                box.Name = "ChamsESP"
                box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Color3 = isSelected and col.selected or col.purple
                box.Transparency = 0.5
                table.insert(chams, box)
            end
        end

        espData[player] = {chams = chams, char = ch, type = "chams"}

    -- MODE 16: Distance Ring ESP
    elseif cfg.espMode == 16 then
        local ring = Instance.new("CylinderHandleAdornment", hrp)
        ring.Name = "RingESP"
        ring.Height = 0.2
        ring.Radius = 2
        ring.Adornee = hrp
        ring.AlwaysOnTop = true
        ring.Color3 = isSelected and col.selected or col.orange
        ring.Transparency = 0.3
        ring.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), 0, 0)

        espData[player] = {obj = ring, type = "ring"}

    -- MODE 17: 3D Text ESP
    elseif cfg.espMode == 17 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.Name = "TextESP"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 100, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3, 0)

        local name = Instance.new("TextLabel", bb)
        name.Size = UDim2.new(1, 0, 0.5, 0)
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.GothamBlack
        name.Text = player.Name
        name.TextColor3 = isSelected and col.selected or col.text
        name.TextScaled = true
        name.TextStrokeTransparency = 0

        local dist = Instance.new("TextLabel", bb)
        dist.Position = UDim2.new(0, 0, 0.5, 0)
        dist.Size = UDim2.new(1, 0, 0.5, 0)
        dist.BackgroundTransparency = 1
        dist.Font = Enum.Font.Gotham
        dist.TextColor3 = col.textDim
        dist.TextScaled = true
        dist.TextStrokeTransparency = 0

        espData[player] = {obj = bb, dist = dist, name = name, type = "text3d"}

    -- MODE 18: Radar Blip ESP
    elseif cfg.espMode == 18 then
        local blip = Drawing.new("Circle")
        blip.Visible = true
        blip.Color = isSelected and col.selected or col.cyan
        blip.Radius = isSelected and 6 or 4
        blip.Filled = true
        blip.Thickness = 1
        blip.Transparency = 0.9

        local line = Drawing.new("Line")
        line.Visible = true
        line.Color = isSelected and col.selected or col.cyan
        line.Thickness = isSelected and 2 or 1
        line.Transparency = 0.7

        espData[player] = {blip = blip, line = line, hrp = hrp, type = "radar"}

    -- MODE 19: Icon ESP
    elseif cfg.espMode == 19 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.Name = "IconESP"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 50, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)

        local icon = Instance.new("TextLabel", bb)
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Font = Enum.Font.GothamBold
        icon.Text = isSelected and "⭐" or "👤"
        icon.TextColor3 = isSelected and col.selected or col.text
        icon.TextScaled = true

        espData[player] = {obj = bb, icon = icon, type = "icon"}

    -- MODE 20: Advanced Box ESP
    elseif cfg.espMode == 20 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Name = "AdvancedBoxESP"
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSelected and col.selected or col.textDim
        box.Transparency = 0.5

        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 80, 0, 25)
        bb.StudsOffset = Vector3.new(0, ch:GetExtentsSize().Y / 2 + 1, 0)

        local name = Instance.new("TextLabel", bb)
        name.Size = UDim2.new(1, 0, 0.6, 0)
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.GothamBold
        name.Text = player.Name
        name.TextColor3 = isSelected and col.selected or col.text
        name.TextScaled = true
        name.TextStrokeTransparency = 0

        local dist = Instance.new("TextLabel", bb)
        dist.Position = UDim2.new(0, 0, 0.6, 0)
        dist.Size = UDim2.new(1, 0, 0.4, 0)
        dist.BackgroundTransparency = 1
        dist.Font = Enum.Font.Gotham
        dist.TextColor3 = col.textDim
        dist.TextScaled = true
        dist.TextStrokeTransparency = 0

        espData[player] = {obj = box, billboard = bb, dist = dist, name = name, type = "advancedbox"}
    end
end

local function updateESP()
    local localHRP = char and char:FindFirstChild("HumanoidRootPart")
    
    for player, data in pairs(espData) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end
        
        local hrp = player.Character.HumanoidRootPart
        local head = player.Character:FindFirstChild("Head")
        local hum = player.Character:FindFirstChild("Humanoid")
        local dist = localHRP and (hrp.Position - localHRP.Position).Magnitude or 0
        local isSelected = (cfg.selectedPlayer == player)

        local rainbow = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)

        -- Update selection colors
        if data.type == "nametag" and data.bg then
            data.bg.BackgroundColor3 = isSelected and col.selected or col.bg
        elseif data.type == "box" then
            data.obj.Color3 = isSelected and col.selected or (cfg.espRgb and rainbow or col.textDim)
        elseif data.type == "highlight" then
            data.obj.FillColor = isSelected and col.selected or (cfg.espRgb and rainbow or col.textDim)
        elseif data.type == "tracer" then
            data.obj.Color = isSelected and col.selected or (cfg.espRgb and rainbow or col.cyan)
            data.obj.Thickness = isSelected and 2.5 or 1.5
        elseif data.type == "healthbar" and data.container then
            data.container.BackgroundColor3 = isSelected and col.selected or col.bg
        elseif data.type == "fullinfo" and data.stroke then
            data.stroke.Color = isSelected and col.selected or col.cyan
            data.stroke.Thickness = isSelected and 3 or 2
        end

        -- Update distance
        if data.dist then
            data.dist.Text = math.floor(dist) .. "m"
        end

        -- Update health bar
        if data.hpBar and hum then
            local hpPercent = hum.Health / hum.MaxHealth
            data.hpBar.Size = UDim2.new(math.clamp(hpPercent, 0, 1), 0, 1, 0)
            data.hpBar.BackgroundColor3 = Color3.fromRGB(
                255 * (1 - hpPercent),
                255 * hpPercent,
                0
            )
        end

        if data.hpLabel and hum then
            data.hpLabel.Text = "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
        end

        if data.toolLabel then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            data.toolLabel.Text = tool and ("🔫 " .. tool.Name) or "🔫 None"
        end

        -- Update tracer
        if data.type == "tracer" then
            local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                data.obj.Visible = true
                data.obj.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                data.obj.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                data.obj.Visible = false
            end
        end

        -- Update dot
        if data.type == "dot" and head then
            local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
            if onScreen then
                data.obj.Visible = true
                data.obj.Position = Vector2.new(screenPos.X, screenPos.Y)
            else
                data.obj.Visible = false
            end
        end

        -- Update skeleton
        if data.type == "skeleton" then
            for _, bone in ipairs(data.bones) do
                local part1 = data.char:FindFirstChild(bone.part1)
                local part2 = data.char:FindFirstChild(bone.part2)
                if part1 and part2 then
                    local pos1, on1 = cam:WorldToViewportPoint(part1.Position)
                    local pos2, on2 = cam:WorldToViewportPoint(part2.Position)
                    if on1 and on2 then
                        bone.line.Visible = true
                        bone.line.From = Vector2.new(pos1.X, pos1.Y)
                        bone.line.To = Vector2.new(pos2.X, pos2.Y)
                        if cfg.espRgb then bone.line.Color = rainbow end
                    else
                        bone.line.Visible = false
                    end
                else
                    bone.line.Visible = false
                end
            end
        end

        -- Update head circle
        if data.type == "headcircle" and head then
            local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
            if onScreen then
                local scaleFactor = 1 / (screenPos.Z * 0.1)
                data.circle.Visible = true
                data.circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                data.circle.Radius = math.clamp(50 * scaleFactor, 5, 30)
                
                data.name.Visible = true
                data.name.Position = Vector2.new(screenPos.X, screenPos.Y - data.circle.Radius - 15)
                
                if cfg.espRgb then 
                    data.circle.Color = rainbow 
                end
            else
                data.circle.Visible = false
                data.name.Visible = false
            end
        end

        -- Update arrow
        if data.type == "arrow" then
            local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if not onScreen then
                data.obj.Visible = true
                local center = cam.ViewportSize / 2
                local direction = (Vector2.new(screenPos.X, screenPos.Y) - center).Unit
                local arrowPos = center + direction * 100
                
                local angle = math.atan2(direction.Y, direction.X)
                local size = 15
                
                data.obj.PointA = arrowPos + Vector2.new(math.cos(angle) * size, math.sin(angle) * size)
                data.obj.PointB = arrowPos + Vector2.new(math.cos(angle + 2.5) * size * 0.6, math.sin(angle + 2.5) * size * 0.6)
                data.obj.PointC = arrowPos + Vector2.new(math.cos(angle - 2.5) * size * 0.6, math.sin(angle - 2.5) * size * 0.6)
                
                if cfg.espRgb then data.obj.Color = rainbow end
            else
                data.obj.Visible = false
            end
        end

        -- Update radar
        if data.type == "radar" and localHRP then
            local radarSize = 150
            local radarCenter = Vector2.new(100, cam.ViewportSize.Y - 100)
            
            local relative = hrp.Position - localHRP.Position
            local distance = relative.Magnitude
            local maxDistance = 500
            
            if distance < maxDistance then
                local scale = math.clamp(distance / maxDistance, 0, 1)
                local angle = math.atan2(relative.Z, relative.X)
                
                local x = radarCenter.X + math.cos(angle) * (radarSize / 2) * scale
                local y = radarCenter.Y + math.sin(angle) * (radarSize / 2) * scale
                
                data.blip.Visible = true
                data.blip.Position = Vector2.new(x, y)
                
                data.line.Visible = true
                data.line.From = radarCenter
                data.line.To = Vector2.new(x, y)
                
                if cfg.espRgb then
                    data.blip.Color = rainbow
                    data.line.Color = rainbow
                end
            else
                data.blip.Visible = false
                data.line.Visible = false
            end
        end

        -- RGB effect
        if cfg.espRgb then
            if data.type == "box" or data.type == "circle" or data.type == "sphere" or data.type == "ring" then
                data.obj.Color3 = rainbow
            elseif data.type == "beam" then
                data.obj.Color = ColorSequence.new(rainbow)
            elseif data.type == "chams" then
                for _, cham in ipairs(data.chams) do
                    cham.Color3 = rainbow
                end
            end
        end
    end
end

local function getClosest()
    local closest = nil
    local minD = cfg.aimfov
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < minD then
                        closest = p
                        minD = d
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
    notify("anti afk on")
end

local function teleportToPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            notify("teleported to " .. player.Name)
        end
    end
end

-- HOME TAB
local homePage = pages["home"]

sectionLabel(homePage, "PLAYER")

local pCard = Instance.new("Frame", homePage)
pCard.BackgroundColor3 = col.card
pCard.BorderSizePixel = 0
pCard.Size = UDim2.new(1, 0, 0, 48)

Instance.new("UICorner", pCard).CornerRadius = UDim.new(0, 5)

local avatar = Instance.new("ImageLabel", pCard)
avatar.BackgroundColor3 = col.elevated
avatar.BorderSizePixel = 0
avatar.Position = UDim2.new(0, 8, 0.5, 0)
avatar.AnchorPoint = Vector2.new(0, 0.5)
avatar.Size = UDim2.new(0, 32, 0, 32)

Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 5)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local pName = Instance.new("TextLabel", pCard)
pName.BackgroundTransparency = 1
pName.Position = UDim2.new(0, 46, 0, 8)
pName.Size = UDim2.new(1, -56, 0, 14)
pName.Font = Enum.Font.GothamBold
pName.Text = plr.Name
pName.TextColor3 = col.text
pName.TextSize = 11
pName.TextXAlignment = Enum.TextXAlignment.Left

local gName = Instance.new("TextLabel", pCard)
gName.BackgroundTransparency = 1
gName.Position = UDim2.new(0, 46, 0, 24)
gName.Size = UDim2.new(1, -56, 0, 12)
gName.Font = Enum.Font.Gotham
gName.Text = "Violence District"
gName.TextColor3 = col.textDim
gName.TextSize = 9
gName.TextXAlignment = Enum.TextXAlignment.Left

sectionLabel(homePage, "INFO")

local iCard = Instance.new("Frame", homePage)
iCard.BackgroundColor3 = col.card
iCard.BorderSizePixel = 0
iCard.Size = UDim2.new(1, 0, 0, 54)

Instance.new("UICorner", iCard).CornerRadius = UDim.new(0, 5)

local iGrid = Instance.new("UIGridLayout", iCard)
iGrid.CellSize = UDim2.new(0.333, -6, 1, -8)
iGrid.CellPadding = UDim2.new(0, 4, 0, 0)
iGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
iGrid.VerticalAlignment = Enum.VerticalAlignment.Center

local function infoItem(val, label)
    local item = Instance.new("Frame", iCard)
    item.BackgroundColor3 = col.elevated
    item.BorderSizePixel = 0

    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 3)

    local vL = Instance.new("TextLabel", item)
    vL.BackgroundTransparency = 1
    vL.Position = UDim2.new(0, 0, 0, 6)
    vL.Size = UDim2.new(1, 0, 0, 16)
    vL.Font = Enum.Font.GothamBold
    vL.Text = val
    vL.TextColor3 = col.text
    vL.TextSize = 12

    local nL = Instance.new("TextLabel", item)
    nL.BackgroundTransparency = 1
    nL.Position = UDim2.new(0, 0, 0, 24)
    nL.Size = UDim2.new(1, 0, 0, 12)
    nL.Font = Enum.Font.Gotham
    nL.Text = label
    nL.TextColor3 = col.textDim
    nL.TextSize = 8
end

infoItem("20", "ESP modes")
infoItem("v3", "version")
infoItem("ix-prem", "status")

sectionLabel(homePage, "CREDITS")

local cCard = Instance.new("Frame", homePage)
cCard.BackgroundColor3 = col.card
cCard.BorderSizePixel = 0
cCard.Size = UDim2.new(1, 0, 0, 34)

Instance.new("UICorner", cCard).CornerRadius = UDim.new(0, 5)

local cL = Instance.new("TextLabel", cCard)
cL.BackgroundTransparency = 1
cL.Size = UDim2.new(1, 0, 1, 0)
cL.Font = Enum.Font.Gotham
cL.Text = "made by ikaxzu"
cL.TextColor3 = col.textDim
cL.TextSize = 9

-- COMBAT TAB
local combatPage = pages["combat"]

sectionLabel(combatPage, "PROTECTION")
createToggle(combatPage, "God Mode", function(v)
    cfg.god = v
    if v then enableGod() else disableGod() end
end)

sectionLabel(combatPage, "AIMBOT")
createToggle(combatPage, "Auto Aim", function(v)
    cfg.aim = v
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosest()
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

createSlider(combatPage, "FOV Size", 50, 350, 100, function(v) cfg.aimfov = v end)

createToggle(combatPage, "Kill Aura", function(v)
    cfg.killaura = v
    if v then
        conn.aura = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d < 15 then
                        for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                            if r:IsA("RemoteEvent") and r.Name:lower():find("attack") then
                                pcall(function() r:FireServer(p.Character) end)
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

-- MOVE TAB
local movePage = pages["move"]

sectionLabel(movePage, "SPEED")
createSlider(movePage, "Walk Speed", 16, 350, 16, function(v) cfg.speed = v end)
createSlider(movePage, "Jump Power", 50, 350, 50, function(v) cfg.jump = v end)

sectionLabel(movePage, "MOVEMENT")
createToggle(movePage, "Noclip", function(v)
    cfg.noclip = v
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
        notify("noclip on")
    else
        if conn.noclip then conn.noclip:Disconnect() conn.noclip = nil end
        notify("noclip off")
    end
end)

-- VISUAL TAB
local visualPage = pages["visual"]

sectionLabel(visualPage, "WORLD")
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

sectionLabel(visualPage, "CHARACTER")

createToggle(visualPage, "Invisible", function(v)
    cfg.invisible = v
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = v and 1 or 0
        end
    end
end)

sectionLabel(visualPage, "MISC")
createToggle(visualPage, "Anti AFK", function(v)
    cfg.antiAfk = v
    if v then setupAntiAFK() end
end)

-- ESP TAB
local espPage = pages["esp"]

sectionLabel(espPage, "ESP CONTROL")
createToggle(espPage, "Enable ESP", function(v)
    cfg.esp = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    else
        clearESP()
    end
end)

createToggle(espPage, "RGB Effect", function(v) cfg.espRgb = v end)

sectionLabel(espPage, "ESP MODES")

local espModes = {
    {1, "Name Tag"},
    {2, "Box"},
    {3, "Highlight"},
    {4, "Tracer"},
    {5, "Dot"},
    {6, "Health Bar"},
    {7, "Skeleton"},
    {8, "Circle"},
    {9, "Arrow"},
    {10, "Beam"},
    {11, "Corner Box"},
    {12, "Head Circle"},
    {13, "Glow Sphere"},
    {14, "Full Info"},
    {15, "Chams"},
    {16, "Distance Ring"},
    {17, "3D Text"},
    {18, "Radar Blip"},
    {19, "Icon"},
    {20, "Advanced Box"}
}

for i = 1, #espModes, 2 do
    local row = Instance.new("Frame", espPage)
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 28)

    local rowLayout = Instance.new("UIListLayout", row)
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 3)

    local btn1 = createButton(row, espModes[i][2], function()
        cfg.espMode = espModes[i][1]
        clearESP()
        if cfg.esp then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr then createESP(p) end
            end
        end
        notify("esp: " .. espModes[i][2]:lower())
    end)
    btn1.Size = UDim2.new(0.5, -2, 0, 28)

    if espModes[i + 1] then
        local btn2 = createButton(row, espModes[i + 1][2], function()
            cfg.espMode = espModes[i + 1][1]
            clearESP()
            if cfg.esp then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= plr then createESP(p) end
                end
            end
            notify("esp: " .. espModes[i + 1][2]:lower())
        end)
        btn2.Size = UDim2.new(0.5, -2, 0, 28)
    end
end

-- PLAYERS TAB
local playersPage = pages["players"]

sectionLabel(playersPage, "PLAYER LIST")

local playerListContainer = Instance.new("Frame", playersPage)
playerListContainer.BackgroundColor3 = col.card
playerListContainer.BorderSizePixel = 0
playerListContainer.Size = UDim2.new(1, 0, 0, 200)

Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 5)

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 4, 0, 4)
playerListScroll.Size = UDim2.new(1, -8, 1, -8)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 2
playerListScroll.ScrollBarImageColor3 = col.border

local playerListLayout = Instance.new("UIListLayout", playerListScroll)
playerListLayout.Padding = UDim.new(0, 2)

playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerListScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 4)
end)

local function updatePlayerList()
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local btn = Instance.new("TextButton", playerListScroll)
            btn.BackgroundColor3 = cfg.selectedPlayer == player and col.selected or col.elevated
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Font = Enum.Font.Gotham
            btn.Text = " " .. player.Name
            btn.TextColor3 = col.text
            btn.TextSize = 10
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false

            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            local selectIcon = Instance.new("TextLabel", btn)
            selectIcon.BackgroundTransparency = 1
            selectIcon.Position = UDim2.new(1, -30, 0, 0)
            selectIcon.Size = UDim2.new(0, 30, 1, 0)
            selectIcon.Font = Enum.Font.GothamBold
            selectIcon.Text = cfg.selectedPlayer == player and "✓" or ""
            selectIcon.TextColor3 = col.text
            selectIcon.TextSize = 14

            btn.MouseButton1Click:Connect(function()
                if cfg.selectedPlayer == player then
                    cfg.selectedPlayer = nil
                    notify("deselected " .. player.Name)
                else
                    cfg.selectedPlayer = player
                    notify("selected " .. player.Name)
                end
                
                -- Refresh ESP
                if cfg.esp then
                    clearESP()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= plr then createESP(p) end
                    end
                end
                
                updatePlayerList()
            end)

            btn.MouseEnter:Connect(function()
                if cfg.selectedPlayer ~= player then
                    TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover}):Play()
                end
            end)
            btn.MouseLeave:Connect(function()
                if cfg.selectedPlayer ~= player then
                    TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = col.elevated}):Play()
                end
            end)
        end
    end
end

updatePlayerList()

sectionLabel(playersPage, "SELECTED PLAYER ACTIONS")

createButton(playersPage, "Teleport to Player", function()
    if cfg.selectedPlayer then
        teleportToPlayer(cfg.selectedPlayer)
    else
        notify("no player selected", 2)
    end
end)

createButton(playersPage, "Spectate Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        cam.CameraSubject = cfg.selectedPlayer.Character.Humanoid
        notify("spectating " .. cfg.selectedPlayer.Name)
    else
        notify("no player selected", 2)
    end
end)

createButton(playersPage, "Stop Spectate", function()
    cam.CameraSubject = char.Humanoid
    notify("stopped spectating")
end)

createButton(playersPage, "Clear Selection", function()
    cfg.selectedPlayer = nil
    if cfg.esp then
        clearESP()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    updatePlayerList()
    notify("selection cleared")
end)

-- EVENTS
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
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

    if cfg.esp then updateESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESP(p) end
        if activeTab == "players" then updatePlayerList() end
    end)
    if activeTab == "players" then updatePlayerList() end
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        if espData[p].obj then
            pcall(function() espData[p].obj:Destroy() end)
        end
        espData[p] = nil
    end
    if cfg.selectedPlayer == p then
        cfg.selectedPlayer = nil
    end
    if activeTab == "players" then updatePlayerList() end
end)

plr.CharacterAdded:Connect(function(ch)
    char = ch
    task.wait(1)

    if cfg.god then enableGod() end
    if cfg.noclip then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
    if cfg.vip then enableVIP() end
end)

task.wait(0.15)
notify("ikaxzu v3 loaded")
notify("20 ESP modes available")
warn("ikaxzu scripter v3 ready")
