--[[
    IKAXZU HUB - MOBILE EDITION
    Key: ikaxzu
    NO EMOJI - MOBILE SAFE!
]]

task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkaxzuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

print("GUI Created!")

-- ============================================
-- KEY SYSTEM
-- ============================================
local CORRECT_KEY = "ikaxzu"
local keyEntered = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 350, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 15)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(100, 100, 255)
KeyStroke.Thickness = 3
KeyStroke.Parent = KeyFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 70, 0, 70)
Logo.Position = UDim2.new(0.5, -35, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Image = "https://files.catbox.moe/8h7dgs.jpg"
Logo.Parent = KeyFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 15)
LogoCorner.Parent = Logo

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 90)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "[IKAXZU HUB]"
KeyTitle.TextColor3 = Color3.fromRGB(100, 100, 255)
KeyTitle.TextSize = 22
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.85, 0, 0, 40)
KeyInput.Position = UDim2.new(0.075, 0, 0, 130)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
KeyInput.PlaceholderText = "Enter Key: ikaxzu"
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.white
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.Gotham
KeyInput.BorderSizePixel = 0
KeyInput.ClearTextOnFocus = true
KeyInput.Parent = KeyFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = KeyInput

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.85, 0, 0, 40)
SubmitButton.Position = UDim2.new(0.075, 0, 0, 175)
SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
SubmitButton.Text = "SUBMIT KEY"
SubmitButton.TextColor3 = Color3.white
SubmitButton.TextSize = 18
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.BorderSizePixel = 0
SubmitButton.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 10)
SubmitCorner.Parent = SubmitButton

print("Key System Created!")

