-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                        VIOLENCE DISTRICT V4 PREMIUM                          ║
-- ║                     Professional 16:9 GUI | 70+ Features                     ║
-- ║                          Delta Executor Compatible                           ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════════════════════════════════════════════

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
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local PathfindingService = game:GetService("PathfindingService")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local MarketplaceService = game:GetService("MarketplaceService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local LocalizationService = game:GetService("LocalizationService")
local PolicyService = game:GetService("PolicyService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TextService = game:GetService("TextService")

-- ══════════════════════════════════════════════════════════════════════════════
-- LOCAL VARIABLES
-- ══════════════════════════════════════════════════════════════════════════════

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

local SAVE_FILE = "vd4_premium_settings.json"
local VERSION = "4.0.0"
local BUILD = "Premium"

-- ══════════════════════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ══════════════════════════════════════════════════════════════════════════════

local cfg = {
    -- Combat
    god = false,
    aim = false,
    aimfov = 150,
    showfov = false,
    aimSmooth = 0.5,
    aimPart = "Head",
    silentAim = false,
    silentNoFov = false,
    killaura = false,
    auraRange = 15,
    showAura = false,
    hitChance = 100,
    triggerbot = false,
    triggerDelay = 0.1,
    autoParry = false,
    parryRange = 10,
    reach = false,
    reachDistance = 15,
    hitboxExpander = false,
    hitboxSize = 5,
    noCooldown = false,
    autoCombo = false,
    comboSpeed = 0.15,
    autoDodge = false,
    dodgeRange = 8,
    autoBlock = false,
    blockRange = 12,
    damageMultiplier = 1,
    criticalHit = false,
    criticalChance = 25,
    
    -- Movement
    speedHack = false,
    speed = 50,
    fly = false,
    flySpeed = 80,
    noclip = false,
    infiniteJump = false,
    autoJump = false,
    bunnyHop = false,
    bunnySpeed = 1.5,
    noFallDamage = false,
    teleportWaypoint = false,
    autoWalk = false,
    walkDirection = 0,
    sprintMultiplier = 2,
    sprint = false,
    crawl = false,
    crawlSpeed = 8,
    moonJump = false,
    jumpPower = 50,
    airWalk = false,
    wallClimb = false,
    ladder = false,
    
    -- Visual
    esp = false,
    espMode = 1,
    espRgb = false,
    espDistance = 1000,
    espShowHealth = true,
    espShowDistance = true,
    espShowName = true,
    espTeamCheck = false,
    chams = false,
    chamsColor = Color3.fromRGB(100, 150, 255),
    tracers = false,
    tracerOrigin = "Bottom",
    tracerColor = Color3.fromRGB(255, 255, 255),
    skeleton = false,
    skeletonColor = Color3.fromRGB(255, 255, 255),
    itemEsp = false,
    npcEsp = false,
    vehicleEsp = false,
    fog = false,
    bright = false,
    fov = 70,
    invisible = false,
    xray = false,
    xrayTransparency = 0.7,
    noParticles = false,
    noEffects = false,
    ambientColor = Color3.fromRGB(127, 127, 127),
    timeOfDay = 14,
    customSkybox = false,
    rainbowSky = false,
    
    -- Character
    noRagdoll = false,
    infiniteStamina = false,
    antiVoid = false,
    lowGravity = false,
    customGravity = 196.2,
    characterSize = 1,
    headSize = 1,
    rainbowCharacter = false,
    noAnimations = false,
    customAnimation = false,
    animationId = 0,
    forcefield = false,
    trail = false,
    trailColor = Color3.fromRGB(255, 255, 255),
    particles = false,
    particleColor = Color3.fromRGB(255, 255, 255),
    
    -- World
    worldGravity = 196.2,
    worldTime = 14,
    lockTime = false,
    noWeather = false,
    noSounds = false,
    noMusic = false,
    destroyAll = false,
    collectAll = false,
    magnetItems = false,
    magnetRange = 50,
    antiLag = false,
    noTextures = false,
    lowGraphics = false,
    
    -- Utility
    antiAfk = false,
    antiKick = false,
    autoRejoin = false,
    autoFarm = false,
    farmTarget = "Nearest",
    autoCollect = false,
    collectRange = 30,
    autoQuest = false,
    autoSell = false,
    autoBuy = false,
    chatSpam = false,
    spamMessage = "Hello!",
    spamDelay = 1,
    chatBypass = false,
    autoChat = false,
    autoChatMessage = "",
    webhook = false,
    webhookUrl = "",
    logKills = false,
    logDeaths = false,
    
    -- Camera
    freeCam = false,
    freeCamSpeed = 1,
    orbitCam = false,
    orbitSpeed = 1,
    orbitDistance = 15,
    lockCam = false,
    lockTarget = nil,
    thirdPerson = false,
    thirdPersonDistance = 10,
    headTracker = false,
    bodyTracker = false,
    cameraShake = false,
    shakeIntensity = 0.5,
    cinematicBars = false,
    barsSize = 0.1,
    
    -- Player
    selectedPlayer = nil,
    followPlayer = false,
    followDistance = 5,
    copyLook = false,
    annoyPlayer = false,
    annoyRange = 3,
    
    -- Gun Mods
    noRecoil = false,
    noSpread = false,
    infiniteAmmo = false,
    noReload = false,
    rapidFire = false,
    fireRate = 0.05,
    autoShoot = false,
    
    -- UI Settings
    uiScale = 1,
    uiOpacity = 0.95,
    accentColor = Color3.fromRGB(100, 140, 200),
    secondaryColor = Color3.fromRGB(70, 100, 150),
    animationSpeed = 0.2,
    soundEffects = true,
    notifications = true,
    notifDuration = 3,
    compactMode = false,
    darkMode = true,
    blurEffect = true,
    
    -- Keybinds
    toggleKey = Enum.KeyCode.RightShift,
    flyKey = Enum.KeyCode.F,
    noclipKey = Enum.KeyCode.V,
    speedKey = Enum.KeyCode.G,
    espKey = Enum.KeyCode.E,
}

-- ══════════════════════════════════════════════════════════════════════════════
-- SAVE/LOAD SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        elseif typeof(v) == "Color3" then
            copy[k] = {r = v.R, g = v.G, b = v.B, _isColor3 = true}
        elseif typeof(v) ~= "userdata" then
            copy[k] = v
        end
    end
    return copy
end

local function restoreColor3(data)
    local restored = {}
    for k, v in pairs(data) do
        if type(v) == "table" then
            if v._isColor3 then
                restored[k] = Color3.new(v.r, v.g, v.b)
            else
                restored[k] = restoreColor3(v)
            end
        else
            restored[k] = v
        end
    end
    return restored
end

local toggleBtnPosition = {x = 20, y = 0.5}

local function saveSettings()
    local data = {
        cfg = deepCopy(cfg),
        togglePos = toggleBtnPosition,
        version = VERSION
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

if savedData and savedData.cfg then
    local restoredCfg = restoreColor3(savedData.cfg)
    for k, v in pairs(restoredCfg) do
        if cfg[k] ~= nil then
            cfg[k] = v
        end
    end
    if savedData.togglePos then
        toggleBtnPosition = savedData.togglePos
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- CONNECTIONS & DATA STORAGE
-- ══════════════════════════════════════════════════════════════════════════════

local conn = {}
local espData = {}
local tracerData = {}
local chamsData = {}
local skeletonData = {}
local toggleRefs = {}
local sliderRefs = {}
local dropdownRefs = {}
local waypoints = {}

local defaultSpeed = 16
local defaultGravity = 196.2
local defaultJumpPower = 50

-- ══════════════════════════════════════════════════════════════════════════════
-- COLOR PALETTE - PROFESSIONAL MINIMALIST DESIGN
-- ══════════════════════════════════════════════════════════════════════════════

local col = {
    -- Background Colors
    bg = Color3.fromRGB(12, 14, 18),
    bgSecondary = Color3.fromRGB(16, 18, 24),
    bgTertiary = Color3.fromRGB(20, 23, 30),
    
    -- Surface Colors
    surface = Color3.fromRGB(24, 27, 35),
    surfaceHover = Color3.fromRGB(30, 34, 44),
    surfaceActive = Color3.fromRGB(36, 40, 52),
    surfaceElevated = Color3.fromRGB(32, 36, 46),
    
    -- Card Colors
    card = Color3.fromRGB(28, 32, 42),
    cardHover = Color3.fromRGB(34, 38, 50),
    cardActive = Color3.fromRGB(40, 45, 58),
    
    -- Border Colors
    border = Color3.fromRGB(42, 47, 60),
    borderLight = Color3.fromRGB(55, 62, 78),
    borderFocus = Color3.fromRGB(80, 110, 160),
    
    -- Text Colors
    text = Color3.fromRGB(235, 238, 245),
    textSecondary = Color3.fromRGB(175, 182, 198),
    textMuted = Color3.fromRGB(125, 132, 150),
    textDim = Color3.fromRGB(85, 92, 108),
    textDisabled = Color3.fromRGB(65, 72, 88),
    
    -- Accent Colors
    accent = Color3.fromRGB(90, 130, 190),
    accentHover = Color3.fromRGB(105, 148, 210),
    accentActive = Color3.fromRGB(120, 165, 225),
    accentDim = Color3.fromRGB(65, 95, 145),
    accentGlow = Color3.fromRGB(130, 170, 230),
    accentMuted = Color3.fromRGB(70, 100, 155),
    
    -- State Colors
    success = Color3.fromRGB(75, 160, 115),
    successDim = Color3.fromRGB(55, 120, 88),
    successGlow = Color3.fromRGB(95, 190, 140),
    
    warning = Color3.fromRGB(200, 165, 75),
    warningDim = Color3.fromRGB(155, 130, 60),
    warningGlow = Color3.fromRGB(225, 190, 95),
    
    error = Color3.fromRGB(185, 80, 90),
    errorDim = Color3.fromRGB(140, 60, 70),
    errorGlow = Color3.fromRGB(210, 100, 115),
    
    info = Color3.fromRGB(85, 155, 205),
    infoDim = Color3.fromRGB(60, 115, 160),
    infoGlow = Color3.fromRGB(110, 180, 230),
    
    -- Toggle States
    toggleOn = Color3.fromRGB(70, 145, 105),
    toggleOnHover = Color3.fromRGB(85, 165, 120),
    toggleOnGlow = Color3.fromRGB(100, 185, 140),
    toggleOff = Color3.fromRGB(50, 55, 68),
    toggleOffHover = Color3.fromRGB(60, 66, 82),
    
    -- Slider Colors
    sliderTrack = Color3.fromRGB(40, 45, 58),
    sliderFill = Color3.fromRGB(90, 130, 190),
    sliderKnob = Color3.fromRGB(235, 238, 245),
    
    -- Special Colors
    selection = Color3.fromRGB(160, 145, 95),
    selectionDim = Color3.fromRGB(130, 118, 78),
    rainbow = Color3.fromRGB(255, 100, 150),
    
    -- Shadow
    shadow = Color3.fromRGB(0, 0, 0),
    shadowLight = Color3.fromRGB(8, 10, 14),
}

-- ══════════════════════════════════════════════════════════════════════════════
-- TWEEN PRESETS
-- ══════════════════════════════════════════════════════════════════════════════

local tweenInstant = TweenInfo.new(0, Enum.EasingStyle.Linear)
local tweenFast = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenMedium = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenSlow = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenElastic = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local tweenSmooth = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- ══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ══════════════════════════════════════════════════════════════════════════════

local function getParent()
    local success, result = pcall(function() return gethui() end)
    return success and result or CoreGui
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function round(value, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(value * mult + 0.5) / mult
end

local function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(math.floor(num))
    end
end

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function isAlive(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    return hum and hrp and hum.Health > 0
end

local function getCharacter()
    return plr.Character or plr.CharacterAdded:Wait()
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function playSound(soundId, volume)
    if not cfg.soundEffects then return end
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = volume or 0.3
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 3)
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- GUI CREATION
-- ══════════════════════════════════════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "VD4_Premium_" .. math.random(10000, 99999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999

-- ══════════════════════════════════════════════════════════════════════════════
-- BLUR EFFECT
-- ══════════════════════════════════════════════════════════════════════════════

local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "VD4_Blur"
blurEffect.Size = 0
blurEffect.Parent = Lighting

-- ══════════════════════════════════════════════════════════════════════════════
-- TOGGLE BUTTON (FLOATING)
-- ══════════════════════════════════════════════════════════════════════════════

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.ZIndex = 500
toggleBtn.Position = UDim2.new(0, toggleBtnPosition.x, toggleBtnPosition.y, -22)
toggleBtn.Size = UDim2.new(0, 44, 0, 44)

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 12)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = col.border
toggleStroke.Thickness = 1.5
toggleStroke.Transparency = 0.4

local toggleShadow = Instance.new("ImageLabel", toggleBtn)
toggleShadow.BackgroundTransparency = 1
toggleShadow.Size = UDim2.new(1, 40, 1, 40)
toggleShadow.Position = UDim2.new(0, -20, 0, -15)
toggleShadow.Image = "rbxassetid://5028857084"
toggleShadow.ImageColor3 = col.shadow
toggleShadow.ImageTransparency = 0.7
toggleShadow.ZIndex = 499

local toggleGlow = Instance.new("ImageLabel", toggleBtn)
toggleGlow.BackgroundTransparency = 1
toggleGlow.Size = UDim2.new(1, 35, 1, 35)
toggleGlow.Position = UDim2.new(0, -17, 0, -17)
toggleGlow.Image = "rbxassetid://5028857084"
toggleGlow.ImageColor3 = col.accent
toggleGlow.ImageTransparency = 0.9
toggleGlow.ZIndex = 498

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBlack
toggleIcon.Text = "V4"
toggleIcon.TextColor3 = col.textMuted
toggleIcon.TextSize = 14
toggleIcon.ZIndex = 501

local togglePulse = Instance.new("Frame", toggleBtn)
togglePulse.BackgroundColor3 = col.accent
togglePulse.BackgroundTransparency = 0.8
togglePulse.Size = UDim2.new(1, 0, 1, 0)
togglePulse.ZIndex = 500
togglePulse.Visible = false
Instance.new("UICorner", togglePulse).CornerRadius = UDim.new(0, 12)

-- Toggle Button Drag System
local toggleDragging = false
local toggleDragStart = nil
local toggleStartPos = nil
local toggleDragMoved = false

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        toggleDragMoved = false
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
        if not toggleDragMoved then
            -- Click event - toggle menu
        end
        toggleBtnPosition = {
            x = toggleBtn.Position.X.Offset,
            y = toggleBtn.Position.Y.Scale
        }
        task.spawn(saveSettings)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - toggleDragStart
            if delta.Magnitude > 5 then
                toggleDragMoved = true
            end
            local newX = clamp(toggleStartPos.X.Offset + delta.X, 0, cam.ViewportSize.X - 50)
            local newY = clamp(toggleStartPos.Y.Offset + delta.Y, -cam.ViewportSize.Y / 2 + 30, cam.ViewportSize.Y / 2 - 30)
            toggleBtn.Position = UDim2.new(0, newX, toggleStartPos.Y.Scale, newY)
        end
    end
end)

-- Toggle Button Hover Effects
toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, tweenFast, {Color = col.accentGlow, Transparency = 0}):Play()
    TweenService:Create(toggleIcon, tweenFast, {TextColor3 = col.text}):Play()
    TweenService:Create(toggleBtn, tweenMedium, {Size = UDim2.new(0, 48, 0, 48), BackgroundColor3 = col.surfaceHover}):Play()
    TweenService:Create(toggleGlow, tweenFast, {ImageTransparency = 0.7}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, tweenFast, {Color = col.border, Transparency = 0.4}):Play()
    TweenService:Create(toggleIcon, tweenFast, {TextColor3 = col.textMuted}):Play()
    TweenService:Create(toggleBtn, tweenMedium, {Size = UDim2.new(0, 44, 0, 44), BackgroundColor3 = col.surface}):Play()
    TweenService:Create(toggleGlow, tweenFast, {ImageTransparency = 0.9}):Play()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN FRAME - 16:9 ASPECT RATIO
-- ══════════════════════════════════════════════════════════════════════════════

local mainWidth = 680
local mainHeight = 400
local sidebarWidth = 140
local headerHeight = 48

local main = Instance.new("Frame")
main.Name = "MainFrame"
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
main.ZIndex = 100

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = col.border
mainStroke.Thickness = 1.5
mainStroke.Transparency = 1

-- Main Shadow
local mainShadow = Instance.new("ImageLabel", main)
mainShadow.BackgroundTransparency = 1
mainShadow.Size = UDim2.new(1, 80, 1, 80)
mainShadow.Position = UDim2.new(0, -40, 0, -30)
mainShadow.Image = "rbxassetid://5028857084"
mainShadow.ImageColor3 = col.shadow
mainShadow.ImageTransparency = 1
mainShadow.ZIndex = 99

-- Main Glow
local mainGlow = Instance.new("ImageLabel", main)
mainGlow.BackgroundTransparency = 1
mainGlow.Size = UDim2.new(1, 100, 1, 100)
mainGlow.Position = UDim2.new(0, -50, 0, -50)
mainGlow.Image = "rbxassetid://5028857084"
mainGlow.ImageColor3 = col.accent
mainGlow.ImageTransparency = 1
mainGlow.ZIndex = 98

-- ══════════════════════════════════════════════════════════════════════════════
-- HEADER
-- ══════════════════════════════════════════════════════════════════════════════

local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = col.bgSecondary
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, headerHeight)
header.ZIndex = 110

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 16)

-- Header bottom fix
local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = col.bgSecondary
headerFix.BackgroundTransparency = 0.1
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -14)
headerFix.Size = UDim2.new(1, 0, 0, 14)
headerFix.ZIndex = 109

-- Header Line
local headerLine = Instance.new("Frame", header)
headerLine.BackgroundColor3 = col.border
headerLine.BackgroundTransparency = 0.6
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.ZIndex = 111

-- Logo Container
local logoContainer = Instance.new("Frame", header)
logoContainer.BackgroundTransparency = 1
logoContainer.Position = UDim2.new(0, 20, 0, 0)
logoContainer.Size = UDim2.new(0, 200, 1, 0)
logoContainer.ZIndex = 112

