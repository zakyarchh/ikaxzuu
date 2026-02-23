-- Violence District-- ikaxzu scripter FULL EDITION
-- Violence District - Ultimate Cheat
-- Delta X Optimized | ALL FEATURES

warn("Loading ikaxzu scripter FULL EDITION...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

-- Config
local settings = {
    esp = false,
    espMode = 1,
    espRgb = false,
    espItems = false,
    espWeapons = false,
    espVehicles = false,
    espSpawns = false,
    speed = 16,
    jump = 50,
    noclip = false,
    fly = false,
    flyspeed = 50,
    god = false,
    aim = false,
    silentaim = false,
    aimfov = 100,
    showfov = false,
    spinbot = false,
    killaura = false,
    reach = false,
    reachdist = 15,
    fog = false,
    bright = false,
    cross = false,
    fov = 70,
    vipremove = false,
    wings = false,
    halo = false,
    invisible = false,
    autoFarm = false,
    autoCollect = false,
    farmDivine = false,
    farmCelestial = false,
    farmInfinity = false,
    antiKick = false,
    antiBan = false,
    antiAfk = false,
    trails = false,
    rgbChar = false,
    sizeChanger = false,
    charSize = 1
}

local connections = {}
local espData = {}
local itemESP = {}
local waypoints = {}
local oldHealth = 0
local immortal = false
local removedObjects = {}
local wingsModel = nil
local haloModel = nil
local farmingItems = {}
local lastPosition = nil

-- Get Parent
local function getParent()
    if pcall(function() gethui() end) then
        return gethui()
    end
    return CoreGui
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ikaxzu"
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Toggle Button
local toggle = Instance.new("ImageButton")
toggle.Name = "Toggle"
toggle.Parent = gui
toggle.AnchorPoint = Vector2.new(0, 0.5)
toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggle.BorderSizePixel = 0
toggle.Position = UDim2.new(0, 15, 0.5, 0)
toggle.Size = UDim2.new(0, 45, 0, 45)
toggle.Image = "rbxassetid://3926305904"
toggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggle.ImageRectOffset = Vector2.new(644, 364)
toggle.ImageRectSize = Vector2.new(36, 36)
toggle.Active = true
toggle.Draggable = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.8
toggleStroke.Parent = toggle

-- Main
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.9
mainStroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = main
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 35)

local title = Instance.new("TextLabel")
title.Parent = header
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 12, 0, 0)
title.Size = UDim2.new(1, -50, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "ikaxzu scripter FULL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("ImageButton")
close.Name = "Close"
close.Parent = header
close.AnchorPoint = Vector2.new(1, 0)
close.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
close.BorderSizePixel = 0
close.Position = UDim2.new(1, -8, 0, 8)
close.Size = UDim2.new(0, 20, 0, 20)
close.Image = "rbxassetid://3926305904"
close.ImageColor3 = Color3.fromRGB(255, 255, 255)
close.ImageRectOffset = Vector2.new(284, 4)
close.ImageRectSize = Vector2.new(24, 24)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = close

-- Tabs
local tabContainer = Instance.new("Frame")
tabContainer.Name = "Tabs"
tabContainer.Parent = main
tabContainer.BackgroundTransparency = 1
tabContainer.Position = UDim2.new(0, 0, 0, 35)
tabContainer.Size = UDim2.new(1, 0, 0, 30)

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabContainer
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, 3)

local activePage = nil
local pages = {}

local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = tabContainer
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(0, 70, 1, -5)
    tabBtn.AutoButtonColor = false
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.TextSize = 9
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabBtn
    
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = main
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Position = UDim2.new(0, 8, 0, 73)
    page.Size = UDim2.new(1, -16, 1, -81)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    page.ScrollBarImageTransparency = 0.9
    page.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)
    
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
        for _, pg in pairs(pages) do
            pg.Visible = false
        end
        
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
        activePage = name
    end)
    
    if not activePage then
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
        activePage = name
    end
    
    return page
end

-- Divider
local div = Instance.new("Frame")
div.Parent = main
div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
div.BackgroundTransparency = 0.95
div.BorderSizePixel = 0
div.Position = UDim2.new(0, 0, 0, 65)
div.Size = UDim2.new(1, 0, 0, 1)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 1
fovCircle.NumSides = 64
fovCircle.Filled = false