SubmitButton.MouseButton1Click:Connect(function()
    print("Checking key...")
    if KeyInput.Text == CORRECT_KEY then
        print("Correct Key!")
        keyEntered = true
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Loading..."
        
        local tween = TweenService:Create(KeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
            {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
        tween:Play()
        task.wait(0.5)
        KeyFrame:Destroy()
    else
        print("Wrong Key!")
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong! Try: ikaxzu"
        KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
        task.wait(0.5)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        KeyInput.PlaceholderText = "Enter Key: ikaxzu"
    end
end)

repeat task.wait(0.1) until keyEntered

print("Loading Main Hub...")

-- ============================================
-- LIBRARY
-- ============================================
local lib = {}

lib.ESPEnabled = false
lib.GeneratorESPEnabled = false
lib.RGBESPEnabled = false
lib.SuperESPEnabled = false
lib.RGBESPSpeed = 1
lib.SuperESPSpeed = 1

lib.KillerColor = Color3.fromRGB(255, 0, 0)
lib.SurvivorColor = Color3.fromRGB(0, 255, 0)
lib.GeneratorColor = Color3.fromRGB(255, 255, 0)

lib.walkSpeedActive = false
lib.walkSpeed = 16
lib.JumpPowerEnabled = false
lib.JumpPowerValue = 50
lib.NoclipEnabled = false
lib.GodModeEnabled = false
lib.AntiStunEnabled = false

lib.NoFogEnabled = false
lib.CrosshairEnabled = false

lib.AimbotEnabled = false
lib.AimbotFOV = 50
lib.AimbotSmoothness = 10
lib.AimbotTeamCheck = true

lib.ESPFolders = {}
lib.GeneratorESPItems = {}
lib.Connections = {}
lib._cache = {roleCache = {}}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
lib.GetRainbowColor = function(speed)
    local hue = (tick() * speed * 100) % 255 / 255
    return Color3.fromHSV(hue, 1, 1)
end

lib.GetSuperESPColor = function(baseColor, time, speed)
    local offset = math.sin(time * speed) * 0.5 + 0.5
    return Color3.new(
        math.clamp(baseColor.R * (0.5 + offset * 0.5), 0, 1),
        math.clamp(baseColor.G * (0.5 + offset * 0.5), 0, 1),
        math.clamp(baseColor.B * (0.5 + offset * 0.5), 0, 1)
    )
end

lib.IsPlayerKiller = function(player)
    if not player or not player.Character then return false end
    
    if lib._cache.roleCache[player.UserId] then
        local cached = lib._cache.roleCache[player.UserId]
        if tick() - cached.time < 5 then
            return cached.isKiller
        end
    end
    
    local character = player.Character
    local isKiller = character:FindFirstChild("Knife") ~= nil or
                     character:FindFirstChild("Weapon") ~= nil or
                     (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") ~= nil)
    
    lib._cache.roleCache[player.UserId] = {isKiller = isKiller, time = tick()}
    return isKiller
end

lib.IsPlayerSpectator = function(player)
    if not player or not player.Character then return true end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return not humanoid or humanoid.Health <= 0
end

-- ============================================
-- ESP FUNCTIONS
-- ============================================
lib.CreateESP = function(player)
    task.spawn(function()
        pcall(function()
            if player == LocalPlayer or lib.IsPlayerSpectator(player) then return end
            
            lib.RemoveESP(player)
            
            local character = player.Character
            if not character then return end
            
            local folder = Instance.new("Folder")
            folder.Name = "ESP_" .. player.Name
            folder.Parent = character
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Adornee = character
            highlight.FillColor = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = folder
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPBillboard"
            billboard.Adornee = character:FindFirstChild("Head")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = folder
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "ESPName"
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
            nameLabel.TextSize = 18
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Parent = billboard
            
            lib.ESPFolders[player] = folder
        end)
    end)
end

lib.RemoveESP = function(player)
    pcall(function()
        if lib.ESPFolders[player] then
            lib.ESPFolders[player]:Destroy()
            lib.ESPFolders[player] = nil
        end
    end)
end

lib.ClearAllESP = function()
    for player, folder in pairs(lib.ESPFolders) do
        pcall(function()
            if folder then folder:Destroy() end
        end)
    end
    lib.ESPFolders = {}
end

lib.UpdateESP = function()
    for player, folder in pairs(lib.ESPFolders) do
        pcall(function()
            if player and folder and player.Character then
                local highlight = folder:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight.FillColor = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
                end
                local billboard = folder:FindFirstChild("ESPBillboard")
                if billboard then
                    local nameLabel = billboard:FindFirstChild("ESPName")
                    if nameLabel then
                        nameLabel.TextColor3 = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
                    end
                end
            end
        end)
    end
end

lib.FindAndCreateGenerators = function()
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            if string.find(string.lower(obj.Name), "generator") and obj:IsA("Model") then
                if not lib.GeneratorESPItems[obj] then
                    local folder = Instance.new("Folder")
                    folder.Name = "GeneratorESP"
                    folder.Parent = obj
                    
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = obj
                    highlight.FillColor = lib.GeneratorColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = folder
                    
                    lib.GeneratorESPItems[obj] = folder
                end
            end
        end)
    end
end

-- ============================================
-- AIMBOT
-- ============================================
lib.AimbotFunctions = {}

lib.AimbotFunctions.findClosestPlayer = function()
    local closestPlayer = nil
    local closestDistance = lib.AimbotFOV
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player ~= LocalPlayer and player.Character then
                if lib.AimbotTeamCheck and not lib.IsPlayerKiller(player) then return end
                
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                        local distance = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end)
    end
    
    return closestPlayer
end

lib.AimbotFunctions.aimAt = function(player)
    pcall(function()
        if not player or not player.Character then return end
        
        local head = player.Character:FindFirstChild("Head")
        if not head then return end
        
        local camera = workspace.CurrentCamera
        local targetCFrame = CFrame.lookAt(camera.CFrame.Position, head.Position)
        local smoothness = (100 - lib.AimbotSmoothness) / 100
        
        camera.CFrame = camera.CFrame:Lerp(targetCFrame, smoothness)
    end)
end

-- ============================================
-- MOVEMENT FUNCTIONS
-- ============================================
lib.StartNoclip = function()
    if lib.Connections.Noclip then lib.Connections.Noclip:Disconnect() end
    
    lib.Connections.Noclip = RunService.Stepped:Connect(function()
        pcall(function()
            if not lib.NoclipEnabled then return end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end)
end

lib.StopNoclip = function()
    if lib.Connections.Noclip then
        lib.Connections.Noclip:Disconnect()
        lib.Connections.Noclip = nil
    end
end

lib.StartGodMode = function()
    if lib.Connections.GodMode then lib.Connections.GodMode:Disconnect() end
    
    lib.Connections.GodMode = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not lib.GodModeEnabled then return end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health < 100 then
                    humanoid.Health = 100
                end
            end
        end)
    end)
