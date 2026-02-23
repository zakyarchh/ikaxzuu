-- Violence District | Clean & Minimal UI
-- Delta X Mobile Optimized
-- Made by Human, Not AI

print("[VD] Loading...")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Settings
local cfg = {
    esp = false,
    espMode = 1,
    espRGB = false,
    speed = 16,
    jump = 50,
    noclip = false,
    fly = false,
    flyspeed = 50,
    godv1 = false,
    godv2 = false,
    godv3 = false,
    godv4 = false,
    godv5 = false,
    aim = false,
    aimrange = 50,
    aimfov = 100,
    aimcircle = false,
    fog = false,
    bright = false,
    cross = false,
    fov = 70
}

-- God Mode Connections & Protection
local godConnections = {}
local protectionParts = {}

-- Parent
local function GetGui()
    return (pcall(function() return gethui() end) and gethui()) or CoreGui
end

-- Create GUI
local VD = Instance.new("ScreenGui")
VD.Name = "VD"
VD.Parent = GetGui()
VD.ResetOnSpawn = false
VD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Open Button
local Open = Instance.new("TextButton")
Open.Name = "Open"
Open.Parent = VD
Open.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Open.BorderSizePixel = 0
Open.Position = UDim2.new(0, 20, 0.5, -25)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Font = Enum.Font.GothamBold
Open.Text = "VD"
Open.TextColor3 = Color3.fromRGB(255, 255, 255)
Open.TextSize = 16
Open.Active = true
Open.Draggable = true

local OpenC = Instance.new("UICorner")
OpenC.CornerRadius = UDim.new(0, 12)
OpenC.Parent = Open

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = VD
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 0, 0, 0)
Main.ClipsDescendants = true
Main.Visible = false
Main.Active = true
Main.Draggable = true

local MainC = Instance.new("UICorner")
MainC.CornerRadius = UDim.new(0, 10)
MainC.Parent = Main

-- Top Bar
local Top = Instance.new("Frame")
Top.Name = "Top"
Top.Parent = Main
Top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Top.BorderSizePixel = 0
Top.Size = UDim2.new(1, 0, 0, 40)

local TopC = Instance.new("UICorner")
TopC.CornerRadius = UDim.new(0, 10)
TopC.Parent = Top

local TopFix = Instance.new("Frame")
TopFix.Parent = Top
TopFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopFix.BorderSizePixel = 0
TopFix.Position = UDim2.new(0, 0, 1, -10)
TopFix.Size = UDim2.new(1, 0, 0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = Top
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "VIOLENCE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local Sub = Instance.new("TextLabel")
Sub.Parent = Top
Sub.BackgroundTransparency = 1
Sub.Position = UDim2.new(0, 95, 0, 0)
Sub.Size = UDim2.new(0, 100, 1, 0)
Sub.Font = Enum.Font.Gotham
Sub.Text = "DISTRICT"
Sub.TextColor3 = Color3.fromRGB(150, 150, 150)
Sub.TextSize = 15
Sub.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Parent = Top
Close.AnchorPoint = Vector2.new(1, 0)
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -10, 0, 10)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Font = Enum.Font.GothamBold
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 12

local CloseC = Instance.new("UICorner")
CloseC.CornerRadius = UDim.new(0, 5)
CloseC.Parent = Close

-- Tabs Container
local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.Parent = Main
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.Size = UDim2.new(1, 0, 0, 35)

local TabList = Instance.new("UIListLayout")
TabList.Parent = Tabs
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

-- Content
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 10, 0, 85)
Content.Size = UDim2.new(1, -20, 1, -95)

-- FOV Circle for Aim
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.8
FOVCircle.NumSides = 64
FOVCircle.Filled = false

-- Functions
local currentTab = nil

local function Tab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name
    TabBtn.Parent = Tabs
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.BorderSizePixel = 0
    TabBtn.Size = UDim2.new(0, 80, 1, 0)
    TabBtn.AutoButtonColor = false
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.TextSize = 12
    
    local TabC = Instance.new("UICorner")
    TabC.CornerRadius = UDim.new(0, 6)
    TabC.Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Parent = Content
    Page.Active = true
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Page.Visible = false
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 8)
    
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 5)
    end)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                v.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
        for _, v in pairs(Content:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v.Visible = false
            end
        end
        
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
        currentTab = name
    end)
    
    if not currentTab then
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
        currentTab = name
    end
    
    return Page