-- UI Elements
local function label(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 0.4
end

local function toggle_option(parent, text, callback)
    local state = false
    
    local frame = Instance.new("TextButton")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.AutoButtonColor = false
    frame.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local txt = Instance.new("TextLabel")
    txt.Parent = frame
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.Size = UDim2.new(1, -45, 1, 0)
    txt.Font = Enum.Font.Gotham
    txt.Text = text
    txt.TextColor3 = Color3.fromRGB(200, 200, 200)
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame")
    indicator.Parent = frame
    indicator.AnchorPoint = Vector2.new(1, 0.5)
    indicator.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(1, -8, 0.5, 0)
    indicator.Size = UDim2.new(0, 30, 0, 16)
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
    
    local dot = Instance.new("Frame")
    dot.Parent = indicator
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0, 2, 0.5, 0)
    dot.Size = UDim2.new(0, 12, 0, 12)
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    
    frame.MouseButton1Click:Connect(function()
        state = not state
        
        if state then
            TweenService:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            TweenService:Create(txt, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            TweenService:Create(txt, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        
        pcall(callback, state)
    end)
end

local function slider(parent, text, min, max, def, callback)
    local val = def
    local dragging = false
    
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 42)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local txt = Instance.new("TextLabel")
    txt.Parent = frame
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 10, 0, 4)
    txt.Size = UDim2.new(0.7, 0, 0, 14)
    txt.Font = Enum.Font.Gotham
    txt.Text = text
    txt.TextColor3 = Color3.fromRGB(200, 200, 200)
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local value = Instance.new("TextLabel")
    value.Parent = frame
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(0, 10, 0, 4)
    value.Size = UDim2.new(1, -20, 0, 14)
    value.Font = Enum.Font.GothamBold
    value.Text = tostring(def)
    value.TextColor3 = Color3.fromRGB(255, 255, 255)
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("Frame")
    track.Parent = frame
    track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 10, 0, 24)
    track.Size = UDim2.new(1, -20, 0, 10)
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local btn = Instance.new("TextButton")
    btn.Parent = track
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
    
    btn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
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
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
        pcall(callback)
    end)
end

-- ANTI-CHEAT BYPASS
local function enableAntiKick()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            warn("[Anti-Kick] Blocked kick attempt")
            return
        end
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("[Anti-Kick] Enabled")
end

local function enableAntiBan()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:match("ban") or name:match("kick") or name:match("anticheat") then
                v:Destroy()
                print("[Anti-Ban] Removed:", v.Name)
            end
        end
    end
end

local function enableAntiAFK()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        warn("[Anti-AFK] Prevented AFK kick")
    end)
    print("[Anti-AFK] Enabled")
end

-- GOD MODE
local function enableGod()
    if immortal then return end
    immortal = true
    
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    oldHealth = hum.Health
    
    pcall(function()
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end)
    
    local fakeHum = Instance.new("Humanoid", char)
    fakeHum.Name = "FakeHumanoid"
    fakeHum.Health = 100
    fakeHum.MaxHealth = 100
    hum.Name = "RealHumanoid"
    hum.BreakJointsOnDeath = false
    
    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function()
            hum:SetStateEnabled(state, false)
        end)
    end
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    
    local barrier = Instance.new("Part")
    barrier.Name = "ProtectionField"
    barrier.Parent = char
    barrier.Size = Vector3.new(8, 8, 8)
    barrier.Shape = Enum.PartType.Ball
    barrier.Transparency = 0.98
    barrier.Material = Enum.Material.ForceField
    barrier.Color = Color3.fromRGB(255, 255, 255)
    barrier.CanCollide = false
    barrier.Anchored = false
    barrier.Massless = true
    barrier.CastShadow = false
    
    local weld = Instance.new("WeldConstraint")
    weld.Parent = barrier
    weld.Part0 = hrp
    weld.Part1 = barrier
    
    connections.healthLock = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health ~= math.huge and hum.Health < oldHealth then
            hum.Health = math.huge
        end
    end)
    
    connections.cleanEffects = RunService.Heartbeat:Connect(function()
        if hum.Health ~= math.huge then
            hum.Health = math.huge
        end
        
        for _, v in pairs(hum:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("StringValue") then
                v:Destroy()
            end
        end
        
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    
    connections.partKiller = RunService.Stepped:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:match("kill") or name:match("death") or name:match("lava") or 
                   name:match("trap") or name:match("spike") or name:match("void") or
                   name:match("hurt") or name:match("fire") or name:match("poison") or
                   name:match("damage") then
                    pcall(function()
                        obj.CanTouch = false
                        obj.CanCollide = false
                    end)
                end
            end
        end
    end)
    
    connections.scriptKill = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                if name:match("kill") or name:match("damage") or name:match("death") or name:match("anti") then
                    obj.Disabled = true
                    task.wait()
                    obj:Destroy()
                end
            end
        end
    end)
    
    local lastPos = hrp.CFrame
    connections.voidProtect = RunService.Heartbeat:Connect(function()
        if hrp.Position.Y > -50 then
            lastPos = hrp.CFrame
        end
        if hrp.Position.Y < -100 then
            hrp.CFrame = lastPos
            hum.Health = math.huge
        end
    end)
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:match("damage") or name:match("kill") or name:match("death") then
                pcall(function()
                    v:Destroy()
                end)
            end
        end
    end
    
    connections.touchBlock = barrier.Touched:Connect(function(hit)
        if hit and hit.Parent and not hit.Parent:FindFirstChild("Humanoid") then
            pcall(function()
                hit.CanTouch = false
            end)
        end
    end)
    
    connections.charProtect = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            char.Parent = Workspace
        end
    end)
    
    print("[God] Immortality Activated")
