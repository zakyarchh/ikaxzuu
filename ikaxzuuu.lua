--[[
    Violence District Script
    Created by: ikaz_pinter
    Version: 1.0
    Mobile Optimized
]]

-- Anti Force Close
local ProtectGui = syn and syn.protect_gui or function() end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Variables
local ScriptEnabled = false
local Config = {
    AutoAim = false,
    AutoHit = false,
    AutoBlock = false,
    AutoFollow = false,
    HitboxEnabled = false,
    HitboxSize = 3,
    HeadHitbox = false,
    AllParts = false,
    Walkspeed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    FlyMode = false,
    Noclip = false,
    ESP = false,
    Tracers = false,
    HealthBar = false
}

local TargetPlayer = nil
local OriginalHitboxes = {}

-- Key System
local function CreateKeySystem()
    local KeySystemGui = Instance.new("ScreenGui")
    KeySystemGui.Name = "KeySystem"
    KeySystemGui.ResetOnSpawn = false
    KeySystemGui.IgnoreGuiInset = true
    ProtectGui(KeySystemGui)
    KeySystemGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeySystemGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 153, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(0, 153, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.Parent = MainFrame

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -40, 0, 30)
    Subtitle.Position = UDim2.new(0, 20, 0, 55)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Enter key to continue"
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 14
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = MainFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 45)
    KeyBox.Position = UDim2.new(0, 20, 0, 95)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyBox.Text = ""
    KeyBox.PlaceholderText = "Enter key here..."
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 16
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = MainFrame

    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 8)
    KeyBoxCorner.Parent = KeyBox

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(1, -40, 0, 45)
    SubmitButton.Position = UDim2.new(0, 20, 0, 155)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
    SubmitButton.Text = "SUBMIT KEY"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 16
    SubmitButton.Parent = MainFrame

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 8)
    SubmitCorner.Parent = SubmitButton

    local Credits = Instance.new("TextLabel")
    Credits.Size = UDim2.new(1, 0, 0, 30)
    Credits.Position = UDim2.new(0, 0, 1, -35)
    Credits.BackgroundTransparency = 1
    Credits.Text = "Key: ikaxzu | By: ikaz_pinter"
    Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
    Credits.Font = Enum.Font.Gotham
    Credits.TextSize = 12
    Credits.Parent = MainFrame

    SubmitButton.MouseButton1Click:Connect(function()
        local key = KeyBox.Text
        if key == "ikaxzu" then
            SubmitButton.Text = "✓ CORRECT!"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            wait(0.5)
            KeySystemGui:Destroy()
            ScriptEnabled = true
            CreateMainGUI()
        else
            SubmitButton.Text = "✗ WRONG KEY!"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            wait(1)
            SubmitButton.Text = "SUBMIT KEY"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
            KeyBox.Text = ""
        end
    end)
end

-- Notification System
local function Notify(title, text, duration)
    spawn(function()
        local NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "Notification"
        NotifGui.IgnoreGuiInset = true
        NotifGui.Parent = CoreGui

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 300, 0, 80)
        NotifFrame.Position = UDim2.new(1, 10, 0, 100)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = NotifGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = NotifFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(0, 153, 255)
        Stroke.Thickness = 2
        Stroke.Parent = NotifFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(0, 153, 255)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 16
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifFrame

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, -20, 0, 45)
        TextLabel.Position = UDim2.new(0, 10, 0, 30)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = text
        TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextWrapped = true
        TextLabel.Parent = NotifFrame

        NotifFrame:TweenPosition(UDim2.new(1, -310, 0, 100), "Out", "Quad", 0.5, true)
        wait(duration or 3)
        NotifFrame:TweenPosition(UDim2.new(1, 10, 0, 100), "In", "Quad", 0.5, true)
        wait(0.5)
        NotifGui:Destroy()
    end)
end

