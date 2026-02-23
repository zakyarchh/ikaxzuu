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

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

-- Colors
local c = {
    bg = Color3.fromRGB(8, 8, 12),
    panel = Color3.fromRGB(14, 14, 20),
    card = Color3.fromRGB(18, 18, 26),
    cardHover = Color3.fromRGB(24, 24, 34),
    accent = Color3.fromRGB(108, 92, 231),
    accentDark = Color3.fromRGB(88, 72, 211),
    green = Color3.fromRGB(46, 213, 115),
    red = Color3.fromRGB(255, 71, 87),
    orange = Color3.fromRGB(255, 159, 67),
    blue = Color3.fromRGB(30, 144, 255),
    white = Color3.fromRGB(255, 255, 255),
    text = Color3.fromRGB(235, 235, 245),
    dim = Color3.fromRGB(100, 100, 120),
    border = Color3.fromRGB(35, 35, 50)
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ikaxzu_v3"
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Floating Button
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "Float"
floatBtn.Parent = gui
floatBtn.AnchorPoint = Vector2.new(0, 0.5)
floatBtn.BackgroundColor3 = c.panel
floatBtn.BorderSizePixel = 0
floatBtn.Position = UDim2.new(0, 12, 0.5, 0)
floatBtn.Size = UDim2.new(0, 52, 0, 52)
floatBtn.Text = ""
floatBtn.AutoButtonColor = false
floatBtn.Active = true
floatBtn.Draggable = true

local floatC = Instance.new("UICorner", floatBtn)
floatC.CornerRadius = UDim.new(0, 14)

local floatS = Instance.new("UIStroke", floatBtn)
floatS.Color = c.accent
floatS.Thickness = 2

local floatIcon = Instance.new("TextLabel", floatBtn)
floatIcon.BackgroundTransparency = 1
floatIcon.Size = UDim2.new(1, 0, 1, 0)
floatIcon.Font = Enum.Font.GothamBlack
floatIcon.Text = "VD"
floatIcon.TextColor3 = c.accent
floatIcon.TextSize = 18

local floatRing = Instance.new("Frame", floatBtn)
floatRing.Name = "Ring"
floatRing.AnchorPoint = Vector2.new(0.5, 0.5)
floatRing.BackgroundTransparency = 1
floatRing.Position = UDim2.new(0.5, 0, 0.5, 0)
floatRing.Size = UDim2.new(1, 8, 1, 8)

local ringS = Instance.new("UIStroke", floatRing)
ringS.Color = c.accent
ringS.Thickness = 1
ringS.Transparency = 0.7

local ringC = Instance.new("UICorner", floatRing)
ringC.CornerRadius = UDim.new(0, 18)

task.spawn(function()
    while floatRing.Parent do
        ringS.Transparency = 0.5 + math.sin(tick() * 2) * 0.3
        task.wait(0.03)
    end
end)

-- Main Window
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = c.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true

local mainC = Instance.new("UICorner", main)
mainC.CornerRadius = UDim.new(0, 12)

local mainS = Instance.new("UIStroke", main)
mainS.Color = c.border
mainS.Thickness = 1

-- Header
local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = c.panel
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 46)

local headerC = Instance.new("UICorner", header)
headerC.CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = c.panel
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.Size = UDim2.new(1, 0, 0, 12)

-- Logo
local logoBox = Instance.new("Frame", header)
logoBox.BackgroundColor3 = c.accent
logoBox.BorderSizePixel = 0
logoBox.Position = UDim2.new(0, 12, 0.5, 0)
logoBox.AnchorPoint = Vector2.new(0, 0.5)
logoBox.Size = UDim2.new(0, 32, 0, 32)

local logoC = Instance.new("UICorner", logoBox)
logoC.CornerRadius = UDim.new(0, 8)

local logoTxt = Instance.new("TextLabel", logoBox)
logoTxt.BackgroundTransparency = 1
logoTxt.Size = UDim2.new(1, 0, 1, 0)
logoTxt.Font = Enum.Font.GothamBlack
logoTxt.Text = "VD"
logoTxt.TextColor3 = c.white
logoTxt.TextSize = 13

