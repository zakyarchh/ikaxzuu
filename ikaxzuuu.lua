-- Violence District Premium UI Script for Delta X Mobile
-- NO KEY SYSTEM | Professional UI Design
-- Made for Android Delta X Executor

print("Violence District Premium Loading...")

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
        local HealthBar = Instance.new("Frame")
        local HealthFill = Instance.new("Frame")
        
        BillboardGui.Parent = hrp
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 200, 0, 80)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        
        Frame.Parent = BillboardGui
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Frame.BackgroundTransparency = 0.3
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 1, 0)
        
        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 8)
        FrameCorner.Parent = Frame
        
        local FrameStroke = Instance.new("UIStroke")
        FrameStroke.Color = IsPlayerKiller(player) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 100)
        FrameStroke.Thickness = 2
        FrameStroke.Parent = Frame
        
        NameLabel.Parent = Frame
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0, 0, 0, 5)
        NameLabel.Size = UDim2.new(1, 0, 0, 25)
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.Text = player.Name
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.TextSize = 16
        NameLabel.TextStrokeTransparency = 0.5
        
        DistanceLabel.Parent = Frame
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.Position = UDim2.new(0, 0, 0, 30)
        DistanceLabel.Size = UDim2.new(1, 0, 0, 20)
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        DistanceLabel.TextSize = 14
        DistanceLabel.TextStrokeTransparency = 0.5
        
        HealthBar.Parent = Frame
        HealthBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        HealthBar.BorderSizePixel = 0
        HealthBar.Position = UDim2.new(0, 10, 1, -15)
        HealthBar.Size = UDim2.new(1, -20, 0, 8)
        
        local HealthBarCorner = Instance.new("UICorner")
        HealthBarCorner.CornerRadius = UDim.new(1, 0)
        HealthBarCorner.Parent = HealthBar
        
        HealthFill.Parent = HealthBar
        HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        HealthFill.BorderSizePixel = 0
        HealthFill.Size = UDim2.new(1, 0, 1, 0)
        
        local HealthFillCorner = Instance.new("UICorner")
        HealthFillCorner.CornerRadius = UDim.new(1, 0)
        HealthFillCorner.Parent = HealthFill
        
        ESPObjects[player] = {
            BillboardGui = BillboardGui,
            Frame = Frame,
            FrameStroke = FrameStroke,
            DistanceLabel = DistanceLabel,
            HealthFill = HealthFill
        }
        
        -- Update Distance & Health
        local conn = RunService.RenderStepped:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local dist = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                    DistanceLabel.Text = math.floor(dist) .. " studs"
                    
                    local humanoid = player.Character.Humanoid
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    HealthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                    
                    if Settings.RGBMode then
                        local hue = tick() % 5 / 5
                        FrameStroke.Color = Color3.fromHSV(hue, 1, 1)
                        HealthFill.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 1)
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
        Center.Size = UDim2.new(0, 6, 0, 6)
        
        local CenterCorner = Instance.new("UICorner")
        CenterCorner.CornerRadius = UDim.new(1, 0)
        CenterCorner.Parent = Center
        
        local CenterStroke = Instance.new("UIStroke")
        CenterStroke.Color = Color3.fromRGB(0, 0, 0)
        CenterStroke.Thickness = 1
        CenterStroke.Parent = Center
        
        local function createLine(pos, size)
            local line = Instance.new("Frame")
            line.Parent = CrosshairGui
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BorderSizePixel = 0
            line.Position = pos
            line.Size = size
            
            local lineStroke = Instance.new("UIStroke")
            lineStroke.Color = Color3.fromRGB(0, 0, 0)
            lineStroke.Thickness = 1
            lineStroke.Parent = line
            
            return line
        end
        
        createLine(UDim2.new(0.5, 0, 0.5, -20), UDim2.new(0, 2, 0, 12))
        createLine(UDim2.new(0.5, 0, 0.5, 20), UDim2.new(0, 2, 0, 12))
        createLine(UDim2.new(0.5, -20, 0.5, 0), UDim2.new(0, 12, 0, 2))
        createLine(UDim2.new(0.5, 20, 0.5, 0), UDim2.new(0, 12, 0, 2))
        
        return CrosshairGui
    end)
end

-- UI Creation with Premium Design
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictPremiumGUI"
ScreenGui.Parent = GetParent()
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Floating Button with Gradient
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Parent = ScreenGui
FloatingButton.AnchorPoint = Vector2.new(0, 0.5)
FloatingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
FloatingButton.Position = UDim2.new(0, 15, 0.5, 0)
FloatingButton.Size = UDim2.new(0, 70, 0, 70)
FloatingButton.Image = "https://files.catbox.moe/8h7dgs.jpg"
FloatingButton.ScaleType = Enum.ScaleType.Crop
FloatingButton.Draggable = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 15)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Thickness = 3
FloatStroke.Transparency = 0.5
FloatStroke.Parent = FloatingButton

