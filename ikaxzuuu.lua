-- Violence District Script for Delta X Mobile
-- Made for Android Delta X Executor
-- NO KEY SYSTEM | Mobile Optimized

print("Violence District Script Loading...")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Settings Storage
local Settings = {
    ESPPlayers = false,
    ESPGenerators = false,
    RGBMode = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    GodMode = false,
    AntiStun = false,
    AutoAim = false,
    AutoAimRange = 50,
    AutoKill = false,
    NoFog = false,
    FullBright = false,
    Crosshair = false,
    FOV = 70
}

-- Connections Storage
local Connections = {}
local ESPObjects = {}
local FlyConnection = nil
local NoclipConnection = nil

-- Parent Detection (Delta X Compatible)
local function GetParent()
    local success, result = pcall(function()
        return gethui()
    end)
    if success and result then
        print("Using gethui() as parent")
        return result
    else
        print("Using CoreGui as parent")
        return CoreGui
    end
end

-- Helper Functions
local function IsPlayerKiller(player)
    pcall(function()
        if player.Character then
            local tag = player.Character:FindFirstChild("Killer") or player:FindFirstChild("Killer")
            return tag ~= nil
        end
    end)
    return false
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Settings.AutoAimRange
    
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end)
    
    return closestPlayer
end

local function CreateESP(player)
    pcall(function()
        if ESPObjects[player] then return end
        if not player.Character then return end
        
        local character = player.Character
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local BillboardGui = Instance.new("BillboardGui")
        local Frame = Instance.new("Frame")
        local NameLabel = Instance.new("TextLabel")
        local DistanceLabel = Instance.new("TextLabel")
        
        BillboardGui.Parent = hrp
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        
        Frame.Parent = BillboardGui
        Frame.BackgroundColor3 = IsPlayerKiller(player) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
        Frame.BackgroundTransparency = 0.5
        Frame.BorderSizePixel = 2
        Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        
        NameLabel.Parent = Frame
        NameLabel.BackgroundTransparency = 1
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.Text = player.Name
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.TextScaled = true
        
        DistanceLabel.Parent = Frame
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DistanceLabel.TextScaled = true
        
        ESPObjects[player] = {
            BillboardGui = BillboardGui,
            Frame = Frame,
            DistanceLabel = DistanceLabel
        }
        
        -- Update Distance
        local conn = RunService.RenderStepped:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                    DistanceLabel.Text = math.floor(dist) .. " studs"
                    
                    if Settings.RGBMode then
                        local hue = tick() % 5 / 5
                        Frame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    end
                end
            end)
        end)
        
        table.insert(Connections, conn)
    end)
end

local function RemoveESP(player)
    pcall(function()
        if ESPObjects[player] then
            ESPObjects[player].BillboardGui:Destroy()
            ESPObjects[player] = nil
        end
    end)
end

local function UpdateAllESP()
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                RemoveESP(player)
                if Settings.ESPPlayers then
                    CreateESP(player)
                end
            end
        end
    end)
end

local function StartNoclip()
    pcall(function()
        if NoclipConnection then return end
        print("Noclip Enabled")
        
        NoclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end)
    end)
end

local function StopNoclip()
    pcall(function()
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
            print("Noclip Disabled")
        end
    end)
end