end

local function disableGod()
    if not immortal then return end
    immortal = false
    
    for name, con in pairs(connections) do
        if con then
            con:Disconnect()
        end
        connections[name] = nil
    end
    
    local hum = char:FindFirstChild("RealHumanoid")
    if hum then
        hum.Name = "Humanoid"
        hum.Health = oldHealth
        hum.MaxHealth = 100
        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            pcall(function()
                hum:SetStateEnabled(state, true)
            end)
        end
    end
    
    local fake = char:FindFirstChild("FakeHumanoid")
    if fake then fake:Destroy() end
    
    local barrier = char:FindFirstChild("ProtectionField")
    if barrier then barrier:Destroy() end
    
    print("[God] Immortality Deactivated")
end

-- AUTO FARM RARITY ITEMS
local function isRareItem(obj)
    local name = obj.Name:lower()
    local rarity = nil
    
    -- Check name
    if name:match("divine") then
        rarity = "Divine"
    elseif name:match("celestial") then
        rarity = "Celestial"
    elseif name:match("infinity") or name:match("infinite") then
        rarity = "Infinity"
    end
    
    -- Check attributes
    for _, attr in pairs(obj:GetAttributes()) do
        local attrStr = tostring(attr):lower()
        if attrStr:match("divine") then
            rarity = "Divine"
        elseif attrStr:match("celestial") then
            rarity = "Celestial"
        elseif attrStr:match("infinity") or attrStr:match("infinite") then
            rarity = "Infinity"
        end
    end
    
    -- Check children for rarity tags
    for _, child in pairs(obj:GetChildren()) do
        if child:IsA("StringValue") or child:IsA("ObjectValue") then
            local childName = child.Name:lower()
            local childValue = tostring(child.Value):lower()
            
            if childName:match("rarity") or childName:match("tier") or childName:match("rank") then
                if childValue:match("divine") then
                    rarity = "Divine"
                elseif childValue:match("celestial") then
                    rarity = "Celestial"
                elseif childValue:match("infinity") or childValue:match("infinite") then
                    rarity = "Infinity"
                end
            end
        end
    end
    
    return rarity
end

local function farmItem(item)
    if not item or not item.Parent then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    pcall(function()
        local itemPos = item:IsA("Model") and item:GetPrimaryPartCFrame().Position or item.Position
        
        -- Teleport to item
        hrp.CFrame = CFrame.new(itemPos + Vector3.new(0, 3, 0))
        
        wait(0.1)
        
        -- Try to collect
        if item:FindFirstChild("ClickDetector") then
            fireclickdetector(item.ClickDetector)
        elseif item:FindFirstChild("ProximityPrompt") then
            fireproximityprompt(item.ProximityPrompt)
        end
        
        -- Touch the item
        if item:IsA("BasePart") then
            hrp.CFrame = item.CFrame
            wait(0.1)
        end
        
        -- Fire collect event
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local name = v.Name:lower()
                if name:match("collect") or name:match("pickup") or name:match("take") or name:match("grab") then
                    v:FireServer(item)
                end
            end
        end
        
        print("[Farm] Collected:", item.Name, "- Rarity:", isRareItem(item) or "Unknown")
    end)
end

local function startAutoFarm()
    connections.autoFarm = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local rarity = isRareItem(obj)
                
                if rarity then
                    local shouldFarm = false
                    
                    if rarity == "Divine" and settings.farmDivine then
                        shouldFarm = true
                    elseif rarity == "Celestial" and settings.farmCelestial then
                        shouldFarm = true
                    elseif rarity == "Infinity" and settings.farmInfinity then
                        shouldFarm = true
                    end
                    
                    if shouldFarm and not farmingItems[obj] then
                        farmingItems[obj] = true
                        task.spawn(function()
                            farmItem(obj)
                            wait(1)
                            farmingItems[obj] = nil
                        end)
                    end
                end
            end
        end
    end)
    
    print("[Farm] Auto Farm Started")
