-- Violence District Script -- Violence District | Clean & Minimal UI
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

-- Settings
local cfg = {
    esp = false,
    espRGB = false,
    speed = 16,
    jump = 50,
    noclip = false,
    fly = false,
    flyspeed = 50,
    god = false,
    aim = false,
    aimrange = 50,
    fog = false,
    bright = false,
    cross = false,
    fov = 70
}

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

-- Build UI
local ESP = Tab("ESP")
local Move = Tab("Move")
local Combat = Tab("Combat")
local Visual = Tab("Visual")
local TP = Tab("TP")

-- ESP Functions
local espObjects = {}

local function AddESP(plr)
    if espObjects[plr] or not plr.Character then return end
    
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Parent = hrp
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 100, 0, 50)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    
    local frame = Instance.new("Frame", esp)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 4)
    
    local name = Instance.new("TextLabel", frame)
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = plr.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextSize = 12
    
    local dist = Instance.new("TextLabel", frame)
    dist.Position = UDim2.new(0, 0, 0.5, 0)
    dist.Size = UDim2.new(1, 0, 0.5, 0)
    dist.BackgroundTransparency = 1
    dist.Font = Enum.Font.Gotham
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist.TextSize = 11
    
    espObjects[plr] = {esp = esp, frame = frame, dist = dist}
    
    RunService.RenderStepped:Connect(function()
        if cfg.esp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            dist.Text = math.floor(d) .. "m"
            
            if cfg.espRGB then
                local hue = tick() % 5 / 5
                frame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            end
        end
    end)
end

local function RemoveESP(plr)
    if espObjects[plr] then
        espObjects[plr].esp:Destroy()
        espObjects[plr] = nil
    end
end

-- ESP Tab
Toggle(ESP, "Player ESP", function(v)
    cfg.esp = v
    if v then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                AddESP(plr)
            end
        end
    else
        for plr, _ in pairs(espObjects) do
            RemoveESP(plr)
        end
    end
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

-- Combat
local godCon
Toggle(Combat, "God Mode", function(v)
    cfg.god = v
    local hum = Character:FindFirstChild("Humanoid")
    if v and hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        godCon = hum.HealthChanged:Connect(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        if godCon then godCon:Disconnect() end
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end)

local function GetClosest()
    local closest, dist = nil, cfg.aimrange
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                closest = plr
                dist = d
            end
        end
    end
    return closest
end

local aimCon
Toggle(Combat, "Auto Aim", function(v)
    cfg.aim = v
    if v then
        aimCon = RunService.RenderStepped:Connect(function()
            local target = GetClosest()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if aimCon then aimCon:Disconnect() end
    end
end)

Slider(Combat, "Aim Range", 10, 100, 50, function(v)
    cfg.aimrange = v
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
    local target = GetClosest()
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

-- Auto Update
RunService.RenderStepped:Connect(function()
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = cfg.speed
        Character.Humanoid.JumpPower = cfg.jump
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        if cfg.esp then
            AddESP(plr)
        end
    end)
end)

Player.CharacterAdded:Connect(function(char)
    Character = char
    wait(1)
    
    if cfg.god then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            godCon = hum.HealthChanged:Connect(function()
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        end
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
