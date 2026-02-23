--- violence district v3
-- delta executor
-- auto save settings

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

-- ══════════════════════════════════════════════════════════════
-- SAVE/LOAD SYSTEM
-- ══════════════════════════════════════════════════════════════

local SAVE_FILE = "vd3_settings.json"

local function saveSettings()
    local data = {
        cfg = cfg,
        togglePos = {
            x = toggleBtn and toggleBtn.Position.X.Offset or 14,
            y = toggleBtn and toggleBtn.Position.Y.Scale or 0.5
        }
    }
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadSettings()
    local success, data = pcall(function()
        if isfile and isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
    end)
    if success and data then
        return data
    end
    return nil
end

local savedData = loadSettings()

local cfg = {
    esp = false, espMode = 1, espRgb = false,
    speedHack = false, speed = 50,
    noclip = false,
    god = false, godV2 = false, cloneOffset = -15,
    aim = false, aimfov = 100, showfov = false,
    silentAim = false, silentNoFov = false,
    killaura = false, auraRange = 15, showAura = false,
    hitChance = 100,
    invisible = false,
    fog = false, bright = false, fov = 70, antiAfk = false,
    selectedPlayer = nil,
    noRagdoll = false, infiniteStamina = false,
    antiVoid = false, lowGravity = false,
    xray = false, noParticles = false
}

-- Load saved config
if savedData and savedData.cfg then
    for k, v in pairs(savedData.cfg) do
        if cfg[k] ~= nil and type(v) ~= "userdata" then
            cfg[k] = v
        end
    end
end

local conn = {}
local espData = {}
local immortal = false
local defaultSpeed = 16
local defaultGravity = 196.2
local toggleRefs = {}

-- ══════════════════════════════════════════════════════════════
-- GOD MODE V2 - CLONE SYSTEM
-- ══════════════════════════════════════════════════════════════

local godV2System = {
    active = false,
    clone = nil,
    realBodyOffset = -15,
    conn = {},
    originalData = {}
}

local function createCloneHitbox(clone)
    for _, part in pairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function storeOriginalAppearance()
    godV2System.originalData = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            godV2System.originalData[part] = {
                transparency = part.Transparency,
                canCollide = part.CanCollide
            }
        elseif part:IsA("Decal") or part:IsA("Texture") then
            godV2System.originalData[part] = {
                transparency = part.Transparency
            }
        end
    end
end

local function hideRealBody()
    for part, data in pairs(godV2System.originalData) do
        if part and part.Parent then
            if part:IsA("BasePart") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
                part.CanCollide = false
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
    end
end

local function restoreRealBody()
    for part, data in pairs(godV2System.originalData) do
        if part and part.Parent then
            if part:IsA("BasePart") then
                part.Transparency = data.transparency
                part.CanCollide = data.canCollide
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = data.transparency
            end
        end
    end
    godV2System.originalData = {}
end

local function setupCloneHumanoid(cloneHum)
    if not cloneHum then return end
    
    cloneHum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    cloneHum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    cloneHum.MaxHealth = math.huge
    cloneHum.Health = math.huge
    cloneHum.BreakJointsOnDeath = false
    
    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function() 
            cloneHum:SetStateEnabled(state, false) 
        end)
    end
    
    cloneHum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    cloneHum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
    cloneHum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    cloneHum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    cloneHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    cloneHum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
end