-- Title
local titleBox = Instance.new("Frame", header)
titleBox.BackgroundTransparency = 1
titleBox.Position = UDim2.new(0, 52, 0, 6)
titleBox.Size = UDim2.new(0, 180, 0, 34)

local titleMain = Instance.new("TextLabel", titleBox)
titleMain.BackgroundTransparency = 1
titleMain.Size = UDim2.new(1, 0, 0, 16)
titleMain.Font = Enum.Font.GothamBlack
titleMain.Text = "ikaxzu scripter"
titleMain.TextColor3 = c.text
titleMain.TextSize = 13
titleMain.TextXAlignment = Enum.TextXAlignment.Left

local titleSub = Instance.new("TextLabel", titleBox)
titleSub.BackgroundTransparency = 1
titleSub.Position = UDim2.new(0, 0, 0, 16)
titleSub.Size = UDim2.new(1, 0, 0, 14)
titleSub.Font = Enum.Font.Gotham
titleSub.Text = "Violence District"
titleSub.TextColor3 = c.dim
titleSub.TextSize = 10
titleSub.TextXAlignment = Enum.TextXAlignment.Left

-- Version
local verBadge = Instance.new("Frame", header)
verBadge.BackgroundColor3 = c.card
verBadge.BorderSizePixel = 0
verBadge.Position = UDim2.new(0, 180, 0.5, 0)
verBadge.AnchorPoint = Vector2.new(0, 0.5)
verBadge.Size = UDim2.new(0, 36, 0, 18)

local verC = Instance.new("UICorner", verBadge)
verC.CornerRadius = UDim.new(0, 6)

local verTxt = Instance.new("TextLabel", verBadge)
verTxt.BackgroundTransparency = 1
verTxt.Size = UDim2.new(1, 0, 1, 0)
verTxt.Font = Enum.Font.GothamBold
verTxt.Text = "v3.0"
verTxt.TextColor3 = c.accent
verTxt.TextSize = 9

-- Window Controls
local ctrlBox = Instance.new("Frame", header)
ctrlBox.BackgroundTransparency = 1
ctrlBox.AnchorPoint = Vector2.new(1, 0.5)
ctrlBox.Position = UDim2.new(1, -10, 0.5, 0)
ctrlBox.Size = UDim2.new(0, 60, 0, 26)

local ctrlLayout = Instance.new("UIListLayout", ctrlBox)
ctrlLayout.FillDirection = Enum.FillDirection.Horizontal
ctrlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ctrlLayout.Padding = UDim.new(0, 6)

local function ctrlBtn(icon, col)
    local btn = Instance.new("TextButton", ctrlBox)
    btn.BackgroundColor3 = c.card
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.Text = icon
    btn.TextColor3 = col
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = c.cardHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = c.card}):Play()
    end)
    
    return btn
end

local minBtn = ctrlBtn("-", c.orange)
local closeBtn = ctrlBtn("x", c.red)

-- Tab Bar
local tabBar = Instance.new("Frame", main)
tabBar.Name = "TabBar"
tabBar.BackgroundColor3 = c.panel
tabBar.BorderSizePixel = 0
tabBar.Position = UDim2.new(0, 0, 0, 46)
tabBar.Size = UDim2.new(1, 0, 0, 38)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 4)

-- Content
local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 10, 0, 92)
content.Size = UDim2.new(1, -20, 1, -102)

-- Notification
local notifBox = Instance.new("Frame", gui)
notifBox.Name = "Notifs"
notifBox.AnchorPoint = Vector2.new(0.5, 0)
notifBox.BackgroundTransparency = 1
notifBox.Position = UDim2.new(0.5, 0, 0, 10)
notifBox.Size = UDim2.new(0, 300, 0, 200)

