-- violence district v3
-- delta executor

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
local mouse = plr:GetMouse()

local cfg = {
    esp = false, espMode = 1, espRgb = false,
    speed = 16, jump = 50, noclip = false,
    god = false, aim = false, aimfov = 100, showfov = false,
    silentAim = false, silentNoFov = false,
    killaura = false, auraRange = 15, showAura = false,
    hitChance = 100,
    vip = false, invisible = false,
    fog = false, bright = false, fov = 70, antiAfk = false,
    selectedPlayer = nil, fly = false, flySpeed = 50
}

local conn = {}
local espData = {}
local removedObjects = {}
local immortal = false
local flying = false
local bodyGyro, bodyVel

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

local col = {
    bg = Color3.fromRGB(18, 18, 21),
    surface = Color3.fromRGB(24, 24, 28),
    card = Color3.fromRGB(32, 32, 38),
    cardHover = Color3.fromRGB(42, 42, 50),
    elevated = Color3.fromRGB(38, 38, 45),
    border = Color3.fromRGB(50, 50, 58),
    borderLight = Color3.fromRGB(65, 65, 75),
    text = Color3.fromRGB(220, 220, 225),
    textMuted = Color3.fromRGB(140, 140, 150),
    textDim = Color3.fromRGB(90, 90, 100),
    accent = Color3.fromRGB(90, 120, 150),
    accentDim = Color3.fromRGB(60, 85, 110),
    on = Color3.fromRGB(75, 140, 100),
    onDim = Color3.fromRGB(50, 95, 70),
    off = Color3.fromRGB(55, 55, 65),
    danger = Color3.fromRGB(140, 65, 70),
    warn = Color3.fromRGB(150, 125, 60)
}

local gui = Instance.new("ScreenGui")
gui.Name = "vd_" .. math.random(1000, 9999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 12, 0.5, -18)
toggleBtn.Size = UDim2.new(0, 36, 0, 36)
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Draggable = true

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = col.border
toggleStroke.Thickness = 1

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Text = "≡"
toggleIcon.TextColor3 = col.textMuted
toggleIcon.TextSize = 18

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.12), {Color = col.borderLight}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.12), {TextColor3 = col.text}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.12), {Color = col.border}):Play()
    TweenService:Create(toggleIcon, TweenInfo.new(0.12), {TextColor3 = col.textMuted}):Play()
end)

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = col.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 460, 0, 295)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = col.border
mainStroke.Thickness = 1

local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = col.surface
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 32)

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

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
titleLabel.Size = UDim2.new(0, 120, 1, 0)
titleLabel.Font = Enum.Font.GothamMedium
titleLabel.Text = "violence district"
titleLabel.TextColor3 = col.textMuted
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = col.textDim
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), {TextColor3 = col.danger}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), {TextColor3 = col.textDim}):Play()
end)

local minBtn = Instance.new("TextButton", header)
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -52, 0, 4)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = col.textDim
minBtn.TextSize = 14
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
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.Size = UDim2.new(0, 90, 1, -32)

local sidebarLine = Instance.new("Frame", sidebar)
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)

local tabList = Instance.new("Frame", sidebar)
tabList.BackgroundTransparency = 1
tabList.Position = UDim2.new(0, 5, 0, 8)
tabList.Size = UDim2.new(1, -10, 1, -16)

local tabListLayout = Instance.new("UIListLayout", tabList)
tabListLayout.Padding = UDim.new(0, 3)

local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 98, 0, 40)
content.Size = UDim2.new(1, -106, 1, -48)

local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifs"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -230, 0, 10)
notifContainer.Size = UDim2.new(0, 220, 0, 200)

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 4)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(msg, dur)
    local n = Instance.new("Frame", notifContainer)
    n.BackgroundColor3 = col.surface
    n.BorderSizePixel = 0
    n.Size = UDim2.new(0, 0, 0, 26)
    n.ClipsDescendants = true

    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", n).Color = col.border

    local t = Instance.new("TextLabel", n)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 10, 0, 0)
    t.Size = UDim2.new(1, -20, 1, 0)
    t.Font = Enum.Font.Gotham
    t.Text = msg
    t.TextColor3 = col.textMuted
    t.TextSize = 10
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTransparency = 1

    TweenService:Create(n, TweenInfo.new(0.18), {Size = UDim2.new(0, 200, 0, 26)}):Play()
    task.delay(0.06, function()
        TweenService:Create(t, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
    end)

    task.delay(dur or 2.2, function()
        TweenService:Create(t, TweenInfo.new(0.08), {TextTransparency = 1}):Play()
        task.wait(0.08)
        TweenService:Create(n, TweenInfo.new(0.12), {Size = UDim2.new(0, 0, 0, 26)}):Play()
        task.wait(0.12)
        n:Destroy()
    end)
end

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = col.textDim
fovCircle.Transparency = 0.6
fovCircle.NumSides = 50
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1
auraCircle.Color = Color3.fromRGB(120, 70, 70)
auraCircle.Transparency = 0.5
auraCircle.NumSides = 50
auraCircle.Filled = false

local pages = {}
local tabButtons = {}
local activeTab = nil

local tabs = {
    {id = "home", name = "home"},
    {id = "combat", name = "combat"},
    {id = "move", name = "movement"},
    {id = "visual", name = "visuals"},
    {id = "esp", name = "esp"},
    {id = "players", name = "players"},
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
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.Font = Enum.Font.Gotham
    btn.Text = tab.name
    btn.TextColor3 = col.textDim
    btn.TextSize = 10
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local ind = Instance.new("Frame", btn)
    ind.Name = "Ind"
    ind.BackgroundColor3 = col.accent
    ind.BorderSizePixel = 0
    ind.Position = UDim2.new(0, 0, 0.5, -4)
    ind.Size = UDim2.new(0, 2, 0, 0)

    Instance.new("UICorner", ind).CornerRadius = UDim.new(0, 1)

    local page = createPage(tab.id)
    tabButtons[tab.id] = btn

    btn.MouseButton1Click:Connect(function()
        for id, b in pairs(tabButtons) do
            b.BackgroundTransparency = 1
            b.TextColor3 = col.textDim
            TweenService:Create(b.Ind, TweenInfo.new(0.1), {Size = UDim2.new(0, 2, 0, 0)}):Play()
            pages[id].Visible = false
        end

        btn.BackgroundTransparency = 0.7
        btn.TextColor3 = col.text
        TweenService:Create(ind, TweenInfo.new(0.1), {Size = UDim2.new(0, 2, 0, 8)}):Play()
        page.Visible = true
        activeTab = tab.id
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.8}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 1}):Play()
        end
    end)

    if i == 1 then
        btn.BackgroundTransparency = 0.7
        btn.TextColor3 = col.text
        ind.Size = UDim2.new(0, 2, 0, 8)
        page.Visible = true
        activeTab = tab.id
    end