local function StartFly()
    pcall(function()
        if FlyConnection then return end
        print("Fly Enabled")
        
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Parent = HumanoidRootPart
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.Parent = HumanoidRootPart
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.P = 9e9
        
        FlyConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                local speed = Settings.FlySpeed
                BodyGyro.CFrame = Camera.CFrame
                
                local velocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + (Camera.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - (Camera.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - (Camera.CFrame.RightVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + (Camera.CFrame.RightVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + (Vector3.new(0, speed, 0))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity - (Vector3.new(0, speed, 0))
                end
                
                BodyVelocity.Velocity = velocity
            end)
        end)
    end)
end

local function StopFly()
    pcall(function()
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
            
            for _, obj in pairs(HumanoidRootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                    obj:Destroy()
                end
            end
            
            print("Fly Disabled")
        end
    end)
end

local function StartGodMode()
    pcall(function()
        print("God Mode Enabled")
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        Connections.GodMode = Humanoid.HealthChanged:Connect(function(health)
            if health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end)
end

local function StopGodMode()
    pcall(function()
        if Connections.GodMode then
            Connections.GodMode:Disconnect()
            Connections.GodMode = nil
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            print("God Mode Disabled")
        end
    end)
end

local function StartAutoAim()
    pcall(function()
        print("Auto Aim Enabled")
        
        Connections.AutoAim = RunService.RenderStepped:Connect(function()
            pcall(function()
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
                    
                    if Settings.AutoKill then
                        -- Add your game's attack function here
                        -- Example: fireremote, click, etc.
                    end
                end
            end)
        end)
    end)
end

local function StopAutoAim()
    pcall(function()
        if Connections.AutoAim then
            Connections.AutoAim:Disconnect()
            Connections.AutoAim = nil
            print("Auto Aim Disabled")
        end
    end)
end

local function CreateCrosshair()
    pcall(function()
        local CrosshairGui = Instance.new("ScreenGui")
        CrosshairGui.Name = "Crosshair"
        CrosshairGui.Parent = GetParent()
        CrosshairGui.DisplayOrder = 999999
        CrosshairGui.IgnoreGuiInset = true
        
        local Center = Instance.new("Frame")
        Center.Parent = CrosshairGui
        Center.AnchorPoint = Vector2.new(0.5, 0.5)
        Center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Center.BorderSizePixel = 0
        Center.Position = UDim2.new(0.5, 0, 0.5, 0)
        Center.Size = UDim2.new(0, 4, 0, 4)
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Center
        
        -- Lines
        local function createLine(pos, size)
            local line = Instance.new("Frame")
            line.Parent = CrosshairGui
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BorderSizePixel = 0
            line.Position = pos
            line.Size = size
            return line
        end
        
        createLine(UDim2.new(0.5, 0, 0.5, -15), UDim2.new(0, 2, 0, 10))
        createLine(UDim2.new(0.5, 0, 0.5, 15), UDim2.new(0, 2, 0, 10))
        createLine(UDim2.new(0.5, -15, 0.5, 0), UDim2.new(0, 10, 0, 2))
        createLine(UDim2.new(0.5, 15, 0.5, 0), UDim2.new(0, 10, 0, 2))
        
        return CrosshairGui
    end)
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictGUI"
ScreenGui.Parent = GetParent()
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Floating Button
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Parent = ScreenGui
FloatingButton.AnchorPoint = Vector2.new(0, 0.5)
FloatingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
FloatingButton.Position = UDim2.new(0, 10, 0.5, 0)
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Image = "https://files.catbox.moe/8h7dgs.jpg"
FloatingButton.Draggable = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatingButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Visible = false
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Violence District"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Position = UDim2.new(1, -5, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Scrolling Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1500)
ScrollFrame.ScrollBarThickness = 6

-- Feature Creation Functions
local YOffset = 10

local function CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Parent = ScrollFrame
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Section.Position = UDim2.new(0, 5, 0, YOffset)
    Section.Size = UDim2.new(1, -10, 0, 35)
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = name
    SectionLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    SectionLabel.TextSize = 16
    
    YOffset = YOffset + 45
    return Section
end

local function CreateToggle(name, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = name
    Toggle.Parent = ScrollFrame
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Toggle.Position = UDim2.new(0, 5, 0, YOffset)
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = Toggle
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = Toggle
    ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleButton.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton
    
    local enabled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        }
        
        TweenService:Create(ToggleButton, tweenInfo, goal):Play()
        ToggleButton.Text = enabled and "ON" or "OFF"
        
        pcall(function()
            callback(enabled)
        end)
        
        print(name .. " toggled: " .. tostring(enabled))
    end)
    
    YOffset = YOffset + 50
    return Toggle
end

local function CreateSlider(name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = name
    Slider.Parent = ScrollFrame
    Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Slider.Position = UDim2.new(0, 5, 0, YOffset)
    Slider.Size = UDim2.new(1, -10, 0, 60)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = Slider
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = Slider
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. default
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = Slider
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    SliderBar.Position = UDim2.new(0, 10, 0, 35)
    SliderBar.Size = UDim2.new(1, -20, 0, 15)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderLabel.Text = name .. ": " .. value
        
        pcall(function()
            callback(value)
        end)
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    YOffset = YOffset + 70
    return Slider
end

local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = ScrollFrame
    Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Button.Position = UDim2.new(0, 5, 0, YOffset)
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local shrink = TweenService:Create(Button, tweenInfo, {Size = UDim2.new(1, -15, 0, 35)})
        local grow = TweenService:Create(Button, tweenInfo, {Size = UDim2.new(1, -10, 0, 40)})
        
        shrink:Play()
        shrink.Completed:Connect(function()
            grow:Play()
        end)
        
        pcall(function()
            callback()
        end)
        
        print(name .. " clicked")
    end)
    
    YOffset = YOffset + 50
    return Button
end

-- Build UI
CreateSection("ESP")

CreateToggle("ESP Players", function(enabled)
    Settings.ESPPlayers = enabled
    if enabled then
        UpdateAllESP()
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
    end
end)

CreateToggle("ESP Generators", function(enabled)
    Settings.ESPGenerators = enabled
    -- Add generator ESP logic here
end)

CreateToggle("RGB ESP Mode", function(enabled)
    Settings.RGBMode = enabled
end)

CreateSection("Movement")

CreateSlider("Walk Speed", 16, 500, 16, function(value)
    Settings.WalkSpeed = value
    if Humanoid then
        Humanoid.WalkSpeed = value
    end
end)

CreateSlider("Jump Power", 50, 500, 50, function(value)
    Settings.JumpPower = value
    if Humanoid then
        Humanoid.JumpPower = value
    end
end)

CreateToggle("Noclip", function(enabled)
    Settings.Noclip = enabled
    if enabled then
        StartNoclip()
    else
        StopNoclip()
    end
end)

CreateToggle("Fly", function(enabled)
    Settings.Fly = enabled
    if enabled then
        StartFly()
    else
        StopFly()
    end
end)

CreateSlider("Fly Speed", 10, 200, 50, function(value)
    Settings.FlySpeed = value
end)

CreateSection("Combat")

CreateToggle("God Mode", function(enabled)
    Settings.GodMode = enabled
    if enabled then
        StartGodMode()
    else
        StopGodMode()
    end
end)

CreateToggle("Anti Stun", function(enabled)
    Settings.AntiStun = enabled
    -- Add anti-stun logic
end)

CreateToggle("Auto Aim", function(enabled)
    Settings.AutoAim = enabled
    if enabled then
        StartAutoAim()
    else
        StopAutoAim()
    end
end)

CreateSlider("Auto Aim Range", 10, 100, 50, function(value)
    Settings.AutoAimRange = value
end)

CreateToggle("Auto Kill", function(enabled)
    Settings.AutoKill = enabled
end)

CreateSection("Visual")

CreateToggle("No Fog", function(enabled)
    Settings.NoFog = enabled
    if enabled then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 1000
    end
end)

CreateToggle("Full Bright", function(enabled)
    Settings.FullBright = enabled
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

local CrosshairObj = nil
CreateToggle("Crosshair", function(enabled)
    Settings.Crosshair = enabled
    if enabled then
        CrosshairObj = CreateCrosshair()
    else
        if CrosshairObj then
            CrosshairObj:Destroy()
        end
    end
end)

CreateSlider("FOV", 70, 120, 70, function(value)
    Settings.FOV = value
    Camera.FieldOfView = value
end)

CreateSection("Teleport")

CreateButton("TP to Closest Player", function()
    local target = GetClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        print("Teleported to " .. target.Name)
    else
        print("No player found")
    end
end)

CreateButton("TP to Random Player", function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer ~= Player and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            print("Teleported to " .. randomPlayer.Name)
        end
    end
end)

-- Floating Button Toggle
FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        local goal = {Size = UDim2.new(0, 400, 0, 500)}
        TweenService:Create(MainFrame, tweenInfo, goal):Play()
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local goal = {Size = UDim2.new(0, 0, 0, 0)}
    local tween = TweenService:Create(MainFrame, tweenInfo, goal)
    
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
end)

-- Auto-Update Movement
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Humanoid then
            if Settings.WalkSpeed ~= 16 then
                Humanoid.WalkSpeed = Settings.WalkSpeed
            end
            if Settings.JumpPower ~= 50 then
                Humanoid.JumpPower = Settings.JumpPower
            end
        end
    end)
end)

-- Player Added ESP
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if Settings.ESPPlayers then
            CreateESP(player)
        end
    end)