local function enableGodV2()
    if godV2System.active then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then 
        notify("karakter tidak valid", 2, "error")
        return 
    end
    
    godV2System.active = true
    
    -- simpan posisi awal
    local startCF = hrp.CFrame
    
    -- buat clone karakter
    local clone = char:Clone()
    clone.Name = "Proxy_" .. tostring(plr.UserId) .. "_" .. math.random(1000, 9999)
    
    -- bersihkan script dari clone
    for _, obj in pairs(clone:GetDescendants()) do
        if obj:IsA("BaseScript") then
            obj.Enabled = false
            obj:Destroy()
        end
    end
    
    clone.Parent = Workspace
    
    local cloneHRP = clone:FindFirstChild("HumanoidRootPart")
    local cloneHum = clone:FindFirstChildOfClass("Humanoid")
    
    if not cloneHRP or not cloneHum then
        clone:Destroy()
        godV2System.active = false
        notify("gagal membuat clone", 2, "error")
        return
    end
    
    -- posisikan clone
    cloneHRP.CFrame = startCF
    
    -- setup clone humanoid
    setupCloneHumanoid(cloneHum)
    createCloneHitbox(clone)
    
    -- simpan dan sembunyikan tubuh asli
    storeOriginalAppearance()
    hideRealBody()
    
    -- switch kamera ke clone
    cam.CameraSubject = cloneHum
    
    -- koneksi untuk menjaga clone tetap hidup
    godV2System.conn.immortal = RunService.Heartbeat:Connect(function()
        if not clone or not clone.Parent then return end
        
        local ch = clone:FindFirstChildOfClass("Humanoid")
        if ch then
            if ch.Health ~= math.huge then
                ch.Health = math.huge
            end
            
            if ch:GetState() == Enum.HumanoidStateType.Dead then
                ch:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
    
    -- koneksi untuk sinkronisasi posisi
    godV2System.conn.position = RunService.Heartbeat:Connect(function()
        if not clone or not clone.Parent then
            if cfg.godV2 then
                disableGodV2()
            end
            return
        end
        
        local realHRP = char:FindFirstChild("HumanoidRootPart")
        local cloneHRP = clone:FindFirstChild("HumanoidRootPart")
        
        if realHRP and cloneHRP then
            -- tubuh asli mengikuti di bawah clone
            local clonePos = cloneHRP.Position
            local cloneRot = cloneHRP.CFrame - cloneHRP.CFrame.Position
            
            realHRP.CFrame = CFrame.new(
                clonePos.X,
                clonePos.Y + godV2System.realBodyOffset,
                clonePos.Z
            ) * cloneRot
            
            -- netralkan velocity tubuh asli
            realHRP.Velocity = Vector3.zero
            pcall(function()
                realHRP.AssemblyLinearVelocity = Vector3.zero
                realHRP.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
    
    -- koneksi untuk kontrol pergerakan clone
    godV2System.conn.movement = RunService.RenderStepped:Connect(function()
        if not clone or not clone.Parent then return end
        
        local cloneHum = clone:FindFirstChildOfClass("Humanoid")
        local realHum = char:FindFirstChildOfClass("Humanoid")
        
        if cloneHum and realHum then
            -- transfer input pergerakan ke clone
            cloneHum:Move(realHum.MoveDirection, false)
            
            -- sinkronkan kecepatan
            local targetSpeed = cfg.speedHack and cfg.speed or defaultSpeed
            cloneHum.WalkSpeed = targetSpeed
            cloneHum.JumpPower = realHum.JumpPower
        end
    end)
    
    -- koneksi untuk input lompat
    godV2System.conn.jump = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            if clone and clone.Parent then
                local cloneHum = clone:FindFirstChildOfClass("Humanoid")
                if cloneHum then
                    cloneHum.Jump = true
                end
            end
        end
    end)
    
    -- handle jika clone dihancurkan secara eksternal
    godV2System.conn.destroyed = clone.AncestryChanged:Connect(function(_, parent)
        if not parent and godV2System.active then
            task.spawn(function()
                task.wait(0.1)
                if cfg.godV2 and godV2System.active then
                    -- recreate clone
                    disableGodV2()
                    task.wait(0.2)
                    enableGodV2()
                end
            end)
        end
    end)
    
    godV2System.clone = clone
end

local function disableGodV2()
    if not godV2System.active then return end
    godV2System.active = false
    
    -- putuskan semua koneksi
    for key, connection in pairs(godV2System.conn) do
        if connection then
            pcall(function() connection:Disconnect() end)
        end
    end
    godV2System.conn = {}
    
    -- ambil posisi clone sebelum dihancurkan
    local restorePos = nil
    if godV2System.clone and godV2System.clone.Parent then
        local cloneHRP = godV2System.clone:FindFirstChild("HumanoidRootPart")
        if cloneHRP then
            restorePos = cloneHRP.CFrame
        end
    end
    
    -- hancurkan clone
    if godV2System.clone then
        pcall(function() 
            godV2System.clone:Destroy() 
        end)
        godV2System.clone = nil
    end
    
    -- kembalikan tampilan tubuh asli
    restoreRealBody()
    
    -- kembalikan kamera
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        cam.CameraSubject = hum
    end
    
    -- kembalikan posisi
    if restorePos then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = restorePos
        end
    end
end

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

local col = {
    bg = Color3.fromRGB(15, 15, 18),
    surface = Color3.fromRGB(22, 22, 26),
    card = Color3.fromRGB(28, 28, 34),
    cardHover = Color3.fromRGB(38, 38, 46),
    elevated = Color3.fromRGB(35, 35, 42),
    border = Color3.fromRGB(45, 45, 55),
    borderLight = Color3.fromRGB(60, 60, 72),
    text = Color3.fromRGB(225, 225, 230),
    textMuted = Color3.fromRGB(145, 145, 158),
    textDim = Color3.fromRGB(85, 85, 98),
    accent = Color3.fromRGB(95, 125, 160),
    accentDim = Color3.fromRGB(65, 90, 120),
    accentGlow = Color3.fromRGB(120, 150, 190),
    on = Color3.fromRGB(80, 150, 110),
    onDim = Color3.fromRGB(55, 105, 80),
    onGlow = Color3.fromRGB(100, 180, 130),
    off = Color3.fromRGB(50, 50, 60),
    danger = Color3.fromRGB(150, 70, 75),
    warn = Color3.fromRGB(160, 135, 70)
}

local tweenFast = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenMed = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenSlow = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenBounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local gui = Instance.new("ScreenGui")
gui.Name = "vd_v4" .. math.random(1000, 9999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ══════════════════════════════════════════════════════════════
-- DRAGGABLE TOGGLE BUTTON
-- ══════════════════════════════════════════════════════════════

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.ZIndex = 100

-- Load saved position
if savedData and savedData.togglePos then
    toggleBtn.Position = UDim2.new(0, savedData.togglePos.x, savedData.togglePos.y, -20)
else
    toggleBtn.Position = UDim2.new(0, 14, 0.5, -20)
end
toggleBtn.Size = UDim2.new(0, 40, 0, 40)

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = col.border
toggleStroke.Thickness = 1.5
toggleStroke.Transparency = 0.3

local toggleGlow = Instance.new("ImageLabel", toggleBtn)
toggleGlow.BackgroundTransparency = 1
toggleGlow.Size = UDim2.new(1, 30, 1, 30)
toggleGlow.Position = UDim2.new(0, -15, 0, -15)
toggleGlow.Image = "rbxassetid://5028857084"
toggleGlow.ImageColor3 = col.accent
toggleGlow.ImageTransparency = 0.85
toggleGlow.ZIndex = 99

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Text = "IXU"
toggleIcon.TextColor3 = col.textMuted
toggleIcon.TextSize = 20
toggleIcon.ZIndex = 101

-- Custom Drag System
local dragging = false
local dragStart = nil
local startPos = nil
local lastClick = 0

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        lastClick = tick()
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        -- Save position after drag
        task.spawn(saveSettings)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, cam.ViewportSize.X - 50)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, -cam.ViewportSize.Y/2 + 30, cam.ViewportSize.Y/2 - 30)
        toggleBtn.Position = UDim2.new(0, newX, startPos.Y.Scale, newY)
    end
end)

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, tweenFast, {Color = col.accentGlow, Transparency = 0}):Play()
    TweenService:Create(toggleIcon, tweenFast, {TextColor3 = col.text}):Play()
    TweenService:Create(toggleBtn, tweenFast, {Size = UDim2.new(0, 44, 0, 44)}):Play()
    TweenService:Create(toggleGlow, tweenFast, {ImageTransparency = 0.6}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, tweenFast, {Color = col.border, Transparency = 0.3}):Play()
    TweenService:Create(toggleIcon, tweenFast, {TextColor3 = col.textMuted}):Play()
    TweenService:Create(toggleBtn, tweenFast, {Size = UDim2.new(0, 40, 0, 40)}):Play()
    TweenService:Create(toggleGlow, tweenFast, {ImageTransparency = 0.85}):Play()
end)

-- Main Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = col.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true
main.BackgroundTransparency = 1
main.ZIndex = 10

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = col.border
mainStroke.Thickness = 1.5
mainStroke.Transparency = 1