end

lib.StopGodMode = function()
    if lib.Connections.GodMode then
        lib.Connections.GodMode:Disconnect()
        lib.Connections.GodMode = nil
    end
end

lib.StartAntiStun = function()
    if lib.Connections.AntiStun then lib.Connections.AntiStun:Disconnect() end
    
    lib.Connections.AntiStun = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not lib.AntiStunEnabled then return end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if humanoid.PlatformStand then humanoid.PlatformStand = false end
                    if humanoid.Sit then humanoid.Sit = false end
                end
            end
        end)
    end)
end

lib.StopAntiStun = function()
    if lib.Connections.AntiStun then
        lib.Connections.AntiStun:Disconnect()
        lib.Connections.AntiStun = nil
    end
end

-- ============================================
-- VISUAL FUNCTIONS
-- ============================================
lib.StartNoFog = function()
    if lib.Connections.NoFog then lib.Connections.NoFog:Disconnect() end
    
    lib.Connections.NoFog = RunService.Heartbeat:Connect(function()
        pcall(function()
            if lib.NoFogEnabled then
                Lighting.FogEnd = 1000000
                Lighting.FogStart = 100000
            end
        end)
    end)
end

lib.StopNoFog = function()
    if lib.Connections.NoFog then
        lib.Connections.NoFog:Disconnect()
        lib.Connections.NoFog = nil
    end
    Lighting.FogEnd = 1000
    Lighting.FogStart = 0
end

-- ============================================
-- RGB & SUPER ESP
-- ============================================
lib.StartRGBESP = function()
    if lib.Connections.RGBESP then lib.Connections.RGBESP:Disconnect() end
    
    lib.Connections.RGBESP = RunService.Heartbeat:Connect(function()
        pcall(function()
            if lib.RGBESPEnabled and lib.ESPEnabled then
                local color = lib.GetRainbowColor(lib.RGBESPSpeed)
                lib.KillerColor = color
                lib.SurvivorColor = color
                lib.UpdateESP()
            end
        end)
    end)
end

lib.StopRGBESP = function()
    if lib.Connections.RGBESP then
        lib.Connections.RGBESP:Disconnect()
        lib.Connections.RGBESP = nil
    end
    lib.KillerColor = Color3.fromRGB(255, 0, 0)
    lib.SurvivorColor = Color3.fromRGB(0, 255, 0)
end

lib.StartSuperESP = function()
    if lib.Connections.SuperESP then lib.Connections.SuperESP:Disconnect() end
    
    lib.Connections.SuperESP = RunService.Heartbeat:Connect(function()
        pcall(function()
            if lib.SuperESPEnabled and lib.ESPEnabled then
                local time = tick()
                for player, folder in pairs(lib.ESPFolders) do
                    if player and folder and player.Character then
                        local color = lib.GetSuperESPColor(
                            lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor, 
                            time, 
                            lib.SuperESPSpeed
                        )
                        local highlight = folder:FindFirstChild("ESPHighlight")
                        if highlight then
                            highlight.FillColor = color
                        end
                    end
                end
            end
        end)
    end)
end

lib.StopSuperESP = function()
    if lib.Connections.SuperESP then
        lib.Connections.SuperESP:Disconnect()
        lib.Connections.SuperESP = nil
    end
end

-- ============================================
-- TELEPORT
-- ============================================
lib.TeleportToPlayer = function(targetPlayer)
    pcall(function()
        if not targetPlayer or targetPlayer == LocalPlayer then return end
        
        local character = LocalPlayer.Character
        local targetChar = targetPlayer.Character
        
        if character and targetChar then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            
            if rootPart and targetRoot then
                rootPart.CFrame = CFrame.new(targetRoot.Position + Vector3.new(3, 0, 3))
            end
        end
    end)