end

local function stopAutoFarm()
    if connections.autoFarm then
        connections.autoFarm:Disconnect()
        connections.autoFarm = nil
    end
    farmingItems = {}
    print("[Farm] Auto Farm Stopped")
end

-- AUTO COLLECT
local function startAutoCollect()
    connections.autoCollect = RunService.Heartbeat:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:match("coin") or name:match("money") or name:match("cash") or 
                   name:match("gem") or name:match("crystal") or name:match("orb") or
                   name:match("item") or name:match("pickup") or name:match("collect") then
                    
                    local dist = (obj.Position - hrp.Position).Magnitude
                    if dist < 100 then
                        pcall(function()
                            obj.CFrame = hrp.CFrame
                        end)
                    end
                end
            end
        end
    end)
    
    print("[Collect] Auto Collect Started")
end

local function stopAutoCollect()
    if connections.autoCollect then
        connections.autoCollect:Disconnect()
        connections.autoCollect = nil
    end
    print("[Collect] Auto Collect Stopped")
end

-- VIP REMOVER
local vipConnection
local function enableVIPRemove()
    if vipConnection then return end
    
    vipConnection = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local name = obj.Name:lower()
                local hasBadge = obj:FindFirstChild("GamepassRequired") or 
                                 obj:FindFirstChild("VIPOnly") or 
                                 obj:FindFirstChild("PremiumOnly") or
                                 obj:FindFirstChild("BadgeRequired")
                
                if name:match("vip") or name:match("premium") or name:match("gamepass") or 
                   name:match("donate") or name:match("robux") or name:match("safe") or
                   name:match("badge") or hasBadge then
                    
                    if not removedObjects[obj] then
                        pcall(function()
                            if obj:IsA("BasePart") then
                                obj.Transparency = 1
                                obj.CanCollide = false
                                obj.CanTouch = false
                                
                                for _, child in pairs(obj:GetDescendants()) do
                                    if child:IsA("BasePart") then
                                        child.Transparency = 1
                                        child.CanCollide = false
                                        child.CanTouch = false
                                    end
                                end
                            elseif obj:IsA("Model") then
                                for _, part in pairs(obj:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.Transparency = 1
                                        part.CanCollide = false
                                        part.CanTouch = false
                                    elseif part:IsA("Decal") or part:IsA("Texture") then
                                        part.Transparency = 1
                                    elseif part:IsA("SurfaceGui") or part:IsA("BillboardGui") then
                                        part.Enabled = false
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
    
    print("[VIP] Remover Enabled")
end

local function disableVIPRemove()
    if vipConnection then
        vipConnection:Disconnect()
        vipConnection = nil
    end
    removedObjects = {}
    print("[VIP] Remover Disabled")
end

-- WINGS
local function createWings()
    if wingsModel then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    wingsModel = Instance.new("Model")
    wingsModel.Name = "AngelWings"
    wingsModel.Parent = char
    
    local leftWing = Instance.new("Part")
    leftWing.Name = "LeftWing"
    leftWing.Parent = wingsModel
    leftWing.Size = Vector3.new(0.2, 4, 2)
    leftWing.Material = Enum.Material.Neon
    leftWing.Color = Color3.fromRGB(255, 255, 255)
    leftWing.Transparency = 0.3
    leftWing.CanCollide = false
    leftWing.Massless = true
    leftWing.CastShadow = false
    
    local leftMesh = Instance.new("SpecialMesh", leftWing)
    leftMesh.MeshType = Enum.MeshType.FileMesh
    leftMesh.MeshId = "rbxassetid://2520762076"
    leftMesh.Scale = Vector3.new(1.5, 1.5, 1.5)
    
    local leftWeld = Instance.new("Weld")
    leftWeld.Parent = leftWing
    leftWeld.Part0 = hrp
    leftWeld.Part1 = leftWing
    leftWeld.C0 = CFrame.new(-1, 0.5, -0.5) * CFrame.Angles(0, math.rad(15), 0)
    
    local rightWing = Instance.new("Part")
    rightWing.Name = "RightWing"
    rightWing.Parent = wingsModel
    rightWing.Size = Vector3.new(0.2, 4, 2)
    rightWing.Material = Enum.Material.Neon
    rightWing.Color = Color3.fromRGB(255, 255, 255)
    rightWing.Transparency = 0.3
    rightWing.CanCollide = false
    rightWing.Massless = true
    rightWing.CastShadow = false
    
    local rightMesh = Instance.new("SpecialMesh", rightWing)
    rightMesh.MeshType = Enum.MeshType.FileMesh
    rightMesh.MeshId = "rbxassetid://2520762076"
    rightMesh.Scale = Vector3.new(1.5, 1.5, 1.5)
    
    local rightWeld = Instance.new("Weld")
    rightWeld.Parent = rightWing
    rightWeld.Part0 = hrp
    rightWeld.Part1 = rightWing
    rightWeld.C0 = CFrame.new(1, 0.5, -0.5) * CFrame.Angles(0, math.rad(-15), 0)
    
    connections.wingAnim = RunService.RenderStepped:Connect(function()
        local time = tick()
        local wave = math.sin(time * 3) * 0.2
        
        leftWeld.C0 = CFrame.new(-1, 0.5, -0.5) * CFrame.Angles(0, math.rad(15 + wave * 10), wave * 0.5)
        rightWeld.C0 = CFrame.new(1, 0.5, -0.5) * CFrame.Angles(0, math.rad(-15 - wave * 10), -wave * 0.5)
    end)
    
    print("[Wings] Equipped")
end

local function removeWings()
    if wingsModel then
        wingsModel:Destroy()
        wingsModel = nil
    end
    if connections.wingAnim then
        connections.wingAnim:Disconnect()
        connections.wingAnim = nil
    end
    print("[Wings] Removed")
end

-- HALO
local function createHalo()
    if haloModel then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    haloModel = Instance.new("Part")
    haloModel.Name = "Halo"
    haloModel.Parent = char
    haloModel.Size = Vector3.new(2, 0.2, 2)
    haloModel.Shape = Enum.PartType.Cylinder
    haloModel.Material = Enum.Material.Neon
    haloModel.Color = Color3.fromRGB(255, 255, 255)
    haloModel.Transparency = 0.2
    haloModel.CanCollide = false
    haloModel.Massless = true
    haloModel.CastShadow = false
    
    local light = Instance.new("PointLight", haloModel)
    light.Brightness = 2
    light.Color = Color3.fromRGB(255, 255, 255)
    light.Range = 10
    
    local weld = Instance.new("Weld")
    weld.Parent = haloModel
    weld.Part0 = head
    weld.Part1 = haloModel
    weld.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, math.rad(90))
    
    connections.haloAnim = RunService.RenderStepped:Connect(function()
        weld.C0 = weld.C0 * CFrame.Angles(0, math.rad(2), 0)
    end)
    
    print("[Halo] Equipped")
end

local function removeHalo()
    if haloModel then
        haloModel:Destroy()
        haloModel = nil
    end
    if connections.haloAnim then
        connections.haloAnim:Disconnect()
        connections.haloAnim = nil
    end
    print("[Halo] Removed")
end

-- TRAILS
local function createTrails()
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local trail = Instance.new("Trail")
            trail.Parent = part
            trail.Attachment0 = Instance.new("Attachment", part)
            trail.Attachment1 = Instance.new("Attachment", part)
            trail.Attachment1.Position = Vector3.new(0, 1, 0)
            trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            trail.Transparency = NumberSequence.new(0.5)
            trail.Lifetime = 1
            trail.MinLength = 0
        end
    end
    print("[Trails] Enabled")
end

local function removeTrails()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("Trail") then
            part:Destroy()
        end
    end
    print("[Trails] Removed")
end

-- RGB CHARACTER
local function enableRGBChar()
    connections.rgbChar = RunService.RenderStepped:Connect(function()
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = color
            end
        end
    end)
    print("[RGB] Character Enabled")
end

local function disableRGBChar()
    if connections.rgbChar then
        connections.rgbChar:Disconnect()
        connections.rgbChar = nil
    end
    print("[RGB] Character Disabled")
end

-- SIZE CHANGER
local function changeSize(scale)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local currentSize = hrp.Size
    local newSize = currentSize * scale / settings.charSize
    
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * scale / settings.charSize
        end
    end
    
    settings.charSize = scale
    print("[Size] Changed to:", scale)
end

-- INVISIBLE
local function enableInvisible()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        elseif part:IsA("Decal") then
            part.Transparency = 1
        end
    end
    print("[Invisible] Enabled")
end

local function disableInvisible()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0
        elseif part:IsA("Decal") then
            part.Transparency = 0
        end
    end
    print("[Invisible] Disabled")
end

-- SPINBOT
local function enableSpinbot()
    connections.spinbot = RunService.RenderStepped:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(20), 0)
        end
    end)
    print("[Spinbot] Enabled")