local mainGlow = Instance.new("ImageLabel", main)
mainGlow.BackgroundTransparency = 1
mainGlow.Size = UDim2.new(1, 60, 1, 60)
mainGlow.Position = UDim2.new(0, -30, 0, -30)
mainGlow.Image = "rbxassetid://5028857084"
mainGlow.ImageColor3 = col.accent
mainGlow.ImageTransparency = 1
mainGlow.ZIndex = 9

local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = col.surface
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 0.3
header.ZIndex = 12

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = col.surface
headerFix.BackgroundTransparency = 0.3
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.ZIndex = 12

local headerLine = Instance.new("Frame", header)
headerLine.BackgroundColor3 = col.border
headerLine.BackgroundTransparency = 0.5
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.ZIndex = 12

local titleLabel = Instance.new("TextLabel", header)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "ikaxu premium"
titleLabel.TextColor3 = col.text
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 13

local versionBadge = Instance.new("Frame", header)
versionBadge.BackgroundColor3 = col.accent
versionBadge.BackgroundTransparency = 0.8
versionBadge.Position = UDim2.new(0, 130, 0.5, -8)
versionBadge.Size = UDim2.new(0, 24, 0, 16)
versionBadge.ZIndex = 13
Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0, 4)

local versionLabel = Instance.new("TextLabel", versionBadge)
versionLabel.BackgroundTransparency = 1
versionLabel.Size = UDim2.new(1, 0, 1, 0)
versionLabel.Font = Enum.Font.GothamBold
versionLabel.Text = "v4"
versionLabel.TextColor3 = col.accent
versionLabel.TextSize = 9
versionLabel.ZIndex = 14

local closeBtn = Instance.new("TextButton", header)
closeBtn.BackgroundColor3 = col.danger
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = col.textDim
closeBtn.TextSize = 18
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 13
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, tweenFast, {BackgroundTransparency = 0.7, TextColor3 = col.danger}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, tweenFast, {BackgroundTransparency = 1, TextColor3 = col.textDim}):Play()
end)

local minBtn = Instance.new("TextButton", header)
minBtn.BackgroundColor3 = col.warn
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -62, 0, 6)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = col.textDim
minBtn.TextSize = 16
minBtn.AutoButtonColor = false
minBtn.ZIndex = 13
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, tweenFast, {BackgroundTransparency = 0.7, TextColor3 = col.warn}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, tweenFast, {BackgroundTransparency = 1, TextColor3 = col.textDim}):Play()
end)

local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = col.surface
sidebar.BackgroundTransparency = 0.5
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.Size = UDim2.new(0, 95, 1, -36)
sidebar.ZIndex = 11

local sidebarLine = Instance.new("Frame", sidebar)
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BackgroundTransparency = 0.5
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.ZIndex = 11

local tabList = Instance.new("Frame", sidebar)
tabList.BackgroundTransparency = 1
tabList.Position = UDim2.new(0, 6, 0, 10)
tabList.Size = UDim2.new(1, -12, 1, -20)
tabList.ZIndex = 12

local tabListLayout = Instance.new("UIListLayout", tabList)
tabListLayout.Padding = UDim.new(0, 4)

local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 103, 0, 44)
content.Size = UDim2.new(1, -111, 1, -52)
content.ZIndex = 11

local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifs"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -240, 0, 12)
notifContainer.Size = UDim2.new(0, 230, 0, 220)

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 6)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(msg, dur, notifType)
    local notifCol = col.accent
    if notifType == "success" then notifCol = col.on
    elseif notifType == "error" then notifCol = col.danger
    elseif notifType == "warn" then notifCol = col.warn end

    local n = Instance.new("Frame", notifContainer)
    n.BackgroundColor3 = col.surface
    n.BorderSizePixel = 0
    n.Size = UDim2.new(0, 0, 0, 32)
    n.ClipsDescendants = true
    n.BackgroundTransparency = 0.1

    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    
    local nStroke = Instance.new("UIStroke", n)
    nStroke.Color = notifCol
    nStroke.Thickness = 1
    nStroke.Transparency = 0.7

    local accent = Instance.new("Frame", n)
    accent.BackgroundColor3 = notifCol
    accent.BorderSizePixel = 0
    accent.Size = UDim2.new(0, 3, 1, 0)
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 8)

    local icon = Instance.new("TextLabel", n)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.Size = UDim2.new(0, 20, 1, 0)
    icon.Font = Enum.Font.GothamBold
    icon.Text = notifType == "success" and "✓" or notifType == "error" and "✕" or notifType == "warn" and "!" or "●"
    icon.TextColor3 = notifCol
    icon.TextSize = 12

    local t = Instance.new("TextLabel", n)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 32, 0, 0)
    t.Size = UDim2.new(1, -40, 1, 0)
    t.Font = Enum.Font.GothamMedium
    t.Text = msg
    t.TextColor3 = col.text
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTransparency = 1

    TweenService:Create(n, tweenBounce, {Size = UDim2.new(0, 210, 0, 32)}):Play()
    task.delay(0.1, function()
        TweenService:Create(t, tweenFast, {TextTransparency = 0}):Play()
        TweenService:Create(nStroke, tweenFast, {Transparency = 0.3}):Play()
    end)

    task.delay(dur or 2.5, function()
        TweenService:Create(t, tweenFast, {TextTransparency = 1}):Play()
        TweenService:Create(n, tweenMed, {Size = UDim2.new(0, 0, 0, 32), BackgroundTransparency = 1}):Play()
        task.wait(0.25)
        n:Destroy()
    end)
end

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.Color = col.accent
fovCircle.Transparency = 0.5
fovCircle.NumSides = 60
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1.5
auraCircle.Color = Color3.fromRGB(140, 90, 90)
auraCircle.Transparency = 0.4
auraCircle.NumSides = 60
auraCircle.Filled = false

local pages = {}
local tabButtons = {}
local activeTab = nil

local tabs = {
    {id = "home", name = "home", icon = "◆"},
    {id = "combat", name = "combat", icon = "⚔"},
    {id = "move", name = "movement", icon = "➤"},
    {id = "visual", name = "visuals", icon = "◐"},
    {id = "esp", name = "esp", icon = "◎"},
    {id = "players", name = "players", icon = "♦"},
}