end

local function sectionLabel(parent, text)
    local c = Instance.new("Frame", parent)
    c.BackgroundTransparency = 1
    c.Size = UDim2.new(1, 0, 0, 18)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 4, 0, 2)
    l.Size = UDim2.new(1, -8, 0, 14)
    l.Font = Enum.Font.GothamMedium
    l.Text = text:upper()
    l.TextColor3 = col.textDim
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
end

local function createToggle(parent, text, callback)
    local state = false

    local c = Instance.new("TextButton", parent)
    c.BackgroundColor3 = col.card
    c.BorderSizePixel = 0
    c.Size = UDim2.new(1, 0, 0, 30)
    c.Text = ""
    c.AutoButtonColor = false

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 5)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 12, 0, 0)
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
    sw.Position = UDim2.new(1, -10, 0.5, 0)
    sw.Size = UDim2.new(0, 26, 0, 12)

    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local k = Instance.new("Frame", sw)
    k.AnchorPoint = Vector2.new(0, 0.5)
    k.BackgroundColor3 = col.textDim
    k.BorderSizePixel = 0
    k.Position = UDim2.new(0, 2, 0.5, 0)
    k.Size = UDim2.new(0, 8, 0, 8)

    Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)

    c.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(sw, TweenInfo.new(0.1), {BackgroundColor3 = col.onDim}):Play()
            TweenService:Create(k, TweenInfo.new(0.1), {Position = UDim2.new(1, -10, 0.5, 0), BackgroundColor3 = col.on}):Play()
            TweenService:Create(l, TweenInfo.new(0.1), {TextColor3 = col.text}):Play()
        else
            TweenService:Create(sw, TweenInfo.new(0.1), {BackgroundColor3 = col.off}):Play()
            TweenService:Create(k, TweenInfo.new(0.1), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = col.textDim}):Play()
            TweenService:Create(l, TweenInfo.new(0.1), {TextColor3 = col.textMuted}):Play()
        end
        pcall(callback, state)
    end)

    c.MouseEnter:Connect(function()
        TweenService:Create(c, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover}):Play()
    end)
    c.MouseLeave:Connect(function()
        TweenService:Create(c, TweenInfo.new(0.08), {BackgroundColor3 = col.card}):Play()
    end)
    
    return {
        setState = function(v)
            state = v
            if state then
                sw.BackgroundColor3 = col.onDim
                k.Position = UDim2.new(1, -10, 0.5, 0)
                k.BackgroundColor3 = col.on
                l.TextColor3 = col.text
            else
                sw.BackgroundColor3 = col.off
                k.Position = UDim2.new(0, 2, 0.5, 0)
                k.BackgroundColor3 = col.textDim
                l.TextColor3 = col.textMuted
            end
        end
    }
end

local function createSlider(parent, text, min, max, def, callback)
    local val = def
    local drag = false

    local c = Instance.new("Frame", parent)
    c.BackgroundColor3 = col.card
    c.BorderSizePixel = 0
    c.Size = UDim2.new(1, 0, 0, 38)

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 5)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 12, 0, 4)
    l.Size = UDim2.new(0.6, 0, 0, 12)
    l.Font = Enum.Font.Gotham
    l.Text = text
    l.TextColor3 = col.textMuted
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left

    local v = Instance.new("TextLabel", c)
    v.BackgroundTransparency = 1
    v.Position = UDim2.new(1, -36, 0, 4)
    v.Size = UDim2.new(0, 28, 0, 12)
    v.Font = Enum.Font.GothamMedium
    v.Text = tostring(def)
    v.TextColor3 = col.text
    v.TextSize = 10
    v.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", c)
    track.BackgroundColor3 = col.elevated
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 12, 0, 22)
    track.Size = UDim2.new(1, -24, 0, 4)

    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = col.accent
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
    b.Size = UDim2.new(1, 0, 0, 26)
    b.Font = Enum.Font.GothamMedium
    b.Text = text
    b.TextColor3 = col.textMuted
    b.TextSize = 10
    b.AutoButtonColor = false

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

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

-- ══════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ══════════════════════════════════════════════════════════════

