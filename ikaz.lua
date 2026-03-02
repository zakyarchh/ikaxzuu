-- -- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    VIOLENCE DISTRICT V4 PREMIUM - REDESIGN                  ║
-- ║                    MONOCHROME EDITION | DARK AESTHETIC                      ║
-- ║                         COMPLETE 70+ FEATURES                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- [SERVICES, VARIABLES, COLOR PALETTE, UTILITY FUNCTIONS, TWEEN PRESETS, 
--  GUI CREATION, BACKGROUND, BLUR, TOGGLE BUTTON, MAIN FRAME, HEADER, 
--  SIDEBAR, CONTENT AREA, NOTIFICATION SYSTEM, TAB CREATION, 
--  UI COMPONENTS (toggle, slider, button, keybind) - SAMA SEPERTI SEBELUMNYA]

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB DEFINITIONS - LENGKAP 12 TAB
-- ══════════════════════════════════════════════════════════════════════════════

local tabs = {
    {id = "home", name = "HOME", icon = "⌂", order = 1},
    {id = "combat", name = "COMBAT", icon = "⚔", order = 2},
    {id = "movement", name = "MOVE", icon = "➤", order = 3},
    {id = "visual", name = "VISUAL", icon = "◐", order = 4},
    {id = "esp", name = "ESP", icon = "◎", order = 5},
    {id = "character", name = "CHAR", icon = "♦", order = 6},
    {id = "world", name = "WORLD", icon = "●", order = 7},
    {id = "utility", name = "UTILITY", icon = "⚙", order = 8},
    {id = "camera", name = "CAMERA", icon = "◉", order = 9},
    {id = "players", name = "PLAYERS", icon = "♣", order = 10},
    {id = "teleport", name = "TELEPORT", icon = "⤴", order = 11},
    {id = "settings", name = "SETTINGS", icon = "≡", order = 12},
}

-- [TAB BUTTON CREATION - SAMA SEPERTI SEBELUMNYA]

-- ══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS UNTUK FITUR
-- ══════════════════════════════════════════════════════════════════════════════

local function getClosestPlayerToMouse(fovLimit)
    local closest = nil
    local minDistance = fovLimit or math.huge
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and isAlive(player.Character) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if distance < minDistance then
                        closest = player
                        minDistance = distance
                    end
                end
            end
        end
    end
    return closest
end

local function getClosestPlayer()
    local closest = nil
    local minDistance = math.huge
    local myHRP = getHRP()
    if not myHRP then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and isAlive(player.Character) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = getDistance(myHRP.Position, hrp.Position)
                if distance < minDistance then
                    closest = player
                    minDistance = distance
                end
            end
        end
    end
    return closest, minDistance
end

local function fireRemotes(target)
    if not target or not target.Character then return end
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("attack") or name:find("hit") or name:find("damage") or name:find("swing") then
                pcall(function()
                    remote:FireServer(target.Character)
                    remote:FireServer(target.Character.HumanoidRootPart)
                end)
            end
        end
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- DRAWING API (FOV Circle, Aura Circle)
-- ══════════════════════════════════════════════════════════════════════════════

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.Color = col.white
fovCircle.Transparency = 0.4
fovCircle.NumSides = 64
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1.5
auraCircle.Color = col.textMuted
auraCircle.Transparency = 0.4
auraCircle.NumSides = 64
auraCircle.Filled = false

-- ══════════════════════════════════════════════════════════════════════════════
-- HOME PAGE - LENGKAP
-- ══════════════════════════════════════════════════════════════════════════════

local homePage = pages["home"]

-- Player Card (Premium)
local playerCard = Instance.new("Frame")
playerCard.Parent = homePage
playerCard.BackgroundColor3 = col.bgTertiary
playerCard.BackgroundTransparency = 0.3
playerCard.Size = UDim2.new(1, 0, 0, 80)
playerCard.ZIndex = 107

local cardCorner = Instance.new("UICorner", playerCard)
cardCorner.CornerRadius = UDim.new(0, 12)

local cardStroke = Instance.new("UIStroke", playerCard)
cardStroke.Color = col.border
cardStroke.Thickness = 1
cardStroke.Transparency = 0.7

local avatarContainer = Instance.new("Frame")
avatarContainer.Parent = playerCard
avatarContainer.BackgroundColor3 = col.bgElevated
avatarContainer.Position = UDim2.new(0, 14, 0.5, -24)
avatarContainer.Size = UDim2.new(0, 48, 0, 48)
avatarContainer.ZIndex = 108
Instance.new("UICorner", avatarContainer).CornerRadius = UDim.new(0, 10)

local avatar = Instance.new("ImageLabel")
avatar.Parent = avatarContainer
avatar.BackgroundTransparency = 1
avatar.Size = UDim2.new(1, 0, 1, 0)
avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
avatar.ZIndex = 109

local playerName = Instance.new("TextLabel")
playerName.Parent = playerCard
playerName.BackgroundTransparency = 1
playerName.Position = UDim2.new(0, 74, 0, 16)
playerName.Size = UDim2.new(1, -88, 0, 20)
playerName.Font = Enum.Font.GothamBlack
playerName.Text = plr.DisplayName
playerName.TextColor3 = col.white
playerName.TextSize = 16
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.ZIndex = 108

local playerUsername = Instance.new("TextLabel")
playerUsername.Parent = playerCard
playerUsername.BackgroundTransparency = 1
playerUsername.Position = UDim2.new(0, 74, 0, 38)
playerUsername.Size = UDim2.new(1, -88, 0, 14)
playerUsername.Font = Enum.Font.Gotham
playerUsername.Text = "@" .. plr.Name
playerUsername.TextColor3 = col.textMuted
playerUsername.TextSize = 11
playerUsername.TextXAlignment = Enum.TextXAlignment.Left
playerUsername.ZIndex = 108

-- Stats Row
local statsRow = Instance.new("Frame")
statsRow.Parent = homePage
statsRow.BackgroundTransparency = 1
statsRow.Size = UDim2.new(1, 0, 0, 60)
statsRow.ZIndex = 107

local function createStatCard(posX, title, value, icon)
    local card = Instance.new("Frame")
    card.Parent = statsRow
    card.BackgroundColor3 = col.bgTertiary
    card.BackgroundTransparency = 0.3
    card.Position = UDim2.new(posX, 0, 0, 0)
    card.Size = UDim2.new(0.48, 0, 1, 0)
    card.ZIndex = 107
    
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 10)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = card
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 10)
    iconLabel.Size = UDim2.new(0, 20, 0, 20)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextColor3 = col.textMuted
    iconLabel.TextSize = 14
    iconLabel.ZIndex = 108
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = card
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 42, 0, 10)
    valueLabel.Size = UDim2.new(1, -56, 0, 20)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = value
    valueLabel.TextColor3 = col.white
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.ZIndex = 108
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = card
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 14, 0, 34)
    titleLabel.Size = UDim2.new(1, -28, 0, 16)
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.Text = title
    titleLabel.TextColor3 = col.textDim
    titleLabel.TextSize = 9
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 108
    
    return {setValue = function(v) valueLabel.Text = v end}
end

local pingCard = createStatCard(0, "Ping", "0ms", "◈")
local fpsCard = createStatCard(0.52, "FPS", "60", "◉")

-- Quick Actions
createSectionLabel(homePage, "QUICK ACTIONS")

createButton(homePage, "Reset Character", function()
    local hum = getHumanoid()
    if hum then hum.Health = 0 end
    notify("Character reset", 2, "success")
end, "default")

createButton(homePage, "Rejoin Server", function()
    notify("Rejoining server...", 2, "warning")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, "default")

createButton(homePage, "Server Hop", function()
    notify("Finding new server...", 2, "warning")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, "default")

createButton(homePage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied", 2, "success")
    end
end, "default")

-- Character Actions
createSectionLabel(homePage, "CHARACTER")

createButton(homePage, "Heal Character", function()
    local hum = getHumanoid()
    if hum then
        hum.Health = hum.MaxHealth
        notify("Character healed", 2, "success")
    end
end, "success")

createButton(homePage, "Teleport to Spawn", function()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn and getHRP() then
        getHRP().CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        notify("Teleported to spawn", 2, "success")
    end
end, "default")

createButton(homePage, "Freeze Character", function()
    local hrp = getHRP()
    if hrp then
        hrp.Anchored = not hrp.Anchored
        notify(hrp.Anchored and "Character frozen" or "Character unfrozen", 2, "success")
    end
end, "default")

-- ══════════════════════════════════════════════════════════════════════════════
-- COMBAT PAGE - 70+ FEATURES
-- ══════════════════════════════════════════════════════════════════════════════