-- Logo Icon
local logoIcon = Instance.new("Frame", logoContainer)
logoIcon.BackgroundColor3 = col.accent
logoIcon.BackgroundTransparency = 0.85
logoIcon.Position = UDim2.new(0, 0, 0.5, -14)
logoIcon.Size = UDim2.new(0, 28, 0, 28)
logoIcon.ZIndex = 113
Instance.new("UICorner", logoIcon).CornerRadius = UDim.new(0, 8)

local logoIconStroke = Instance.new("UIStroke", logoIcon)
logoIconStroke.Color = col.accentMuted
logoIconStroke.Thickness = 1
logoIconStroke.Transparency = 0.5

local logoIconText = Instance.new("TextLabel", logoIcon)
logoIconText.BackgroundTransparency = 1
logoIconText.Size = UDim2.new(1, 0, 1, 0)
logoIconText.Font = Enum.Font.GothamBlack
logoIconText.Text = "V"
logoIconText.TextColor3 = col.accent
logoIconText.TextSize = 14
logoIconText.ZIndex = 114

-- Title
local titleLabel = Instance.new("TextLabel", logoContainer)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 38, 0, 6)
titleLabel.Size = UDim2.new(0, 150, 0, 18)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "VIOLENCE DISTRICT"
titleLabel.TextColor3 = col.text
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 112

-- Subtitle
local subtitleLabel = Instance.new("TextLabel", logoContainer)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 38, 0, 24)
subtitleLabel.Size = UDim2.new(0, 150, 0, 14)
subtitleLabel.Font = Enum.Font.GothamMedium
subtitleLabel.Text = "Premium Edition"
subtitleLabel.TextColor3 = col.textDim
subtitleLabel.TextSize = 10
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.ZIndex = 112

-- Version Badge
local versionBadge = Instance.new("Frame", header)
versionBadge.BackgroundColor3 = col.accent
versionBadge.BackgroundTransparency = 0.85
versionBadge.Position = UDim2.new(0, 195, 0.5, -9)
versionBadge.Size = UDim2.new(0, 35, 0, 18)
versionBadge.ZIndex = 112
Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0, 5)

local versionLabel = Instance.new("TextLabel", versionBadge)
versionLabel.BackgroundTransparency = 1
versionLabel.Size = UDim2.new(1, 0, 1, 0)
versionLabel.Font = Enum.Font.GothamBold
versionLabel.Text = "v4.0"
versionLabel.TextColor3 = col.accent
versionLabel.TextSize = 9
versionLabel.ZIndex = 113

-- Window Controls Container
local windowControls = Instance.new("Frame", header)
windowControls.BackgroundTransparency = 1
windowControls.Position = UDim2.new(1, -95, 0.5, -12)
windowControls.Size = UDim2.new(0, 80, 0, 24)
windowControls.ZIndex = 112

-- Minimize Button
local minBtn = Instance.new("TextButton", windowControls)
minBtn.BackgroundColor3 = col.warning
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(0, 0, 0, 0)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = col.textDim
minBtn.TextSize = 16
minBtn.AutoButtonColor = false
minBtn.ZIndex = 113
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, tweenFast, {BackgroundTransparency = 0.75, TextColor3 = col.warning}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, tweenFast, {BackgroundTransparency = 1, TextColor3 = col.textDim}):Play()
end)

-- Maximize Button
local maxBtn = Instance.new("TextButton", windowControls)
maxBtn.BackgroundColor3 = col.success
maxBtn.BackgroundTransparency = 1
maxBtn.Position = UDim2.new(0, 28, 0, 0)
maxBtn.Size = UDim2.new(0, 24, 0, 24)
maxBtn.Font = Enum.Font.GothamBold
maxBtn.Text = "□"
maxBtn.TextColor3 = col.textDim
maxBtn.TextSize = 12
maxBtn.AutoButtonColor = false
maxBtn.ZIndex = 113
Instance.new("UICorner", maxBtn).CornerRadius = UDim.new(0, 6)

maxBtn.MouseEnter:Connect(function()
    TweenService:Create(maxBtn, tweenFast, {BackgroundTransparency = 0.75, TextColor3 = col.success}):Play()
end)
maxBtn.MouseLeave:Connect(function()
    TweenService:Create(maxBtn, tweenFast, {BackgroundTransparency = 1, TextColor3 = col.textDim}):Play()
end)

-- Close Button
local closeBtn = Instance.new("TextButton", windowControls)
closeBtn.BackgroundColor3 = col.error
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0, 56, 0, 0)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = col.textDim
closeBtn.TextSize = 18
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 113
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, tweenFast, {BackgroundTransparency = 0.75, TextColor3 = col.error}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, tweenFast, {BackgroundTransparency = 1, TextColor3 = col.textDim}):Play()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- SIDEBAR
-- ══════════════════════════════════════════════════════════════════════════════

local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = col.bgSecondary
sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, headerHeight)
sidebar.Size = UDim2.new(0, sidebarWidth, 1, -headerHeight)
sidebar.ZIndex = 105

-- Sidebar Line
local sidebarLine = Instance.new("Frame", sidebar)
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BackgroundTransparency = 0.6
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.ZIndex = 106

-- Tab List Container
local tabListContainer = Instance.new("Frame", sidebar)
tabListContainer.BackgroundTransparency = 1
tabListContainer.Position = UDim2.new(0, 8, 0, 12)
tabListContainer.Size = UDim2.new(1, -16, 1, -24)
tabListContainer.ZIndex = 107

-- Tab List ScrollingFrame
local tabList = Instance.new("ScrollingFrame", tabListContainer)
tabList.BackgroundTransparency = 1
tabList.Size = UDim2.new(1, 0, 1, 0)
tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
tabList.ScrollBarThickness = 0
tabList.ScrollingDirection = Enum.ScrollingDirection.Y
tabList.ZIndex = 108

local tabListLayout = Instance.new("UIListLayout", tabList)
tabListLayout.Padding = UDim.new(0, 4)
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabList.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 10)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- CONTENT AREA
-- ══════════════════════════════════════════════════════════════════════════════

local contentArea = Instance.new("Frame", main)
contentArea.Name = "ContentArea"
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0, sidebarWidth + 12, 0, headerHeight + 10)
contentArea.Size = UDim2.new(1, -(sidebarWidth + 24), 1, -(headerHeight + 20))
contentArea.ZIndex = 105
contentArea.ClipsDescendants = true

-- ══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifications"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -280, 0, 20)
notifContainer.Size = UDim2.new(0, 260, 0, 300)
notifContainer.ZIndex = 1000

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local notificationCount = 0

local function notify(message, duration, notifType, title)
    if not cfg.notifications then return end
    
    duration = duration or cfg.notifDuration
    notifType = notifType or "info"
    title = title or "Notification"
    
    notificationCount = notificationCount + 1
    local order = notificationCount
    
    local notifColor = col.info
    local notifIcon = "●"
    
    if notifType == "success" then
        notifColor = col.success
        notifIcon = "✓"
        title = title == "Notification" and "Success" or title
    elseif notifType == "error" then
        notifColor = col.error
        notifIcon = "✕"
        title = title == "Notification" and "Error" or title
    elseif notifType == "warning" or notifType == "warn" then
        notifColor = col.warning
        notifIcon = "!"
        title = title == "Notification" and "Warning" or title
    end
    
    local notif = Instance.new("Frame", notifContainer)
    notif.BackgroundColor3 = col.surface
    notif.BackgroundTransparency = 0.05
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 0, 0, 0)
    notif.ClipsDescendants = true
    notif.LayoutOrder = order
    notif.ZIndex = 1001
    
    local notifCorner = Instance.new("UICorner", notif)
    notifCorner.CornerRadius = UDim.new(0, 10)
    
    local notifStroke = Instance.new("UIStroke", notif)
    notifStroke.Color = notifColor
    notifStroke.Thickness = 1
    notifStroke.Transparency = 0.7
    
    local notifAccent = Instance.new("Frame", notif)
    notifAccent.BackgroundColor3 = notifColor
    notifAccent.BorderSizePixel = 0
    notifAccent.Size = UDim2.new(0, 4, 1, 0)
    notifAccent.ZIndex = 1002
    
    local accentCorner = Instance.new("UICorner", notifAccent)
    accentCorner.CornerRadius = UDim.new(0, 10)
    
    local iconLabel = Instance.new("TextLabel", notif)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 8)
    iconLabel.Size = UDim2.new(0, 20, 0, 20)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = notifIcon
    iconLabel.TextColor3 = notifColor
    iconLabel.TextSize = 13
    iconLabel.TextTransparency = 1
    iconLabel.ZIndex = 1003
    
    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 38, 0, 8)
    titleLabel.Size = UDim2.new(1, -48, 0, 16)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = col.text
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1
    titleLabel.ZIndex = 1003
    
    local messageLabel = Instance.new("TextLabel", notif)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Position = UDim2.new(0, 14, 0, 26)
    messageLabel.Size = UDim2.new(1, -24, 0, 28)
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.Text = message
    messageLabel.TextColor3 = col.textSecondary
    messageLabel.TextSize = 10
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.TextTransparency = 1
    messageLabel.ZIndex = 1003
    
    local progressBar = Instance.new("Frame", notif)
    progressBar.BackgroundColor3 = notifColor
    progressBar.BackgroundTransparency = 0.5
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.ZIndex = 1002
    
    -- Animate in
    TweenService:Create(notif, tweenBounce, {Size = UDim2.new(0, 240, 0, 60)}):Play()
    
    task.delay(0.1, function()
        TweenService:Create(iconLabel, tweenFast, {TextTransparency = 0}):Play()
        TweenService:Create(titleLabel, tweenFast, {TextTransparency = 0}):Play()
        TweenService:Create(messageLabel, tweenFast, {TextTransparency = 0}):Play()
        TweenService:Create(notifStroke, tweenFast, {Transparency = 0.4}):Play()
    end)
    
    -- Progress bar animation
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    
    -- Animate out
    task.delay(duration, function()
        TweenService:Create(iconLabel, tweenFast, {TextTransparency = 1}):Play()
        TweenService:Create(titleLabel, tweenFast, {TextTransparency = 1}):Play()
        TweenService:Create(messageLabel, tweenFast, {TextTransparency = 1}):Play()
        TweenService:Create(notif, tweenMedium, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
        
        task.wait(0.25)
        notif:Destroy()
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- DRAWING API (FOV Circle, Aura Circle, Tracers)
-- ══════════════════════════════════════════════════════════════════════════════

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.Color = col.accent
fovCircle.Transparency = 0.6
fovCircle.NumSides = 64
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1.5
auraCircle.Color = Color3.fromRGB(180, 100, 100)
auraCircle.Transparency = 0.5
auraCircle.NumSides = 64
auraCircle.Filled = false

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB DEFINITIONS
-- ══════════════════════════════════════════════════════════════════════════════

local tabs = {
    {id = "home", name = "Home", icon = "◆", order = 1},
    {id = "combat", name = "Combat", icon = "⚔", order = 2},
    {id = "movement", name = "Movement", icon = "➤", order = 3},
    {id = "visual", name = "Visuals", icon = "◐", order = 4},
    {id = "esp", name = "ESP", icon = "◎", order = 5},
    {id = "character", name = "Character", icon = "♦", order = 6},
    {id = "world", name = "World", icon = "●", order = 7},
    {id = "utility", name = "Utility", icon = "⚙", order = 8},
    {id = "camera", name = "Camera", icon = "◉", order = 9},
    {id = "players", name = "Players", icon = "♣", order = 10},
    {id = "teleport", name = "Teleport", icon = "⤴", order = 11},
    {id = "settings", name = "Settings", icon = "≡", order = 12},
}

local pages = {}
local tabButtons = {}
local activeTab = nil

-- ══════════════════════════════════════════════════════════════════════════════
-- UI COMPONENT CREATORS
-- ══════════════════════════════════════════════════════════════════════════════

local function createPage(id)
    local page = Instance.new("ScrollingFrame")
    page.Name = id
    page.Parent = contentArea
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = col.accent
    page.ScrollBarImageTransparency = 0.6
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.Visible = false
    page.ZIndex = 106
    
    local padding = Instance.new("UIPadding", page)
    padding.PaddingRight = UDim.new(0, 8)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)
    
    pages[id] = page
    return page
end

local function createSectionLabel(parent, text, order)
    local container = Instance.new("Frame", parent)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 24)
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 4, 0, 4)
    label.Size = UDim2.new(1, -8, 0, 16)
    label.Font = Enum.Font.GothamBold
    label.Text = text:upper()
    label.TextColor3 = col.textDim
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    local line = Instance.new("Frame", container)
    line.BackgroundColor3 = col.border
    line.BackgroundTransparency = 0.7
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 4, 1, -1)
    line.Size = UDim2.new(1, -8, 0, 1)
    line.ZIndex = 107
    
    return container
end

local function createToggle(parent, text, cfgKey, callback, order, description)
    local state = cfg[cfgKey] or false
    
    local container = Instance.new("TextButton", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, description and 48 or 36)
    container.Text = ""
    container.AutoButtonColor = false
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, description and 6 or 0)
    label.Size = UDim2.new(1, -70, 0, description and 18 or 36)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    if description then
        local descLabel = Instance.new("TextLabel", container)
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 14, 0, 24)
        descLabel.Size = UDim2.new(1, -70, 0, 16)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = col.textDim
        descLabel.TextSize = 9
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 108
    end
    
    local switch = Instance.new("Frame", container)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = col.toggleOff
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -12, 0.5, 0)
    switch.Size = UDim2.new(0, 38, 0, 20)
    switch.ZIndex = 108
    
    local switchCorner = Instance.new("UICorner", switch)
    switchCorner.CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", switch)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = col.textDim
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(0, 3, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.ZIndex = 109
    
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local function updateVisual(animate)
        local tweenInfo = animate and tweenMedium or tweenInstant
        
        if state then
            TweenService:Create(switch, tweenInfo, {BackgroundColor3 = col.toggleOn}):Play()
            TweenService:Create(knob, animate and tweenBounce or tweenInstant, {
                Position = UDim2.new(1, -17, 0.5, 0),
                BackgroundColor3 = col.toggleOnGlow
            }):Play()
            TweenService:Create(label, tweenInfo, {TextColor3 = col.text}):Play()
            TweenService:Create(stroke, tweenInfo, {Color = col.toggleOn, Transparency = 0.5}):Play()
        else
            TweenService:Create(switch, tweenInfo, {BackgroundColor3 = col.toggleOff}):Play()
            TweenService:Create(knob, animate and tweenBounce or tweenInstant, {
                Position = UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = col.textDim
            }):Play()
            TweenService:Create(label, tweenInfo, {TextColor3 = col.textSecondary}):Play()
            TweenService:Create(stroke, tweenInfo, {Color = col.border, Transparency = 0.75}):Play()
        end
    end
    
    local function toggle(noSave)
        state = not state
        cfg[cfgKey] = state
        updateVisual(true)
        pcall(callback, state)
        if not noSave then
            task.spawn(saveSettings)
        end
    end
    
    container.MouseButton1Click:Connect(function()
        toggle(false)
    end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.2}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.35}):Play()
    end)
    
    -- Initialize visual state
    updateVisual(false)
    
    local ref = {
        setState = function(v, noCallback, noSave)
            state = v
            cfg[cfgKey] = v
            updateVisual(true)
            if not noCallback then pcall(callback, state) end
            if not noSave then task.spawn(saveSettings) end
        end,
        getState = function() return state end,
        apply = function()
            if state then pcall(callback, true) end
        end,
        container = container
    }
    
    toggleRefs[cfgKey] = ref
    return ref
end

local function createSlider(parent, text, min, max, cfgKey, callback, order, suffix, decimals)
    local value = clamp(cfg[cfgKey] or min, min, max)
    local dragging = false
    suffix = suffix or ""
    decimals = decimals or 0
    
    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 52)
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 8)
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    local valueBg = Instance.new("Frame", container)
    valueBg.BackgroundColor3 = col.accent
    valueBg.BackgroundTransparency = 0.85
    valueBg.Position = UDim2.new(1, -54, 0, 8)
    valueBg.Size = UDim2.new(0, 42, 0, 18)
    valueBg.ZIndex = 108
    Instance.new("UICorner", valueBg).CornerRadius = UDim.new(0, 4)
    
    local valueLabel = Instance.new("TextLabel", valueBg)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = round(value, decimals) .. suffix
    valueLabel.TextColor3 = col.accent
    valueLabel.TextSize = 10
    valueLabel.ZIndex = 109
    
    local track = Instance.new("Frame", container)
    track.BackgroundColor3 = col.sliderTrack
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 14, 0, 34)
    track.Size = UDim2.new(1, -28, 0, 8)
    track.ZIndex = 108
    
    local trackCorner = Instance.new("UICorner", track)
    trackCorner.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = col.sliderFill
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.ZIndex = 109
    
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", fill)
    knob.AnchorPoint = Vector2.new(1, 0.5)
    knob.BackgroundColor3 = col.sliderKnob
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.ZIndex = 110
    
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local knobShadow = Instance.new("UIStroke", knob)
    knobShadow.Color = col.shadow
    knobShadow.Thickness = 2
    knobShadow.Transparency = 0.5
    
    local hitbox = Instance.new("TextButton", track)
    hitbox.BackgroundTransparency = 1
    hitbox.Size = UDim2.new(1, 0, 1, 16)
    hitbox.Position = UDim2.new(0, 0, 0, -8)
    hitbox.Text = ""
    hitbox.ZIndex = 111
    
    local function updateValue(inputPos)
        local pos = clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = round(min + (max - min) * pos, decimals)
        cfg[cfgKey] = value
        
        TweenService:Create(fill, tweenFast, {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        valueLabel.Text = round(value, decimals) .. suffix
        
        pcall(callback, value)
    end
    
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input.Position.X)
            TweenService:Create(knob, tweenFast, {Size = UDim2.new(0, 16, 0, 16)}):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                TweenService:Create(knob, tweenFast, {Size = UDim2.new(0, 14, 0, 14)}):Play()
                task.spawn(saveSettings)
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                updateValue(input.Position.X)
            end
        end
    end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.2}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.35}):Play()
    end)
    
    local ref = {
        setValue = function(v)
            value = clamp(v, min, max)
            cfg[cfgKey] = value
            local pos = (value - min) / (max - min)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            valueLabel.Text = round(value, decimals) .. suffix
            pcall(callback, value)
        end,
        getValue = function() return value end,
        container = container
    }
    
    sliderRefs[cfgKey] = ref
    return ref