end

local function disableSpinbot()
    if connections.spinbot then
        connections.spinbot:Disconnect()
        connections.spinbot = nil
    end
    print("[Spinbot] Disabled")
end

-- KILL AURA
local function enableKillAura()
    connections.killAura = RunService.Heartbeat:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < 20 then
                    -- Attack logic here
                    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                        if v:IsA("RemoteEvent") then
                            local name = v.Name:lower()
                            if name:match("attack") or name:match("hit") or name:match("damage") then
                                v:FireServer(player.Character)
                            end
                        end
                    end
                end
            end
        end
    end)
    print("[Kill Aura] Enabled")
end

local function disableKillAura()
    if connections.killAura then
        connections.killAura:Disconnect()
        connections.killAura = nil
    end
    print("[Kill Aura] Disabled")
end

-- REACH
local function enableReach()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                handle.Size = Vector3.new(settings.reachdist, settings.reachdist, settings.reachdist)
                handle.Transparency = 1
            end
        end
    end
    print("[Reach] Enabled")
end

-- SILENT AIM
local function getClosestInFOV()
    local closest = nil
    local minDist = settings.aimfov
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

-- ESP FUNCTIONS
local function clearESP()
    for _, data in pairs(espData) do
        if data.obj then
            data.obj:Destroy()
        end
    end
    espData = {}