local function clearESP()
    for player, data in pairs(espData) do
        pcall(function()
            if data.obj then
                if typeof(data.obj) == "Instance" then data.obj:Destroy()
                else data.obj:Remove() end
            end
            if data.bones then for _, b in ipairs(data.bones) do b.line:Remove() end end
            if data.corners then for _, c in ipairs(data.corners) do c[1]:Remove() c[2]:Remove() end end
            if data.chams then for _, c in ipairs(data.chams) do c:Destroy() end end
            if data.circle then data.circle:Remove() end
            if data.name then data.name:Remove() end
            if data.att0 then data.att0:Destroy() end
            if data.att1 then data.att1:Destroy() end
            if data.blip then data.blip:Remove() end
            if data.line then data.line:Remove() end
            if data.billboard then data.billboard:Destroy() end
        end)
    end
    espData = {}
end

local function enableGod()
    if immortal then return end
    immortal = true

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.Name = "H" .. math.random(100, 999)
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

    notify("god mode enabled")
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

    notify("god mode disabled")
end

local function getClosestInFOV()
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

local function getClosestPlayer()
    local closest = nil
    local minD = math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
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

local function fireHit(target)
    if not target or not target.Character then return end
    
    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local n = r.Name:lower()
            if n:find("attack") or n:find("hit") or n:find("damage") or n:find("punch") or n:find("shoot") or n:find("combat") or n:find("weapon") then
                pcall(function() 
                    r:FireServer(target.Character)
                    r:FireServer(target.Character.HumanoidRootPart)
                    r:FireServer(target)
                end)
            end
        end
    end
end

local function setupAntiAFK()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function teleportToPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            notify("teleported to " .. player.Name)
        end
    end
end