end

lib.CreateTeleportMenu = function()
    local TeleportFrame = Instance.new("Frame")
    TeleportFrame.Name = "TeleportFrame"
    TeleportFrame.Size = UDim2.new(0, 320, 0, 400)
    TeleportFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TeleportFrame.BorderSizePixel = 0
    TeleportFrame.Visible = false
    TeleportFrame.ZIndex = 100
    TeleportFrame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = TeleportFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    titleLabel.Text = "[TELEPORT]"
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = TeleportFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleLabel
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.white
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleLabel
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -110)
    scrollFrame.Position = UDim2.new(0, 10, 0, 60)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = TeleportFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent = scrollFrame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 120, 0, 40)
    refreshBtn.Position = UDim2.new(0, 15, 1, -50)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    refreshBtn.Text = "REFRESH"
    refreshBtn.TextColor3 = Color3.white
    refreshBtn.TextSize = 16
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Parent = TeleportFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn
    
    lib.TeleportFrame = TeleportFrame
    lib.TeleportScrollFrame = scrollFrame
    
    local function updateList()
        for _, child in ipairs(scrollFrame:GetChildren()) do
            child:Destroy()
        end
        
        local yPos = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 55)
                btn.Position = UDim2.new(0, 5, 0, yPos)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                btn.Text = player.Name
                btn.TextColor3 = Color3.white
                btn.TextSize = 16
                btn.Font = Enum.Font.GothamBold
                btn.BorderSizePixel = 0
                btn.Parent = scrollFrame
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    lib.TeleportToPlayer(player)
                    TeleportFrame.Visible = false
                end)
                
                yPos = yPos + 60
            end
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end
    
    refreshBtn.MouseButton1Click:Connect(updateList)
    closeBtn.MouseButton1Click:Connect(function()
        TeleportFrame.Visible = false
    end)
    
    updateList()
end

lib.OpenTeleportMenu = function()
    if not lib.TeleportFrame then
        lib.CreateTeleportMenu()
    end
    lib.TeleportFrame.Visible = true
end

-- ============================================
-- CREATE MAIN UI (NO EMOJI!)
-- ============================================
print("Creating Main UI...")

lib.MainFrame = Instance.new("Frame")
lib.MainFrame.Size = UDim2.new(0, 500, 0, 600)
lib.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
lib.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
lib.MainFrame.BorderSizePixel = 0
lib.MainFrame.Active = true
lib.MainFrame.Visible = false
lib.MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = lib.MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 100, 255)
mainStroke.Thickness = 3
mainStroke.Parent = lib.MainFrame

-- Make draggable
local dragToggle = false
local dragStart = nil
local startPos = nil

lib.MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = lib.MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and dragToggle then
        local delta = input.Position - dragStart
        lib.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 55)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = lib.MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 38, 0, 38)
logoImg.Position = UDim2.new(0, 8, 0.5, -19)
logoImg.BackgroundTransparency = 1
logoImg.Image = "https://files.catbox.moe/8h7dgs.jpg"
logoImg.Parent = titleBar

local logoImgCorner = Instance.new("UICorner")
logoImgCorner.CornerRadius = UDim.new(0, 8)
logoImgCorner.Parent = logoImg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.new(0, 55, 0, 0)
title.BackgroundTransparency = 1
title.Text = "[IKAXZU HUB]"
title.TextColor3 = Color3.fromRGB(100, 100, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 43, 0, 43)
closeBtn.Position = UDim2.new(1, -49, 0.5, -21.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.white
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 10)
closeBtnCorner.Parent = closeBtn

-- Tab System
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 42)
tabContainer.Position = UDim2.new(0, 0, 0, 55)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = lib.MainFrame

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 5)
tabList.Parent = tabContainer

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -18, 1, -115)
contentFrame.Position = UDim2.new(0, 9, 0, 105)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = lib.MainFrame

local tabNames = {"ESP", "COLORS", "MOVE", "VISUAL", "AIM"}
local tabButtons = {}
local tabFrames = {}