end

local function createButton(parent, text, callback, order, icon, buttonType)
    local container = Instance.new("TextButton", parent)
    container.BackgroundColor3 = buttonType == "danger" and col.errorDim or buttonType == "success" and col.successDim or col.card
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 36)
    container.Text = ""
    container.AutoButtonColor = false
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = buttonType == "danger" and col.error or buttonType == "success" and col.success or col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    
    if icon then
        local iconLabel = Instance.new("TextLabel", container)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 14, 0, 0)
        iconLabel.Size = UDim2.new(0, 20, 1, 0)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Text = icon
        iconLabel.TextColor3 = buttonType == "danger" and col.error or buttonType == "success" and col.success or col.accent
        iconLabel.TextSize = 12
        iconLabel.ZIndex = 108
    end
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, icon and 38 or 14, 0, 0)
    label.Size = UDim2.new(1, icon and -52 or -28, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    local arrow = Instance.new("TextLabel", container)
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "›"
    arrow.TextColor3 = col.textDim
    arrow.TextSize = 14
    arrow.ZIndex = 108
    
    container.MouseButton1Click:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.05), {BackgroundTransparency = 0.1}):Play()
        task.wait(0.05)
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.35}):Play()
        pcall(callback)
    end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(label, tweenFast, {TextColor3 = col.text}):Play()
        TweenService:Create(arrow, tweenFast, {TextColor3 = col.accent, Position = UDim2.new(1, -24, 0, 0)}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweenFast, {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(label, tweenFast, {TextColor3 = col.textSecondary}):Play()
        TweenService:Create(arrow, tweenFast, {TextColor3 = col.textDim, Position = UDim2.new(1, -28, 0, 0)}):Play()
    end)
    
    return container
end

local function createDropdown(parent, text, options, cfgKey, callback, order)
    local selectedIndex = 1
    local isOpen = false
    
    -- Find current selection
    for i, opt in ipairs(options) do
        if opt == cfg[cfgKey] then
            selectedIndex = i
            break
        end
    end
    
    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 42)
    container.ClipsDescendants = true
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.5, 0, 0, 42)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    local selectedBtn = Instance.new("TextButton", container)
    selectedBtn.BackgroundColor3 = col.surfaceElevated
    selectedBtn.BackgroundTransparency = 0.3
    selectedBtn.Position = UDim2.new(0.5, 0, 0, 8)
    selectedBtn.Size = UDim2.new(0.5, -22, 0, 26)
    selectedBtn.Font = Enum.Font.GothamMedium
    selectedBtn.Text = options[selectedIndex] or "Select"
    selectedBtn.TextColor3 = col.text
    selectedBtn.TextSize = 10
    selectedBtn.AutoButtonColor = false
    selectedBtn.ZIndex = 109
    
    local selectedCorner = Instance.new("UICorner", selectedBtn)
    selectedCorner.CornerRadius = UDim.new(0, 6)
    
    local arrow = Instance.new("TextLabel", selectedBtn)
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.Size = UDim2.new(0, 18, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = col.textMuted
    arrow.TextSize = 10
    arrow.ZIndex = 110
    
    local optionsList = Instance.new("Frame", container)
    optionsList.BackgroundTransparency = 1
    optionsList.Position = UDim2.new(0.5, 0, 0, 42)
    optionsList.Size = UDim2.new(0.5, -22, 0, #options * 28 + 8)
    optionsList.ZIndex = 111
    optionsList.Visible = false
    
    local optionsLayout = Instance.new("UIListLayout", optionsList)
    optionsLayout.Padding = UDim.new(0, 2)
    
    local optionsPadding = Instance.new("UIPadding", optionsList)
    optionsPadding.PaddingTop = UDim.new(0, 4)
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton", optionsList)
        optBtn.BackgroundColor3 = col.surfaceHover
        optBtn.BackgroundTransparency = 1
        optBtn.Size = UDim2.new(1, 0, 0, 26)
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.Text = opt
        optBtn.TextColor3 = col.textSecondary
        optBtn.TextSize = 10
        optBtn.AutoButtonColor = false
        optBtn.ZIndex = 112
        
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
        
        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, tweenFast, {BackgroundTransparency = 0.3, TextColor3 = col.text}):Play()
        end)
        
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, tweenFast, {BackgroundTransparency = 1, TextColor3 = col.textSecondary}):Play()
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            selectedIndex = i
            cfg[cfgKey] = opt
            selectedBtn.Text = opt
            pcall(callback, opt, i)
            
            -- Close dropdown
            isOpen = false
            optionsList.Visible = false
            TweenService:Create(container, tweenMedium, {Size = UDim2.new(1, 0, 0, 42)}):Play()
            TweenService:Create(arrow, tweenFast, {Rotation = 0}):Play()
            
            task.spawn(saveSettings)
        end)
    end
    
    selectedBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            local height = 42 + #options * 28 + 12
            TweenService:Create(container, tweenMedium, {Size = UDim2.new(1, 0, 0, height)}):Play()
            TweenService:Create(arrow, tweenFast, {Rotation = 180}):Play()
            optionsList.Visible = true
        else
            TweenService:Create(container, tweenMedium, {Size = UDim2.new(1, 0, 0, 42)}):Play()
            TweenService:Create(arrow, tweenFast, {Rotation = 0}):Play()
            task.delay(0.2, function()
                if not isOpen then
                    optionsList.Visible = false
                end
            end)
        end
    end)
    
    local ref = {
        setSelected = function(optName)
            for i, opt in ipairs(options) do
                if opt == optName then
                    selectedIndex = i
                    cfg[cfgKey] = opt
                    selectedBtn.Text = opt
                    pcall(callback, opt, i)
                    break
                end
            end
        end,
        getSelected = function() return options[selectedIndex] end,
        container = container
    }
    
    dropdownRefs[cfgKey] = ref
    return ref
end

local function createTextInput(parent, text, cfgKey, placeholder, callback, order)
    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 42)
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    local inputBox = Instance.new("TextBox", container)
    inputBox.BackgroundColor3 = col.surfaceElevated
    inputBox.BackgroundTransparency = 0.3
    inputBox.Position = UDim2.new(0.4, 0, 0, 8)
    inputBox.Size = UDim2.new(0.6, -22, 0, 26)
    inputBox.Font = Enum.Font.GothamMedium
    inputBox.PlaceholderText = placeholder or "Enter value..."
    inputBox.PlaceholderColor3 = col.textDim
    inputBox.Text = cfg[cfgKey] or ""
    inputBox.TextColor3 = col.text
    inputBox.TextSize = 10
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 109
    
    local inputCorner = Instance.new("UICorner", inputBox)
    inputCorner.CornerRadius = UDim.new(0, 6)
    
    local inputPadding = Instance.new("UIPadding", inputBox)
    inputPadding.PaddingLeft = UDim.new(0, 8)
    inputPadding.PaddingRight = UDim.new(0, 8)
    
    inputBox.Focused:Connect(function()
        TweenService:Create(stroke, tweenFast, {Color = col.accent, Transparency = 0.3}):Play()
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(stroke, tweenFast, {Color = col.border, Transparency = 0.75}):Play()
        cfg[cfgKey] = inputBox.Text
        pcall(callback, inputBox.Text)
        task.spawn(saveSettings)
    end)
    
    return {
        setValue = function(v)
            inputBox.Text = v
            cfg[cfgKey] = v
        end,
        getValue = function() return inputBox.Text end,
        container = container
    }
end

local function createKeybind(parent, text, cfgKey, callback, order)
    local listening = false
    
    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 36)
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 108
    
    local keyBtn = Instance.new("TextButton", container)
    keyBtn.BackgroundColor3 = col.surfaceElevated
    keyBtn.BackgroundTransparency = 0.3
    keyBtn.Position = UDim2.new(1, -90, 0.5, -11)
    keyBtn.Size = UDim2.new(0, 78, 0, 22)
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.Text = cfg[cfgKey] and cfg[cfgKey].Name or "None"
    keyBtn.TextColor3 = col.accent
    keyBtn.TextSize = 9
    keyBtn.AutoButtonColor = false
    keyBtn.ZIndex = 109
    
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)
    
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        TweenService:Create(stroke, tweenFast, {Color = col.accent}):Play()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            cfg[cfgKey] = input.KeyCode
            keyBtn.Text = input.KeyCode.Name
            TweenService:Create(stroke, tweenFast, {Color = col.border}):Play()
            pcall(callback, input.KeyCode)
            task.spawn(saveSettings)
        end
    end)
    
    return container
end

local function createInfoCard(parent, title, value, icon, order)
    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.25
    container.BorderSizePixel = 0
    container.Size = UDim2.new(0.48, 0, 0, 65)
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = col.border
    stroke.Thickness = 1
    stroke.Transparency = 0.8
    
    local iconLabel = Instance.new("TextLabel", container)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 10)
    iconLabel.Size = UDim2.new(0, 24, 0, 24)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon or "●"
    iconLabel.TextColor3 = col.accent
    iconLabel.TextSize = 16
    iconLabel.ZIndex = 108
    
    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 14, 0, 38)
    titleLabel.Size = UDim2.new(1, -28, 0, 14)
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.Text = title
    titleLabel.TextColor3 = col.textDim
    titleLabel.TextSize = 9
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 108
    
    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Name = "Value"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 42, 0, 10)
    valueLabel.Size = UDim2.new(1, -56, 0, 24)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = col.text
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.ZIndex = 108
    
    return {
        setValue = function(v)
            valueLabel.Text = tostring(v)
        end,
        container = container
    }
end

local function createDualColumn(parent, order)
    local container = Instance.new("Frame", parent)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 65)
    container.LayoutOrder = order or 0
    container.ZIndex = 107
    
    local layout = Instance.new("UIListLayout", container)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0.04, 0)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return container
end

local function createSpacer(parent, height, order)
    local spacer = Instance.new("Frame", parent)
    spacer.BackgroundTransparency = 1
    spacer.Size = UDim2.new(1, 0, 0, height or 8)
    spacer.LayoutOrder = order or 0
    spacer.ZIndex = 107
    return spacer
end

-- ══════════════════════════════════════════════════════════════════════════════
-- CREATE TABS
-- ══════════════════════════════════════════════════════════════════════════════

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabList
    btn.BackgroundColor3 = col.surfaceHover
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = tab.order
    btn.ZIndex = 109
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 7)
    
    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = col.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.5, -8)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.ZIndex = 110
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)
    
    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.Name = "Icon"
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.Size = UDim2.new(0, 20, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = tab.icon
    iconLabel.TextColor3 = col.textDim
    iconLabel.TextSize = 11
    iconLabel.ZIndex = 110
    
    local textLabel = Instance.new("TextLabel", btn)
    textLabel.Name = "Text"
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 34, 0, 0)
    textLabel.Size = UDim2.new(1, -44, 1, 0)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.Text = tab.name
    textLabel.TextColor3 = col.textDim
    textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 110
    
    local page = createPage(tab.id)
    tabButtons[tab.id] = {btn = btn, icon = iconLabel, text = textLabel, indicator = indicator}
    
    btn.MouseButton1Click:Connect(function()
        -- Deselect all tabs
        for id, data in pairs(tabButtons) do
            TweenService:Create(data.btn, tweenFast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.icon, tweenFast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.text, tweenFast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.indicator, tweenMedium, {Size = UDim2.new(0, 3, 0, 0)}):Play()
            pages[id].Visible = false
        end
        
        -- Select this tab
        TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.6}):Play()
        TweenService:Create(iconLabel, tweenFast, {TextColor3 = col.accent}):Play()
        TweenService:Create(textLabel, tweenFast, {TextColor3 = col.text}):Play()
        TweenService:Create(indicator, tweenBounce, {Size = UDim2.new(0, 3, 0, 16)}):Play()
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
    
    -- Select first tab by default
    if i == 1 then
        btn.BackgroundTransparency = 0.6
        iconLabel.TextColor3 = col.accent
        textLabel.TextColor3 = col.text
        indicator.Size = UDim2.new(0, 3, 0, 16)
        page.Visible = true
        activeTab = tab.id
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS FOR FEATURES
-- ══════════════════════════════════════════════════════════════════════════════

local function clearESP()
    for player, data in pairs(espData) do
        pcall(function()
            if data.billboard then data.billboard:Destroy() end
            if data.highlight then data.highlight:Destroy() end
            if data.box then data.box:Destroy() end
        end)
    end
    espData = {}
end

local function clearTracers()
    for player, tracer in pairs(tracerData) do
        pcall(function()
            tracer:Remove()
        end)
    end
    tracerData = {}
end

local function clearChams()
    for player, highlight in pairs(chamsData) do
        pcall(function()
            highlight:Destroy()
        end)
    end
    chamsData = {}
end

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
                    remote:FireServer(target)
                end)
            end
        end
    end
end

local function teleportToPlayer(player)
    if not player or not player.Character then return false end
    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = getHRP()
    
    if targetHRP and myHRP then
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 4)
        return true
    end
    return false
end

local function createESP(player)
    if not player.Character or espData[player] then return end
    
    local character = player.Character
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    local isSelected = cfg.selectedPlayer == player
    local selectedColor = col.selection
    
    if cfg.espMode == 1 then
        -- Nametag ESP
        local billboard = Instance.new("BillboardGui", hrp)
        billboard.Name = "VD4_ESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 80, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.LightInfluence = 0
        
        local container = Instance.new("Frame", billboard)
        container.BackgroundColor3 = isSelected and selectedColor or col.bg
        container.BackgroundTransparency = 0.2
        container.Size = UDim2.new(1, 0, 1, 0)
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
        
        local stroke = Instance.new("UIStroke", container)
        stroke.Color = isSelected and selectedColor or col.accent
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        
        local nameLabel = Instance.new("TextLabel", container)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = col.text
        nameLabel.TextScaled = true
        
        local infoLabel = Instance.new("TextLabel", container)
        infoLabel.Name = "Info"
        infoLabel.BackgroundTransparency = 1
        infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
        infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
        infoLabel.Font = Enum.Font.GothamMedium
        infoLabel.Text = "0m | 100HP"
        infoLabel.TextColor3 = col.textMuted
        infoLabel.TextScaled = true
        
        espData[player] = {billboard = billboard, info = infoLabel, type = "nametag"}
        
    elseif cfg.espMode == 2 then
        -- Highlight ESP
        local highlight = Instance.new("Highlight", character)
        highlight.Name = "VD4_ESP"
        highlight.FillColor = isSelected and selectedColor or col.accent
        highlight.OutlineColor = col.text
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0.3
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        espData[player] = {highlight = highlight, type = "highlight"}
        
    elseif cfg.espMode == 3 then
        -- Box ESP
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Name = "VD4_ESP"
        box.Size = character:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSelected and selectedColor or col.accent
        box.Transparency = 0.5
        
        espData[player] = {box = box, type = "box"}
    end
end

local function updateESP()
    local myHRP = getHRP()
    if not myHRP then return end
    
    for player, data in pairs(espData) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end
        
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local distance = getDistance(myHRP.Position, hrp.Position)
        
        if distance > cfg.espDistance then
            if data.billboard then data.billboard.Enabled = false end
            if data.highlight then data.highlight.Enabled = false end
            if data.box then data.box.Visible = false end
            continue
        else
            if data.billboard then data.billboard.Enabled = true end
            if data.highlight then data.highlight.Enabled = true end
            if data.box then data.box.Visible = true end
        end
        
        if data.info and hum then
            local healthText = cfg.espShowHealth and math.floor(hum.Health) .. "HP" or ""
            local distanceText = cfg.espShowDistance and math.floor(distance) .. "m" or ""
            local separator = (cfg.espShowHealth and cfg.espShowDistance) and " | " or ""
            data.info.Text = distanceText .. separator .. healthText
        end
        
        if cfg.espRgb then
            local rainbow = Color3.fromHSV(tick() % 5 / 5, 0.6, 0.9)
            if data.type == "highlight" then
                data.highlight.FillColor = rainbow
            elseif data.type == "box" then
                data.box.Color3 = rainbow
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

-- ══════════════════════════════════════════════════════════════════════════════
-- HOME PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local homePage = pages["home"]
local orderCounter = 0

-- Player Card
local playerCard = Instance.new("Frame", homePage)
playerCard.BackgroundColor3 = col.card
playerCard.BackgroundTransparency = 0.2
playerCard.Size = UDim2.new(1, 0, 0, 75)
playerCard.LayoutOrder = orderCounter
playerCard.ZIndex = 107
orderCounter = orderCounter + 1

Instance.new("UICorner", playerCard).CornerRadius = UDim.new(0, 12)

local playerCardStroke = Instance.new("UIStroke", playerCard)
playerCardStroke.Color = col.border
playerCardStroke.Thickness = 1
playerCardStroke.Transparency = 0.7

local avatar = Instance.new("ImageLabel", playerCard)
avatar.BackgroundColor3 = col.surfaceElevated
avatar.Position = UDim2.new(0, 14, 0.5, 0)
avatar.AnchorPoint = Vector2.new(0, 0.5)
avatar.Size = UDim2.new(0, 48, 0, 48)
avatar.ZIndex = 108
Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 10)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

local playerName = Instance.new("TextLabel", playerCard)
playerName.BackgroundTransparency = 1
playerName.Position = UDim2.new(0, 74, 0, 14)
playerName.Size = UDim2.new(1, -88, 0, 20)
playerName.Font = Enum.Font.GothamBold
playerName.Text = plr.DisplayName
playerName.TextColor3 = col.text
playerName.TextSize = 15
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.ZIndex = 108