local FloatGradient = Instance.new("UIGradient")
FloatGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
}
FloatGradient.Rotation = 45
FloatGradient.Parent = FloatingButton

local FloatShadow = Instance.new("ImageLabel")
FloatShadow.Name = "Shadow"
FloatShadow.Parent = FloatingButton
FloatShadow.AnchorPoint = Vector2.new(0.5, 0.5)
FloatShadow.BackgroundTransparency = 1
FloatShadow.Position = UDim2.new(0.5, 0, 0.5, 5)
FloatShadow.Size = UDim2.new(1, 20, 1, 20)
FloatShadow.ZIndex = -1
FloatShadow.Image = "rbxassetid://6014261993"
FloatShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
FloatShadow.ImageTransparency = 0.5

-- Pulse Animation for Floating Button
local function PulseAnimation()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local goal = {Size = UDim2.new(0, 75, 0, 75)}
    TweenService:Create(FloatingButton, tweenInfo, goal):Play()
end
PulseAnimation()

-- Main Frame with Modern Design
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.Parent = MainFrame
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 8)
MainShadow.Size = UDim2.new(1, 30, 1, 30)
MainShadow.ZIndex = -1
MainShadow.Image = "rbxassetid://6014261993"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.3

-- Title Bar with Gradient
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
TitleBar.Size = UDim2.new(1, 0, 0, 50)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
}
TitleGradient.Rotation = 45
TitleGradient.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Parent = TitleBar
TitleFix.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
TitleFix.BorderSizePixel = 0
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.Size = UDim2.new(1, 0, 0, 10)

local TitleFixGradient = Instance.new("UIGradient")
TitleFixGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
}
TitleFixGradient.Rotation = 45
TitleFixGradient.Parent = TitleFix

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Parent = TitleBar
TitleIcon.BackgroundTransparency = 1
TitleIcon.Position = UDim2.new(0, 10, 0.5, 0)
TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
TitleIcon.Size = UDim2.new(0, 35, 0, 35)
TitleIcon.Image = "https://files.catbox.moe/8h7dgs.jpg"
TitleIcon.ScaleType = Enum.ScaleType.Crop

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 8)
IconCorner.Parent = TitleIcon

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 55, 0, 0)
TitleLabel.Size = UDim2.new(1, -110, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "VIOLENCE DISTRICT"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleSubLabel = Instance.new("TextLabel")
TitleSubLabel.Parent = TitleBar
TitleSubLabel.BackgroundTransparency = 1
TitleSubLabel.Position = UDim2.new(0, 55, 0, 20)
TitleSubLabel.Size = UDim2.new(1, -110, 0, 20)
TitleSubLabel.Font = Enum.Font.Gotham
TitleSubLabel.Text = "Premium Edition"
TitleSubLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
TitleSubLabel.TextSize = 12
TitleSubLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleSubLabel.TextTransparency = 0.3

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.AnchorPoint = Vector2.new(1, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MinimizeButton.Position = UDim2.new(1, -45, 0, 10)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Position = UDim2.new(1, -10, 0, 10)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.Size = UDim2.new(0, 120, 1, -50)

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 12)
TabCorner.Parent = TabContainer

local TabFix = Instance.new("Frame")
TabFix.Parent = TabContainer
TabFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TabFix.BorderSizePixel = 0
TabFix.Position = UDim2.new(1, -10, 0, 0)
TabFix.Size = UDim2.new(0, 10, 1, 0)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabContainer
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.PaddingRight = UDim.new(0, 8)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 130, 0, 60)
ContentContainer.Size = UDim2.new(1, -140, 1, -70)

-- Tab Creation Variables
local ActiveTab = nil
local Tabs = {}

