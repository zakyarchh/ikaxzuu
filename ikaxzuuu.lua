-- ============================================
-- IKAXZU HUB - VIOLENCE DISTRICT ULTIMATE
-- Mobile & PC Compatible - Full Features
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- ============================================
-- KEY SYSTEM
-- ============================================

local CORRECT_KEY = "ikaxzu"
local keyEntered = false

local function CreateKeySystem()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystem"
    KeyGui.ResetOnSpawn = false
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn then
        syn.protect_gui(KeyGui)
        KeyGui.Parent = CoreGui
    else
        KeyGui.Parent = CoreGui
    end

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 400, 0, 250)
    KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = KeyGui

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 15)
    KeyCorner.Parent = KeyFrame

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = Color3.fromRGB(100, 100, 255)
    KeyStroke.Thickness = 3
    KeyStroke.Parent = KeyFrame

    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 80, 0, 80)
    Logo.Position = UDim2.new(0.5, -40, 0, 20)
    Logo.BackgroundTransparency = 1
    Logo.Image = "https://files.catbox.moe/8h7dgs.jpg"
    Logo.Parent = KeyFrame

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 15)
    LogoCorner.Parent = Logo
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0, 150)
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.PlaceholderText = "Enter Key: ikaxzu"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.white
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.BorderSizePixel = 0
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 10)
    InputCorner.Parent = KeyInput

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0, 200)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SubmitButton.Text = "✓ SUBMIT KEY"
    SubmitButton.TextColor3 = Color3.white
    SubmitButton.TextSize = 18
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Parent = KeyFrame

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 10)
    SubmitCorner.Parent = SubmitButton

    SubmitButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == CORRECT_KEY then
            keyEntered = true
            local tween = TweenService:Create(KeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
            tween:Play()
            tween.Completed:Connect(function()
                KeyGui:Destroy()
            end)
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "❌ Wrong Key!"
            KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
            wait(0.5)
            KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            KeyInput.PlaceholderText = "Enter Key: ikaxzu"
        end
    end)
end

CreateKeySystem()
repeat wait() until keyEntered

-- ============================================
-- LIBRARY INITIALIZATION
-- ============================================

local lib = {}
lib.LocalPlayer = Players.LocalPlayer
lib.Character = lib.LocalPlayer.Character or lib.LocalPlayer.CharacterAdded:Wait()
lib.Humanoid = lib.Character:WaitForChild("Humanoid")
lib.RootPart = lib.Character:WaitForChild("HumanoidRootPart")

-- ============================================
-- VARIABLES
-- ============================================

-- ESP Settings
lib.ESPEnabled = false
lib.GeneratorESPEnabled = false
lib.PalletESPEnabled = false
lib.RGBESPEnabled = false
lib.SuperESPEnabled = false
lib.RGBESPSpeed = 1
lib.SuperESPSpeed = 1

-- Colors
lib.KillerColor = Color3.fromRGB(255, 0, 0)
lib.SurvivorColor = Color3.fromRGB(0, 255, 0)
lib.GeneratorColor = Color3.fromRGB(255, 255, 0)
lib.PalletColor = Color3.fromRGB(255, 165, 0)

-- Movement
lib.walkSpeedActive = false
lib.walkSpeed = 16
lib.JumpPowerEnabled = false
lib.JumpPowerValue = 50
lib.FlyEnabled = false
lib.FlySpeedValue = 50
lib.NoclipEnabled = false

-- Combat
lib.GodModeEnabled = false
lib.InvisibleEnabled = false
lib.AntiStunEnabled = false
lib.AntiGrabEnabled = false
lib.MaxEscapeChanceEnabled = false
lib.GrabKillerEnabled = false
lib.RapidFireEnabled = false
lib.DisableTwistAnimationsEnabled = false

-- Visual
lib.NoFogEnabled = false
lib.TimeEnabled = false
lib.TimeValue = 12
lib.MapColorEnabled = false
lib.MapColor = Color3.fromRGB(255, 255, 255)
lib.MapColorSaturation = 1
lib.CrosshairEnabled = false
lib.ThirdPersonEnabled = false
lib.RotatePersonEnabled = false
lib.RotateSpeed = 100

-- Aimbot
lib.AimbotEnabled = false
lib.AimbotFOV = 50
lib.AimbotSmoothness = 10
lib.AimbotTeamCheck = true
lib.AimbotVisibleCheck = true
lib.AimbotWallCheck = false

-- Storage
lib.ESPFolders = {}
lib.GeneratorESPItems = {}
lib.PalletESPItems = {}
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
        baseColor.R * (0.5 + offset * 0.5),
        baseColor.G * (0.5 + offset * 0.5),
        baseColor.B * (0.5 + offset * 0.5)
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
                     player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") ~= nil
    
    lib._cache.roleCache[player.UserId] = {isKiller = isKiller, time = tick()}
    return isKiller
end

lib.IsPlayerSpectator = function(player)
    if not player or not player.Character then return true end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return not humanoid or humanoid.Health <= 0
end

lib.GetPlayerRole = function(player)
    if lib.IsPlayerSpectator(player) then return "Spectator" end
    if lib.IsPlayerKiller(player) then return "Killer" end
    return "Survivor"
end

-- ============================================
-- ESP FUNCTIONS
-- ============================================

lib.CreateESP = function(player)
    if player == lib.LocalPlayer or lib.IsPlayerSpectator(player) then return end
    
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
    nameLabel.Text = player.Name .. " [" .. lib.GetPlayerRole(player) .. "]"
    nameLabel.TextColor3 = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = billboard
    
    lib.ESPFolders[player] = folder
end

lib.RemoveESP = function(player)
    if lib.ESPFolders[player] then
        lib.ESPFolders[player]:Destroy()
        lib.ESPFolders[player] = nil
    end
end

lib.ClearAllESP = function()
    for player, folder in pairs(lib.ESPFolders) do
        if folder then folder:Destroy() end
    end
    lib.ESPFolders = {}
end

lib.UpdateESP = function()
    for player, folder in pairs(lib.ESPFolders) do
        if player and folder and player.Character then
            local highlight = folder:FindFirstChild("ESPHighlight")
            local billboard = folder:FindFirstChild("ESPBillboard")
            
            if highlight then
                highlight.FillColor = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
            end
            
            if billboard then
                local nameLabel = billboard:FindFirstChild("ESPName")
                if nameLabel then
                    nameLabel.TextColor3 = lib.IsPlayerKiller(player) and lib.KillerColor or lib.SurvivorColor
                end
            end
        end
    end
end

-- Generator ESP
lib.FindAndCreateGenerators = function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") and obj:IsA("Model") then
            lib.CreateGeneratorESP(obj)
        end
    end
end

lib.CreateGeneratorESP = function(generator)
    if lib.GeneratorESPItems[generator] then return end
    
    local folder = Instance.new("Folder")
    folder.Name = "GeneratorESP"
    folder.Parent = generator
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.Adornee = generator
    highlight.FillColor = lib.GeneratorColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = folder
    
    lib.GeneratorESPItems[generator] = folder
end

lib.UpdateGeneratorESP = function()
    for obj, folder in pairs(lib.GeneratorESPItems) do
        if obj and folder then
            local highlight = folder:FindFirstChild("Highlight")
            if highlight then
                highlight.FillColor = lib.GeneratorColor
            end
        end
    end
end

-- Pallet ESP
lib.FindAndCreatePallets = function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("pallet") and obj:IsA("Model") then
            lib.CreatePalletESP(obj)
        end
    end
end

lib.CreatePalletESP = function(pallet)
    if lib.PalletESPItems[pallet] then return end
    
    local folder = Instance.new("Folder")
    folder.Name = "PalletESP"
    folder.Parent = pallet
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.Adornee = pallet
    highlight.FillColor = lib.PalletColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = folder
    
    lib.PalletESPItems[pallet] = folder
end

lib.UpdatePalletESP = function()
    for obj, folder in pairs(lib.PalletESPItems) do
        if obj and folder then
            local highlight = folder:FindFirstChild("Highlight")
            if highlight then
                highlight.FillColor = lib.PalletColor
            end
        end
    end
end

lib.ObjectESPManager = {
    ClearAll = function()
        for obj, folder in pairs(lib.GeneratorESPItems) do
            if folder then folder:Destroy() end
        end
        lib.GeneratorESPItems = {}
        
        for obj, folder in pairs(lib.PalletESPItems) do
            if folder then folder:Destroy() end
        end
        lib.PalletESPItems = {}
    end
}

-- ============================================
-- AIMBOT FUNCTIONS
-- ============================================

lib.AimbotFunctions = {}

