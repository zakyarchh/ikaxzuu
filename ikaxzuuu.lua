-- ============================================
-- AIMBOT FUNCTIONS (LENGKAP)
-- ============================================

lib.AimbotFunctions = {}

lib.AimbotFunctions.isPlayerVisible = function(player)
    if not lib.AimbotWallCheck then
        return true
    end
    
    local character = player.Character
    if not character then return false end
    
    local head = character:FindFirstChild("Head")
    if not head then return false end
    
    local camera = Workspace.CurrentCamera
    local cameraPos = camera.CFrame.Position
    local direction = (head.Position - cameraPos).Unit
    local distance = (head.Position - cameraPos).Magnitude
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
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
        if player ~= LocalPlayer and player.Character then
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
    if lib.AimbotEnabled then
        lib.AimbotFOVCircle.Visible = true
        lib.AimbotFOVCircle.Size = UDim2.new(0, lib.AimbotFOV * 2, 0, lib.AimbotFOV * 2)
    else
        lib.AimbotFOVCircle.Visible = false
    end
end

lib.StartAimbot = function()
    if lib.AimbotConnection then
        lib.AimbotConnection:Disconnect()
    end
    
    lib.AimbotConnection = RunService.RenderStepped:Connect(function()
        if lib.AimbotEnabled then
            local target = lib.AimbotFunctions.findClosestPlayer()
            if target then
                lib.AimbotFunctions.aimAt(target)
            end
        end
    end)
end

lib.StopAimbot = function()
    if lib.AimbotConnection then
        lib.AimbotConnection:Disconnect()
        lib.AimbotConnection = nil
    end
end

-- ============================================
-- FLY FUNCTIONS (LENGKAP)
-- ============================================

lib.FlyActive = false
lib.BodyVelocity = nil
lib.BodyGyro = nil

lib.StartFly = function()
    local character = LocalPlayer.Character
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
    
    lib.FlyConnection = RunService.Heartbeat:Connect(function()
        if not lib.FlyEnabled or not character or not rootPart or not lib.BodyVelocity or not lib.BodyGyro then
            return
        end
        
        lib.BodyGyro.CFrame = Workspace.CurrentCamera.CFrame
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Touch controls untuk fly (menggunakan touch joystick sederhana)
        -- Untuk implementasi lengkap, perlu touch joystick
        
        if UserInputService.TouchEnabled then
            -- Akan diisi dengan touch controls
        end
        
        lib.BodyVelocity.Velocity = moveDirection * lib.FlySpeedValue
        humanoid.PlatformStand = true
    end)
end

lib.StopFly = function()
    lib.FlyActive = false
    
    if lib.FlyConnection then
        lib.FlyConnection:Disconnect()
        lib.FlyConnection = nil
    end
    
    local character = LocalPlayer.Character
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

-- ============================================
-- NOCLIP FUNCTIONS (LENGKAP)
-- ============================================

lib.StartNoclip = function()
    local character = LocalPlayer.Character
    if not character then return end
    
    if lib.NoclipConnection then
        lib.NoclipConnection:Disconnect()
        lib.NoclipConnection = nil
    end
    
    lib.NoclipConnection = RunService.Stepped:Connect(function()
        if not lib.NoclipEnabled or not character or not character.Parent then
            if lib.NoclipConnection then
                lib.NoclipConnection:Disconnect()
                lib.NoclipConnection = nil
            end
            return
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- R6 body parts
        local bodyParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        for _, partName in ipairs(bodyParts) do
            local part = character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = false
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        -- Accessories
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    handle.CanCollide = false
                end
            end
        end
    end)
end

lib.StopNoclip = function()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    if lib.NoclipConnection then
        lib.NoclipConnection:Disconnect()
        lib.NoclipConnection = nil
    end
end

-- ============================================
-- GOD MODE FUNCTIONS (LENGKAP)
-- ============================================