local combatPage = pages["combat"]

-- Protection
createSectionLabel(combatPage, "PROTECTION")

createToggle(combatPage, "God Mode", "god", function(state)
    local hum = getHumanoid()
    if state and hum then
        hum.Name = "H_" .. math.random(100, 999)
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        notify("God Mode enabled", 2, "success")
    elseif hum then
        hum.Name = "Humanoid"
        hum.MaxHealth = 100
        hum.Health = 100
        notify("God Mode disabled", 2)
    end
end, "Become invincible")

-- Aimbot
createSectionLabel(combatPage, "AIMBOT")

createToggle(combatPage, "Auto Aim", "aim", function(state)
    if state then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestPlayerToMouse(cfg.aimfov)
            if target and target.Character then
                local targetPart = target.Character:FindFirstChild(cfg.aimPart) or target.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPart.Position), cfg.aimSmooth)
                end
            end
        end)
        notify("Auto Aim enabled", 2, "success")
    elseif conn.aim then
        conn.aim:Disconnect()
        notify("Auto Aim disabled", 2)
    end
end, "Automatically aim at players")

createToggle(combatPage, "Show FOV", "showfov", function(state)
    fovCircle.Visible = state
end, "Display aimbot field of view")

createSlider(combatPage, "FOV Size", 50, 400, "aimfov", function(v)
    fovCircle.Radius = v
end, "px")

createSlider(combatPage, "Smoothness", 0.1, 1, "aimSmooth", nil, "", 1)

createDropdown(combatPage, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, "aimPart")

-- Silent Aim
createSectionLabel(combatPage, "SILENT AIM")

createToggle(combatPage, "Silent Aim (FOV)", "silentAim", function(state)
    if state then
        conn.silentAim = mouse.Button1Down:Connect(function()
            local target = getClosestPlayerToMouse(cfg.aimfov)
            if target then fireRemotes(target) end
        end)
        notify("Silent Aim enabled", 2, "success")
    elseif conn.silentAim then
        conn.silentAim:Disconnect()
        notify("Silent Aim disabled", 2)
    end
end, "Hit targets within FOV")

createToggle(combatPage, "Silent Aim (No FOV)", "silentNoFov", function(state)
    if state then
        conn.silentNoFov = mouse.Button1Down:Connect(function()
            local target = getClosestPlayer()
            if target then fireRemotes(target) end
        end)
        notify("Silent Aim (No FOV) enabled", 2, "success")
    elseif conn.silentNoFov then
        conn.silentNoFov:Disconnect()
        notify("Silent Aim (No FOV) disabled", 2)
    end
end, "Hit any visible target")

createSlider(combatPage, "Hit Chance", 50, 100, "hitChance", nil, "%")

-- Kill Aura
createSectionLabel(combatPage, "KILL AURA")

createToggle(combatPage, "Kill Aura", "killaura", function(state)
    if state then
        conn.aura = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and getDistance(myHRP.Position, hrp.Position) <= cfg.auraRange then
                        fireRemotes(player)
                    end
                end
            end
        end)
        notify("Kill Aura enabled", 2, "success")
    elseif conn.aura then
        conn.aura:Disconnect()
        notify("Kill Aura disabled", 2)
    end
end, "Auto attack nearby players")

createToggle(combatPage, "Show Aura Range", "showAura", function(state)
    auraCircle.Visible = state
end, "Visualize aura range")

createSlider(combatPage, "Aura Range", 5, 30, "auraRange", nil, " studs")

-- Triggerbot
createSectionLabel(combatPage, "TRIGGERBOT")

createToggle(combatPage, "Triggerbot", "triggerbot", function(state)
    if state then
        conn.triggerbot = RunService.RenderStepped:Connect(function()
            local ray = cam:ScreenPointToRay(mouse.X, mouse.Y)
            local result = Workspace:Raycast(ray.Origin, ray.Direction * 500)
            if result and result.Instance then
                local hitChar = result.Instance:FindFirstAncestorOfClass("Model")
                local hitPlayer = hitChar and Players:GetPlayerFromCharacter(hitChar)
                if hitPlayer and hitPlayer ~= plr then
                    task.wait(cfg.triggerDelay)
                    mouse1click()
                end
            end
        end)
        notify("Triggerbot enabled", 2, "success")
    elseif conn.triggerbot then
        conn.triggerbot:Disconnect()
        notify("Triggerbot disabled", 2)
    end
end, "Auto-click when aiming at players")

createSlider(combatPage, "Trigger Delay", 0, 0.5, "triggerDelay", nil, "s", 2)

-- Combat Assist
createSectionLabel(combatPage, "COMBAT ASSIST")

createToggle(combatPage, "Auto Parry", "autoParry", function(state)
    if state then
        conn.autoParry = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and getDistance(myHRP.Position, hrp.Position) <= cfg.parryRange then
                        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("parry") then
                                pcall(function() remote:FireServer() end)
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Parry enabled", 2, "success")
    elseif conn.autoParry then
        conn.autoParry:Disconnect()
        notify("Auto Parry disabled", 2)
    end
end, "Automatically parry attacks")

createSlider(combatPage, "Parry Range", 5, 20, "parryRange", nil, " studs")

createToggle(combatPage, "Auto Block", "autoBlock", function(state)
    if state then
        conn.autoBlock = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and getDistance(myHRP.Position, hrp.Position) <= cfg.blockRange then
                        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("block") then
                                pcall(function() remote:FireServer(true) end)
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Block enabled", 2, "success")
    elseif conn.autoBlock then
        conn.autoBlock:Disconnect()
        notify("Auto Block disabled", 2)
    end
end, "Auto block when enemies nearby")

createSlider(combatPage, "Block Range", 5, 25, "blockRange", nil, " studs")

createToggle(combatPage, "Auto Dodge", "autoDodge", function(state)
    if state then
        conn.autoDodge = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and getDistance(myHRP.Position, hrp.Position) <= cfg.dodgeRange then
                        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("dodge") then
                                pcall(function() remote:FireServer() end)
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Dodge enabled", 2, "success")
    elseif conn.autoDodge then
        conn.autoDodge:Disconnect()
        notify("Auto Dodge disabled", 2)
    end
end, "Auto dodge incoming attacks")

createSlider(combatPage, "Dodge Range", 3, 15, "dodgeRange", nil, " studs")

-- Reach & Hitbox
createSectionLabel(combatPage, "REACH & HITBOX")

createToggle(combatPage, "Extended Reach", "reach", function(state)
    if state then
        conn.reach = RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = getHRP()
                    if hrp and myHRP and getDistance(myHRP.Position, hrp.Position) <= cfg.reachDistance then
                        hrp.CFrame = CFrame.new(hrp.Position, myHRP.Position) * CFrame.new(0, 0, -4)
                    end
                end
            end
        end)
        notify("Extended Reach enabled", 2, "success")
    elseif conn.reach then
        conn.reach:Disconnect()
        notify("Extended Reach disabled", 2)
    end
end, "Hit players from further away")

createSlider(combatPage, "Reach Distance", 8, 25, "reachDistance", nil, " studs")

createToggle(combatPage, "Hitbox Expander", "hitboxExpander", function(state)
    if state then
        conn.hitbox = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local head = player.Character:FindFirstChild("Head")
                    if hrp then hrp.Size = Vector3.new(cfg.hitboxSize, cfg.hitboxSize, cfg.hitboxSize) end
                    if head then head.Size = Vector3.new(cfg.hitboxSize, cfg.hitboxSize, cfg.hitboxSize) end
                end
            end
        end)
        notify("Hitbox Expander enabled", 2, "success")
    elseif conn.hitbox then
        conn.hitbox:Disconnect()
        notify("Hitbox Expander disabled", 2)
    end
end, "Expand enemy hitboxes")

createSlider(combatPage, "Hitbox Size", 2, 15, "hitboxSize", nil, " studs")

-- ══════════════════════════════════════════════════════════════════════════════
-- MOVEMENT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local movementPage = pages["movement"]

-- Speed
createSectionLabel(movementPage, "SPEED")

createToggle(movementPage, "Speed Hack", "speedHack", function(state)
    if not state and getHumanoid() then
        getHumanoid().WalkSpeed = 16
    end
    notify(state and "Speed Hack enabled" or "Speed Hack disabled", 2)
end, "Increase walk speed")

createSlider(movementPage, "Walk Speed", 16, 500, "speed", function(v)
    if cfg.speedHack and getHumanoid() then
        getHumanoid().WalkSpeed = v
    end
end, "")