local playerUsername = Instance.new("TextLabel", playerCard)
playerUsername.BackgroundTransparency = 1
playerUsername.Position = UDim2.new(0, 74, 0, 34)
playerUsername.Size = UDim2.new(1, -88, 0, 14)
playerUsername.Font = Enum.Font.GothamMedium
playerUsername.Text = "@" .. plr.Name
playerUsername.TextColor3 = col.textDim
playerUsername.TextSize = 11
playerUsername.TextXAlignment = Enum.TextXAlignment.Left
playerUsername.ZIndex = 108

local gameLabel = Instance.new("TextLabel", playerCard)
gameLabel.BackgroundTransparency = 1
gameLabel.Position = UDim2.new(0, 74, 0, 50)
gameLabel.Size = UDim2.new(1, -88, 0, 14)
gameLabel.Font = Enum.Font.Gotham
gameLabel.Text = "Violence District • " .. game.PlaceId
gameLabel.TextColor3 = col.textDim
gameLabel.TextSize = 9
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.ZIndex = 108

createSpacer(homePage, 4, orderCounter)
orderCounter = orderCounter + 1

-- Stats Row
local statsRow = createDualColumn(homePage, orderCounter)
orderCounter = orderCounter + 1

local pingCard = createInfoCard(statsRow, "Ping", "0ms", "◈", 1)
local fpsCard = createInfoCard(statsRow, "FPS", "60", "◉", 2)

