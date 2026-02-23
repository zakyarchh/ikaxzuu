-- Vio-- ikaxzu scripter FULL EDITION
-- Violence District - Ultimate Cheat
-- Delta X Mobile | 16:9 UI

warn("Loading ikaxzu scripter...")

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
    esp = false, espMode = 1, espRgb = false, espItems = false,
    speed = 16, jump = 50, noclip = false, fly = false, flyspeed = 50,
    god = false, aim = false, silentaim = false, aimfov = 100, showfov = false,
    spinbot = false, killaura = false, reach = false, reachdist = 15,
    fog = false, bright = false, cross = false, fov = 70,
    vip = false, wings = false, halo = false, invisible = false,
    trails = false, rgbChar = false, charSize = 1,
    farmDivine = false, farmCelestial = false, farmInfinity = false,
    autoCollect = false, antiKick = false, antiBan = false, antiAfk = false
}

local conn = {}
local espData = {}
local farmingItems = {}
local removedObjects = {}
local wingsModel, haloModel = nil, nil
local immortal = false
local oldHealth = 100

-- Parent
local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

-- Colors
local colors = {
    bg = Color3.fromRGB(12, 12, 14),
    card = Color3.fromRGB(18, 18, 22),
    accent = Color3.fromRGB(90, 90, 240),
    text = Color3.fromRGB(240, 240, 245),
    dim = Color3.fromRGB(120, 120, 130),
    dark = Color3.fromRGB(8, 8, 10),
    on = Color3.fromRGB(100, 220, 120),
    off = Color3.fromRGB(60, 60, 70)
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ikaxzu"
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
toggleBtn.BackgroundColor3 = colors.bg
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 12, 0.5, 0)
toggleBtn.Size = UDim2.new(0, 42, 0, 42)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.Text = "VD"
toggleBtn.TextColor3 = colors.accent
toggleBtn.TextSize = 14
toggleBtn.Active = true
toggleBtn.Draggable = true

local toggleC = Instance.new("UICorner", toggleBtn)
toggleC.CornerRadius = UDim.new(0, 10)

local toggleS = Instance.new("UIStroke", toggleBtn)
toggleS.Color = colors.accent
toggleS.Thickness = 1.5
toggleS.Transparency = 0.5

-- Main Frame (16:9 Ratio - 560x315)
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = colors.bg
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
mainS.Color = Color3.fromRGB(40, 40, 50)
mainS.Thickness = 1

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = main
header.BackgroundColor3 = colors.card
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 42)

local headerC = Instance.new("UICorner", header)
headerC.CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = colors.card
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.Size = UDim2.new(1, 0, 0, 12)

-- Logo
local logo = Instance.new("TextLabel")
logo.Parent = header
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0, 14, 0, 0)
logo.Size = UDim2.new(0, 36, 1, 0)
logo.Font = Enum.Font.GothamBlack
logo.Text = "VD"
logo.TextColor3 = colors.accent
logo.TextSize = 18

-- Title
local title = Instance.new("TextLabel")
title.Parent = header
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 52, 0, 5)
title.Size = UDim2.new(0, 200, 0, 16)
title.Font = Enum.Font.GothamBold
title.Text = "ikaxzu scripter"
title.TextColor3 = colors.text
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel")
subtitle.Parent = header
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 52, 0, 21)
subtitle.Size = UDim2.new(0, 200, 0, 14)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Violence District"
subtitle.TextColor3 = colors.dim
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Parent = header
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.BackgroundColor3 = colors.off
closeBtn.BorderSizePixel = 0
closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "x"
closeBtn.TextColor3 = colors.dim
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false

local closeC = Instance.new("UICorner", closeBtn)
closeC.CornerRadius = UDim.new(0, 6)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Name = "Min"
minBtn.Parent = header
minBtn.AnchorPoint = Vector2.new(1, 0.5)
minBtn.BackgroundColor3 = colors.off
minBtn.BorderSizePixel = 0
minBtn.Position = UDim2.new(1, -42, 0.5, 0)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "-"
minBtn.TextColor3 = colors.dim
minBtn.TextSize = 16
minBtn.AutoButtonColor = false