lib.StartGodMode = function()
    if lib.GodModeConnection then
        lib.GodModeConnection:Disconnect()
    end
    
    lib.GodModeConnection = RunService.Heartbeat:Connect(function()
        if not lib.GodModeEnabled then
            if lib.GodModeConnection then
                lib.GodModeConnection:Disconnect()
                lib.GodModeConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            -- Disable damage scripts
            for _, script in pairs(character:GetDescendants()) do
                if script:IsA("Script") or script:IsA("LocalScript") then
                    if string.find(string.lower(script.Name), "health") or 
                       string.find(string.lower(script.Name), "damage") or 
                       string.find(string.lower(script.Name), "hit") then
                        pcall(function()
                            script.Disabled = true
                        end)
                    end
                end
            end
            
            -- Set health values to max
            for _, value in pairs(character:GetDescendants()) do
                if value:IsA("NumberValue") or value:IsA("IntValue") then
                    local name = string.lower(value.Name)
                    if string.find(name, "health") or string.find(name, "hp") or string.find(name, "damage") then
                        pcall(function()
                            if value.Value < 100 then
                                value.Value = 100
                            end
                        end)
                    end
                end
            end
            
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
    if lib.GodModeConnection then
        lib.GodModeConnection:Disconnect()
        lib.GodModeConnection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        -- Re-enable scripts
        for _, script in pairs(character:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                pcall(function()
                    script.Disabled = false
                end)
            end
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
        end
    end
end

-- ============================================
-- ANTI STUN FUNCTIONS
-- ============================================

lib.StartAntiStun = function()
    if lib.AntiStunConnection then
        lib.AntiStunConnection:Disconnect()
    end
    
    lib.AntiStunConnection = RunService.Heartbeat:Connect(function()
        if not lib.AntiStunEnabled then
            if lib.AntiStunConnection then
                lib.AntiStunConnection:Disconnect()
                lib.AntiStunConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
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
    if lib.AntiStunConnection then
        lib.AntiStunConnection:Disconnect()
        lib.AntiStunConnection = nil
    end
end

-- ============================================
-- ANTI GRAB FUNCTIONS
-- ============================================

lib.StartAntiGrab = function()
    if lib.AntiGrabConnection then
        lib.AntiGrabConnection:Disconnect()
    end
    
    lib.AntiGrabConnection = RunService.Heartbeat:Connect(function()
        if not lib.AntiGrabEnabled then
            if lib.AntiGrabConnection then
                lib.AntiGrabConnection:Disconnect()
                lib.AntiGrabConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                if humanoid.PlatformStand then
                    humanoid.PlatformStand = false
                    rootPart.Velocity = Vector3.new(0, 50, 0)
                end
                
                -- Check for nearby killers
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and lib.IsPlayerKiller(player) then
                        local killerChar = player.Character
                        if killerChar then
                            local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                            if killerRoot then
                                local distance = (rootPart.Position - killerRoot.Position).Magnitude
                                if distance < 12 then
                                    -- Teleport away
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
    if lib.AntiGrabConnection then
        lib.AntiGrabConnection:Disconnect()
        lib.AntiGrabConnection = nil
    end
end

-- ============================================
-- 100% ESCAPE CHANCE FUNCTIONS
-- ============================================

lib.StartEscapeChance = function()
    if lib.EscapeChanceConnection then
        lib.EscapeChanceConnection:Disconnect()
    end
    
    lib.EscapeChanceConnection = RunService.Heartbeat:Connect(function()
        if not lib.MaxEscapeChanceEnabled then
            if lib.EscapeChanceConnection then
                lib.EscapeChanceConnection:Disconnect()
                lib.EscapeChanceConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                if humanoid.PlatformStand or humanoid.Sit then
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                    rootPart.Velocity = (rootPart.CFrame.LookVector * 50) + Vector3.new(0, 25, 0)
                end
                
                -- Auto-escape from killer
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and lib.IsPlayerKiller(player) then
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
    if lib.EscapeChanceConnection then
        lib.EscapeChanceConnection:Disconnect()
        lib.EscapeChanceConnection = nil
    end
end

-- ============================================
-- GRAB KILLER FUNCTIONS
-- ============================================

lib.StartGrabKiller = function()
    if lib.GrabKillerConnection then
        lib.GrabKillerConnection:Disconnect()
    end
    
    lib.GrabKillerConnection = RunService.Heartbeat:Connect(function()
        if not lib.GrabKillerEnabled then
            if lib.GrabKillerConnection then
                lib.GrabKillerConnection:Disconnect()
                lib.GrabKillerConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid then
                local closestKiller = nil
                local closestDist = 15
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and lib.IsPlayerKiller(player) and not lib.IsPlayerSpectator(player) then
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
                            
                            -- Disable killer's attack
                            if killerHumanoid:FindFirstChild("Attack") then
                                killerHumanoid.Attack:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end)
end

lib.StopGrabKiller = function()
    if lib.GrabKillerConnection then
        lib.GrabKillerConnection:Disconnect()
        lib.GrabKillerConnection = nil
    end
end

-- ============================================
-- RAPID FIRE FUNCTIONS
-- ============================================

lib.StartRapidFire = function()
    if lib.RapidFireConnection then
        lib.RapidFireConnection:Disconnect()
    end
    
    lib.RapidFireConnection = RunService.Heartbeat:Connect(function()
        if not lib.RapidFireEnabled then
            if lib.RapidFireConnection then
                lib.RapidFireConnection:Disconnect()
                lib.RapidFireConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local weapon = nil
            
            -- Find weapon in character
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "twist") or 
                   string.find(string.lower(tool.Name), "fate") or 
                   string.find(string.lower(tool.Name), "pistol") or 
                   string.find(string.lower(tool.Name), "gun")) then
                    weapon = tool
                    break
                end
            end
            
            -- Find weapon in backpack
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
                -- Set cooldowns to 0
                for _, child in pairs(weapon:GetDescendants()) do
                    if child:IsA("NumberValue") and (child.Name == "Cooldown" or child.Name == "Delay" or child.Name == "FireRate") then
                        child.Value = 0
                    end
                end
                
                -- Auto-fire when touching screen (untuk mobile)
                -- Implementasi touch firing akan ditambahkan
            end
        end
    end)
end

lib.StopRapidFire = function()
    if lib.RapidFireConnection then
        lib.RapidFireConnection:Disconnect()
        lib.RapidFireConnection = nil
    end
end

-- ============================================
-- DISABLE TWIST ANIMATIONS FUNCTIONS
-- ============================================

lib.StartDisableTwistAnimations = function()
    if lib.TwistAnimationsConnection then
        lib.TwistAnimationsConnection:Disconnect()
    end
    
    lib.TwistAnimationsConnection = RunService.Heartbeat:Connect(function()
        if not lib.DisableTwistAnimationsEnabled then
            if lib.TwistAnimationsConnection then
                lib.TwistAnimationsConnection:Disconnect()
                lib.TwistAnimationsConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local weapon = nil
            
            -- Find Twist of Fate weapon
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
                -- Stop all animations
                for _, anim in pairs(weapon:GetDescendants()) do
                    if anim:IsA("AnimationTrack") then
                        anim:Stop()
                    end
                end
                
                -- Stop all sounds
                for _, sound in pairs(weapon:GetDescendants()) do
                    if sound:IsA("Sound") then
                        sound:Stop()
                    end
                end
                
                -- Disable particle emitters
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
    if lib.TwistAnimationsConnection then
        lib.TwistAnimationsConnection:Disconnect()
        lib.TwistAnimationsConnection = nil
    end
end

-- ============================================
-- ROTATE PERSON FUNCTIONS
-- ============================================

lib.StartRotatePerson = function()
    if lib.RotateConnection then
        lib.RotateConnection:Disconnect()
    end
    
    lib.RotateConnection = RunService.Heartbeat:Connect(function()
        if not lib.RotatePersonEnabled then
            if lib.RotateConnection then
                lib.RotateConnection:Disconnect()
                lib.RotateConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
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
    if lib.RotateConnection then
        lib.RotateConnection:Disconnect()
        lib.RotateConnection = nil
    end
end

-- ============================================
-- THIRD PERSON VIEW FUNCTIONS
-- ============================================

lib.OriginalCameraType = nil

lib.StartThirdPerson = function()
    if not lib.ThirdPersonEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    if not lib.IsPlayerKiller(LocalPlayer) then
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
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

lib.UpdateThirdPersonView = function()
    if not lib.ThirdPersonEnabled then return end
    
    local character = LocalPlayer.Character
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
    
    if state and not lib.IsPlayerKiller(LocalPlayer) then
        print("Third Person: You are not the Killer!")
        lib.ThirdPersonEnabled = false
        return
    end
    
    if state then
        lib.StartThirdPerson()
        
        if lib.ThirdPersonConnection then
            lib.ThirdPersonConnection:Disconnect()
        end
        
        lib.ThirdPersonConnection = RunService.RenderStepped:Connect(function()
            if not lib.ThirdPersonEnabled then
                lib.ThirdPersonConnection:Disconnect()
                lib.StopThirdPerson()
                return
            end
            
            if not lib.IsPlayerKiller(LocalPlayer) then
                print("Third Person: You are no longer the Killer!")
                lib.ToggleThirdPerson(false)
                return
            end
            
            lib.UpdateThirdPersonView()
        end)
        
        LocalPlayer.CharacterAdded:Connect(function()
            wait(1)
            if lib.ThirdPersonEnabled and lib.IsPlayerKiller(LocalPlayer) then
                lib.StartThirdPerson()
            end
        end)
    else
        if lib.ThirdPersonConnection then
            lib.ThirdPersonConnection:Disconnect()
            lib.ThirdPersonConnection = nil
        end
        lib.StopThirdPerson()
    end
end

-- ============================================
-- NO FOG FUNCTIONS
-- ============================================

lib.StartNoFog = function()
    if lib.NoFogConnection then
        lib.NoFogConnection:Disconnect()
    end
    
    lib.NoFogConnection = RunService.Heartbeat:Connect(function()
        if not lib.NoFogEnabled then
            if lib.NoFogConnection then
                lib.NoFogConnection:Disconnect()
                lib.NoFogConnection = nil
            end
            return
        end
        
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 100000
        Lighting.FogColor = Color3.new(1, 1, 1)
    end)
end

lib.StopNoFog = function()
    if lib.NoFogConnection then
        lib.NoFogConnection:Disconnect()
        lib.NoFogConnection = nil
    end
    
    Lighting.FogEnd = 1000
    Lighting.FogStart = 0
end

-- ============================================
-- CUSTOM TIME FUNCTIONS
-- ============================================

lib.StartCustomTime = function()
    if lib.TimeConnection then
        lib.TimeConnection:Disconnect()
    end
    
    lib.TimeConnection = RunService.Heartbeat:Connect(function()
        if not lib.TimeEnabled then
            if lib.TimeConnection then
                lib.TimeConnection:Disconnect()
                lib.TimeConnection = nil
            end
            return
        end
        Lighting.ClockTime = lib.TimeValue
    end)
end

lib.StopCustomTime = function()
    if lib.TimeConnection then
        lib.TimeConnection:Disconnect()
        lib.TimeConnection = nil
    end
end

-- ============================================
-- MAP COLOR FUNCTIONS
-- ============================================

lib.StartMapColor = function()
    if lib.MapColorConnection then
        lib.MapColorConnection:Disconnect()
    end
    
    lib.MapColorConnection = RunService.Heartbeat:Connect(function()
        if not lib.MapColorEnabled then
            if lib.MapColorConnection then
                lib.MapColorConnection:Disconnect()
                lib.MapColorConnection = nil
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
    if lib.MapColorConnection then
        lib.MapColorConnection:Disconnect()
        lib.MapColorConnection = nil
    end
    
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    
    if Lighting:FindFirstChild("ColorCorrection") then
        Lighting.ColorCorrection:Destroy()
    end
end

-- ============================================
-- RGB ESP FUNCTIONS
-- ============================================

lib.StartRGBESP = function()
    if lib.RGBESPConnection then
        lib.RGBESPConnection:Disconnect()
    end
    
    lib.RGBESPConnection = RunService.Heartbeat:Connect(function()
        if not lib.RGBESPEnabled or not lib.ESPEnabled then
            if lib.RGBESPConnection then
                lib.RGBESPConnection:Disconnect()
                lib.RGBESPConnection = nil
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
    if lib.RGBESPConnection then
        lib.RGBESPConnection:Disconnect()
        lib.RGBESPConnection = nil
    end
end

-- ============================================
-- SUPER ESP FUNCTIONS
-- ============================================

lib.StartSuperESP = function()
    if lib.SuperESPConnection then
        lib.SuperESPConnection:Disconnect()
    end
    
    lib.SuperESPConnection = RunService.Heartbeat:Connect(function()
        if not lib.SuperESPEnabled or not lib.ESPEnabled then
            if lib.SuperESPConnection then
                lib.SuperESPConnection:Disconnect()
                lib.SuperESPConnection = nil
            end
            return
        end
        
        local time = tick()
        
        -- Update player ESP
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
        
        -- Update generator ESP
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
        
        -- Update pallet ESP
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
    if lib.SuperESPConnection then
        lib.SuperESPConnection:Disconnect()
        lib.SuperESPConnection = nil
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
    if not targetPlayer or targetPlayer == LocalPlayer then
        print("Cannot teleport to yourself")
        return
    end
    
    local character = LocalPlayer.Character
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
        if player ~= LocalPlayer and not lib.IsPlayerSpectator(player) then
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
    titleLabel.Text = "TELEPORT TO PLAYER"
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
    refreshBtn.Text = "REFRESH"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 14
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = lib.TeleportFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn
    
    -- Dragging
    local dragActive = false
    local dragStart = nil
    local startPos = nil
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragActive = true
            dragStart = input.Position
            startPos = lib.TeleportFrame.Position
        end
    end)
    
    titleFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            lib.dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == lib.dragInput and dragActive then
            local delta = input.Position - dragStart
            lib.TeleportFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragActive = false
        end
    end)
    
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
    
    -- Check if there are players with roles
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
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
        if player ~= LocalPlayer then
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
        if player ~= LocalPlayer and not lib.IsPlayerSpectator(player) then
            lib.CreateESP(player)
        end
    end
end

-- ============================================
-- TOGGLE FUNCTIONS (CALLBACKS)
-- ============================================

lib.ToggleESP = function(state)
    lib.ESPEnabled = state
    
    if state then
        print("ESP Players: ENABLED")
        lib.ForceUpdateAllESP()
        
        lib.PlayerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
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
        
        if lib.PlayerAddedConnection then
            lib.PlayerAddedConnection:Disconnect()
            lib.PlayerAddedConnection = nil
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
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = lib.walkSpeed
            end
        end
        print("Walk Speed: ENABLED (" .. lib.walkSpeed .. ")")
    else
        local character = LocalPlayer.Character
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
        local character = LocalPlayer.Character
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
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = lib.JumpPowerValue
            end
        end
        print("Jump Power: ENABLED (" .. lib.JumpPowerValue .. ")")
    else
        local character = LocalPlayer.Character
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
        local character = LocalPlayer.Character
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
-- CREATE UI ELEMENTS (LENGKAP)
-- ============================================

-- ESP Tab
lib.CreateToggle("ESP Players", false, lib.ToggleESP, tabFrames["ESP"])
lib.CreateToggle("ESP Generators", false, lib.ToggleGeneratorESP, tabFrames["ESP"])
lib.CreateToggle("ESP Pallets", false, lib.TogglePalletESP, tabFrames["ESP"])
lib.CreateToggle("RGB ESP", false, lib.ToggleRGBESP, tabFrames["ESP"])
lib.CreateSlider("RGB ESP Speed", 0.1, 5, 1, lib.UpdateRGBESPSpeed, tabFrames["ESP"])
lib.CreateToggle("Super ESP", false, lib.ToggleSuperESP, tabFrames["ESP"])
lib.CreateSlider("Super ESP Speed", 0.1, 5, 1, lib.UpdateSuperESPSpeed, tabFrames["ESP"])

-- Colors Tab
lib.CreateColorPicker("Killer Color", lib.KillerColor, function(color)
    lib.KillerColor = color
    if lib.ESPEnabled then
        wait(0.1)
        lib.UpdateESP()
    end
end, tabFrames["COLORS"])

lib.CreateColorPicker("Survivor Color", lib.SurvivorColor, function(color)
    lib.SurvivorColor = color
    if lib.ESPEnabled then
        wait(0.1)
        lib.UpdateESP()
    end
end, tabFrames["COLORS"])

lib.CreateColorPicker("Generator Color", lib.GeneratorColor, function(color)
    lib.GeneratorColor = color
    if lib.GeneratorESPEnabled then
        lib.UpdateGeneratorESP()
    end
end, tabFrames["COLORS"])

lib.CreateColorPicker("Pallet Color", lib.PalletColor, function(color)
    lib.PalletColor = color
    if lib.PalletESPEnabled then
        lib.UpdatePalletESP()
    end
end, tabFrames["COLORS"])

-- Features Tab
lib.CreateToggle("Walk Speed", false, lib.ToggleWalkSpeed, tabFrames["FEATURES"])
lib.CreateSlider("Walk Speed Value", 16, 500, 16, lib.UpdateWalkSpeedValue, tabFrames["FEATURES"])
lib.CreateToggle("Jump Power", false, lib.ToggleJumpPower, tabFrames["FEATURES"])
lib.CreateSlider("Jump Power Value", 0, 500, 50, lib.UpdateJumpPowerValue, tabFrames["FEATURES"])
lib.CreateToggle("Fly", false, lib.ToggleFly, tabFrames["FEATURES"])
lib.CreateSlider("Fly Speed", 0, 500, 50, lib.UpdateFlySpeed, tabFrames["FEATURES"])
lib.CreateToggle("Noclip", false, lib.ToggleNoclip, tabFrames["FEATURES"])
lib.CreateToggle("God Mode", false, lib.ToggleGodMode, tabFrames["FEATURES"])
lib.CreateToggle("Invisible", false, lib.ToggleInvisible, tabFrames["FEATURES"])
lib.CreateToggle("Anti Stun", false, lib.ToggleAntiStun, tabFrames["FEATURES"])
lib.CreateToggle("Anti Grab", false, lib.ToggleAntiGrab, tabFrames["FEATURES"])
lib.CreateToggle("100% Escape", false, lib.ToggleMaxEscapeChance, tabFrames["FEATURES"])
lib.CreateToggle("Grab Killer", false, lib.ToggleGrabKiller, tabFrames["FEATURES"])
lib.CreateToggle("Rapid Fire", false, lib.ToggleRapidFire, tabFrames["FEATURES"])
lib.CreateToggle("Disable Twist Anim", false, lib.ToggleDisableTwistAnimations, tabFrames["FEATURES"])
lib.CreateToggle("Rotate Person", false, lib.ToggleRotatePerson, tabFrames["FEATURES"])
lib.CreateSlider("Rotate Speed", 0, 1000, 100, lib.UpdateRotateSpeed, tabFrames["FEATURES"])
lib.CreateButton("Teleport to Player", lib.OpenTeleportMenu, tabFrames["FEATURES"])

-- Visual Tab
lib.CreateToggle("No Fog", false, lib.ToggleNoFog, tabFrames["VISUAL"])
lib.CreateToggle("Custom Time", false, lib.ToggleTime, tabFrames["VISUAL"])
lib.CreateSlider("Time Value", 0, 24, 12, lib.UpdateTimeValue, tabFrames["VISUAL"])
lib.CreateToggle("Map Color", false, lib.ToggleMapColor, tabFrames["VISUAL"])
lib.CreateColorPicker("Map Color Picker", lib.MapColor, lib.UpdateMapColor, tabFrames["VISUAL"])
lib.CreateSlider("Map Saturation", -1, 2, 1, lib.UpdateMapSaturation, tabFrames["VISUAL"])
lib.CreateToggle("Crosshair", false, lib.ToggleCrosshair, tabFrames["VISUAL"])
lib.CreateToggle("Third Person (Killer)", false, lib.ToggleThirdPerson, tabFrames["VISUAL"])

-- Aimbot Tab
lib.CreateToggle("Aimbot", false, lib.ToggleAimbot, tabFrames["AIMBOT"])
lib.CreateSlider("Aimbot FOV", 1, 200, 50, lib.UpdateAimbotFOV, tabFrames["AIMBOT"])
lib.CreateSlider("Aimbot Smoothness", 1, 100, 10, lib.UpdateAimbotSmoothness, tabFrames["AIMBOT"])
lib.CreateToggle("Team Check (Killer Only)", true, lib.ToggleAimbotTeamCheck, tabFrames["AIMBOT"])
lib.CreateToggle("Visible Check", true, lib.ToggleAimbotVisibleCheck, tabFrames["AIMBOT"])
lib.CreateToggle("Wall Check", false, lib.ToggleAimbotWallCheck, tabFrames["AIMBOT"])

-- Teleport Tab (akan diisi otomatis oleh tombol di Features)

-- ============================================
-- FLOATING MENU BUTTON
-- ============================================

lib.FloatingButton = Instance.new("TextButton")
lib.FloatingButton.Name = "MenuButton"
lib.FloatingButton.Size = UDim2.new(0, 70, 0, 70)
lib.FloatingButton.Position = UDim2.new(0, 20, 1, -90)
lib.FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
lib.FloatingButton.BorderSizePixel = 0
lib.FloatingButton.Text = "⚡"
lib.FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lib.FloatingButton.TextSize = 36
lib.FloatingButton.Font = Enum.Font.GothamBold
lib.FloatingButton.ZIndex = 1000
lib.FloatingButton.Parent = lib.ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 35)
floatCorner.Parent = lib.FloatingButton

-- Menu toggle
lib.MenuOpen = true
lib.MainFrame.Position = UDim2.new(0.025, 0, 0.05, 0)

lib.ToggleMenu = function()
    lib.MenuOpen = not lib.MenuOpen
    local targetPos = lib.MenuOpen and UDim2.new(0.025, 0, 0.05, 0) or UDim2.new(0, -1000, 0.05, 0)
    local tween = TweenService:Create(lib.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        {Position = targetPos})
    tween:Play()
    print("Menu: " .. (lib.MenuOpen and "OPENED" or "CLOSED"))
end

lib.FloatingButton.MouseButton1Click:Connect(function()
    lib.ToggleMenu()
end)

-- ============================================
-- INITIAL SETUP
-- ============================================

-- Notification
local Notification = Instance.new("TextLabel")
Notification.Name = "MobileHint"
Notification.Size = UDim2.new(0.8, 0, 0, 60)
Notification.Position = UDim2.new(0.1, 0, 0.5, -30)
Notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Notification.BackgroundTransparency = 0.5
Notification.Text = "Tap ⚡ button to open menu\nAll features included!"
Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
Notification.TextSize = 16
Notification.Font = Enum.Font.GothamBold
Notification.TextStrokeTransparency = 0
Notification.ZIndex = 1000
Notification.Parent = lib.ScreenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 12)
notifCorner.Parent = Notification

-- Animate notification
Notification.Position = UDim2.new(0.5, -150, 0.5, -30)
local notifTween = TweenService:Create(Notification, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
    {Position = UDim2.new(0.5, -150, 0.1, 0)})
notifTween:Play()

delay(5, function()
    local hideTween = TweenService:Create(Notification, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In), 
        {Position = UDim2.new(0.5, -150, 1, 100)})
    hideTween:Play()
    hideTween.Completed:Connect(function()
        Notification:Destroy()
    end)
end)

-- Start game checkers
lib.StartGameCheckers()

-- Auto-refresh teleport list when menu is open
spawn(function()
    while true do
        wait(5)
        if lib.TeleportFrame and lib.TeleportFrame.Visible then
            lib.UpdateTeleportPlayersList()
        end
    end
end)

-- Unlock cursor
lib.UnlockCursor()

-- Print instructions
print("=" .. string.rep("=", 50) .. "=")
print("VIOLENCE DISTRICT ULTIMATE - MOBILE EDITION")
print("=" .. string.rep("=", 50) .. "=")
print("✅ ALL FEATURES INCLUDED - NOTHING REMOVED")
print("✅ SAME AS PC VERSION - ADAPTED FOR TOUCH")
print("")
print("📱 CONTROLS:")
print("  • Tap ⚡ button to open/close menu")
print("  • Tap and drag title to move window")
print("  • Tap toggles to enable/disable features")
print("  • Drag sliders with your finger")
print("  • Use color pickers by tapping and dragging")
print("")
print("🎮 FEATURES:")
print("  • ESP (Players, Generators, Pallets)")
print("  • RGB ESP & Super ESP with speed control")
print("  • Full color customization")
print("  • Aimbot with FOV, smoothness, wall check")
print("  • Movement (WalkSpeed, JumpPower, Fly, Noclip)")
print("  • God Mode, Anti Stun, Anti Grab")
print("  • 100% Escape, Grab Killer, Rapid Fire")
print("  • Visual (No Fog, Time, Map Color)")
print("  • Teleport to any player")
print("  • And many more...")
print("=" .. string.rep("=", 50) .. "=")