end

local function Toggle(parent, text, callback)
    local on = false
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.BorderSizePixel = 0
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.AutoButtonColor = false
    Btn.Font = Enum.Font.Gotham
    Btn.Text = ""
    Btn.TextSize = 1
    
    local BtnC = Instance.new("UICorner")
    BtnC.CornerRadius = UDim.new(0, 6)
    BtnC.Parent = Btn
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Btn
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Switch = Instance.new("Frame")
    Switch.Parent = Btn
    Switch.AnchorPoint = Vector2.new(1, 0.5)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Switch.BorderSizePixel = 0
    Switch.Position = UDim2.new(1, -10, 0.5, 0)
    Switch.Size = UDim2.new(0, 35, 0, 18)
    
    local SwitchC = Instance.new("UICorner")
    SwitchC.CornerRadius = UDim.new(1, 0)
    SwitchC.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Parent = Switch
    Circle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Circle.BorderSizePixel = 0
    Circle.Position = UDim2.new(0, 2, 0.5, 0)
    Circle.AnchorPoint = Vector2.new(0, 0.5)
    Circle.Size = UDim2.new(0, 14, 0, 14)
    
    local CircleC = Instance.new("UICorner")
    CircleC.CornerRadius = UDim.new(1, 0)
    CircleC.Parent = Circle
    
    Btn.MouseButton1Click:Connect(function()
        on = not on
        
        if on then
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        
        pcall(callback, on)
    end)
end