local minC = Instance.new("UICorner", minBtn)
minC.CornerRadius = UDim.new(0, 6)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Parent = main
sidebar.BackgroundColor3 = colors.card
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.Size = UDim2.new(0, 90, 1, -42)

local sidebarC = Instance.new("UICorner", sidebar)
sidebarC.CornerRadius = UDim.new(0, 12)

local sidebarFix = Instance.new("Frame", sidebar)
sidebarFix.BackgroundColor3 = colors.card
sidebarFix.BorderSizePixel = 0
sidebarFix.Position = UDim2.new(1, -12, 0, 0)
sidebarFix.Size = UDim2.new(0, 12, 1, 0)

local sidebarFix2 = Instance.new("Frame", sidebar)
sidebarFix2.BackgroundColor3 = colors.card
sidebarFix2.BorderSizePixel = 0
sidebarFix2.Position = UDim2.new(0, 0, 0, 0)
sidebarFix2.Size = UDim2.new(1, 0, 0, 12)

local tabList = Instance.new("Frame")
tabList.Parent = sidebar
tabList.BackgroundTransparency = 1
tabList.Position = UDim2.new(0, 0, 0, 8)
tabList.Size = UDim2.new(1, 0, 1, -8)

local tabLayout = Instance.new("UIListLayout", tabList)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Name = "Content"
contentArea.Parent = main
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0, 98, 0, 50)
contentArea.Size = UDim2.new(1, -106, 1, -58)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = colors.accent
fovCircle.Transparency = 0.8
fovCircle.NumSides = 64
fovCircle.Filled = false

-- Tab System
local activeTab = nil
local pages = {}

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Parent = tabList
    tabBtn.BackgroundColor3 = colors.card
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.AutoButtonColor = false
    tabBtn.Text = ""
    
    local tabIcon = Instance.new("TextLabel", tabBtn)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Position = UDim2.new(0, 10, 0, 0)
    tabIcon.Size = UDim2.new(0, 20, 1, 0)
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.Text = icon
    tabIcon.TextColor3 = colors.dim
    tabIcon.TextSize = 12
    
    local tabName = Instance.new("TextLabel", tabBtn)
    tabName.BackgroundTransparency = 1
    tabName.Position = UDim2.new(0, 32, 0, 0)
    tabName.Size = UDim2.new(1, -32, 1, 0)
    tabName.Font = Enum.Font.Gotham
    tabName.Text = name
    tabName.TextColor3 = colors.dim
    tabName.TextSize = 10
    tabName.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame", tabBtn)
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = colors.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.Size = UDim2.new(0, 3, 0.7, 0)
    indicator.Visible = false
    
    local indC = Instance.new("UICorner", indicator)
    indC.CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = contentArea
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = colors.accent
    page.ScrollBarImageTransparency = 0.7
    page.Visible = false
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 5)
    
    local pagePad = Instance.new("UIPadding", page)
    pagePad.PaddingRight = UDim.new(0, 4)
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 8)
    end)
    
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn:FindFirstChild("Indicator").Visible = false
                for _, child in pairs(btn:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child.TextColor3 = colors.dim
                    end
                end
            end
        end
        for _, pg in pairs(pages) do
            pg.Visible = false
        end
        
        indicator.Visible = true
        tabIcon.TextColor3 = colors.accent
        tabName.TextColor3 = colors.text
        page.Visible = true
        activeTab = name
    end)
    
    if not activeTab then
        indicator.Visible = true
        tabIcon.TextColor3 = colors.accent
        tabName.TextColor3 = colors.text
        page.Visible = true
        activeTab = name
    end
    
    return page
end

-- UI Components
local function section(parent, text)
    local sec = Instance.new("TextLabel")
    sec.Parent = parent
    sec.BackgroundTransparency = 1
    sec.Size = UDim2.new(1, 0, 0, 20)
    sec.Font = Enum.Font.GothamBold
    sec.Text = text
    sec.TextColor3 = colors.accent
    sec.TextSize = 10
    sec.TextXAlignment = Enum.TextXAlignment.Left
end

