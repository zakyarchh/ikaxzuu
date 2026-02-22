-- Script by IKAXZU for Violence District
-- Key: ikaxzu

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("IKAXZU HUB - Violence District", "DarkTheme")

-- Variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Anti AFK
local vu = game:GetService("VirtualUser")
player.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Key System
local Key = "ikaxzu"
local KeyInput = ""

local KeyWindow = Library.CreateLib("Key System", "DarkTheme")
local KeyTab = KeyWindow:NewTab("Key")
local KeySection = KeyTab:NewSection("Enter Key")

KeySection:NewTextBox("Key", "Enter the key", function(txt)
    KeyInput = txt
end)

KeySection:NewButton("Submit Key", function()
    if KeyInput == Key then
        KeyWindow:Destroy()
        Window = Library.CreateLib("IKAXZU HUB - Violence District", "DarkTheme")
        CreateTabs()
    else
        game.Players.LocalPlayer:Kick("Invalid Key!")
    end
end)

-- Main Functions
local function CreateTabs()
    -- Home Tab
    local HomeTab = Window:NewTab("Home")
    local HomeSection = HomeTab:NewSection("Player Settings")
    
    -- Speed
    HomeSection:NewSlider("Walkspeed", "Change walkspeed", 250, 16, function(v)
        player.Character.Humanoid.WalkSpeed = v
    end)
    
    -- Jump Power
    HomeSection:NewSlider("Jump Power", "Change jump height", 500, 50, function(v)
        player.Character.Humanoid.JumpPower = v
    end)
    
    -- Gravity
    HomeSection:NewSlider("Gravity", "Change gravity", 500, 196.2, function(v)
        game.Workspace.Gravity = v
    end)
    
    -- Fly
    HomeSection:NewToggle("Fly", "Enable fly", function(state)
        local flying = state
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.Parent = player.Character.HumanoidRootPart
        
        RunService.Stepped:Connect(function()
            if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                bodyVelocity.Velocity = camera.CFrame.LookVector * 100
                bodyGyro.CFrame = camera.CFrame
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end
        end)
    end)
    
    -- Noclip
    HomeSection:NewToggle("Noclip", "Walk through walls", function(state)
        local noclip = state
        RunService.Stepped:Connect(function()
            if noclip and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
    
    -- Server ID
    HomeSection:NewButton("Copy Server ID", "Copy server ID to clipboard", function()
        setclipboard(game.JobId)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Server ID";
            Text = "Server ID copied to clipboard!";
            Duration = 3;
        })
    end)

    -- Main Tab (Combat)
    local MainTab = Window:NewTab("Main")
    local MainSection = MainTab:NewSection("Combat Settings")
    
    -- Auto Aim (20 studs range)
    MainSection:NewToggle("Auto Aim", "Auto aim at players within 20 studs", function(state)
        getgenv().autoAim = state
        while getgenv().autoAim do
            task.wait()
            local closestPlayer = nil
            local shortestDistance = 20
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local distance = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = v
                    end
                end
            end
            
            if closestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end)
    
    -- Auto Hit (Melee)
    MainSection:NewToggle("Auto Hit", "Auto hit nearest player (melee)", function(state)
        getgenv().autoHit = state
        while getgenv().autoHit do
            task.wait(0.3)
            local target = nil
            local shortestDist = 20
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = v
                    end
                end
            end
            
            if target then
                local args = {
                    [1] = "melee",
                    [2] = target.Character.HumanoidRootPart.Position,
                    [3] = target.Character.HumanoidRootPart
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Player"):WaitForChild("Attack"):FireServer(unpack(args))
            end
        end
    end)
    
    -- Auto Parry/Block
    MainSection:NewToggle("Auto Parry", "Auto parry incoming attacks", function(state)
        getgenv().autoParry = state
        while getgenv().autoParry do
            task.wait()
            -- Parry logic for Violence District
            local args = {
                [1] = "block"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Player"):WaitForChild("Block"):FireServer(unpack(args))
        end
    end)
    
    -- Auto Follow
    MainSection:NewToggle("Auto Follow", "Follow nearest player", function(state)
        getgenv().autoFollow = state
        while getgenv().autoFollow do
            task.wait(0.1)
            local target = nil
            local shortestDistance = math.huge
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local distance = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        target = v
                    end
                end
            end
            
            if target and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
            end
        end
    end)
    
    -- Silent Aim
    MainSection:NewToggle("Silent Aim", "Aim at nearest player without moving camera", function(state)
        getgenv().silentAim = state
        -- Silent aim logic
    end)

    -- Teleport Tab
    local TeleportTab = Window:NewTab("Teleport")
    local TeleportSection = TeleportTab:NewSection("Teleport Options")
    
    -- Teleport to Player
    TeleportSection:NewDropdown("Select Player", "Choose player to teleport to", function()
        local players = {}
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player then
                table.insert(players, v.Name)
            end
        end
        return players
    end, function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 2)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Teleported";
                Text = "Teleported to " .. name;
                Duration = 2;
            })
        end
    end)
    
    -- Teleport to Generator (ATM/Money spots)
    TeleportSection:NewButton("Nearest Generator/ATM", "Teleport to nearest generator/ATM", function()
        local nearestObj = nil
        local shortestDist = math.huge
        local objects = {"Generator", "ATM", "Money", "Cash", "Bank"}
        
        for _, objName in pairs(objects) do
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if obj.Name:find(objName) and obj:IsA("BasePart") then
                    local dist = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearestObj = obj
                    end
                end
            end
        end
        
        if nearestObj then
            player.Character.HumanoidRootPart.CFrame = nearestObj.CFrame * CFrame.new(0, 3, 0)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Teleported";
                Text = "Teleported to nearest " .. nearestObj.Name;
                Duration = 2;
            })
        end
    end)
    
    -- Teleport to Safe Zone
    TeleportSection:NewButton("Safe Zone", "Teleport to safe zone", function()
        -- Adjust coordinates based on Violence District map
        local safeZone = CFrame.new(100, 50, 100) -- Change these coordinates
        player.Character.HumanoidRootPart.CFrame = safeZone
    end)

    -- ESP Tab
    local ESPTab = Window:NewTab("ESP")
    local ESPSection = ESPTab:NewSection("ESP Settings")
    
    -- Player ESP
    ESPSection:NewToggle("Player ESP", "See players through walls", function(state)
        getgenv().espEnabled = state
        while getgenv().espEnabled do
            task.wait()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    -- Create ESP
                    if not v.Character:FindFirstChild("ESP") then
                        local billboard = Instance.new("BillboardGui")
                        local textLabel = Instance.new("TextLabel")
                        
                        billboard.Name = "ESP"
                        billboard.Adornee = v.Character.HumanoidRootPart
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        
                        textLabel.Parent = billboard
                        textLabel.BackgroundTransparency = 1
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.Text = v.Name .. " [" .. math.floor(v.Character.Humanoid.Health) .. "HP]"
                        textLabel.TextColor3 = Color3.new(1, 0, 0)
                        textLabel.TextScaled = true
                        
                        billboard.Parent = v.Character.HumanoidRootPart
                    else
                        v.Character.ESP.TextLabel.Text = v.Name .. " [" .. math.floor(v.Character.Humanoid.Health) .. "HP]"
                    end
                end
            end
        end
        
        -- Cleanup ESP
        if not getgenv().espEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("ESP") then
                    v.Character.ESP:Destroy()
                end
            end
        end
    end)
    
    -- Tracer ESP
    ESPSection:NewToggle("Tracers", "Draw lines to players", function(state)
        getgenv().tracers = state
        -- Tracer logic here
    end)

    -- About Tab
    local AboutTab = Window:NewTab("About")
    local AboutSection = AboutTab:NewSection("About IKAXZU")
    
    AboutSection:NewLabel("Script by: IKAXZU")
    AboutSection:NewLabel("Created for Violence District")
    AboutSection:NewLabel("Version: 1.0")
    AboutSection:NewLabel("Join for more scripts!")
    
    -- Social Media
    local SocialSection = AboutTab:NewSection("Social Media")
    SocialSection:NewButton("Instagram: ikaz_pinter", "Copy Instagram", function()
        setclipboard("ikaz_pinter")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Copied!";
            Text = "Instagram username copied!";
            Duration = 2;
        })
    end)
    
    SocialSection:NewButton("TikTok: zakiacnh", "Copy TikTok", function()
        setclipboard("zakiacnh")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Copied!";
            Text = "TikTok username copied!";
            Duration = 2;
        })
    end)
    
    -- Credits
    local CreditSection = AboutTab:NewSection("Credits")
    CreditSection:NewLabel("Special thanks to all users!")
    CreditSection:NewLabel("Enjoy the script!")
end

-- Auto-execute CreateTabs after key submission
-- Note: CreateTabs is called within the Submit Key function, so no need to call it again here.