end

local function clearItemESP()
    for _, obj in pairs(itemESP) do
        if obj then
            obj:Destroy()
        end
    end
    itemESP = {}
end

local function createESP(player)
    if espData[player] or not player.Character then return end
    
    local c = player.Character
    local h = c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    
    if settings.espMode == 1 then
        local b = Instance.new("BillboardGui")
        b.Parent = h
        b.AlwaysOnTop = true
        b.Size = UDim2.new(0, 100, 0, 40)
        b.StudsOffset = Vector3.new(0, 2, 0)
        
        local f = Instance.new("Frame", b)
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        f.BackgroundTransparency = 0.5
        f.BorderSizePixel = 0
        
        local c1 = Instance.new("UICorner", f)
        c1.CornerRadius = UDim.new(0, 4)
        
        local n = Instance.new("TextLabel", f)
        n.Size = UDim2.new(1, 0, 0.5, 0)
        n.BackgroundTransparency = 1
        n.Font = Enum.Font.GothamBold
        n.Text = player.Name
        n.TextColor3 = Color3.fromRGB(255, 255, 255)
        n.TextSize = 10
        n.TextScaled = true
        
        local d = Instance.new("TextLabel", f)
        d.Position = UDim2.new(0, 0, 0.5, 0)
        d.Size = UDim2.new(1, 0, 0.5, 0)
        d.BackgroundTransparency = 1
        d.Font = Enum.Font.Gotham
        d.TextColor3 = Color3.fromRGB(200, 200, 200)
        d.TextSize = 9
        d.TextScaled = true
        
        espData[player] = {obj = b, dist = d, frame = f}
        
    elseif settings.espMode == 2 then
        local box = Instance.new("BoxHandleAdornment")
        box.Parent = h
        box.Size = c:GetExtentsSize()
        box.Adornee = h
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = Color3.fromRGB(255, 255, 255)
        box.Transparency = 0.5
        
        espData[player] = {obj = box}
        
    elseif settings.espMode == 3 then
        local hl = Instance.new("Highlight")
        hl.Parent = c
        hl.FillColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        
        espData[player] = {obj = hl}
    end
end

local function createItemESP()
    clearItemESP()
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            local shouldESP = false
            
            if settings.espItems and (name:match("item") or name:match("pickup") or name:match("coin")) then
                shouldESP = true
            elseif settings.espWeapons and (name:match("weapon") or name:match("gun") or name:match("sword")) then
                shouldESP = true
            elseif settings.espVehicles and (name:match("car") or name:match("vehicle")) then
                shouldESP = true
            end
            
            if shouldESP then
                local esp = Instance.new("Highlight")
                esp.Parent = obj:IsA("Model") and obj or obj.Parent
                esp.FillColor = Color3.fromRGB(255, 255, 0)
                esp.OutlineColor = Color3.fromRGB(255, 255, 0)
                esp.FillTransparency = 0.5
                esp.OutlineTransparency = 0
                
                table.insert(itemESP, esp)
            end
        end
    end
end

local function updateESP()
    for player, data in pairs(espData) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            
            if data.dist then
                data.dist.Text = math.floor(dist) .. "m"
            end
            
            if settings.espRgb and data.frame then
                data.frame.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            elseif settings.espRgb and data.obj then
                if data.obj:IsA("BoxHandleAdornment") then
                    data.obj.Color3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                elseif data.obj:IsA("Highlight") then
                    data.obj.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    data.obj.OutlineColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
            end
        end
    end
end