createSpacer(homePage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(homePage, "Quick Actions", orderCounter)
orderCounter = orderCounter + 1

createButton(homePage, "Reset Character", function()
    local hum = getHumanoid()
    if hum then
        hum.Health = 0
        notify("Character reset", 2, "success")
    end
end, orderCounter, "↺")
orderCounter = orderCounter + 1

createButton(homePage, "Rejoin Server", function()
    notify("Rejoining server...", 2, "warning")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, orderCounter, "⟳")
orderCounter = orderCounter + 1

createButton(homePage, "Server Hop", function()
    notify("Finding new server...", 2, "warning")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, orderCounter, "⇄")
orderCounter = orderCounter + 1

createButton(homePage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied to clipboard", 2, "success")
    else
        notify("Clipboard not supported", 2, "error")
    end
end, orderCounter, "⎘")
orderCounter = orderCounter + 1

createSpacer(homePage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(homePage, "Character Actions", orderCounter)
orderCounter = orderCounter + 1

createButton(homePage, "Heal Character", function()
    local hum = getHumanoid()
    if hum then
        hum.Health = hum.MaxHealth
        notify("Character healed", 2, "success")
    end
end, orderCounter, "+", "success")
orderCounter = orderCounter + 1

createButton(homePage, "Teleport to Spawn", function()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            notify("Teleported to spawn", 2, "success")
        end
    else
        notify("No spawn location found", 2, "error")
    end
end, orderCounter, "⌂")
orderCounter = orderCounter + 1

createButton(homePage, "Freeze Character", function()
    local hrp = getHRP()
    if hrp then
        hrp.Anchored = not hrp.Anchored
        notify(hrp.Anchored and "Character frozen" or "Character unfrozen", 2, "success")
    end
end, orderCounter, "❄")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- COMBAT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local combatPage = pages["combat"]
orderCounter = 0

createSectionLabel(combatPage, "Protection", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "God Mode", "god", function(state)
    if state then
        local hum = getHumanoid()
        if hum then
            hum.Name = "H_" .. math.random(100, 999)
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            
            for _, stateType in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                pcall(function()
                    hum:SetStateEnabled(stateType, false)
                end)
            end
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            
            conn.godHealth = hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hum.Health ~= math.huge then
                    hum.Health = math.huge
                end
            end)
            
            conn.godLoop = RunService.Heartbeat:Connect(function()
                if hum.Health ~= math.huge then
                    hum.Health = math.huge
                end
                if hum:GetState() == Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
            
            notify("God Mode enabled", 2, "success")
        end
    else
        if conn.godHealth then conn.godHealth:Disconnect() end
        if conn.godLoop then conn.godLoop:Disconnect() end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Name = "Humanoid"
            hum.MaxHealth = 100
            hum.Health = 100
        end
        notify("God Mode disabled", 2)
    end
end, orderCounter, "Become invincible to all damage")
orderCounter = orderCounter + 1

createSpacer(combatPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(combatPage, "Aimbot", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "Auto Aim", "aim", function(state)
    if state then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestPlayerToMouse(cfg.aimfov)
            if target and target.Character then
                local targetPart = target.Character:FindFirstChild(cfg.aimPart) or target.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local targetPos = targetPart.Position
                    local currentCF = cam.CFrame
                    local targetCF = CFrame.new(currentCF.Position, targetPos)
                    cam.CFrame = currentCF:Lerp(targetCF, cfg.aimSmooth)
                end
            end
        end)
        notify("Auto Aim enabled", 2, "success")
    else
        if conn.aim then conn.aim:Disconnect() end
        notify("Auto Aim disabled", 2)
    end
end, orderCounter, "Automatically aim at nearest player")
orderCounter = orderCounter + 1

createToggle(combatPage, "Show FOV Circle", "showfov", function(state)
    fovCircle.Visible = state
end, orderCounter)
orderCounter = orderCounter + 1

createSlider(combatPage, "FOV Size", 50, 400, "aimfov", function(value)
    fovCircle.Radius = value
end, orderCounter, "px")
orderCounter = orderCounter + 1

createSlider(combatPage, "Aim Smoothness", 0.1, 1, "aimSmooth", function(value)
    -- Applied in aim loop
end, orderCounter, "", 1)
orderCounter = orderCounter + 1

createDropdown(combatPage, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, "aimPart", function(value)
    -- Applied in aim loop
end, orderCounter)
orderCounter = orderCounter + 1

createSpacer(combatPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(combatPage, "Silent Aim", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "Silent Aim (FOV)", "silentAim", function(state)
    if state then
        conn.silentAim = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestPlayerToMouse(cfg.aimfov)
                if target then
                    fireRemotes(target)
                end
            end
        end)
        notify("Silent Aim (FOV) enabled", 2, "success")
    else
        if conn.silentAim then conn.silentAim:Disconnect() end
        notify("Silent Aim (FOV) disabled", 2)
    end
end, orderCounter, "Hit targets within FOV circle")
orderCounter = orderCounter + 1

createToggle(combatPage, "Silent Aim (No FOV)", "silentNoFov", function(state)
    if state then
        conn.silentNoFov = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target, distance = getClosestPlayer()
                if target then
                    fireRemotes(target)
                end
            end
        end)
        notify("Silent Aim (No FOV) enabled", 2, "success")
    else
        if conn.silentNoFov then conn.silentNoFov:Disconnect() end
        notify("Silent Aim (No FOV) disabled", 2)
    end
end, orderCounter, "Hit any visible target")
orderCounter = orderCounter + 1

createSpacer(combatPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(combatPage, "Kill Aura", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "Kill Aura", "killaura", function(state)
    if state then
        conn.aura = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = getDistance(myHRP.Position, hrp.Position)
                        if distance <= cfg.auraRange then
                            if math.random(1, 100) <= cfg.hitChance then
                                fireRemotes(player)
                            end
                        end
                    end
                end
            end
        end)
        notify("Kill Aura enabled", 2, "success")
    else
        if conn.aura then conn.aura:Disconnect() end
        notify("Kill Aura disabled", 2)
    end
end, orderCounter, "Automatically attack nearby players")
orderCounter = orderCounter + 1

createToggle(combatPage, "Show Aura Range", "showAura", function(state)
    auraCircle.Visible = state
end, orderCounter)
orderCounter = orderCounter + 1

createSlider(combatPage, "Aura Range", 5, 30, "auraRange", function(value)
    -- Applied in aura loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createSlider(combatPage, "Hit Chance", 50, 100, "hitChance", function(value)
    -- Applied in combat functions
end, orderCounter, "%")
orderCounter = orderCounter + 1

createSpacer(combatPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(combatPage, "Triggerbot", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "Triggerbot", "triggerbot", function(state)
    if state then
        conn.triggerbot = RunService.RenderStepped:Connect(function()
            local ray = cam:ScreenPointToRay(mouse.X, mouse.Y)
            local raycastResult = Workspace:Raycast(ray.Origin, ray.Direction * 500)
            
            if raycastResult and raycastResult.Instance then
                local hitChar = raycastResult.Instance:FindFirstAncestorOfClass("Model")
                if hitChar then
                    local hitPlayer = Players:GetPlayerFromCharacter(hitChar)
                    if hitPlayer and hitPlayer ~= plr then
                        task.wait(cfg.triggerDelay)
                        mouse1click()
                    end
                end
            end
        end)
        notify("Triggerbot enabled", 2, "success")
    else
        if conn.triggerbot then conn.triggerbot:Disconnect() end
        notify("Triggerbot disabled", 2)
    end
end, orderCounter, "Auto-click when aiming at players")
orderCounter = orderCounter + 1

createSlider(combatPage, "Trigger Delay", 0, 0.5, "triggerDelay", function(value)
    -- Applied in triggerbot loop
end, orderCounter, "s", 2)
orderCounter = orderCounter + 1

createSpacer(combatPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(combatPage, "Combat Assist", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "Auto Parry", "autoParry", function(state)
    if state then
        conn.autoParry = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = getDistance(myHRP.Position, hrp.Position)
                        if distance <= cfg.parryRange then
                            -- Attempt to parry
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") then
                                    local name = remote.Name:lower()
                                    if name:find("parry") or name:find("block") or name:find("defend") then
                                        pcall(function() remote:FireServer() end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Parry enabled", 2, "success")
    else
        if conn.autoParry then conn.autoParry:Disconnect() end
        notify("Auto Parry disabled", 2)
    end
end, orderCounter, "Automatically parry incoming attacks")
orderCounter = orderCounter + 1

createSlider(combatPage, "Parry Range", 5, 20, "parryRange", function(value)
    -- Applied in auto parry loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createToggle(combatPage, "Auto Block", "autoBlock", function(state)
    if state then
        conn.autoBlock = RunService.Heartbeat:Connect(function()
            local myHRP = getHRP()
            if not myHRP then return end
            
            local enemyNearby = false
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and getDistance(myHRP.Position, hrp.Position) <= cfg.blockRange then
                        enemyNearby = true
                        break
                    end
                end
            end
            
            if enemyNearby then
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("block") or name:find("guard") or name:find("shield") then
                            pcall(function() remote:FireServer(true) end)
                        end
                    end
                end
            end
        end)
        notify("Auto Block enabled", 2, "success")
    else
        if conn.autoBlock then conn.autoBlock:Disconnect() end
        notify("Auto Block disabled", 2)
    end
end, orderCounter)
orderCounter = orderCounter + 1

createSlider(combatPage, "Block Range", 5, 25, "blockRange", function(value)
    -- Applied in auto block loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

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
                            if remote:IsA("RemoteEvent") then
                                local name = remote.Name:lower()
                                if name:find("dodge") or name:find("dash") or name:find("roll") then
                                    pcall(function() remote:FireServer() end)
                                end
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Dodge enabled", 2, "success")
    else
        if conn.autoDodge then conn.autoDodge:Disconnect() end
        notify("Auto Dodge disabled", 2)
    end
end, orderCounter)
orderCounter = orderCounter + 1

createSlider(combatPage, "Dodge Range", 3, 15, "dodgeRange", function(value)
    -- Applied in auto dodge loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createSpacer(combatPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(combatPage, "Reach", orderCounter)
orderCounter = orderCounter + 1

createToggle(combatPage, "Extended Reach", "reach", function(state)
    if state then
        conn.reach = RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and isAlive(player.Character) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = getHRP()
                    if hrp and myHRP then
                        local distance = getDistance(myHRP.Position, hrp.Position)
                        if distance <= cfg.reachDistance and distance > 5 then
                            -- Simulate being closer for hit registration
                            hrp.CFrame = CFrame.new(hrp.Position, myHRP.Position) * CFrame.new(0, 0, distance - 4)
                        end
                    end
                end
            end
        end)
        notify("Extended Reach enabled", 2, "success")
    else
        if conn.reach then conn.reach:Disconnect() end
        notify("Extended Reach disabled", 2)
    end
end, orderCounter, "Hit players from further away")
orderCounter = orderCounter + 1

createSlider(combatPage, "Reach Distance", 8, 25, "reachDistance", function(value)
    -- Applied in reach loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createToggle(combatPage, "Hitbox Expander", "hitboxExpander", function(state)
    if state then
        conn.hitbox = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local head = player.Character:FindFirstChild("Head")
                    if hrp then
                        hrp.Size = Vector3.new(cfg.hitboxSize, cfg.hitboxSize, cfg.hitboxSize)
                        hrp.Transparency = 0.8
                    end
                    if head then
                        head.Size = Vector3.new(cfg.hitboxSize, cfg.hitboxSize, cfg.hitboxSize)
                    end
                end
            end
        end)
        notify("Hitbox Expander enabled", 2, "success")
    else
        if conn.hitbox then conn.hitbox:Disconnect() end
        -- Reset hitboxes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")
                if hrp then hrp.Size = Vector3.new(2, 2, 1) hrp.Transparency = 1 end
                if head then head.Size = Vector3.new(2, 1, 1) end
            end
        end
        notify("Hitbox Expander disabled", 2)
    end
end, orderCounter, "Expand enemy hitboxes")
orderCounter = orderCounter + 1

createSlider(combatPage, "Hitbox Size", 2, 15, "hitboxSize", function(value)
    -- Applied in hitbox loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- MOVEMENT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local movementPage = pages["movement"]
orderCounter = 0

createSectionLabel(movementPage, "Speed", orderCounter)
orderCounter = orderCounter + 1

createToggle(movementPage, "Speed Hack", "speedHack", function(state)
    if not state then
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = defaultSpeed end
    end
    notify(state and "Speed Hack enabled" or "Speed Hack disabled", 2, state and "success" or nil)
end, orderCounter, "Increase your walk speed")
orderCounter = orderCounter + 1

createSlider(movementPage, "Walk Speed", 16, 500, "speed", function(value)
    if cfg.speedHack then
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = value end
    end
end, orderCounter, "")
orderCounter = orderCounter + 1

createToggle(movementPage, "Sprint", "sprint", function(state)
    if state then
        conn.sprint = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.LeftShift then
                local hum = getHumanoid()
                if hum then
                    hum.WalkSpeed = (cfg.speedHack and cfg.speed or defaultSpeed) * cfg.sprintMultiplier
                end
            end
        end)
        
        conn.sprintEnd = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftShift then
                local hum = getHumanoid()
                if hum then
                    hum.WalkSpeed = cfg.speedHack and cfg.speed or defaultSpeed
                end
            end
        end)
        notify("Sprint enabled (Hold Shift)", 2, "success")
    else
        if conn.sprint then conn.sprint:Disconnect() end
        if conn.sprintEnd then conn.sprintEnd:Disconnect() end
        notify("Sprint disabled", 2)
    end
end, orderCounter, "Hold Shift to sprint")
orderCounter = orderCounter + 1

createSlider(movementPage, "Sprint Multiplier", 1.5, 5, "sprintMultiplier", function(value)
    -- Applied when sprinting
end, orderCounter, "x", 1)
orderCounter = orderCounter + 1

createSpacer(movementPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(movementPage, "Fly & Noclip", orderCounter)
orderCounter = orderCounter + 1

createToggle(movementPage, "Fly", "fly", function(state)
    if state then
        local hrp = getHRP()
        if hrp then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "VD4_Fly"
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = hrp
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Name = "VD4_FlyGyro"
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.D = 500
            bodyGyro.P = 100000
            bodyGyro.Parent = hrp
            
            conn.fly = RunService.RenderStepped:Connect(function()
                local moveDir = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveDir * cfg.flySpeed
                bodyGyro.CFrame = cam.CFrame
            end)
            notify("Fly enabled (WASD + Space/Ctrl)", 2, "success")
        end
    else
        if conn.fly then conn.fly:Disconnect() end
        local hrp = getHRP()
        if hrp then
            local bv = hrp:FindFirstChild("VD4_Fly")
            local bg = hrp:FindFirstChild("VD4_FlyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
        notify("Fly disabled", 2)
    end
end, orderCounter, "Fly freely in any direction")
orderCounter = orderCounter + 1

createSlider(movementPage, "Fly Speed", 20, 300, "flySpeed", function(value)
    -- Applied in fly loop
end, orderCounter, "")
orderCounter = orderCounter + 1

createToggle(movementPage, "Noclip", "noclip", function(state)
    if state then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        notify("Noclip enabled", 2, "success")
    else
        if conn.noclip then conn.noclip:Disconnect() end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        notify("Noclip disabled", 2)
    end
end, orderCounter, "Walk through walls and objects")
orderCounter = orderCounter + 1

createSpacer(movementPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(movementPage, "Jump Modifications", orderCounter)
orderCounter = orderCounter + 1

createToggle(movementPage, "Infinite Jump", "infiniteJump", function(state)
    if state then
        conn.infJump = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local hum = getHumanoid()
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        notify("Infinite Jump enabled", 2, "success")
    else
        if conn.infJump then conn.infJump:Disconnect() end
        notify("Infinite Jump disabled", 2)
    end
end, orderCounter, "Jump unlimited times in the air")
orderCounter = orderCounter + 1

createToggle(movementPage, "Auto Jump", "autoJump", function(state)
    if state then
        conn.autoJump = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then
                hum.Jump = true
            end
        end)
        notify("Auto Jump enabled", 2, "success")
    else
        if conn.autoJump then conn.autoJump:Disconnect() end
        notify("Auto Jump disabled", 2)
    end
end, orderCounter, "Continuously jump automatically")
orderCounter = orderCounter + 1

createToggle(movementPage, "Moon Jump", "moonJump", function(state)
    if state then
        conn.moonJump = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local hrp = getHRP()
                if hrp then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, cfg.jumpPower, hrp.Velocity.Z)
                end
            end
        end)
        notify("Moon Jump enabled", 2, "success")
    else
        if conn.moonJump then conn.moonJump:Disconnect() end
        notify("Moon Jump disabled", 2)
    end
end, orderCounter, "Jump with custom power")
orderCounter = orderCounter + 1

createSlider(movementPage, "Jump Power", 30, 200, "jumpPower", function(value)
    local hum = getHumanoid()
    if hum then
        hum.JumpPower = value
    end
end, orderCounter, "")
orderCounter = orderCounter + 1

createToggle(movementPage, "Bunny Hop", "bunnyHop", function(state)
    if state then
        conn.bunnyHop = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then
                if hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    if cfg.speedHack then
                        hum.WalkSpeed = cfg.speed * cfg.bunnySpeed
                    else
                        hum.WalkSpeed = defaultSpeed * cfg.bunnySpeed
                    end
                end
            end
        end)
        notify("Bunny Hop enabled", 2, "success")
    else
        if conn.bunnyHop then conn.bunnyHop:Disconnect() end
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = cfg.speedHack and cfg.speed or defaultSpeed
        end
        notify("Bunny Hop disabled", 2)
    end
end, orderCounter, "Auto jump with speed boost")
orderCounter = orderCounter + 1

createSlider(movementPage, "Bunny Speed", 1, 3, "bunnySpeed", function(value)
    -- Applied in bunny hop loop
end, orderCounter, "x", 1)
orderCounter = orderCounter + 1

createSpacer(movementPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(movementPage, "Special Movement", orderCounter)
orderCounter = orderCounter + 1

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
    else
        if conn.noFall then conn.noFall:Disconnect() end
        notify("No Fall Damage disabled", 2)
    end
end, orderCounter, "Prevent fall damage")
orderCounter = orderCounter + 1

createToggle(movementPage, "Air Walk", "airWalk", function(state)
    if state then
        conn.airWalk = RunService.RenderStepped:Connect(function()
            local hrp = getHRP()
            if hrp and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            end
        end)
        notify("Air Walk enabled (Hold Space)", 2, "success")
    else
        if conn.airWalk then conn.airWalk:Disconnect() end
        notify("Air Walk disabled", 2)
    end
end, orderCounter, "Walk in the air while holding Space")
orderCounter = orderCounter + 1

createToggle(movementPage, "Wall Climb", "wallClimb", function(state)
    if state then
        conn.wallClimb = RunService.RenderStepped:Connect(function()
            local hrp = getHRP()
            local hum = getHumanoid()
            if hrp and hum then
                local ray = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3)
                if ray and UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 30, hrp.Velocity.Z)
                end
            end
        end)
        notify("Wall Climb enabled", 2, "success")
    else
        if conn.wallClimb then conn.wallClimb:Disconnect() end
        notify("Wall Climb disabled", 2)
    end
end, orderCounter, "Climb walls by walking into them")
orderCounter = orderCounter + 1

createToggle(movementPage, "Crawl Mode", "crawl", function(state)
    if state then
        local hum = getHumanoid()
        if hum then
            hum.HipHeight = -2
            hum.WalkSpeed = cfg.crawlSpeed
        end
        notify("Crawl Mode enabled", 2, "success")
    else
        local hum = getHumanoid()
        if hum then
            hum.HipHeight = 0
            hum.WalkSpeed = cfg.speedHack and cfg.speed or defaultSpeed
        end
        notify("Crawl Mode disabled", 2)
    end
end, orderCounter, "Crawl on the ground")
orderCounter = orderCounter + 1

createSlider(movementPage, "Crawl Speed", 4, 20, "crawlSpeed", function(value)
    if cfg.crawl then
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = value end
    end
end, orderCounter, "")
orderCounter = orderCounter + 1

createToggle(movementPage, "Auto Walk", "autoWalk", function(state)
    if state then
        conn.autoWalk = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then
                hum:Move(Vector3.new(0, 0, -1), true)
            end
        end)
        notify("Auto Walk enabled", 2, "success")
    else
        if conn.autoWalk then conn.autoWalk:Disconnect() end
        notify("Auto Walk disabled", 2)
    end
end, orderCounter, "Walk forward automatically")
orderCounter = orderCounter + 1

createSpacer(movementPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(movementPage, "Teleport", orderCounter)
orderCounter = orderCounter + 1

createButton(movementPage, "Teleport to Mouse", function()
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        notify("Teleported to mouse position", 2, "success")
    end
end, orderCounter, "⤴")
orderCounter = orderCounter + 1

createButton(movementPage, "Save Waypoint", function()
    local hrp = getHRP()
    if hrp then
        table.insert(waypoints, hrp.CFrame)
        notify("Waypoint #" .. #waypoints .. " saved", 2, "success")
    end
end, orderCounter, "◆")
orderCounter = orderCounter + 1

createButton(movementPage, "Teleport to Last Waypoint", function()
    local hrp = getHRP()
    if hrp and #waypoints > 0 then
        hrp.CFrame = waypoints[#waypoints]
        notify("Teleported to waypoint #" .. #waypoints, 2, "success")
    else
        notify("No waypoints saved", 2, "error")
    end
end, orderCounter, "◇")
orderCounter = orderCounter + 1

createButton(movementPage, "Clear Waypoints", function()
    waypoints = {}
    notify("All waypoints cleared", 2, "success")
end, orderCounter, "✕", "danger")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- VISUAL PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local visualPage = pages["visual"]
orderCounter = 0

createSectionLabel(visualPage, "Lighting", orderCounter)
orderCounter = orderCounter + 1

createToggle(visualPage, "Remove Fog", "fog", function(state)
    if state then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        notify("Fog removed", 2, "success")
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
        notify("Fog restored", 2)
    end
end, orderCounter, "Remove all fog effects")
orderCounter = orderCounter + 1

createToggle(visualPage, "Fullbright", "bright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
        Lighting.Ambient = Color3.fromRGB(170, 170, 170)
        
        for _, effect in pairs(Lighting:GetDescendants()) do
            if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
                effect.Enabled = false
            end
        end
        notify("Fullbright enabled", 2, "success")
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        notify("Fullbright disabled", 2)
    end
end, orderCounter, "Maximum brightness and visibility")
orderCounter = orderCounter + 1

createToggle(visualPage, "Lock Time of Day", "lockTime", function(state)
    if state then
        conn.lockTime = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = cfg.timeOfDay
        end)
        notify("Time locked", 2, "success")
    else
        if conn.lockTime then conn.lockTime:Disconnect() end
        notify("Time unlocked", 2)
    end
end, orderCounter, "Lock the in-game time")
orderCounter = orderCounter + 1

createSlider(visualPage, "Time of Day", 0, 24, "timeOfDay", function(value)
    Lighting.ClockTime = value
end, orderCounter, "h")
orderCounter = orderCounter + 1

createSpacer(visualPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(visualPage, "Camera", orderCounter)
orderCounter = orderCounter + 1

createSlider(visualPage, "Field of View", 30, 120, "fov", function(value)
    cam.FieldOfView = value
end, orderCounter, "°")
orderCounter = orderCounter + 1

createToggle(visualPage, "Cinematic Bars", "cinematicBars", function(state)
    if state then
        local topBar = Instance.new("Frame", gui)
        topBar.Name = "CinematicTop"
        topBar.BackgroundColor3 = Color3.new(0, 0, 0)
        topBar.BorderSizePixel = 0
        topBar.Size = UDim2.new(1, 0, cfg.barsSize, 0)
        topBar.Position = UDim2.new(0, 0, 0, 0)
        topBar.ZIndex = 999
        
        local bottomBar = Instance.new("Frame", gui)
        bottomBar.Name = "CinematicBottom"
        bottomBar.BackgroundColor3 = Color3.new(0, 0, 0)
        bottomBar.BorderSizePixel = 0
        bottomBar.Size = UDim2.new(1, 0, cfg.barsSize, 0)
        bottomBar.Position = UDim2.new(0, 0, 1 - cfg.barsSize, 0)
        bottomBar.ZIndex = 999
        
        notify("Cinematic bars enabled", 2, "success")
    else
        local topBar = gui:FindFirstChild("CinematicTop")
        local bottomBar = gui:FindFirstChild("CinematicBottom")
        if topBar then topBar:Destroy() end
        if bottomBar then bottomBar:Destroy() end
        notify("Cinematic bars disabled", 2)
    end
end, orderCounter, "Add movie-style black bars")
orderCounter = orderCounter + 1

createSlider(visualPage, "Bar Size", 0.05, 0.2, "barsSize", function(value)
    local topBar = gui:FindFirstChild("CinematicTop")
    local bottomBar = gui:FindFirstChild("CinematicBottom")
    if topBar then topBar.Size = UDim2.new(1, 0, value, 0) end
    if bottomBar then
        bottomBar.Size = UDim2.new(1, 0, value, 0)
        bottomBar.Position = UDim2.new(0, 0, 1 - value, 0)
    end
end, orderCounter, "", 2)
orderCounter = orderCounter + 1

createSpacer(visualPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(visualPage, "Character Visuals", orderCounter)
orderCounter = orderCounter + 1

createToggle(visualPage, "Invisible", "invisible", function(state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = state and 1 or 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = state and 1 or 0
        end
    end
    
    for _, accessory in pairs(char:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = state and 1 or 0
            end
        end
    end
    
    notify(state and "Invisible enabled" or "Invisible disabled", 2, state and "success" or nil)
end, orderCounter, "Make your character invisible")
orderCounter = orderCounter + 1

createToggle(visualPage, "Rainbow Character", "rainbowCharacter", function(state)
    if state then
        conn.rainbowChar = RunService.RenderStepped:Connect(function()
            local rainbow = Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = rainbow
                end
            end
        end)
        notify("Rainbow Character enabled", 2, "success")
    else
        if conn.rainbowChar then conn.rainbowChar:Disconnect() end
        notify("Rainbow Character disabled", 2)
    end
end, orderCounter, "Cycle through rainbow colors")
orderCounter = orderCounter + 1

createToggle(visualPage, "Forcefield", "forcefield", function(state)
    if state then
        local ff = Instance.new("ForceField", char)
        ff.Name = "VD4_Forcefield"
        ff.Visible = true
        notify("Forcefield enabled", 2, "success")
    else
        local ff = char:FindFirstChild("VD4_Forcefield")
        if ff then ff:Destroy() end
        notify("Forcefield disabled", 2)
    end
end, orderCounter, "Show forcefield effect")
orderCounter = orderCounter + 1

createToggle(visualPage, "Character Trail", "trail", function(state)
    if state then
        local hrp = getHRP()
        if hrp then
            local attachment0 = Instance.new("Attachment", hrp)
            attachment0.Name = "VD4_TrailAttach0"
            attachment0.Position = Vector3.new(0, 1, 0)
            
            local attachment1 = Instance.new("Attachment", hrp)
            attachment1.Name = "VD4_TrailAttach1"
            attachment1.Position = Vector3.new(0, -1, 0)
            
            local trail = Instance.new("Trail", hrp)
            trail.Name = "VD4_Trail"
            trail.Attachment0 = attachment0
            trail.Attachment1 = attachment1
            trail.Color = ColorSequence.new(cfg.trailColor)
            trail.Transparency = NumberSequence.new(0, 1)
            trail.Lifetime = 0.5
            trail.MinLength = 0.1
            trail.LightEmission = 0.5
        end
        notify("Trail enabled", 2, "success")
    else
        local hrp = getHRP()
        if hrp then
            local trail = hrp:FindFirstChild("VD4_Trail")
            local attach0 = hrp:FindFirstChild("VD4_TrailAttach0")
            local attach1 = hrp:FindFirstChild("VD4_TrailAttach1")
            if trail then trail:Destroy() end
            if attach0 then attach0:Destroy() end
            if attach1 then attach1:Destroy() end
        end
        notify("Trail disabled", 2)
    end
end, orderCounter, "Add a trail behind your character")
orderCounter = orderCounter + 1

createToggle(visualPage, "Character Particles", "particles", function(state)
    if state then
        local hrp = getHRP()
        if hrp then
            local particle = Instance.new("ParticleEmitter", hrp)
            particle.Name = "VD4_Particles"
            particle.Color = ColorSequence.new(cfg.particleColor)
            particle.Size = NumberSequence.new(0.3, 0)
            particle.Lifetime = NumberRange.new(0.5, 1)
            particle.Rate = 50
            particle.Speed = NumberRange.new(2, 5)
            particle.SpreadAngle = Vector2.new(180, 180)
            particle.LightEmission = 0.5
        end
        notify("Particles enabled", 2, "success")
    else
        local hrp = getHRP()
        if hrp then
            local particle = hrp:FindFirstChild("VD4_Particles")
            if particle then particle:Destroy() end
        end
        notify("Particles disabled", 2)
    end
end, orderCounter, "Add particle effects to your character")
orderCounter = orderCounter + 1

createSpacer(visualPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(visualPage, "World Effects", orderCounter)
orderCounter = orderCounter + 1

createToggle(visualPage, "X-Ray Walls", "xray", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            local name = obj.Name:lower()
            if name:find("wall") or name:find("door") or name:find("window") or name:find("barrier") then
                if state then
                    if not obj:GetAttribute("VD4_OrigTransparency") then
                        obj:SetAttribute("VD4_OrigTransparency", obj.Transparency)
                    end
                    obj.Transparency = cfg.xrayTransparency
                else
                    local orig = obj:GetAttribute("VD4_OrigTransparency")
                    if orig then
                        obj.Transparency = orig
                        obj:SetAttribute("VD4_OrigTransparency", nil)
                    end
                end
            end
        end
    end
    notify(state and "X-Ray enabled" or "X-Ray disabled", 2, state and "success" or nil)
end, orderCounter, "See through walls")
orderCounter = orderCounter + 1

createSlider(visualPage, "X-Ray Transparency", 0.3, 0.9, "xrayTransparency", function(value)
    if cfg.xray then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:GetAttribute("VD4_OrigTransparency") then
                obj.Transparency = value
            end
        end
    end
end, orderCounter, "", 1)
orderCounter = orderCounter + 1

createToggle(visualPage, "No Particles", "noParticles", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = not state
        end
    end
    notify(state and "Particles disabled" or "Particles enabled", 2, state and "success" or nil)
end, orderCounter, "Disable all world particles")
orderCounter = orderCounter + 1

createToggle(visualPage, "No Effects", "noEffects", function(state)
    for _, effect in pairs(Lighting:GetDescendants()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = not state
        end
    end
    notify(state and "Effects disabled" or "Effects enabled", 2, state and "success" or nil)
end, orderCounter, "Disable post-processing effects")
orderCounter = orderCounter + 1

createToggle(visualPage, "Rainbow Sky", "rainbowSky", function(state)
    if state then
        conn.rainbowSky = RunService.RenderStepped:Connect(function()
            local rainbow = Color3.fromHSV(tick() % 10 / 10, 0.5, 0.9)
            Lighting.Ambient = rainbow
            Lighting.OutdoorAmbient = rainbow
        end)
        notify("Rainbow Sky enabled", 2, "success")
    else
        if conn.rainbowSky then conn.rainbowSky:Disconnect() end
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        notify("Rainbow Sky disabled", 2)
    end
end, orderCounter, "Rainbow ambient lighting")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local espPage = pages["esp"]
orderCounter = 0

createSectionLabel(espPage, "Player ESP", orderCounter)
orderCounter = orderCounter + 1

createToggle(espPage, "Enable ESP", "esp", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                createESP(player)
            end
        end
        notify("ESP enabled", 2, "success")
    else
        clearESP()
        notify("ESP disabled", 2)
    end
end, orderCounter, "See players through walls")
orderCounter = orderCounter + 1

createToggle(espPage, "RGB Effect", "espRgb", function(state)
    notify(state and "RGB ESP enabled" or "RGB ESP disabled", 2, state and "success" or nil)
end, orderCounter, "Rainbow color cycle for ESP")
orderCounter = orderCounter + 1

createToggle(espPage, "Show Health", "espShowHealth", function(state)
    notify(state and "Health display enabled" or "Health display disabled", 2)
end, orderCounter)
orderCounter = orderCounter + 1

createToggle(espPage, "Show Distance", "espShowDistance", function(state)
    notify(state and "Distance display enabled" or "Distance display disabled", 2)
end, orderCounter)
orderCounter = orderCounter + 1

createToggle(espPage, "Show Name", "espShowName", function(state)
    notify(state and "Name display enabled" or "Name display disabled", 2)
end, orderCounter)
orderCounter = orderCounter + 1

createSlider(espPage, "Max Distance", 100, 2000, "espDistance", function(value)
    -- Applied in ESP update loop
end, orderCounter, "m")
orderCounter = orderCounter + 1

createSpacer(espPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(espPage, "ESP Mode", orderCounter)
orderCounter = orderCounter + 1

createButton(espPage, "Nametag Mode", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESP(player) end
        end
    end
    notify("ESP Mode: Nametag", 2, "success")
    task.spawn(saveSettings)
end, orderCounter, "◇")
orderCounter = orderCounter + 1

createButton(espPage, "Highlight Mode", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESP(player) end
        end
    end
    notify("ESP Mode: Highlight", 2, "success")
    task.spawn(saveSettings)
end, orderCounter, "◈")
orderCounter = orderCounter + 1

createButton(espPage, "Box Mode", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then createESP(player) end
        end
    end
    notify("ESP Mode: Box", 2, "success")
    task.spawn(saveSettings)
end, orderCounter, "▢")
orderCounter = orderCounter + 1

createSpacer(espPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(espPage, "Tracers", orderCounter)
orderCounter = orderCounter + 1

createToggle(espPage, "Enable Tracers", "tracers", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character then
                local tracer = Drawing.new("Line")
                tracer.Visible = true
                tracer.Color = cfg.tracerColor
                tracer.Thickness = 1.5
                tracer.Transparency = 0.7
                tracerData[player] = tracer
            end
        end
        notify("Tracers enabled", 2, "success")
    else
        clearTracers()
        notify("Tracers disabled", 2)
    end
end, orderCounter, "Draw lines to players")
orderCounter = orderCounter + 1

createDropdown(espPage, "Tracer Origin", {"Bottom", "Center", "Top", "Mouse"}, "tracerOrigin", function(value)
    -- Applied in tracer update
end, orderCounter)
orderCounter = orderCounter + 1

createSpacer(espPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(espPage, "Chams", orderCounter)
orderCounter = orderCounter + 1

createToggle(espPage, "Enable Chams", "chams", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.Name = "VD4_Chams"
                highlight.FillColor = cfg.chamsColor
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                chamsData[player] = highlight
            end
        end
        notify("Chams enabled", 2, "success")
    else
        clearChams()
        notify("Chams disabled", 2)
    end
end, orderCounter, "Colored character overlay")
orderCounter = orderCounter + 1

createSpacer(espPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(espPage, "Object ESP", orderCounter)
orderCounter = orderCounter + 1

createToggle(espPage, "Item ESP", "itemEsp", function(state)
    if state then
        conn.itemEsp = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Name:lower():find("item")) then
                    if not obj:FindFirstChild("VD4_ItemESP") then
                        local billboard = Instance.new("BillboardGui", obj)
                        billboard.Name = "VD4_ItemESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 50, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        
                        local label = Instance.new("TextLabel", billboard)
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Font = Enum.Font.GothamBold
                        label.Text = obj.Name
                        label.TextColor3 = Color3.fromRGB(255, 200, 100)
                        label.TextScaled = true
                        label.TextStrokeTransparency = 0.5
                    end
                end
            end
        end)
        notify("Item ESP enabled", 2, "success")
    else
        if conn.itemEsp then conn.itemEsp:Disconnect() end
        for _, obj in pairs(Workspace:GetDescendants()) do
            local esp = obj:FindFirstChild("VD4_ItemESP")
            if esp then esp:Destroy() end
        end
        notify("Item ESP disabled", 2)
    end
end, orderCounter, "See items through walls")
orderCounter = orderCounter + 1

createToggle(espPage, "NPC ESP", "npcEsp", function(state)
    if state then
        conn.npcEsp = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                    local player = Players:GetPlayerFromCharacter(obj)
                    if not player and not obj:FindFirstChild("VD4_NPCESP") then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                        if hrp then
                            local billboard = Instance.new("BillboardGui", hrp)
                            billboard.Name = "VD4_NPCESP"
                            billboard.AlwaysOnTop = true
                            billboard.Size = UDim2.new(0, 60, 0, 25)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            
                            local label = Instance.new("TextLabel", billboard)
                            label.BackgroundTransparency = 1
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.Font = Enum.Font.GothamBold
                            label.Text = obj.Name
                            label.TextColor3 = Color3.fromRGB(255, 100, 100)
                            label.TextScaled = true
                            label.TextStrokeTransparency = 0.5
                        end
                    end
                end
            end
        end)
        notify("NPC ESP enabled", 2, "success")
    else
        if conn.npcEsp then conn.npcEsp:Disconnect() end
        for _, obj in pairs(Workspace:GetDescendants()) do
            local esp = obj:FindFirstChild("VD4_NPCESP")
            if esp then esp:Destroy() end
        end
        notify("NPC ESP disabled", 2)
    end
end, orderCounter, "See NPCs through walls")
orderCounter = orderCounter + 1

createToggle(espPage, "Vehicle ESP", "vehicleEsp", function(state)
    if state then
        conn.vehicleEsp = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") or (obj:IsA("Model") and obj:FindFirstChildOfClass("VehicleSeat")) then
                    local target = obj:IsA("VehicleSeat") and obj or obj:FindFirstChildOfClass("VehicleSeat")
                    if target and not target:FindFirstChild("VD4_VehicleESP") then
                        local billboard = Instance.new("BillboardGui", target)
                        billboard.Name = "VD4_VehicleESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 60, 0, 25)
                        billboard.StudsOffset = Vector3.new(0, 4, 0)
                        
                        local label = Instance.new("TextLabel", billboard)
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Font = Enum.Font.GothamBold
                        label.Text = "Vehicle"
                        label.TextColor3 = Color3.fromRGB(100, 200, 255)
                        label.TextScaled = true
                        label.TextStrokeTransparency = 0.5
                    end
                end
            end
        end)
        notify("Vehicle ESP enabled", 2, "success")
    else
        if conn.vehicleEsp then conn.vehicleEsp:Disconnect() end
        for _, obj in pairs(Workspace:GetDescendants()) do
            local esp = obj:FindFirstChild("VD4_VehicleESP")
            if esp then esp:Destroy() end
        end
        notify("Vehicle ESP disabled", 2)
    end
end, orderCounter, "See vehicles through walls")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- CHARACTER PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local characterPage = pages["character"]
orderCounter = 0

createSectionLabel(characterPage, "Character Mods", orderCounter)
orderCounter = orderCounter + 1

createToggle(characterPage, "No Ragdoll", "noRagdoll", function(state)
    if state then
        conn.noRagdoll = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            end
        end)
        notify("No Ragdoll enabled", 2, "success")
    else
        if conn.noRagdoll then conn.noRagdoll:Disconnect() end
        notify("No Ragdoll disabled", 2)
    end
end, orderCounter, "Prevent character from ragdolling")
orderCounter = orderCounter + 1

createToggle(characterPage, "Infinite Stamina", "infiniteStamina", function(state)
    if state then
        conn.stamina = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(plr.PlayerGui:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    local name = obj.Name:lower()
                    if name:find("stamina") or name:find("energy") or name:find("endurance") then
                        obj.Value = obj.Value + 100
                    end
                end
            end
            
            for _, obj in pairs(plr:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    local name = obj.Name:lower()
                    if name:find("stamina") or name:find("energy") or name:find("endurance") then
                        obj.Value = obj.Value + 100
                    end
                end
            end
        end)
        notify("Infinite Stamina enabled", 2, "success")
    else
        if conn.stamina then conn.stamina:Disconnect() end
        notify("Infinite Stamina disabled", 2)
    end
end, orderCounter, "Never run out of stamina")
orderCounter = orderCounter + 1

createToggle(characterPage, "Anti Void", "antiVoid", function(state)
    if state then
        local safePos = getHRP() and getHRP().CFrame or CFrame.new(0, 50, 0)
        conn.antiVoid = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp then
                if hrp.Position.Y > -50 then
                    safePos = hrp.CFrame
                end
                if hrp.Position.Y < -100 then
                    hrp.CFrame = safePos
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        notify("Anti Void enabled", 2, "success")
    else
        if conn.antiVoid then conn.antiVoid:Disconnect() end
        notify("Anti Void disabled", 2)
    end
end, orderCounter, "Teleport back if you fall into void")
orderCounter = orderCounter + 1

createSpacer(characterPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(characterPage, "Physics", orderCounter)
orderCounter = orderCounter + 1

createToggle(characterPage, "Low Gravity", "lowGravity", function(state)
    Workspace.Gravity = state and 50 or defaultGravity
    notify(state and "Low Gravity enabled" or "Gravity restored", 2, state and "success" or nil)
end, orderCounter, "Reduce gravity for moon-like movement")
orderCounter = orderCounter + 1

createSlider(characterPage, "Custom Gravity", 10, 300, "customGravity", function(value)
    if cfg.lowGravity then
        Workspace.Gravity = value
    end
end, orderCounter, "")
orderCounter = orderCounter + 1

createSpacer(characterPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(characterPage, "Size Modifications", orderCounter)
orderCounter = orderCounter + 1

createSlider(characterPage, "Character Size", 0.5, 3, "characterSize", function(value)
    local hum = getHumanoid()
    if hum then
        local bodyDepth = hum:FindFirstChild("BodyDepthScale")
        local bodyHeight = hum:FindFirstChild("BodyHeightScale")
        local bodyWidth = hum:FindFirstChild("BodyWidthScale")
        local headScale = hum:FindFirstChild("HeadScale")
        
        if bodyDepth then bodyDepth.Value = value end
        if bodyHeight then bodyHeight.Value = value end
        if bodyWidth then bodyWidth.Value = value end
        if headScale then headScale.Value = value end
    end
end, orderCounter, "x", 1)
orderCounter = orderCounter + 1

createSlider(characterPage, "Head Size", 0.5, 5, "headSize", function(value)
    local head = char:FindFirstChild("Head")
    if head then
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if mesh then
            mesh.Scale = Vector3.new(value, value, value)
        end
    end
end, orderCounter, "x", 1)
orderCounter = orderCounter + 1

createButton(characterPage, "Reset Size", function()
    local hum = getHumanoid()
    if hum then
        local bodyDepth = hum:FindFirstChild("BodyDepthScale")
        local bodyHeight = hum:FindFirstChild("BodyHeightScale")
        local bodyWidth = hum:FindFirstChild("BodyWidthScale")
        local headScale = hum:FindFirstChild("HeadScale")
        
        if bodyDepth then bodyDepth.Value = 1 end
        if bodyHeight then bodyHeight.Value = 1 end
        if bodyWidth then bodyWidth.Value = 1 end
        if headScale then headScale.Value = 1 end
    end
    cfg.characterSize = 1
    cfg.headSize = 1
    notify("Size reset to default", 2, "success")
end, orderCounter, "↺")
orderCounter = orderCounter + 1

createSpacer(characterPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(characterPage, "Animation", orderCounter)
orderCounter = orderCounter + 1

createToggle(characterPage, "No Animations", "noAnimations", function(state)
    local hum = getHumanoid()
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            if state then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                conn.noAnim = animator.AnimationPlayed:Connect(function(track)
                    track:Stop()
                end)
            else
                if conn.noAnim then conn.noAnim:Disconnect() end
            end
        end
    end
    notify(state and "Animations disabled" or "Animations enabled", 2, state and "success" or nil)
end, orderCounter, "Stop all character animations")
orderCounter = orderCounter + 1

createTextInput(characterPage, "Animation ID", "animationId", "Enter animation ID...", function(value)
    -- Will be used when playing animation
end, orderCounter)
orderCounter = orderCounter + 1

createButton(characterPage, "Play Animation", function()
    local hum = getHumanoid()
    if hum and cfg.animationId ~= "" then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(cfg.animationId)
            local track = animator:LoadAnimation(anim)
            track:Play()
            notify("Playing animation", 2, "success")
        end
    else
        notify("Enter an animation ID first", 2, "error")
    end
end, orderCounter, "▶")
orderCounter = orderCounter + 1

createButton(characterPage, "Stop All Animations", function()
    local hum = getHumanoid()
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            notify("All animations stopped", 2, "success")
        end
    end
end, orderCounter, "■")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- WORLD PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local worldPage = pages["world"]
orderCounter = 0

createSectionLabel(worldPage, "World Modifications", orderCounter)
orderCounter = orderCounter + 1

createSlider(worldPage, "World Gravity", 10, 400, "worldGravity", function(value)
    Workspace.Gravity = value
end, orderCounter, "")
orderCounter = orderCounter + 1

createToggle(worldPage, "No Weather", "noWeather", function(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                local name = obj.Name:lower()
                if name:find("rain") or name:find("snow") or name:find("weather") then
                    obj.Enabled = false
                end
            end
        end
        notify("Weather disabled", 2, "success")
    else
        notify("Weather effects may return", 2)
    end
end, orderCounter, "Disable rain and snow effects")
orderCounter = orderCounter + 1

createToggle(worldPage, "No Sounds", "noSounds", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj.Volume = state and 0 or 1
        end
    end
    notify(state and "Sounds muted" or "Sounds restored", 2, state and "success" or nil)
end, orderCounter, "Mute all game sounds")
orderCounter = orderCounter + 1

createToggle(worldPage, "No Music", "noMusic", function(state)
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Sound") then
            local name = obj.Name:lower()
            if name:find("music") or name:find("bgm") or name:find("soundtrack") or obj.PlaybackLoudness > 0.5 then
                if state then
                    obj:SetAttribute("VD4_OrigVolume", obj.Volume)
                    obj.Volume = 0
                else
                    local origVol = obj:GetAttribute("VD4_OrigVolume")
                    if origVol then obj.Volume = origVol end
                end
            end
        end
    end
    notify(state and "Music muted" or "Music restored", 2, state and "success" or nil)
end, orderCounter, "Mute background music")
orderCounter = orderCounter + 1

createSpacer(worldPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(worldPage, "Performance", orderCounter)
orderCounter = orderCounter + 1

createToggle(worldPage, "Anti Lag", "antiLag", function(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            end
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
            if obj:IsA("MeshPart") then
                obj.TextureID = ""
            end
        end
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        notify("Anti Lag enabled (Low quality)", 2, "success")
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        notify("Anti Lag disabled", 2)
    end
end, orderCounter, "Reduce lag by disabling effects")
orderCounter = orderCounter + 1

createToggle(worldPage, "No Textures", "noTextures", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = state and 1 or 0
        end
    end
    notify(state and "Textures hidden" or "Textures restored", 2, state and "success" or nil)
end, orderCounter, "Hide all textures")
orderCounter = orderCounter + 1

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
end, orderCounter, "Set graphics to minimum")
orderCounter = orderCounter + 1

createSpacer(worldPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(worldPage, "Items & Objects", orderCounter)
orderCounter = orderCounter + 1

createToggle(worldPage, "Magnet Items", "magnetItems", function(state)
    if state then
        conn.magnet = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if not hrp then return end
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") or (obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector")) then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChild("Handle")
                    if part then
                        local distance = getDistance(hrp.Position, part.Position)
                        if distance <= cfg.magnetRange then
                            part.CFrame = hrp.CFrame
                        end
                    end
                end
            end
        end)
        notify("Magnet Items enabled", 2, "success")
    else
        if conn.magnet then conn.magnet:Disconnect() end
        notify("Magnet Items disabled", 2)
    end
end, orderCounter, "Pull nearby items to you")
orderCounter = orderCounter + 1

createSlider(worldPage, "Magnet Range", 10, 100, "magnetRange", function(value)
    -- Applied in magnet loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createButton(worldPage, "Collect All Items", function()
    local collected = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            pcall(function()
                obj.Parent = plr.Backpack
                collected = collected + 1
            end)
        end
    end
    notify("Collected " .. collected .. " items", 2, "success")
end, orderCounter, "⬇")
orderCounter = orderCounter + 1

createButton(worldPage, "Click All ClickDetectors", function()
    local clicked = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            pcall(function()
                fireclickdetector(obj)
                clicked = clicked + 1
            end)
        end
    end
    notify("Clicked " .. clicked .. " detectors", 2, "success")
end, orderCounter, "◉")
orderCounter = orderCounter + 1

createButton(worldPage, "Touch All TouchInterests", function()
    local touched = 0
    local hrp = getHRP()
    if hrp then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") then
                pcall(function()
                    firetouchinterest(hrp, obj.Parent, 0)
                    task.wait()
                    firetouchinterest(hrp, obj.Parent, 1)
                    touched = touched + 1
                end)
            end
        end
    end
    notify("Touched " .. touched .. " objects", 2, "success")
end, orderCounter, "✋")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- UTILITY PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local utilityPage = pages["utility"]
orderCounter = 0

createSectionLabel(utilityPage, "Anti Features", orderCounter)
orderCounter = orderCounter + 1

createToggle(utilityPage, "Anti AFK", "antiAfk", function(state)
    if state then
        setupAntiAFK()
        notify("Anti AFK enabled", 2, "success")
    else
        notify("Anti AFK disabled (rejoin to fully disable)", 2)
    end
end, orderCounter, "Prevent being kicked for inactivity")
orderCounter = orderCounter + 1

createToggle(utilityPage, "Anti Kick", "antiKick", function(state)
    if state then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        notify("Anti Kick enabled", 2, "success")
    else
        notify("Anti Kick disabled", 2)
    end
end, orderCounter, "Prevent being kicked from the game")
orderCounter = orderCounter + 1

createToggle(utilityPage, "Auto Rejoin", "autoRejoin", function(state)
    if state then
        conn.autoRejoin = plr.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Failed then
                task.wait(5)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
            end
        end)
        notify("Auto Rejoin enabled", 2, "success")
    else
        if conn.autoRejoin then conn.autoRejoin:Disconnect() end
        notify("Auto Rejoin disabled", 2)
    end
end, orderCounter, "Auto rejoin if teleport fails")
orderCounter = orderCounter + 1

createSpacer(utilityPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(utilityPage, "Auto Farm", orderCounter)
orderCounter = orderCounter + 1

createToggle(utilityPage, "Auto Farm", "autoFarm", function(state)
    if state then
        conn.autoFarm = RunService.Heartbeat:Connect(function()
            local target, distance = getClosestPlayer()
            if target and distance and distance < 30 then
                local myHRP = getHRP()
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and targetHRP then
                    -- Move towards target
                    local hum = getHumanoid()
                    if hum then
                        hum:MoveTo(targetHRP.Position)
                    end
                    
                    -- Attack if close enough
                    if distance < 10 then
                        fireRemotes(target)
                    end
                end
            end
        end)
        notify("Auto Farm enabled", 2, "success")
    else
        if conn.autoFarm then conn.autoFarm:Disconnect() end
        notify("Auto Farm disabled", 2)
    end
end, orderCounter, "Automatically farm players/NPCs")
orderCounter = orderCounter + 1

createToggle(utilityPage, "Auto Collect", "autoCollect", function(state)
    if state then
        conn.autoCollect = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if not hrp then return end
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") or obj:FindFirstChild("ClickDetector") then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChild("Handle")
                    if part then
                        local distance = getDistance(hrp.Position, part.Position)
                        if distance <= cfg.collectRange then
                            if obj:IsA("Tool") then
                                pcall(function() obj.Parent = plr.Backpack end)
                            elseif obj:FindFirstChild("ClickDetector") then
                                pcall(function() fireclickdetector(obj.ClickDetector) end)
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Collect enabled", 2, "success")
    else
        if conn.autoCollect then conn.autoCollect:Disconnect() end
        notify("Auto Collect disabled", 2)
    end
end, orderCounter, "Automatically collect nearby items")
orderCounter = orderCounter + 1

createSlider(utilityPage, "Collect Range", 10, 100, "collectRange", function(value)
    -- Applied in auto collect loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createSpacer(utilityPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(utilityPage, "Chat", orderCounter)
orderCounter = orderCounter + 1

createToggle(utilityPage, "Chat Spam", "chatSpam", function(state)
    if state then
        conn.chatSpam = task.spawn(function()
            while cfg.chatSpam do
                pcall(function()
                    local args = {
                        cfg.spamMessage,
                        "All"
                    }
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
                end)
                task.wait(cfg.spamDelay)
            end
        end)
        notify("Chat Spam enabled", 2, "success")
    else
        notify("Chat Spam disabled", 2)
    end
end, orderCounter, "Spam messages in chat")
orderCounter = orderCounter + 1

createTextInput(utilityPage, "Spam Message", "spamMessage", "Enter message...", function(value)
    -- Message updated
end, orderCounter)
orderCounter = orderCounter + 1

createSlider(utilityPage, "Spam Delay", 0.5, 10, "spamDelay", function(value)
    -- Applied in spam loop
end, orderCounter, "s", 1)
orderCounter = orderCounter + 1

createSpacer(utilityPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(utilityPage, "Information", orderCounter)
orderCounter = orderCounter + 1

createButton(utilityPage, "Copy Game ID", function()
    if setclipboard then
        setclipboard(tostring(game.PlaceId))
        notify("Game ID copied: " .. game.PlaceId, 2, "success")
    else
        notify("Clipboard not supported", 2, "error")
    end
end, orderCounter, "⎘")
orderCounter = orderCounter + 1

createButton(utilityPage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied", 2, "success")
    else
        notify("Clipboard not supported", 2, "error")
    end
end, orderCounter, "⎘")
orderCounter = orderCounter + 1

createButton(utilityPage, "Copy Player List", function()
    if setclipboard then
        local list = ""
        for _, player in pairs(Players:GetPlayers()) do
            list = list .. player.Name .. " (" .. player.DisplayName .. ")\n"
        end
        setclipboard(list)
        notify("Player list copied", 2, "success")
    else
        notify("Clipboard not supported", 2, "error")
    end
end, orderCounter, "⎘")
orderCounter = orderCounter + 1

createButton(utilityPage, "Print Explorer", function()
    local function printTree(obj, indent)
        print(string.rep("  ", indent) .. obj.ClassName .. ": " .. obj.Name)
        for _, child in pairs(obj:GetChildren()) do
            printTree(child, indent + 1)
        end
    end
    printTree(Workspace, 0)
    notify("Explorer printed to console", 2, "success")
end, orderCounter, "📋")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- CAMERA PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local cameraPage = pages["camera"]
orderCounter = 0

createSectionLabel(cameraPage, "Camera Modes", orderCounter)
orderCounter = orderCounter + 1

createToggle(cameraPage, "Free Camera", "freeCam", function(state)
    if state then
        local freeCamPos = cam.CFrame
        local freeCamVel = Vector3.new(0, 0, 0)
        
        local hum = getHumanoid()
        if hum then
            cam.CameraSubject = nil
        end
        
        conn.freeCam = RunService.RenderStepped:Connect(function(dt)
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            local speed = cfg.freeCamSpeed * 50
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                speed = speed * 2
            end
            
            freeCamPos = freeCamPos + moveDir * speed * dt
            cam.CFrame = CFrame.new(freeCamPos.Position) * CFrame.fromEulerAnglesYXZ(
                cam.CFrame:ToEulerAnglesYXZ()
            )
        end)
        notify("Free Camera enabled (WASD + Q/E)", 2, "success")
    else
        if conn.freeCam then conn.freeCam:Disconnect() end
        local hum = getHumanoid()
        if hum then
            cam.CameraSubject = hum
        end
        notify("Free Camera disabled", 2)
    end
end, orderCounter, "Freely move camera anywhere")
orderCounter = orderCounter + 1

createSlider(cameraPage, "Free Cam Speed", 0.5, 5, "freeCamSpeed", function(value)
    -- Applied in freecam loop
end, orderCounter, "x", 1)
orderCounter = orderCounter + 1

createToggle(cameraPage, "Orbit Camera", "orbitCam", function(state)
    if state then
        local angle = 0
        conn.orbitCam = RunService.RenderStepped:Connect(function(dt)
            local hrp = getHRP()
            if hrp then
                angle = angle + cfg.orbitSpeed * dt
                local offset = Vector3.new(
                    math.cos(angle) * cfg.orbitDistance,
                    5,
                    math.sin(angle) * cfg.orbitDistance
                )
                cam.CFrame = CFrame.new(hrp.Position + offset, hrp.Position)
            end
        end)
        notify("Orbit Camera enabled", 2, "success")
    else
        if conn.orbitCam then conn.orbitCam:Disconnect() end
        local hum = getHumanoid()
        if hum then
            cam.CameraSubject = hum
        end
        notify("Orbit Camera disabled", 2)
    end
end, orderCounter, "Camera orbits around your character")
orderCounter = orderCounter + 1

createSlider(cameraPage, "Orbit Speed", 0.1, 3, "orbitSpeed", function(value)
    -- Applied in orbit loop
end, orderCounter, "x", 1)
orderCounter = orderCounter + 1

createSlider(cameraPage, "Orbit Distance", 5, 50, "orbitDistance", function(value)
    -- Applied in orbit loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createSpacer(cameraPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(cameraPage, "Third Person", orderCounter)
orderCounter = orderCounter + 1

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
end, orderCounter, "Lock camera to third person view")
orderCounter = orderCounter + 1

createSlider(cameraPage, "Third Person Distance", 5, 30, "thirdPersonDistance", function(value)
    if cfg.thirdPerson then
        plr.CameraMaxZoomDistance = value
        plr.CameraMinZoomDistance = value
    end
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createSpacer(cameraPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(cameraPage, "Effects", orderCounter)
orderCounter = orderCounter + 1

createToggle(cameraPage, "Camera Shake", "cameraShake", function(state)
    if state then
        conn.camShake = RunService.RenderStepped:Connect(function()
            local intensity = cfg.shakeIntensity
            local shakeOffset = Vector3.new(
                (math.random() - 0.5) * intensity,
                (math.random() - 0.5) * intensity,
                (math.random() - 0.5) * intensity
            )
            cam.CFrame = cam.CFrame * CFrame.new(shakeOffset)
        end)
        notify("Camera Shake enabled", 2, "success")
    else
        if conn.camShake then conn.camShake:Disconnect() end
        notify("Camera Shake disabled", 2)
    end
end, orderCounter, "Add shake effect to camera")
orderCounter = orderCounter + 1

createSlider(cameraPage, "Shake Intensity", 0.1, 2, "shakeIntensity", function(value)
    -- Applied in shake loop
end, orderCounter, "", 1)
orderCounter = orderCounter + 1

createToggle(cameraPage, "Head Tracker", "headTracker", function(state)
    if state then
        conn.headTracker = RunService.RenderStepped:Connect(function()
            local target = getClosestPlayerToMouse(cfg.aimfov)
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
                end
            end
        end)
        notify("Head Tracker enabled", 2, "success")
    else
        if conn.headTracker then conn.headTracker:Disconnect() end
        notify("Head Tracker disabled", 2)
    end
end, orderCounter, "Camera tracks nearest player's head")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- PLAYERS PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local playersPage = pages["players"]
orderCounter = 0

createSectionLabel(playersPage, "Player List", orderCounter)
orderCounter = orderCounter + 1

local playerListContainer = Instance.new("Frame", playersPage)
playerListContainer.BackgroundColor3 = col.card
playerListContainer.BackgroundTransparency = 0.25
playerListContainer.BorderSizePixel = 0
playerListContainer.Size = UDim2.new(1, 0, 0, 150)
playerListContainer.LayoutOrder = orderCounter
playerListContainer.ZIndex = 107
orderCounter = orderCounter + 1

Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 10)

local playerListStroke = Instance.new("UIStroke", playerListContainer)
playerListStroke.Color = col.border
playerListStroke.Thickness = 1
playerListStroke.Transparency = 0.7

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 6, 0, 6)
playerListScroll.Size = UDim2.new(1, -12, 1, -12)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 3
playerListScroll.ScrollBarImageColor3 = col.accent
playerListScroll.ScrollBarImageTransparency = 0.5
playerListScroll.ZIndex = 108

local playerListLayout = Instance.new("UIListLayout", playerListScroll)
playerListLayout.Padding = UDim.new(0, 4)
playerListLayout.SortOrder = Enum.SortOrder.Name

playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerListScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 6)
end)

local function updatePlayerList()
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local isSelected = cfg.selectedPlayer == player
            
            local btn = Instance.new("TextButton", playerListScroll)
            btn.BackgroundColor3 = isSelected and col.selectionDim or col.surfaceElevated
            btn.BackgroundTransparency = 0.4
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 109
            
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local btnStroke = Instance.new("UIStroke", btn)
            btnStroke.Color = isSelected and col.selection or col.border
            btnStroke.Thickness = 1
            btnStroke.Transparency = isSelected and 0.5 or 0.8
            
            local avatar = Instance.new("ImageLabel", btn)
            avatar.BackgroundColor3 = col.card
            avatar.Position = UDim2.new(0, 4, 0.5, -11)
            avatar.Size = UDim2.new(0, 22, 0, 22)
            avatar.ZIndex = 110
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 6)
            
            pcall(function()
                avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            
            local nameLabel = Instance.new("TextLabel", btn)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0, 32, 0, 0)
            nameLabel.Size = UDim2.new(1, -70, 1, 0)
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.Text = player.DisplayName
            nameLabel.TextColor3 = col.text
            nameLabel.TextSize = 11
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 110
            
            local selectedIcon = Instance.new("TextLabel", btn)
            selectedIcon.BackgroundTransparency = 1
            selectedIcon.Position = UDim2.new(1, -28, 0, 0)
            selectedIcon.Size = UDim2.new(0, 24, 1, 0)
            selectedIcon.Font = Enum.Font.GothamBold
            selectedIcon.Text = isSelected and "●" or ""
            selectedIcon.TextColor3 = col.selection
            selectedIcon.TextSize = 12
            selectedIcon.ZIndex = 110
            
            btn.MouseButton1Click:Connect(function()
                cfg.selectedPlayer = cfg.selectedPlayer == player and nil or player
                
                if cfg.selectedPlayer then
                    notify("Selected: " .. player.DisplayName, 2, "success")
                else
                    notify("Deselected player", 2)
                end
                
                if cfg.esp then
                    clearESP()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= plr then createESP(p) end
                    end
                end
                
                updatePlayerList()
            end)
            
            btn.MouseEnter:Connect(function()
                if not isSelected then
                    TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.2}):Play()
                end
            end)
            
            btn.MouseLeave:Connect(function()
                if not isSelected then
                    TweenService:Create(btn, tweenFast, {BackgroundTransparency = 0.4}):Play()
                end
            end)
        end
    end
end

updatePlayerList()

createSpacer(playersPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(playersPage, "Player Actions", orderCounter)
orderCounter = orderCounter + 1

createButton(playersPage, "Teleport to Player", function()
    if cfg.selectedPlayer then
        if teleportToPlayer(cfg.selectedPlayer) then
            notify("Teleported to " .. cfg.selectedPlayer.DisplayName, 2, "success")
        else
            notify("Failed to teleport", 2, "error")
        end
    else
        notify("Select a player first", 2, "warning")
    end
end, orderCounter, "⤴")
orderCounter = orderCounter + 1

createButton(playersPage, "Spectate Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local hum = cfg.selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            cam.CameraSubject = hum
            notify("Spectating " .. cfg.selectedPlayer.DisplayName, 2, "success")
        end
    else
        notify("Select a player first", 2, "warning")
    end
end, orderCounter, "◉")
orderCounter = orderCounter + 1

createButton(playersPage, "Stop Spectating", function()
    local hum = getHumanoid()
    if hum then
        cam.CameraSubject = hum
        notify("Stopped spectating", 2, "success")
    end
end, orderCounter, "◎")
orderCounter = orderCounter + 1

createButton(playersPage, "Refresh List", function()
    updatePlayerList()
    notify("Player list refreshed", 2, "success")
end, orderCounter, "↻")
orderCounter = orderCounter + 1

createSpacer(playersPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(playersPage, "Follow & Annoy", orderCounter)
orderCounter = orderCounter + 1

createToggle(playersPage, "Follow Player", "followPlayer", function(state)
    if state then
        if cfg.selectedPlayer then
            conn.follow = RunService.Heartbeat:Connect(function()
                if cfg.selectedPlayer and cfg.selectedPlayer.Character then
                    local targetHRP = cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = getHRP()
                    local hum = getHumanoid()
                    
                    if targetHRP and myHRP and hum then
                        local distance = getDistance(myHRP.Position, targetHRP.Position)
                        if distance > cfg.followDistance then
                            hum:MoveTo(targetHRP.Position)
                        end
                    end
                end
            end)
            notify("Following " .. cfg.selectedPlayer.DisplayName, 2, "success")
        else
            cfg.followPlayer = false
            notify("Select a player first", 2, "warning")
        end
    else
        if conn.follow then conn.follow:Disconnect() end
        notify("Stopped following", 2)
    end
end, orderCounter, "Automatically follow selected player")
orderCounter = orderCounter + 1

createSlider(playersPage, "Follow Distance", 3, 20, "followDistance", function(value)
    -- Applied in follow loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createToggle(playersPage, "Annoy Player", "annoyPlayer", function(state)
    if state then
        if cfg.selectedPlayer then
            conn.annoy = RunService.Heartbeat:Connect(function()
                if cfg.selectedPlayer and cfg.selectedPlayer.Character then
                    local targetHRP = cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = getHRP()
                    
                    if targetHRP and myHRP then
                        local offset = Vector3.new(
                            math.random(-cfg.annoyRange, cfg.annoyRange),
                            0,
                            math.random(-cfg.annoyRange, cfg.annoyRange)
                        )
                        myHRP.CFrame = CFrame.new(targetHRP.Position + offset)
                    end
                end
            end)
            notify("Annoying " .. cfg.selectedPlayer.DisplayName, 2, "success")
        else
            cfg.annoyPlayer = false
            notify("Select a player first", 2, "warning")
        end
    else
        if conn.annoy then conn.annoy:Disconnect() end
        notify("Stopped annoying", 2)
    end
end, orderCounter, "Teleport around the player constantly")
orderCounter = orderCounter + 1

createSlider(playersPage, "Annoy Range", 1, 10, "annoyRange", function(value)
    -- Applied in annoy loop
end, orderCounter, " studs")
orderCounter = orderCounter + 1

createToggle(playersPage, "Copy Look", "copyLook", function(state)
    if state then
        if cfg.selectedPlayer then
            conn.copyLook = RunService.Heartbeat:Connect(function()
                if cfg.selectedPlayer and cfg.selectedPlayer.Character then
                    local targetHRP = cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = getHRP()
                    
                    if targetHRP and myHRP then
                        myHRP.CFrame = CFrame.new(myHRP.Position, myHRP.Position + targetHRP.CFrame.LookVector)
                    end
                end
            end)
            notify("Copying " .. cfg.selectedPlayer.DisplayName .. "'s look direction", 2, "success")
        else
            cfg.copyLook = false
            notify("Select a player first", 2, "warning")
        end
    else
        if conn.copyLook then conn.copyLook:Disconnect() end
        notify("Stopped copying look", 2)
    end
end, orderCounter, "Face the same direction as selected player")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- TELEPORT PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local teleportPage = pages["teleport"]
orderCounter = 0

createSectionLabel(teleportPage, "Quick Teleport", orderCounter)
orderCounter = orderCounter + 1

createButton(teleportPage, "Teleport to Mouse Position", function()
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        notify("Teleported to mouse position", 2, "success")
    end
end, orderCounter, "⤴")
orderCounter = orderCounter + 1

createButton(teleportPage, "Teleport to Spawn", function()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            notify("Teleported to spawn", 2, "success")
        end
    else
        notify("No spawn location found", 2, "error")
    end
end, orderCounter, "⌂")
orderCounter = orderCounter + 1

createButton(teleportPage, "Teleport to Random Player", function()
    local players = Players:GetPlayers()
    local validPlayers = {}
    
    for _, player in pairs(players) do
        if player ~= plr and isAlive(player.Character) then
            table.insert(validPlayers, player)
        end
    end
    
    if #validPlayers > 0 then
        local randomPlayer = validPlayers[math.random(1, #validPlayers)]
        if teleportToPlayer(randomPlayer) then
            notify("Teleported to " .. randomPlayer.DisplayName, 2, "success")
        end
    else
        notify("No valid players to teleport to", 2, "error")
    end
end, orderCounter, "🎲")
orderCounter = orderCounter + 1

createSpacer(teleportPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(teleportPage, "Waypoints", orderCounter)
orderCounter = orderCounter + 1

createButton(teleportPage, "Save Current Position", function()
    local hrp = getHRP()
    if hrp then
        table.insert(waypoints, {
            name = "Waypoint #" .. (#waypoints + 1),
            cframe = hrp.CFrame
        })
        notify("Saved waypoint #" .. #waypoints, 2, "success")
    end
end, orderCounter, "+")
orderCounter = orderCounter + 1

createButton(teleportPage, "Teleport to Last Waypoint", function()
    if #waypoints > 0 then
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = waypoints[#waypoints].cframe
            notify("Teleported to " .. waypoints[#waypoints].name, 2, "success")
        end
    else
        notify("No waypoints saved", 2, "error")
    end
end, orderCounter, "◇")
orderCounter = orderCounter + 1

createButton(teleportPage, "Clear All Waypoints", function()
    waypoints = {}
    notify("All waypoints cleared", 2, "success")
end, orderCounter, "✕", "danger")
orderCounter = orderCounter + 1

createSpacer(teleportPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(teleportPage, "Coordinate Teleport", orderCounter)
orderCounter = orderCounter + 1

local coordX, coordY, coordZ = 0, 50, 0

createTextInput(teleportPage, "X Coordinate", "teleportX", "0", function(value)
    coordX = tonumber(value) or 0
end, orderCounter)
orderCounter = orderCounter + 1

createTextInput(teleportPage, "Y Coordinate", "teleportY", "50", function(value)
    coordY = tonumber(value) or 50
end, orderCounter)
orderCounter = orderCounter + 1

createTextInput(teleportPage, "Z Coordinate", "teleportZ", "0", function(value)
    coordZ = tonumber(value) or 0
end, orderCounter)
orderCounter = orderCounter + 1

createButton(teleportPage, "Teleport to Coordinates", function()
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(coordX, coordY, coordZ)
        notify("Teleported to (" .. coordX .. ", " .. coordY .. ", " .. coordZ .. ")", 2, "success")
    end
end, orderCounter, "⤴")
orderCounter = orderCounter + 1

createButton(teleportPage, "Copy Current Position", function()
    local hrp = getHRP()
    if hrp and setclipboard then
        local pos = hrp.Position
        setclipboard(string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z))
        notify("Position copied to clipboard", 2, "success")
    else
        notify("Failed to copy position", 2, "error")
    end
end, orderCounter, "⎘")
orderCounter = orderCounter + 1

createSpacer(teleportPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(teleportPage, "Server Teleport", orderCounter)
orderCounter = orderCounter + 1

createButton(teleportPage, "Rejoin Server", function()
    notify("Rejoining server...", 2, "warning")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, orderCounter, "⟳")
orderCounter = orderCounter + 1

createButton(teleportPage, "Server Hop", function()
    notify("Finding new server...", 2, "warning")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, orderCounter, "⇄")
orderCounter = orderCounter + 1

createTextInput(teleportPage, "Place ID", "teleportPlaceId", "Enter Place ID...", function(value)
    -- Store for teleport
end, orderCounter)
orderCounter = orderCounter + 1

createButton(teleportPage, "Teleport to Place", function()
    local placeId = tonumber(cfg.teleportPlaceId)
    if placeId then
        notify("Teleporting to place " .. placeId .. "...", 2, "warning")
        task.wait(0.5)
        TeleportService:Teleport(placeId, plr)
    else
        notify("Enter a valid Place ID", 2, "error")
    end
end, orderCounter, "⤴")
orderCounter = orderCounter + 1

-- ══════════════════════════════════════════════════════════════════════════════
-- SETTINGS PAGE
-- ══════════════════════════════════════════════════════════════════════════════

local settingsPage = pages["settings"]
orderCounter = 0

createSectionLabel(settingsPage, "UI Settings", orderCounter)
orderCounter = orderCounter + 1

createSlider(settingsPage, "UI Opacity", 0.5, 1, "uiOpacity", function(value)
    main.BackgroundTransparency = 1 - value
end, orderCounter, "", 2)
orderCounter = orderCounter + 1

createSlider(settingsPage, "Animation Speed", 0.1, 0.5, "animationSpeed", function(value)
    -- This would affect global animation speeds
end, orderCounter, "s", 2)
orderCounter = orderCounter + 1

createToggle(settingsPage, "Sound Effects", "soundEffects", function(state)
    notify(state and "Sound effects enabled" or "Sound effects disabled", 2)
end, orderCounter, "Play sounds for UI interactions")
orderCounter = orderCounter + 1

createToggle(settingsPage, "Notifications", "notifications", function(state)
    if state then
        notify("Notifications enabled", 2, "success")
    end
end, orderCounter, "Show notification popups")
orderCounter = orderCounter + 1

createSlider(settingsPage, "Notification Duration", 1, 10, "notifDuration", function(value)
    -- Applied to new notifications
end, orderCounter, "s")
orderCounter = orderCounter + 1

createToggle(settingsPage, "Blur Effect", "blurEffect", function(state)
    if state then
        blurEffect.Size = 8
    else
        blurEffect.Size = 0
    end
    notify(state and "Blur enabled" or "Blur disabled", 2)
end, orderCounter, "Blur background when menu is open")
orderCounter = orderCounter + 1

createSpacer(settingsPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(settingsPage, "Keybinds", orderCounter)
orderCounter = orderCounter + 1

createKeybind(settingsPage, "Toggle Menu", "toggleKey", function(key)
    notify("Toggle key set to " .. key.Name, 2, "success")
end, orderCounter)
orderCounter = orderCounter + 1

createKeybind(settingsPage, "Fly Key", "flyKey", function(key)
    notify("Fly key set to " .. key.Name, 2, "success")
end, orderCounter)
orderCounter = orderCounter + 1

createKeybind(settingsPage, "Noclip Key", "noclipKey", function(key)
    notify("Noclip key set to " .. key.Name, 2, "success")
end, orderCounter)
orderCounter = orderCounter + 1

createKeybind(settingsPage, "Speed Key", "speedKey", function(key)
    notify("Speed key set to " .. key.Name, 2, "success")
end, orderCounter)
orderCounter = orderCounter + 1

createKeybind(settingsPage, "ESP Key", "espKey", function(key)
    notify("ESP key set to " .. key.Name, 2, "success")
end, orderCounter)
orderCounter = orderCounter + 1

createSpacer(settingsPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(settingsPage, "Data Management", orderCounter)
orderCounter = orderCounter + 1

createButton(settingsPage, "Save Settings", function()
    saveSettings()
    notify("Settings saved successfully", 2, "success")
end, orderCounter, "💾", "success")
orderCounter = orderCounter + 1

createButton(settingsPage, "Load Settings", function()
    local data = loadSettings()
    if data and data.cfg then
        local restored = restoreColor3(data.cfg)
        for k, v in pairs(restored) do
            if cfg[k] ~= nil then
                cfg[k] = v
            end
        end
        notify("Settings loaded successfully", 2, "success")
    else
        notify("No saved settings found", 2, "error")
    end
end, orderCounter, "📂")
orderCounter = orderCounter + 1

createButton(settingsPage, "Reset All Settings", function()
    pcall(function()
        if delfile and isfile(SAVE_FILE) then
            delfile(SAVE_FILE)
        end
    end)
    notify("Settings reset. Rejoin to apply.", 2, "warning")
end, orderCounter, "🔄", "danger")
orderCounter = orderCounter + 1

createSpacer(settingsPage, 4, orderCounter)
orderCounter = orderCounter + 1

createSectionLabel(settingsPage, "Script Info", orderCounter)
orderCounter = orderCounter + 1

local infoCard = Instance.new("Frame", settingsPage)
infoCard.BackgroundColor3 = col.card
infoCard.BackgroundTransparency = 0.25
infoCard.Size = UDim2.new(1, 0, 0, 100)
infoCard.LayoutOrder = orderCounter
infoCard.ZIndex = 107
orderCounter = orderCounter + 1

Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 10)

local infoTitle = Instance.new("TextLabel", infoCard)
infoTitle.BackgroundTransparency = 1
infoTitle.Position = UDim2.new(0, 14, 0, 10)
infoTitle.Size = UDim2.new(1, -28, 0, 18)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Text = "Violence District V4 Premium"
infoTitle.TextColor3 = col.accent
infoTitle.TextSize = 13
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.ZIndex = 108

local infoVersion = Instance.new("TextLabel", infoCard)
infoVersion.BackgroundTransparency = 1
infoVersion.Position = UDim2.new(0, 14, 0, 30)
infoVersion.Size = UDim2.new(1, -28, 0, 14)
infoVersion.Font = Enum.Font.GothamMedium
infoVersion.Text = "Version: " .. VERSION .. " | Build: " .. BUILD
infoVersion.TextColor3 = col.textMuted
infoVersion.TextSize = 10
infoVersion.TextXAlignment = Enum.TextXAlignment.Left
infoVersion.ZIndex = 108

local infoFeatures = Instance.new("TextLabel", infoCard)
infoFeatures.BackgroundTransparency = 1
infoFeatures.Position = UDim2.new(0, 14, 0, 46)
infoFeatures.Size = UDim2.new(1, -28, 0, 14)
infoFeatures.Font = Enum.Font.GothamMedium
infoFeatures.Text = "Features: 70+ | Optimized for Delta Executor"
infoFeatures.TextColor3 = col.textMuted
infoFeatures.TextSize = 10
infoFeatures.TextXAlignment = Enum.TextXAlignment.Left
infoFeatures.ZIndex = 108

local infoCredits = Instance.new("TextLabel", infoCard)
infoCredits.BackgroundTransparency = 1
infoCredits.Position = UDim2.new(0, 14, 0, 70)
infoCredits.Size = UDim2.new(1, -28, 0, 14)
infoCredits.Font = Enum.Font.Gotham
infoCredits.Text = "Professional 16:9 GUI | Minimalist Design"
infoCredits.TextColor3 = col.textDim
infoCredits.TextSize = 9
infoCredits.TextXAlignment = Enum.TextXAlignment.Left
infoCredits.ZIndex = 108

-- ══════════════════════════════════════════════════════════════════════════════
-- MENU ANIMATION SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

local menuOpen = false
local menuAnimating = false

local function openMenu()
    if menuOpen or menuAnimating then return end
    menuAnimating = true
    menuOpen = true
    
    main.Visible = true
    main.BackgroundTransparency = 1
    main.Size = UDim2.new(0, 0, 0, 0)
    mainStroke.Transparency = 1
    mainShadow.ImageTransparency = 1
    mainGlow.ImageTransparency = 1
    
    if cfg.blurEffect then
        TweenService:Create(blurEffect, tweenSlow, {Size = 8}):Play()
    end
    
    TweenService:Create(main, tweenBounce, {
        Size = UDim2.new(0, mainWidth, 0, mainHeight),
        BackgroundTransparency = 1 - cfg.uiOpacity
    }):Play()
    
    TweenService:Create(mainStroke, tweenMedium, {Transparency = 0.4}):Play()
    TweenService:Create(mainShadow, tweenSlow, {ImageTransparency = 0.5}):Play()
    TweenService:Create(mainGlow, tweenSlow, {ImageTransparency = 0.9}):Play()
    
    task.delay(0.35, function()
        menuAnimating = false
    end)
end

local function closeMenu()
    if not menuOpen or menuAnimating then return end
    menuAnimating = true
    menuOpen = false
    
    TweenService:Create(blurEffect, tweenMedium, {Size = 0}):Play()
    
    TweenService:Create(main, tweenMedium, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(mainStroke, tweenFast, {Transparency = 1}):Play()
    TweenService:Create(mainShadow, tweenFast, {ImageTransparency = 1}):Play()
    TweenService:Create(mainGlow, tweenFast, {ImageTransparency = 1}):Play()
    
    task.delay(0.2, function()
        if not menuOpen then
            main.Visible = false
        end
        menuAnimating = false
    end)
end

local function toggleMenu()
    if menuOpen then
        closeMenu()
    else
        openMenu()
    end
end

-- Toggle Button Click
toggleBtn.MouseButton1Click:Connect(function()
    if not toggleDragMoved then
        toggleMenu()
    end
end)

-- Close Button
closeBtn.MouseButton1Click:Connect(closeMenu)

-- Minimize Button
minBtn.MouseButton1Click:Connect(closeMenu)

-- Maximize Button (toggle size - future feature)
maxBtn.MouseButton1Click:Connect(function()
    notify("Size toggle coming soon", 2, "info")
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- KEYBIND SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == cfg.toggleKey then
        toggleMenu()
    elseif input.KeyCode == cfg.flyKey then
        if toggleRefs.fly then
            toggleRefs.fly.setState(not toggleRefs.fly.getState())
        end
    elseif input.KeyCode == cfg.noclipKey then
        if toggleRefs.noclip then
            toggleRefs.noclip.setState(not toggleRefs.noclip.getState())
        end
    elseif input.KeyCode == cfg.speedKey then
        if toggleRefs.speedHack then
            toggleRefs.speedHack.setState(not toggleRefs.speedHack.getState())
        end
    elseif input.KeyCode == cfg.espKey then
        if toggleRefs.esp then
            toggleRefs.esp.setState(not toggleRefs.esp.getState())
        end
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN UPDATE LOOP
-- ══════════════════════════════════════════════════════════════════════════════

local lastUpdate = 0
local fpsCount = 0
local lastFpsUpdate = 0

RunService.RenderStepped:Connect(function(dt)
    local now = tick()
    fpsCount = fpsCount + 1
    
    -- Update FPS counter every second
    if now - lastFpsUpdate >= 1 then
        if fpsCard then
            fpsCard.setValue(math.floor(fpsCount))
        end
        fpsCount = 0
        lastFpsUpdate = now
    end
    
    -- Update ping
    if now - lastUpdate >= 0.5 then
        local ping = math.floor(plr:GetNetworkPing() * 1000)
        if pingCard then
            pingCard.setValue(ping .. "ms")
        end
        lastUpdate = now
    end
    
    -- Speed Hack
    if cfg.speedHack then
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = cfg.speed
        end
    end
    
    -- FOV Circle
    if cfg.showfov then
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = cfg.aimfov
        fovCircle.Color = cfg.espRgb and Color3.fromHSV(tick() % 5 / 5, 0.6, 0.9) or col.accent
    end
    
    -- Aura Circle
    if cfg.showAura then
        auraCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        auraCircle.Radius = cfg.auraRange * 5
        auraCircle.Color = cfg.espRgb and Color3.fromHSV(tick() % 5 / 5, 0.6, 0.9) or Color3.fromRGB(180, 100, 100)
    end
    
    -- ESP Update
    if cfg.esp then
        updateESP()
    end
    
    -- Tracers Update
    if cfg.tracers then
        local myHRP = getHRP()
        if myHRP then
            for player, tracer in pairs(tracerData) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        tracer.Visible = true
                        
                        local originY = cam.ViewportSize.Y
                        if cfg.tracerOrigin == "Center" then
                            originY = cam.ViewportSize.Y / 2
                        elseif cfg.tracerOrigin == "Top" then
                            originY = 0
                        elseif cfg.tracerOrigin == "Mouse" then
                            tracer.From = Vector2.new(mouse.X, mouse.Y)
                            tracer.To = Vector2.new(pos.X, pos.Y)
                            continue
                        end
                        
                        tracer.From = Vector2.new(cam.ViewportSize.X / 2, originY)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            end
        end
    end
    
    -- Apply FOV
    cam.FieldOfView = cfg.fov
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- PLAYER EVENTS
-- ══════════════════════════════════════════════════════════════════════════════

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESP(player) end
        if cfg.chams and player.Character then
            local highlight = Instance.new("Highlight", player.Character)
            highlight.Name = "VD4_Chams"
            highlight.FillColor = cfg.chamsColor
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            chamsData[player] = highlight
        end
        if cfg.tracers and player.Character then
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = cfg.tracerColor
            tracer.Thickness = 1.5
            tracer.Transparency = 0.7
            tracerData[player] = tracer
        end
    end)
    
    if activeTab == "players" then
        updatePlayerList()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    -- Cleanup ESP
    if espData[player] then
        pcall(function()
            if espData[player].billboard then espData[player].billboard:Destroy() end
            if espData[player].highlight then espData[player].highlight:Destroy() end
            if espData[player].box then espData[player].box:Destroy() end
        end)
        espData[player] = nil
    end
    
    -- Cleanup Tracers
    if tracerData[player] then
        pcall(function() tracerData[player]:Remove() end)
        tracerData[player] = nil
    end
    
    -- Cleanup Chams
    if chamsData[player] then
        pcall(function() chamsData[player]:Destroy() end)
        chamsData[player] = nil
    end
    
    -- Clear selected player if they left
    if cfg.selectedPlayer == player then
        cfg.selectedPlayer = nil
    end
    
    if activeTab == "players" then
        updatePlayerList()
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- CHARACTER RESPAWN HANDLER
-- ══════════════════════════════════════════════════════════════════════════════

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    
    task.wait(1)
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        defaultSpeed = hum.WalkSpeed
        defaultJumpPower = hum.JumpPower
    end
    
    -- Re-apply active features
    for key, ref in pairs(toggleRefs) do
        if cfg[key] and ref.apply then
            task.spawn(function()
                ref.apply()
            end)
        end
    end
    
    notify("Character respawned - features reapplied", 2, "info")
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- INITIAL SETUP
-- ══════════════════════════════════════════════════════════════════════════════

task.spawn(function()
    task.wait(0.5)
    
    -- Apply saved visual settings
    if cfg.fov ~= 70 then
        cam.FieldOfView = cfg.fov
    end
    
    if cfg.fog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    end
    
    if cfg.bright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
    
    if cfg.lowGravity then
        Workspace.Gravity = cfg.customGravity or 50
    end
    
    -- Count active features
    local activeCount = 0
    for key, value in pairs(cfg) do
        if type(value) == "boolean" and value == true then
            activeCount = activeCount + 1
        end
    end
    
    -- Show welcome notification
    notify("Violence District V4 Premium loaded!", 3, "success", "Welcome")
    
    if activeCount > 0 then
        task.wait(0.5)
        notify(activeCount .. " saved features restored", 2.5, "info")
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- CLEANUP ON SCRIPT UNLOAD
-- ══════════════════════════════════════════════════════════════════════════════

gui.Destroying:Connect(function()
    -- Cleanup connections
    for name, connection in pairs(conn) do
        if connection then
            pcall(function() connection:Disconnect() end)
        end
    end
    
    -- Cleanup Drawing objects
    pcall(function() fovCircle:Remove() end)
    pcall(function() auraCircle:Remove() end)
    
    -- Cleanup Tracers
    clearTracers()
    
    -- Cleanup ESP
    clearESP()
    
    -- Cleanup Chams
    clearChams()
    
    -- Remove blur effect
    pcall(function() blurEffect:Destroy() end)
    
    -- Reset gravity
    Workspace.Gravity = defaultGravity
    
    -- Reset humanoid
    local hum = getHumanoid()
    if hum then
        hum.WalkSpeed = defaultSpeed
        hum.JumpPower = defaultJumpPower
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO-SAVE SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════

task.spawn(function()
    while task.wait(60) do -- Auto-save every 60 seconds
        saveSettings()
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- FINAL SETUP
-- ══════════════════════════════════════════════════════════════════════════════

-- Initialize character reference
char = plr.Character or plr.CharacterAdded:Wait()

-- Get default values
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
    defaultSpeed = hum.WalkSpeed
    defaultJumpPower = hum.JumpPower
end

defaultGravity = Workspace.Gravity

-- Script loaded successfully
print("╔══════════════════════════════════════════════════════════════╗")
print("║         Violence District V4 Premium - Loaded                ║")
print("║         Version: " .. VERSION .. " | Build: " .. BUILD .. "                      ║")
print("║         Features: 70+ | Optimized for Delta Executor         ║")
print("║         Press " .. (cfg.toggleKey and cfg.toggleKey.Name or "RightShift") .. " to toggle menu                       ║")
print("╚══════════════════════════════════════════════════════════════╝")