local function enableFly()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    flying = true
    
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame

    bodyVel = Instance.new("BodyVelocity", hrp)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    conn.fly = RunService.RenderStepped:Connect(function()
        if not flying then return end
        
        bodyGyro.CFrame = cam.CFrame
        
        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            bodyVel.Velocity = moveDir.Unit * cfg.flySpeed
        else
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function disableFly()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVel then bodyVel:Destroy() end
    if conn.fly then conn.fly:Disconnect() end
end

-- ══════════════════════════════════════════════════════════════
-- 20 ESP MODES
-- ══════════════════════════════════════════════════════════════

local function createESP(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChild("Humanoid")
    local head = ch:FindFirstChild("Head")
    if not hrp then return end

    local isSel = (cfg.selectedPlayer == player)
    local selCol = Color3.fromRGB(180, 160, 100)
    
    if cfg.espMode == 1 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 55, 0, 18)
        bb.StudsOffset = Vector3.new(0, 2.2, 0)

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = isSel and selCol or col.bg
        bg.BackgroundTransparency = 0.4
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 3)

        local nm = Instance.new("TextLabel", bg)
        nm.Size = UDim2.new(1, 0, 0.55, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamMedium
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

    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSel and selCol or col.textDim
        box.Transparency = 0.6

        espData[player] = {obj = box, type = "box"}

    elseif cfg.espMode == 3 then
        local hl = Instance.new("Highlight", ch)
        hl.FillColor = isSel and selCol or col.textDim
        hl.OutlineColor = col.textMuted
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.5

        espData[player] = {obj = hl, type = "highlight"}

    elseif cfg.espMode == 4 then
        local tracer = Drawing.new("Line")
        tracer.Visible = true
        tracer.Color = isSel and selCol or col.accent
        tracer.Thickness = isSel and 2 or 1
        tracer.Transparency = 0.7

        espData[player] = {obj = tracer, hrp = hrp, type = "tracer"}

    elseif cfg.espMode == 5 then
        local dot = Drawing.new("Circle")
        dot.Visible = true
        dot.Color = isSel and selCol or Color3.fromRGB(140, 90, 90)
        dot.Radius = isSel and 6 or 4
        dot.Filled = true
        dot.Transparency = 0.8

        espData[player] = {obj = dot, head = head, type = "dot"}

    elseif cfg.espMode == 6 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 70, 0, 32)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)

        local container = Instance.new("Frame", bb)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundColor3 = isSel and selCol or col.bg
        container.BackgroundTransparency = 0.35
        container.BorderSizePixel = 0
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 4)

        local nm = Instance.new("TextLabel", container)
        nm.Size = UDim2.new(1, 0, 0.45, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamMedium
        nm.Text = player.Name
        nm.TextColor3 = col.text
        nm.TextScaled = true

        local hpBg = Instance.new("Frame", container)
        hpBg.Position = UDim2.new(0.1, 0, 0.52, 0)
        hpBg.Size = UDim2.new(0.8, 0, 0.12, 0)
        hpBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        hpBg.BorderSizePixel = 0
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

        local hpBar = Instance.new("Frame", hpBg)
        hpBar.Size = UDim2.new(1, 0, 1, 0)
        hpBar.BackgroundColor3 = Color3.fromRGB(90, 140, 100)
        hpBar.BorderSizePixel = 0
        Instance.new("UICorner", hpBar).CornerRadius = UDim.new(1, 0)

        local dst = Instance.new("TextLabel", container)
        dst.Position = UDim2.new(0, 0, 0.7, 0)
        dst.Size = UDim2.new(1, 0, 0.3, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textDim
        dst.TextScaled = true

        espData[player] = {obj = bb, dist = dst, hpBar = hpBar, hum = hum, container = container, type = "healthbar"}

    elseif cfg.espMode == 7 then
        local bones = {}
        local boneConn = {
            {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"},
            {"LeftLowerArm", "LeftHand"}, {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"}, {"RightLowerLeg", "RightFoot"}
        }

        for _, c in ipairs(boneConn) do
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = isSel and selCol or col.text
            line.Thickness = isSel and 2 or 1
            line.Transparency = 0.8
            table.insert(bones, {line = line, part1 = c[1], part2 = c[2]})
        end

        espData[player] = {bones = bones, char = ch, type = "skeleton"}

    elseif cfg.espMode == 8 then
        local circle = Instance.new("CylinderHandleAdornment", hrp)
        circle.Height = 0.08
        circle.Radius = isSel and 3.5 or 2.8
        circle.Adornee = hrp
        circle.AlwaysOnTop = true
        circle.Color3 = isSel and selCol or col.accent
        circle.Transparency = 0.5
        circle.CFrame = CFrame.new(0, -3, 0)

        espData[player] = {obj = circle, type = "circle"}

    elseif cfg.espMode == 9 then
        local arrow = Drawing.new("Triangle")
        arrow.Visible = false
        arrow.Color = isSel and selCol or col.warn
        arrow.Filled = true
        arrow.Transparency = 0.8

        espData[player] = {obj = arrow, hrp = hrp, type = "arrow"}

    elseif cfg.espMode == 10 then
        local att0 = Instance.new("Attachment", hrp)
        att0.Position = Vector3.new(0, 0, 0)
        
        local att1 = Instance.new("Attachment", hrp)
        att1.Position = Vector3.new(0, 45, 0)

        local beam = Instance.new("Beam", hrp)
        beam.Attachment0 = att0
        beam.Attachment1 = att1
        beam.Width0 = isSel and 0.8 or 0.4
        beam.Width1 = isSel and 0.8 or 0.4
        beam.Color = ColorSequence.new(isSel and selCol or col.accent)
        beam.Transparency = NumberSequence.new(0.4)
        beam.LightEmission = 0.8
        beam.FaceCamera = true

        espData[player] = {obj = beam, att0 = att0, att1 = att1, type = "beam"}

    elseif cfg.espMode == 11 then
        local corners = {}
        for i = 1, 8 do
            local l1 = Drawing.new("Line")
            l1.Visible = true
            l1.Color = isSel and selCol or Color3.fromRGB(140, 90, 90)
            l1.Thickness = isSel and 2 or 1.5
            l1.Transparency = 0.8
            
            local l2 = Drawing.new("Line")
            l2.Visible = true
            l2.Color = isSel and selCol or Color3.fromRGB(140, 90, 90)
            l2.Thickness = isSel and 2 or 1.5
            l2.Transparency = 0.8
            
            table.insert(corners, {l1, l2})
        end

        espData[player] = {corners = corners, char = ch, type = "cornerbox"}

    elseif cfg.espMode == 12 then
        local hCircle = Drawing.new("Circle")
        hCircle.Visible = true
        hCircle.Color = isSel and selCol or Color3.fromRGB(150, 110, 140)
        hCircle.Radius = isSel and 12 or 8
        hCircle.Filled = false
        hCircle.Thickness = isSel and 2 or 1.5
        hCircle.Transparency = 0.8

        local nameText = Drawing.new("Text")
        nameText.Visible = true
        nameText.Color = col.text
        nameText.Text = player.Name
        nameText.Size = 13
        nameText.Center = true
        nameText.Outline = true

        espData[player] = {circle = hCircle, name = nameText, head = head, type = "headcircle"}

    elseif cfg.espMode == 13 then
        local sphere = Instance.new("SphereHandleAdornment", hrp)
        sphere.Radius = isSel and 4 or 3
        sphere.Adornee = hrp
        sphere.AlwaysOnTop = true
        sphere.Color3 = isSel and selCol or col.accent
        sphere.Transparency = 0.65

        espData[player] = {obj = sphere, type = "sphere"}

    elseif cfg.espMode == 14 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 100, 0, 65)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)

        local container = Instance.new("Frame", bb)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundColor3 = col.bg
        container.BackgroundTransparency = 0.25
        container.BorderSizePixel = 0
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke", container)
        stroke.Color = isSel and selCol or col.accent
        stroke.Thickness = isSel and 2 or 1

        local nm = Instance.new("TextLabel", container)
        nm.Size = UDim2.new(1, 0, 0.25, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBold
        nm.Text = player.Name
        nm.TextColor3 = col.text
        nm.TextScaled = true

        local hpLabel = Instance.new("TextLabel", container)
        hpLabel.Position = UDim2.new(0, 0, 0.25, 0)
        hpLabel.Size = UDim2.new(1, 0, 0.2, 0)
        hpLabel.BackgroundTransparency = 1
        hpLabel.Font = Enum.Font.Gotham
        hpLabel.Text = "100/100"
        hpLabel.TextColor3 = Color3.fromRGB(100, 150, 110)
        hpLabel.TextScaled = true

        local hpBg = Instance.new("Frame", container)
        hpBg.Position = UDim2.new(0.08, 0, 0.48, 0)
        hpBg.Size = UDim2.new(0.84, 0, 0.1, 0)
        hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        hpBg.BorderSizePixel = 0
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

        local hpBar = Instance.new("Frame", hpBg)
        hpBar.Size = UDim2.new(1, 0, 1, 0)
        hpBar.BackgroundColor3 = Color3.fromRGB(90, 140, 100)
        hpBar.BorderSizePixel = 0
        Instance.new("UICorner", hpBar).CornerRadius = UDim.new(1, 0)

        local dst = Instance.new("TextLabel", container)
        dst.Position = UDim2.new(0, 0, 0.62, 0)
        dst.Size = UDim2.new(1, 0, 0.18, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textDim
        dst.TextScaled = true

        local toolLabel = Instance.new("TextLabel", container)
        toolLabel.Position = UDim2.new(0, 0, 0.8, 0)
        toolLabel.Size = UDim2.new(1, 0, 0.18, 0)
        toolLabel.BackgroundTransparency = 1
        toolLabel.Font = Enum.Font.Gotham
        toolLabel.Text = "none"
        toolLabel.TextColor3 = col.textMuted
        toolLabel.TextScaled = true

        espData[player] = {
            obj = bb, dist = dst, hpBar = hpBar, hpLabel = hpLabel, 
            toolLabel = toolLabel, hum = hum, char = ch,
            container = container, stroke = stroke, type = "fullinfo"
        }

    elseif cfg.espMode == 15 then
        local chams = {}
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local box = Instance.new("BoxHandleAdornment", part)
                box.Size = part.Size + Vector3.new(0.04, 0.04, 0.04)
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Color3 = isSel and selCol or col.accent
                box.Transparency = 0.55
                table.insert(chams, box)
            end
        end

        espData[player] = {chams = chams, char = ch, type = "chams"}

    elseif cfg.espMode == 16 then
        local ring = Instance.new("CylinderHandleAdornment", hrp)
        ring.Height = 0.15
        ring.Radius = 2
        ring.Adornee = hrp
        ring.AlwaysOnTop = true
        ring.Color3 = isSel and selCol or Color3.fromRGB(150, 120, 80)
        ring.Transparency = 0.4
        ring.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), 0, 0)

        espData[player] = {obj = ring, type = "ring"}

    elseif cfg.espMode == 17 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 85, 0, 35)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)

        local name = Instance.new("TextLabel", bb)
        name.Size = UDim2.new(1, 0, 0.55, 0)
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.GothamBold
        name.Text = player.Name
        name.TextColor3 = isSel and selCol or col.text
        name.TextScaled = true
        name.TextStrokeTransparency = 0.5

        local dist = Instance.new("TextLabel", bb)
        dist.Position = UDim2.new(0, 0, 0.55, 0)
        dist.Size = UDim2.new(1, 0, 0.45, 0)
        dist.BackgroundTransparency = 1
        dist.Font = Enum.Font.Gotham
        dist.TextColor3 = col.textDim
        dist.TextScaled = true
        dist.TextStrokeTransparency = 0.5

        espData[player] = {obj = bb, dist = dist, nameLbl = name, type = "text3d"}

    elseif cfg.espMode == 18 then
        local blip = Drawing.new("Circle")
        blip.Visible = true
        blip.Color = isSel and selCol or col.accent
        blip.Radius = isSel and 5 or 3
        blip.Filled = true
        blip.Transparency = 0.8

        local line = Drawing.new("Line")
        line.Visible = true
        line.Color = isSel and selCol or col.accent
        line.Thickness = 1
        line.Transparency = 0.6

        espData[player] = {blip = blip, line = line, hrp = hrp, type = "radar"}

    elseif cfg.espMode == 19 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 40, 0, 40)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)

        local icon = Instance.new("TextLabel", bb)
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Font = Enum.Font.GothamBold
        icon.Text = isSel and "★" or "●"
        icon.TextColor3 = isSel and selCol or col.textMuted
        icon.TextScaled = true

        espData[player] = {obj = bb, icon = icon, type = "icon"}

    elseif cfg.espMode == 20 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSel and selCol or col.textDim
        box.Transparency = 0.55

        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 70, 0, 22)
        bb.StudsOffset = Vector3.new(0, ch:GetExtentsSize().Y / 2 + 0.8, 0)

        local name = Instance.new("TextLabel", bb)
        name.Size = UDim2.new(1, 0, 0.6, 0)
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.GothamMedium
        name.Text = player.Name
        name.TextColor3 = isSel and selCol or col.text
        name.TextScaled = true
        name.TextStrokeTransparency = 0.6

        local dist = Instance.new("TextLabel", bb)
        dist.Position = UDim2.new(0, 0, 0.6, 0)
        dist.Size = UDim2.new(1, 0, 0.4, 0)
        dist.BackgroundTransparency = 1
        dist.Font = Enum.Font.Gotham
        dist.TextColor3 = col.textDim
        dist.TextScaled = true
        dist.TextStrokeTransparency = 0.6

        espData[player] = {obj = box, billboard = bb, dist = dist, nameLbl = name, type = "advancedbox"}
    end