local function Slider(parent, text, min, max, def, callback)
    local val = def
    local dragging = false
    
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, 50)
    
    local FrameC = Instance.new("UICorner")
    FrameC.CornerRadius = UDim.new(0, 6)
    FrameC.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.Size = UDim2.new(1, -24, 0, 15)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Value = Instance.new("TextLabel")
    Value.Parent = Frame
    Value.BackgroundTransparency = 1
    Value.Position = UDim2.new(0, 12, 0, 5)
    Value.Size = UDim2.new(1, -24, 0, 15)
    Value.Font = Enum.Font.GothamBold
    Value.Text = tostring(def)
    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
    Value.TextSize = 13
    Value.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Parent = Frame
    SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBack.BorderSizePixel = 0
    SliderBack.Position = UDim2.new(0, 12, 0, 28)
    SliderBack.Size = UDim2.new(1, -24, 0, 12)
    
    local SliderBackC = Instance.new("UICorner")
    SliderBackC.CornerRadius = UDim.new(1, 0)
    SliderBackC.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBack
    SliderFill.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    
    local SliderFillC = Instance.new("UICorner")
    SliderFillC.CornerRadius = UDim.new(1, 0)
    SliderFillC.Parent = SliderFill
    
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Parent = SliderBack
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SliderBtn.Text = ""
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pos)
        
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Value.Text = tostring(val)
        
        pcall(callback, val)
    end
    
    SliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    SliderBtn.InputBegan:Connect(function(input)
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

local function Btn(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.AutoButtonColor = false
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    
    local ButtonC = Instance.new("UICorner")
    ButtonC.CornerRadius = UDim.new(0, 6)
    ButtonC.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        pcall(callback)
    end)
end

-- God Mode Functions
local function StopAllGod()
    for name, conn in pairs(godConnections) do
        if conn then
            pcall(function()
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end)
        end
        godConnections[name] = nil
    end
    
    -- Remove protection parts
    for _, part in pairs(protectionParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    protectionParts = {}
    
    local hum = Character:FindFirstChild("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    end
    
    -- Remove force fields
    for _, v in pairs(Character:GetChildren()) do
        if v:IsA("ForceField") then
            v:Destroy()
        end
    end
    
    print("[VD] All God Modes Disabled")
end

local function GodV1(enabled)
    if not enabled then
        if godConnections.GodV1 then
            godConnections.GodV1:Disconnect()
            godConnections.GodV1 = nil
        end
        print("[VD] God V1 Disabled")
        return
    end
    
    local hum = Character:FindFirstChild("Humanoid")
    if not hum then return end
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    
    godConnections.GodV1 = hum.HealthChanged:Connect(function()
        if hum.Health < math.huge then
            hum.Health = math.huge
        end
    end)
    
    print("[VD] God V1 Enabled - Health Regen")
end

local function GodV2(enabled)
    if not enabled then
        if godConnections.GodV2 then
            godConnections.GodV2:Disconnect()
            godConnections.GodV2 = nil
        end
        print("[VD] God V2 Disabled")
        return
    end
    
    local hum = Character:FindFirstChild("Humanoid")
    if not hum then return end
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    
    godConnections.GodV2 = hum.Died:Connect(function()
        local newHum = hum:Clone()
        hum:Destroy()
        newHum.Parent = Character
        newHum.Health = newHum.MaxHealth
    end)
    
    print("[VD] God V2 Enabled - Humanoid Replace")
end

local function GodV3(enabled)
    if not enabled then
        if godConnections.GodV3 then
            godConnections.GodV3:Disconnect()
            godConnections.GodV3 = nil
        end
        if godConnections.GodV3Touched then
            godConnections.GodV3Touched:Disconnect()
            godConnections.GodV3Touched = nil
        end
        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("ForceField") then
                v:Destroy()
            end
        end
        print("[VD] God V3 Disabled")
        return
    end
    
    local hum = Character:FindFirstChild("Humanoid")
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    
    local ff = Instance.new("ForceField")
    ff.Parent = Character
    ff.Visible = false
    
    godConnections.GodV3 = hum.HealthChanged:Connect(function(health)
        if health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end)
    
    godConnections.GodV3Touched = hrp.Touched:Connect(function(hit)
        if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
            return
        end
        if hit.Name == "Spike" or hit.Name == "Trap" or hit.Name == "Kill" or hit.Name == "Lava" then
            pcall(function()
                hit.CanTouch = false
                hit.CanCollide = false
            end)
        end
    end)
    
    print("[VD] God V3 Enabled - Force Field + Touch Block")
end

local function GodV4(enabled)
    if not enabled then
        if godConnections.GodV4 then
            godConnections.GodV4:Disconnect()
            godConnections.GodV4 = nil
        end
        if godConnections.GodV4Respawn then
            godConnections.GodV4Respawn:Disconnect()
            godConnections.GodV4Respawn = nil
        end
        if godConnections.GodV4Damage then
            godConnections.GodV4Damage:Disconnect()
            godConnections.GodV4Damage = nil
        end
        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("ForceField") then
                v:Destroy()
            end
        end
        print("[VD] God V4 Disabled")
        return
    end
    
    local hum = Character:FindFirstChild("Humanoid")
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum.MaxHealth = 999999
    hum.Health = 999999
    
    for _, v in pairs(Character:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            if v.Name:lower():find("damage") or v.Name:lower():find("kill") or v.Name:lower():find("death") then
                v:Destroy()
            end
        end
    end
    
    local ff = Instance.new("ForceField")
    ff.Parent = Character
    ff.Visible = false
    
    godConnections.GodV4 = RunService.Heartbeat:Connect(function()
        if hum.Health < 999999 then
            hum.Health = 999999
        end
        
        for _, effect in pairs(hum:GetChildren()) do
            if effect:IsA("NumberValue") or effect:IsA("StringValue") then
                if effect.Name:lower():find("damage") or effect.Name:lower():find("poison") or effect.Name:lower():find("burn") then
                    effect:Destroy()
                end
            end
        end
    end)
    
    godConnections.GodV4Damage = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health < 999999 then
            hum.Health = 999999
        end
    end)
    
    godConnections.GodV4Respawn = hum.Died:Connect(function()
        hum.Health = 999999
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name:lower():find("kill") or v.Name:lower():find("death") or v.Name:lower():find("trap") or v.Name:lower():find("spike") or v.Name:lower():find("lava") then
                pcall(function()
                    v.CanTouch = false
                    v.CanCollide = false
                    v.Transparency = 0.8
                end)
            end
        end
    end
    
    print("[VD] God V4 Enabled - ULTIMATE PROTECTION")
end

local function GodV5(enabled)
    if not enabled then
        if godConnections.GodV5 then
            godConnections.GodV5:Disconnect()
            godConnections.GodV5 = nil
        end
        if godConnections.GodV5Part then
            godConnections.GodV5Part:Disconnect()
            godConnections.GodV5Part = nil
        end
        for _, part in pairs(protectionParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        protectionParts = {}
        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("ForceField") then
                v:Destroy()
            end
        end
        print("[VD] God V5 Disabled")
        return
    end
    
    local hum = Character:FindFirstChild("Humanoid")
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    -- ULTIMATE PROTECTION
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    
    -- Invisible Force Field
    local ff = Instance.new("ForceField")
    ff.Parent = Character
    ff.Visible = false
    
    -- Create Transparent Protection Barrier
    local barrier = Instance.new("Part")
    barrier.Name = "ProtectionBarrier"
    barrier.Parent = Character
    barrier.Size = Vector3.new(10, 10, 10)
    barrier.Shape = Enum.PartType.Ball
    barrier.Transparency = 0.95
    barrier.Material = Enum.Material.ForceField
    barrier.Color = Color3.fromRGB(100, 200, 255)
    barrier.CanCollide = false
    barrier.Anchored = false
    barrier.Massless = true
    barrier.CastShadow = false
    
    local weld = Instance.new("Weld")
    weld.Parent = barrier
    weld.Part0 = hrp
    weld.Part1 = barrier
    weld.C0 = CFrame.new(0, 0, 0)
    
    table.insert(protectionParts, barrier)
    
    -- Visual glow effect
    local attachment = Instance.new("Attachment", barrier)
    local particle = Instance.new("ParticleEmitter", attachment)
    particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particle.Size = NumberSequence.new(0.5)
    particle.Transparency = NumberSequence.new(0.9)
    particle.Lifetime = NumberRange.new(1)
    particle.Rate = 20
    particle.Speed = NumberRange.new(0.5)
    particle.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))
    
    -- MEGA HEALTH PROTECTION
    godConnections.GodV5 = RunService.Heartbeat:Connect(function()
        -- Force max health
        if hum.Health < math.huge then
            hum.Health = math.huge
        end
        
        -- Remove ALL negative effects
        for _, child in pairs(hum:GetChildren()) do
            if child:IsA("NumberValue") or child:IsA("StringValue") or child:IsA("ObjectValue") then
                child:Destroy()
            end
        end
        
        -- Remove damage scripts from character
        for _, script in pairs(Character:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                if script.Name:lower():find("damage") or 
                   script.Name:lower():find("kill") or 
                   script.Name:lower():find("death") or 
                   script.Name:lower():find("harm") or
                   script.Name:lower():find("hurt") then
                    script:Destroy()
                end
            end
        end
        
        -- Disable death state
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)
    
    -- Nullify ALL kill parts
    godConnections.GodV5Part = RunService.Stepped:Connect(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local name = v.Name:lower()
                if name:find("kill") or name:find("death") or name:find("trap") or 
                   name:find("spike") or name:find("lava") or name:find("fire") or
                   name:find("poison") or name:find("damage") then
                    pcall(function()
                        v.CanTouch = false
                        v.CanCollide = false
                        v.Transparency = 0.95
                    end)
                end
            end
        end
        
        -- Make character parts indestructible
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
    
    -- Block remote events that can kill
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            if remote.Name:lower():find("damage") or remote.Name:lower():find("kill") or remote.Name:lower():find("death") then
                pcall(function()
                    remote:Destroy()
                end)
            end
        end
    end
    
    print("[VD] God V5 Enabled - INVINCIBLE BARRIER")
end

-- ESP Functions - 4 Versions
local espObjects = {}

local function RemoveAllESP()
    for plr, _ in pairs(espObjects) do
        if espObjects[plr] and espObjects[plr].esp then
            espObjects[plr].esp:Destroy()
        end
        espObjects[plr] = nil
    end
end

-- ESP V1 - Minimal (Name + Distance)
local function AddESPV1(plr)
    if espObjects[plr] or not plr.Character then return end
    
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Parent = hrp
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 80, 0, 40)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    
    local frame = Instance.new("Frame", esp)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 4)
    
    local name = Instance.new("TextLabel", frame)
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = plr.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextSize = 11
    name.TextScaled = true
    
    local dist = Instance.new("TextLabel", frame)
    dist.Position = UDim2.new(0, 0, 0.5, 0)
    dist.Size = UDim2.new(1, 0, 0.5, 0)
    dist.BackgroundTransparency = 1
    dist.Font = Enum.Font.Gotham
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist.TextSize = 10
    dist.TextScaled = true
    
    espObjects[plr] = {esp = esp, frame = frame, dist = dist}
end

-- ESP V2 - Box ESP (3D Box)
local function AddESPV2(plr)
    if espObjects[plr] or not plr.Character then return end
    
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Parent = hrp
    box.Size = Vector3.new(4, 5, 1)
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = Color3.fromRGB(255, 255, 255)
    box.Transparency = 0.7
    
    local esp = Instance.new("BillboardGui")
    esp.Parent = hrp
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 60, 0, 20)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    
    local name = Instance.new("TextLabel", esp)
    name.Size = UDim2.new(1, 0, 1, 0)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = plr.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextSize = 12
    name.TextStrokeTransparency = 0.5
    
    espObjects[plr] = {esp = esp, box = box}
end

-- ESP V3 - Health Bar ESP
local function AddESPV3(plr)
    if espObjects[plr] or not plr.Character then return end
    
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Parent = hrp
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 100, 0, 60)
    esp.StudsOffset = Vector3.new(0, 2.5, 0)
    
    local frame = Instance.new("Frame", esp)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 5)
    
    local name = Instance.new("TextLabel", frame)
    name.Size = UDim2.new(1, 0, 0.3, 0)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = plr.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextSize = 12
    
    local healthBar = Instance.new("Frame", frame)
    healthBar.Position = UDim2.new(0.1, 0, 0.4, 0)
    healthBar.Size = UDim2.new(0.8, 0, 0.15, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBar.BorderSizePixel = 0
    
    local healthCorner = Instance.new("UICorner", healthBar)
    healthCorner.CornerRadius = UDim.new(1, 0)
    
    local healthFill = Instance.new("Frame", healthBar)
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner", healthFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local dist = Instance.new("TextLabel", frame)
    dist.Position = UDim2.new(0, 0, 0.65, 0)
    dist.Size = UDim2.new(1, 0, 0.3, 0)
    dist.BackgroundTransparency = 1
    dist.Font = Enum.Font.Gotham
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist.TextSize = 10
    
    espObjects[plr] = {esp = esp, frame = frame, dist = dist, healthFill = healthFill, hum = hum}
end

-- ESP V4 - Chams (Highlight)
local function AddESPV4(plr)
    if espObjects[plr] or not plr.Character then return end
    
    local char = plr.Character
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = char
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    local esp = Instance.new("BillboardGui")
    esp.Parent = char:FindFirstChild("HumanoidRootPart")
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 80, 0, 25)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    
    local name = Instance.new("TextLabel", esp)
    name.Size = UDim2.new(1, 0, 0.6, 0)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = plr.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextSize = 13
    name.TextStrokeTransparency = 0.3
    
    local dist = Instance.new("TextLabel", esp)
    dist.Position = UDim2.new(0, 0, 0.6, 0)
    dist.Size = UDim2.new(1, 0, 0.4, 0)
    dist.BackgroundTransparency = 1
    dist.Font = Enum.Font.Gotham
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist.TextSize = 11
    dist.TextStrokeTransparency = 0.3
    
    espObjects[plr] = {esp = esp, highlight = highlight, dist = dist}
