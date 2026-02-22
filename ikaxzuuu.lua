-- IKAXZU HUB V2 - Violence District
-- Key: ikaxzu
-- Fitur: Aimbot + Hitbox Besar

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Windows = {
    Center = Fluent:CreateWindow({
        Title = "IKAXZU HUB V2 | Violence District",
        SubTitle = "by ikaz_pinter (Aimbot + Hitbox)",
        TabWidth = 160,
        Size = UDim2.fromOffset(650, 500),
        Acrylic = true,
        Theme = "Dark"
    })
}

-- Variables Global
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- Aimbot Variables
local aimbotEnabled = false
local aimbotMode = "Camera" -- Camera, Silent, Mouse
local aimbotTarget = "Closest" -- Closest, Crosshair, LowestHP
local aimbotPart = "Head" -- Head, Torso, HumanoidRootPart
local aimbotFOV = 90
local aimbotSmoothness = 5
local aimbotShowFOV = false
local aimbotPrediction = false
local aimbotPredictionValue = 0.1
local aimbotVisibleCheck = true
local aimbotTeamCheck = false
local aimbotWallCheck = false
local aimbotKeybind = Enum.UserInputType.MouseButton2 -- Right click
local aimbotKeybindEnabled = false
local silentAimEnabled = false

-- Hitbox Variables
local hitboxState = false
local hitboxSize = 3
local headHitboxState = false
local allPartsState = false
local originalSizes = {}

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Key System
local Key = "ikaxzu"
local KeyInput = ""
local KeyValid = false

local KeyWindow = Fluent:CreateWindow({
    Title = "KEY SYSTEM",
    SubTitle = "Enter Key to Continue",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 200),
    Acrylic = true,
    Theme = "Dark"
})

local KeyTab = KeyWindow:AddTab({ Title = "Authentication" })
local KeySection = KeyTab:AddSection("Masukkan Key")

KeySection:AddInput("KeyInput", {
    Title = "Key",
    Default = "",
    Placeholder = "masukkan key...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        KeyInput = Value
    end
})

KeySection:AddButton({
    Title = "Submit Key",
    Description = "Klik setelah memasukkan key",
    Callback = function()
        if KeyInput == Key then
            KeyValid = true
            KeyWindow:Delete()
            CreateMainGUI()
        else
            Fluent:Notify({
                Title = "Key Invalid",
                Content = "Key yang dimasukkan salah!",
                Duration = 3
            })
        end
    end
})

