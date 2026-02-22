-- Violence District Script | Optimized for Delta X Mobile
-- No Key System | Full Features

print("[VD] Initializing script...")

-- Services
local Players = game:GetServices("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Settings Storage
local Settings = {
    ESP = {
        Players = false,
        Generators = false,
        RGBMode = false
    },
    Movement = {
        WalkSpeed = 16,
        JumpPower = 50,
        Noclip = false,
        Fly = false,
        FlySpeed = 50
    },
    Combat = {
        GodMode = false,
        AntiStun = false,
        AutoAim = false,
        AutoAimRange = 50,
        AutoKill = false
    },
    Visual = {
        NoFog = false,
        FullBright = false,
        Crosshair = false,
        FOV = 70
    }
}

-- Connections Storage
local Connections = {}
local ESPObjects = {}
local RGBHue = 0

-- Parent Detection
local function GetParent()
    local success, result = pcall(function()
        return gethui()
    end)
    return success and result or CoreGui
end

-- Helper Functions
local function IsPlayerKiller(player)
    if not player or not player.Character then return false end
    local success, result = pcall(function()
        local backpack = player.Backpack
        local character = player.Character
        
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("weapon")) then
                return true
            end
        end
        
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("weapon")) then
                return true
            end
        end
        
        return false
    end)
    return success and result or false
end

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Settings.Combat.AutoAimRange
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            
            if distance < shortestDistance then
                closest = player
                shortestDistance = distance
            end
        end
    end
    
    return closest
end

local function CreateESP(player)
    if not player or not player.Character then return end
    if ESPObjects[player] then return end
    
    local character = player.Character
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. player.Name
    espFolder.Parent = hrp
    
    -- Box ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.7
    
    if IsPlayerKiller(player) then
        box.Color3 = Color3.fromRGB(255, 0, 0)
    else
        box.Color3 = Color3.fromRGB(0, 255, 0)
    end
    
    box.Parent = espFolder
    
    -- Name Tag
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPName"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = box.Color3
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Parent = billboard
    
    ESPObjects[player] = {
        Folder = espFolder,
        Box = box,
        Text = textLabel
    }
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Folder:Destroy()
        ESPObjects[player] = nil
    end
end

local function ClearAllESP()
    for player, _ in pairs(ESPObjects) do
        RemoveESP(player)
    end
end

local function UpdateESP()
    if not Settings.ESP.Players then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not ESPObjects[player] then
                CreateESP(player)
            end
            
            if Settings.ESP.RGBMode and ESPObjects[player] then
                local rainbowColor = Color3.fromHSV(RGBHue, 1, 1)
                ESPObjects[player].Box.Color3 = rainbowColor
                ESPObjects[player].Text.TextColor3 = rainbowColor
            end
        end
    end
end

