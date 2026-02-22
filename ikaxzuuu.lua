-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- // Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Key System
local CORRECT_KEY = "ikaxzu"
local keyEntered = false

-- // Script Settings
local Settings = {
    AutoParry = false,
    AutoAim = false,
    AutoKill = false,
    AimBot = false,
    ESP = false,
    WalkSpeed = false,
    JumpPower = false,
    NoClip = false,
    WalkSpeedValue = 16,
    JumpPowerValue = 50,
    AimPart = "Head"
}

-- // ESP Storage
local ESPObjects = {}

-- // Create ScreenGui
local function CreateUI()
    -- // Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "IkaxzuHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- // Protection
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end

    -- // Toggle Button (Icon)
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(0, 10, 0.5, -30)
    ToggleButton.Image = "https://files.catbox.moe/8h7dgs.jpg"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ScreenGui
    ToggleButton.Active = true
    ToggleButton.Draggable = true

    -- // Toggle Button Corner
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton

    -- // Toggle Button Stroke
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(100, 100, 255)
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = ToggleButton

    -- // Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- // Main Frame Corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame

    -- // Main Frame Stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(100, 100, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    -- // Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame

    -- // Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar

    -- // Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🎮 IKAXZU HUB"
    Title.TextColor3 = Color3.fromRGB(100, 100, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- // Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.white
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton

    -- // Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    ContentFrame.Position = UDim2.new(0, 10, 0, 60)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = ContentFrame

    -- // Auto-resize canvas
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
    end)

    return ScreenGui, MainFrame, ToggleButton, CloseButton, ContentFrame
end

-- // Create Toggle Function
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.white
    ToggleLabel.TextSize = 16
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame

    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9.5)
    ToggleCircle.BackgroundColor3 = Color3.white
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle

    local enabled = false

    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if enabled then
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -22, 0.5, -9.5)}):Play()
        else
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9.5)}):Play()
        end
        
        callback(enabled)
    end)

    return ToggleFrame
end

-- // Create Slider Function
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text .. ": " .. default
    SliderLabel.TextColor3 = Color3.white
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -20, 0, 8)
    SliderBack.Position = UDim2.new(0, 10, 1, -20)
    SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = SliderFrame

    local SliderBackCorner = Instance.new("UICorner")
    SliderBackCorner.CornerRadius = UDim.new(1, 0)
    SliderBackCorner.Parent = SliderBack

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local dragging = false

    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = SliderBack.AbsolutePosition.X
            local sliderSize = SliderBack.AbsoluteSize.X
            
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local finalValue = math.floor(min + (max - min) * value)
            
            SliderFill.Size = UDim2.new(value, 0, 1, 0)
            SliderLabel.Text = text .. ": " .. finalValue
            
            callback(finalValue)
        end
    end)

    return SliderFrame
end

-- // Create Button Function
local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = text
    ButtonFrame.TextColor3 = Color3.white
    ButtonFrame.TextSize = 16
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ButtonFrame

    ButtonFrame.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(ButtonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 80, 200)}):Play()
        wait(0.1)
        TweenService:Create(ButtonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
        callback()
    end)

    return ButtonFrame
end

-- // ESP Function
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_" .. player.Name
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(100, 100, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    ESPObjects[player] = highlight
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

-- // Get Closest Player
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- // Auto Parry Function (Basic Implementation)
local function AutoParry()
    spawn(function()
        while Settings.AutoParry do
            wait(0.1)
            -- Add your game-specific parry logic here
            -- This is a placeholder
            local target = GetClosestPlayer()
            if target and target.Character then
                -- Implement parry logic
            end
        end
    end)
end

-- // Auto Aim Function
local function AutoAim()
    spawn(function()
        while Settings.AutoAim do
            wait()
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild(Settings.AimPart) then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[Settings.AimPart].Position)
            end
        end
    end)
end

-- // AimBot Function
local function AimBot()
    spawn(function()
        while Settings.AimBot do
            wait()
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild(Settings.AimPart) then
                local aimPart = target.Character[Settings.AimPart]
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                
                -- Auto click (if needed)
                mouse1click()
            end
        end
    end)
end

-- // No Clip Function
local function NoClip()
    spawn(function()
        while Settings.NoClip do
            wait()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

-- // Walk Speed & Jump Power
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if Settings.WalkSpeed then
            LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeedValue
        end
        if Settings.JumpPower then
            LocalPlayer.Character.Humanoid.JumpPower = Settings.JumpPowerValue
        end
    end
end)

