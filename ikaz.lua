--[[
    IKAXZU HUB - NO KEY EDITION
    Combat Features + Auto Aim
    Mobile & PC Compatible
]]

repeat task.wait() until game:IsLoaded()
task.wait(1)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkaxzuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

print("[IKAXZU] Loading...")

-- ============================================
-- LIBRARY
-- ============================================
local lib = {
    -- ESP
    ESPEnabled = false,
    GeneratorESPEnabled = false,
    RGBESPEnabled = false,
    RGBESPSpeed = 1,
    KillerColor = Color3.fromRGB(255, 0, 0),
    SurvivorColor = Color3.fromRGB(0, 255, 0),
    GeneratorColor = Color3.fromRGB(255, 255, 0),
    
    -- Movement
    walkSpeedActive = false,
    walkSpeed = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    NoclipEnabled = false,
    FlyEnabled = false,
    FlySpeed = 50,
    
    -- Combat
    GodModeEnabled = false,
    AntiStunEnabled = false,
    AutoAimEnabled = false,
    AutoAimRange = 50,
    AutoKillEnabled = false,
    
    -- Visual
    NoFogEnabled = false,
    FullBrightEnabled = false,
    CrosshairEnabled = false,
    
    -- Aimbot
    AimbotEnabled = false,
    AimbotFOV = 100,
    AimbotSmoothness = 10,
    AimbotTeamCheck = true,
    
    -- Storage
    ESPFolders = {},
    GeneratorESPItems = {},
    Connections = {},
    _cache = {roleCache = {}},
}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
lib.GetRainbowColor = function(speed)
    local hue = (tick() * speed * 100) % 255 / 255
    return Color3.fromHSV(hue, 1, 1)
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

lib.GetClosestPlayer = function()
    local closestPlayer = nil
    local closestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not lib.IsPlayerSpectator(player) then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (myChar.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
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
-- AUTO AIM & AUTO KILL
-- ============================================
lib.StartAutoAim = function()
    if lib.Connections.AutoAim then lib.Connections.AutoAim:Disconnect() end
    
    lib.Connections.AutoAim = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not lib.AutoAimEnabled then return end
            
            local myChar = LocalPlayer.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
            
            local target = lib.GetClosestPlayer()
            if target and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local distance = (myChar.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                    
                    if distance <= lib.AutoAimRange then
                        -- Auto aim camera
                        local camera = workspace.CurrentCamera
                        local targetHead = target.Character:FindFirstChild("Head") or targetRoot
                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetHead.Position)
                        
                        -- Auto kill logic (if enabled)
                        if lib.AutoKillEnabled then
                            -- Look for tool/weapon
                            local tool = myChar:FindFirstChildOfClass("Tool")
                            if tool then
                                -- Try to activate tool
                                tool:Activate()
                            end
                        end
                    end
                end
            end
        end)
    end)
end

lib.StopAutoAim = function()
    if lib.Connections.AutoAim then
        lib.Connections.AutoAim:Disconnect()
        lib.Connections.AutoAim = nil
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
-- MOVEMENT
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

lib.StartFly = function()
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    lib.BodyVelocity = Instance.new("BodyVelocity")
    lib.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    lib.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    lib.BodyVelocity.Parent = rootPart
    
    lib.BodyGyro = Instance.new("BodyGyro")
    lib.BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    lib.BodyGyro.P = 1000
    lib.BodyGyro.Parent = rootPart
    
    if lib.Connections.Fly then lib.Connections.Fly:Disconnect() end
    
    lib.Connections.Fly = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not lib.FlyEnabled or not lib.BodyVelocity or not lib.BodyGyro then return end
            
            lib.BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            lib.BodyVelocity.Velocity = moveDirection * lib.FlySpeed
        end)
    end)
end

lib.StopFly = function()
    if lib.Connections.Fly then
        lib.Connections.Fly:Disconnect()
        lib.Connections.Fly = nil
    end
    
    if lib.BodyVelocity then
        lib.BodyVelocity:Destroy()
        lib.BodyVelocity = nil
    end
    
    if lib.BodyGyro then
        lib.BodyGyro:Destroy()
        lib.BodyGyro = nil
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
-- VISUAL
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

lib.StartFullBright = function()
    if lib.Connections.FullBright then lib.Connections.FullBright:Disconnect() end
    
    lib.Connections.FullBright = RunService.Heartbeat:Connect(function()
        pcall(function()
            if lib.FullBrightEnabled then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
        end)
    end)
end