-- CREATE TABS
local combatPage = createTab("Combat")
local movementPage = createTab("Move")
local visualPage = createTab("Visual")
local espPage = createTab("ESP")
local farmPage = createTab("Farm")
local miscPage = createTab("Misc")

-- COMBAT TAB
label(combatPage, "COMBAT")
toggle_option(combatPage, "God Mode", function(v)
    settings.god = v
    if v then enableGod() else disableGod() end
end)

toggle_option(combatPage, "Auto Aim", function(v)
    settings.aim = v
    if v then
        connections.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if connections.aim then connections.aim:Disconnect() end
    end
end)

toggle_option(combatPage, "Silent Aim", function(v)
    settings.silentaim = v
end)

toggle_option(combatPage, "Show FOV", function(v)
    settings.showfov = v
    fovCircle.Visible = v
end)

slider(combatPage, "FOV Size", 50, 500, 100, function(v)
    settings.aimfov = v
end)

toggle_option(combatPage, "Spinbot", function(v)
    settings.spinbot = v
    if v then enableSpinbot() else disableSpinbot() end
end)

toggle_option(combatPage, "Kill Aura", function(v)
    settings.killaura = v
    if v then enableKillAura() else disableKillAura() end
end)

toggle_option(combatPage, "Reach Extender", function(v)
    settings.reach = v
    if v then enableReach() end
end)

slider(combatPage, "Reach Distance", 5, 30, 15, function(v)
    settings.reachdist = v
end)

-- MOVEMENT TAB
label(movementPage, "MOVEMENT")
slider(movementPage, "Speed", 16, 500, 16, function(v)
    settings.speed = v
end)

slider(movementPage, "Jump", 50, 500, 50, function(v)
    settings.jump = v
end)

toggle_option(movementPage, "Noclip", function(v)
    settings.noclip = v
    if v then
        connections.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() end
    end
end)

toggle_option(movementPage, "Fly", function(v)
    settings.fly = v
    if v then
        local hrp = char.HumanoidRootPart
        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        connections.fly = RunService.RenderStepped:Connect(function()
            bg.CFrame = cam.CFrame
            local vel = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector * settings.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector * settings.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector * settings.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector * settings.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, settings.flyspeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, settings.flyspeed, 0) end
            bv.Velocity = vel
        end)
    else
        if connections.fly then connections.fly:Disconnect() end
        for _, v in pairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end)

slider(movementPage, "Fly Speed", 10, 200, 50, function(v)
    settings.flyspeed = v
end)

-- VISUAL TAB
label(visualPage, "VISUAL")
toggle_option(visualPage, "No Fog", function(v)
    settings.fog = v
    Lighting.FogEnd = v and 100000 or 1000
end)