lib.AimbotFunctions.isPlayerVisible = function(player)
    if not lib.AimbotWallCheck then return true end
    
    local character = player.Character
    if not character then return false end
    
    local head = character:FindFirstChild("Head")
    if not head then return false end
    
    local camera = Workspace.CurrentCamera
    local cameraPos = camera.CFrame.Position
    local direction = (head.Position - cameraPos).Unit
    local distance = (head.Position - cameraPos).Magnitude
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {lib.LocalPlayer.Character, character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.IgnoreWater = true
    
    local result = Workspace:Raycast(cameraPos, direction * distance, rayParams)
    return result == nil
end

lib.AimbotFunctions.findClosestPlayer = function()
    local closestPlayer = nil
    local closestDistance = lib.AimbotFOV
    local camera = Workspace.CurrentCamera
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lib.LocalPlayer and player.Character then
            if lib.AimbotTeamCheck and not lib.IsPlayerKiller(player) then
                continue
            end
            
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    if lib.AimbotVisibleCheck and not lib.AimbotFunctions.isPlayerVisible(player) then
                        continue
                    end
                    
                    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (center - targetPos).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

lib.AimbotFunctions.aimAt = function(player)
    if not player or not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local camera = Workspace.CurrentCamera
    local cameraPos = camera.CFrame.Position
    local targetPos = head.Position
    local targetCFrame = CFrame.lookAt(cameraPos, targetPos)
    local smoothness = (100 - lib.AimbotSmoothness) / 100
    
    camera.CFrame = camera.CFrame:Lerp(targetCFrame, smoothness)
end

lib.AimbotFunctions.updateAimbotUI = function()
    if lib.AimbotFOVCircle then
        lib.AimbotFOVCircle.Visible = lib.AimbotEnabled
        lib.AimbotFOVCircle.Size = UDim2.new(0, lib.AimbotFOV * 2, 0, lib.AimbotFOV * 2)
    end
end

lib.StartAimbot = function()
    if lib.Connections.Aimbot then
        lib.Connections.Aimbot:Disconnect()
    end
    
    lib.Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if lib.AimbotEnabled then
            local target = lib.AimbotFunctions.findClosestPlayer()
            if target then
                lib.AimbotFunctions.aimAt(target)
            end
        end
    end)
end

lib.StopAimbot = function()
    if lib.Connections.Aimbot then
        lib.Connections.Aimbot:Disconnect()
        lib.Connections.Aimbot = nil
    end
end

-- ============================================
-- MOVEMENT FUNCTIONS
-- ============================================

-- Fly
lib.StartFly = function()
    local character = lib.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    lib.FlyActive = true
    
    lib.BodyVelocity = Instance.new("BodyVelocity")
    lib.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    lib.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    lib.BodyVelocity.Parent = rootPart
    
    lib.BodyGyro = Instance.new("BodyGyro")
    lib.BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    lib.BodyGyro.P = 1000
    lib.BodyGyro.D = 50
    lib.BodyGyro.Parent = rootPart
    
    lib.Connections.Fly = RunService.Heartbeat:Connect(function()
        if not lib.FlyEnabled or not character or not rootPart or not lib.BodyVelocity or not lib.BodyGyro then
            return
        end
        
        lib.BodyGyro.CFrame = Workspace.CurrentCamera.CFrame
        
        local moveDirection = Vector3.new(0, 0, 0)
        lib.BodyVelocity.Velocity = moveDirection * lib.FlySpeedValue
        humanoid.PlatformStand = true
    end)
end

lib.StopFly = function()
    lib.FlyActive = false
    
    if lib.Connections.Fly then
        lib.Connections.Fly:Disconnect()
        lib.Connections.Fly = nil
    end
    
    local character = lib.LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        if rootPart then
            if lib.BodyVelocity then
                lib.BodyVelocity:Destroy()
                lib.BodyVelocity = nil
            end
            if lib.BodyGyro then
                lib.BodyGyro:Destroy()
                lib.BodyGyro = nil
            end
        end
    end
end

-- Noclip
lib.StartNoclip = function()
    local character = lib.LocalPlayer.Character
    if not character then return end
    
    if lib.Connections.Noclip then
        lib.Connections.Noclip:Disconnect()
    end
    
    lib.Connections.Noclip = RunService.Stepped:Connect(function()
        if not lib.NoclipEnabled or not character or not character.Parent then
            if lib.Connections.Noclip then
                lib.Connections.Noclip:Disconnect()
                lib.Connections.Noclip = nil
            end
            return
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

lib.StopNoclip = function()
    local character = lib.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    if lib.Connections.Noclip then
        lib.Connections.Noclip:Disconnect()
        lib.Connections.Noclip = nil
    end
end

-- ============================================
-- COMBAT FUNCTIONS
-- ============================================

-- God Mode
lib.StartGodMode = function()
    if lib.Connections.GodMode then
        lib.Connections.GodMode:Disconnect()
    end
    
    lib.Connections.GodMode = RunService.Heartbeat:Connect(function()
        if not lib.GodModeEnabled then
            if lib.Connections.GodMode then
                lib.Connections.GodMode:Disconnect()
                lib.Connections.GodMode = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.Health < 100 then
                    humanoid.Health = 100
                end
                humanoid.MaxHealth = math.huge
            end
        end
    end)
end

lib.StopGodMode = function()
    if lib.Connections.GodMode then
        lib.Connections.GodMode:Disconnect()
        lib.Connections.GodMode = nil
    end
    
    local character = lib.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
        end
    end
end

-- Anti Stun
lib.StartAntiStun = function()
    if lib.Connections.AntiStun then
        lib.Connections.AntiStun:Disconnect()
    end
    
    lib.Connections.AntiStun = RunService.Heartbeat:Connect(function()
        if not lib.AntiStunEnabled then
            if lib.Connections.AntiStun then
                lib.Connections.AntiStun:Disconnect()
                lib.Connections.AntiStun = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.PlatformStand then
                    humanoid.PlatformStand = false
                end
                if humanoid.Sit then
                    humanoid.Sit = false
                end
                if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or 
                   humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
    end)
end

lib.StopAntiStun = function()
    if lib.Connections.AntiStun then
        lib.Connections.AntiStun:Disconnect()
        lib.Connections.AntiStun = nil
    end
end

-- Anti Grab
lib.StartAntiGrab = function()
    if lib.Connections.AntiGrab then
        lib.Connections.AntiGrab:Disconnect()
    end
    
    lib.Connections.AntiGrab = RunService.Heartbeat:Connect(function()
        if not lib.AntiGrabEnabled then
            if lib.Connections.AntiGrab then
                lib.Connections.AntiGrab:Disconnect()
                lib.Connections.AntiGrab = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                if humanoid.PlatformStand then
                    humanoid.PlatformStand = false
                    rootPart.Velocity = Vector3.new(0, 50, 0)
                end
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= lib.LocalPlayer and lib.IsPlayerKiller(player) then
                        local killerChar = player.Character
                        if killerChar then
                            local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                            if killerRoot then
                                local distance = (rootPart.Position - killerRoot.Position).Magnitude
                                if distance < 12 then
                                    local dirX = rootPart.Position.X - killerRoot.Position.X
                                    local dirZ = rootPart.Position.Z - killerRoot.Position.Z
                                    local dist = math.sqrt(dirX * dirX + dirZ * dirZ)
                                    if dist > 0 then
                                        local normX, normZ = dirX / dist, dirZ / dist
                                        local newX = killerRoot.Position.X + (normX * 25)
                                        local newZ = killerRoot.Position.Z + (normZ * 25)
                                        rootPart.CFrame = CFrame.new(newX, rootPart.Position.Y + 3, newZ)
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

lib.StopAntiGrab = function()
    if lib.Connections.AntiGrab then
        lib.Connections.AntiGrab:Disconnect()
        lib.Connections.AntiGrab = nil
    end
end

-- Escape Chance
lib.StartEscapeChance = function()
    if lib.Connections.EscapeChance then
        lib.Connections.EscapeChance:Disconnect()
    end
    
    lib.Connections.EscapeChance = RunService.Heartbeat:Connect(function()
        if not lib.MaxEscapeChanceEnabled then
            if lib.Connections.EscapeChance then
                lib.Connections.EscapeChance:Disconnect()
                lib.Connections.EscapeChance = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                if humanoid.PlatformStand or humanoid.Sit then
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                    rootPart.Velocity = (rootPart.CFrame.LookVector * 50) + Vector3.new(0, 25, 0)
                end
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= lib.LocalPlayer and lib.IsPlayerKiller(player) then
                        local killerChar = player.Character
                        if killerChar then
                            local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                            if killerRoot and (rootPart.Position - killerRoot.Position).Magnitude < 8 then
                                local direction = (rootPart.Position - killerRoot.Position).Unit
                                rootPart.Velocity = (direction * 40) + Vector3.new(0, 15, 0)
                            end
                        end
                    end
                end
            end
        end
    end)
end

lib.StopEscapeChance = function()
    if lib.Connections.EscapeChance then
        lib.Connections.EscapeChance:Disconnect()
        lib.Connections.EscapeChance = nil
    end
end

-- Grab Killer
lib.StartGrabKiller = function()
    if lib.Connections.GrabKiller then
        lib.Connections.GrabKiller:Disconnect()
    end
    
    lib.Connections.GrabKiller = RunService.Heartbeat:Connect(function()
        if not lib.GrabKillerEnabled then
            if lib.Connections.GrabKiller then
                lib.Connections.GrabKiller:Disconnect()
                lib.Connections.GrabKiller = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid then
                local closestKiller = nil
                local closestDist = 15
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= lib.LocalPlayer and lib.IsPlayerKiller(player) and not lib.IsPlayerSpectator(player) then
                        local killerChar = player.Character
                        if killerChar then
                            local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                            local killerHumanoid = killerChar:FindFirstChildOfClass("Humanoid")
                            
                            if killerRoot and killerHumanoid and killerHumanoid.Health > 0 then
                                local dist = (rootPart.Position - killerRoot.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestKiller = player
                                end
                            end
                        end
                    end
                end
                
                if closestKiller then
                    local killerChar = closestKiller.Character
                    if killerChar then
                        local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                        local killerHumanoid = killerChar:FindFirstChildOfClass("Humanoid")
                        
                        if killerRoot and killerHumanoid then
                            killerHumanoid.PlatformStand = true
                            local grabOffset = (rootPart.CFrame.LookVector * 4) + Vector3.new(0, 1, 0)
                            killerRoot.CFrame = CFrame.new(rootPart.Position + grabOffset)
                            killerRoot.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end
    end)
end

lib.StopGrabKiller = function()
    if lib.Connections.GrabKiller then
        lib.Connections.GrabKiller:Disconnect()
        lib.Connections.GrabKiller = nil
    end
end

-- Rapid Fire
lib.StartRapidFire = function()
    if lib.Connections.RapidFire then
        lib.Connections.RapidFire:Disconnect()
    end
    
    lib.Connections.RapidFire = RunService.Heartbeat:Connect(function()
        if not lib.RapidFireEnabled then
            if lib.Connections.RapidFire then
                lib.Connections.RapidFire:Disconnect()
                lib.Connections.RapidFire = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local backpack = lib.LocalPlayer:FindFirstChild("Backpack")
            local weapon = nil
            
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "twist") or 
                   string.find(string.lower(tool.Name), "fate") or 
                   string.find(string.lower(tool.Name), "pistol") or 
                   string.find(string.lower(tool.Name), "gun")) then
                    weapon = tool
                    break
                end
            end
            
            if not weapon and backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "twist") or 
                       string.find(string.lower(tool.Name), "fate") or 
                       string.find(string.lower(tool.Name), "pistol") or 
                       string.find(string.lower(tool.Name), "gun")) then
                        weapon = tool
                        break
                    end
                end
            end
            
            if weapon then
                for _, child in pairs(weapon:GetDescendants()) do
                    if child:IsA("NumberValue") and (child.Name == "Cooldown" or child.Name == "Delay" or child.Name == "FireRate") then
                        child.Value = 0
                    end
                end
            end
        end
    end)