end

local function UpdateESP()
    for plr, data in pairs(espObjects) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            
            if data.dist then
                data.dist.Text = math.floor(d) .. "m"
            end
            
            if data.healthFill and data.hum then
                local healthPercent = data.hum.Health / data.hum.MaxHealth
                data.healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                data.healthFill.BackgroundColor3 = healthPercent > 0.5 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
            
            if cfg.espRGB then
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                
                if data.frame then
                    data.frame.BackgroundColor3 = color
                end
                if data.box then
                    data.box.Color3 = color
                end
                if data.highlight then
                    data.highlight.FillColor = color
                    data.highlight.OutlineColor = color
                end
            end
        end
    end
end

-- Aim FOV Functions
local function GetClosestInFOV()
    local closest, dist = nil, cfg.aimfov
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local hrp = plr.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                local distanceFromCenter = (screenPos2D - screenCenter).Magnitude
                
                if distanceFromCenter < dist then
                    closest = plr
                    dist = distanceFromCenter
                end
            end
        end
    end
    
    return closest
end

-- Build UI
local ESP = Tab("ESP")
local Move = Tab("Move")
local Combat = Tab("Combat")
local Visual = Tab("Visual")
local TP = Tab("TP")

-- ESP Tab
Toggle(ESP, "ESP Enabled", function(v)
    cfg.esp = v
    if v then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                if cfg.espMode == 1 then
                    AddESPV1(plr)
                elseif cfg.espMode == 2 then
                    AddESPV2(plr)
                elseif cfg.espMode == 3 then
                    AddESPV3(plr)
                elseif cfg.espMode == 4 then
                    AddESPV4(plr)
                end
            end
        end
    else
        RemoveAllESP()
    end
end)