for i, tabName in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.2, -4, 1, 0)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(30, 30, 35)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.white
    tabBtn.TextSize = 15
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 8
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Visible = (i == 1)
    tabFrame.Parent = contentFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 9)
    tabListLayout.Parent = tabFrame
    
    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    tabButtons[tabName] = tabBtn
    tabFrames[tabName] = tabFrame
    
    tabBtn.MouseButton1Click:Connect(function()
        for name, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
        for name, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        
        tabBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        tabFrame.Visible = true
    end)
end

print("Main UI Created!")

-- ============================================
-- UI CREATION FUNCTIONS
-- ============================================
lib.CreateToggle = function(text, default, callback, parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 48)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -68, 1, 0)
    toggleLabel.Position = UDim2.new(0, 13, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.white
    toggleLabel.TextSize = 15
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 48, 0, 24)
    toggleButton.Position = UDim2.new(1, -56, 0.5, -12)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(50, 50, 55)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    toggleCircle.BackgroundColor3 = Color3.white
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local enabled = default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if enabled then
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
        
        pcall(function() callback(enabled) end)
    end)
end

lib.CreateSlider = function(text, min, max, default, callback, parent)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 62)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -18, 0, 23)
    sliderLabel.Position = UDim2.new(0, 9, 0, 4)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. default
    sliderLabel.TextColor3 = Color3.white
    sliderLabel.TextSize = 14
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -18, 0, 11)
    sliderBack.Position = UDim2.new(0, 9, 1, -19)
    sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = sliderFrame
    
    local sliderBackCorner = Instance.new("UICorner")
    sliderBackCorner.CornerRadius = UDim.new(1, 0)
    sliderBackCorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local dragging = false
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            pcall(function()
                local mousePos = input.UserInputType == Enum.UserInputType.Touch and input.Position.X or UserInputService:GetMouseLocation().X
                local sliderPos = sliderBack.AbsolutePosition.X
                local sliderSize = sliderBack.AbsoluteSize.X
                
                local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                local finalValue = math.floor(min + (max - min) * value)
                
                sliderFill.Size = UDim2.new(value, 0, 1, 0)
                sliderLabel.Text = text .. ": " .. finalValue
                
                callback(finalValue)
            end)
        end
    end)
end

lib.CreateButton = function(text, callback, parent)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, 0, 0, 48)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Text = text
    buttonFrame.TextColor3 = Color3.white
    buttonFrame.TextSize = 16
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        pcall(function()
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 80, 200)}):Play()
            task.wait(0.1)
            TweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            callback()
        end)
    end)
end

lib.CreateColorPicker = function(text, defaultColor, callback, parent)
    local colorFrame = Instance.new("Frame")
    colorFrame.Size = UDim2.new(1, 0, 0, 48)
    colorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    colorFrame.BorderSizePixel = 0
    colorFrame.Parent = parent
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 10)
    colorCorner.Parent = colorFrame
    
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(1, -68, 1, 0)
    colorLabel.Position = UDim2.new(0, 13, 0, 0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = text
    colorLabel.TextColor3 = Color3.white
    colorLabel.TextSize = 15
    colorLabel.Font = Enum.Font.Gotham
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left
    colorLabel.Parent = colorFrame
    
    local colorDisplay = Instance.new("TextButton")
    colorDisplay.Size = UDim2.new(0, 38, 0, 28)
    colorDisplay.Position = UDim2.new(1, -46, 0.5, -14)
    colorDisplay.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255)
    colorDisplay.BorderSizePixel = 0
    colorDisplay.Text = ""
    colorDisplay.Parent = colorFrame
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 8)
    displayCorner.Parent = colorDisplay
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 165, 0),
    }
    
    local currentIndex = 1
    
    colorDisplay.MouseButton1Click:Connect(function()
        pcall(function()
            currentIndex = currentIndex + 1
            if currentIndex > #colors then currentIndex = 1 end
            
            colorDisplay.BackgroundColor3 = colors[currentIndex]
            callback(colors[currentIndex])
        end)
    end)
end

