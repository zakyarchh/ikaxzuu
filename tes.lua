-- Violence District -- ikaxzu scripter
-- Violence District X escape tsunami for brainroot
-- Delta X Optimized

warn("Loading ikaxzu scripter...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

-- Config
local settings = {
    esp = false,
    espMode = 1,
    espRgb = false,
    speed = 16,
    jump = 50,
    noclip = false,
    fly = false,
    flyspeed = 50,
    god = false,
    aim = false,
    aimfov = 100,
    showfov = false,
    fog = false,
    bright = false,
    cross = false,
    fov = 70,
    vipremove = false,
    wings = false,
    halo = false
}

local connections = {}
local espData = {}
local oldHealth = 0
local immortal = false
local removedObjects = {}
local wingsModel = nil
local haloModel = nil

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
title.Text = "ikaxzu scripter"
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

-- Divider
local div = Instance.new("Frame")
div.Parent = main
div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
div.BackgroundTransparency = 0.95
div.BorderSizePixel = 0
div.Position = UDim2.new(0, 0, 0, 35)
div.Size = UDim2.new(1, 0, 0, 1)

-- Content
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Parent = main
content.Active = true
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.Position = UDim2.new(0, 8, 0, 43)
content.Size = UDim2.new(1, -16, 1, -51)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ScrollBarThickness = 2
content.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
content.ScrollBarImageTransparency = 0.9

local layout = Instance.new("UIListLayout")
layout.Parent = content
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 1
fovCircle.NumSides = 64
fovCircle.Filled = false

-- Functions
local function label(text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = content
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 0.4
end

local function toggle_option(text, callback)
    local state = false
    
    local frame = Instance.new("TextButton")
    frame.Parent = content
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
    
    return frame
end

local function slider(text, min, max, def, callback)
    local val = def
    local dragging = false
    
    local frame = Instance.new("Frame")
    frame.Parent = content
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

local function button(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = content
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

-- ULTIMATE GOD MODE (Fixed)
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

-- ikaxzu VIP Remove
local vipConnection
local function enableVIPRemove()
    if vipConnection then return end
    
    vipConnection = RunService.Heartbeat:Connect(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                -- Check for VIP/Gamepass objects
                local name = obj.Name:lower()
                local hasBadge = obj:FindFirstChild("GamepassRequired") or 
                                 obj:FindFirstChild("VIPOnly") or 
                                 obj:FindFirstChild("PremiumOnly") or
                                 obj:FindFirstChild("BadgeRequired")
                
                -- Common VIP object names
                if name:match("vip") or name:match("premium") or name:match("gamepass") or 
                   name:match("donate") or name:match("robux") or name:match("safe") or
                   name:match("badge") or hasBadge then
                    
                    if not removedObjects[obj] then
                        pcall(function()
                            -- Make transparent and non-collidable
                            if obj:IsA("BasePart") then
                                obj.Transparency = 1
                                obj.CanCollide = false
                                obj.CanTouch = false
                                
                                -- Remove collision
                                for _, child in pairs(obj:GetDescendants()) do
                                    if child:IsA("BasePart") then
                                        child.Transparency = 1
                                        child.CanCollide = false
                                        child.CanTouch = false
                                    end
                                end
                            elseif obj:IsA("Model") then
                                -- Hide entire model
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
                            print("[VIP] Removed:", obj.Name)
                        end)
                    end
                end
            end
        end
    end)
    
    print("[VIP] ikaxzu VIP Remover Enabled")
end

local function disableVIPRemove()
    if vipConnection then
        vipConnection:Disconnect()
        vipConnection = nil
    end
    removedObjects = {}
    print("[VIP] ikaxzu VIP Remover Disabled")
end

-- Wings Function
local function createWings()
    if wingsModel then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    wingsModel = Instance.new("Model")
    wingsModel.Name = "AngelWings"
    wingsModel.Parent = char
    
    -- Left Wing
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
    
    -- Right Wing
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
    
    -- Wing Animation
    connections.wingAnim = RunService.RenderStepped:Connect(function()
        local time = tick()
        local wave = math.sin(time * 3) * 0.2
        
        leftWeld.C0 = CFrame.new(-1, 0.5, -0.5) * CFrame.Angles(0, math.rad(15 + wave * 10), wave * 0.5)
        rightWeld.C0 = CFrame.new(1, 0.5, -0.5) * CFrame.Angles(0, math.rad(-15 - wave * 10), -wave * 0.5)
    end)
    
    print("[Wings] Angel Wings Equipped")
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
    print("[Wings] Angel Wings Removed")
end

-- Halo Function
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
    
    -- Halo Rotation
    connections.haloAnim = RunService.RenderStepped:Connect(function()
        weld.C0 = weld.C0 * CFrame.Angles(0, math.rad(2), 0)
    end)
    
    print("[Halo] Angel Halo Equipped")
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
    print("[Halo] Angel Halo Removed")
end

-- ESP Functions
local function clearESP()
    for _, data in pairs(espData) do
        if data.obj then
            data.obj:Destroy()
        end
    end
    espData = {}
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

-- Aim Functions
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

-- Build UI
label("ESP")
toggle_option("ESP Enabled", function(v)
    settings.esp = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then
                createESP(p)
            end
        end
    else
        clearESP()
    end
end)

button("Mode: Simple", function()
    settings.espMode = 1
    clearESP()
    if settings.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

button("Mode: Box", function()
    settings.espMode = 2
    clearESP()
    if settings.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

button("Mode: Highlight", function()
    settings.espMode = 3
    clearESP()
    if settings.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
    end
end)

toggle_option("RGB Mode", function(v)
    settings.espRgb = v
end)

label("MOVEMENT")
slider("Speed", 16, 500, 16, function(v)
    settings.speed = v
end)

slider("Jump", 50, 500, 50, function(v)
    settings.jump = v
end)

local noclipCon
toggle_option("Noclip", function(v)
    settings.noclip = v
    if v then
        noclipCon = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end)
    else
        if noclipCon then noclipCon:Disconnect() end
    end
end)

local flyCon
toggle_option("Fly", function(v)
    settings.fly = v
    if v then
        local hrp = char.HumanoidRootPart
        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        flyCon = RunService.RenderStepped:Connect(function()
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
        if flyCon then flyCon:Disconnect() end
        for _, v in pairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end)

slider("Fly Speed", 10, 200, 50, function(v)
    settings.flyspeed = v
end)

label("COMBAT")
toggle_option("God Mode", function(v)
    settings.god = v
    if v then
        enableGod()
    else
        disableGod()
    end
end)

local aimCon
toggle_option("Auto Aim", function(v)
    settings.aim = v
    if v then
        aimCon = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if aimCon then aimCon:Disconnect() end
    end
end)

toggle_option("Show FOV", function(v)
    settings.showfov = v
    fovCircle.Visible = v
end)

slider("FOV Size", 50, 500, 100, function(v)
    settings.aimfov = v
end)

label("ikaxzu VIP")
toggle_option("VIP Object Remover", function(v)
    settings.vipremove = v
    if v then
        enableVIPRemove()
    else
        disableVIPRemove()
    end
end)

label("COSMETICS")
toggle_option("Angel Wings", function(v)
    settings.wings = v
    if v then
        createWings()
    else
        removeWings()
    end
end)

toggle_option("Angel Halo", function(v)
    settings.halo = v
    if v then
        createHalo()
    else
        removeHalo()
    end
end)

label("VISUAL")
toggle_option("No Fog", function(v)
    settings.fog = v
    Lighting.FogEnd = v and 100000 or 1000
end)

toggle_option("Full Bright", function(v)
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

local crosshair
toggle_option("Crosshair", function(v)
    settings.cross = v
    if v then
        crosshair = Instance.new("ScreenGui", gui)
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
    else
        if crosshair then crosshair:Destroy() end
    end
end)

slider("FOV", 70, 120, 70, function(v)
    settings.fov = v
    cam.FieldOfView = v
end)

label("TELEPORT")
button("TP Closest", function()
    local target = getClosestInFOV()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

button("TP Random", function()
    local ps = Players:GetPlayers()
    if #ps > 1 then
        local rnd = ps[math.random(1, #ps)]
        if rnd ~= plr and rnd.Character and rnd.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = rnd.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Events
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, 340, 0, 480)}):Play()
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
        if settings.esp then
            createESP(p)
        end
    end)
end)

plr.CharacterAdded:Connect(function(c)
    char = c
    task.wait(1)
    
    if settings.god then
        enableGod()
    end
    if settings.noclip then
        noclipCon = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
    if settings.wings then
        createWings()
    end
    if settings.halo then
        createHalo()
    end
    if settings.vipremove then
        enableVIPRemove()
    end
end)

warn("ikaxzu scripter loaded successfully")
warn("Features: God Mode, ESP, Aim, VIP Remover, Angel Wings, Halo")