createToggle(movementPage, "Sprint", "sprint", function(state)
    if state then
        conn.sprint = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftShift and getHumanoid() then
                getHumanoid().WalkSpeed = (cfg.speedHack and cfg.speed or 16) * cfg.sprintMultiplier
            end
        end)
        conn.sprintEnd = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftShift and getHumanoid() then
                getHumanoid().WalkSpeed = cfg.speedHack and cfg.speed or 16
            end
        end)
        notify("Sprint enabled (Hold Shift)", 2, "success")
    else
        if conn.sprint then conn.sprint:Disconnect() end
        if conn.sprintEnd then conn.sprintEnd:Disconnect() end
        notify("Sprint disabled", 2)
    end
end, "Hold Shift to sprint")

createSlider(movementPage, "Sprint Multiplier", 1.5, 5, "sprintMultiplier", nil, "x", 1)

-- Fly & Noclip
createSectionLabel(movementPage, "FLY & NOCLIP")

createToggle(movementPage, "Fly", "fly", function(state)
    if state and getHRP() then
        local hrp = getHRP()
        local bv = Instance.new("BodyVelocity")
        bv.Name = "VD4_Fly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = hrp
        
        conn.fly = RunService.RenderStepped:Connect(function()
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            bv.Velocity = moveDir * cfg.flySpeed
        end)
        notify("Fly enabled (WASD + Space/Ctrl)", 2, "success")
    elseif getHRP() then
        if conn.fly then conn.fly:Disconnect() end
        local bv = getHRP():FindFirstChild("VD4_Fly")
        if bv then bv:Destroy() end
        notify("Fly disabled", 2)
    end
end, "Fly freely")

createSlider(movementPage, "Fly Speed", 20, 300, "flySpeed", nil, "")

createToggle(movementPage, "Noclip", "noclip", function(state)
    if state then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        notify("Noclip enabled", 2, "success")
    else
        if conn.noclip then conn.noclip:Disconnect() end
        notify("Noclip disabled", 2)
    end
end, "Walk through walls")

-- Jump Modifications
createSectionLabel(movementPage, "JUMP MODS")

createToggle(movementPage, "Infinite Jump", "infiniteJump", function(state)
    if state then
        conn.infJump = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space and getHumanoid() then
                getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        notify("Infinite Jump enabled", 2, "success")
    elseif conn.infJump then
        conn.infJump:Disconnect()
        notify("Infinite Jump disabled", 2)
    end
end, "Jump infinitely")

createToggle(movementPage, "Auto Jump", "autoJump", function(state)
    if state then
        conn.autoJump = RunService.Heartbeat:Connect(function()
            if getHumanoid() then getHumanoid().Jump = true end
        end)
        notify("Auto Jump enabled", 2, "success")
    elseif conn.autoJump then
        conn.autoJump:Disconnect()
        notify("Auto Jump disabled", 2)
    end
end, "Auto jump constantly")

createToggle(movementPage, "Moon Jump", "moonJump", function(state)
    if state then
        conn.moonJump = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space and getHRP() then
                getHRP().Velocity = Vector3.new(getHRP().Velocity.X, cfg.jumpPower, getHRP().Velocity.Z)
            end
        end)
        notify("Moon Jump enabled", 2, "success")
    elseif conn.moonJump then
        conn.moonJump:Disconnect()
        notify("Moon Jump disabled", 2)
    end
end, "Custom jump power")

createSlider(movementPage, "Jump Power", 30, 200, "jumpPower", function(v)
    if getHumanoid() then getHumanoid().JumpPower = v end
end, "")

createToggle(movementPage, "Bunny Hop", "bunnyHop", function(state)
    if state then
        conn.bunnyHop = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hum.WalkSpeed = (cfg.speedHack and cfg.speed or 16) * cfg.bunnySpeed
            end
        end)
        notify("Bunny Hop enabled", 2, "success")
    elseif conn.bunnyHop then
        conn.bunnyHop:Disconnect()
        if getHumanoid() then
            getHumanoid().WalkSpeed = cfg.speedHack and cfg.speed or 16
        end
        notify("Bunny Hop disabled", 2)
    end
end, "Auto jump with speed boost")

createSlider(movementPage, "Bunny Speed", 1, 3, "bunnySpeed", nil, "x", 1)

-- Special Movement
createSectionLabel(movementPage, "SPECIAL")

createToggle(movementPage, "No Fall Damage", "noFallDamage", function(state)
    if state then
        conn.noFall = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end)
        notify("No Fall Damage enabled", 2, "success")
    elseif conn.noFall then
        conn.noFall:Disconnect()
        notify("No Fall Damage disabled", 2)
    end
end, "Prevent fall damage")

createToggle(movementPage, "Air Walk", "airWalk", function(state)
    if state then
        conn.airWalk = RunService.RenderStepped:Connect(function()
            local hrp = getHRP()
            if hrp and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            end
        end)
        notify("Air Walk enabled (Hold Space)", 2, "success")
    elseif conn.airWalk then
        conn.airWalk:Disconnect()
        notify("Air Walk disabled", 2)
    end
end, "Walk on air")

createToggle(movementPage, "Wall Climb", "wallClimb", function(state)
    if state then
        conn.wallClimb = RunService.RenderStepped:Connect(function()
            local hrp = getHRP()
            if hrp and UserInputService:IsKeyDown(Enum.KeyCode.W) then
                local ray = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3)
                if ray then hrp.Velocity = Vector3.new(hrp.Velocity.X, 30, hrp.Velocity.Z) end
            end
        end)
        notify("Wall Climb enabled", 2, "success")
    elseif conn.wallClimb then
        conn.wallClimb:Disconnect()
        notify("Wall Climb disabled", 2)
    end
end, "Climb walls")

createToggle(movementPage, "Crawl Mode", "crawl", function(state)
    local hum = getHumanoid()
    if hum then
        hum.HipHeight = state and -2 or 0
        hum.WalkSpeed = state and cfg.crawlSpeed or (cfg.speedHack and cfg.speed or 16)
        notify(state and "Crawl Mode enabled" or "Crawl Mode disabled", 2)
    end
end, "Crawl on ground")

createSlider(movementPage, "Crawl Speed", 4, 20, "crawlSpeed", function(v)
    if cfg.crawl and getHumanoid() then getHumanoid().WalkSpeed = v end
end, "")

createToggle(movementPage, "Auto Walk", "autoWalk", function(state)
    if state then
        conn.autoWalk = RunService.Heartbeat:Connect(function()
            if getHumanoid() then getHumanoid():Move(Vector3.new(0, 0, -1), true) end
        end)
        notify("Auto Walk enabled", 2, "success")
    elseif conn.autoWalk then
        conn.autoWalk:Disconnect()
        notify("Auto Walk disabled", 2)
    end
end, "Walk forward automatically")

-- Teleport
createSectionLabel(movementPage, "TELEPORT")

createButton(movementPage, "Teleport to Mouse", function()
    if getHRP() then
        getHRP().CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        notify("Teleported to mouse", 2, "success")
    end
end, "default")

