-- Scr-- Ikaxzu Premium Script
-- Version 1.0

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local ESPEnabled = {}
local GodModeEnabled = false
local ClonedCharacter = nil
local OriginalCharacter = nil

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkaxzuPremium"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 480)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ikaxzu premium"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Version Label
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 100, 1, 0)
VersionLabel.Position = UDim2.new(0, 180, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0"
VersionLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -42, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 150, 1, -55)
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(0, 670, 1, -55)
ContentContainer.Position = UDim2.new(0, 170, 0, 50)
ContentContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentContainer

-- Tab System
local Tabs = {}
local CurrentTab = nil

function Library:CreateTab(name)
    local Tab = {}
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, -10, 0, 38)
    TabButton.Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 43))
    TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.BorderSizePixel = 0
    TabButton.Parent = TabContainer
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 5)
    TabButtonCorner.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            tab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            tab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        TabContent.Visible = true
        CurrentTab = Tab
    end)
    
    Tab.Button = TabButton
    Tab.Content = TabContent
    table.insert(Tabs, Tab)
    
    if #Tabs == 1 then
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        TabContent.Visible = true
        CurrentTab = Tab
    end
    
    function Tab:CreateSection(text)
        local Section = Instance.new("Frame")
        Section.Name = "Section"
        Section.Size = UDim2.new(1, 0, 0, 30)
        Section.BackgroundTransparency = 1
        Section.Parent = TabContent
        
        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, 0, 1, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = text
        SectionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        SectionLabel.TextSize = 14
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = Section
        
        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.Position = UDim2.new(0, 0, 1, -5)
        Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Divider.BorderSizePixel = 0
        Divider.Parent = Section
    end
    
    function Tab:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Size = UDim2.new(1, 0, 0, 36)
        Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.TextSize = 13
        Button.Font = Enum.Font.Gotham
        Button.BorderSizePixel = 0
        Button.Parent = TabContent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 5)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            wait(0.1)
            Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            callback()
        end)
    end
    
    function Tab:CreateToggle(text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = TabContent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 5)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ToggleLabel.TextSize = 13
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -48, 0.5, -10)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(35, 35, 35)
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        local ToggleBtnCorner = Instance.new("UICorner")
        ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
        ToggleBtnCorner.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
        ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleButton
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ToggleCircle
        
        local toggled = default
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local togglePos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local toggleColor = toggled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(35, 35, 35)
            
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = togglePos}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = toggleColor}):Play()
            
            callback(toggled)
        end)
    end
    
    function Tab:CreateDropdown(text, options, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = TabContent
        
        local DropCorner = Instance.new("UICorner")
        DropCorner.CornerRadius = UDim.new(0, 5)
        DropCorner.Parent = DropdownFrame
        
        local DropButton = Instance.new("TextButton")
        DropButton.Size = UDim2.new(1, 0, 0, 36)
        DropButton.BackgroundTransparency = 1
        DropButton.Text = ""
        DropButton.Parent = DropdownFrame
        
        local DropLabel = Instance.new("TextLabel")
        DropLabel.Size = UDim2.new(1, -40, 1, 0)
        DropLabel.Position = UDim2.new(0, 12, 0, 0)
        DropLabel.BackgroundTransparency = 1
        DropLabel.Text = text .. ": None"
        DropLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        DropLabel.TextSize = 13
        DropLabel.Font = Enum.Font.Gotham
        DropLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropLabel.Parent = DropdownFrame
        
        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 20, 0, 36)
        Arrow.Position = UDim2.new(1, -28, 0, 0)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "▼"
        Arrow.TextColor3 = Color3.fromRGB(180, 180, 180)
        Arrow.TextSize = 10
        Arrow.Font = Enum.Font.Gotham
        Arrow.Parent = DropdownFrame
        
        local OptionsList = Instance.new("Frame")
        OptionsList.Size = UDim2.new(1, 0, 0, 0)
        OptionsList.Position = UDim2.new(0, 0, 0, 36)
        OptionsList.BackgroundTransparency = 1
        OptionsList.Parent = DropdownFrame
        
        local OptionsLayout = Instance.new("UIListLayout")
        OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsLayout.Parent = OptionsList
        
        local expanded = false
        
        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
            OptionButton.TextSize = 12
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.BorderSizePixel = 0
            OptionButton.Parent = OptionsList
            
            OptionButton.MouseButton1Click:Connect(function()
                DropLabel.Text = text .. ": " .. option
                expanded = false
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                callback(option)
            end)
        end
        
        DropButton.MouseButton1Click:Connect(function()
            expanded = not expanded
            local newSize = expanded and UDim2.new(1, 0, 0, 36 + (#options * 30)) or UDim2.new(1, 0, 0, 36)
            local rotation = expanded and 180 or 0
            
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = newSize}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = rotation}):Play()
        end)
    end
    
    function Tab:CreateTextBox(text, placeholder, callback)
        local TextBoxFrame = Instance.new("Frame")
        TextBoxFrame.Name = "TextBoxFrame"
        TextBoxFrame.Size = UDim2.new(1, 0, 0, 36)
        TextBoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        TextBoxFrame.BorderSizePixel = 0
        TextBoxFrame.Parent = TabContent
        
        local TextBoxCorner = Instance.new("UICorner")
        TextBoxCorner.CornerRadius = UDim.new(0, 5)
        TextBoxCorner.Parent = TextBoxFrame
        
        local TextBoxLabel = Instance.new("TextLabel")
        TextBoxLabel.Size = UDim2.new(0.4, 0, 1, 0)
        TextBoxLabel.Position = UDim2.new(0, 12, 0, 0)
        TextBoxLabel.BackgroundTransparency = 1
        TextBoxLabel.Text = text
        TextBoxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TextBoxLabel.TextSize = 13
        TextBoxLabel.Font = Enum.Font.Gotham
        TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextBoxLabel.Parent = TextBoxFrame
        
        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(0.55, -12, 0, 26)
        TextBox.Position = UDim2.new(0.45, 0, 0.5, -13)
        TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TextBox.PlaceholderText = placeholder
        TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        TextBox.TextSize = 12
        TextBox.Font = Enum.Font.Gotham
        TextBox.BorderSizePixel = 0
        TextBox.Parent = TextBoxFrame
        
        local TBCorner = Instance.new("UICorner")
        TBCorner.CornerRadius = UDim.new(0, 4)
        TBCorner.Parent = TextBox
        
        TextBox.FocusLost:Connect(function(enter)
            if enter then
                callback(TextBox.Text)
            end
        end)
    end
    
    function Tab:CreateLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(160, 160, 160)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TabContent
    end
    
    return Tab