-- Create Main GUI
function CreateMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ViolenceDistrictGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ProtectGui(ScreenGui)
    ScreenGui.Parent = CoreGui

    -- Floating Button
    local FloatingButton = Instance.new("ImageButton")
    FloatingButton.Size = UDim2.new(0, 60, 0, 60)
    FloatingButton.Position = UDim2.new(1, -80, 0.5, -30)
    FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
    FloatingButton.BorderSizePixel = 0
    FloatingButton.Image = "rbxassetid://3926305904"
    FloatingButton.ImageRectOffset = Vector2.new(644, 204)
    FloatingButton.ImageRectSize = Vector2.new(36, 36)
    FloatingButton.Parent = ScreenGui

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = FloatingButton

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    ButtonStroke.Thickness = 3
    ButtonStroke.Transparency = 0.5
    ButtonStroke.Parent = FloatingButton

    -- Draggable Floating Button
    local dragging = false
    local dragInput, mousePos, framePos

    FloatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = FloatingButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    FloatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            FloatingButton.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 153, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "⚔️ VIOLENCE DISTRICT"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 153, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    -- Tabs Container
    local TabButtons = Instance.new("Frame")
    TabButtons.Size = UDim2.new(1, -20, 0, 45)
    TabButtons.Position = UDim2.new(0, 10, 0, 60)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabButtons

    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -125)
    ContentFrame.Position = UDim2.new(0, 10, 0, 115)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 153, 255)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentList.Parent = ContentFrame

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = ContentFrame

    -- Auto-resize canvas
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
    end)

    -- Toggle Main Frame
    FloatingButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    -- Make Main Frame Draggable
    local dragToggle, dragSpeed = nil, 0.25
    local dragStart, startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end

    TitleBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)

    -- UI Creation Functions
    local function CreateButton(text, parent, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 45)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 15
        Button.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(callback)
        return Button
    end

    local function CreateToggle(text, parent, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 45)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        ToggleFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 15
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 30)
        ToggleButton.Position = UDim2.new(1, -60, 0.5, -15)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 12
        ToggleButton.Parent = ToggleFrame

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = ToggleButton

        local toggled = false
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            if toggled then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                ToggleButton.Text = "ON"
            else
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                ToggleButton.Text = "OFF"
            end
            callback(toggled)
        end)

        return ToggleFrame, ToggleButton
    end

    local function CreateSlider(text, parent, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -20, 0, 65)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        SliderFrame.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = SliderFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 0, 25)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        local SliderBack = Instance.new("Frame")
        SliderBack.Size = UDim2.new(1, -20, 0, 8)
        SliderBack.Position = UDim2.new(0, 10, 1, -18)
        SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        SliderBack.BorderSizePixel = 0
        SliderBack.Parent = SliderFrame

        local SliderBackCorner = Instance.new("UICorner")
        SliderBackCorner.CornerRadius = UDim.new(1, 0)
        SliderBackCorner.Parent = SliderBack

        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBack

        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill

        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.new(1, 0, 1, 0)
        SliderButton.BackgroundTransparency = 1
        SliderButton.Text = ""
        SliderButton.Parent = SliderBack

        local dragging = false
        SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        SliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relativePos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * relativePos)
                SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                Label.Text = text .. ": " .. value
                callback(value)
            end
        end)

        return SliderFrame
    end

    local function CreateDropdown(text, parent, options, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, -20, 0, 45)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        DropdownFrame.Parent = parent
        DropdownFrame.ClipsDescendants = true

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = DropdownFrame

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Size = UDim2.new(1, 0, 0, 45)
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Text = text .. ": None"
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.TextSize = 15
        DropdownButton.Parent = DropdownFrame

        local OptionsFrame = Instance.new("ScrollingFrame")
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        OptionsFrame.Position = UDim2.new(0, 0, 0, 45)
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.ScrollBarThickness = 4
        OptionsFrame.Visible = false
        OptionsFrame.Parent = DropdownFrame

        local OptionsList = Instance.new("UIListLayout")
        OptionsList.Parent = OptionsFrame

        local expanded = false
        DropdownButton.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                OptionsFrame.Visible = true
                DropdownFrame.Size = UDim2.new(1, -20, 0, 200)
                OptionsFrame.Size = UDim2.new(1, 0, 0, 155)
            else
                OptionsFrame.Visible = false
                DropdownFrame.Size = UDim2.new(1, -20, 0, 45)
            end
        end)

        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 35)
            OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextSize = 14
            OptionButton.Parent = OptionsFrame

            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = text .. ": " .. option
                callback(option)
                expanded = false
                OptionsFrame.Visible = false
                DropdownFrame.Size = UDim2.new(1, -20, 0, 45)
            end)
        end

        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsList.AbsoluteContentSize.Y)

        return DropdownFrame
    end

    -- Tab System
    local Tabs = {}
    local CurrentTab = nil

    local function CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 13
        TabButton.Parent = TabButtons

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentFrame

        local TabList = Instance.new("UIListLayout")
        TabList.Padding = UDim.new(0, 10)
        TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabList.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                CurrentTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                CurrentTab.Content.Visible = false
            end

            TabButton.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            CurrentTab = {Button = TabButton, Content = TabContent}
        end)

        Tabs[name] = {Button = TabButton, Content = TabContent}

        if not CurrentTab then
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 153, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            CurrentTab = {Button = TabButton, Content = TabContent}
        end

        return TabContent
    end

    -- TAB HOME
    local HomeTab = CreateTab("HOME")

    CreateButton("📋 Copy Server ID", HomeTab, function()
        setclipboard(tostring(game.JobId))
        Notify("Copied!", "Server ID copied to clipboard", 2)
    end)

    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -20, 0, 100)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    StatsFrame.Parent = HomeTab

    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 8)
    StatsCorner.Parent = StatsFrame

    local StatsTitle = Instance.new("TextLabel")
    StatsTitle.Size = UDim2.new(1, -20, 0, 30)
    StatsTitle.Position = UDim2.new(0, 10, 0, 5)
    StatsTitle.BackgroundTransparency = 1
    StatsTitle.Text = "📊 Player Stats"
    StatsTitle.TextColor3 = Color3.fromRGB(0, 153, 255)
    StatsTitle.Font = Enum.Font.GothamBold
    StatsTitle.TextSize = 16
    StatsTitle.TextXAlignment = Enum.TextXAlignment.Left
    StatsTitle.Parent = StatsFrame

    local HealthLabel = Instance.new("TextLabel")
    HealthLabel.Size = UDim2.new(1, -20, 0, 25)
    HealthLabel.Position = UDim2.new(0, 10, 0, 35)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.Text = "Health: 100/100"
    HealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    HealthLabel.Font = Enum.Font.Gotham
    HealthLabel.TextSize = 14
    HealthLabel.TextXAlignment = Enum.TextXAlignment.Left
    HealthLabel.Parent = StatsFrame

    local WalkspeedLabel = Instance.new("TextLabel")
    WalkspeedLabel.Size = UDim2.new(1, -20, 0, 25)
    WalkspeedLabel.Position = UDim2.new(0, 10, 0, 60)
    WalkspeedLabel.BackgroundTransparency = 1
    WalkspeedLabel.Text = "Walkspeed: 16"
    WalkspeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkspeedLabel.Font = Enum.Font.Gotham
    WalkspeedLabel.TextSize = 14
    WalkspeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    WalkspeedLabel.Parent = StatsFrame

    spawn(function()
        while wait(0.5) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                HealthLabel.Text = "Health: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                WalkspeedLabel.Text = "Walkspeed: " .. math.floor(hum.WalkSpeed)
            end
        end
    end)

    -- TAB COMBAT
    local CombatTab = CreateTab("COMBAT")

    CreateToggle("⚔️ Auto Aim", CombatTab, function(value)
        Config.AutoAim = value
        Notify("Auto Aim", value and "Enabled" or "Disabled", 2)
    end)

    CreateToggle("🗡️ Auto Hit", CombatTab, function(value)
        Config.AutoHit = value
        Notify("Auto Hit", value and "Enabled" or "Disabled", 2)
    end)

    CreateToggle("🛡️ Auto Block", CombatTab, function(value)
        Config.AutoBlock = value
        Notify("Auto Block", value and "Enabled" or "Disabled", 2)
    end)

    CreateToggle("🏃 Auto Follow", CombatTab, function(value)
        Config.AutoFollow = value
        Notify("Auto Follow", value and "Enabled" or "Disabled", 2)
    end)

    -- TAB HITBOX
    local HitboxTab = CreateTab("HITBOX")

    CreateToggle("📦 Hitbox Expander", HitboxTab, function(value)
        Config.HitboxEnabled = value
        Notify("Hitbox", value and "Enabled" or "Disabled", 2)
    end)

    CreateSlider("📏 Hitbox Size", HitboxTab, 1.5, 10, 3, function(value)
        Config.HitboxSize = value
    end)

    CreateToggle("🎯 Head Hitbox", HitboxTab, function(value)
        Config.HeadHitbox = value
    end)

    CreateToggle("🔄 All Parts", HitboxTab, function(value)
        Config.AllParts = value
    end)

    CreateButton("🔄 Reset Hitboxes", HitboxTab, function()
        for _, data in pairs(OriginalHitboxes) do
            if data.Part and data.Part.Parent then
                data.Part.Size = data.Size
                data.Part.Transparency = data.Transparency
                data.Part.CanCollide = data.CanCollide
            end
        end
        OriginalHitboxes = {}
        Notify("Hitbox", "All hitboxes reset!", 2)
    end)

    -- TAB MOVEMENT
    local MovementTab = CreateTab("MOVEMENT")

    CreateSlider("🏃 Walkspeed", MovementTab, 16, 250, 16, function(value)
        Config.Walkspeed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)

    CreateSlider("⬆️ Jump Power", MovementTab, 50, 500, 50, function(value)
        Config.JumpPower = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)

    CreateSlider("🌍 Gravity", MovementTab, 0, 500, 196.2, function(value)
        Config.Gravity = value
        workspace.Gravity = value
    end)

    CreateToggle("✈️ Fly Mode", MovementTab, function(value)
        Config.FlyMode = value
        Notify("Fly Mode", value and "Enabled" or "Disabled", 2)
    end)

    CreateToggle("👻 Noclip", MovementTab, function(value)
        Config.Noclip = value
        Notify("Noclip", value and "Enabled" or "Disabled", 2)
    end)

    -- TAB TELEPORT
    local TeleportTab = CreateTab("TELEPORT")

    local playerList = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(playerList, v.Name)
        end
    end

    CreateDropdown("👤 Select Player", TeleportTab, playerList, function(selected)
        TargetPlayer = Players:FindFirstChild(selected)
    end)

    CreateButton("📍 Teleport to Player", TeleportTab, function()
        if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame
                Notify("Teleport", "Teleported to " .. TargetPlayer.Name, 2)
            end
        else
            Notify("Error", "Target player not found!", 2)
        end
    end)

    CreateButton("💰 Teleport to ATM", TeleportTab, function()
        local atm = workspace:FindFirstChild("ATM") or workspace:FindFirstChild("Generator")
        if atm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = atm.CFrame
            Notify("Teleport", "Teleported to ATM/Generator", 2)
        else
            Notify("Error", "ATM not found!", 2)
        end
    end)

    CreateButton("🛡️ Teleport to Safe Zone", TeleportTab, function()
        local safezone = workspace:FindFirstChild("SafeZone") or workspace:FindFirstChild("Spawn")
        if safezone and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = safezone.CFrame
            Notify("Teleport", "Teleported to Safe Zone", 2)
        else
            Notify("Error", "Safe zone not found!", 2)
        end
    end)

    -- TAB ESP
    local ESPTab = CreateTab("ESP")

    CreateToggle("👁️ Player ESP", ESPTab, function(value)
        Config.ESP = value
        Notify("Player ESP", value and "Enabled" or "Disabled", 2)
    end)

    CreateToggle("📏 Tracers", ESPTab, function(value)
        Config.Tracers = value
        Notify("Tracers", value and "Enabled" or "Disabled", 2)
    end)

    CreateToggle("💚 Health Bar", ESPTab, function(value)
        Config.HealthBar = value
        Notify("Health Bar", value and "Enabled" or "Disabled", 2)
    end)

    -- TAB ABOUT
    local AboutTab = CreateTab("ABOUT")

    local AboutFrame = Instance.new("Frame")
    AboutFrame.Size = UDim2.new(1, -20, 0, 280)
    AboutFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    AboutFrame.Parent = AboutTab

    local AboutCorner = Instance.new("UICorner")
    AboutCorner.CornerRadius = UDim.new(0, 8)
    AboutCorner.Parent = AboutFrame

    local AboutTitle = Instance.new("TextLabel")
    AboutTitle.Size = UDim2.new(1, -20, 0, 40)
    AboutTitle.Position = UDim2.new(0, 10, 0, 10)
    AboutTitle.BackgroundTransparency = 1
    AboutTitle.Text = "⚔️ VIOLENCE DISTRICT SCRIPT"
    AboutTitle.TextColor3 = Color3.fromRGB(0, 153, 255)
    AboutTitle.Font = Enum.Font.GothamBold
    AboutTitle.TextSize = 18
    AboutTitle.Parent = AboutFrame

    local Creator = Instance.new("TextLabel")
    Creator.Size = UDim2.new(1, -20, 0, 25)
    Creator.Position = UDim2.new(0, 10, 0, 55)
    Creator.BackgroundTransparency = 1
    Creator.Text = "👤 Created by: ikaz_pinter"
    Creator.TextColor3 = Color3.fromRGB(255, 255, 255)
    Creator.Font = Enum.Font.Gotham
    Creator.TextSize = 14
    Creator.TextXAlignment = Enum.TextXAlignment.Left
    Creator.Parent = AboutFrame

    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(1, -20, 0, 25)
    Version.Position = UDim2.new(0, 10, 0, 80)
    Version.BackgroundTransparency = 1
    Version.Text = "📦 Version: 1.0 (Mobile Optimized)"
    Version.TextColor3 = Color3.fromRGB(255, 255, 255)
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 14
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.Parent = AboutFrame

    local IGButton = Instance.new("TextButton")
    IGButton.Size = UDim2.new(1, -20, 0, 40)
    IGButton.Position = UDim2.new(0, 10, 0, 120)
    IGButton.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    IGButton.Text = "📷 Instagram: ikaz_pinter"
    IGButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IGButton.Font = Enum.Font.GothamBold
    IGButton.TextSize = 14
    IGButton.Parent = AboutFrame

    local IGCorner = Instance.new("UICorner")
    IGCorner.CornerRadius = UDim.new(0, 8)
    IGCorner.Parent = IGButton

    IGButton.MouseButton1Click:Connect(function()
        setclipboard("ikaz_pinter")
        Notify("Copied!", "Instagram username copied!", 2)
    end)

    local TTButton = Instance.new("TextButton")
    TTButton.Size = UDim2.new(1, -20, 0, 40)
    TTButton.Position = UDim2.new(0, 10, 0, 170)
    TTButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    TTButton.Text = "🎵 TikTok: zakiacnh"
    TTButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TTButton.Font = Enum.Font.GothamBold
    TTButton.TextSize = 14
    TTButton.Parent = AboutFrame

    local TTCorner = Instance.new("UICorner")
    TTCorner.CornerRadius = UDim.new(0, 8)
    TTCorner.Parent = TTButton

    TTButton.MouseButton1Click:Connect(function()
        setclipboard("zakiacnh")
        Notify("Copied!", "TikTok username copied!", 2)
    end)

    local Credits = Instance.new("TextLabel")
    Credits.Size = UDim2.new(1, -20, 0, 25)
    Credits.Position = UDim2.new(0, 10, 1, -35)
    Credits.BackgroundTransparency = 1
    Credits.Text = "❤️ Thanks for using this script!"
    Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
    Credits.Font = Enum.Font.Gotham
    Credits.TextSize = 12
    Credits.Parent = AboutFrame

    Notify("Success!", "Violence District Script Loaded!", 3)
