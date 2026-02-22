-- IKAXZU HUB V2 - Violence District
-- Key: ikaxzu
-- Stabil, Ringan, UI Mantap

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Windows = {
    Center = Fluent:CreateWindow({
        Title = "IKAXZU HUB V2 | Violence District",
        SubTitle = "by ikaz_pinter",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
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

    local HomeStats = Tabs.Home:AddSection("Player Stats")
    
    HomeStats:AddButton({
        Title = "Refresh Stats",
        Description = "Lihat statistik player",
        Callback = function()
            Fluent:Notify({
                Title = "Player Stats",
                Content = string.format("Health: %s | Walkspeed: %s", 
                    math.floor(player.Character.Humanoid.Health),
                    math.floor(player.Character.Humanoid.WalkSpeed)),
                Duration = 3
            })
        end
    })

    -- ===== COMBAT TAB =====
    local CombatSection = Tabs.Combat:AddSection("Aimbot Settings")
    
    local aimState = false
    CombatSection:AddToggle("AutoAim", {
        Title = "Auto Aim",
        Description = "Auto aim ke player terdekat (range 20 studs)",
        Default = false,
        Callback = function(state)
            aimState = state
            if state then
                spawn(function()
                    while aimState do
                        task.wait()
                        local target = getClosestPlayer(20)
                        if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
                        end
                    end
                end)
            end
        end
    })

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
                        task.wait(0.3)
                        local target = getClosestPlayer(20)
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

    local followState = false
    CombatSection:AddToggle("AutoFollow", {
        Title = "Auto Follow",
        Description = "Mengikuti player terdekat",
        Default = false,
        Callback = function(state)
            followState = state
            if state then
                spawn(function()
                    while followState do
                        task.wait(0.1)
                        local target = getClosestPlayer(50)
                        if target and player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
                        end
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

    local gravityValue = 196.2
    MovementSection:AddSlider("GravitySlider", {
        Title = "Gravity",
        Description = "Atur gravitasi dunia",
        Default = 196.2,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(value)
            gravityValue = value
            workspace.Gravity = value
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
            if selectedPlayer then
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

    TeleportSection:AddButton({
        Title = "Safe Zone",
        Description = "Teleport ke safe zone",
        Callback = function()
            local safeZone = CFrame.new(100, 50, 100)
            player.Character.HumanoidRootPart.CFrame = safeZone
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
                            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                                createESP(v)
                            end
                        end
                    end
                    
                    -- Cleanup
                    for _, v in pairs(Players:GetPlayers()) do
                        if v.Character and v.Character:FindFirstChild("ESP_Box") then
                            v.Character.ESP_Box:Destroy()
                        end
                    end
                end)
            end
        end
    })

    ESPSection:AddToggle("TracerToggle", {
        Title = "Tracers",
        Description = "Garis ke player",
        Default = false,
        Callback = function(state)
            tracerState = state
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
        Content = "2.0.0 - Stabil & Ringan"
    })
    
    AboutSection:AddParagraph({
        Title = "Description",
        Content = "Script khusus untuk Violence District dengan performa optimal"
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

    -- Add Interface Manager
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("IKAXZU_V2")
    SaveManager:SetFolder("IKAXZU_V2/ViolenceDistrict")
    
    InterfaceManager:BuildInterfaceSection(Tabs.About)
    SaveManager:BuildConfigSection(Tabs.About)

    Windows.Center:SelectTab(1)
    
    Fluent:Notify({
        Title = "IKAXZU HUB V2",
        Content = "Script loaded successfully!",
        Duration = 3
    })
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
        esp.Size = target.Character.HumanoidRootPart.Size * 2.5
        esp.Transparency = 0.5
        esp.Color3 = Color3.new(1, 0, 0)
        esp.AlwaysOnTop = true
        esp.ZIndex = 5
        esp.Parent = target.Character.HumanoidRootPart
    end
end

-- Tambahkan Tracer logic di sini
local tracerState = false
RunService.RenderStepped:Connect(function()
    if tracerState then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                -- Tracer drawing logic
            end
        end
    end
end)

-- Update player list setiap 5 detik
spawn(function()
    while true do
        task.wait(5)
        if Windows.Center and Tabs and Tabs.Teleport then
            -- Update dropdown player list
        end
    end
end)