-- Crosshair (NO EMOJI!)
lib.CrosshairFrame = Instance.new("Frame")
lib.CrosshairFrame.Size = UDim2.new(0, 22, 0, 22)
lib.CrosshairFrame.Position = UDim2.new(0.5, -11, 0.5, -11)
lib.CrosshairFrame.BackgroundTransparency = 1
lib.CrosshairFrame.Visible = false
lib.CrosshairFrame.ZIndex = 10
lib.CrosshairFrame.Parent = ScreenGui

local crosshairH = Instance.new("Frame")
crosshairH.Size = UDim2.new(1, 0, 0, 2)
crosshairH.Position = UDim2.new(0, 0, 0.5, -1)
crosshairH.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
crosshairH.BorderSizePixel = 0
crosshairH.Parent = lib.CrosshairFrame

local crosshairV = Instance.new("Frame")
crosshairV.Size = UDim2.new(0, 2, 1, 0)
crosshairV.Position = UDim2.new(0.5, -1, 0, 0)
crosshairV.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
crosshairV.BorderSizePixel = 0
crosshairV.Parent = lib.CrosshairFrame

-- Aimbot FOV
lib.AimbotFOVCircle = Instance.new("Frame")
lib.AimbotFOVCircle.Size = UDim2.new(0, 100, 0, 100)
lib.AimbotFOVCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
lib.AimbotFOVCircle.BackgroundTransparency = 0.8
lib.AimbotFOVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lib.AimbotFOVCircle.BorderSizePixel = 0
lib.AimbotFOVCircle.Visible = false
lib.AimbotFOVCircle.ZIndex = 5
lib.AimbotFOVCircle.Parent = ScreenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = lib.AimbotFOVCircle

-- ============================================
-- TOGGLE CALLBACKS
-- ============================================
lib.ToggleESP = function(state)
    lib.ESPEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                lib.CreateESP(player)
            end
        end
        if lib.RGBESPEnabled then lib.StartRGBESP() end
        if lib.SuperESPEnabled then lib.StartSuperESP() end
    else
        lib.ClearAllESP()
        lib.StopRGBESP()
        lib.StopSuperESP()
    end
end

lib.ToggleGeneratorESP = function(state)
    lib.GeneratorESPEnabled = state
    if state then lib.FindAndCreateGenerators() end
end

lib.ToggleRGBESP = function(state)
    lib.RGBESPEnabled = state
    if state then lib.StartRGBESP() else lib.StopRGBESP() end
end

lib.ToggleSuperESP = function(state)
    lib.SuperESPEnabled = state
    if state then lib.StartSuperESP() else lib.StopSuperESP() end
end

lib.ToggleWalkSpeed = function(state)
    lib.walkSpeedActive = state
end

lib.ToggleJumpPower = function(state)
    lib.JumpPowerEnabled = state
end

lib.ToggleNoclip = function(state)
    lib.NoclipEnabled = state
    if state then lib.StartNoclip() else lib.StopNoclip() end
end

lib.ToggleGodMode = function(state)
    lib.GodModeEnabled = state
    if state then lib.StartGodMode() else lib.StopGodMode() end
end

lib.ToggleAntiStun = function(state)
    lib.AntiStunEnabled = state
    if state then lib.StartAntiStun() else lib.StopAntiStun() end
end

lib.ToggleNoFog = function(state)
    lib.NoFogEnabled = state
    if state then lib.StartNoFog() else lib.StopNoFog() end
end

lib.ToggleCrosshair = function(state)
    lib.CrosshairEnabled = state
    lib.CrosshairFrame.Visible = state
end

lib.ToggleAimbot = function(state)
    lib.AimbotEnabled = state
    lib.AimbotFOVCircle.Visible = state
    
    if state then
        if lib.Connections.Aimbot then lib.Connections.Aimbot:Disconnect() end
        lib.Connections.Aimbot = RunService.RenderStepped:Connect(function()
            pcall(function()
                if lib.AimbotEnabled then
                    local target = lib.AimbotFunctions.findClosestPlayer()
                    if target then
                        lib.AimbotFunctions.aimAt(target)
                    end
                end
            end)
        end)
    else
        if lib.Connections.Aimbot then
            lib.Connections.Aimbot:Disconnect()
            lib.Connections.Aimbot = nil
        end
    end