Btn(ESP, "ESP V1 - Minimal", function()
    cfg.espMode = 1
    RemoveAllESP()
    if cfg.esp then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                AddESPV1(plr)
            end
        end
    end
    print("[VD] ESP Mode: V1 - Minimal")
end)

Btn(ESP, "ESP V2 - Box", function()
    cfg.espMode = 2
    RemoveAllESP()
    if cfg.esp then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                AddESPV2(plr)
            end
        end
    end
    print("[VD] ESP Mode: V2 - Box")
end)

Btn(ESP, "ESP V3 - Health Bar", function()
    cfg.espMode = 3
    RemoveAllESP()
    if cfg.esp then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                AddESPV3(plr)
            end
        end
    end
    print("[VD] ESP Mode: V3 - Health Bar")
end)

Btn(ESP, "ESP V4 - Chams", function()
    cfg.espMode = 4
    RemoveAllESP()
    if cfg.esp then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                AddESPV4(plr)
            end
        end
    end
    print("[VD] ESP Mode: V4 - Chams")
end)

Toggle(ESP, "RGB Mode", function(v)
    cfg.espRGB = v
end)

-- Movement
Slider(Move, "Speed", 16, 500, 16, function(v)
    cfg.speed = v
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = v
    end
end)

Slider(Move, "Jump", 50, 500, 50, function(v)
    cfg.jump = v
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.JumpPower = v
    end
end)