end)

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    wait(1)
    
    -- Reapply settings
    if Settings.GodMode then
        StartGodMode()
    end
    if Settings.Noclip then
        StartNoclip()
    end
    if Settings.Fly then
        StartFly()
    end
    if Settings.AutoAim then
        StartAutoAim()
    end
end)

-- Notification
local function CreateNotification(text)
    local Notif = Instance.new("Frame")
    Notif.Parent = ScreenGui
    Notif.AnchorPoint = Vector2.new(0.5, 0)
    Notif.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Notif.Position = UDim2.new(0.5, 0, 0, -100)
    Notif.Size = UDim2.new(0, 300, 0, 60)
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notif
    
    local NotifLabel = Instance.new("TextLabel")
    NotifLabel.Parent = Notif
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Size = UDim2.new(1, 0, 1, 0)
    NotifLabel.Font = Enum.Font.GothamBold
    NotifLabel.Text = text
    NotifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifLabel.TextSize = 16
    
    local tweenIn = TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, 0, 0, 20)})
    tweenIn:Play()
    
    wait(3)
    
    local tweenOut = TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, 0, 0, -100)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        Notif:Destroy()
    end)
end

-- Load Notification
CreateNotification("Violence District LOADED!")
print("Violence District Script Loaded Successfully!")
print("Made for Delta X Mobile")