local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TabButton.Size = UDim2.new(1, 0, 0, 45)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabButton.TextSize = 13
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.AutoButtonColor = false
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 8)
    TabButtonCorner.Parent = TabButton
    
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Parent = TabButton
    TabIcon.BackgroundTransparency = 1
    TabIcon.Position = UDim2.new(0, 8, 0, 0)
    TabIcon.Size = UDim2.new(0, 30, 1, 0)
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.Text = icon
    TabIcon.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabIcon.TextSize = 18
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    TabContent.Visible = false
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local function ActivateTab()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            tab.Button.TextColor3 = Color3.fromRGB(150, 150, 160)
            tab.Icon.TextColor3 = Color3.fromRGB(150, 150, 160)
            tab.Content.Visible = false
        end
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(TabButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
        TweenService:Create(TabButton, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(TabIcon, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        
        TabContent.Visible = true
        ActiveTab = name
    end
    
    TabButton.MouseButton1Click:Connect(ActivateTab)
    
    Tabs[name] = {
        Button = TabButton,
        Icon = TabIcon,
        Content = TabContent
    }
    
    if not ActiveTab then
        ActivateTab()
    end
    
    return TabContent
end

-- Feature Creation Functions
local function CreateToggle(parent, name, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = name
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Toggle.Size = UDim2.new(1, 0, 0, 50)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = Toggle
    
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(40, 40, 50)
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.5
    ToggleStroke.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = Toggle
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.Size = UDim2.new(0.65, 0, 1, 0)
    ToggleLabel.Font = Enum.Font.GothamBold
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Parent = Toggle
    ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
    ToggleSwitch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleSwitch.Position = UDim2.new(1, -15, 0.5, 0)
    ToggleSwitch.Size = UDim2.new(0, 50, 0, 26)
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = ToggleSwitch
    
    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Parent = ToggleSwitch
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    SwitchKnob.Position = UDim2.new(0, 3, 0.5, 0)
    SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
    SwitchKnob.Size = UDim2.new(0, 20, 0, 20)
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = Toggle
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.Text = ""
    
    local enabled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if enabled then
            TweenService:Create(ToggleSwitch, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(SwitchKnob, tweenInfo, {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
            TweenService:Create(SwitchKnob, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(ToggleStroke, tweenInfo, {Color = Color3.fromRGB(100, 100, 255)}):Play()
        else
            TweenService:Create(ToggleSwitch, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
            TweenService:Create(SwitchKnob, tweenInfo, {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
            TweenService:Create(SwitchKnob, tweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 200, 210)}):Play()
            TweenService:Create(ToggleStroke, tweenInfo, {Color = Color3.fromRGB(40, 40, 50)}):Play()
        end
        
        pcall(function()
            callback(enabled)
        end)
        
        print(name .. " toggled: " .. tostring(enabled))
    end)
    
    return Toggle
end

local function CreateSlider(parent, name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = name
    Slider.Parent = parent
    Slider.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Slider.Size = UDim2.new(1, 0, 0, 70)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = Slider
    
    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Color = Color3.fromRGB(40, 40, 50)
    SliderStroke.Thickness = 1
    SliderStroke.Transparency = 0.5
    SliderStroke.Parent = Slider
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = Slider
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 15, 0, 8)
    SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SliderLabel.Font = Enum.Font.GothamBold
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = Slider
    ValueLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    ValueLabel.Position = UDim2.new(1, -65, 0, 8)
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 12
    
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 6)
    ValueCorner.Parent = ValueLabel
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = Slider
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBar.Position = UDim2.new(0, 15, 0, 42)
    SliderBar.Size = UDim2.new(1, -30, 0, 18)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 9)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BorderSizePixel = 0
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 9)
    FillCorner.Parent = SliderFill
    
    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
    }
    FillGradient.Parent = SliderFill
    
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
        
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(SliderFill, tweenInfo, {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        
        ValueLabel.Text = tostring(value)
        
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
    
    return Slider
end

local function CreateButton(parent, name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
    }
    ButtonGradient.Rotation = 45
    ButtonGradient.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local shrink = TweenService:Create(Button, tweenInfo, {Size = UDim2.new(1, -5, 0, 42)})
        local grow = TweenService:Create(Button, tweenInfo, {Size = UDim2.new(1, 0, 0, 45)})
        
        shrink:Play()
        shrink.Completed:Connect(function()
            grow:Play()
        end)
        
        pcall(function()
            callback()
        end)
        
        print(name .. " clicked")
    end)
    
    return Button
end

-- Build Tabs
local ESPTab = CreateTab("ESP", "👁")
local MovementTab = CreateTab("Movement", "🏃")
local CombatTab = CreateTab("Combat", "⚔")
local VisualTab = CreateTab("Visual", "🎨")
local TeleportTab = CreateTab("Teleport", "📍")

-- ESP Tab Content
CreateToggle(ESPTab, "Player ESP", function(enabled)
    Settings.ESPPlayers = enabled
    if enabled then
        UpdateAllESP()
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
    end
end)

CreateToggle(ESPTab, "Generator ESP", function(enabled)
    Settings.ESPGenerators = enabled
end)

CreateToggle(ESPTab, "RGB ESP Mode", function(enabled)
    Settings.RGBMode = enabled
end)

-- Movement Tab Content
CreateSlider(MovementTab, "Walk Speed", 16, 500, 16, function(value)
    Settings.WalkSpeed = value
    if Humanoid then
        Humanoid.WalkSpeed = value
    end
end)

CreateSlider(MovementTab, "Jump Power", 50, 500, 50, function(value)
    Settings.JumpPower = value
    if Humanoid then
        Humanoid.JumpPower = value
    end
end)

CreateToggle(MovementTab, "Noclip", function(enabled)
    Settings.Noclip = enabled
    if enabled then
        StartNoclip()
    else
        StopNoclip()
    end
end)

CreateToggle(MovementTab, "Fly Mode", function(enabled)
    Settings.Fly = enabled
    if enabled then
        StartFly()
    else
        StopFly()
    end
end)

CreateSlider(MovementTab, "Fly Speed", 10, 200, 50, function(value)
    Settings.FlySpeed = value
end)

-- Combat Tab Content
CreateToggle(CombatTab, "God Mode", function(enabled)
    Settings.GodMode = enabled
    if enabled then
        StartGodMode()
    else
        StopGodMode()
    end
end)

CreateToggle(CombatTab, "Anti Stun", function(enabled)
    Settings.AntiStun = enabled
end)

CreateToggle(CombatTab, "Auto Aim", function(enabled)
    Settings.AutoAim = enabled
    if enabled then
        StartAutoAim()
    else
        StopAutoAim()
    end
end)

CreateSlider(CombatTab, "Auto Aim Range", 10, 100, 50, function(value)
    Settings.AutoAimRange = value
end)

CreateToggle(CombatTab, "Auto Kill", function(enabled)
    Settings.AutoKill = enabled
end)

-- Visual Tab Content
CreateToggle(VisualTab, "No Fog", function(enabled)
    Settings.NoFog = enabled
    if enabled then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 1000
    end
end)

CreateToggle(VisualTab, "Full Bright", function(enabled)
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
CreateToggle(VisualTab, "Crosshair", function(enabled)
    Settings.Crosshair = enabled
    if enabled then
        CrosshairObj = CreateCrosshair()
    else
        if CrosshairObj then
            CrosshairObj:Destroy()
        end
    end
end)

CreateSlider(VisualTab, "Field of View", 70, 120, 70, function(value)
    Settings.FOV = value
    Camera.FieldOfView = value
end)

-- Teleport Tab Content
CreateButton(TeleportTab, "TP to Closest Player", function()
    local target = GetClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        print("Teleported to " .. target.Name)
    else
        print("No player found")
    end
end)

CreateButton(TeleportTab, "TP to Random Player", function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer ~= Player and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            print("Teleported to " .. randomPlayer.Name)
        end
    end
end)

-- Floating Button Toggle with Animation
FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local goal = {
            Size = UDim2.new(0, 450, 0, 550),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }
        TweenService:Create(MainFrame, tweenInfo, goal):Play()
    end
end)

-- Close Button with Animation
CloseButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local goal = {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }
    local tween = TweenService:Create(MainFrame, tweenInfo, goal)
    
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
end)

-- Minimize Button
MinimizeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
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

-- Premium Notification System
local function CreateNotification(title, text, duration)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = ScreenGui
    NotifFrame.AnchorPoint = Vector2.new(1, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    NotifFrame.Position = UDim2.new(1, 20, 0, 20)
    NotifFrame.Size = UDim2.new(0, 320, 0, 90)
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = NotifFrame
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(100, 100, 255)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame
    
    local NotifAccent = Instance.new("Frame")
    NotifAccent.Parent = NotifFrame
    NotifAccent.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    NotifAccent.Size = UDim2.new(0, 5, 1, 0)
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 12)
    AccentCorner.Parent = NotifAccent
    
    local AccentFix = Instance.new("Frame")
    AccentFix.Parent = NotifAccent
    AccentFix.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    AccentFix.BorderSizePixel = 0
    AccentFix.Position = UDim2.new(1, -5, 0, 0)
    AccentFix.Size = UDim2.new(0, 5, 1, 0)
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifFrame
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 20, 0, 10)
    NotifTitle.Size = UDim2.new(1, -30, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 16
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = NotifFrame
    NotifText.BackgroundTransparency = 1
    NotifText.Position = UDim2.new(0, 20, 0, 35)
    NotifText.Size = UDim2.new(1, -30, 0, 45)
    NotifText.Font = Enum.Font.Gotham
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(200, 200, 210)
    NotifText.TextSize = 13
    NotifText.TextWrapped = true
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    
    local tweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0, 20)})
    tweenIn:Play()
    
    wait(duration or 3)
    
    local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        NotifFrame:Destroy()
    end)
end

-- Load Notification
wait(0.5)
CreateNotification("VIOLENCE DISTRICT", "Premium script loaded successfully!\nMade for Delta X Mobile", 4)
print("Violence District Premium Script Loaded!")
print("UI Version: Premium Edition")
print("Made for Delta X Mobile Executor")