local noclipCon
Toggle(Move, "Noclip", function(v)
    cfg.noclip = v
    if v then
        noclipCon = RunService.Stepped:Connect(function()
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end)
    else
        if noclipCon then
            noclipCon:Disconnect()
        end
    end
end)

local flyCon
Toggle(Move, "Fly", function(v)
    cfg.fly = v
    if v then
        local hrp = Character.HumanoidRootPart
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9e9
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        flyCon = RunService.RenderStepped:Connect(function()
            bg.CFrame = Camera.CFrame
            local vel = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Camera.CFrame.LookVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Camera.CFrame.LookVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Camera.CFrame.RightVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Camera.CFrame.RightVector * cfg.flyspeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, cfg.flyspeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, cfg.flyspeed, 0) end
            
            bv.Velocity = vel
        end)
    else
        if flyCon then flyCon:Disconnect() end
        for _, v in pairs(Character.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end)

Slider(Move, "Fly Speed", 10, 200, 50, function(v)
    cfg.flyspeed = v
end)

-- Combat Tab
Toggle(Combat, "God V1 - Health Regen", function(v)
    cfg.godv1 = v
    if v then
        cfg.godv2 = false
        cfg.godv3 = false
        cfg.godv4 = false
        cfg.godv5 = false
        StopAllGod()
        GodV1(true)
    else
        GodV1(false)
    end
end)

Toggle(Combat, "God V2 - Humanoid Replace", function(v)
    cfg.godv2 = v
    if v then
        cfg.godv1 = false
        cfg.godv3 = false
        cfg.godv4 = false
        cfg.godv5 = false
        StopAllGod()
        GodV2(true)
    else
        GodV2(false)
    end
end)

Toggle(Combat, "God V3 - Force Field", function(v)
    cfg.godv3 = v
    if v then
        cfg.godv1 = false
        cfg.godv2 = false
        cfg.godv4 = false
        cfg.godv5 = false
        StopAllGod()
        GodV3(true)
    else
        GodV3(false)
    end
end)

