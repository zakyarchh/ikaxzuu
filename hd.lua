-- ikxzu premium
-- Advanced Hide and Seek Script

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local ESPEnabled = false
local WalkSpeedEnabled = false
local JumpPowerEnabled = false
local InvisibleEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ikxzuPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 8)
MainFrameCorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 8)
TopBarFix.Position = UDim2.new(0, 0, 1, -8)
TopBarFix.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ikxzu premium"
Title.TextColor3 = Color3.fromRGB(200, 200, 205)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 205)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.Parent = TopBar

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Create Toggle Function
local function CreateToggle(name, position, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Frame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0, 250, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 45, 0, 22)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 205)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local Toggled = false
    
    local ClickDetector = Instance.new("TextButton")
    ClickDetector.Size = UDim2.new(1, 0, 1, 0)
    ClickDetector.BackgroundTransparency = 1
    ClickDetector.Text = ""
    ClickDetector.Parent = ToggleFrame
    
    ClickDetector.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        
        local circlePos = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local buttonColor = Toggled and Color3.fromRGB(75, 110, 175) or Color3.fromRGB(45, 45, 50)
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = circlePos}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = buttonColor}):Play()
        
        callback(Toggled)
    end)
    
    return ToggleFrame
end

-- Create Slider Function
local function CreateSlider(name, position, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Frame"
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.Position = position
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ContentFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0, 200, 0, 20)
    SliderLabel.Position = UDim2.new(0, 12, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 13
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -62, 0, 5)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(default)
    SliderValue.TextColor3 = Color3.fromRGB(200, 200, 205)
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextSize = 13
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0, 360, 0, 4)
    SliderBar.Position = UDim2.new(0, 12, 1, -15)
    SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(75, 110, 175)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local Dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
        end
    end)
    
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = SliderBar.AbsolutePosition.X
            local sliderSize = SliderBar.AbsoluteSize.X
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local finalValue = math.floor(min + (max - min) * value)
            
            SliderFill.Size = UDim2.new(value, 0, 1, 0)
            SliderValue.Text = tostring(finalValue)
            callback(finalValue)
        end
    end)
    
    return SliderFrame
end

-- ESP Function
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ikxzuESP"
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(75, 110, 175)
    highlight.OutlineColor = Color3.fromRGB(200, 200, 205)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    return highlight
end

local function RemoveESP(player)
    if player.Character and player.Character:FindFirstChild("ikxzuESP") then
        player.Character.ikxzuESP:Destroy()
    end
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            RemoveESP(player)
            if ESPEnabled and player.Character then
                CreateESP(player)
            end
        end
    end
end

-- Character Reset Handler
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    UpdateESP()
end)

-- Creating Toggles and Sliders
CreateToggle("ESP Players", UDim2.new(0, 0, 0, 0), function(toggled)
    ESPEnabled = toggled
    UpdateESP()
end)

CreateToggle("Walk Speed Hack", UDim2.new(0, 0, 0, 45), function(toggled)
    WalkSpeedEnabled = toggled
end)

CreateSlider("Walk Speed", UDim2.new(0, 0, 0, 90), 16, 200, 16, function(value)
    WalkSpeedValue = value
end)

CreateToggle("Jump Power Hack", UDim2.new(0, 0, 0, 145), function(toggled)
    JumpPowerEnabled = toggled
end)

CreateSlider("Jump Power", UDim2.new(0, 0, 0, 190), 50, 200, 50, function(value)
    JumpPowerValue = value
end)

-- RunService for continuous updates
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        if WalkSpeedEnabled then
            humanoid.WalkSpeed = WalkSpeedValue
        end
        
        if JumpPowerEnabled then
            humanoid.JumpPower = JumpPowerValue
        end
    end
end)

-- Player Added Handler
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.5)
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

-- Close Button Function
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Dragging functionality
local dragging = false
local dragInput, mousePos, framePos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        }):Play()
    end
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 420, 0, 280)}):Play()

-- Notification
local function Notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "ikxzu premium";
        Text = text;
        Duration = 3;
    })
end

Notify("Script loaded successfully!")