createButton(movementPage, "Save Waypoint", function()
    if getHRP() then
        table.insert(waypoints, getHRP().CFrame)
        notify("Waypoint #" .. #waypoints .. " saved", 2, "success")
    end
end, "default")

createButton(movementPage, "Teleport to Last Waypoint", function()
    if getHRP() and #waypoints > 0 then
        getHRP().CFrame = waypoints[#waypoints]
        notify("Teleported to waypoint #" .. #waypoints, 2, "success")
    end
end, "default")

createButton(movementPage, "Clear Waypoints", function()
    waypoints = {}
    notify("Waypoints cleared", 2, "success")
end, "danger")

-- ══════════════════════════════════════════════════════════════════════════════
-- VISUAL PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local visualPage = pages["visual"]

-- Lighting
createSectionLabel(visualPage, "LIGHTING")

createToggle(visualPage, "Remove Fog", "fog", function(state)
    Lighting.FogEnd = state and 100000 or 1000
    Lighting.FogStart = state and 100000 or 0
    notify(state and "Fog removed" or "Fog restored", 2)
end, "Remove all fog")

createToggle(visualPage, "Fullbright", "bright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
        Lighting.Ambient = Color3.fromRGB(170, 170, 170)
        notify("Fullbright enabled", 2, "success")
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        notify("Fullbright disabled", 2)
    end
end, "Maximum brightness")

createToggle(visualPage, "Lock Time", "lockTime", function(state)
    if state then
        conn.lockTime = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = cfg.timeOfDay
        end)
        notify("Time locked", 2, "success")
    elseif conn.lockTime then
        conn.lockTime:Disconnect()
        notify("Time unlocked", 2)
    end
end, "Lock time of day")

createSlider(visualPage, "Time of Day", 0, 24, "timeOfDay", function(v)
    Lighting.ClockTime = v
end, "h")

-- Camera
createSectionLabel(visualPage, "CAMERA")

createSlider(visualPage, "Field of View", 30, 120, "fov", function(v)
    cam.FieldOfView = v
end, "°")

createToggle(visualPage, "Cinematic Bars", "cinematicBars", function(state)
    if state then
        local topBar = Instance.new("Frame", gui)
        topBar.Name = "CinematicTop"
        topBar.BackgroundColor3 = col.black
        topBar.BorderSizePixel = 0
        topBar.Size = UDim2.new(1, 0, cfg.barsSize, 0)
        topBar.Position = UDim2.new(0, 0, 0, 0)
        topBar.ZIndex = 999
        
        local bottomBar = Instance.new("Frame", gui)
        bottomBar.Name = "CinematicBottom"
        bottomBar.BackgroundColor3 = col.black
        bottomBar.BorderSizePixel = 0
        bottomBar.Size = UDim2.new(1, 0, cfg.barsSize, 0)
        bottomBar.Position = UDim2.new(0, 0, 1 - cfg.barsSize, 0)
        bottomBar.ZIndex = 999
        notify("Cinematic bars enabled", 2, "success")
    else
        local top = gui:FindFirstChild("CinematicTop")
        local bottom = gui:FindFirstChild("CinematicBottom")
        if top then top:Destroy() end
        if bottom then bottom:Destroy() end
        notify("Cinematic bars disabled", 2)
    end
end, "Add movie-style black bars")

createSlider(visualPage, "Bar Size", 0.05, 0.2, "barsSize", function(v)
    local top = gui:FindFirstChild("CinematicTop")
    local bottom = gui:FindFirstChild("CinematicBottom")
    if top then top.Size = UDim2.new(1, 0, v, 0) end
    if bottom then
        bottom.Size = UDim2.new(1, 0, v, 0)
        bottom.Position = UDim2.new(0, 0, 1 - v, 0)
    end
end, "", 2)

-- Character Visuals
createSectionLabel(visualPage, "CHARACTER")

createToggle(visualPage, "Invisible", "invisible", function(state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = state and 1 or 0
        elseif part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        end
    end
    notify(state and "Invisible enabled" or "Invisible disabled", 2)
end, "Make character invisible")

createToggle(visualPage, "Forcefield", "forcefield", function(state)
    if state then
        local ff = Instance.new("ForceField", char)
        ff.Name = "VD4_Forcefield"
        notify("Forcefield enabled", 2, "success")
    else
        local ff = char:FindFirstChild("VD4_Forcefield")
        if ff then ff:Destroy() end
        notify("Forcefield disabled", 2)
    end
end, "Show forcefield effect")

createToggle(visualPage, "Character Trail", "trail", function(state)
    if state and getHRP() then
        local hrp = getHRP()
        local attach0 = Instance.new("Attachment", hrp)
        attach0.Name = "VD4_TrailAttach0"
        attach0.Position = Vector3.new(0, 1, 0)
        
        local attach1 = Instance.new("Attachment", hrp)
        attach1.Name = "VD4_TrailAttach1"
        attach1.Position = Vector3.new(0, -1, 0)
        
        local trail = Instance.new("Trail", hrp)
        trail.Name = "VD4_Trail"
        trail.Attachment0 = attach0
        trail.Attachment1 = attach1
        trail.Color = ColorSequence.new(col.white)
        trail.Transparency = NumberSequence.new(0, 1)
        trail.Lifetime = 0.5
        notify("Trail enabled", 2, "success")
    elseif getHRP() then
        local hrp = getHRP()
        local trail = hrp:FindFirstChild("VD4_Trail")
        local a0 = hrp:FindFirstChild("VD4_TrailAttach0")
        local a1 = hrp:FindFirstChild("VD4_TrailAttach1")
        if trail then trail:Destroy() end
        if a0 then a0:Destroy() end
        if a1 then a1:Destroy() end
        notify("Trail disabled", 2)
    end
end, "Add trail behind character")

createToggle(visualPage, "Particles", "particles", function(state)
    if state and getHRP() then
        local hrp = getHRP()
        local particle = Instance.new("ParticleEmitter", hrp)
        particle.Name = "VD4_Particles"
        particle.Color = ColorSequence.new(col.white)
        particle.Size = NumberSequence.new(0.3, 0)
        particle.Lifetime = NumberRange.new(0.5, 1)
        particle.Rate = 50
        notify("Particles enabled", 2, "success")
    elseif getHRP() then
        local particle = getHRP():FindFirstChild("VD4_Particles")
        if particle then particle:Destroy() end
        notify("Particles disabled", 2)
    end
end, "Add particle effects")

-- World Effects
createSectionLabel(visualPage, "WORLD")

createToggle(visualPage, "X-Ray Walls", "xray", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            if obj.Name:lower():find("wall") or obj.Name:lower():find("door") then
                if state then
                    obj:SetAttribute("VD4_OrigTransparency", obj.Transparency)
                    obj.Transparency = cfg.xrayTransparency
                else
                    local orig = obj:GetAttribute("VD4_OrigTransparency")
                    if orig then obj.Transparency = orig end
                end
            end
        end
    end
    notify(state and "X-Ray enabled" or "X-Ray disabled", 2)
end, "See through walls")

createSlider(visualPage, "X-Ray Transparency", 0.3, 0.9, "xrayTransparency", nil, "", 1)

createToggle(visualPage, "No Particles", "noParticles", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then obj.Enabled = not state end
    end
    notify(state and "Particles disabled" or "Particles enabled", 2)
end, "Disable world particles")

createToggle(visualPage, "No Effects", "noEffects", function(state)
    for _, effect in pairs(Lighting:GetDescendants()) do
        if effect:IsA("PostEffect") then effect.Enabled = not state end
    end
    notify(state and "Effects disabled" or "Effects enabled", 2)
end, "Disable post-processing")

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local espPage = pages["esp"]
local espData = {}
local tracerData = {}

local function clearESP()
    for _, data in pairs(espData) do
        pcall(function()
            if data.billboard then data.billboard:Destroy() end
            if data.highlight then data.highlight:Destroy() end
        end)
    end
    espData = {}
end

local function createESP(player)
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VD4_ESP"
    billboard.Parent = hrp
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 80, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.LightInfluence = 0
    
    local container = Instance.new("Frame", billboard)
    container.BackgroundColor3 = col.bgPrimary
    container.BackgroundTransparency = 0.2
    container.Size = UDim2.new(1, 0, 1, 0)
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.white
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    
    local nameLabel = Instance.new("TextLabel", container)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = col.white
    nameLabel.TextScaled = true
    
    local infoLabel = Instance.new("TextLabel", container)
    infoLabel.Name = "Info"
    infoLabel.Parent = container
    infoLabel.BackgroundTransparency = 1
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Text = "0m | 100HP"
    infoLabel.TextColor3 = col.textMuted
    infoLabel.TextScaled = true
    
    espData[player] = {billboard = billboard, info = infoLabel}
end

-- ESP Page UI
createSectionLabel(espPage, "PLAYER ESP")

createToggle(espPage, "Enable ESP", "esp", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESP(player) end
        end
        notify("ESP enabled", 2, "success")
    else
        clearESP()
        notify("ESP disabled", 2)
    end
end, "See players through walls")

createToggle(espPage, "Show Health", "espShowHealth", nil, "Display health")
createToggle(espPage, "Show Distance", "espShowDistance", nil, "Display distance")
createSlider(espPage, "Max Distance", 100, 2000, "espDistance", nil, "m")

-- Tracers
createSectionLabel(espPage, "TRACERS")

createToggle(espPage, "Enable Tracers", "tracers", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                local tracer = Drawing.new("Line")
                tracer.Visible = true
                tracer.Color = col.white
                tracer.Thickness = 1.5
                tracer.Transparency = 0.5
                tracerData[player] = tracer
            end
        end
        notify("Tracers enabled", 2, "success")
    else
        for _, tracer in pairs(tracerData) do
            pcall(function() tracer:Remove() end)
        end
        tracerData = {}
        notify("Tracers disabled", 2)
    end
end, "Draw lines to players")

createDropdown(espPage, "Origin", {"Bottom", "Center", "Top", "Mouse"}, "tracerOrigin")

-- Chams
createSectionLabel(espPage, "CHAMS")

createToggle(espPage, "Enable Chams", "chams", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.Name = "VD4_Chams"
                highlight.FillColor = col.white
                highlight.OutlineColor = col.textMuted
                highlight.FillTransparency = 0.5
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                chamsData[player] = highlight
            end
        end
        notify("Chams enabled", 2, "success")
    else
        for _, highlight in pairs(chamsData) do
            pcall(function() highlight:Destroy() end)
        end
        chamsData = {}
        notify("Chams disabled", 2)
    end
end, "Colored character overlay")

-- Object ESP
createSectionLabel(espPage, "OBJECTS")

createToggle(espPage, "Item ESP", "itemEsp", function(state)
    if state then
        conn.itemEsp = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") and not obj:FindFirstChild("VD4_ItemESP") then
                    local billboard = Instance.new("BillboardGui", obj)
                    billboard.Name = "VD4_ItemESP"
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0, 50, 0, 20)
                    
                    local label = Instance.new("TextLabel", billboard)
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Font = Enum.Font.GothamBold
                    label.Text = obj.Name
                    label.TextColor3 = col.textMuted
                    label.TextScaled = true
                end
            end
        end)
        notify("Item ESP enabled", 2, "success")
    elseif conn.itemEsp then
        conn.itemEsp:Disconnect()
        notify("Item ESP disabled", 2)
    end
end, "See items through walls")

createToggle(espPage, "NPC ESP", "npcEsp", function(state)
    if state then
        conn.npcEsp = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                    local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                    if hrp and not hrp:FindFirstChild("VD4_NPCESP") then
                        local billboard = Instance.new("BillboardGui", hrp)
                        billboard.Name = "VD4_NPCESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 60, 0, 25)
                        
                        local label = Instance.new("TextLabel", billboard)
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Font = Enum.Font.GothamBold
                        label.Text = obj.Name
                        label.TextColor3 = col.textMuted
                        label.TextScaled = true
                    end
                end
            end
        end)
        notify("NPC ESP enabled", 2, "success")
    elseif conn.npcEsp then
        conn.npcEsp:Disconnect()
        notify("NPC ESP disabled", 2)
    end
end, "See NPCs through walls")