local notifLayout = Instance.new("UIListLayout", notifBox)
notifLayout.Padding = UDim.new(0, 6)
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function notify(msg, dur)
    local n = Instance.new("Frame", notifBox)
    n.BackgroundColor3 = c.panel
    n.BorderSizePixel = 0
    n.Size = UDim2.new(0, 0, 0, 36)
    n.ClipsDescendants = true
    
    local nc = Instance.new("UICorner", n)
    nc.CornerRadius = UDim.new(0, 8)
    
    local ns = Instance.new("UIStroke", n)
    ns.Color = c.accent
    ns.Thickness = 1
    
    local ico = Instance.new("TextLabel", n)
    ico.BackgroundTransparency = 1
    ico.Position = UDim2.new(0, 10, 0, 0)
    ico.Size = UDim2.new(0, 24, 1, 0)
    ico.Font = Enum.Font.GothamBlack
    ico.Text = "VD"
    ico.TextColor3 = c.accent
    ico.TextSize = 10
    
    local txt = Instance.new("TextLabel", n)
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 38, 0, 0)
    txt.Size = UDim2.new(1, -48, 1, 0)
    txt.Font = Enum.Font.GothamBold
    txt.Text = msg
    txt.TextColor3 = c.text
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 280, 0, 36)}):Play()
    
    task.delay(dur or 2, function()
        TweenService:Create(n, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 36)}):Play()
        task.wait(0.2)
        n:Destroy()
    end)
end

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = c.accent
fovCircle.Transparency = 0.8
fovCircle.NumSides = 60
fovCircle.Filled = false

-- Tab System
local activeTab = nil
local pages = {}
local tabBtns = {}

local tabData = {
    {name = "Home", icon = "H"},
    {name = "Combat", icon = "C"},
    {name = "Move", icon = "M"},
    {name = "Visual", icon = "V"},
    {name = "ESP", icon = "E"},
    {name = "Farm", icon = "F"},
}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = content
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = c.accent
    page.ScrollBarImageTransparency = 0.5
    page.Visible = false
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    pages[name] = page
    return page
end

for i, tab in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.name
    btn.Parent = tabBar
    btn.BackgroundColor3 = c.card
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 70, 0, 30)
    btn.Text = ""
    btn.AutoButtonColor = false
    
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 8)
    
    local ico = Instance.new("TextLabel", btn)
    ico.Name = "Icon"
    ico.BackgroundTransparency = 1
    ico.Position = UDim2.new(0, 8, 0, 0)
    ico.Size = UDim2.new(0, 18, 1, 0)
    ico.Font = Enum.Font.GothamBlack
    ico.Text = tab.icon
    ico.TextColor3 = c.dim
    ico.TextSize = 11
    
    local nm = Instance.new("TextLabel", btn)
    nm.Name = "Label"
    nm.BackgroundTransparency = 1
    nm.Position = UDim2.new(0, 26, 0, 0)
    nm.Size = UDim2.new(1, -30, 1, 0)
    nm.Font = Enum.Font.GothamBold
    nm.Text = tab.name
    nm.TextColor3 = c.dim
    nm.TextSize = 10
    nm.TextXAlignment = Enum.TextXAlignment.Left
    
    local line = Instance.new("Frame", btn)
    line.Name = "Line"
    line.BackgroundColor3 = c.accent
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0.5, 0, 1, -2)
    line.AnchorPoint = Vector2.new(0.5, 0)
    line.Size = UDim2.new(0, 0, 0, 2)
    
    local lc = Instance.new("UICorner", line)
    lc.CornerRadius = UDim.new(1, 0)
    
    local page = createPage(tab.name)
    tabBtns[tab.name] = btn
    
    btn.MouseButton1Click:Connect(function()
        for name, b in pairs(tabBtns) do
            b.BackgroundTransparency = 1
            b.Icon.TextColor3 = c.dim
            b.Label.TextColor3 = c.dim
            TweenService:Create(b.Line, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 2)}):Play()
            pages[name].Visible = false
        end
        
        btn.BackgroundTransparency = 0
        ico.TextColor3 = c.accent
        nm.TextColor3 = c.text
        TweenService:Create(line, TweenInfo.new(0.2), {Size = UDim2.new(0.7, 0, 0, 2)}):Play()
        page.Visible = true
        activeTab = tab.name
    end)
    
    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.name then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.name then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end)
    
    if i == 1 then
        btn.BackgroundTransparency = 0
        ico.TextColor3 = c.accent
        nm.TextColor3 = c.text
        line.Size = UDim2.new(0.7, 0, 0, 2)
        page.Visible = true
        activeTab = tab.name
    end
end