end

-- ============================================
-- CREATE UI ELEMENTS (NO EMOJI!)
-- ============================================
print("Adding features...")

-- ESP Tab
lib.CreateToggle("ESP Players", false, lib.ToggleESP, tabFrames["ESP"])
lib.CreateToggle("ESP Generators", false, lib.ToggleGeneratorESP, tabFrames["ESP"])
lib.CreateToggle("RGB ESP", false, lib.ToggleRGBESP, tabFrames["ESP"])
lib.CreateSlider("RGB Speed", 0.1, 5, 1, function(v) lib.RGBESPSpeed = v end, tabFrames["ESP"])
lib.CreateToggle("Super ESP", false, lib.ToggleSuperESP, tabFrames["ESP"])
lib.CreateSlider("Super Speed", 0.1, 5, 1, function(v) lib.SuperESPSpeed = v end, tabFrames["ESP"])

-- Colors Tab
lib.CreateColorPicker("Killer Color", lib.KillerColor, function(c) lib.KillerColor = c; lib.UpdateESP() end, tabFrames["COLORS"])
lib.CreateColorPicker("Survivor Color", lib.SurvivorColor, function(c) lib.SurvivorColor = c; lib.UpdateESP() end, tabFrames["COLORS"])
lib.CreateColorPicker("Generator Color", lib.GeneratorColor, function(c) lib.GeneratorColor = c end, tabFrames["COLORS"])

-- Move Tab
lib.CreateToggle("Walk Speed", false, lib.ToggleWalkSpeed, tabFrames["MOVE"])
lib.CreateSlider("Speed", 16, 500, 16, function(v) lib.walkSpeed = v end, tabFrames["MOVE"])
lib.CreateToggle("Jump Power", false, lib.ToggleJumpPower, tabFrames["MOVE"])
lib.CreateSlider("Jump", 50, 500, 50, function(v) lib.JumpPowerValue = v end, tabFrames["MOVE"])
lib.CreateToggle("Noclip", false, lib.ToggleNoclip, tabFrames["MOVE"])
lib.CreateToggle("God Mode", false, lib.ToggleGodMode, tabFrames["MOVE"])
lib.CreateToggle("Anti Stun", false, lib.ToggleAntiStun, tabFrames["MOVE"])
lib.CreateButton("Teleport to Player", lib.OpenTeleportMenu, tabFrames["MOVE"])

-- Visual Tab
lib.CreateToggle("No Fog", false, lib.ToggleNoFog, tabFrames["VISUAL"])
lib.CreateToggle("Crosshair", false, lib.ToggleCrosshair, tabFrames["VISUAL"])

-- Aim Tab
lib.CreateToggle("Aimbot", false, lib.ToggleAimbot, tabFrames["AIM"])
lib.CreateSlider("FOV", 10, 200, 50, function(v) 
    lib.AimbotFOV = v
    lib.AimbotFOVCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
    lib.AimbotFOVCircle.Position = UDim2.new(0.5, -v, 0.5, -v)
end, tabFrames["AIM"])
lib.CreateSlider("Smoothness", 1, 100, 10, function(v) lib.AimbotSmoothness = v end, tabFrames["AIM"])
lib.CreateToggle("Team Check", true, function(s) lib.AimbotTeamCheck = s end, tabFrames["AIM"])

print("All features added!")

-- ============================================
-- FLOATING BUTTON (NO EMOJI!)
-- ============================================
print("Creating floating button...")

lib.FloatingButton = Instance.new("ImageButton")
lib.FloatingButton.Size = UDim2.new(0, 75, 0, 75)
lib.FloatingButton.Position = UDim2.new(0, 15, 1, -95)
lib.FloatingButton.Image = "https://files.catbox.moe/8h7dgs.jpg"
lib.FloatingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
lib.FloatingButton.BorderSizePixel = 0
lib.FloatingButton.ZIndex = 1000
lib.FloatingButton.Parent = ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = lib.FloatingButton

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = Color3.fromRGB(255, 255, 255)
floatStroke.Thickness = 4
floatStroke.Parent = lib.FloatingButton