toggle_option(visualPage, "Full Bright", function(v)
    settings.bright = v
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

toggle_option(visualPage, "Crosshair", function(v)
    settings.cross = v
    if v then
        local crosshair = Instance.new("ScreenGui", gui)
        local function line(x, y, w, h)
            local l = Instance.new("Frame", crosshair)
            l.AnchorPoint = Vector2.new(0.5, 0.5)
            l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            l.BorderSizePixel = 0
            l.Position = UDim2.new(0.5, x, 0.5, y)
            l.Size = UDim2.new(0, w, 0, h)
        end
        line(0, -8, 1, 6)
        line(0, 8, 1, 6)
        line(-8, 0, 6, 1)
        line(8, 0, 6, 1)
    end
end)

slider(visualPage, "FOV", 70, 120, 70, function(v)
    settings.fov = v
    cam.FieldOfView = v
end)

label(visualPage, "COSMETICS")
toggle_option(visualPage, "Angel Wings", function(v)
    settings.wings = v
    if v then createWings() else removeWings() end
end)

toggle_option(visualPage, "Angel Halo", function(v)
    settings.halo = v
    if v then createHalo() else removeHalo() end
end)

toggle_option(visualPage, "Trails", function(v)
    settings.trails = v
    if v then createTrails() else removeTrails() end
end)

toggle_option(visualPage, "RGB Character", function(v)
    settings.rgbChar = v
    if v then enableRGBChar() else disableRGBChar() end
end)

toggle_option(visualPage, "Invisible", function(v)
    settings.invisible = v
    if v then enableInvisible() else disableInvisible() end
end)

slider(visualPage, "Character Size", 0.5, 3, 1, function(v)
    changeSize(v)
end)

-- ESP TAB
label(espPage, "ESP")
toggle_option(espPage, "ESP Enabled", function(v)
    settings.esp = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    else
        clearESP()
    end
end)

button(espPage, "Mode: Simple", function()
    settings.espMode = 1
    clearESP()
    if settings.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

button(espPage, "Mode: Box", function()
    settings.espMode = 2
    clearESP()
    if settings.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

button(espPage, "Mode: Highlight", function()
    settings.espMode = 3
    clearESP()
    if settings.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

toggle_option(espPage, "RGB Mode", function(v)
    settings.espRgb = v
end)

label(espPage, "ITEM ESP")
toggle_option(espPage, "Item ESP", function(v)
    settings.espItems = v
    createItemESP()
end)

toggle_option(espPage, "Weapon ESP", function(v)
    settings.espWeapons = v
    createItemESP()
end)

toggle_option(espPage, "Vehicle ESP", function(v)
    settings.espVehicles = v
    createItemESP()
end)

-- FARM TAB
label(farmPage, "AUTO FARM")
toggle_option(farmPage, "Auto Farm Divine", function(v)
    settings.farmDivine = v
    if settings.farmDivine or settings.farmCelestial or settings.farmInfinity then
        if not settings.autoFarm then
            settings.autoFarm = true
            startAutoFarm()
        end
    else
        if settings.autoFarm then
            settings.autoFarm = false
            stopAutoFarm()
        end
    end
end)

toggle_option(farmPage, "Auto Farm Celestial", function(v)
    settings.farmCelestial = v
    if settings.farmDivine or settings.farmCelestial or settings.farmInfinity then
        if not settings.autoFarm then
            settings.autoFarm = true
            startAutoFarm()
        end
    else
        if settings.autoFarm then
            settings.autoFarm = false
            stopAutoFarm()
        end
    end
end)

toggle_option(farmPage, "Auto Farm Infinity", function(v)
    settings.farmInfinity = v
    if settings.farmDivine or settings.farmCelestial or settings.farmInfinity then
        if not settings.autoFarm then
            settings.autoFarm = true
            startAutoFarm()
        end
    else
        if settings.autoFarm then
            settings.autoFarm = false
            stopAutoFarm()
        end
    end
end)

toggle_option(farmPage, "Auto Collect Items", function(v)
    settings.autoCollect = v
    if v then startAutoCollect() else stopAutoCollect() end
end)

label(farmPage, "ikaxzu VIP")
toggle_option(farmPage, "VIP Remover", function(v)
    settings.vipremove = v
    if v then enableVIPRemove() else disableVIPRemove() end
end)

label(farmPage, "TELEPORT")
button(farmPage, "TP Closest Player", function()
    local target = getClosestInFOV()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

button(farmPage, "TP Random Player", function()
    local ps = Players:GetPlayers()
    if #ps > 1 then
        local rnd = ps[math.random(1, #ps)]
        if rnd ~= plr and rnd.Character and rnd.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = rnd.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- MISC TAB
label(miscPage, "PROTECTION")
toggle_option(miscPage, "Anti Kick", function(v)
    settings.antiKick = v
    if v then enableAntiKick() end
end)

toggle_option(miscPage, "Anti Ban", function(v)
    settings.antiBan = v
    if v then enableAntiBan() end
end)

toggle_option(miscPage, "Anti AFK", function(v)
    settings.antiAfk = v
    if v then enableAntiAFK() end
end)

label(miscPage, "UTILITY")
button(miscPage, "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

button(miscPage, "Server Hop", function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    if servers and servers.data then
        for _, server in pairs(servers.data) do
            if server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, plr)
                break
            end
        end
    end
end)

button(miscPage, "Copy Game ID", function()
    setclipboard(tostring(game.PlaceId))
    print("Game ID copied to clipboard")
end)

-- EVENTS
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, 450, 0, 520)}):Play()
    end
end)

close.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.25)
    main.Visible = false
end)

RunService.RenderStepped:Connect(function()
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = settings.speed
        char.Humanoid.JumpPower = settings.jump
    end
    
    if settings.showfov then
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = settings.aimfov
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
    
    if settings.esp then
        updateESP()
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if settings.esp then createESP(p) end
    end)
end)

plr.CharacterAdded:Connect(function(c)
    char = c
    task.wait(1)
    
    if settings.god then enableGod() end
    if settings.noclip then
        connections.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
    if settings.wings then createWings() end
    if settings.halo then createHalo() end
    if settings.vipremove then enableVIPRemove() end
    if settings.autoFarm then startAutoFarm() end
    if settings.autoCollect then startAutoCollect() end
    if settings.trails then createTrails() end
    if settings.rgbChar then enableRGBChar() end
    if settings.invisible then enableInvisible() end
end)

warn("ikaxzu scripter FULL EDITION loaded")
warn("All features unlocked!")
warn("Tabs: Combat | Move | Visual | ESP | Farm | Misc")