-- UI Components
local function section(parent, text)
    local s = Instance.new("Frame", parent)
    s.BackgroundTransparency = 1
    s.Size = UDim2.new(1, 0, 0, 22)
    
    local ln = Instance.new("Frame", s)
    ln.BackgroundColor3 = c.accent
    ln.BorderSizePixel = 0
    ln.Position = UDim2.new(0, 0, 0.5, 0)
    ln.AnchorPoint = Vector2.new(0, 0.5)
    ln.Size = UDim2.new(0, 3, 0, 14)
    
    local lnc = Instance.new("UICorner", ln)
    lnc.CornerRadius = UDim.new(1, 0)
    
    local t = Instance.new("TextLabel", s)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 10, 0, 0)
    t.Size = UDim2.new(1, -10, 1, 0)
    t.Font = Enum.Font.GothamBlack
    t.Text = text:upper()
    t.TextColor3 = c.accent
    t.TextSize = 10
    t.TextXAlignment = Enum.TextXAlignment.Left
end

local function toggle(parent, text, callback)
    local state = false
    
    local f = Instance.new("TextButton", parent)
    f.BackgroundColor3 = c.card
    f.BorderSizePixel = 0
    f.Size = UDim2.new(1, 0, 0, 40)
    f.Text = ""
    f.AutoButtonColor = false
    
    local fc = Instance.new("UICorner", f)
    fc.CornerRadius = UDim.new(0, 8)
    
    local t = Instance.new("TextLabel", f)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 14, 0, 0)
    t.Size = UDim2.new(1, -60, 1, 0)
    t.Font = Enum.Font.GothamBold
    t.Text = text
    t.TextColor3 = c.dim
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    
    local sw = Instance.new("Frame", f)
    sw.AnchorPoint = Vector2.new(1, 0.5)
    sw.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sw.BorderSizePixel = 0
    sw.Position = UDim2.new(1, -12, 0.5, 0)
    sw.Size = UDim2.new(0, 38, 0, 20)
    
    local swc = Instance.new("UICorner", sw)
    swc.CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", sw)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = c.dim
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0, 3, 0.5, 0)
    dot.Size = UDim2.new(0, 14, 0, 14)
    
    local dotc = Instance.new("UICorner", dot)
    dotc.CornerRadius = UDim.new(1, 0)
    
    f.MouseButton1Click:Connect(function()
        state = not state
        
        if state then
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = UDim2.new(1, -17, 0.5, 0), BackgroundColor3 = c.white}):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = c.green}):Play()
            TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = c.text}):Play()
        else
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = c.dim}):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
            TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = c.dim}):Play()
        end
        
        pcall(callback, state)
    end)
    
    f.MouseEnter:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = c.cardHover}):Play()
    end)
    f.MouseLeave:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = c.card}):Play()
    end)
end

local function slider(parent, text, min, max, def, callback)
    local val = def
    local dragging = false
    
    local f = Instance.new("Frame", parent)
    f.BackgroundColor3 = c.card
    f.BorderSizePixel = 0
    f.Size = UDim2.new(1, 0, 0, 52)
    
    local fc = Instance.new("UICorner", f)
    fc.CornerRadius = UDim.new(0, 8)
    
    local t = Instance.new("TextLabel", f)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 14, 0, 6)
    t.Size = UDim2.new(0.6, 0, 0, 16)
    t.Font = Enum.Font.GothamBold
    t.Text = text
    t.TextColor3 = c.text
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    
    local v = Instance.new("TextLabel", f)
    v.BackgroundColor3 = c.accent
    v.BorderSizePixel = 0
    v.Position = UDim2.new(1, -54, 0, 6)
    v.Size = UDim2.new(0, 40, 0, 16)
    v.Font = Enum.Font.GothamBlack
    v.Text = tostring(def)
    v.TextColor3 = c.white
    v.TextSize = 10
    
    local vc = Instance.new("UICorner", v)
    vc.CornerRadius = UDim.new(0, 6)
    
    local track = Instance.new("Frame", f)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 14, 0, 32)
    track.Size = UDim2.new(1, -28, 0, 10)
    
    local tc = Instance.new("UICorner", track)
    tc.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = c.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    
    local fillc = Instance.new("UICorner", fill)
    fillc.CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", fill)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = c.white
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    
    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", track)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    
    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pos)
        TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        v.Text = tostring(val)
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
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3 = c.accent
    b.BorderSizePixel = 0
    b.Size = UDim2.new(1, 0, 0, 36)
    b.Text = text
    b.TextColor3 = c.white
    b.TextSize = 11
    b.Font = Enum.Font.GothamBlack
    b.AutoButtonColor = false
    
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = c.accentDark}):Play()
        task.wait(0.08)
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = c.accent}):Play()
        pcall(callback)
    end)
    
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 38)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    end)
end