end

lib.StopRapidFire = function()
    if lib.Connections.RapidFire then
        lib.Connections.RapidFire:Disconnect()
        lib.Connections.RapidFire = nil
    end
end

-- Disable Twist Animations
lib.StartDisableTwistAnimations = function()
    if lib.Connections.TwistAnimations then
        lib.Connections.TwistAnimations:Disconnect()
    end
    
    lib.Connections.TwistAnimations = RunService.Heartbeat:Connect(function()
        if not lib.DisableTwistAnimationsEnabled then
            if lib.Connections.TwistAnimations then
                lib.Connections.TwistAnimations:Disconnect()
                lib.Connections.TwistAnimations = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local backpack = lib.LocalPlayer:FindFirstChild("Backpack")
            local weapon = nil
            
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "twist") or string.find(string.lower(tool.Name), "fate")) then
                    weapon = tool
                    break
                end
            end
            
            if not weapon and backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "twist") or string.find(string.lower(tool.Name), "fate")) then
                        weapon = tool
                        break
                    end
                end
            end
            
            if weapon then
                for _, anim in pairs(weapon:GetDescendants()) do
                    if anim:IsA("AnimationTrack") then
                        anim:Stop()
                    end
                end
                
                for _, sound in pairs(weapon:GetDescendants()) do
                    if sound:IsA("Sound") then
                        sound:Stop()
                    end
                end
                
                for _, emitter in pairs(weapon:GetDescendants()) do
                    if emitter:IsA("ParticleEmitter") then
                        emitter.Enabled = false
                    end
                end
            end
        end
    end)
end

lib.StopDisableTwistAnimations = function()
    if lib.Connections.TwistAnimations then
        lib.Connections.TwistAnimations:Disconnect()
        lib.Connections.TwistAnimations = nil
    end
end

-- Rotate Person
lib.StartRotatePerson = function()
    if lib.Connections.Rotate then
        lib.Connections.Rotate:Disconnect()
    end
    
    lib.Connections.Rotate = RunService.Heartbeat:Connect(function()
        if not lib.RotatePersonEnabled then
            if lib.Connections.Rotate then
                lib.Connections.Rotate:Disconnect()
                lib.Connections.Rotate = nil
            end
            return
        end
        
        local character = lib.LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local currentCF = rootPart.CFrame
                local rotation = CFrame.Angles(0, math.rad(lib.RotateSpeed) * 0.1, 0)
                rootPart.CFrame = currentCF * rotation
            end
        end
    end)
end

lib.StopRotatePerson = function()
    if lib.Connections.Rotate then
        lib.Connections.Rotate:Disconnect()
        lib.Connections.Rotate = nil
    end
end

-- ============================================
-- VISUAL FUNCTIONS
-- ============================================