local function createPage(id)
    local page = Instance.new("ScrollingFrame")
    page.Name = id
    page.Parent = content
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = col.accent
    page.ScrollBarImageTransparency = 0.5
    page.Visible = false
    page.ZIndex = 12

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 5)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    pages[id] = page
    return page
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabList
    btn.BackgroundColor3 = col.card
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 13

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local ind = Instance.new("Frame", btn)
    ind.Name = "Ind"
    ind.BackgroundColor3 = col.accent
    ind.BorderSizePixel = 0
    ind.Position = UDim2.new(0, 0, 0.5, -6)
    ind.Size = UDim2.new(0, 3, 0, 0)
    ind.ZIndex = 13
    Instance.new("UICorner", ind).CornerRadius = UDim.new(0, 2)

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.Size = UDim2.new(0, 16, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = tab.icon
    iconLabel.TextColor3 = col.textDim
    iconLabel.TextSize = 10
    iconLabel.ZIndex = 14

    local textLabel = Instance.new("TextLabel", btn)
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 26, 0, 0)
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.Text = tab.name
    textLabel.TextColor3 = col.textDim
    textLabel.TextSize = 10
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 14

    local page = createPage(tab.id)
    tabButtons[tab.id] = {btn = btn, icon = iconLabel, text = textLabel, ind = ind}

    btn.MouseButton1Click:Connect(function()
        for id, data in pairs(tabButtons) do
            TweenService:Create(data.btn, tweenFast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.icon, tweenFast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.text, tweenFast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.ind, tweenMed, {Size = UDim2.new(0, 3, 0, 0)}):Play()
            pages[id].Visible = false
        end

        TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.6}):Play()
        TweenService:Create(iconLabel, tweenFast, {TextColor3 = col.accent}):Play()
        TweenService:Create(textLabel, tweenFast, {TextColor3 = col.text}):Play()
        TweenService:Create(ind, tweenBounce, {Size = UDim2.new(0, 3, 0, 12)}):Play()
        page.Visible = true
        activeTab = tab.id
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.75}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, tweenFast, {BackgroundTransparency = 1}):Play()
        end
    end)

    if i == 1 then
        btn.BackgroundTransparency = 0.6
        iconLabel.TextColor3 = col.accent
        textLabel.TextColor3 = col.text
        ind.Size = UDim2.new(0, 3, 0, 12)
        page.Visible = true
        activeTab = tab.id
    end
end

local function sectionLabel(parent, text)
    local c = Instance.new("Frame", parent)
    c.BackgroundTransparency = 1
    c.Size = UDim2.new(1, 0, 0, 20)
    c.ZIndex = 13

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 4, 0, 0)
    l.Size = UDim2.new(1, -8, 1, 0)
    l.Font = Enum.Font.GothamBold
    l.Text = text:upper()
    l.TextColor3 = col.textDim
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 13
end

local function createToggle(parent, text, cfgKey, callback)
    local state = cfg[cfgKey] or false

    local c = Instance.new("TextButton", parent)
    c.BackgroundColor3 = col.card
    c.BackgroundTransparency = 0.3
    c.BorderSizePixel = 0
    c.Size = UDim2.new(1, 0, 0, 34)
    c.Text = ""
    c.AutoButtonColor = false
    c.ZIndex = 13

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)

    local cStroke = Instance.new("UIStroke", c)
    cStroke.Color = col.border
    cStroke.Thickness = 1
    cStroke.Transparency = 0.8

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Font = Enum.Font.GothamMedium
    l.Text = text
    l.TextColor3 = col.textMuted
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 14

    local sw = Instance.new("Frame", c)
    sw.AnchorPoint = Vector2.new(1, 0.5)
    sw.BackgroundColor3 = col.off
    sw.BorderSizePixel = 0
    sw.Position = UDim2.new(1, -12, 0.5, 0)
    sw.Size = UDim2.new(0, 32, 0, 16)
    sw.ZIndex = 14

    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local k = Instance.new("Frame", sw)
    k.AnchorPoint = Vector2.new(0, 0.5)
    k.BackgroundColor3 = col.textDim
    k.BorderSizePixel = 0
    k.Position = UDim2.new(0, 2, 0.5, 0)
    k.Size = UDim2.new(0, 12, 0, 12)
    k.ZIndex = 15

    Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)

    local function updateVisual()
        if state then
            sw.BackgroundColor3 = col.onDim
            k.Position = UDim2.new(1, -14, 0.5, 0)
            k.BackgroundColor3 = col.onGlow
            l.TextColor3 = col.text
            cStroke.Color = col.onDim
        else
            sw.BackgroundColor3 = col.off
            k.Position = UDim2.new(0, 2, 0.5, 0)
            k.BackgroundColor3 = col.textDim
            l.TextColor3 = col.textMuted
            cStroke.Color = col.border
        end
    end

    local function toggle(noSave)
        state = not state
        cfg[cfgKey] = state
        
        if state then
            TweenService:Create(sw, tweenMed, {BackgroundColor3 = col.onDim}):Play()
            TweenService:Create(k, tweenBounce, {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = col.onGlow}):Play()
            TweenService:Create(l, tweenFast, {TextColor3 = col.text}):Play()
            TweenService:Create(cStroke, tweenFast, {Color = col.onDim}):Play()
        else
            TweenService:Create(sw, tweenMed, {BackgroundColor3 = col.off}):Play()
            TweenService:Create(k, tweenBounce, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = col.textDim}):Play()
            TweenService:Create(l, tweenFast, {TextColor3 = col.textMuted}):Play()
            TweenService:Create(cStroke, tweenFast, {Color = col.border}):Play()
        end
        
        pcall(callback, state)
        if not noSave then task.spawn(saveSettings) end
    end

    c.MouseButton1Click:Connect(function() toggle(false) end)

    c.MouseEnter:Connect(function()
        TweenService:Create(c, tweenFast, {BackgroundTransparency = 0.1}):Play()
    end)
    c.MouseLeave:Connect(function()
        TweenService:Create(c, tweenFast, {BackgroundTransparency = 0.3}):Play()
    end)

    -- Initialize visual state
    updateVisual()

    local ref = {
        setState = function(v, noCallback)
            state = v
            cfg[cfgKey] = v
            updateVisual()
            if not noCallback then pcall(callback, state) end
        end,
        getState = function() return state end,
        apply = function() if state then pcall(callback, true) end end
    }
    
    toggleRefs[cfgKey] = ref
    return ref