lib.StopFullBright = function()
    if lib.Connections.FullBright then
        lib.Connections.FullBright:Disconnect()
        lib.Connections.FullBright = nil
    end
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
end

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

-- ============================================
-- CREATE MAIN UI
-- ============================================
lib.MainFrame = Instance.new("Frame")
lib.MainFrame.Size = UDim2.new(0, 450, 0, 600)
lib.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
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

-- Draggable
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
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = lib.MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 35, 0, 35)
logoImg.Position = UDim2.new(0, 8, 0.5, -17.5)
logoImg.BackgroundTransparency = 1
logoImg.Image = "https://files.catbox.moe/8h7dgs.jpg"
logoImg.Parent = titleBar

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logoImg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.BackgroundTransparency = 1
title.Text = "IKAXZU HUB"
title.TextColor3 = Color3.fromRGB(100, 100, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0.5, -20)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.white
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 10)
closeBtnCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -16, 1, -60)
contentFrame.Position = UDim2.new(0, 8, 0, 55)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = lib.MainFrame

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 8)
contentList.Parent = contentFrame

contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
end)

-- ============================================
-- UI CREATION FUNCTIONS
-- ============================================
lib.CreateToggle = function(text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -65, 1, 0)
    toggleLabel.Position = UDim2.new(0, 12, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.white
    toggleLabel.TextSize = 15
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 22)
    toggleButton.Position = UDim2.new(1, -53, 0.5, -11)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(50, 50, 55)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
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
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
        else
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
        end
        
        pcall(function() callback(enabled) end)
    end)
end

lib.CreateSlider = function(text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 58)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = contentFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -16, 0, 20)
    sliderLabel.Position = UDim2.new(0, 8, 0, 4)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. default
    sliderLabel.TextColor3 = Color3.white
    sliderLabel.TextSize = 14
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -16, 0, 10)
    sliderBack.Position = UDim2.new(0, 8, 1, -17)
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

lib.CreateButton = function(text, callback)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, 0, 0, 45)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Text = text
    buttonFrame.TextColor3 = Color3.white
    buttonFrame.TextSize = 15
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.Parent = contentFrame
    
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

lib.CreateLabel = function(text)
    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(1, 0, 0, 35)
    labelFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    labelFrame.BorderSizePixel = 0
    labelFrame.Parent = contentFrame
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 10)
    labelCorner.Parent = labelFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(100, 100, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = labelFrame
end

-- Crosshair
lib.CrosshairFrame = Instance.new("Frame")
lib.CrosshairFrame.Size = UDim2.new(0, 20, 0, 20)
lib.CrosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -10)
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
lib.AimbotFOVCircle.Size = UDim2.new(0, 200, 0, 200)
lib.AimbotFOVCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
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
    else
        lib.ClearAllESP()
        lib.StopRGBESP()
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

lib.ToggleFly = function(state)
    lib.FlyEnabled = state
    if state then lib.StartFly() else lib.StopFly() end
end

lib.ToggleGodMode = function(state)
    lib.GodModeEnabled = state
    if state then lib.StartGodMode() else lib.StopGodMode() end
end

lib.ToggleAntiStun = function(state)
    lib.AntiStunEnabled = state
    if state then lib.StartAntiStun() else lib.StopAntiStun() end
end

lib.ToggleAutoAim = function(state)
    lib.AutoAimEnabled = state
    if state then lib.StartAutoAim() else lib.StopAutoAim() end
end

lib.ToggleAutoKill = function(state)
    lib.AutoKillEnabled = state
end

lib.ToggleNoFog = function(state)
    lib.NoFogEnabled = state
    if state then lib.StartNoFog() else lib.StopNoFog() end
end

lib.ToggleFullBright = function(state)
    lib.FullBrightEnabled = state
    if state then lib.StartFullBright() else lib.StopFullBright() end
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
-- CREATE UI ELEMENTS
-- ============================================
lib.CreateLabel("ESP FEATURES")
lib.CreateToggle("ESP Players", false, lib.ToggleESP)
lib.CreateToggle("ESP Generators", false, lib.ToggleGeneratorESP)
lib.CreateToggle("RGB ESP", false, lib.ToggleRGBESP)
lib.CreateSlider("RGB Speed", 0.1, 5, 1, function(v) lib.RGBESPSpeed = v end)