end

-- Function to get nearest player
local function GetNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance and distance <= 30 then
                    nearestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return nearestPlayer
end

-- Auto Aim
spawn(function()
    while wait(0.1) do
        if Config.AutoAim then
            local target = GetNearestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end
end)

-- Auto Hit
spawn(function()
    while wait(0.3) do
        if Config.AutoHit then
            local target = GetNearestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                -- Trigger attack (adjust based on game mechanics)
                Mouse1click()
            end
        end
    end
end)

-- Auto Follow
spawn(function()
    while wait(0.5) do
        if Config.AutoFollow then
            local target = GetNearestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
end)

-- Hitbox Expander
spawn(function()
    while wait(0.5) do
        if Config.HitboxEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local shouldExpand = false
                            
                            if Config.AllParts then
                                shouldExpand = true
                            elseif Config.HeadHitbox and part.Name == "Head" then
                                shouldExpand = true
                            elseif part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "UpperTorso" then
                                shouldExpand = true
                            end

                            if shouldExpand then
                                if not OriginalHitboxes[part] then
                                    OriginalHitboxes[part] = {
                                        Part = part,
                                        Size = part.Size,
                                        Transparency = part.Transparency,
                                        CanCollide = part.CanCollide
                                    }
                                end
                                
                                part.Size = OriginalHitboxes[part].Size * Config.HitboxSize
                                part.Transparency = 0.8
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Movement
spawn(function()
    while wait(0.1) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Walkspeed
            LocalPlayer.Character.Humanoid.JumpPower = Config.JumpPower
        end
    end
end)

-- Fly Mode
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

spawn(function()
    while wait(0.1) do
        if Config.FlyMode and not flying then
            flying = true
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = hrp
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = hrp.CFrame
                bodyGyro.Parent = hrp
            end
        elseif not Config.FlyMode and flying then
            flying = false
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
        
        if flying and bodyVelocity and bodyGyro then
            local cam = Camera
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + (cam.CFrame.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - (cam.CFrame.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - (cam.CFrame.RightVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + (cam.CFrame.RightVector * flySpeed)
            end
            
            bodyVelocity.Velocity = direction
            bodyGyro.CFrame = cam.CFrame
        end
    end
end)

-- Noclip
spawn(function()
    while wait(0.1) do
        if Config.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ESP System
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(0, 153, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = player.Character
    
    ESPObjects[player] = {Highlight = highlight}
end

local function RemoveESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Highlight then
            ESPObjects[player].Highlight:Destroy()
        end
        ESPObjects[player] = nil
    end
end

spawn(function()
    while wait(1) do
        if Config.ESP then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not ESPObjects[player] then
                    CreateESP(player)
                end
            end
        else
            for player, _ in pairs(ESPObjects) do
                RemoveESP(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Anti AFK
spawn(function()
    while wait(300) do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
    end
end)

-- Start Script
CreateKeySystem()

Notify("Welcome!", "Enter key to continue", 3)