-- Main GUI Function
function CreateMainGUI()
    -- Tabs
    local Tabs = {
        Home = Windows.Center:AddTab({ Title = "Home", Icon = "home" }),
        Aimbot = Windows.Center:AddTab({ Title = "Aimbot", Icon = "crosshair" }),
        Hitbox = Windows.Center:AddTab({ Title = "Hitbox", Icon = "target" }),
        Combat = Windows.Center:AddTab({ Title = "Combat", Icon = "swords" }),
        Movement = Windows.Center:AddTab({ Title = "Movement", Icon = "zap" }),
        Teleport = Windows.Center:AddTab({ Title = "Teleport", Icon = "map-pin" }),
        ESP = Windows.Center:AddTab({ Title = "ESP", Icon = "eye" }),
        About = Windows.Center:AddTab({ Title = "About", Icon = "info" })
    }

    -- ===== HOME TAB =====
    local HomeSection = Tabs.Home:AddSection("Player Info")
    
    HomeSection:AddButton({
        Title = "Copy Server ID",
        Description = "Salin ID server ke clipboard",
        Callback = function()
            setclipboard(game.JobId)
            Fluent:Notify({
                Title = "Success",
                Content = "Server ID copied!",
                Duration = 2
            })
        end
    })

    -- ===== AIMBOT TAB (BARU) =====
    local AimbotMain = Tabs.Aimbot:AddSection("Aimbot Settings")
    
    AimbotMain:AddToggle("AimbotEnabled", {
        Title = "Enable Aimbot",
        Description = "Aktifkan aimbot",
        Default = false,
        Callback = function(state)
            aimbotEnabled = state
            Fluent:Notify({
                Title = "Aimbot",
                Content = state and "Aimbot ACTIVE" or "Aimbot OFF",
                Duration = 1
            })
        end
    })
    
    AimbotMain:AddDropdown("AimbotMode", {
        Title = "Aimbot Mode",
        Description = "Cara aimbot bekerja",
        Values = {"Camera (Kamera Bergerak)", "Silent (Tidak Gerak Kamera)", "Mouse (Gerak Mouse)"},
        Multi = false,
        Default = 1,
        Callback = function(value)
            if value == "Camera (Kamera Bergerak)" then
                aimbotMode = "Camera"
                silentAimEnabled = false
            elseif value == "Silent (Tidak Gerak Kamera)" then
                aimbotMode = "Silent"
                silentAimEnabled = true
            elseif value == "Mouse (Gerak Mouse)" then
                aimbotMode = "Mouse"
                silentAimEnabled = false
            end
        end
    })
    
    AimbotMain:AddDropdown("AimbotTarget", {
        Title = "Target Selection",
        Description = "Prioritas target",
        Values = {"Closest (Terdekat)", "Crosshair (Tengah Layar)", "Lowest HP (HP Tersedikit)"},
        Multi = false,
        Default = 1,
        Callback = function(value)
            if value == "Closest (Terdekat)" then
                aimbotTarget = "Closest"
            elseif value == "Crosshair (Tengah Layar)" then
                aimbotTarget = "Crosshair"
            elseif value == "Lowest HP (HP Tersedikit)" then
                aimbotTarget = "LowestHP"
            end
        end
    })
    
    AimbotMain:AddDropdown("AimbotPart", {
        Title = "Target Body Part",
        Description = "Bagian tubuh yang diincar",
        Values = {"Head", "Torso", "HumanoidRootPart", "Random"},
        Multi = false,
        Default = 1,
        Callback = function(value)
            aimbotPart = value
        end
    })
    
    -- Aimbot FOV
    local AimbotFOV = Tabs.Aimbot:AddSection("Field of View")
    
    AimbotFOV:AddSlider("AimbotFOV", {
        Title = "FOV Size",
        Description = "Radius aimbot (0 = seluruh layar)",
        Default = 90,
        Min = 0,
        Max = 360,
        Rounding = 1,
        Callback = function(value)
            aimbotFOV = value
        end
    })
    
    AimbotFOV:AddToggle("ShowFOV", {
        Title = "Show FOV Circle",
        Description = "Tampilkan lingkaran FOV",
        Default = false,
        Callback = function(state)
            aimbotShowFOV = state
        end
    })
    
    -- Aimbot Smoothing
    local AimbotSmooth = Tabs.Aimbot:AddSection("Smoothing")
    
    AimbotSmooth:AddSlider("AimbotSmoothness", {
        Title = "Smoothness",
        Description = "Kehalusan aimbot (rendah = cepat, tinggi = halus)",
        Default = 5,
        Min = 1,
        Max = 20,
        Rounding = 1,
        Callback = function(value)
            aimbotSmoothness = value
        end
    })
    
    AimbotSmooth:AddToggle("AimbotPrediction", {
        Title = "Movement Prediction",
        Description = "Prediksi gerakan musuh",
        Default = false,
        Callback = function(state)
            aimbotPrediction = state
        end
    })
    
    AimbotSmooth:AddSlider("PredictionValue", {
        Title = "Prediction Amount",
        Description = "Seberapa jauh prediksi",
        Default = 0.1,
        Min = 0.05,
        Max = 0.5,
        Rounding = 2,
        Callback = function(value)
            aimbotPredictionValue = value
        end
    })
    
    -- Aimbot Advanced
    local AimbotAdvanced = Tabs.Aimbot:AddSection("Advanced")
    
    AimbotAdvanced:AddToggle("VisibleCheck", {
        Title = "Visible Check",
        Description = "Hanya target yang terlihat",
        Default = true,
        Callback = function(state)
            aimbotVisibleCheck = state
        end
    })
    
    AimbotAdvanced:AddToggle("WallCheck", {
        Title = "Wall Check",
        Description = "Cek apakah tertutup tembok",
        Default = false,
        Callback = function(state)
            aimbotWallCheck = state
        end
    })
    
    AimbotAdvanced:AddToggle("TeamCheck", {
        Title = "Team Check",
        Description = "Abaikan satu tim",
        Default = false,
        Callback = function(state)
            aimbotTeamCheck = state
        end
    })
    
    AimbotAdvanced:AddToggle("KeybindEnabled", {
        Title = "Hold Key to Aim",
        Description = "Aimbot aktif hanya saat tombol ditekan",
        Default = false,
        Callback = function(state)
            aimbotKeybindEnabled = state
        end
    })
    
    AimbotAdvanced:AddDropdown("AimbotKeybind", {
        Title = "Aimbot Key",
        Description = "Tombol untuk aimbot",
        Values = {"Right Click", "Left Click", "Q", "E", "Shift", "Ctrl", "X"},
        Multi = false,
        Default = 1,
        Callback = function(value)
            if value == "Right Click" then
                aimbotKeybind = Enum.UserInputType.MouseButton2
            elseif value == "Left Click" then
                aimbotKeybind = Enum.UserInputType.MouseButton1
            end
        end
    })

    -- ===== HITBOX TAB =====
    local HitboxSection = Tabs.Hitbox:AddSection("Hitbox Expander")
    
    HitboxSection:AddParagraph({
        Title = "⚠️ Info",
        Content = "Memperbesar ukuran tubuh lawan agar mudah terkena serangan"
    })
    
    HitboxSection:AddToggle("HitboxToggle", {
        Title = "Enable Hitbox Besar",
        Description = "Perbesar ukuran tubuh lawan",
        Default = false,
        Callback = function(state)
            hitboxState = state
            if state then
                spawn(function()
                    while hitboxState do
                        task.wait(0.5)
                        for _, v in pairs(Players:GetPlayers()) do
                            if v ~= player and v.Character then
                                expandHitbox(v, hitboxSize, headHitboxState, allPartsState)
                            end
                        end
                    end
                    
                    if not hitboxState then
                        for _, v in pairs(Players:GetPlayers()) do
                            if v ~= player and v.Character then
                                restoreHitbox(v)
                            end
                        end
                    end
                end)
            else
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        restoreHitbox(v)
                    end
                end
            end
        end
    })
    
    HitboxSection:AddSlider("HitboxSize", {
        Title = "Ukuran Hitbox",
        Description = "Semakin besar semakin mudah kena",
        Default = 3,
        Min = 1.5,
        Max = 10,
        Rounding = 1,
        Callback = function(value)
            hitboxSize = value
            if hitboxState then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        expandHitbox(v, hitboxSize, headHitboxState, allPartsState)
                    end
                end
            end
        end
    })
    
    HitboxSection:AddToggle("HeadHitbox", {
        Title = "Perbesar Head Hitbox",
        Description = "Bikin kepala lebih gede biar headshot gampang",
        Default = false,
        Callback = function(state)
            headHitboxState = state
            if hitboxState then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        expandHitbox(v, hitboxSize, headHitboxState, allPartsState)
                    end
                end
            end
        end
    })
    
    HitboxSection:AddToggle("AllParts", {
        Title = "Perbesar Semua Bagian Tubuh",
        Description = "Tangan, kaki, badan semuanya gede",
        Default = false,
        Callback = function(state)
            allPartsState = state
            if hitboxState then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        expandHitbox(v, hitboxSize, headHitboxState, allPartsState)
                    end
                end
            end
        end
    })

    -- ===== COMBAT TAB =====
    local CombatSection = Tabs.Combat:AddSection("Combat Settings")
    
    local hitState = false
    CombatSection:AddToggle("AutoHit", {
        Title = "Auto Hit",
        Description = "Otomatis menyerang player terdekat",
        Default = false,
        Callback = function(state)
            hitState = state
            if state then
                spawn(function()
                    while hitState do
                        task.wait(0.2)
                        local target = getClosestPlayer(25)
                        if target then
                            pcall(function()
                                local args = {
                                    [1] = "melee",
                                    [2] = target.Character.HumanoidRootPart.Position,
                                    [3] = target.Character.HumanoidRootPart
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Player"):WaitForChild("Attack"):FireServer(unpack(args))
                            end)
                        end
                    end
                end)
            end
        end
    })

    local blockState = false
    CombatSection:AddToggle("AutoBlock", {
        Title = "Auto Block/Parry",
        Description = "Otomatis memblokir serangan",
        Default = false,
        Callback = function(state)
            blockState = state
            if state then
                spawn(function()
                    while blockState do
                        task.wait(0.1)
                        pcall(function()
                            local args = { [1] = "block" }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Player"):WaitForChild("Block"):FireServer(unpack(args))
                        end)
                    end
                end)
            end
        end
    })

    -- ===== MOVEMENT TAB =====
    local MovementSection = Tabs.Movement:AddSection("Movement Settings")
    
    local speedValue = 16
    MovementSection:AddSlider("SpeedSlider", {
        Title = "Walkspeed",
        Description = "Atur kecepatan jalan",
        Default = 16,
        Min = 16,
        Max = 250,
        Rounding = 1,
        Callback = function(value)
            speedValue = value
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
        end
    })

    local jumpValue = 50
    MovementSection:AddSlider("JumpSlider", {
        Title = "Jump Power",
        Description = "Atur kekuatan lompat",
        Default = 50,
        Min = 50,
        Max = 500,
        Rounding = 1,
        Callback = function(value)
            jumpValue = value
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = value
            end
        end
    })

    local flyState = false
    local flyConnection
    MovementSection:AddToggle("FlyToggle", {
        Title = "Fly Mode",
        Description = "Terbang bebas",
        Default = false,
        Callback = function(state)
            flyState = state
            if state then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0,0,0)
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Parent = player.Character.HumanoidRootPart
                
                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
                bodyGyro.Parent = player.Character.HumanoidRootPart
                
                flyConnection = RunService.Stepped:Connect(function()
                    if flyState and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        bodyVelocity.Velocity = camera.CFrame.LookVector * 100
                        bodyGyro.CFrame = camera.CFrame
                    else
                        bodyVelocity:Destroy()
                        bodyGyro:Destroy()
                        if flyConnection then
                            flyConnection:Disconnect()
                        end
                    end
                end)
            end
        end
    })

    local noclipState = false
    local noclipConnection
    MovementSection:AddToggle("NoclipToggle", {
        Title = "Noclip",
        Description = "Tembus tembok",
        Default = false,
        Callback = function(state)
            noclipState = state
            if state then
                noclipConnection = RunService.Stepped:Connect(function()
                    if noclipState and player.Character then
                        for _, v in pairs(player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            elseif noclipConnection then
                noclipConnection:Disconnect()
            end
        end
    })

    -- ===== TELEPORT TAB =====
    local TeleportSection = Tabs.Teleport:AddSection("Teleport Options")
    
    local selectedPlayer = ""
    TeleportSection:AddDropdown("PlayerDropdown", {
        Title = "Pilih Player",
        Description = "Teleport ke player tertentu",
        Values = getPlayerNames(),
        Multi = false,
        Default = 1,
        Callback = function(value)
            selectedPlayer = value
        end
    })

    TeleportSection:AddButton({
        Title = "Teleport ke Player",
        Description = "Pindah ke player yang dipilih",
        Callback = function()
            if selectedPlayer and selectedPlayer ~= "" then
                local target = Players:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 2)
                    Fluent:Notify({
                        Title = "Teleported",
                        Content = "Ke " .. selectedPlayer,
                        Duration = 2
                    })
                end
            end
        end
    })

    TeleportSection:AddButton({
        Title = "Nearest Generator/ATM",
        Description = "Teleport ke generator terdekat",
        Callback = function()
            local nearest = findNearestObject({"Generator", "ATM", "Money", "Cash", "Bank"})
            if nearest then
                player.Character.HumanoidRootPart.CFrame = nearest.CFrame * CFrame.new(0, 3, 0)
                Fluent:Notify({
                    Title = "Teleported",
                    Content = "Ke " .. nearest.Name,
                    Duration = 2
                })
            end
        end
    })

    -- ===== ESP TAB =====
    local ESPSection = Tabs.ESP:AddSection("ESP Settings")
    
    local espState = false
    ESPSection:AddToggle("ESPToggle", {
        Title = "Player ESP",
        Description = "Lihat player melalui tembok",
        Default = false,
        Callback = function(state)
            espState = state
            if state then
                spawn(function()
                    while espState do
                        task.wait(0.1)
                        for _, v in pairs(Players:GetPlayers()) do
                            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                createESP(v)
                            end
                        end
                    end
                    
                    for _, v in pairs(Players:GetPlayers()) do
                        if v.Character and v.Character:FindFirstChild("ESP_Box") then
                            v.Character.ESP_Box:Destroy()
                        end
                    end
                end)
            else
                for _, v in pairs(Players:GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("ESP_Box") then
                        v.Character.ESP_Box:Destroy()
                    end
                end
            end
        end
    })

    -- ===== ABOUT TAB =====
    local AboutSection = Tabs.About:AddSection("IKAXZU HUB V2")
    
    AboutSection:AddParagraph({
        Title = "Creator",
        Content = "IKAXZU (ikaz_pinter)"
    })
    
    AboutSection:AddParagraph({
        Title = "Version",
        Content = "2.5.0 - Aimbot Pro + Hitbox"
    })
    
    AboutSection:AddParagraph({
        Title = "Fitur Unggulan",
        Content = "✅ Aimbot 3 Mode\n✅ Silent Aim\n✅ Hitbox Expander\n✅ Auto Hit & Block\n✅ ESP & Tracers"
    })

    local SocialSection = Tabs.About:AddSection("Social Media")
    
    SocialSection:AddButton({
        Title = "Instagram: ikaz_pinter",
        Description = "Klik untuk copy",
        Callback = function()
            setclipboard("ikaz_pinter")
            Fluent:Notify({
                Title = "Copied!",
                Content = "Instagram username copied!",
                Duration = 2
            })
        end
    })
    
    SocialSection:AddButton({
        Title = "TikTok: zakiacnh",
        Description = "Klik untuk copy",
        Callback = function()
            setclipboard("zakiacnh")
            Fluent:Notify({
                Title = "Copied!",
                Content = "TikTok username copied!",
                Duration = 2
            })
        end
    })

    Windows.Center:SelectTab(1)
    
    Fluent:Notify({
        Title = "IKAXZU HUB V2",
        Content = "Loaded dengan AIMBOT PRO!",
        Duration = 3
    })
end

-- AIMBOT FUNCTIONS
local function getAimbotTarget()
    local targets = {}
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            -- Team Check
            if aimbotTeamCheck and v.Team == player.Team then
                continue
            end
            
            -- Visible Check
            if aimbotVisibleCheck then
                local ray = Ray.new(camera.CFrame.Position, (v.Character.HumanoidRootPart.Position - camera.CFrame.Position).Unit * 1000)
                local hit, pos = workspace:FindPartOnRay(ray, player.Character)
                if hit and not hit:IsDescendantOf(v.Character) then
                    continue
                end
            end
            
            -- Wall Check
            if aimbotWallCheck then
                -- Implement wall check logic here
            end
            
            table.insert(targets, v)
        end
    end
    
    if #targets == 0 then return nil end
    
    if aimbotTarget == "Closest" then
        local closest = nil
        local shortest = math.huge
        for _, v in pairs(targets) do
            local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
        return closest
    elseif aimbotTarget == "Crosshair" then
        -- Get target closest to crosshair
        local best = nil
        local bestAngle = aimbotFOV
        for _, v in pairs(targets) do
            local pos = v.Character.HumanoidRootPart.Position
            local screenPos, onScreen = camera:WorldToViewportPoint(pos)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if distance < bestAngle then
                    bestAngle = distance
                    best = v
                end
            end
        end
        return best
    elseif aimbotTarget == "LowestHP" then
        local lowest = nil
        local hp = math.huge
        for _, v in pairs(targets) do
            if v.Character.Humanoid.Health < hp then
                hp = v.Character.Humanoid.Health
                lowest = v
            end
        end
        return lowest
    end
    
    return nil
end

local function getTargetPart(target)
    if not target or not target.Character then return nil end
    
    if aimbotPart == "Head" then
        return target.Character:FindFirstChild("Head")
    elseif aimbotPart == "Torso" then
        return target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("UpperTorso")
    elseif aimbotPart == "HumanoidRootPart" then
        return target.Character:FindFirstChild("HumanoidRootPart")
    elseif aimbotPart == "Random" then
        local parts = {"Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        local randomPart = parts[math.random(1, #parts)]
        return target.Character:FindFirstChild(randomPart)
    end
    
    return target.Character:FindFirstChild("HumanoidRootPart")
end

-- Aimbot Main Loop
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if aimbotShowFOV then
        -- Implement FOV circle drawing here (requires drawing library)
    end
    
    -- Aimbot Logic
    if aimbotEnabled then
        local shouldAim = true
        
        if aimbotKeybindEnabled then
            shouldAim = UserInputService:IsMouseButtonPressed(aimbotKeybind)
        end
        
        if shouldAim then
            local target = getAimbotTarget()
            if target then
                local targetPart = getTargetPart(target)
                if targetPart then
                    local targetPos = targetPart.Position
                    
                    -- Movement Prediction
                    if aimbotPrediction and target.Character.HumanoidRootPart then
                        local velocity = target.Character.HumanoidRootPart.Velocity
                        targetPos = targetPos + (velocity * aimbotPredictionValue)
                    end
                    
                    if aimbotMode == "Camera" then
                        -- Smooth Camera Aimbot
                        local lookAt = CFrame.lookAt(camera.CFrame.Position, targetPos)
                        camera.CFrame = camera.CFrame:Lerp(lookAt, 1/aimbotSmoothness)
                    elseif aimbotMode == "Silent" then
                        silentAimEnabled = true
                        -- Silent aim handled by hit detection
                    elseif aimbotMode == "Mouse" then
                        -- Mouse Aimbot
                        local screenPos = camera:WorldToViewportPoint(targetPos)
                        mousemove(screenPos.X, screenPos.Y)
                    end
                end
            end
        end
    end
end)

-- Silent Aim
local oldNamecall
if silentAimEnabled then
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" and self.Name == "Attack" and silentAimEnabled then
            local target = getAimbotTarget()
            if target and target.Character then
                local targetPart = getTargetPart(target)
                if targetPart then
                    args[2] = targetPart.Position
                    args[3] = targetPart
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
end

-- HITBOX FUNCTIONS
function expandHitbox(target, scale, expandHead, expandAll)
    if not target.Character then return end
    
    if not originalSizes[target.Name] then
        originalSizes[target.Name] = {}
    end
    
    local parts = {
        target.Character:FindFirstChild("HumanoidRootPart"),
        target.Character:FindFirstChild("Head"),
        target.Character:FindFirstChild("Torso"),
        target.Character:FindFirstChild("UpperTorso"),
        target.Character:FindFirstChild("LowerTorso")
    }
    
    if expandAll then
        table.insert(parts, target.Character:FindFirstChild("Left Arm"))
        table.insert(parts, target.Character:FindFirstChild("Right Arm"))
        table.insert(parts, target.Character:FindFirstChild("Left Leg"))
        table.insert(parts, target.Character:FindFirstChild("Right Leg"))
        table.insert(parts, target.Character:FindFirstChild("LeftHand"))
        table.insert(parts, target.Character:FindFirstChild("RightHand"))
        table.insert(parts, target.Character:FindFirstChild("LeftFoot"))
        table.insert(parts, target.Character:FindFirstChild("RightFoot"))
    end
    
    for _, part in pairs(parts) do
        if part then
            if not originalSizes[target.Name][part.Name] then
                originalSizes[target.Name][part.Name] = part.Size
            end
            
            local newSize = originalSizes[target.Name][part.Name] * scale
            
            if expandHead and part.Name == "Head" then
                newSize = newSize * 1.5
            end
            
            part.Size = newSize
            
            if part.Name == "Head" and part:FindFirstChildOfClass("SpecialMesh") then
                local mesh = part:FindFirstChildOfClass("SpecialMesh")
                mesh.Scale = mesh.Scale * scale
            end
        end
    end
end

function restoreHitbox(target)
    if not target.Character or not originalSizes[target.Name] then return end
    
    for partName, originalSize in pairs(originalSizes[target.Name]) do
        local part = target.Character:FindFirstChild(partName)
        if part then
            part.Size = originalSize
            
            if part.Name == "Head" and part:FindFirstChildOfClass("SpecialMesh") then
                local mesh = part:FindFirstChildOfClass("SpecialMesh")
                mesh.Scale = Vector3.new(1, 1, 1)
            end
        end
    end
    
    originalSizes[target.Name] = nil
end

-- Helper Functions
function getClosestPlayer(range)
    local closest = nil
    local shortest = range or math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

function getPlayerNames()
    local names = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            table.insert(names, v.Name)
        end
    end
    return names
end

function findNearestObject(objectNames)
    local nearest = nil
    local shortest = math.huge
    
    for _, objName in pairs(objectNames) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:find(objName) and obj:IsA("BasePart") then
                local dist = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

function createESP(target)
    if not target.Character:FindFirstChild("ESP_Box") then
        local esp = Instance.new("BoxHandleAdornment")
        esp.Name = "ESP_Box"
        esp.Adornee = target.Character.HumanoidRootPart
        esp.Size = target.Character.HumanoidRootPart.Size * 3
        esp.Transparency = 0.5
        esp.Color3 = Color3.new(1, 0, 0)
        esp.AlwaysOnTop = true
        esp.ZIndex = 5
        esp.Parent = target.Character.HumanoidRootPart
    end
end

-- Update player list
spawn(function()
    while true do
        task.wait(5)
        if Windows.Center and Tabs and Tabs.Teleport then
            -- Update logic
        end
    end
end)