end

local function createSlider(parent, text, min, max, cfgKey, callback)
    local val = cfg[cfgKey] or min
    local drag = false

    local c = Instance.new("Frame", parent)
    c.BackgroundColor3 = col.card
    c.BackgroundTransparency = 0.3
    c.BorderSizePixel = 0
    c.Size = UDim2.new(1, 0, 0, 44)
    c.ZIndex = 13

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)

    local l = Instance.new("TextLabel", c)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 14, 0, 4)
    l.Size = UDim2.new(0.6, 0, 0, 14)
    l.Font = Enum.Font.GothamMedium
    l.Text = text
    l.TextColor3 = col.textMuted
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 14

    local vBg = Instance.new("Frame", c)
    vBg.BackgroundColor3 = col.accent
    vBg.BackgroundTransparency = 0.85
    vBg.Position = UDim2.new(1, -44, 0, 5)
    vBg.Size = UDim2.new(0, 32, 0, 16)
    vBg.ZIndex = 14
    Instance.new("UICorner", vBg).CornerRadius = UDim.new(0, 4)

    local v = Instance.new("TextLabel", vBg)
    v.BackgroundTransparency = 1
    v.Size = UDim2.new(1, 0, 1, 0)
    v.Font = Enum.Font.GothamBold
    v.Text = tostring(val)
    v.TextColor3 = col.accent
    v.TextSize = 10
    v.ZIndex = 15

    local track = Instance.new("Frame", c)
    track.BackgroundColor3 = col.elevated
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 14, 0, 28)
    track.Size = UDim2.new(1, -28, 0, 6)
    track.ZIndex = 14

    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = col.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.ZIndex = 15

    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local hit = Instance.new("TextButton", track)
    hit.BackgroundTransparency = 1
    hit.Size = UDim2.new(1, 0, 1, 10)
    hit.Position = UDim2.new(0, 0, 0, -5)
    hit.Text = ""
    hit.ZIndex = 16

    local function upd(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pos)
        cfg[cfgKey] = val
        TweenService:Create(fill, tweenFast, {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        v.Text = tostring(val)
        pcall(callback, val)
    end

    hit.MouseButton1Down:Connect(function() drag = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if drag then
                drag = false
                task.spawn(saveSettings)
            end
        end
    end)
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            upd(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            upd(input)
        end
    end)
end

local function createButton(parent, text, callback, icon)
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3 = col.card
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Size = UDim2.new(1, 0, 0, 32)
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 13

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    if icon then
        local iconLbl = Instance.new("TextLabel", b)
        iconLbl.BackgroundTransparency = 1
        iconLbl.Position = UDim2.new(0, 12, 0, 0)
        iconLbl.Size = UDim2.new(0, 16, 1, 0)
        iconLbl.Font = Enum.Font.GothamBold
        iconLbl.Text = icon
        iconLbl.TextColor3 = col.accent
        iconLbl.TextSize = 11
        iconLbl.ZIndex = 14
    end

    local textLbl = Instance.new("TextLabel", b)
    textLbl.BackgroundTransparency = 1
    textLbl.Position = UDim2.new(0, icon and 30 or 14, 0, 0)
    textLbl.Size = UDim2.new(1, icon and -44 or -28, 1, 0)
    textLbl.Font = Enum.Font.GothamMedium
    textLbl.Text = text
    textLbl.TextColor3 = col.textMuted
    textLbl.TextSize = 11
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.ZIndex = 14

    b.MouseButton1Click:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
        task.wait(0.05)
        TweenService:Create(b, tweenFast, {BackgroundTransparency = 0.3}):Play()
        pcall(callback)
    end)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, tweenFast, {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(textLbl, tweenFast, {TextColor3 = col.text}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, tweenFast, {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(textLbl, tweenFast, {TextColor3 = col.textMuted}):Play()
    end)

    return b
end

-- ══════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ══════════════════════════════════════════════════════════════

local function clearESP()
    for player, data in pairs(espData) do
        pcall(function()
            if data.obj then
                if typeof(data.obj) == "Instance" then data.obj:Destroy()
                else data.obj:Remove() end
            end
        end)
    end
    espData = {}
end

local function enableGod()
    if immortal then return end
    immortal = true

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.Name = "H" .. math.random(100, 999)
    hum.BreakJointsOnDeath = false

    for _, st in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function() hum:SetStateEnabled(st, false) end)
    end
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    conn.godH = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
    end)

    conn.godL = RunService.Heartbeat:Connect(function()
        if hum.Health ~= math.huge then hum.Health = math.huge end
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function disableGod()
    if not immortal then return end
    immortal = false

    if conn.godH then conn.godH:Disconnect() end
    if conn.godL then conn.godL:Disconnect() end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Name = "Humanoid"
        hum.MaxHealth = 100
        hum.Health = 100
    end
end

local function getClosestInFOV()
    local closest = nil
    local minD = cfg.aimfov
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < minD then
                        closest = p
                        minD = d
                    end
                end
            end
        end
    end
    return closest
end

local function getClosestPlayer()
    local closest = nil
    local minD = math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < minD then
                        closest = p
                        minD = d
                    end
                end
            end
        end
    end
    return closest
end

local function fireHit(target)
    if not target or not target.Character then return end
    
    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local n = r.Name:lower()
            if n:find("attack") or n:find("hit") or n:find("damage") then
                pcall(function() r:FireServer(target.Character) end)
            end
        end
    end
end

local function setupAntiAFK()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function teleportToPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        end
    end
end

local function createESP(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local isSel = (cfg.selectedPlayer == player)
    local selCol = Color3.fromRGB(180, 160, 100)
    
    if cfg.espMode == 1 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 60, 0, 22)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = isSel and selCol or col.bg
        bg.BackgroundTransparency = 0.3
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 5)

        local nm = Instance.new("TextLabel", bg)
        nm.Size = UDim2.new(1, 0, 0.55, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBold
        nm.Text = player.Name
        nm.TextColor3 = col.text
        nm.TextScaled = true

        local dst = Instance.new("TextLabel", bg)
        dst.Position = UDim2.new(0, 0, 0.55, 0)
        dst.Size = UDim2.new(1, 0, 0.45, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = col.textMuted
        dst.TextScaled = true

        espData[player] = {obj = bb, dist = dst, type = "nametag"}

    elseif cfg.espMode == 2 then
        local hl = Instance.new("Highlight", ch)
        hl.FillColor = isSel and selCol or col.accent
        hl.OutlineColor = isSel and selCol or col.text
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.4

        espData[player] = {obj = hl, type = "highlight"}

    elseif cfg.espMode == 3 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSel and selCol or col.accent
        box.Transparency = 0.5

        espData[player] = {obj = box, type = "box"}
    end
end

local function updateESP()
    local localHRP = char and char:FindFirstChild("HumanoidRootPart")
    
    for player, data in pairs(espData) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end
        
        local hrp = player.Character.HumanoidRootPart
        local dist = localHRP and (hrp.Position - localHRP.Position).Magnitude or 0

        if data.dist then data.dist.Text = math.floor(dist) .. "m" end

        if cfg.espRgb then
            local rainbow = Color3.fromHSV(tick() % 6 / 6, 0.5, 0.85)
            if data.type == "box" then data.obj.Color3 = rainbow
            elseif data.type == "highlight" then data.obj.FillColor = rainbow end
        end
    end
end

-- ══════════════════════════════════════════════════════════════
-- HOME TAB
-- ══════════════════════════════════════════════════════════════
local homePage = pages["home"]

sectionLabel(homePage, "player")

local pCard = Instance.new("Frame", homePage)
pCard.BackgroundColor3 = col.card
pCard.BackgroundTransparency = 0.2
pCard.BorderSizePixel = 0
pCard.Size = UDim2.new(1, 0, 0, 55)
pCard.ZIndex = 13
Instance.new("UICorner", pCard).CornerRadius = UDim.new(0, 10)

local avatar = Instance.new("ImageLabel", pCard)
avatar.BackgroundColor3 = col.elevated
avatar.BorderSizePixel = 0
avatar.Position = UDim2.new(0, 10, 0.5, 0)
avatar.AnchorPoint = Vector2.new(0, 0.5)
avatar.Size = UDim2.new(0, 36, 0, 36)
avatar.ZIndex = 14
Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 8)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local pName = Instance.new("TextLabel", pCard)
pName.BackgroundTransparency = 1
pName.Position = UDim2.new(0, 54, 0, 10)
pName.Size = UDim2.new(1, -60, 0, 16)
pName.Font = Enum.Font.GothamBold
pName.Text = plr.Name
pName.TextColor3 = col.text
pName.TextSize = 13
pName.TextXAlignment = Enum.TextXAlignment.Left
pName.ZIndex = 14

local gName = Instance.new("TextLabel", pCard)
gName.BackgroundTransparency = 1
gName.Position = UDim2.new(0, 54, 0, 28)
gName.Size = UDim2.new(1, -60, 0, 14)
gName.Font = Enum.Font.GothamMedium
gName.Text = "@ violence district"
gName.TextColor3 = col.textDim
gName.TextSize = 10
gName.TextXAlignment = Enum.TextXAlignment.Left
gName.ZIndex = 14

sectionLabel(homePage, "quick actions")

createButton(homePage, "reset character", function()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    notify("character reset", 2, "success")
end, "↺")

createButton(homePage, "rejoin server", function()
    notify("rejoining...", 2, "warn")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, "⟳")

createButton(homePage, "server hop", function()
    notify("finding server...", 2, "warn")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, "⇄")

createButton(homePage, "copy server id", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("server id copied!", 2, "success")
    else
        notify("not supported", 2, "error")
    end
end, "⎘")

sectionLabel(homePage, "character mods")

createToggle(homePage, "no ragdoll", "noRagdoll", function(v)
    if v then
        conn.noRagdoll = RunService.Heartbeat:Connect(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end)
        notify("no ragdoll on", 2, "success")
    else
        if conn.noRagdoll then conn.noRagdoll:Disconnect() end
        notify("no ragdoll off", 2)
    end
end)

createToggle(homePage, "infinite stamina", "infiniteStamina", function(v)
    if v then
        conn.stamina = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(plr.PlayerGui:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    if obj.Name:lower():find("stamina") then
                        obj.Value = 100
                    end
                end
            end
        end)
        notify("infinite stamina on", 2, "success")
    else
        if conn.stamina then conn.stamina:Disconnect() end
        notify("infinite stamina off", 2)
    end
end)

createToggle(homePage, "anti void", "antiVoid", function(v)
    if v then
        local safePos = char.HumanoidRootPart.CFrame
        conn.antiVoid = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp.Position.Y > -50 then safePos = hrp.CFrame end
                if hrp.Position.Y < -100 then hrp.CFrame = safePos end
            end
        end)
        notify("anti void on", 2, "success")
    else
        if conn.antiVoid then conn.antiVoid:Disconnect() end
        notify("anti void off", 2)
    end
end)

createToggle(homePage, "low gravity", "lowGravity", function(v)
    Workspace.Gravity = v and 50 or defaultGravity
    notify(v and "low gravity on" or "gravity normal", 2, v and "success" or nil)
end)

sectionLabel(homePage, "utility")

createToggle(homePage, "anti afk", "antiAfk", function(v)
    if v then setupAntiAFK() notify("anti afk on", 2, "success")
    else notify("anti afk off", 2) end
end)

createToggle(homePage, "x-ray walls", "xray", function(v)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            if obj.Name:lower():find("wall") or obj.Name:lower():find("door") then
                if v then
                    if not obj:GetAttribute("OT") then obj:SetAttribute("OT", obj.Transparency) end
                    obj.Transparency = 0.7
                else
                    local orig = obj:GetAttribute("OT")
                    if orig then obj.Transparency = orig end
                end
            end
        end
    end
    notify(v and "x-ray on" or "x-ray off", 2, v and "success" or nil)
end)

createToggle(homePage, "no particles", "noParticles", function(v)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") then
            obj.Enabled = not v
        end
    end
    notify(v and "particles off" or "particles on", 2, v and "success" or nil)
end)

createButton(homePage, "freeze character", function()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = not hrp.Anchored
        notify(hrp.Anchored and "frozen" or "unfrozen", 2, "success")
    end
end, "❄")

createButton(homePage, "teleport to spawn", function()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        notify("teleported", 2, "success")
    end
end, "⌂")

createButton(homePage, "heal character", function()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = hum.MaxHealth notify("healed", 2, "success") end
end, "+")

-- ══════════════════════════════════════════════════════════════
-- COMBAT TAB
-- ══════════════════════════════════════════════════════════════
local combatPage = pages["combat"]

sectionLabel(combatPage, "protection")
createToggle(combatPage, "god mode", "god", function(v)
    if v then enableGod() notify("god mode on", 2, "success")
    else disableGod() notify("god mode off", 2) end
end)

sectionLabel(combatPage, "protection")

createToggle(combatPage, "god mode", "god", function(v)
    if v then enableGod() notify("god mode on", 2, "success")
    else disableGod() notify("god mode off", 2) end
end)

-- TAMBAHKAN INI SETELAH GOD MODE BIASA
createToggle(combatPage, "god mode v2 (clone)", "godV2", function(v)
    if v then 
        enableGodV2() 
        notify("clone mode aktif", 2, "success")
    else 
        disableGodV2() 
        notify("clone mode nonaktif", 2)
    end
end)

createSlider(combatPage, "clone offset (y)", -30, -5, "cloneOffset", function(v)
    godV2System.realBodyOffset = v
end)

sectionLabel(combatPage, "aimbot")
createToggle(combatPage, "auto aim", "aim", function(v)
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
        notify("auto aim on", 2, "success")
    else
        if conn.aim then conn.aim:Disconnect() end
        notify("auto aim off", 2)
    end
end)

createToggle(combatPage, "show fov", "showfov", function(v)
    fovCircle.Visible = v
end)

createSlider(combatPage, "fov size", 50, 350, "aimfov", function(v) end)

sectionLabel(combatPage, "silent aim")
createToggle(combatPage, "silent aim (fov)", "silentAim", function(v)
    if v then
        conn.silentAim = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestInFOV()
                if target then fireHit(target) end
            end
        end)
        notify("silent aim on", 2, "success")
    else
        if conn.silentAim then conn.silentAim:Disconnect() end
        notify("silent aim off", 2)
    end
end)