-- // Teleport Function
local function TeleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- // Key System UI
local function CreateKeySystem()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystem"
    KeyGui.ResetOnSpawn = false
    
    if syn then
        syn.protect_gui(KeyGui)
        KeyGui.Parent = CoreGui
    else
        KeyGui.Parent = CoreGui
    end

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 350, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = KeyGui

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 15)
    KeyCorner.Parent = KeyFrame

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = Color3.fromRGB(100, 100, 255)
    KeyStroke.Thickness = 2
    KeyStroke.Parent = KeyFrame

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 50)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Text = "🔐 KEY SYSTEM"
    KeyTitle.TextColor3 = Color3.fromRGB(100, 100, 255)
    KeyTitle.TextSize = 24
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.9, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.05, 0, 0.35, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.white
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.BorderSizePixel = 0
    KeyInput.Parent = KeyFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 10)
    InputCorner.Parent = KeyInput

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.9, 0, 0, 40)
    SubmitButton.Position = UDim2.new(0.05, 0, 0.65, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SubmitButton.Text = "Submit Key"
    SubmitButton.TextColor3 = Color3.white
    SubmitButton.TextSize = 18
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Parent = KeyFrame

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 10)
    SubmitCorner.Parent = SubmitButton

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = KeyFrame

    SubmitButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == CORRECT_KEY then
            StatusLabel.Text = "✓ Key Correct! Loading..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            wait(1)
            keyEntered = true
            KeyGui:Destroy()
        else
            StatusLabel.Text = "✗ Incorrect Key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            wait(2)
            StatusLabel.Text = ""
        end
    end)
end

-- // Initialize
CreateKeySystem()

repeat wait() until keyEntered

-- // Create Main UI
local ScreenGui, MainFrame, ToggleButton, CloseButton, ContentFrame = CreateUI()

-- // Toggle UI
local uiVisible = false
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
    
    if uiVisible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, 500, 0, 400)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
            {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        MainFrame.Visible = false
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    uiVisible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    MainFrame.Visible = false
end)

-- // Create Features
CreateToggle(ContentFrame, "⚔️ Auto Parry", function(enabled)
    Settings.AutoParry = enabled
    if enabled then AutoParry() end
end)

CreateToggle(ContentFrame, "🎯 Auto Aim", function(enabled)
    Settings.AutoAim = enabled
    if enabled then AutoAim() end
end)

CreateToggle(ContentFrame, "💀 Auto Kill", function(enabled)
    Settings.AutoKill = enabled
end)

CreateToggle(ContentFrame, "🎮 Aim Bot", function(enabled)
    Settings.AimBot = enabled
    if enabled then AimBot() end
end)

CreateToggle(ContentFrame, "👁️ ESP", function(enabled)
    Settings.ESP = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                CreateESP(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            RemoveESP(player)
        end
    end
end)

CreateToggle(ContentFrame, "🏃 Walk Speed", function(enabled)
    Settings.WalkSpeed = enabled
end)

CreateSlider(ContentFrame, "Walk Speed Value", 16, 200, 16, function(value)
    Settings.WalkSpeedValue = value
end)

CreateToggle(ContentFrame, "🦘 Jump Power", function(enabled)
    Settings.JumpPower = enabled
end)

CreateSlider(ContentFrame, "Jump Power Value", 50, 200, 50, function(value)
    Settings.JumpPowerValue = value
end)

CreateToggle(ContentFrame, "👻 No Clip", function(enabled)
    Settings.NoClip = enabled
    if enabled then NoClip() end
end)

CreateButton(ContentFrame, "📍 Teleport to Random Player", function()
    local players = Players:GetPlayers()
    local randomPlayer = players[math.random(1, #players)]
    if randomPlayer ~= LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TeleportTo(randomPlayer.Character.HumanoidRootPart.Position)
    end
end)

CreateButton(ContentFrame, "⚡ Teleport to Generator", function()
    -- Add your game-specific generator finding logic
    local generator = workspace:FindFirstChild("Generator") -- Example
    if generator then
        TeleportTo(generator.Position)
    end
end)

-- // ESP Player Added/Removed
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if Settings.ESP then
            wait(0.5)
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- // Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "IKAXZU HUB";
    Text = "Loaded Successfully! Press Icon to Open";
    Duration = 5;
})

print("✓ IKAXZU HUB Loaded Successfully!")