end

local function updateESP()
    local localHRP = char and char:FindFirstChild("HumanoidRootPart")
    
    for player, data in pairs(espData) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end
        
        local hrp = player.Character.HumanoidRootPart
        local head = player.Character:FindFirstChild("Head")
        local hum = player.Character:FindFirstChild("Humanoid")
        local dist = localHRP and (hrp.Position - localHRP.Position).Magnitude or 0
        local isSel = (cfg.selectedPlayer == player)
        local selCol = Color3.fromRGB(180, 160, 100)

        local rainbow = Color3.fromHSV(tick() % 6 / 6, 0.5, 0.8)

        if data.dist then data.dist.Text = math.floor(dist) .. "m" end

        if data.hpBar and hum then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            data.hpBar.Size = UDim2.new(hp, 0, 1, 0)
            data.hpBar.BackgroundColor3 = Color3.fromRGB(140 + 115 * (1 - hp), 140 * hp, 70 * hp)
        end

        if data.hpLabel and hum then
            data.hpLabel.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
        end

        if data.toolLabel then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            data.toolLabel.Text = tool and tool.Name or "none"
        end

        if data.type == "tracer" then
            local sp, on = cam:WorldToViewportPoint(hrp.Position)
            if on then
                data.obj.Visible = true
                data.obj.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                data.obj.To = Vector2.new(sp.X, sp.Y)
                if cfg.espRgb then data.obj.Color = rainbow end
            else
                data.obj.Visible = false
            end
        end

        if data.type == "dot" and head then
            local sp, on = cam:WorldToViewportPoint(head.Position)
            if on then
                data.obj.Visible = true
                data.obj.Position = Vector2.new(sp.X, sp.Y)
                if cfg.espRgb then data.obj.Color = rainbow end
            else
                data.obj.Visible = false
            end
        end

        if data.type == "skeleton" then
            for _, bone in ipairs(data.bones) do
                local p1 = data.char:FindFirstChild(bone.part1)
                local p2 = data.char:FindFirstChild(bone.part2)
                if p1 and p2 then
                    local s1, o1 = cam:WorldToViewportPoint(p1.Position)
                    local s2, o2 = cam:WorldToViewportPoint(p2.Position)
                    if o1 and o2 then
                        bone.line.Visible = true
                        bone.line.From = Vector2.new(s1.X, s1.Y)
                        bone.line.To = Vector2.new(s2.X, s2.Y)
                        if cfg.espRgb then bone.line.Color = rainbow end
                    else
                        bone.line.Visible = false
                    end
                else
                    bone.line.Visible = false
                end
            end
        end

        if data.type == "headcircle" and head then
            local sp, on = cam:WorldToViewportPoint(head.Position)
            if on then
                local sf = 1 / (sp.Z * 0.1)
                data.circle.Visible = true
                data.circle.Position = Vector2.new(sp.X, sp.Y)
                data.circle.Radius = math.clamp(45 * sf, 4, 25)
                data.name.Visible = true
                data.name.Position = Vector2.new(sp.X, sp.Y - data.circle.Radius - 12)
                if cfg.espRgb then data.circle.Color = rainbow end
            else
                data.circle.Visible = false
                data.name.Visible = false
            end
        end

        if data.type == "arrow" then
            local sp, on = cam:WorldToViewportPoint(hrp.Position)
            if not on then
                data.obj.Visible = true
                local center = cam.ViewportSize / 2
                local dir = (Vector2.new(sp.X, sp.Y) - center).Unit
                local aPos = center + dir * 90
                local ang = math.atan2(dir.Y, dir.X)
                local sz = 12
                data.obj.PointA = aPos + Vector2.new(math.cos(ang) * sz, math.sin(ang) * sz)
                data.obj.PointB = aPos + Vector2.new(math.cos(ang + 2.5) * sz * 0.55, math.sin(ang + 2.5) * sz * 0.55)
                data.obj.PointC = aPos + Vector2.new(math.cos(ang - 2.5) * sz * 0.55, math.sin(ang - 2.5) * sz * 0.55)
                if cfg.espRgb then data.obj.Color = rainbow end
            else
                data.obj.Visible = false
            end
        end

        if data.type == "radar" and localHRP then
            local radarSize = 130
            local radarCenter = Vector2.new(85, cam.ViewportSize.Y - 85)
            local relative = hrp.Position - localHRP.Position
            local distance = relative.Magnitude
            local maxDist = 450
            
            if distance < maxDist then
                local scale = math.clamp(distance / maxDist, 0, 1)
                local angle = math.atan2(relative.Z, relative.X)
                local x = radarCenter.X + math.cos(angle) * (radarSize / 2) * scale
                local y = radarCenter.Y + math.sin(angle) * (radarSize / 2) * scale
                
                data.blip.Visible = true
                data.blip.Position = Vector2.new(x, y)
                data.line.Visible = true
                data.line.From = radarCenter
                data.line.To = Vector2.new(x, y)
                if cfg.espRgb then data.blip.Color = rainbow data.line.Color = rainbow end
            else
                data.blip.Visible = false
                data.line.Visible = false
            end
        end

        if cfg.espRgb then
            if data.type == "box" or data.type == "circle" or data.type == "sphere" or data.type == "ring" then
                data.obj.Color3 = rainbow
            elseif data.type == "beam" then
                data.obj.Color = ColorSequence.new(rainbow)
            elseif data.type == "highlight" then
                data.obj.FillColor = rainbow
            elseif data.type == "chams" then
                for _, c in ipairs(data.chams) do c.Color3 = rainbow end
            end
        end
    end