-- Movement Functions
local function StartNoclip()
    if Connections.Noclip then return end
    print("[VD] Noclip enabled")
    
    Connections.Noclip = RunService.Stepped:Connect(function()
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function StopNoclip()
    if Connections.Noclip then
        Connections.Noclip:Disconnect()
        Connections.Noclip = nil
        print("[VD] Noclip disabled")
        
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function StartFly()
    if Connections.Fly then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    print("[VD] Fly enabled")
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    Connections.Fly = RunService.RenderStepped:Connect(function()
        if not LocalPlayer.Character or not hrp.Parent then
            StopFly()
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Camera.CFrame.LookVector * Settings.Movement.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Camera.CFrame.LookVector * Settings.Movement.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (Camera.CFrame.RightVector * Settings.Movement.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (Camera.CFrame.RightVector * Settings.Movement.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + (Vector3.new(0, 1, 0) * Settings.Movement.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - (Vector3.new(0, 1, 0) * Settings.Movement.FlySpeed)
        end
        
        bodyVelocity.Velocity = moveDirection
        bodyGyro.CFrame = Camera.CFrame
    end)
end

local function StopFly()
    if Connections.Fly then
        Connections.Fly:Disconnect()
        Connections.Fly = nil
        print("[VD] Fly disabled")
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if hrp:FindFirstChild("FlyVelocity") then
                hrp.FlyVelocity:Destroy()
            end
            if hrp:FindFirstChild("FlyGyro") then
                hrp.FlyGyro:Destroy()
            end
        end
    end
end

-- Combat Functions
local function StartGodMode()
    if Connections.GodMode then return end
    print("[VD] God Mode enabled")
    
    Connections.GodMode = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

local function StopGodMode()
    if Connections.GodMode then
        Connections.GodMode:Disconnect()
        Connections.GodMode = nil
        print("[VD] God Mode disabled")
    end
end

local function StartAutoAim()
    if Connections.AutoAim then return end
    print("[VD] Auto Aim enabled")
    
    Connections.AutoAim = RunService.RenderStepped:Connect(function()
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            
            if Settings.Combat.AutoKill then
                -- Auto attack logic here
                pcall(function()
                    if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                        LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                    end
                end)
            end
        end
    end)
end

local function StopAutoAim()
    if Connections.AutoAim then
        Connections.AutoAim:Disconnect()
        Connections.AutoAim = nil
        print("[VD] Auto Aim disabled")
    end
end

-- Visual Functions
local function ToggleNoFog()
    pcall(function()
        game:GetService("Lighting").FogEnd = Settings.Visual.NoFog and 9e9 or 1000
        print("[VD] No Fog:", Settings.Visual.NoFog)
    end)
end

local function ToggleFullBright()
    pcall(function()
        local lighting = game:GetService("Lighting")
        if Settings.Visual.FullBright then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            print("[VD] Full Bright enabled")
        else
            lighting.Brightness = 1
            lighting.GlobalShadows = true
            print("[VD] Full Bright disabled")
        end
    end)
end

local function CreateCrosshair()
    local crosshair = Instance.new("ScreenGui")
    crosshair.Name = "Crosshair"
    crosshair.ResetOnSpawn = false
    crosshair.IgnoreGuiInset = true
    crosshair.Parent = GetParent()
    
    local center = Instance.new("Frame")
    center.Size = UDim2.new(0, 20, 0, 20)
    center.Position = UDim2.new(0.5, -10, 0.5, -10)
    center.BackgroundTransparency = 1
    center.Parent = crosshair
    
    local lines = {
        {Size = UDim2.new(0, 2, 0, 10), Position = UDim2.new(0.5, -1, 0, -15)}, -- Top
        {Size = UDim2.new(0, 2, 0, 10), Position = UDim2.new(0.5, -1, 1, 5)},   -- Bottom
        {Size = UDim2.new(0, 10, 0, 2), Position = UDim2.new(0, -15, 0.5, -1)}, -- Left
        {Size = UDim2.new(0, 10, 0, 2), Position = UDim2.new(1, 5, 0.5, -1)}    -- Right
    }
    
    for _, line in ipairs(lines) do
        local part = Instance.new("Frame")
        part.Size = line.Size
        part.Position = line.Position
        part.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        part.BorderSizePixel = 0
        part.Parent = center
    end
    
    return crosshair
end

-- UI Creation
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ViolenceDistrictHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999999
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = GetParent()
    
    -- Float Button
    local FloatButton = Instance.new("ImageButton")
    FloatButton.Name = "FloatButton"
    FloatButton.Size = UDim2.new(0, 60, 0, 60)
    FloatButton.Position = UDim2.new(0, 10, 0.5, -30)
    FloatButton.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    FloatButton.BorderSizePixel = 0
    FloatButton.Image = "rbxassetid://ikaxzu"
    FloatButton.Draggable = true
    FloatButton.Parent = ScreenGui
    
    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatButton
    
    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(100, 100, 255)
    FloatStroke.Thickness = 3
    FloatStroke.Parent = FloatButton
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(100, 100, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 12)
    TopFix.Position = UDim2.new(0, 0, 1, -12)
    TopFix.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    TopFix.BorderSizePixel = 0
    TopFix.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VIOLENCE DISTRICT"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Scroll Frame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = MainFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ScrollFrame
    
    -- Auto resize canvas
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Helper function to create sections
    local function CreateSection(name)
        local Section = Instance.new("Frame")
        Section.Size = UDim2.new(1, 0, 0, 40)
        Section.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Section.BorderSizePixel = 0
        Section.Parent = ScrollFrame
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = Section
        
        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, -20, 1, 0)
        SectionLabel.Position = UDim2.new(0, 10, 0, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = name
        SectionLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
        SectionLabel.TextSize = 16
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = Section
        
        return Section
    end
    
    -- Helper function to create toggle
    local function CreateToggle(name, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(1, 0, 0, 45)
        Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Toggle.BorderSizePixel = 0
        Toggle.Parent = ScrollFrame
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = Toggle
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = Toggle
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = Toggle
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
        ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9.5)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleButton
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ToggleCircle
        
        local toggled = false
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local bgColor = toggled and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(60, 60, 65)
            local circlePos = toggled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
            
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = circlePos}):Play()
            
            callback(toggled)
        end)
        
        return Toggle
    end
    
    -- Helper function to create slider
    local function CreateSlider(name, min, max, default, callback)
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(1, 0, 0, 60)
        Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Slider.BorderSizePixel = 0
        Slider.Parent = ScrollFrame
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = Slider
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
        SliderLabel.Position = UDim2.new(0, 15, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = name
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = Slider
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.4, -15, 0, 20)
        ValueLabel.Position = UDim2.new(0.6, 0, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default)
        ValueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
        ValueLabel.TextSize = 14
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Slider
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -30, 0, 6)
        SliderBar.Position = UDim2.new(0, 15, 0, 35)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = Slider
        
        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = SliderFill
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.new(1, 0, 1, 10)
        SliderButton.Position = UDim2.new(0, 0, 0, -5)
        SliderButton.BackgroundTransparency = 1
        SliderButton.Text = ""
        SliderButton.Parent = SliderBar
        
        local dragging = false
        
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        SliderButton.MouseButton1Click:Connect(function()
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            callback(value)
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = SliderBar.AbsolutePosition.X
                local barSize = SliderBar.AbsoluteSize.X
                local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                local value = math.floor(min + (max - min) * percentage)
                
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                callback(value)
            end
        end)
        
        return Slider
    end
    
    -- Helper function to create button
    local function CreateButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 45)
        Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamBold
        Button.BorderSizePixel = 0
        Button.Parent = ScrollFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 200)}):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            callback()
        end)
        
        return Button
    end
    
    -- Build UI
    CreateSection("ESP")
    
    CreateToggle("Player ESP", function(state)
        Settings.ESP.Players = state
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
        else
            ClearAllESP()
        end
    end)
    
    CreateToggle("RGB ESP", function(state)
        Settings.ESP.RGBMode = state
    end)
    
    CreateSection("MOVEMENT")
    
    CreateSlider("Walk Speed", 16, 500, 16, function(value)
        Settings.Movement.WalkSpeed = value
    end)
    
    CreateSlider("Jump Power", 50, 500, 50, function(value)
        Settings.Movement.JumpPower = value
    end)
    
    CreateToggle("Noclip", function(state)
        Settings.Movement.Noclip = state
        if state then
            StartNoclip()
        else
            StopNoclip()
        end
    end)
    
    CreateToggle("Fly Mode", function(state)
        Settings.Movement.Fly = state
        if state then
            StartFly()
        else
            StopFly()
        end
    end)
    
    CreateSlider("Fly Speed", 10, 200, 50, function(value)
        Settings.Movement.FlySpeed = value
    end)
    
    CreateSection("COMBAT")
    
    CreateToggle("God Mode", function(state)
        Settings.Combat.GodMode = state
        if state then
            StartGodMode()
        else
            StopGodMode()
        end
    end)
    
    CreateToggle("Auto Aim", function(state)
        Settings.Combat.AutoAim = state
        if state then
            StartAutoAim()
        else
            StopAutoAim()
        end
    end)
    
    CreateSlider("Auto Aim Range", 10, 100, 50, function(value)
        Settings.Combat.AutoAimRange = value
    end)
    
    CreateToggle("Auto Kill", function(state)
        Settings.Combat.AutoKill = state
    end)
    
    CreateSection("VISUAL")
    
    CreateToggle("No Fog", function(state)
        Settings.Visual.NoFog = state
        ToggleNoFog()
    end)
    
    CreateToggle("Full Bright", function(state)
        Settings.Visual.FullBright = state
        ToggleFullBright()
    end)
    
    CreateToggle("Crosshair", function(state)
        Settings.Visual.Crosshair = state
        if state then
            if not ScreenGui:FindFirstChild("Crosshair") then
                CreateCrosshair()
            end
        else
            if ScreenGui:FindFirstChild("Crosshair") then
                ScreenGui.Crosshair:Destroy()
            end
        end
    end)
    
    CreateSlider("FOV", 70, 120, 70, function(value)
        Settings.Visual.FOV = value
        Camera.FieldOfView = value
    end)
    
    CreateSection("TELEPORT")
    
    CreateButton("TP to Closest Player", function()
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                print("[VD] Teleported to " .. target.Name)
            end
        else
            print("[VD] No player found")
        end
    end)
    
    CreateButton("TP to Random Player", function()
        local players = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(players, player)
            end
        end
        
        if #players > 0 then
            local target = players[math.random(1, #players)]
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                print("[VD] Teleported to " .. target.Name)
            end
        else
            print("[VD] No players found")
        end
    end)
    
    -- Float Button Logic
    local menuOpen = false
    
    FloatButton.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        MainFrame.Visible = true
        
        if menuOpen then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 400, 0, 500)
            }):Play()
            TweenService:Create(FloatButton, TweenInfo.new(0.2), {
                Rotation = 90
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            TweenService:Create(FloatButton, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            wait(0.2)
            MainFrame.Visible = false
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        menuOpen = false
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(FloatButton, TweenInfo.new(0.2), {
            Rotation = 0
        }):Play()
        wait(0.2)
        MainFrame.Visible = false
    end)
    
    -- RGB Loop
    RunService.RenderStepped:Connect(function()
        RGBHue = (RGBHue + 0.005) % 1
        
        if Settings.ESP.RGBMode then
            UpdateESP()
        end
        
        -- Update Float Button Stroke
        FloatStroke.Color = Color3.fromHSV(RGBHue, 1, 1)
        MainStroke.Color = Color3.fromHSV(RGBHue, 0.8, 1)
    end)
    
    -- Movement Speed Loop
    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = Settings.Movement.WalkSpeed
            humanoid.JumpPower = Settings.Movement.JumpPower
        end
    end)
    
    print("[VD] UI Created")
end

-- Player Events
Players.PlayerAdded:Connect(function(player)
    if Settings.ESP.Players then
        player.CharacterAdded:Connect(function()
            wait(0.5)
            CreateESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    
    -- Reapply settings
    if Settings.Movement.Noclip then
        StopNoclip()
        StartNoclip()
    end
    
    if Settings.Movement.Fly then
        StopFly()
        StartFly()
    end
    
    if Settings.Combat.GodMode then
        StopGodMode()
        StartGodMode()
    end
    
    if Settings.Combat.AutoAim then
        StopAutoAim()
        StartAutoAim()
    end
    
    ToggleNoFog()
    ToggleFullBright()
end)

-- Notification
local function ShowNotification(text, duration)
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.ResetOnSpawn = false
    NotifGui.Parent = GetParent()
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 0)
    NotifFrame.Position = UDim2.new(0.5, -150, 0, -60)
    NotifFrame.AnchorPoint = Vector2.new(0.5, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotifFrame
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(100, 100, 255)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 16
    NotifText.Font = Enum.Font.GothamBold
    NotifText.Parent = NotifFrame
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 300, 0, 50),
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()
    
    wait(duration or 3)
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.5, -150, 0, -60)
    }):Play()
    
    wait(0.3)
    NotifGui:Destroy()
end

-- Initialize
print("[VD] Loading Violence District Script...")
CreateUI()
ShowNotification("VIOLENCE DISTRICT LOADED!", 3)
print("[VD] Script loaded successfully!")