createToggle(combatPage, "silent aim (no fov)", "silentNoFov", function(v)
    if v then
        conn.silentNoFov = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestPlayer()
                if target then fireHit(target) end
            end
        end)
        notify("silent aim on", 2, "success")
    else
        if conn.silentNoFov then conn.silentNoFov:Disconnect() end
        notify("silent aim off", 2)
    end
end)

sectionLabel(combatPage, "kill aura")
createToggle(combatPage, "kill aura", "killaura", function(v)
    if v then
        conn.aura = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d <= cfg.auraRange and math.random(1, 100) <= cfg.hitChance then
                        fireHit(p)
                    end
                end
            end
        end)
        notify("kill aura on", 2, "success")
    else
        if conn.aura then conn.aura:Disconnect() end
        notify("kill aura off", 2)
    end
end)

createToggle(combatPage, "show aura range", "showAura", function(v)
    auraCircle.Visible = v
end)

createSlider(combatPage, "aura range", 10, 30, "auraRange", function(v) end)
createSlider(combatPage, "hit chance %", 50, 100, "hitChance", function(v) end)

-- ══════════════════════════════════════════════════════════════
-- MOVEMENT TAB
-- ══════════════════════════════════════════════════════════════
local movePage = pages["move"]

sectionLabel(movePage, "speed")
createToggle(movePage, "speed hack", "speedHack", function(v)
    if not v then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = defaultSpeed end
    end
    notify(v and "speed hack on" or "speed hack off", 2, v and "success" or nil)
end)