-- FUNCTIONS
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
    barrier.Color = c.accent
    barrier.CanCollide = false
    barrier.Anchored = false
    barrier.Massless = true
    
    local weld = Instance.new("WeldConstraint", barrier)
    weld.Part0 = hrp
    weld.Part1 = barrier
    
    conn.godH = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
    end)
    
    conn.godC = RunService.Heartbeat:Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
        for _, v in pairs(hum:GetChildren()) do
            if v:IsA("NumberValue") then v:Destroy() end
        end
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    
    conn.godP = RunService.Stepped:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:match("kill") or n:match("death") or n:match("lava") or n:match("trap") then
                    pcall(function() obj.CanTouch = false; obj.CanCollide = false end)
                end
            end
        end
    end)
    
    local lastPos = hrp.CFrame
    conn.godV = RunService.Heartbeat:Connect(function()
        if hrp.Position.Y > -50 then lastPos = hrp.CFrame end
        if hrp.Position.Y < -100 then hrp.CFrame = lastPos end
    end)
    
    conn.godT = barrier.Touched:Connect(function(hit)
        if hit and hit.Parent and not hit.Parent:FindFirstChild("Humanoid") then
            pcall(function() hit.CanTouch = false end)
        end
    end)
    
    notify("God Mode ON")
end

local function disableGod()
    if not immortal then return end
    immortal = false
    
    for n, con in pairs(conn) do
        if con then pcall(function() con:Disconnect() end) end
        conn[n] = nil
    end
    
    local hum = char:FindFirstChild("RealHumanoid")
    if hum then hum.Name = "Humanoid"; hum.Health = 100; hum.MaxHealth = 100 end
    
    local shield = char:FindFirstChild("Shield")
    if shield then shield:Destroy() end
    
    notify("God Mode OFF")
end

local function isRareItem(obj)
    local n = obj.Name:lower()
    if n:match("divine") then return "Divine" end
    if n:match("celestial") then return "Celestial" end
    if n:match("infinity") then return "Infinity" end
    
    for _, attr in pairs(obj:GetAttributes()) do
        local a = tostring(attr):lower()
        if a:match("divine") then return "Divine" end
        if a:match("celestial") then return "Celestial" end
        if a:match("infinity") then return "Infinity" end
    end
    
    for _, ch in pairs(obj:GetChildren()) do
        if ch:IsA("StringValue") then
            local v = tostring(ch.Value):lower()
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
                if rn:match("collect") or rn:match("pickup") then
                    v:FireServer(item)
                end
            end
        end
        
        notify("Farmed: " .. item.Name)
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
    notify("VIP Remover ON")
end

local function disableVIP()
    if conn.vip then conn.vip:Disconnect(); conn.vip = nil end
    removedObjects = {}
end

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
        wing.Color = c.accent
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
    
    notify("Wings ON")
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
    haloModel.Color = c.accent
    haloModel.Transparency = 0.2
    haloModel.CanCollide = false
    haloModel.Massless = true
    
    local light = Instance.new("PointLight", haloModel)
    light.Brightness = 2
    light.Color = c.accent
    light.Range = 10
    
    local weld = Instance.new("Weld", haloModel)
    weld.Part0 = head
    weld.Part1 = haloModel
    weld.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, math.rad(90))
    
    conn.halo = RunService.RenderStepped:Connect(function()
        weld.C0 = weld.C0 * CFrame.Angles(0, math.rad(2), 0)
    end)
    
    notify("Halo ON")
end

local function removeHalo()
    if haloModel then haloModel:Destroy(); haloModel = nil end
    if conn.halo then conn.halo:Disconnect(); conn.halo = nil end