-- No Fog
lib.StartNoFog = function()
    if lib.Connections.NoFog then
        lib.Connections.NoFog:Disconnect()
    end
    
    lib.Connections.NoFog = RunService.Heartbeat:Connect(function()
        if not lib.NoFogEnabled then
            if lib.Connections.NoFog then
                lib.Connections.NoFog:Disconnect()
                lib.Connections.NoFog = nil
            end
            return
        end
        
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 100000
        Lighting.FogColor = Color3.new(1, 1, 1)
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

-- Custom Time
lib.StartCustomTime = function()
    if lib.Connections.Time then
        lib.Connections.Time:Disconnect()
    end
    
    lib.Connections.Time = RunService.Heartbeat:Connect(function()
        if not lib.TimeEnabled then
            if lib.Connections.Time then
                lib.Connections.Time:Disconnect()
                lib.Connections.Time = nil
            end
            return
        end
        Lighting.ClockTime = lib.TimeValue
    end)
end

lib.StopCustomTime = function()
    if lib.Connections.Time then
        lib.Connections.Time:Disconnect()
        lib.Connections.Time = nil
    end
end

-- Map Color
lib.StartMapColor = function()
    if lib.Connections.MapColor then
        lib.Connections.MapColor:Disconnect()
    end
    
    lib.Connections.MapColor = RunService.Heartbeat:Connect(function()
        if not lib.MapColorEnabled then
            if lib.Connections.MapColor then
                lib.Connections.MapColor:Disconnect()
                lib.Connections.MapColor = nil
            end
            return
        end
        
        Lighting.Ambient = lib.MapColor
        Lighting.OutdoorAmbient = lib.MapColor
        Lighting.ColorShift_Bottom = lib.MapColor
        Lighting.ColorShift_Top = lib.MapColor
        
        if not Lighting:FindFirstChild("ColorCorrection") then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "ColorCorrection"
            colorCorrection.Saturation = lib.MapColorSaturation
            colorCorrection.Parent = Lighting
        else
            Lighting.ColorCorrection.Saturation = lib.MapColorSaturation
        end
    end)
end

lib.StopMapColor = function()
    if lib.Connections.MapColor then
        lib.Connections.MapColor:Disconnect()
        lib.Connections.MapColor = nil
    end
    
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    
    if Lighting:FindFirstChild("ColorCorrection") then
        Lighting.ColorCorrection:Destroy()
    end
end

-- Third Person
lib.OriginalCameraType = nil

lib.StartThirdPerson = function()
    if not lib.ThirdPersonEnabled then return end
    
    local character = lib.LocalPlayer.Character
    if not character then return end
    
    if not lib.IsPlayerKiller(lib.LocalPlayer) then
        print("Third Person: Available only for Killer")
        lib.ThirdPersonEnabled = false
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if not lib.OriginalCameraType then
        lib.OriginalCameraType = Workspace.CurrentCamera.CameraType
    end
    
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    Workspace.CurrentCamera.CameraSubject = rootPart
end

lib.StopThirdPerson = function()
    if lib.OriginalCameraType then
        Workspace.CurrentCamera.CameraType = lib.OriginalCameraType
        lib.OriginalCameraType = nil
    end
    
    local character = lib.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

lib.UpdateThirdPersonView = function()
    if not lib.ThirdPersonEnabled then return end
    
    local character = lib.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local offset = Vector3.new(0, 2, 8)
    local lookVector = rootPart.CFrame.LookVector
    local cameraPos = (rootPart.Position - (lookVector * offset.Z)) + Vector3.new(0, offset.Y, 0)
    Workspace.CurrentCamera.CFrame = CFrame.lookAt(cameraPos, rootPart.Position + Vector3.new(0, 2, 0))
end

lib.ToggleThirdPerson = function(state)
    lib.ThirdPersonEnabled = state
    
    if state and not lib.IsPlayerKiller(lib.LocalPlayer) then
        print("Third Person: You are not the Killer!")
        lib.ThirdPersonEnabled = false
        return
    end
    
    if state then
        lib.StartThirdPerson()
        
        if lib.Connections.ThirdPerson then
            lib.Connections.ThirdPerson:Disconnect()
        end
        
        lib.Connections.ThirdPerson = RunService.RenderStepped:Connect(function()
            if not lib.ThirdPersonEnabled then
                lib.Connections.ThirdPerson:Disconnect()
                lib.StopThirdPerson()
                return
            end
            
            if not lib.IsPlayerKiller(lib.LocalPlayer) then
                print("Third Person: You are no longer the Killer!")
                lib.ToggleThirdPerson(false)
                return
            end
            
            lib.UpdateThirdPersonView()
        end)
        
        lib.LocalPlayer.CharacterAdded:Connect(function()
            wait(1)
            if lib.ThirdPersonEnabled and lib.IsPlayerKiller(lib.LocalPlayer) then
                lib.StartThirdPerson()
            end
        end)
    else
        if lib.Connections.ThirdPerson then
            lib.Connections.ThirdPerson:Disconnect()
            lib.Connections.ThirdPerson = nil
        end
        lib.StopThirdPerson()
    end
end

-- RGB ESP
lib.StartRGBESP = function()
    if lib.Connections.RGBESP then
        lib.Connections.RGBESP:Disconnect()
    end
    
    lib.Connections.RGBESP = RunService.Heartbeat:Connect(function()
        if not lib.RGBESPEnabled or not lib.ESPEnabled then
            if lib.Connections.RGBESP then
                lib.Connections.RGBESP:Disconnect()
                lib.Connections.RGBESP = nil
            end
            return
        end
        
        local rainbowColor = lib.GetRainbowColor(lib.RGBESPSpeed)
        lib.KillerColor = rainbowColor
        lib.SurvivorColor = rainbowColor
        lib.UpdateESP()
    end)
end

lib.StopRGBESP = function()
    if lib.Connections.RGBESP then
        lib.Connections.RGBESP:Disconnect()
        lib.Connections.RGBESP = nil
    end
end

-- Super ESP
lib.StartSuperESP = function()
    if lib.Connections.SuperESP then
        lib.Connections.SuperESP:Disconnect()
    end
    
    lib.Connections.SuperESP = RunService.Heartbeat:Connect(function()
        if not lib.SuperESPEnabled or not lib.ESPEnabled then
            if lib.Connections.SuperESP then
                lib.Connections.SuperESP:Disconnect()
                lib.Connections.SuperESP = nil
            end
            return
        end
        
        local time = tick()
        
        for player, folder in pairs(lib.ESPFolders) do
            if player and folder and folder.Parent and player.Character then
                local isKiller = lib.IsPlayerKiller(player)
                local baseColor = isKiller and lib.KillerColor or lib.SurvivorColor
                local newColor = lib.GetSuperESPColor(baseColor, time, lib.SuperESPSpeed)
                
                local highlight = folder:FindFirstChild("ESPHighlight")
                local billboard = folder:FindFirstChild("ESPBillboard")
                
                if highlight then
                    highlight.FillColor = newColor
                    highlight.OutlineColor = newColor
                end
                
                if billboard then
                    local nameLabel = billboard:FindFirstChild("ESPName")
                    if nameLabel then
                        nameLabel.TextColor3 = newColor
                    end
                end
            end
        end
        
        for obj, folder in pairs(lib.GeneratorESPItems) do
            if obj and folder then
                local newColor = lib.GetSuperESPColor(lib.GeneratorColor, time, lib.SuperESPSpeed)
                local highlight = folder:FindFirstChild("Highlight")
                if highlight then
                    highlight.FillColor = newColor
                    highlight.OutlineColor = newColor
                end
            end
        end
        
        for obj, folder in pairs(lib.PalletESPItems) do
            if obj and folder then
                local newColor = lib.GetSuperESPColor(lib.PalletColor, time, lib.SuperESPSpeed)
                local highlight = folder:FindFirstChild("Highlight")
                if highlight then
                    highlight.FillColor = newColor
                    highlight.OutlineColor = newColor
                end
            end
        end
    end)
end

lib.StopSuperESP = function()
    if lib.Connections.SuperESP then
        lib.Connections.SuperESP:Disconnect()
        lib.Connections.SuperESP = nil
    end
    
    lib.UpdateESP()
    lib.UpdateGeneratorESP()
    lib.UpdatePalletESP()
end

-- ============================================
-- TELEPORT FUNCTIONS
-- ============================================

lib.TeleportFrame = nil
lib.TeleportPlayersFrame = nil

lib.TeleportToPlayer = function(targetPlayer)
    if not targetPlayer or targetPlayer == lib.LocalPlayer then
        print("Cannot teleport to yourself")
        return
    end
    
    local character = lib.LocalPlayer.Character
    local targetChar = targetPlayer.Character
    
    if not character or not targetChar then
        print("Character not found")
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not rootPart or not targetRoot then
        print("HumanoidRootPart not found")
        return
    end
    
    rootPart.CFrame = CFrame.new(targetRoot.Position + Vector3.new(3, 0, 3))
    print("Teleported to: " .. targetPlayer.Name)
end

lib.UpdateTeleportPlayersList = function()
    if not lib.TeleportPlayersFrame then return end
    
    for _, child in ipairs(lib.TeleportPlayersFrame:GetChildren()) do
        child:Destroy()
    end
    
    local playerCount = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lib.LocalPlayer and not lib.IsPlayerSpectator(player) then
            playerCount = playerCount + 1
            
            local isKiller = lib.IsPlayerKiller(player)
            local btn = Instance.new("TextButton")
            btn.Name = player.Name
            btn.Size = UDim2.new(1, -10, 0, 50)
            btn.Position = UDim2.new(0, 5, 0, (playerCount - 1) * 55)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            btn.BorderSizePixel = 0
            btn.Text = player.Name .. " (" .. (isKiller and "KILLER" or "SURVIVOR") .. ")"
            btn.TextColor3 = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamBold
            btn.Parent = lib.TeleportPlayersFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                lib.TeleportToPlayer(player)
                if lib.TeleportFrame then
                    lib.TeleportFrame.Visible = false
                end
            end)
        end
    end
    
    lib.TeleportPlayersFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(50, playerCount * 55))
    
    if playerCount == 0 then
        local noPlayers = Instance.new("TextLabel")
        noPlayers.Size = UDim2.new(1, -10, 0, 50)
        noPlayers.Position = UDim2.new(0, 5, 0, 0)
        noPlayers.BackgroundTransparency = 1
        noPlayers.Text = "No other players found"
        noPlayers.TextColor3 = Color3.fromRGB(150, 150, 150)
        noPlayers.TextSize = 16
        noPlayers.Font = Enum.Font.Gotham
        noPlayers.Parent = lib.TeleportPlayersFrame
    end
end

lib.CreateTeleportMenu = function()
    lib.TeleportFrame = Instance.new("Frame")
    lib.TeleportFrame.Name = "TeleportFrame"
    lib.TeleportFrame.Size = UDim2.new(0, 350, 0, 450)
    lib.TeleportFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    lib.TeleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    lib.TeleportFrame.BorderSizePixel = 0
    lib.TeleportFrame.Visible = false
    lib.TeleportFrame.ZIndex = 100
    lib.TeleportFrame.Parent = lib.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = lib.TeleportFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 90)
    stroke.Thickness = 2
    stroke.Parent = lib.TeleportFrame
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(1, 0, 0, 50)
    titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = lib.TeleportFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "📍 TELEPORT TO PLAYER"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0.5, -20)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    lib.TeleportPlayersFrame = Instance.new("ScrollingFrame")
    lib.TeleportPlayersFrame.Name = "TeleportPlayersFrame"
    lib.TeleportPlayersFrame.Size = UDim2.new(1, -20, 1, -120)
    lib.TeleportPlayersFrame.Position = UDim2.new(0, 10, 0, 60)
    lib.TeleportPlayersFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    lib.TeleportPlayersFrame.BorderSizePixel = 0
    lib.TeleportPlayersFrame.ScrollBarThickness = 6
    lib.TeleportPlayersFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    lib.TeleportPlayersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    lib.TeleportPlayersFrame.Parent = lib.TeleportFrame
    
    local playersCorner = Instance.new("UICorner")
    playersCorner.CornerRadius = UDim.new(0, 8)
    playersCorner.Parent = lib.TeleportPlayersFrame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Name = "RefreshButton"
    refreshBtn.Size = UDim2.new(0, 120, 0, 40)
    refreshBtn.Position = UDim2.new(0, 20, 1, -55)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "🔄 REFRESH"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 14
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = lib.TeleportFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn
    
    refreshBtn.MouseButton1Click:Connect(function()
        lib.UpdateTeleportPlayersList()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        lib.TeleportFrame.Visible = false
    end)
