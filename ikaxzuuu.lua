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
    fog = false, bright = false, fov = 70, antiAfk = false
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
    warn = Color3.fromRGB(160, 130, 50)
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
main.Size = UDim2.new(0, 480, 0, 300)
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
end

-- FUNCTIONS

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

local function createESP(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if cfg.espMode == 1 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 60, 0, 20)
        bb.StudsOffset = Vector3.new(0, 2, 0)

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = col.bg
        bg.BackgroundTransparency = 0.35
        bg.BorderSizePixel = 0

        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 3)

        local nm = Instance.new("TextLabel", bg)
        nm.Size = UDim2.new(1, 0, 0.55, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBold
        nm.Text = player.Name
        nm.TextColor3 = col.text
        nm.TextSize = 8
        nm.TextScaled = true

        local dst = Instance.new("TextLabel", bg)
        dst.Position = UDim2.new(0, 0, 0.55, 0)
        dst.Size = UDim2.new(1, 0, 0.45, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textDim
        dst.TextSize = 7
        dst.TextScaled = true

        espData[player] = {obj = bb, dist = dst}

    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = col.textDim
        box.Transparency = 0.65

        espData[player] = {obj = box}

    elseif cfg.espMode == 3 then
        local hl = Instance.new("Highlight", ch)
        hl.FillColor = col.textDim
        hl.OutlineColor = col.textMuted
        hl.FillTransparency = 0.75
        hl.OutlineTransparency = 0.4

        espData[player] = {obj = hl}
    end
end

local function updateESP()
    for player, data in pairs(espData) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if data.dist then
                data.dist.Text = math.floor(dist) .. "m"
            end

            if cfg.espRgb then
                local hue = tick() % 5 / 5
                local rainbow = Color3.fromHSV(hue, 0.4, 0.7)
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

infoItem("19+", "features")
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

sectionLabel(espPage, "PLAYER ESP")
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

sectionLabel(espPage, "ESP MODE")
createButton(espPage, "Simple", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    notify("esp: simple")
end)

createButton(espPage, "Box", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    notify("esp: box")
end)

createButton(espPage, "Highlight", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
    notify("esp: highlight")
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
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        if espData[p].obj then
            pcall(function() espData[p].obj:Destroy() end)
        end
        espData[p] = nil
    end
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
    if cfg.wings then addWings() end
    if cfg.halo then addHalo() end
    if cfg.vip then enableVIP() end
end)

task.wait(0.15)
notify("ikaxzu v3 loaded")
warn("ikaxzu scripter v3 ready")