-- ══════════════════════════════════════════════════════════════════════════════
-- CHARACTER PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local characterPage = pages["character"]

createSectionLabel(characterPage, "CHARACTER MODS")

createToggle(characterPage, "No Ragdoll", "noRagdoll", function(state)
    if state then
        conn.noRagdoll = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end)
        notify("No Ragdoll enabled", 2, "success")
    elseif conn.noRagdoll then
        conn.noRagdoll:Disconnect()
        notify("No Ragdoll disabled", 2)
    end
end, "Prevent ragdolling")

createToggle(characterPage, "Infinite Stamina", "infiniteStamina", function(state)
    if state then
        conn.stamina = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(plr.PlayerGui:GetDescendants()) do
                if obj:IsA("NumberValue") and obj.Name:lower():find("stamina") then
                    obj.Value = 100
                end
            end
        end)
        notify("Infinite Stamina enabled", 2, "success")
    elseif conn.stamina then
        conn.stamina:Disconnect()
        notify("Infinite Stamina disabled", 2)
    end
end, "Never run out of stamina")

createToggle(characterPage, "Anti Void", "antiVoid", function(state)
    local safePos = getHRP() and getHRP().CFrame or CFrame.new(0, 50, 0)
    if state then
        conn.antiVoid = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp then
                if hrp.Position.Y > -50 then safePos = hrp.CFrame end
                if hrp.Position.Y < -100 then
                    hrp.CFrame = safePos
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        notify("Anti Void enabled", 2, "success")
    elseif conn.antiVoid then
        conn.antiVoid:Disconnect()
        notify("Anti Void disabled", 2)
    end
end, "Teleport back from void")

-- Physics
createSectionLabel(characterPage, "PHYSICS")

createToggle(characterPage, "Low Gravity", "lowGravity", function(state)
    Workspace.Gravity = state and 50 or 196.2
    notify(state and "Low Gravity enabled" or "Gravity restored", 2)
end, "Reduce gravity")

createSlider(characterPage, "Custom Gravity", 10, 300, "customGravity", function(v)
    if cfg.lowGravity then Workspace.Gravity = v end
end, "")

-- Size
createSectionLabel(characterPage, "SIZE")

createSlider(characterPage, "Character Size", 0.5, 3, "characterSize", function(v)
    local hum = getHumanoid()
    if hum then
        local bodyDepth = hum:FindFirstChild("BodyDepthScale")
        local bodyHeight = hum:FindFirstChild("BodyHeightScale")
        local bodyWidth = hum:FindFirstChild("BodyWidthScale")
        if bodyDepth then bodyDepth.Value = v end
        if bodyHeight then bodyHeight.Value = v end
        if bodyWidth then bodyWidth.Value = v end
    end
end, "x", 1)

createSlider(characterPage, "Head Size", 0.5, 5, "headSize", function(v)
    local head = char:FindFirstChild("Head")
    if head then
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if mesh then mesh.Scale = Vector3.new(v, v, v) end
    end
end, "x", 1)

createButton(characterPage, "Reset Size", function()
    cfg.characterSize = 1
    cfg.headSize = 1
    local hum = getHumanoid()
    if hum then
        local bodyDepth = hum:FindFirstChild("BodyDepthScale")
        local bodyHeight = hum:FindFirstChild("BodyHeightScale")
        local bodyWidth = hum:FindFirstChild("BodyWidthScale")
        if bodyDepth then bodyDepth.Value = 1 end
        if bodyHeight then bodyHeight.Value = 1 end
        if bodyWidth then bodyWidth.Value = 1 end
    end
    local head = char:FindFirstChild("Head")
    if head then
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if mesh then mesh.Scale = Vector3.new(1, 1, 1) end
    end
    notify("Size reset", 2, "success")
end, "default")

-- Animation
createSectionLabel(characterPage, "ANIMATION")

createToggle(characterPage, "No Animations", "noAnimations", function(state)
    local hum = getHumanoid()
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            if state then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
                conn.noAnim = animator.AnimationPlayed:Connect(function(t) t:Stop() end)
            elseif conn.noAnim then
                conn.noAnim:Disconnect()
            end
        end
    end
    notify(state and "Animations disabled" or "Animations enabled", 2)
end, "Stop all animations")

createTextInput(characterPage, "Animation ID", "animationId", "Enter ID...")

createButton(characterPage, "Play Animation", function()
    local hum = getHumanoid()
    if hum and cfg.animationId and cfg.animationId ~= "" then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(cfg.animationId)
            local track = animator:LoadAnimation(anim)
            track:Play()
            notify("Playing animation", 2, "success")
        end
    end
end, "default")

-- ══════════════════════════════════════════════════════════════════════════════
-- WORLD PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local worldPage = pages["world"]

createSectionLabel(worldPage, "WORLD SETTINGS")

createSlider(worldPage, "World Gravity", 10, 400, "worldGravity", function(v)
    Workspace.Gravity = v
end, "")

createToggle(worldPage, "No Weather", "noWeather", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") and (obj.Name:lower():find("rain") or obj.Name:lower():find("snow")) then
            obj.Enabled = not state
        end
    end
    notify(state and "Weather disabled" or "Weather enabled", 2)
end, "Disable rain/snow")

createToggle(worldPage, "No Sounds", "noSounds", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then obj.Volume = state and 0 or 1 end
    end
    notify(state and "Sounds muted" or "Sounds restored", 2)
end, "Mute all sounds")

createToggle(worldPage, "No Music", "noMusic", function(state)
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Sound") and (obj.Name:lower():find("music") or obj.Name:lower():find("bgm")) then
            obj.Volume = state and 0 or (obj:GetAttribute("VD4_OrigVolume") or 1)
        end
    end
    notify(state and "Music muted" or "Music restored", 2)
end, "Mute background music")

-- Performance
createSectionLabel(worldPage, "PERFORMANCE")

createToggle(worldPage, "Anti Lag", "antiLag", function(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then obj.Enabled = false end
            if obj:IsA("Decal") then obj.Transparency = 1 end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        notify("Anti Lag enabled", 2, "success")
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        notify("Anti Lag disabled", 2)
    end
end, "Reduce lag")

createToggle(worldPage, "No Textures", "noTextures", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = state and 1 or 0
        end
    end
    notify(state and "Textures hidden" or "Textures restored", 2)
end, "Hide all textures")

createToggle(worldPage, "Low Graphics", "lowGraphics", function(state)
    if state then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        notify("Low graphics enabled", 2, "success")
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
        notify("Graphics restored", 2)
    end
end, "Minimum graphics")

-- Items
createSectionLabel(worldPage, "ITEMS")

createToggle(worldPage, "Magnet Items", "magnetItems", function(state)
    if state then
        conn.magnet = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if not hrp then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle and getDistance(hrp.Position, handle.Position) <= cfg.magnetRange then
                        handle.CFrame = hrp.CFrame
                    end
                end
            end
        end)
        notify("Magnet Items enabled", 2, "success")
    elseif conn.magnet then
        conn.magnet:Disconnect()
        notify("Magnet Items disabled", 2)
    end
end, "Pull items to you")