end

local function clearESP()
    for _, data in pairs(espData) do
        if data.obj then data.obj:Destroy() end
    end
    espData = {}
end

local function createESP(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local h = ch:FindFirstChild("HumanoidRootPart")
    if not h then return end
    
    if cfg.espMode == 1 then
        local b = Instance.new("BillboardGui", h)
        b.AlwaysOnTop = true
        b.Size = UDim2.new(0, 80, 0, 30)
        b.StudsOffset = Vector3.new(0, 2.5, 0)
        
        local f = Instance.new("Frame", b)
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = c.panel
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        
        local s = Instance.new("UIStroke", f)
        s.Color = c.accent
        s.Thickness = 1
        
        local n = Instance.new("TextLabel", f)
        n.Size = UDim2.new(1, 0, 0.5, 0)
        n.BackgroundTransparency = 1
        n.Font = Enum.Font.GothamBold
        n.Text = player.Name
        n.TextColor3 = c.text
        n.TextSize = 10
        n.TextScaled = true
        
        local d = Instance.new("TextLabel", f)
        d.Position = UDim2.new(0, 0, 0.5, 0)
        d.Size = UDim2.new(1, 0, 0.5, 0)
        d.BackgroundTransparency = 1
        d.Font = Enum.Font.Gotham
        d.TextColor3 = c.dim
        d.TextSize = 9
        d.TextScaled = true
        
        espData[player] = {obj = b, dist = d, frame = f, stroke = s}
        
    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", h)
        box.Size = ch:GetExtentsSize()
        box.Adornee = h
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = c.accent
        box.Transparency = 0.5
        
        espData[player] = {obj = box}
        
    elseif cfg.espMode == 3 then
        local hl = Instance.new("Highlight", ch)
        hl.FillColor = c.accent
        hl.OutlineColor = c.white
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
                local col = Color3.fromHSV(hue, 1, 1)
                if data.stroke then data.stroke.Color = col end
                if data.obj and data.obj:IsA("BoxHandleAdornment") then data.obj.Color3 = col end
                if data.obj and data.obj:IsA("Highlight") then data.obj.FillColor = col; data.obj.OutlineColor = col end
            end
        end
    end
end

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

local function enableAntiAfk()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    notify("Anti AFK ON")
end

-- HOME TAB
local homePage = pages["Home"]

section(homePage, "Player Info")

local infoCard = Instance.new("Frame", homePage)
infoCard.BackgroundColor3 = c.card
infoCard.BorderSizePixel = 0
infoCard.Size = UDim2.new(1, 0, 0, 70)

local infoC = Instance.new("UICorner", infoCard)
infoC.CornerRadius = UDim.new(0, 10)

local avatar = Instance.new("ImageLabel", infoCard)
avatar.BackgroundColor3 = c.accent
avatar.BorderSizePixel = 0
avatar.Position = UDim2.new(0, 12, 0.5, 0)
avatar.AnchorPoint = Vector2.new(0, 0.5)
avatar.Size = UDim2.new(0, 46, 0, 46)

local avatarC = Instance.new("UICorner", avatar)
avatarC.CornerRadius = UDim.new(0, 10)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local playerName = Instance.new("TextLabel", infoCard)
playerName.BackgroundTransparency = 1
playerName.Position = UDim2.new(0, 68, 0, 12)
playerName.Size = UDim2.new(1, -78, 0, 20)
playerName.Font = Enum.Font.GothamBlack
playerName.Text = plr.Name
playerName.TextColor3 = c.text
playerName.TextSize = 14
playerName.TextXAlignment = Enum.TextXAlignment.Left

local gameInfo = Instance.new("TextLabel", infoCard)
gameInfo.BackgroundTransparency = 1
gameInfo.Position = UDim2.new(0, 68, 0, 34)
gameInfo.Size = UDim2.new(1, -78, 0, 14)
gameInfo.Font = Enum.Font.Gotham
gameInfo.Text = "Violence District"
gameInfo.TextColor3 = c.dim
gameInfo.TextSize = 11
gameInfo.TextXAlignment = Enum.TextXAlignment.Left

section(homePage, "Script Status")

local statsCard = Instance.new("Frame", homePage)
statsCard.BackgroundColor3 = c.card
statsCard.BorderSizePixel = 0
statsCard.Size = UDim2.new(1, 0, 0, 80)

local statsC = Instance.new("UICorner", statsCard)
statsC.CornerRadius = UDim.new(0, 10)

local statusGrid = Instance.new("UIGridLayout", statsCard)
statusGrid.CellSize = UDim2.new(0.33, -6, 1, -16)
statusGrid.CellPadding = UDim2.new(0, 6, 0, 0)
statusGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
statusGrid.VerticalAlignment = Enum.VerticalAlignment.Center

local function statBox(name, value, col)
    local box = Instance.new("Frame", statsCard)
    box.BackgroundColor3 = c.bg
    box.BorderSizePixel = 0
    
    local boxC = Instance.new("UICorner", box)
    boxC.CornerRadius = UDim.new(0, 8)
    
    local valLabel = Instance.new("TextLabel", box)
    valLabel.BackgroundTransparency = 1
    valLabel.Position = UDim2.new(0, 0, 0, 8)
    valLabel.Size = UDim2.new(1, 0, 0, 24)
    valLabel.Font = Enum.Font.GothamBlack
    valLabel.Text = value
    valLabel.TextColor3 = col
    valLabel.TextSize = 18
    
    local nameLabel = Instance.new("TextLabel", box)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 0, 0, 34)
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = name
    nameLabel.TextColor3 = c.dim
    nameLabel.TextSize = 9