local function toggle(parent, text, callback)
    local state = false
    
    local frame = Instance.new("TextButton")
    frame.Parent = parent
    frame.BackgroundColor3 = colors.card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.AutoButtonColor = false
    frame.Text = ""
    
    local frameC = Instance.new("UICorner", frame)
    frameC.CornerRadius = UDim.new(0, 6)
    
    local txt = Instance.new("TextLabel", frame)
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.Size = UDim2.new(1, -50, 1, 0)
    txt.Font = Enum.Font.Gotham
    txt.Text = text
    txt.TextColor3 = colors.dim
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local switch = Instance.new("Frame", frame)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = colors.off
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -8, 0.5, 0)
    switch.Size = UDim2.new(0, 32, 0, 16)
    
    local switchC = Instance.new("UICorner", switch)
    switchC.CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", switch)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = colors.dim
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0, 2, 0.5, 0)
    dot.Size = UDim2.new(0, 12, 0, 12)
    
    local dotC = Instance.new("UICorner", dot)
    dotC.CornerRadius = UDim.new(1, 0)
    
    frame.MouseButton1Click:Connect(function()
        state = not state
        
        if state then
            TweenService:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = colors.text}):Play()
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = colors.on}):Play()
            TweenService:Create(txt, TweenInfo.new(0.15), {TextColor3 = colors.text}):Play()
        else
            TweenService:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = colors.dim}):Play()
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = colors.off}):Play()
            TweenService:Create(txt, TweenInfo.new(0.15), {TextColor3 = colors.dim}):Play()
        end
        
        pcall(callback, state)
    end)
end

local function slider(parent, text, min, max, def, callback)
    local val = def
    local dragging = false
    
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = colors.card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 44)
    
    local frameC = Instance.new("UICorner", frame)
    frameC.CornerRadius = UDim.new(0, 6)
    
    local txt = Instance.new("TextLabel", frame)
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 10, 0, 4)
    txt.Size = UDim2.new(0.6, 0, 0, 14)
    txt.Font = Enum.Font.Gotham
    txt.Text = text
    txt.TextColor3 = colors.dim
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local value = Instance.new("TextLabel", frame)
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(0.6, 0, 0, 4)
    value.Size = UDim2.new(0.4, -10, 0, 14)
    value.Font = Enum.Font.GothamBold
    value.Text = tostring(def)
    value.TextColor3 = colors.accent
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("Frame", frame)
    track.BackgroundColor3 = colors.off
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 10, 0, 26)
    track.Size = UDim2.new(1, -20, 0, 8)
    
    local trackC = Instance.new("UICorner", track)
    trackC.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = colors.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    
    local fillC = Instance.new("UICorner", fill)
    fillC.CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", track)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    
    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
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
    btn.BackgroundColor3 = colors.accent
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = colors.text
    btn.TextSize = 11
    
    local btnC = Instance.new("UICorner", btn)
    btnC.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 120, 255)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
        pcall(callback)
    end)
end

-- GOD MODE
local function enableGod()
    if immortal then return end
    immortal = true
    
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    oldHealth = hum.Health
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
    barrier.Color = colors.accent
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
    
    warn("[God] Enabled")
end

local function disableGod()
    if not immortal then return end
    immortal = false
    
    for name, c in pairs(conn) do
        if c then pcall(function() c:Disconnect() end) end
        conn[name] = nil
    end
    
    local hum = char:FindFirstChild("RealHumanoid")
    if hum then
        hum.Name = "Humanoid"
        hum.Health = oldHealth
        hum.MaxHealth = 100
    end
    
    local shield = char:FindFirstChild("Shield")
    if shield then shield:Destroy() end
    
    warn("[God] Disabled")
end