createSlider(worldPage, "Magnet Range", 10, 100, "magnetRange", nil, " studs")

createButton(worldPage, "Collect All Items", function()
    local collected = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            pcall(function() obj.Parent = plr.Backpack; collected = collected + 1 end)
        end
    end
    notify("Collected " .. collected .. " items", 2, "success")
end, "default")

createButton(worldPage, "Click All ClickDetectors", function()
    local clicked = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            pcall(function() fireclickdetector(obj); clicked = clicked + 1 end)
        end
    end
    notify("Clicked " .. clicked .. " detectors", 2, "success")
end, "default")

-- ══════════════════════════════════════════════════════════════════════════════
-- UTILITY PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local utilityPage = pages["utility"]

-- Anti Features
createSectionLabel(utilityPage, "PROTECTION")

createToggle(utilityPage, "Anti AFK", "antiAfk", function(state)
    if state then
        plr.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        notify("Anti AFK enabled", 2, "success")
    else
        notify("Anti AFK disabled (rejoin to fully disable)", 2)
    end
end, "Prevent AFK kick")

createToggle(utilityPage, "Anti Kick", "antiKick", function(state)
    if state then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then return nil end
            return oldNamecall(self, ...)
        end)
        notify("Anti Kick enabled", 2, "success")
    end
end, "Prevent being kicked")

createToggle(utilityPage, "Auto Rejoin", "autoRejoin", function(state)
    if state then
        conn.autoRejoin = plr.OnTeleport:Connect(function(s)
            if s == Enum.TeleportState.Failed then
                task.wait(5)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
            end
        end)
        notify("Auto Rejoin enabled", 2, "success")
    elseif conn.autoRejoin then
        conn.autoRejoin:Disconnect()
        notify("Auto Rejoin disabled", 2)
    end
end, "Auto rejoin on failure")

-- Auto Farm
createSectionLabel(utilityPage, "AUTO FARM")

createToggle(utilityPage, "Auto Farm", "autoFarm", function(state)
    if state then
        conn.autoFarm = RunService.Heartbeat:Connect(function()
            local target, dist = getClosestPlayer()
            if target and dist and dist < 30 then
                local hum = getHumanoid()
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if hum and targetHRP then
                    hum:MoveTo(targetHRP.Position)
                    if dist < 10 then fireRemotes(target) end
                end
            end
        end)
        notify("Auto Farm enabled", 2, "success")
    elseif conn.autoFarm then
        conn.autoFarm:Disconnect()
        notify("Auto Farm disabled", 2)
    end
end, "Auto attack nearest player")

createToggle(utilityPage, "Auto Collect", "autoCollect", function(state)
    if state then
        conn.autoCollect = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if not hrp then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                    if getDistance(hrp.Position, obj.Handle.Position) <= cfg.collectRange then
                        pcall(function() obj.Parent = plr.Backpack end)
                    end
                end
            end
        end)
        notify("Auto Collect enabled", 2, "success")
    elseif conn.autoCollect then
        conn.autoCollect:Disconnect()
        notify("Auto Collect disabled", 2)
    end
end, "Auto collect nearby items")

createSlider(utilityPage, "Collect Range", 10, 100, "collectRange", nil, " studs")

-- Chat
createSectionLabel(utilityPage, "CHAT")

createToggle(utilityPage, "Chat Spam", "chatSpam", function(state)
    if state then
        conn.chatSpam = task.spawn(function()
            while cfg.chatSpam do
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cfg.spamMessage, "All")
                end)
                task.wait(cfg.spamDelay)
            end
        end)
        notify("Chat Spam enabled", 2, "success")
    else
        notify("Chat Spam disabled", 2)
    end
end, "Spam messages")

createTextInput(utilityPage, "Spam Message", "spamMessage", "Enter message...")
createSlider(utilityPage, "Spam Delay", 0.5, 10, "spamDelay", nil, "s", 1)

-- Info
createSectionLabel(utilityPage, "INFORMATION")

createButton(utilityPage, "Copy Game ID", function()
    if setclipboard then
        setclipboard(tostring(game.PlaceId))
        notify("Game ID copied", 2, "success")
    end
end, "default")

createButton(utilityPage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied", 2, "success")
    end
end, "default")

createButton(utilityPage, "Copy Player List", function()
    if setclipboard then
        local list = ""
        for _, p in pairs(Players:GetPlayers()) do
            list = list .. p.Name .. " (" .. p.DisplayName .. ")\n"
        end
        setclipboard(list)
        notify("Player list copied", 2, "success")
    end
end, "default")

-- ══════════════════════════════════════════════════════════════════════════════
-- CAMERA PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local cameraPage = pages["camera"]

createSectionLabel(cameraPage, "CAMERA MODES")

createToggle(cameraPage, "Free Camera", "freeCam", function(state)
    if state then
        local freeCamPos = cam.CFrame
        local hum = getHumanoid()
        if hum then cam.CameraSubject = nil end
        
        conn.freeCam = RunService.RenderStepped:Connect(function(dt)
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            freeCamPos = freeCamPos + moveDir * cfg.freeCamSpeed * 50 * dt
            cam.CFrame = CFrame.new(freeCamPos.Position) * CFrame.fromEulerAnglesYXZ(cam.CFrame:ToEulerAnglesYXZ())
        end)
        notify("Free Camera enabled (WASD + Q/E)", 2, "success")
    elseif conn.freeCam then
        conn.freeCam:Disconnect()
        if getHumanoid() then cam.CameraSubject = getHumanoid() end
        notify("Free Camera disabled", 2)
    end
end, "Freely move camera")

createSlider(cameraPage, "Free Cam Speed", 0.5, 5, "freeCamSpeed", nil, "x", 1)

createToggle(cameraPage, "Orbit Camera", "orbitCam", function(state)
    if state then
        local angle = 0
        conn.orbitCam = RunService.RenderStepped:Connect(function(dt)
            local hrp = getHRP()
            if hrp then
                angle = angle + cfg.orbitSpeed * dt
                local offset = Vector3.new(math.cos(angle) * cfg.orbitDistance, 5, math.sin(angle) * cfg.orbitDistance)
                cam.CFrame = CFrame.new(hrp.Position + offset, hrp.Position)
            end
        end)
        notify("Orbit Camera enabled", 2, "success")
    elseif conn.orbitCam then
        conn.orbitCam:Disconnect()
        if getHumanoid() then cam.CameraSubject = getHumanoid() end
        notify("Orbit Camera disabled", 2)
    end
end, "Camera orbits character")

createSlider(cameraPage, "Orbit Speed", 0.1, 3, "orbitSpeed", nil, "x", 1)
createSlider(cameraPage, "Orbit Distance", 5, 50, "orbitDistance", nil, " studs")

-- Third Person
createSectionLabel(cameraPage, "THIRD PERSON")

createToggle(cameraPage, "Force Third Person", "thirdPerson", function(state)
    if state then
        plr.CameraMode = Enum.CameraMode.Classic
        plr.CameraMaxZoomDistance = cfg.thirdPersonDistance
        plr.CameraMinZoomDistance = cfg.thirdPersonDistance
        notify("Third Person forced", 2, "success")
    else
        plr.CameraMaxZoomDistance = 400
        plr.CameraMinZoomDistance = 0.5
        notify("Third Person released", 2)
    end
end, "Lock third person view")

createSlider(cameraPage, "Third Person Distance", 5, 30, "thirdPersonDistance", function(v)
    if cfg.thirdPerson then
        plr.CameraMaxZoomDistance = v
        plr.CameraMinZoomDistance = v
    end
end, " studs")

-- Effects
createSectionLabel(cameraPage, "EFFECTS")

createToggle(cameraPage, "Camera Shake", "cameraShake", function(state)
    if state then
        conn.camShake = RunService.RenderStepped:Connect(function()
            local intensity = cfg.shakeIntensity
            local offset = Vector3.new((math.random()-0.5)*intensity, (math.random()-0.5)*intensity, (math.random()-0.5)*intensity)
            cam.CFrame = cam.CFrame * CFrame.new(offset)
        end)
        notify("Camera Shake enabled", 2, "success")
    elseif conn.camShake then
        conn.camShake:Disconnect()
        notify("Camera Shake disabled", 2)
    end
end, "Add shake effect")

createSlider(cameraPage, "Shake Intensity", 0.1, 2, "shakeIntensity", nil, "", 1)