-- Make button draggable
local btnDragToggle = false
local btnDragStart = nil
local btnStartPos = nil

lib.FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDragToggle = true
        btnDragStart = input.Position
        btnStartPos = lib.FloatingButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                btnDragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and btnDragToggle then
        local delta = input.Position - btnDragStart
        lib.FloatingButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

-- Menu toggle
lib.MenuOpen = false

lib.FloatingButton.MouseButton1Click:Connect(function()
    lib.MenuOpen = not lib.MenuOpen
    lib.MainFrame.Visible = lib.MenuOpen
    
    if lib.MenuOpen then
        lib.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        lib.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(lib.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, 500, 0, 600), Position = UDim2.new(0.5, -250, 0.5, -300)}):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    lib.MenuOpen = false
    TweenService:Create(lib.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.3)
    lib.MainFrame.Visible = false
end)

print("Floating button created!")

-- ============================================
-- MOVEMENT UPDATER
-- ============================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if lib.walkSpeedActive then
                    humanoid.WalkSpeed = lib.walkSpeed
                end
                if lib.JumpPowerEnabled then
                    humanoid.JumpPower = lib.JumpPowerValue
                end
            end
        end
    end)
end)

-- ============================================
-- NOTIFICATION (NO EMOJI!)
-- ============================================
local Notification = Instance.new("Frame")
Notification.Size = UDim2.new(0, 320, 0, 95)
Notification.Position = UDim2.new(0.5, -160, 0, -120)
Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Notification.BorderSizePixel = 0
Notification.ZIndex = 1001
Notification.Parent = ScreenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 15)
notifCorner.Parent = Notification

local notifStroke = Instance.new("UIStroke")
notifStroke.Color = Color3.fromRGB(100, 100, 255)
notifStroke.Thickness = 3
notifStroke.Parent = Notification

local notifTitle = Instance.new("TextLabel")
notifTitle.Size = UDim2.new(1, 0, 0, 38)
notifTitle.BackgroundTransparency = 1
notifTitle.Text = "[LOADED SUCCESSFULLY!]"
notifTitle.TextColor3 = Color3.fromRGB(100, 100, 255)
notifTitle.TextSize = 17
notifTitle.Font = Enum.Font.GothamBold
notifTitle.Parent = Notification

local notifDesc = Instance.new("TextLabel")
notifDesc.Size = UDim2.new(1, 0, 1, -38)
notifDesc.Position = UDim2.new(0, 0, 0, 38)
notifDesc.BackgroundTransparency = 1
notifDesc.Text = "Tap the icon to open menu!\nEnjoy all features!"
notifDesc.TextColor3 = Color3.white
notifDesc.TextSize = 13
notifDesc.Font = Enum.Font.Gotham
notifDesc.Parent = Notification

TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Position = UDim2.new(0.5, -160, 0, 18)}):Play()

task.spawn(function()
    task.wait(5)
    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Position = UDim2.new(0.5, -160, 0, -120)}):Play()
    task.wait(0.5)
    Notification:Destroy()
end)

-- ============================================
-- CHARACTER RESPAWN HANDLER
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    pcall(function()
        if lib.walkSpeedActive then
            character:WaitForChild("Humanoid").WalkSpeed = lib.walkSpeed
        end
        if lib.JumpPowerEnabled then
            character:WaitForChild("Humanoid").JumpPower = lib.JumpPowerValue
        end
        if lib.NoclipEnabled then
            lib.StartNoclip()
        end
        if lib.GodModeEnabled then
            lib.StartGodMode()
        end
        if lib.ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    lib.CreateESP(player)
                end
            end
        end
    end)
end)

-- ============================================
-- FINAL
-- ============================================
print("================================================")
print("    [IKAXZU HUB - LOADED SUCCESSFULLY!]")
print("================================================")
print("TAP THE ICON TO OPEN MENU!")
print("ALL FEATURES READY!")
print("KEY: ikaxzu")
print("================================================")