createSlider(movePage, "walk speed", 16, 300, "speed", function(v) end)

sectionLabel(movePage, "other")
createToggle(movePage, "noclip", "noclip", function(v)
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
        notify("noclip on", 2, "success")
    else
        if conn.noclip then conn.noclip:Disconnect() end
        notify("noclip off", 2)
    end
end)

-- ══════════════════════════════════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════════════════════════════════
local visualPage = pages["visual"]

sectionLabel(visualPage, "world")
createToggle(visualPage, "no fog", "fog", function(v)
    Lighting.FogEnd = v and 100000 or 1000
    notify(v and "fog removed" or "fog restored", 2, v and "success" or nil)
end)

createToggle(visualPage, "fullbright", "bright", function(v)
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
    notify(v and "fullbright on" or "fullbright off", 2, v and "success" or nil)
end)

createSlider(visualPage, "field of view", 70, 120, "fov", function(v)
    cam.FieldOfView = v
end)

sectionLabel(visualPage, "character")
createToggle(visualPage, "invisible", "invisible", function(v)
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = v and 1 or 0
        end
    end
    notify(v and "invisible on" or "invisible off", 2, v and "success" or nil)
end)

-- ══════════════════════════════════════════════════════════════
-- ESP TAB
-- ══════════════════════════════════════════════════════════════
local espPage = pages["esp"]

sectionLabel(espPage, "esp control")
createToggle(espPage, "enable esp", "esp", function(v)
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
        notify("esp on", 2, "success")
    else
        clearESP()
        notify("esp off", 2)
    end
end)

createToggle(espPage, "rgb effect", "espRgb", function(v) end)

sectionLabel(espPage, "esp modes")

createButton(espPage, "name tag", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end end
    notify("esp: name tag", 2, "success")
    task.spawn(saveSettings)
end, "◇")

createButton(espPage, "highlight", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end end
    notify("esp: highlight", 2, "success")
    task.spawn(saveSettings)
end, "◈")

createButton(espPage, "box", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end end
    notify("esp: box", 2, "success")
    task.spawn(saveSettings)
end, "▢")

-- ══════════════════════════════════════════════════════════════
-- PLAYERS TAB
-- ══════════════════════════════════════════════════════════════
local playersPage = pages["players"]

sectionLabel(playersPage, "player list")

local playerListContainer = Instance.new("Frame", playersPage)
playerListContainer.BackgroundColor3 = col.card
playerListContainer.BackgroundTransparency = 0.2
playerListContainer.BorderSizePixel = 0
playerListContainer.Size = UDim2.new(1, 0, 0, 130)
playerListContainer.ZIndex = 13
Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 8)

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 5, 0, 5)
playerListScroll.Size = UDim2.new(1, -10, 1, -10)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 3
playerListScroll.ScrollBarImageColor3 = col.accent
playerListScroll.ZIndex = 14