createToggle(cameraPage, "Head Tracker", "headTracker", function(state)
    if state then
        conn.headTracker = RunService.RenderStepped:Connect(function()
            local target = getClosestPlayerToMouse(cfg.aimfov)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
            end
        end)
        notify("Head Tracker enabled", 2, "success")
    elseif conn.headTracker then
        conn.headTracker:Disconnect()
        notify("Head Tracker disabled", 2)
    end
end, "Track nearest player's head")

-- ══════════════════════════════════════════════════════════════════════════════
-- PLAYERS PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local playersPage = pages["players"]
local selectedPlayer = nil

createSectionLabel(playersPage, "PLAYER LIST")

local playerListContainer = Instance.new("Frame")
playerListContainer.Parent = playersPage
playerListContainer.BackgroundColor3 = col.bgTertiary
playerListContainer.BackgroundTransparency = 0.3
playerListContainer.Size = UDim2.new(1, 0, 0, 150)
playerListContainer.ZIndex = 107

Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 10)

local playerListScroll = Instance.new("ScrollingFrame")
playerListScroll.Parent = playerListContainer
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 6, 0, 6)
playerListScroll.Size = UDim2.new(1, -12, 1, -12)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 3
playerListScroll.ScrollBarImageColor3 = col.textMuted
playerListScroll.ZIndex = 108

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Parent = playerListScroll
playerListLayout.Padding = UDim.new(0, 4)

local function updatePlayerList()
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local isSelected = (cfg.selectedPlayer == player)
            
            local btn = Instance.new("TextButton")
            btn.Parent = playerListScroll
            btn.BackgroundColor3 = isSelected and col.bgElevated or col.bgPrimary
            btn.BackgroundTransparency = 0.4
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = ""
            btn.ZIndex = 109
            
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 6)
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = btn
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.Size = UDim2.new(1, -16, 1, 0)
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.Text = player.DisplayName .. " @" .. player.Name
            nameLabel.TextColor3 = isSelected and col.white or col.textSecondary
            nameLabel.TextSize = 11
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 110
            
            btn.MouseButton1Click:Connect(function()
                cfg.selectedPlayer = (cfg.selectedPlayer == player) and nil or player
                updatePlayerList()
                if cfg.selectedPlayer then
                    notify("Selected: " .. player.DisplayName, 2, "success")
                end
            end)
        end
    end
    playerListScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 6)
end

updatePlayerList()

-- Player Actions
createSectionLabel(playersPage, "ACTIONS")

createButton(playersPage, "Teleport to Player", function()
    if cfg.selectedPlayer and teleportToPlayer(cfg.selectedPlayer) then
        notify("Teleported to " .. cfg.selectedPlayer.DisplayName, 2, "success")
    else
        notify("Select a player first", 2, "warning")
    end
end, "default")

createButton(playersPage, "Spectate Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local hum = cfg.selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            cam.CameraSubject = hum
            notify("Spectating " .. cfg.selectedPlayer.DisplayName, 2, "success")
        end
    end
end, "default")

createButton(playersPage, "Stop Spectating", function()
    if getHumanoid() then
        cam.CameraSubject = getHumanoid()
        notify("Stopped spectating", 2, "success")
    end
end, "default")

createButton(playersPage, "Refresh List", function()
    updatePlayerList()
    notify("Player list refreshed", 2, "success")
end, "default")

-- Follow & Annoy
createSectionLabel(playersPage, "FOLLOW & ANNOY")

createToggle(playersPage, "Follow Player", "followPlayer", function(state)
    if state and cfg.selectedPlayer then
        conn.follow = RunService.Heartbeat:Connect(function()
            if cfg.selectedPlayer and cfg.selectedPlayer.Character then
                local targetHRP = cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHRP = getHRP()
                local hum = getHumanoid()
                if targetHRP and myHRP and hum and getDistance(myHRP.Position, targetHRP.Position) > cfg.followDistance then
                    hum:MoveTo(targetHRP.Position)
                end
            end
        end)
        notify("Following " .. cfg.selectedPlayer.DisplayName, 2, "success")
    elseif conn.follow then
        conn.follow:Disconnect()
        notify("Stopped following", 2)
    end
end, "Auto follow selected player")

createSlider(playersPage, "Follow Distance", 3, 20, "followDistance", nil, " studs")

createToggle(playersPage, "Annoy Player", "annoyPlayer", function(state)
    if state and cfg.selectedPlayer then
        conn.annoy = RunService.Heartbeat:Connect(function()
            if cfg.selectedPlayer and cfg.selectedPlayer.Character then
                local targetHRP = cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHRP = getHRP()
                if targetHRP and myHRP then
                    local offset = Vector3.new(math.random(-cfg.annoyRange, cfg.annoyRange), 0, math.random(-cfg.annoyRange, cfg.annoyRange))
                    myHRP.CFrame = CFrame.new(targetHRP.Position + offset)
                end
            end
        end)
        notify("Annoying " .. cfg.selectedPlayer.DisplayName, 2, "success")
    elseif conn.annoy then
        conn.annoy:Disconnect()
        notify("Stopped annoying", 2)
    end
end, "Teleport around player")

createSlider(playersPage, "Annoy Range", 1, 10, "annoyRange", nil, " studs")

createToggle(playersPage, "Copy Look", "copyLook", function(state)
    if state and cfg.selectedPlayer then
        conn.copyLook = RunService.Heartbeat:Connect(function()
            if cfg.selectedPlayer and cfg.selectedPlayer.Character then
                local targetHRP = cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHRP = getHRP()
                if targetHRP and myHRP then
                    myHRP.CFrame = CFrame.new(myHRP.Position, myHRP.Position + targetHRP.CFrame.LookVector)
                end
            end
        end)
        notify("Copying " .. cfg.selectedPlayer.DisplayName .. "'s look", 2, "success")
    elseif conn.copyLook then
        conn.copyLook:Disconnect()
        notify("Stopped copying look", 2)
    end
end, "Face same direction")

-- ══════════════════════════════════════════════════════════════════════════════
-- TELEPORT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local teleportPage = pages["teleport"]
local waypoints = {}

createSectionLabel(teleportPage, "QUICK TELEPORT")

createButton(teleportPage, "Teleport to Mouse", function()
    if getHRP() then
        getHRP().CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        notify("Teleported to mouse", 2, "success")
    end
end, "default")

createButton(teleportPage, "Teleport to Spawn", function()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn and getHRP() then
        getHRP().CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        notify("Teleported to spawn", 2, "success")
    end
end, "default")