end

lib.OpenTeleportMenu = function()
    if not lib.TeleportFrame then
        lib.CreateTeleportMenu()
    end
    
    lib.TeleportFrame.Visible = true
    lib.UpdateTeleportPlayersList()
end

-- ============================================
-- GAME STATE CHECKERS
-- ============================================

lib.MapLoaded = false
lib.GameStarted = false

lib.CheckMapLoaded = function()
    local mapFolders = {"Generators", "Generator", "Pallets", "Pallet", "Exit", "Doors", "GameArea", "Map"}
    for _, folderName in ipairs(mapFolders) do
        if Workspace:FindFirstChild(folderName) then
            return true
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lib.LocalPlayer then
            local role = lib.GetPlayerRole(player)
            if role ~= "Spectator" and role ~= "Unknown" then
                return true
            end
        end
    end
    
    return false
end

lib.CheckGameStarted = function()
    local hasKiller = false
    local hasSurvivor = false
    local totalPlayers = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lib.LocalPlayer then
            local role = lib.GetPlayerRole(player)
            if role == "Killer" then
                hasKiller = true
                totalPlayers = totalPlayers + 1
            elseif role == "Survivor" then
                hasSurvivor = true
                totalPlayers = totalPlayers + 1
            end
        end
    end
    
    return (hasKiller and hasSurvivor) or (totalPlayers >= 2 and lib.MapLoaded)
end

lib.OnGameStateChanged = function()
    if not lib.GameStarted then
        lib.ClearAllESP()
    elseif lib.ESPEnabled then
        lib.ForceUpdateAllESP()
    end
end

lib.StartGameCheckers = function()
    spawn(function()
        while true do
            wait(3)
            
            local mapLoaded = lib.CheckMapLoaded()
            if mapLoaded ~= lib.MapLoaded then
                lib.MapLoaded = mapLoaded
                print("Map state changed: " .. tostring(lib.MapLoaded))
            end
            
            local gameStarted = lib.CheckGameStarted()
            if gameStarted ~= lib.GameStarted then
                lib.GameStarted = gameStarted
                print("Game state changed: " .. tostring(lib.GameStarted))
                lib._cache.roleCache = {}
                lib.OnGameStateChanged()
            end
        end
    end)
end

lib.ForceUpdateAllESP = function()
    if not lib.ESPEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lib.LocalPlayer and not lib.IsPlayerSpectator(player) then
            lib.CreateESP(player)
        end
    end
end

-- ============================================
-- CREATE UI
-- ============================================

lib.ScreenGui = Instance.new("ScreenGui")
lib.ScreenGui.Name = "IkaxzuHub"
lib.ScreenGui.ResetOnSpawn = false
lib.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn then
    syn.protect_gui(lib.ScreenGui)
    lib.ScreenGui.Parent = CoreGui
else
    lib.ScreenGui.Parent = CoreGui
end

-- Main Frame
lib.MainFrame = Instance.new("Frame")
lib.MainFrame.Name = "MainFrame"
lib.MainFrame.Size = UDim2.new(0, 550, 0, 650)
lib.MainFrame.Position = UDim2.new(0.025, 0, 0.05, 0)
lib.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
lib.MainFrame.BorderSizePixel = 0
lib.MainFrame.Active = true
lib.MainFrame.Parent = lib.ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = lib.MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 100, 255)
mainStroke.Thickness = 3
mainStroke.Parent = lib.MainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = lib.MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

-- Logo
local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 40, 0, 40)
logoImg.Position = UDim2.new(0, 10, 0.5, -20)
logoImg.BackgroundTransparency = 1
logoImg.Image = "https://files.catbox.moe/8h7dgs.jpg"
logoImg.Parent = titleBar

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logoImg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ IKAXZU HUB"
title.TextColor3 = Color3.fromRGB(100, 100, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -52, 0.5, -22.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.white
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Tab System
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 45)
tabContainer.Position = UDim2.new(0, 0, 0, 60)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = lib.MainFrame

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 5)
tabList.Parent = tabContainer

local tabNames = {"ESP", "COLORS", "FEATURES", "VISUAL", "AIMBOT"}
local tabButtons = {}
local tabFrames = {}

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -125)
contentFrame.Position = UDim2.new(0, 10, 0, 115)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = lib.MainFrame

-- Create Tabs
for i, tabName in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(0.2, -4, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.white
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tabName .. "Frame"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 6
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Visible = (i == 1)
    tabFrame.Parent = contentFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 10)
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

tabButtons["ESP"].BackgroundColor3 = Color3.fromRGB(100, 100, 255)

-- ============================================
-- UI CREATION FUNCTIONS
-- ============================================

lib.CreateToggle = function(text, default, callback, parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -70, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.white
    toggleLabel.TextSize = 16
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 19, 0, 19)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -9.5)
    toggleCircle.BackgroundColor3 = Color3.white
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local enabled = default or false
    
    if enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        toggleCircle.Position = UDim2.new(1, -22, 0.5, -9.5)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if enabled then
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -22, 0.5, -9.5)}):Play()
        else
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9.5)}):Play()
        end
        
        callback(enabled)
    end)
    
    return toggleFrame
end

lib.CreateSlider = function(text, min, max, default, callback, parent)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 65)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -20, 0, 25)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. default
    sliderLabel.TextColor3 = Color3.white
    sliderLabel.TextSize = 14
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -20, 0, 10)
    sliderBack.Position = UDim2.new(0, 10, 1, -20)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = input.UserInputType == Enum.UserInputType.Touch and input.Position.X or UserInputService:GetMouseLocation().X
            local sliderPos = sliderBack.AbsolutePosition.X
            local sliderSize = sliderBack.AbsoluteSize.X
            
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local finalValue = math.floor(min + (max - min) * value)
            
            sliderFill.Size = UDim2.new(value, 0, 1, 0)
            sliderLabel.Text = text .. ": " .. finalValue
            
            callback(finalValue)
        end
    end)
    
    return sliderFrame
end

lib.CreateButton = function(text, callback, parent)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, 0, 0, 50)
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
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 80, 200)}):Play()
        wait(0.1)
        TweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
        callback()
    end)
    
    return buttonFrame
end

lib.CreateColorPicker = function(text, defaultColor, callback, parent)
    local colorFrame = Instance.new("Frame")
    colorFrame.Size = UDim2.new(1, 0, 0, 50)
    colorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    colorFrame.BorderSizePixel = 0
    colorFrame.Parent = parent
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 10)
    colorCorner.Parent = colorFrame
    
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(1, -70, 1, 0)
    colorLabel.Position = UDim2.new(0, 15, 0, 0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = text
    colorLabel.TextColor3 = Color3.white
    colorLabel.TextSize = 16
    colorLabel.Font = Enum.Font.Gotham
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left
    colorLabel.Parent = colorFrame
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(0, 40, 0, 30)
    colorDisplay.Position = UDim2.new(1, -50, 0.5, -15)
    colorDisplay.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255)
    colorDisplay.BorderSizePixel = 0
    colorDisplay.Parent = colorFrame
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 8)
    displayCorner.Parent = colorDisplay
    
    -- Simple color picker (cycle through preset colors on click)
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(128, 0, 128)
    }
    
    local currentIndex = 1
    
    colorDisplay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            currentIndex = currentIndex + 1
            if currentIndex > #colors then currentIndex = 1 end
            
            colorDisplay.BackgroundColor3 = colors[currentIndex]
            callback(colors[currentIndex])
        end
    end)
    
    return colorFrame
end

-- Crosshair
lib.CrosshairFrame = Instance.new("Frame")
lib.CrosshairFrame.Name = "Crosshair"
lib.CrosshairFrame.Size = UDim2.new(0, 20, 0, 20)
lib.CrosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -10)
lib.CrosshairFrame.BackgroundTransparency = 1
lib.CrosshairFrame.Visible = false
lib.CrosshairFrame.ZIndex = 10
lib.CrosshairFrame.Parent = lib.ScreenGui

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

-- Aimbot FOV Circle
lib.AimbotFOVCircle = Instance.new("Frame")
lib.AimbotFOVCircle.Name = "AimbotFOV"
lib.AimbotFOVCircle.Size = UDim2.new(0, 100, 0, 100)
lib.AimbotFOVCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
lib.AimbotFOVCircle.BackgroundTransparency = 0.8
lib.AimbotFOVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lib.AimbotFOVCircle.BorderSizePixel = 0
lib.AimbotFOVCircle.Visible = false
lib.AimbotFOVCircle.ZIndex = 5
lib.AimbotFOVCircle.Parent = lib.ScreenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = lib.AimbotFOVCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 2
fovStroke.Transparency = 0.5
fovStroke.Parent = lib.AimbotFOVCircle