end

-- Create Tabs
local HomeTab = Library:CreateTab("Home")
local MainTab = Library:CreateTab("Main")
local ESPTab = Library:CreateTab("ESP")
local TeleportTab = Library:CreateTab("Teleport")

-- HOME TAB
HomeTab:CreateSection("Welcome")
HomeTab:CreateLabel("ikaxzu premium v1.0")
HomeTab:CreateLabel("Made for advanced users")
HomeTab:CreateLabel("")

HomeTab:CreateSection("Information")
HomeTab:CreateLabel("Player: " .. LocalPlayer.Name)
HomeTab:CreateLabel("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
HomeTab:CreateLabel("Server Time: " .. os.date("%H:%M:%S"))
HomeTab:CreateLabel("")

HomeTab:CreateSection("Quick Actions")
HomeTab:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

HomeTab:CreateButton("Server Hop", function()
    local servers = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            break
        end
    end
end)

HomeTab:CreateButton("Copy Job ID", function()
    setclipboard(game.JobId)
end)

HomeTab:CreateSection("Settings")
HomeTab:CreateToggle("Anti AFK", true, function(state)
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- MAIN TAB
MainTab:CreateSection("God Mode")
MainTab:CreateLabel("Clone your character to avoid death")
MainTab:CreateLabel("")

MainTab:CreateToggle("God Mode", false, function(state)
    GodModeEnabled = state
    
    if state then
        local character = LocalPlayer.Character
        if character then
            OriginalCharacter = character
            
            -- Clone character
            ClonedCharacter = character:Clone()
            ClonedCharacter.Name = "ClonedCharacter"
            ClonedCharacter.Parent = workspace
            
            -- Position clone
            if character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local cloneRoot = ClonedCharacter.HumanoidRootPart
                
                -- Move original down
                rootPart.CFrame = rootPart.CFrame - Vector3.new(0, 15, 0)
                
                -- Make original invisible
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    end
                    if part:IsA("Decal") or part:IsA("Texture") then
                        part.Transparency = 1
                    end
                end
                
                -- Connect clone to original
                RunService.Heartbeat:Connect(function()
                    if GodModeEnabled and OriginalCharacter and ClonedCharacter then
                        local origRoot = OriginalCharacter:FindFirstChild("HumanoidRootPart")
                        local clRoot = ClonedCharacter:FindFirstChild("HumanoidRootPart")
                        
                        if origRoot and clRoot then
                            clRoot.CFrame = origRoot.CFrame + Vector3.new(0, 15, 0)
                        end
                    end
                end)
            end
        end
    else
        -- Disable god mode
        if OriginalCharacter then
            for _, part in pairs(OriginalCharacter:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
                if part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = 0
                end
            end
        end
        
        if ClonedCharacter then
            ClonedCharacter:Destroy()
            ClonedCharacter = nil
        end
    end
end)

MainTab:CreateSection("Character")
MainTab:CreateButton("Reset Character", function()
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
end)

MainTab:CreateTextBox("Walk Speed", "16", function(value)
    local speed = tonumber(value)
    if speed then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    end
end)

MainTab:CreateTextBox("Jump Power", "50", function(value)
    local power = tonumber(value)
    if power then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = power
    end
end)

-- ESP TAB
ESPTab:CreateSection("ESP Types")

local ESPTypes = {
    "Box ESP", "Name ESP", "Distance ESP", "Health ESP",
    "Skeleton ESP", "Tracer ESP", "Chams ESP", "Highlight ESP",
    "Head ESP", "LookAt ESP", "Weapon ESP", "Team ESP",
    "Radar ESP", "Arrow ESP", "Circle ESP", "Filled Box ESP",
    "Corner Box ESP", "3D Box ESP", "Gradient ESP", "Rainbow ESP",
    "Outline ESP", "Glow ESP", "X-Ray ESP", "Hitbox ESP",
    "Sound ESP"
}

for i, espType in ipairs(ESPTypes) do
    ESPTab:CreateToggle(espType, false, function(state)
        ESPEnabled[espType] = state
        
        -- ESP Implementation (Basic)
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- Create ESP based on type
                        if espType == "Box ESP" then
                            local box = Instance.new("BillboardGui")
                            box.Name = "ESP_" .. espType
                            box.Size = UDim2.new(4, 0, 5, 0)
                            box.Adornee = character.HumanoidRootPart
                            box.AlwaysOnTop = true
                            box.Parent = character.HumanoidRootPart
                            
                            local frame = Instance.new("Frame", box)
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundTransparency = 0.7
                            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            frame.BorderSizePixel = 2
                            frame.BorderColor3 = Color3.fromRGB(200, 200, 200)
                        end
                        
                        if espType == "Name ESP" then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_" .. espType
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.Adornee = character.Head
                            billboard.AlwaysOnTop = true
                            billboard.Parent = character.Head
                            
                            local label = Instance.new("TextLabel", billboard)
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = player.Name
                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                            label.TextStrokeTransparency = 0.5
                            label.TextScaled = true
                        end
                    end
                end
            end
        else
            -- Remove ESP
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, obj in pairs(player.Character:GetDescendants()) do
                        if obj.Name == "ESP_" .. espType then
                            obj:Destroy()
                        end
                    end
                end
            end
        end
    end)
end

-- TELEPORT TAB
TeleportTab:CreateSection("Player Teleport")
TeleportTab:CreateLabel("Select a player to teleport")
TeleportTab:CreateLabel("")

local playerNames = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.Name)
    end
end

TeleportTab:CreateDropdown("Select Player", playerNames, function(selected)
    local targetPlayer = Players:FindFirstChild(selected)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end)

TeleportTab:CreateSection("Quick Teleport")
TeleportTab:CreateButton("Teleport to Random Player", function()
    local players = Players:GetPlayers()
    local randomPlayer = players[math.random(1, #players)]
    if randomPlayer ~= LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
    end
end)

TeleportTab:CreateButton("Bring All Players", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -87, 0, 2.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    
    if minimized then
        MinimizeButton.Text = "+"
    else
        MinimizeButton.Text = "—"
    end
end)

print("Ikaxzu Premium loaded successfully!").