end

-- ══════════════════════════════════════════════════════════════
-- HOME TAB
-- ══════════════════════════════════════════════════════════════
local homePage = pages["home"]

sectionLabel(homePage, "player info")

local pCard = Instance.new("Frame", homePage)
pCard.BackgroundColor3 = col.card
pCard.BorderSizePixel = 0
pCard.Size = UDim2.new(1, 0, 0, 44)
Instance.new("UICorner", pCard).CornerRadius = UDim.new(0, 5)

local avatar = Instance.new("ImageLabel", pCard)
avatar.BackgroundColor3 = col.elevated
avatar.BorderSizePixel = 0
avatar.Position = UDim2.new(0, 8, 0.5, 0)
avatar.AnchorPoint = Vector2.new(0, 0.5)
avatar.Size = UDim2.new(0, 28, 0, 28)
Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 4)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local pName = Instance.new("TextLabel", pCard)
pName.BackgroundTransparency = 1
pName.Position = UDim2.new(0, 42, 0, 7)
pName.Size = UDim2.new(1, -50, 0, 14)
pName.Font = Enum.Font.GothamMedium
pName.Text = plr.Name
pName.TextColor3 = col.text
pName.TextSize = 11
pName.TextXAlignment = Enum.TextXAlignment.Left

local gName = Instance.new("TextLabel", pCard)
gName.BackgroundTransparency = 1
gName.Position = UDim2.new(0, 42, 0, 22)
gName.Size = UDim2.new(1, -50, 0, 12)
gName.Font = Enum.Font.Gotham
gName.Text = "violence district"
gName.TextColor3 = col.textDim
gName.TextSize = 9
gName.TextXAlignment = Enum.TextXAlignment.Left