-- ============================================
-- TOGGLE CALLBACKS
-- ============================================

lib.ToggleESP = function(state)
    lib.ESPEnabled = state
    
    if state then
        print("ESP Players: ENABLED")
        lib.ForceUpdateAllESP()
        
        lib.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(newPlayer)
            wait(3)
            if not lib.IsPlayerSpectator(newPlayer) then
                lib.CreateESP(newPlayer)
            end
        end)
        
        Players.PlayerRemoving:Connect(function(leavingPlayer)
            lib.RemoveESP(leavingPlayer)
        end)
        
        if lib.RGBESPEnabled then
            lib.StartRGBESP()
        end
        
        if lib.SuperESPEnabled then
            lib.StartSuperESP()
        end
    else
        print("ESP Players: DISABLED")
        lib.ClearAllESP()
        
        if lib.Connections.PlayerAdded then
            lib.Connections.PlayerAdded:Disconnect()
            lib.Connections.PlayerAdded = nil
        end
        
        lib.StopRGBESP()
        lib.StopSuperESP()
    end
end

lib.ToggleGeneratorESP = function(state)
    lib.GeneratorESPEnabled = state
    
    if state then
        lib.FindAndCreateGenerators()
        print("ESP Generators: ENABLED")
        
        if lib.SuperESPEnabled then
            lib.StartSuperESP()
        end
    else
        lib.ObjectESPManager:ClearAll()
        print("ESP Generators: DISABLED")
    end
end

lib.TogglePalletESP = function(state)
    lib.PalletESPEnabled = state
    
    if state then
        lib.FindAndCreatePallets()
        print("ESP Pallets: ENABLED")
        
        if lib.SuperESPEnabled then
            lib.StartSuperESP()
        end
    else
        lib.ObjectESPManager:ClearAll()
        print("ESP Pallets: DISABLED")
    end
end

lib.ToggleRGBESP = function(state)
    lib.RGBESPEnabled = state
    
    if state then
        lib.StartRGBESP()
        print("RGB ESP: ENABLED")
    else
        lib.StopRGBESP()
        lib.KillerColor = Color3.fromRGB(255, 0, 0)
        lib.SurvivorColor = Color3.fromRGB(0, 255, 0)
        lib.UpdateESP()
        print("RGB ESP: DISABLED")
    end
end

lib.UpdateRGBESPSpeed = function(value)
    lib.RGBESPSpeed = value
    print("RGB ESP Speed: " .. value)
end

lib.ToggleSuperESP = function(state)
    lib.SuperESPEnabled = state
    
    if state then
        lib.StartSuperESP()
        print("Super ESP: ENABLED")
    else
        lib.StopSuperESP()
        print("Super ESP: DISABLED")
    end
end

lib.UpdateSuperESPSpeed = function(value)
    lib.SuperESPSpeed = value
    print("Super ESP Speed: " .. value)
end

lib.ToggleWalkSpeed = function(state)
    lib.walkSpeedActive = state
    
    if state then
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = lib.walkSpeed
            end
        end
        print("Walk Speed: ENABLED (" .. lib.walkSpeed .. ")")
    else
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        print("Walk Speed: DISABLED")
    end
end

lib.UpdateWalkSpeedValue = function(value)
    lib.walkSpeed = value
    if lib.walkSpeedActive then
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
    print("Walk Speed Value: " .. value)
end

lib.ToggleJumpPower = function(state)
    lib.JumpPowerEnabled = state
    
    if state then
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = lib.JumpPowerValue
            end
        end
        print("Jump Power: ENABLED (" .. lib.JumpPowerValue .. ")")
    else
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
        end
        print("Jump Power: DISABLED")
    end
end

lib.UpdateJumpPowerValue = function(value)
    lib.JumpPowerValue = value
    if lib.JumpPowerEnabled then
        local character = lib.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
    print("Jump Power Value: " .. value)
end

lib.ToggleFly = function(state)
    lib.FlyEnabled = state
    
    if state then
        lib.StartFly()
        print("Fly: ENABLED")
    else
        lib.StopFly()
        print("Fly: DISABLED")
    end
end

lib.UpdateFlySpeed = function(value)
    lib.FlySpeedValue = value
    print("Fly Speed: " .. value)
end

lib.ToggleNoclip = function(state)
    lib.NoclipEnabled = state
    
    if state then
        lib.StartNoclip()
        print("Noclip: ENABLED")
    else
        lib.StopNoclip()
        print("Noclip: DISABLED")
    end
end

lib.ToggleGodMode = function(state)
    lib.GodModeEnabled = state
    
    if state then
        lib.StartGodMode()
        print("God Mode: ENABLED")
    else
        lib.StopGodMode()
        print("God Mode: DISABLED")
    end
end

lib.ToggleInvisible = function(state)
    lib.InvisibleEnabled = state
    print("Invisible: " .. (state and "ENABLED" or "DISABLED") .. " (Placeholder)")
end

lib.ToggleAntiStun = function(state)
    lib.AntiStunEnabled = state
    
    if state then
        lib.StartAntiStun()
        print("Anti Stun: ENABLED")
    else
        lib.StopAntiStun()
        print("Anti Stun: DISABLED")
    end
end

lib.ToggleAntiGrab = function(state)
    lib.AntiGrabEnabled = state
    
    if state then
        lib.StartAntiGrab()
        print("Anti Grab: ENABLED")
    else
        lib.StopAntiGrab()
        print("Anti Grab: DISABLED")
    end
end

lib.ToggleMaxEscapeChance = function(state)
    lib.MaxEscapeChanceEnabled = state
    
    if state then
        lib.StartEscapeChance()
        print("100% Escape Chance: ENABLED")
    else
        lib.StopEscapeChance()
        print("100% Escape Chance: DISABLED")
    end
end

lib.ToggleGrabKiller = function(state)
    lib.GrabKillerEnabled = state
    
    if state then
        lib.StartGrabKiller()
        print("Grab Killer: ENABLED")
    else
        lib.StopGrabKiller()
        print("Grab Killer: DISABLED")
    end
end

lib.ToggleRapidFire = function(state)
    lib.RapidFireEnabled = state
    
    if state then
        lib.StartRapidFire()
        print("Rapid Fire: ENABLED")
    else
        lib.StopRapidFire()
        print("Rapid Fire: DISABLED")
    end
end

lib.ToggleDisableTwistAnimations = function(state)
    lib.DisableTwistAnimationsEnabled = state
    
    if state then
        lib.StartDisableTwistAnimations()
        print("Disable Twist Animations: ENABLED")
    else
        lib.StopDisableTwistAnimations()
        print("Disable Twist Animations: DISABLED")
    end
end

lib.ToggleRotatePerson = function(state)
    lib.RotatePersonEnabled = state
    
    if state then
        lib.StartRotatePerson()
        print("Rotate Person: ENABLED")
    else
        lib.StopRotatePerson()
        print("Rotate Person: DISABLED")
    end
end

lib.UpdateRotateSpeed = function(value)
    lib.RotateSpeed = value
    print("Rotate Speed: " .. value)
end

lib.ToggleNoFog = function(state)
    lib.NoFogEnabled = state
    
    if state then
        lib.StartNoFog()
        print("No Fog: ENABLED")
    else
        lib.StopNoFog()
        print("No Fog: DISABLED")
    end
end

lib.ToggleTime = function(state)
    lib.TimeEnabled = state
    
    if state then
        lib.StartCustomTime()
        print("Custom Time: ENABLED")
    else
        lib.StopCustomTime()
        print("Custom Time: DISABLED")
    end
end

lib.UpdateTimeValue = function(value)
    lib.TimeValue = value
    if lib.TimeEnabled then
        Lighting.ClockTime = value
    end
    print("Time Value: " .. value)
end

lib.ToggleMapColor = function(state)
    lib.MapColorEnabled = state
    
    if state then
        lib.StartMapColor()
        print("Map Color: ENABLED")
    else
        lib.StopMapColor()
        print("Map Color: DISABLED")
    end
end

lib.UpdateMapColor = function(color)
    lib.MapColor = color
    if lib.MapColorEnabled then
        Lighting.Ambient = color
        Lighting.OutdoorAmbient = color
    end
end

lib.UpdateMapSaturation = function(value)
    lib.MapColorSaturation = value
    if lib.MapColorEnabled then
        if not Lighting:FindFirstChild("ColorCorrection") then
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "ColorCorrection"
            cc.Saturation = value
            cc.Parent = Lighting
        else
            Lighting.ColorCorrection.Saturation = value
        end
    end
end

lib.ToggleCrosshair = function(state)
    lib.CrosshairEnabled = state
    lib.CrosshairFrame.Visible = state
    print("Crosshair: " .. (state and "ENABLED" or "DISABLED"))