end

statBox("Features", "20+", c.accent)
statBox("Version", "3.0", c.green)
statBox("Status", "Active", c.blue)

section(homePage, "Credits")

local creditsCard = Instance.new("Frame", homePage)
creditsCard.BackgroundColor3 = c.card
creditsCard.BorderSizePixel = 0
creditsCard.Size = UDim2.new(1, 0, 0, 50)

local creditsC = Instance.new("UICorner", creditsCard)
creditsC.CornerRadius = UDim.new(0, 10)

local creditsText = Instance.new("TextLabel", creditsCard)
creditsText.BackgroundTransparency = 1
creditsText.Size = UDim2.new(1, 0, 1, 0)
creditsText.Font = Enum.Font.GothamBold
creditsText.Text = "ikaxzu scripter v3.0\nMade for Violence District"
creditsText.TextColor3 = c.dim
creditsText.TextSize = 11

-- COMBAT TAB
local combatPage = pages["Combat"]

section(combatPage, "Protection")
toggle(combatPage, "God Mode", function(v)
    cfg.god = v
    if v then enableGod() else disableGod() end
end)

section(combatPage, "Aimbot")
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

-- MOVE TAB
local movePage = pages["Move"]

section(movePage, "Speed")
slider(movePage, "Walk Speed", 16, 500, 16, function(v) cfg.speed = v end)
slider(movePage, "Jump Power", 50, 500, 50, function(v) cfg.jump = v end)

section(movePage, "Movement")
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
local visualPage = pages["Visual"]

section(visualPage, "World")
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

section(visualPage, "Character")
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

section(visualPage, "Utility")
toggle(visualPage, "Anti AFK", function(v)
    cfg.antiAfk = v
    if v then enableAntiAfk() end
end)

-- ESP TAB
local espPage = pages["ESP"]

section(espPage, "Player ESP")
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

section(espPage, "ESP Modes")
button(espPage, "Mode: Simple", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    notify("ESP: Simple")
end)

button(espPage, "Mode: Box", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    notify("ESP: Box")
end)

button(espPage, "Mode: Highlight", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    notify("ESP: Highlight")
end)

-- FARM TAB
local farmPage = pages["Farm"]

section(farmPage, "Auto Farm Rarity")
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

-- EVENTS
floatBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(0, 580, 0, 340)}):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.25)
    main.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.25)
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
    if cfg.wings then createWings() end
    if cfg.halo then createHalo() end
    if cfg.vip then enableVIP() end
end)

-- Load
task.wait(0.3)
notify("ikaxzu v3 loaded!")
warn("ikaxzu scripter v3 ready!")
warn("Size: 580x340 | 16:9")