Toggle(Combat, "God V4 - ULTIMATE", function(v)
    cfg.godv4 = v
    if v then
        cfg.godv1 = false
        cfg.godv2 = false
        cfg.godv3 = false
        cfg.godv5 = false
        StopAllGod()
        GodV4(true)
    else
        GodV4(false)
    end
end)

Toggle(Combat, "God V5 - INVINCIBLE", function(v)
    cfg.godv5 = v
    if v then
        cfg.godv1 = false
        cfg.godv2 = false
        cfg.godv3 = false
        cfg.godv4 = false
        StopAllGod()
        GodV5(true)
    else
        GodV5(false)
    end
end)

local aimCon
Toggle(Combat, "Auto Aim", function(v)
    cfg.aim = v
    if v then
        aimCon = RunService.RenderStepped:Connect(function()
            local target = GetClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if aimCon then aimCon:Disconnect() end
    end
end)

Toggle(Combat, "Show FOV Circle", function(v)
    cfg.aimcircle = v
    FOVCircle.Visible = v
end)

Slider(Combat, "FOV Size", 50, 500, 100, function(v)
    cfg.aimfov = v
    FOVCircle.Radius = v
end)

-- Visual
Toggle(Visual, "No Fog", function(v)
    cfg.fog = v
    Lighting.FogEnd = v and 100000 or 1000
end)

Toggle(Visual, "Full Bright", function(v)
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

local crosshair
Toggle(Visual, "Crosshair", function(v)
    cfg.cross = v
    if v then
        crosshair = Instance.new("ScreenGui", VD)
        
        local function line(x, y, w, h)
            local l = Instance.new("Frame", crosshair)
            l.AnchorPoint = Vector2.new(0.5, 0.5)
            l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            l.BorderSizePixel = 0
            l.Position = UDim2.new(0.5, x, 0.5, y)
            l.Size = UDim2.new(0, w, 0, h)
        end
        
        line(0, -10, 2, 8)
        line(0, 10, 2, 8)
        line(-10, 0, 8, 2)
        line(10, 0, 8, 2)
    else
        if crosshair then crosshair:Destroy() end
    end
end)

Slider(Visual, "FOV", 70, 120, 70, function(v)
    cfg.fov = v
    Camera.FieldOfView = v
end)

-- Teleport
Btn(TP, "TP to Closest", function()
    local target = GetClosestInFOV()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

Btn(TP, "TP to Random", function()
    local plrs = Players:GetPlayers()
    if #plrs > 1 then
        local rnd = plrs[math.random(1, #plrs)]
        if rnd ~= Player and rnd.Character and rnd.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = rnd.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- UI Control
Open.MouseButton1Click:Connect(function()
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 450)}):Play()
end)

Close.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    Main.Visible = false
end)

-- Update FOV Circle Position
RunService.RenderStepped:Connect(function()
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = cfg.speed
        Character.Humanoid.JumpPower = cfg.jump
    end
    
    -- Update FOV Circle
    if cfg.aimcircle then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = cfg.aimfov
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
    
    -- Update ESP
    if cfg.esp then
        UpdateESP()
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        if cfg.esp then
            if cfg.espMode == 1 then
                AddESPV1(plr)
            elseif cfg.espMode == 2 then
                AddESPV2(plr)
            elseif cfg.espMode == 3 then
                AddESPV3(plr)
            elseif cfg.espMode == 4 then
                AddESPV4(plr)
            end
        end
    end)
end)

Player.CharacterAdded:Connect(function(char)
    Character = char
    wait(1)
    
    if cfg.godv1 then
        GodV1(true)
    elseif cfg.godv2 then
        GodV2(true)
    elseif cfg.godv3 then
        GodV3(true)
    elseif cfg.godv4 then
        GodV4(true)
    elseif cfg.godv5 then
        GodV5(true)
    end
    
    if cfg.noclip then
        noclipCon = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end)
    end
end)

print("[VD] Loaded!")
print("[VD] ESP Modes: V1-V4 | God Modes: V1-V5")
print("[VD] FOV Aim Circle Ready")