end

lib.ToggleAimbot = function(state)
    lib.AimbotEnabled = state
    lib.AimbotFunctions.updateAimbotUI()
    
    if state then
        lib.StartAimbot()
        print("Aimbot: ENABLED")
    else
        lib.StopAimbot()
        print("Aimbot: DISABLED")
    end
end

lib.UpdateAimbotFOV = function(value)
    lib.AimbotFOV = value
    lib.AimbotFunctions.updateAimbotUI()
    print("Aimbot FOV: " .. value)
end

lib.UpdateAimbotSmoothness = function(value)
    lib.AimbotSmoothness = value
    print("Aimbot Smoothness: " .. value)
end

lib.ToggleAimbotTeamCheck = function(state)
    lib.AimbotTeamCheck = state
    print("Aimbot Team Check: " .. (state and "ENABLED" or "DISABLED"))
end

lib.ToggleAimbotVisibleCheck = function(state)
    lib.AimbotVisibleCheck = state
    print("Aimbot Visible Check: " .. (state and "ENABLED" or "DISABLED"))
end

lib.ToggleAimbotWallCheck = function(state)
    lib.AimbotWallCheck = state
    print("Aimbot Wall Check: " .. (state and "ENABLED" or "DISABLED"))
end

-- ============================================
-- CREATE UI ELEMENTS
-- ============================================

-- ESP Tab
lib.CreateToggle("👁️ ESP Players", false, lib.ToggleESP, tabFrames["ESP"])
lib.CreateToggle("⚡ ESP Generators", false, lib.ToggleGeneratorESP, tabFrames["ESP"])
lib.CreateToggle("📦 ESP Pallets", false, lib.TogglePalletESP, tabFrames["ESP"])
lib.CreateToggle("🌈 RGB ESP", false, lib.ToggleRGBESP, tabFrames["ESP"])
lib.CreateSlider("RGB Speed", 0.1, 5, 1, lib.UpdateRGBESPSpeed, tabFrames["ESP"])
lib.CreateToggle("✨ Super ESP", false, lib.ToggleSuperESP, tabFrames["ESP"])
lib.CreateSlider("Super ESP Speed", 0.1, 5, 1, lib.UpdateSuperESPSpeed, tabFrames["ESP"])

-- Colors Tab
lib.CreateColorPicker("🔴 Killer Color", lib.KillerColor, function(color)
    lib.KillerColor = color
    if lib.ESPEnabled then
        wait(0.1)
        lib.UpdateESP()
    end
end, tabFrames["COLORS"])

lib.CreateColorPicker("🟢 Survivor Color", lib.SurvivorColor, function(color)
    lib.SurvivorColor = color
    if lib.ESPEnabled then
        wait(0.1)
        lib.UpdateESP()
    end
end, tabFrames["COLORS"])

lib.CreateColorPicker("🟡 Generator Color", lib.GeneratorColor, function(color)
    lib.GeneratorColor = color
    if lib.GeneratorESPEnabled then
        lib.UpdateGeneratorESP()
    end
end, tabFrames["COLORS"])

lib.CreateColorPicker("🟠 Pallet Color", lib.PalletColor, function(color)
    lib.PalletColor = color
    if lib.PalletESPEnabled then
        lib.UpdatePalletESP()
    end
end, tabFrames["COLORS"])

-- Features Tab
lib.CreateToggle("🏃 Walk Speed", false, lib.ToggleWalkSpeed, tabFrames["FEATURES"])
lib.CreateSlider("Walk Speed", 16, 500, 16, lib.UpdateWalkSpeedValue, tabFrames["FEATURES"])
lib.CreateToggle("🦘 Jump Power", false, lib.ToggleJumpPower, tabFrames["FEATURES"])
lib.CreateSlider("Jump Power", 50, 500, 50, lib.UpdateJumpPowerValue, tabFrames["FEATURES"])
lib.CreateToggle("✈️ Fly", false, lib.ToggleFly, tabFrames["FEATURES"])
lib.CreateSlider("Fly Speed", 50, 500, 50, lib.UpdateFlySpeed, tabFrames["FEATURES"])
lib.CreateToggle("👻 Noclip", false, lib.ToggleNoclip, tabFrames["FEATURES"])
lib.CreateToggle("⭐ God Mode", false, lib.ToggleGodMode, tabFrames["FEATURES"])
lib.CreateToggle("🛡️ Anti Stun", false, lib.ToggleAntiStun, tabFrames["FEATURES"])
lib.CreateToggle("🚫 Anti Grab", false, lib.ToggleAntiGrab, tabFrames["FEATURES"])
lib.CreateToggle("💯 100% Escape", false, lib.ToggleMaxEscapeChance, tabFrames["FEATURES"])
lib.CreateToggle("🤜 Grab Killer", false, lib.ToggleGrabKiller, tabFrames["FEATURES"])
lib.CreateToggle("⚡ Rapid Fire", false, lib.ToggleRapidFire, tabFrames["FEATURES"])
lib.CreateToggle("🚫 Disable Twist Anim", false, lib.ToggleDisableTwistAnimations, tabFrames["FEATURES"])
lib.CreateToggle("🔄 Rotate Person", false, lib.ToggleRotatePerson, tabFrames["FEATURES"])
lib.CreateSlider("Rotate Speed", 1, 1000, 100, lib.UpdateRotateSpeed, tabFrames["FEATURES"])
lib.CreateButton("📍 Teleport to Player", lib.OpenTeleportMenu, tabFrames["FEATURES"])

-- Visual Tab
lib.CreateToggle("🌫️ No Fog", false, lib.ToggleNoFog, tabFrames["VISUAL"])
lib.CreateToggle("🕐 Custom Time", false, lib.ToggleTime, tabFrames["VISUAL"])
lib.CreateSlider("Time Value", 0, 24, 12, lib.UpdateTimeValue, tabFrames["VISUAL"])
lib.CreateToggle("🎨 Map Color", false, lib.ToggleMapColor, tabFrames["VISUAL"])
lib.CreateColorPicker("Map Color", lib.MapColor, lib.UpdateMapColor, tabFrames["VISUAL"])
lib.CreateSlider("Saturation", -1, 2, 1, lib.UpdateMapSaturation, tabFrames["VISUAL"])
lib.CreateToggle("➕ Crosshair", false, lib.ToggleCrosshair, tabFrames["VISUAL"])
lib.CreateToggle("👁️ Third Person (Killer)", false, lib.ToggleThirdPerson, tabFrames["VISUAL"])

-- Aimbot Tab
lib.CreateToggle("🎯 Aimbot", false, lib.ToggleAimbot, tabFrames["AIMBOT"])
lib.CreateSlider("Aimbot FOV", 10, 200, 50, lib.UpdateAimbotFOV, tabFrames["AIMBOT"])
lib.CreateSlider("Smoothness", 1, 100, 10, lib.UpdateAimbotSmoothness, tabFrames["AIMBOT"])
lib.CreateToggle("👥 Team Check (Killer)", true, lib.ToggleAimbotTeamCheck, tabFrames["AIMBOT"])
lib.CreateToggle("👁️ Visible Check", true, lib.ToggleAimbotVisibleCheck, tabFrames["AIMBOT"])
lib.CreateToggle("🧱 Wall Check", false, lib.ToggleAimbotWallCheck, tabFrames["AIMBOT"])

-- ============================================
-- FLOATING MENU BUTTON
-- ============================================

lib.FloatingButton = Instance.new("ImageButton")
lib.FloatingButton.Name = "MenuButton"
lib.FloatingButton.Size = UDim2.new(0, 70, 0, 70)
lib.FloatingButton.Position = UDim2.new(0, 20, 1, -90)
lib.FloatingButton.Image = "https://files.catbox.moe/8h7dgs.jpg"
lib.FloatingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
lib.FloatingButton.BorderSizePixel = 0
lib.FloatingButton.ZIndex = 1000
lib.FloatingButton.Parent = lib.ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = lib.FloatingButton

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = Color3.fromRGB(255, 255, 255)
floatStroke.Thickness = 3
floatStroke.Parent = lib.FloatingButton

-- Make draggable
local dragToggle = nil
local dragSpeed = 0.25
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(lib.FloatingButton, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

lib.FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = lib.FloatingButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

lib.FloatingButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then
        updateInput(input)
    end
end)

-- Menu toggle
lib.MenuOpen = true

lib.ToggleMenu = function()
    lib.MenuOpen = not lib.MenuOpen
    local targetPos = lib.MenuOpen and UDim2.new(0.025, 0, 0.05, 0) or UDim2.new(-1, 0, 0.05, 0)
    local tween = TweenService:Create(lib.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
        {Position = targetPos})
    tween:Play()
    print("Menu: " .. (lib.MenuOpen and "OPENED" or "CLOSED"))
end

lib.FloatingButton.MouseButton1Click:Connect(function()
    lib.ToggleMenu()
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    lib.ToggleMenu()
end)