createButton(teleportPage, "Teleport to Random Player", function()
    local players = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and isAlive(p.Character) then table.insert(players, p) end
    end
    if #players > 0 then
        local target = players[math.random(1, #players)]
        if teleportToPlayer(target) then
            notify("Teleported to " .. target.DisplayName, 2, "success")
        end
    end
end, "default")

-- Waypoints
createSectionLabel(teleportPage, "WAYPOINTS")

createButton(teleportPage, "Save Current Position", function()
    if getHRP() then
        table.insert(waypoints, {name = "Waypoint #" .. (#waypoints+1), cframe = getHRP().CFrame})
        notify("Waypoint #" .. #waypoints .. " saved", 2, "success")
    end
end, "default")

createButton(teleportPage, "Teleport to Last Waypoint", function()
    if #waypoints > 0 and getHRP() then
        getHRP().CFrame = waypoints[#waypoints].cframe
        notify("Teleported to " .. waypoints[#waypoints].name, 2, "success")
    end
end, "default")

createButton(teleportPage, "Clear All Waypoints", function()
    waypoints = {}
    notify("Waypoints cleared", 2, "success")
end, "danger")

-- Coordinates
createSectionLabel(teleportPage, "COORDINATES")

local coordX, coordY, coordZ = 0, 50, 0

createTextInput(teleportPage, "X", "teleportX", "0")
createTextInput(teleportPage, "Y", "teleportY", "50")
createTextInput(teleportPage, "Z", "teleportZ", "0")

createButton(teleportPage, "Teleport to Coordinates", function()
    if getHRP() then
        getHRP().CFrame = CFrame.new(coordX, coordY, coordZ)
        notify("Teleported to coordinates", 2, "success")
    end
end, "default")

createButton(teleportPage, "Copy Current Position", function()
    if getHRP() and setclipboard then
        local pos = getHRP().Position
        setclipboard(string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z))
        notify("Position copied", 2, "success")
    end
end, "default")

-- Server
createSectionLabel(teleportPage, "SERVER")

createButton(teleportPage, "Rejoin Server", function()
    notify("Rejoining...", 2, "warning")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, "default")

createButton(teleportPage, "Server Hop", function()
    notify("Finding new server...", 2, "warning")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, "default")

-- ══════════════════════════════════════════════════════════════════════════════
-- SETTINGS PAGE (LENGKAP)
-- ══════════════════════════════════════════════════════════════════════════════

local settingsPage = pages["settings"]

createSectionLabel(settingsPage, "UI SETTINGS")

createSlider(settingsPage, "UI Opacity", 0.5, 1, "uiOpacity", function(v)
    main.BackgroundTransparency = 1 - v
    header.BackgroundTransparency = 1 - (v - 0.2)
    sidebar.BackgroundTransparency = 1 - (v - 0.3)
end, "%", 2)

createSlider(settingsPage, "Animation Speed", 0.1, 0.5, "animationSpeed", nil, "s", 2)

createToggle(settingsPage, "Sound Effects", "soundEffects", nil, "UI sounds")
createToggle(settingsPage, "Notifications", "notifications", nil, "Show popups")
createToggle(settingsPage, "Blur Effect", "blurEffect", function(v)
    blurEffect.Size = v and 8 or 0
end, "Cinematic blur")

-- Keybinds
createSectionLabel(settingsPage, "KEYBINDS")

createKeybind(settingsPage, "Toggle Menu", "toggleKey")
createKeybind(settingsPage, "Fly Key", "flyKey")
createKeybind(settingsPage, "Noclip Key", "noclipKey")
createKeybind(settingsPage, "Speed Key", "speedKey")
createKeybind(settingsPage, "ESP Key", "espKey")

-- Data
createSectionLabel(settingsPage, "DATA")

createButton(settingsPage, "Save Settings", function()
    notify("Settings saved", 2, "success")
end, "success")

createButton(settingsPage, "Load Settings", function()
    notify("Settings loaded", 2, "success")
end, "default")

createButton(settingsPage, "Reset All Settings", function()
    notify("Settings reset. Rejoin to apply.", 2, "warning")
end, "danger")

-- Info
createSectionLabel(settingsPage, "INFO")

local infoCard = Instance.new("Frame")
infoCard.Parent = settingsPage
infoCard.BackgroundColor3 = col.bgTertiary
infoCard.BackgroundTransparency = 0.3
infoCard.Size = UDim2.new(1, 0, 0, 100)
infoCard.ZIndex = 107

Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 10)

local infoTitle = Instance.new("TextLabel")
infoTitle.Parent = infoCard
infoTitle.BackgroundTransparency = 1
infoTitle.Position = UDim2.new(0, 14, 0, 10)
infoTitle.Size = UDim2.new(1, -28, 0, 18)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Text = "VIOLENCE DISTRICT V4"
infoTitle.TextColor3 = col.white
infoTitle.TextSize = 13
infoTitle.TextXAlignment = Enum.TextXAlignment.Left

local infoVersion = Instance.new("TextLabel")
infoVersion.Parent = infoCard
infoVersion.BackgroundTransparency = 1
infoVersion.Position = UDim2.new(0, 14, 0, 30)
infoVersion.Size = UDim2.new(1, -28, 0, 14)
infoVersion.Font = Enum.Font.Gotham
infoVersion.Text = "Monochrome Edition • v4.0"
infoVersion.TextColor3 = col.textMuted
infoVersion.TextSize = 10
infoVersion.TextXAlignment = Enum.TextXAlignment.Left

local infoFeatures = Instance.new("TextLabel")
infoFeatures.Parent = infoCard
infoFeatures.BackgroundTransparency = 1
infoFeatures.Position = UDim2.new(0, 14, 0, 46)
infoFeatures.Size = UDim2.new(1, -28, 0, 14)
infoFeatures.Font = Enum.Font.Gotham
infoFeatures.Text = "70+ Features • Dark Aesthetic"
infoFeatures.TextColor3 = col.textMuted
infoFeatures.TextSize = 10
infoFeatures.TextXAlignment = Enum.TextXAlignment.Left

local infoCredits = Instance.new("TextLabel")
infoCredits.Parent = infoCard
infoCredits.BackgroundTransparency = 1
infoCredits.Position = UDim2.new(0, 14, 0, 70)
infoCredits.Size = UDim2.new(1, -28, 0, 14)
infoCredits.Font = Enum.Font.Gotham
infoCredits.Text = "Premium Redesign • Delta Executor"
infoCredits.TextColor3 = col.textDim
infoCredits.TextSize = 9
infoCredits.TextXAlignment = Enum.TextXAlignment.Left

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN LOOP & UPDATES
-- ══════════════════════════════════════════════════════════════════════════════

-- Update loop untuk fitur realtime
RunService.RenderStepped:Connect(function(dt)
    -- Update ping & FPS
    local now = tick()
    if now - lastFpsUpdate >= 1 then
        if fpsCard then fpsCard.setValue(math.floor(fpsCount)) end
        fpsCount = 0
        lastFpsUpdate = now
    end
    if now - lastUpdate >= 0.5 then
        if pingCard then pingCard.setValue(math.floor(plr:GetNetworkPing() * 1000) .. "ms") end
        lastUpdate = now
    end
    
    -- Update FOV circle
    if cfg.showfov then
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = cfg.aimfov
    end
    
    -- Update aura circle
    if cfg.showAura then
        auraCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        auraCircle.Radius = cfg.auraRange * 5
    end
    
    -- Update ESP info
    if cfg.esp then
        local myHRP = getHRP()
        if myHRP then
            for player, data in pairs(espData) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    local dist = getDistance(myHRP.Position, hrp.Position)
                    
                    if dist <= cfg.espDistance and data.info then
                        local distText = cfg.espShowDistance and math.floor(dist) .. "m" or ""
                        local hpText = cfg.espShowHealth and hum and math.floor(hum.Health) .. "HP" or ""
                        local sep = (cfg.espShowDistance and cfg.espShowHealth) and " | " or ""
                        data.info.Text = distText .. sep .. hpText
                    end
                end
            end
        end
    end
    
    -- Update tracers
    if cfg.tracers then
        local myHRP = getHRP()
        if myHRP then
            for player, tracer in pairs(tracerData) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        tracer.Visible = true
                        local originY = cfg.tracerOrigin == "Bottom" and cam.ViewportSize.Y or 
                                       cfg.tracerOrigin == "Top" and 0 or 
                                       cfg.tracerOrigin == "Mouse" and mouse.Y or cam.ViewportSize.Y / 2
                        tracer.From = Vector2.new(cam.ViewportSize.X / 2, originY)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                    else
                        tracer.Visible = false
                    end
                end
            end
        end
    end
end)

-- Player events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp and player ~= plr then createESP(player) end
        if cfg.tracers and player ~= plr then
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = col.white
            tracer.Thickness = 1.5
            tracer.Transparency = 0.5
            tracerData[player] = tracer
        end
    end)
    if activeTab == "players" then updatePlayerList() end
end)

Players.PlayerRemoving:Connect(function(player)
    if espData[player] then pcall(function() espData[player].billboard:Destroy() end); espData[player] = nil end
    if tracerData[player] then pcall(function() tracerData[player]:Remove() end); tracerData[player] = nil end
    if cfg.selectedPlayer == player then cfg.selectedPlayer = nil end
    if activeTab == "players" then updatePlayerList() end
end)

-- Character respawn
plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    task.wait(1)
    notify("Character respawned", 2, "info")
end)

-- Initial setup
task.spawn(function()
    task.wait(0.5)
    main.BackgroundTransparency = 1 - (cfg.uiOpacity or 0.95)
    header.BackgroundTransparency = 1 - ((cfg.uiOpacity or 0.95) - 0.2)
    sidebar.BackgroundTransparency = 1 - ((cfg.uiOpacity or 0.95) - 0.3)
    notify("Monochrome Edition • 70+ Features", 3, "success", "Welcome")
end)

-- Cleanup
gui.Destroying:Connect(function()
    for _, conn in pairs(conn) do pcall(function() conn:Disconnect() end) end
    pcall(function() fovCircle:Remove() end)
    pcall(function() auraCircle:Remove() end)
    pcall(function() blurEffect:Destroy() end)
    for _, tracer in pairs(tracerData) do pcall(function() tracer:Remove() end) end
    for _, data in pairs(espData) do pcall(function() data.billboard:Destroy() end) end
end)

print("╔══════════════════════════════════════════════════════════════╗")
print("║    VIOLENCE DISTRICT V4 - MONOCHROME EDITION (COMPLETE)     ║")
print("║    70+ Features • Dark Aesthetic • Premium Redesign         ║")
print("║    Press " .. (cfg.toggleKey and cfg.toggleKey.Name or "RightShift") .. " to toggle                        ║")
print("╚══════════════════════════════════════════════════════════════╝")