-- AUTO FARM RARITY
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
        
        warn("[Farm] Collected:", item.Name)
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
                if n:match("vip") or n:match("premium") or n:match("gamepass") or n:match("robux") or n:match("safe") then
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
        wing.Color = colors.text
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
    haloModel.Color = colors.accent
    haloModel.Transparency = 0.2
    haloModel.CanCollide = false
    haloModel.Massless = true
    
    local light = Instance.new("PointLight", haloModel)
    light.Brightness = 2
    light.Color = colors.accent
    light.Range = 10
    
    local weld = Instance.new("Weld", haloModel)
    weld.Part0 = head
    weld.Part1 = haloModel
    weld.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, math.rad(90))
    
    conn.halo = RunService.RenderStepped:Connect(function()
        weld.C0 = weld.C0 * CFrame.Angles(0, math.rad(2), 0)
    end)
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
        b.Size = UDim2.new(0, 80, 0, 32)
        b.StudsOffset = Vector3.new(0, 2.5, 0)
        
        local f = Instance.new("Frame", b)
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = colors.bg
        f.BackgroundTransparency = 0.3
        f.BorderSizePixel = 0
        
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
        
        local n = Instance.new("TextLabel", f)
        n.Size = UDim2.new(1, 0, 0.5, 0)
        n.BackgroundTransparency = 1
        n.Font = Enum.Font.GothamBold
        n.Text = player.Name
        n.TextColor3 = colors.text
        n.TextSize = 10
        n.TextScaled = true
        
        local d = Instance.new("TextLabel", f)
        d.Position = UDim2.new(0, 0, 0.5, 0)
        d.Size = UDim2.new(1, 0, 0.5, 0)
        d.BackgroundTransparency = 1
        d.Font = Enum.Font.Gotham
        d.TextColor3 = colors.dim
        d.TextSize = 9
        d.TextScaled = true
        
        espData[player] = {obj = b, dist = d, frame = f}
        
    elseif cfg.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment", h)
        box.Size = c:GetExtentsSize()
        box.Adornee = h
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = colors.accent
        box.Transparency = 0.5
        
        espData[player] = {obj = box}
        
    elseif cfg.espMode == 3 then
        local hl = Instance.new("Highlight", c)
        hl.FillColor = colors.accent
        hl.OutlineColor = colors.text
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
                if data.frame then data.frame.BackgroundColor3 = color end
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

-- ANTI CHEAT
local function enableAntiAfk()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        warn("[AFK] Prevented")
    end)
end

-- CREATE TABS
local combatPage = createTab("Combat", "1")
local movePage = createTab("Move", "2")
local visualPage = createTab("Visual", "3")
local espPage = createTab("ESP", "4")
local farmPage = createTab("Farm", "5")
local miscPage = createTab("Misc", "6")

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

toggle(combatPage, "Show FOV", function(v)
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
section(movePage, "SPEED")
slider(movePage, "Walk Speed", 16, 500, 16, function(v) cfg.speed = v end)
slider(movePage, "Jump Power", 50, 500, 50, function(v) cfg.jump = v end)

section(movePage, "MOVEMENT")
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

toggle(movePage, "Fly", function(v)
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
section(visualPage, "WORLD")
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

section(visualPage, "COSMETICS")
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
        if p:IsA("BasePart") then p.Transparency = v and 1 or 0 end
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
toggle(farmPage, "VIP Remover", function(v)
    cfg.vip = v
    if v then enableVIP() else disableVIP() end
end)

section(farmPage, "TELEPORT")
button(farmPage, "TP to Closest", function()
    local target = getClosestInFOV()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

button(farmPage, "TP to Random", function()
    local ps = Players:GetPlayers()
    if #ps > 1 then
        local rnd = ps[math.random(1, #ps)]
        if rnd ~= plr and rnd.Character and rnd.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = rnd.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- MISC TAB
section(miscPage, "PROTECTION")
toggle(miscPage, "Anti AFK", function(v)
    cfg.antiAfk = v
    if v then enableAntiAfk() end
end)

section(miscPage, "SERVER")
button(miscPage, "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

button(miscPage, "Copy Game ID", function()
    setclipboard(tostring(game.PlaceId))
    warn("Game ID copied!")
end)

section(miscPage, "CREDITS")
local credit = Instance.new("TextLabel")
credit.Parent = miscPage
credit.BackgroundTransparency = 1
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Font = Enum.Font.Gotham
credit.Text = "ikaxzu scripter\nMade for Violence District"
credit.TextColor3 = colors.dim
credit.TextSize = 10

-- EVENTS
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 560, 0, 315)}):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    main.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
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

warn("ikaxzu scripter loaded!")
warn("UI: 16:9 | 560x315")