lib.CreateLabel("MOVEMENT")
lib.CreateToggle("Walk Speed", false, lib.ToggleWalkSpeed)
lib.CreateSlider("Speed", 16, 500, 16, function(v) lib.walkSpeed = v end)
lib.CreateToggle("Jump Power", false, lib.ToggleJumpPower)
lib.CreateSlider("Jump", 50, 500, 50, function(v) lib.JumpPowerValue = v end)
lib.CreateToggle("Noclip", false, lib.ToggleNoclip)
lib.CreateToggle("Fly (WASD + Space/Shift)", false, lib.ToggleFly)
lib.CreateSlider("Fly Speed", 10, 200, 50, function(v) lib.FlySpeed = v end)

lib.CreateLabel("COMBAT (AUTO AIM)")
lib.CreateToggle("God Mode", false, lib.ToggleGodMode)
lib.CreateToggle("Anti Stun", false, lib.ToggleAntiStun)
lib.CreateToggle("Auto Aim (Closest Player)", false, lib.ToggleAutoAim)
lib.CreateSlider("Auto Aim Range", 10, 100, 50, function(v) lib.AutoAimRange = v end)
lib.CreateToggle("Auto Kill (Needs Weapon)", false, lib.ToggleAutoKill)

lib.CreateLabel("VISUAL")
lib.CreateToggle("No Fog", false, lib.ToggleNoFog)
lib.CreateToggle("Full Bright", false, lib.ToggleFullBright)
lib.CreateToggle("Crosshair", false, lib.ToggleCrosshair)

lib.CreateLabel("AIMBOT (MANUAL)")
lib.CreateToggle("Aimbot", false, lib.ToggleAimbot)
lib.CreateSlider("FOV", 10, 300, 100, function(v) 
    lib.AimbotFOV = v
    lib.AimbotFOVCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
    lib.AimbotFOVCircle.Position = UDim2.new(0.5, -v, 0.5, -v)
end)
lib.CreateSlider("Smoothness", 1, 100, 10, function(v) lib.AimbotSmoothness = v end)
lib.CreateToggle("Team Check (Killer Only)", true, function(s) lib.AimbotTeamCheck = s end)

lib.CreateLabel("TELEPORT")
lib.CreateButton("Teleport to Random Player", function()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player)
        end
    end
    if #players > 0 then
        local randomPlayer = players[math.random(1, #players)]
        lib.TeleportToPlayer(randomPlayer)
    end
end)

-- ============================================
-- FLOATING BUTTON
-- ============================================
lib.FloatingButton = Instance.new("ImageButton")
lib.FloatingButton.Size = UDim2.new(0, 70, 0, 70)
lib.FloatingButton.Position = UDim2.new(0, 15, 1, -85)
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

-- Draggable
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
            {Size = UDim2.new(0, 450, 0, 600), Position = UDim2.new(0.5, -225, 0.5, -300)}):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    lib.MenuOpen = false
    TweenService:Create(lib.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.3)
    lib.MainFrame.Visible = false
end)

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
-- NOTIFICATION
-- ============================================
local Notification = Instance.new("Frame")
Notification.Size = UDim2.new(0, 300, 0, 80)
Notification.Position = UDim2.new(0.5, -150, 0, -100)
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
notifTitle.Size = UDim2.new(1, 0, 0, 35)
notifTitle.BackgroundTransparency = 1
notifTitle.Text = "IKAXZU HUB + AUTO AIM!"
notifTitle.TextColor3 = Color3.fromRGB(100, 100, 255)
notifTitle.TextSize = 17
notifTitle.Font = Enum.Font.GothamBold
notifTitle.Parent = Notification

local notifDesc = Instance.new("TextLabel")
notifDesc.Size = UDim2.new(1, 0, 1, -35)
notifDesc.Position = UDim2.new(0, 0, 0, 35)
notifDesc.BackgroundTransparency = 1
notifDesc.Text = "Tap icon to open menu!"
notifDesc.TextColor3 = Color3.white
notifDesc.TextSize = 13
notifDesc.Font = Enum.Font.Gotham
notifDesc.Parent = Notification

TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Position = UDim2.new(0.5, -150, 0, 15)}):Play()

task.spawn(function()
    task.wait(4)
    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Position = UDim2.new(0.5, -150, 0, -100)}):Play()
    task.wait(0.5)
    Notification:Destroy()
end)

-- ============================================
-- CHARACTER RESPAWN
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
        if lib.NoclipEnabled then lib.StartNoclip() end
        if lib.FlyEnabled then lib.StartFly() end
        if lib.GodModeEnabled then lib.StartGodMode() end
        if lib.AutoAimEnabled then lib.StartAutoAim() end
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
print("[IKAXZU] Hub loaded successfully!")
print("[IKAXZU] AUTO AIM feature added!")
print("[IKAXZU] Tap the icon to open menu")
print("[IKAXZU] Enjoy!")