sectionLabel(homePage, "script info")

local iCard = Instance.new("Frame", homePage)
iCard.BackgroundColor3 = col.card
iCard.BorderSizePixel = 0
iCard.Size = UDim2.new(1, 0, 0, 50)
Instance.new("UICorner", iCard).CornerRadius = UDim.new(0, 5)

local iGrid = Instance.new("UIGridLayout", iCard)
iGrid.CellSize = UDim2.new(0.333, -5, 1, -8)
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
    vL.Position = UDim2.new(0, 0, 0, 5)
    vL.Size = UDim2.new(1, 0, 0, 15)
    vL.Font = Enum.Font.GothamBold
    vL.Text = val
    vL.TextColor3 = col.text
    vL.TextSize = 11

    local nL = Instance.new("TextLabel", item)
    nL.BackgroundTransparency = 1
    nL.Position = UDim2.new(0, 0, 0, 22)
    nL.Size = UDim2.new(1, 0, 0, 11)
    nL.Font = Enum.Font.Gotham
    nL.Text = label
    nL.TextColor3 = col.textDim
    nL.TextSize = 8
end

infoItem("25+", "features")
infoItem("20", "esp modes")
infoItem("v3", "version")

-- ══════════════════════════════════════════════════════════════
-- COMBAT TAB
-- ══════════════════════════════════════════════════════════════
local combatPage = pages["combat"]

sectionLabel(combatPage, "protection")
createToggle(combatPage, "god mode", function(v)
    cfg.god = v
    if v then enableGod() else disableGod() end
end)

sectionLabel(combatPage, "aimbot")
createToggle(combatPage, "auto aim", function(v)
    cfg.aim = v
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
        notify("auto aim enabled")
    else
        if conn.aim then conn.aim:Disconnect() conn.aim = nil end
        notify("auto aim disabled")
    end
end)

createToggle(combatPage, "show fov circle", function(v)
    cfg.showfov = v
    fovCircle.Visible = v
end)

createSlider(combatPage, "fov size", 50, 350, 100, function(v) cfg.aimfov = v end)

sectionLabel(combatPage, "silent aim")
createToggle(combatPage, "silent aim (in fov)", function(v)
    cfg.silentAim = v
    if v then
        conn.silentAim = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestInFOV()
                if target then fireHit(target) end
            end
        end)
        notify("silent aim (fov) enabled")
    else
        if conn.silentAim then conn.silentAim:Disconnect() conn.silentAim = nil end
        notify("silent aim (fov) disabled")
    end
end)

createToggle(combatPage, "silent aim (no fov)", function(v)
    cfg.silentNoFov = v
    if v then
        conn.silentNoFov = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestPlayer()
                if target then fireHit(target) end
            end
        end)
        notify("silent aim (no fov) enabled")
    else
        if conn.silentNoFov then conn.silentNoFov:Disconnect() conn.silentNoFov = nil end
        notify("silent aim (no fov) disabled")
    end
end)

sectionLabel(combatPage, "kill aura")
createToggle(combatPage, "kill aura", function(v)
    cfg.killaura = v
    if v then
        conn.aura = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d <= cfg.auraRange then
                        if math.random(1, 100) <= cfg.hitChance then
                            fireHit(p)
                        end
                    end
                end
            end
        end)
        notify("kill aura enabled")
    else
        if conn.aura then conn.aura:Disconnect() conn.aura = nil end
        notify("kill aura disabled")
    end
end)

createToggle(combatPage, "show aura range", function(v)
    cfg.showAura = v
    auraCircle.Visible = v
end)

createSlider(combatPage, "aura range (studs)", 10, 30, 15, function(v) cfg.auraRange = v end)
createSlider(combatPage, "hit chance %", 50, 100, 100, function(v) cfg.hitChance = v end)

-- ══════════════════════════════════════════════════════════════
-- MOVEMENT TAB
-- ══════════════════════════════════════════════════════════════
local movePage = pages["move"]

sectionLabel(movePage, "speed")
createSlider(movePage, "walk speed", 16, 300, 16, function(v) cfg.speed = v end)
createSlider(movePage, "jump power", 50, 300, 50, function(v) cfg.jump = v end)

sectionLabel(movePage, "movement")
createToggle(movePage, "noclip", function(v)
    cfg.noclip = v
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
        notify("noclip enabled")
    else
        if conn.noclip then conn.noclip:Disconnect() conn.noclip = nil end
        notify("noclip disabled")
    end
end)

createToggle(movePage, "fly", function(v)
    cfg.fly = v
    if v then
        enableFly()
        notify("fly enabled (wasd + space/ctrl)")
    else
        disableFly()
        notify("fly disabled")
    end
end)

createSlider(movePage, "fly speed", 20, 200, 50, function(v) cfg.flySpeed = v end)

-- ══════════════════════════════════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════════════════════════════════
local visualPage = pages["visual"]

sectionLabel(visualPage, "world")
createToggle(visualPage, "no fog", function(v)
    cfg.fog = v
    Lighting.FogEnd = v and 100000 or 1000
end)