-- ============================================
-- MOVEMENT UPDATER
-- ============================================

RunService.RenderStepped:Connect(function()
    if lib.LocalPlayer.Character then
        local humanoid = lib.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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

-- ============================================
-- INITIAL SETUP & NOTIFICATION (LANJUTAN)
-- ============================================

-- Notification
local Notification = Instance.new("Frame")
Notification.Name = "Notification"
Notification.Size = UDim2.new(0, 350, 0, 100)
Notification.Position = UDim2.new(0.5, -175, 0, -150)
Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Notification.BorderSizePixel = 0
Notification.ZIndex = 1001
Notification.Parent = lib.ScreenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 15)
notifCorner.Parent = Notification

local notifStroke = Instance.new("UIStroke")
notifStroke.Color = Color3.fromRGB(100, 100, 255)
notifStroke.Thickness = 3
notifStroke.Parent = Notification

local notifTitle = Instance.new("TextLabel")
notifTitle.Size = UDim2.new(1, 0, 0, 40)
notifTitle.BackgroundTransparency = 1
notifTitle.Text = "⚡ IKAXZU HUB LOADED"
notifTitle.TextColor3 = Color3.fromRGB(100, 100, 255)
notifTitle.TextSize = 20
notifTitle.Font = Enum.Font.GothamBold
notifTitle.Parent = Notification

local notifDesc = Instance.new("TextLabel")
notifDesc.Size = UDim2.new(1, 0, 1, -40)
notifDesc.Position = UDim2.new(0, 0, 0, 40)
notifDesc.BackgroundTransparency = 1
notifDesc.Text = "Tap the button to open menu\nAll features ready!"
notifDesc.TextColor3 = Color3.white
notifDesc.TextSize = 14
notifDesc.Font = Enum.Font.Gotham
notifDesc.Parent = Notification

-- Animate notification
local notifTween = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Position = UDim2.new(0.5, -175, 0, 20)})
notifTween:Play()

spawn(function()
    wait(5)
    local hideTween = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Position = UDim2.new(0.5, -175, 0, -150)})
    hideTween:Play()
    hideTween.Completed:Connect(function()
        Notification:Destroy()
    end)
end)

-- Start game checkers
lib.StartGameCheckers()

-- Auto-refresh teleport list
spawn(function()
    while true do
        wait(5)
        if lib.TeleportFrame and lib.TeleportFrame.Visible then
            lib.UpdateTeleportPlayersList()
        end
    end
end)

-- Character respawn handler
lib.LocalPlayer.CharacterAdded:Connect(function(character)
    lib.Character = character
    lib.Humanoid = character:WaitForChild("Humanoid")
    lib.RootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings
    wait(1)
    
    if lib.walkSpeedActive then
        lib.Humanoid.WalkSpeed = lib.walkSpeed
    end
    
    if lib.JumpPowerEnabled then
        lib.Humanoid.JumpPower = lib.JumpPowerValue
    end
    
    if lib.FlyEnabled then
        lib.StopFly()
        wait(0.5)
        lib.StartFly()
    end
    
    if lib.NoclipEnabled then
        lib.StartNoclip()
    end
    
    if lib.GodModeEnabled then
        lib.StartGodMode()
    end
end)

-- ============================================
-- CONSOLE OUTPUT
-- ============================================

print("=" .. string.rep("=", 60) .. "=")
print("           ⚡ IKAXZU HUB - VIOLENCE DISTRICT ULTIMATE ⚡")
print("=" .. string.rep("=", 60) .. "=")
print("")
print("✅ STATUS: LOADED SUCCESSFULLY")
print("🔑 KEY: " .. CORRECT_KEY)
print("📱 PLATFORM: " .. (UserInputService.TouchEnabled and "MOBILE" or "PC"))
print("")
print("=" .. string.rep("=", 60) .. "=")
print("                          🎮 CONTROLS")
print("=" .. string.rep("=", 60) .. "=")
print("• TAP/CLICK the icon button to open/close menu")
print("• DRAG the icon to move it anywhere")
print("• DRAG the menu title bar to reposition")
print("• TAP toggles to enable/disable features")
print("• SLIDE with finger/mouse to adjust values")
print("• TAP color boxes to cycle through colors")
print("")
print("=" .. string.rep("=", 60) .. "=")
print("                       ⚡ FEATURES INCLUDED")
print("=" .. string.rep("=", 60) .. "=")
print("")
print("【 ESP 】")
print("  ✓ ESP Players (Killer/Survivor)")
print("  ✓ ESP Generators")
print("  ✓ ESP Pallets")
print("  ✓ RGB ESP (Rainbow effect)")
print("  ✓ Super ESP (Pulsing effect)")
print("")
print("【 COLORS 】")
print("  ✓ Customizable Killer Color")
print("  ✓ Customizable Survivor Color")
print("  ✓ Customizable Generator Color")
print("  ✓ Customizable Pallet Color")
print("")
print("【 MOVEMENT 】")
print("  ✓ Walk Speed (16-500)")
print("  ✓ Jump Power (50-500)")
print("  ✓ Fly Mode with speed control")
print("  ✓ Noclip (walk through walls)")
print("")
print("【 COMBAT 】")
print("  ✓ God Mode (infinite health)")
print("  ✓ Anti Stun (no stun effects)")
print("  ✓ Anti Grab (escape from killer)")
print("  ✓ 100% Escape Chance")
print("  ✓ Grab Killer (reverse grab)")
print("  ✓ Rapid Fire (no cooldown)")
print("  ✓ Disable Twist Animations")
print("  ✓ Rotate Person (spin character)")
print("")
print("【 VISUAL 】")
print("  ✓ No Fog (clear visibility)")
print("  ✓ Custom Time (0-24 hours)")
print("  ✓ Map Color changer")
print("  ✓ Saturation control")
print("  ✓ Crosshair overlay")
print("  ✓ Third Person View (Killer only)")
print("")
print("【 AIMBOT 】")
print("  ✓ Full Aimbot system")
print("  ✓ FOV Circle (adjustable)")
print("  ✓ Smoothness control")
print("  ✓ Team Check (target killers only)")
print("  ✓ Visible Check (only visible targets)")
print("  ✓ Wall Check (ignore walls)")
print("")
print("【 TELEPORT 】")
print("  ✓ Teleport to any player")
print("  ✓ Auto-refresh player list")
print("  ✓ Shows player roles (Killer/Survivor)")
print("")
print("=" .. string.rep("=", 60) .. "=")
print("                      📌 IMPORTANT NOTES")
print("=" .. string.rep("=", 60) .. "=")
print("• This script is MOBILE & PC compatible")
print("• All features work on both platforms")
print("• Some features are game-specific")
print("• Use responsibly - don't ruin others' fun")
print("• Script updates automatically on rejoin")
print("")
print("=" .. string.rep("=", 60) .. "=")
print("                    🎯 QUICK START GUIDE")
print("=" .. string.rep("=", 60) .. "=")
print("1. Tap the icon button in bottom-left corner")
print("2. Navigate through tabs: ESP, COLORS, FEATURES, VISUAL, AIMBOT")
print("3. Enable features you want with toggles")
print("4. Adjust sliders for custom values")
print("5. Change colors by tapping color boxes")
print("6. Use Teleport button in FEATURES tab")
print("")
print("=" .. string.rep("=", 60) .. "=")
print("              ✨ Developed by IKAXZU - Enjoy! ✨")
print("=" .. string.rep("=", 60) .. "=")
print("")
print("🎮 Script fully initialized and ready to use!")
print("📱 Touch the icon to get started!")
print("")

-- ============================================
-- FINAL TOUCHES
-- ============================================

-- Auto-update ESP on player join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(2)
        if lib.ESPEnabled and not lib.IsPlayerSpectator(player) then
            lib.CreateESP(player)
        end
    end)
end)

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
    lib.RemoveESP(player)
    if lib._cache.roleCache[player.UserId] then
        lib._cache.roleCache[player.UserId] = nil
    end
end)

-- Mobile optimization
if UserInputService.TouchEnabled then
    -- Increase button sizes for better touch response
    for _, tabButton in pairs(tabButtons) do
        tabButton.TextSize = 16
    end
    
    -- Make floating button slightly bigger on mobile
    lib.FloatingButton.Size = UDim2.new(0, 80, 0, 80)
end

-- Performance optimization
spawn(function()
    while true do
        wait(10)
        -- Clear old cache entries
        for userId, data in pairs(lib._cache.roleCache) do
            if tick() - data.time > 30 then
                lib._cache.roleCache[userId] = nil
            end
        end
    end
end)

-- Success sound (optional)
local successSound = Instance.new("Sound")
successSound.SoundId = "rbxassetid://6026984224"
successSound.Volume = 0.5
successSound.Parent = game:GetService("SoundService")
successSound:Play()
spawn(function()
    wait(2)
    successSound:Destroy()
end)

-- ============================================
-- SCRIPT END
-- ============================================

return lib