local playerListLayout = Instance.new("UIListLayout", playerListScroll)
playerListLayout.Padding = UDim.new(0, 4)

playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerListScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 5)
end)

local function updatePlayerList()
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local isSel = cfg.selectedPlayer == player
            local btn = Instance.new("TextButton", playerListScroll)
            btn.BackgroundColor3 = isSel and Color3.fromRGB(65, 60, 50) or col.elevated
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 15
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            local name = Instance.new("TextLabel", btn)
            name.BackgroundTransparency = 1
            name.Position = UDim2.new(0, 10, 0, 0)
            name.Size = UDim2.new(1, -40, 1, 0)
            name.Font = Enum.Font.GothamMedium
            name.Text = player.Name
            name.TextColor3 = col.text
            name.TextSize = 11
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.ZIndex = 16

            local selIcon = Instance.new("TextLabel", btn)
            selIcon.BackgroundTransparency = 1
            selIcon.Position = UDim2.new(1, -28, 0, 0)
            selIcon.Size = UDim2.new(0, 24, 1, 0)
            selIcon.Font = Enum.Font.GothamBold
            selIcon.Text = isSel and "●" or ""
            selIcon.TextColor3 = Color3.fromRGB(160, 145, 100)
            selIcon.TextSize = 12
            selIcon.ZIndex = 16

            btn.MouseButton1Click:Connect(function()
                cfg.selectedPlayer = cfg.selectedPlayer == player and nil or player
                notify(cfg.selectedPlayer and ("selected " .. player.Name) or "deselected", 2, cfg.selectedPlayer and "success" or nil)
                if cfg.esp then
                    clearESP()
                    for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end
                end
                updatePlayerList()
            end)

            btn.MouseEnter:Connect(function()
                if not isSel then TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.1}):Play() end
            end)
            btn.MouseLeave:Connect(function()
                if not isSel then TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.3}):Play() end
            end)
        end
    end
end

updatePlayerList()

sectionLabel(playersPage, "actions")

createButton(playersPage, "teleport to player", function()
    if cfg.selectedPlayer then
        teleportToPlayer(cfg.selectedPlayer)
        notify("teleported", 2, "success")
    else
        notify("select a player", 2, "warn")
    end
end, "⤴")

createButton(playersPage, "spectate player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local hum = cfg.selectedPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            cam.CameraSubject = hum
            notify("spectating", 2, "success")
        end
    else
        notify("select a player", 2, "warn")
    end
end, "◉")

createButton(playersPage, "stop spectate", function()
    local hum = char:FindFirstChild("Humanoid")
    if hum then cam.CameraSubject = hum notify("stopped", 2, "success") end
end, "◎")

createButton(playersPage, "refresh list", function()
    updatePlayerList()
    notify("refreshed", 2, "success")
end, "↻")

-- ══════════════════════════════════════════════════════════════
-- MENU ANIMATION
-- ══════════════════════════════════════════════════════════════

local menuOpen = false

local function openMenu()
    if menuOpen then return end
    menuOpen = true
    main.Visible = true
    main.BackgroundTransparency = 1
    main.Size = UDim2.new(0, 0, 0, 0)
    mainStroke.Transparency = 1
    mainGlow.ImageTransparency = 1

    TweenService:Create(main, tweenBounce, {
        Size = UDim2.new(0, 480, 0, 320),
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(mainStroke, tweenMed, {Transparency = 0.3}):Play()
    TweenService:Create(mainGlow, tweenSlow, {ImageTransparency = 0.85}):Play()
end

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    
    TweenService:Create(main, tweenMed, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(mainStroke, tweenFast, {Transparency = 1}):Play()
    TweenService:Create(mainGlow, tweenFast, {ImageTransparency = 1}):Play()
    
    task.delay(0.25, function()
        if not menuOpen then main.Visible = false end
    end)
end

toggleBtn.MouseButton1Click:Connect(function()
    -- Only toggle if not dragging
    if tick() - lastClick < 0.2 then
        if main.Visible then closeMenu() else openMenu() end
    end
end)

closeBtn.MouseButton1Click:Connect(closeMenu)
minBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════════════════════════════
-- MAIN LOOP
-- ══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and cfg.speedHack then
        hum.WalkSpeed = cfg.speed
    end

    if cfg.showfov then
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = cfg.aimfov
    end

    if cfg.showAura then
        auraCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        auraCircle.Radius = cfg.auraRange * 4
    end

    if cfg.esp then updateESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESP(p) end
    end)
    if activeTab == "players" then updatePlayerList() end
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then pcall(function() espData[p].obj:Destroy() end) espData[p] = nil end
    if cfg.selectedPlayer == p then cfg.selectedPlayer = nil end
    if activeTab == "players" then updatePlayerList() end
end)

plr.CharacterAdded:Connect(function(c)
    char = c
    task.wait(1)
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then defaultSpeed = hum.WalkSpeed end
    
    -- Reset God V2 jika aktif
    if cfg.godV2 and godV2System.active then
        godV2System.active = false
        godV2System.clone = nil
        godV2System.conn = {}
        task.wait(0.5)
        enableGodV2()
    end
    
    -- Re-apply saved settings
    for key, ref in pairs(toggleRefs) do
        if cfg[key] then
            ref.apply()
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- APPLY SAVED SETTINGS ON LOAD
-- ══════════════════════════════════════════════════════════════

task.spawn(function()
    task.wait(0.5)
    
    -- Apply visual settings
    if cfg.fov and cfg.fov ~= 70 then cam.FieldOfView = cfg.fov end
    if cfg.fog then Lighting.FogEnd = 100000 end
    if cfg.bright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
    if cfg.lowGravity then Workspace.Gravity = 50 end
    
    -- Count active features
    local activeCount = 0
    for _, v in pairs(cfg) do
        if v == true then activeCount = activeCount + 1 end
    end
    
    notify("violence district v3 loaded", 3, "success")
    if activeCount > 0 then
        notify(activeCount .. " saved settings restored", 2.5)
    end
end)