createToggle(visualPage, "fullbright", function(v)
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

createSlider(visualPage, "field of view", 70, 120, 70, function(v)
    cfg.fov = v
    cam.FieldOfView = v
end)

sectionLabel(visualPage, "character")
createToggle(visualPage, "invisible", function(v)
    cfg.invisible = v
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = v and 1 or 0
        end
    end
end)

sectionLabel(visualPage, "misc")
createToggle(visualPage, "anti afk", function(v)
    cfg.antiAfk = v
    if v then
        setupAntiAFK()
        notify("anti afk enabled")
    end
end)

-- ══════════════════════════════════════════════════════════════
-- ESP TAB
-- ══════════════════════════════════════════════════════════════
local espPage = pages["esp"]

sectionLabel(espPage, "esp control")
createToggle(espPage, "enable esp", function(v)
    cfg.esp = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
        notify("esp enabled")
    else
        clearESP()
        notify("esp disabled")
    end
end)

createToggle(espPage, "rgb effect", function(v) cfg.espRgb = v end)

sectionLabel(espPage, "esp modes")

local espModes = {
    {1, "name tag"}, {2, "box"}, {3, "highlight"}, {4, "tracer"},
    {5, "dot"}, {6, "health bar"}, {7, "skeleton"}, {8, "circle"},
    {9, "arrow"}, {10, "beam"}, {11, "corner box"}, {12, "head circle"},
    {13, "sphere"}, {14, "full info"}, {15, "chams"}, {16, "ring"},
    {17, "3d text"}, {18, "radar"}, {19, "icon"}, {20, "advanced box"}
}

for i = 1, #espModes, 2 do
    local row = Instance.new("Frame", espPage)
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 26)

    local rowLayout = Instance.new("UIListLayout", row)
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 4)

    local btn1 = createButton(row, espModes[i][2], function()
        cfg.espMode = espModes[i][1]
        clearESP()
        if cfg.esp then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr then createESP(p) end
            end
        end
        notify("esp: " .. espModes[i][2])
    end)
    btn1.Size = UDim2.new(0.5, -2, 0, 26)

    if espModes[i + 1] then
        local btn2 = createButton(row, espModes[i + 1][2], function()
            cfg.espMode = espModes[i + 1][1]
            clearESP()
            if cfg.esp then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= plr then createESP(p) end
                end
            end
            notify("esp: " .. espModes[i + 1][2])
        end)
        btn2.Size = UDim2.new(0.5, -2, 0, 26)
    end
end

-- ══════════════════════════════════════════════════════════════
-- PLAYERS TAB
-- ══════════════════════════════════════════════════════════════
local playersPage = pages["players"]

sectionLabel(playersPage, "player list")

local playerListContainer = Instance.new("Frame", playersPage)
playerListContainer.BackgroundColor3 = col.card
playerListContainer.BorderSizePixel = 0
playerListContainer.Size = UDim2.new(1, 0, 0, 120)
Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 5)

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 4, 0, 4)
playerListScroll.Size = UDim2.new(1, -8, 1, -8)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 2
playerListScroll.ScrollBarImageColor3 = col.border

local playerListLayout = Instance.new("UIListLayout", playerListScroll)
playerListLayout.Padding = UDim.new(0, 3)

playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerListScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 4)
end)

local function updatePlayerList()
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local isSel = cfg.selectedPlayer == player
            local btn = Instance.new("TextButton", playerListScroll)
            btn.BackgroundColor3 = isSel and Color3.fromRGB(60, 55, 45) or col.elevated
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.Font = Enum.Font.Gotham
            btn.Text = "  " .. player.Name
            btn.TextColor3 = col.text
            btn.TextSize = 10
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            local selIcon = Instance.new("TextLabel", btn)
            selIcon.BackgroundTransparency = 1
            selIcon.Position = UDim2.new(1, -25, 0, 0)
            selIcon.Size = UDim2.new(0, 22, 1, 0)
            selIcon.Font = Enum.Font.GothamBold
            selIcon.Text = isSel and "●" or ""
            selIcon.TextColor3 = Color3.fromRGB(150, 135, 90)
            selIcon.TextSize = 10

            btn.MouseButton1Click:Connect(function()
                if cfg.selectedPlayer == player then
                    cfg.selectedPlayer = nil
                    notify("deselected " .. player.Name)
                else
                    cfg.selectedPlayer = player
                    notify("selected " .. player.Name)
                end
                
                if cfg.esp then
                    clearESP()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= plr then createESP(p) end
                    end
                end
                updatePlayerList()
            end)

            btn.MouseEnter:Connect(function()
                if not isSel then
                    TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = col.cardHover}):Play()
                end
            end)
            btn.MouseLeave:Connect(function()
                if not isSel then
                    TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = col.elevated}):Play()
                end
            end)
        end
    end
end

updatePlayerList()

sectionLabel(playersPage, "actions")

createButton(playersPage, "teleport to player", function()
    if cfg.selectedPlayer then
        teleportToPlayer(cfg.selectedPlayer)
    else
        notify("select a player first")
    end
end)

createButton(playersPage, "spectate player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local hum = cfg.selectedPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            cam.CameraSubject = hum
            notify("spectating " .. cfg.selectedPlayer.Name)
        end
    else
        notify("select a player first")
    end
end)

createButton(playersPage, "stop spectate", function()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        cam.CameraSubject = hum
        notify("stopped spectating")
    end
end)

createButton(playersPage, "clear selection", function()
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

createButton(playersPage, "refresh list", function()
    updatePlayerList()
    notify("list refreshed")
end)

-- ══════════════════════════════════════════════════════════════
-- EVENTS
-- ══════════════════════════════════════════════════════════════

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

    if cfg.showAura then
        auraCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        auraCircle.Radius = cfg.auraRange * 4
    end

    if cfg.esp then updateESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESP(p) end
    end)
    if activeTab == "players" then updatePlayerList() end
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        pcall(function() espData[p].obj:Destroy() end)
        espData[p] = nil
    end
    if cfg.selectedPlayer == p then cfg.selectedPlayer = nil end
    if activeTab == "players" then updatePlayerList() end
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
    if cfg.fly then enableFly() end
end)

task.wait(0.2)
notify("script loaded successfully")
