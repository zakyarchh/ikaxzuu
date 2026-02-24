-- ═══════════════════════════════════════════════════════════════════════════════
-- ██╗██╗  ██╗ █████╗ ██╗  ██╗██╗   ██╗    ██████╗ ██████╗ ███████╗███╗   ███╗██╗██╗   ██╗███╗   ███╗
-- ██║██║ ██╔╝██╔══██╗╚██╗██╔╝██║   ██║    ██╔══██╗██╔══██╗██╔════╝████╗ ████║██║██║   ██║████╗ ████║
-- ██║█████╔╝ ███████║ ╚███╔╝ ██║   ██║    ██████╔╝██████╔╝█████╗  ██╔████╔██║██║██║   ██║██╔████╔██║
-- ██║██╔═██╗ ██╔══██║ ██╔██╗ ██║   ██║    ██╔═══╝ ██╔══██╗██╔══╝  ██║╚██╔╝██║██║██║   ██║██║╚██╔╝██║
-- ██║██║  ██╗██║  ██║██╔╝ ██╗╚██████╔╝    ██║     ██║  ██║███████╗██║ ╚═╝ ██║██║╚██████╔╝██║ ╚═╝ ██║
-- ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝ ╚═════╝ ╚═╝     ╚═╝
-- ═══════════════════════════════════════════════════════════════════════════════
-- VIOLENCE DISTRICT V4 - PREMIUM EDITION
-- Professional 16:9 Layout | Modern Minimalist Design
-- Delta Executor Compatible | Auto Save Settings
-- ═══════════════════════════════════════════════════════════════════════════════

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              SERVICES                                          ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

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
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local PathfindingService = game:GetService("PathfindingService")
local Debris = game:GetService("Debris")
local TextService = game:GetService("TextService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local Stats = game:GetService("Stats")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           LOCAL REFERENCES                                     ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                            VERSION INFO                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local SCRIPT_VERSION = "4.0.0"
local SCRIPT_NAME = "IKAXU PREMIUM"
local SCRIPT_SUBTITLE = "Violence District"
local BUILD_DATE = "2024"

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          SAVE/LOAD SYSTEM                                      ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local SAVE_FILE = "ikaxu_premium_v4_settings.json"
local WAYPOINTS_FILE = "ikaxu_premium_v4_waypoints.json"

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function saveSettings()
    local success = pcall(function()
        local data = {
            cfg = {},
            togglePos = {
                x = toggleBtn and toggleBtn.Position.X.Offset or 20,
                y = toggleBtn and toggleBtn.Position.Y.Scale or 0.5
            },
            windowPos = {
                x = main and main.Position.X.Offset or 0,
                y = main and main.Position.Y.Offset or 0
            },
            lastTab = activeTab,
            savedTime = os.time()
        }
        
        for k, v in pairs(cfg) do
            if type(v) ~= "userdata" and type(v) ~= "function" then
                data.cfg[k] = v
            end
        end
        
        if writefile then
            writefile(SAVE_FILE, HttpService:JSONEncode(data))
        end
    end)
    return success
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

local function saveWaypoints()
    local success = pcall(function()
        local waypointData = {}
        for name, pos in pairs(savedWaypoints) do
            waypointData[name] = {x = pos.X, y = pos.Y, z = pos.Z}
        end
        if writefile then
            writefile(WAYPOINTS_FILE, HttpService:JSONEncode(waypointData))
        end
    end)
    return success
end

local function loadWaypoints()
    local success, data = pcall(function()
        if isfile and isfile(WAYPOINTS_FILE) then
            local raw = HttpService:JSONDecode(readfile(WAYPOINTS_FILE))
            local waypoints = {}
            for name, pos in pairs(raw) do
                waypoints[name] = Vector3.new(pos.x, pos.y, pos.z)
            end
            return waypoints
        end
    end)
    if success and data then
        return data
    end
    return {}
end

local savedData = loadSettings()
local savedWaypoints = loadWaypoints()

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                         CONFIGURATION TABLE                                    ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local cfg = {
    -- Combat Settings
    esp = false,
    espMode = 1,
    espRgb = false,
    espShowDistance = true,
    espShowHealth = true,
    espShowName = true,
    espTeamCheck = false,
    espMaxDistance = 1000,
    
    -- Aimbot Settings
    aim = false,
    aimfov = 150,
    showfov = false,
    aimSmooth = 0.5,
    aimPrediction = false,
    aimPredictionAmount = 0.1,
    aimTargetPart = "Head",
    aimStickyTarget = false,
    aimVisibleCheck = true,
    
    -- Silent Aim Settings
    silentAim = false,
    silentNoFov = false,
    silentHitPart = "HumanoidRootPart",
    
    -- Kill Aura Settings
    killaura = false,
    auraRange = 15,
    showAura = false,
    auraSpeed = 0.1,
    auraMultiTarget = false,
    auraMaxTargets = 3,
    
    -- Hit Settings
    hitChance = 100,
    hitboxExpander = false,
    hitboxSize = 5,
    
    -- Protection Settings
    god = false,
    antiVoid = false,
    autoHeal = false,
    autoHealPercent = 50,
    autoRespawn = false,
    
    -- Movement Settings
    speedHack = false,
    speed = 16,
    speedDefault = 16,
    
    fly = false,
    flySpeed = 50,
    
    noclip = false,
    
    infiniteJump = false,
    highJump = false,
    jumpPower = 50,
    jumpDefault = 50,
    
    lowGravity = false,
    gravityAmount = 50,
    
    teleportTool = false,
    clickTeleport = false,
    
    -- Visual Settings
    fog = false,
    bright = false,
    fov = 70,
    fovDefault = 70,
    
    invisible = false,
    
    noRagdoll = false,
    noFall = false,
    noClipCam = false,
    
    freeCam = false,
    freeCamSpeed = 1,
    
    thirdPerson = false,
    thirdPersonDistance = 10,
    
    cameraShakeRemove = false,
    
    -- World Settings
    xray = false,
    xrayTransparency = 0.7,
    
    noParticles = false,
    noEffects = false,
    noDecals = false,
    noTextures = false,
    
    timeControl = false,
    timeValue = 14,
    
    weatherControl = false,
    fogDensity = 0,
    
    -- Character Settings
    characterScale = 1,
    headSize = 1,
    
    customWalkAnim = false,
    customIdleAnim = false,
    
    -- ESP Additional
    npcEsp = false,
    itemEsp = false,
    toolEsp = false,
    tracers = false,
    tracerOrigin = "Bottom",
    skeleton = false,
    chams = false,
    chamsColor = {r = 255, g = 0, b = 0},
    
    -- Utility Settings
    antiAfk = false,
    autoClicker = false,
    autoClickerCPS = 10,
    autoClickerKeyBind = "Mouse1",
    
    infiniteStamina = false,
    
    chatSpy = false,
    chatSpyTeam = true,
    chatSpyWhisper = true,
    
    -- UI Settings
    uiScale = 1,
    uiTransparency = 0.05,
    notificationDuration = 3,
    notificationSound = true,
    
    -- Keybinds
    toggleKey = "RightShift",
    flyKey = "F",
    noclipKey = "V",
    speedKey = "LeftShift",
    
    -- Selected
    selectedPlayer = nil,
    
    -- Stats
    totalKills = 0,
    totalDeaths = 0,
    sessionTime = 0,
    
    -- Misc
    watermark = true,
    fpsCounter = true,
    pingDisplay = true,
    coordsDisplay = false,
    serverInfo = false,
    
    -- Auto Features
    autoFarm = false,
    autoCollect = false,
    autoQuest = false,
    autoDodge = false,
    autoBlock = false,
    autoParry = false,
    autoAttack = false,
    autoCombo = false,
    
    -- Target Settings
    targetPriority = "Distance",
    ignoreTeammates = false,
    ignoreFriends = false,
}

-- Load saved config
if savedData and savedData.cfg then
    for k, v in pairs(savedData.cfg) do
        if cfg[k] ~= nil and type(v) ~= "userdata" then
            cfg[k] = v
        end
    end
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           RUNTIME VARIABLES                                    ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local conn = {}
local espData = {}
local npcEspData = {}
local itemEspData = {}
local toolEspData = {}
local tracerData = {}
local skeletonData = {}
local immortal = false
local defaultSpeed = 16
local defaultJump = 50
local defaultGravity = 196.2
local defaultFOV = 70
local toggleRefs = {}
local sliderRefs = {}
local activeTab = nil
local menuOpen = false
local flyActive = false
local flyBodyVelocity = nil
local flyBodyGyro = nil
local currentTarget = nil
local sessionStartTime = os.time()
local lastFrameTime = tick()
local frameCount = 0
local currentFPS = 60
local currentPing = 0
local chatLogs = {}
local killFeed = {}

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           COLOR PALETTE                                        ║
-- ║              Modern Minimalist - Soft Neutral Colors                          ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local colors = {
    -- Primary Background
    background = Color3.fromRGB(12, 12, 14),
    backgroundLight = Color3.fromRGB(18, 18, 22),
    backgroundDark = Color3.fromRGB(8, 8, 10),
    
    -- Surface Colors
    surface = Color3.fromRGB(22, 22, 28),
    surfaceLight = Color3.fromRGB(28, 28, 36),
    surfaceDark = Color3.fromRGB(16, 16, 20),
    
    -- Card Colors
    card = Color3.fromRGB(26, 26, 32),
    cardHover = Color3.fromRGB(32, 32, 40),
    cardActive = Color3.fromRGB(38, 38, 48),
    
    -- Border Colors
    border = Color3.fromRGB(42, 42, 52),
    borderLight = Color3.fromRGB(52, 52, 64),
    borderDark = Color3.fromRGB(32, 32, 40),
    
    -- Text Colors
    textPrimary = Color3.fromRGB(235, 235, 240),
    textSecondary = Color3.fromRGB(165, 165, 180),
    textMuted = Color3.fromRGB(105, 105, 120),
    textDisabled = Color3.fromRGB(65, 65, 75),
    
    -- Accent Colors (Soft Blue)
    accent = Color3.fromRGB(90, 130, 180),
    accentLight = Color3.fromRGB(110, 150, 200),
    accentDark = Color3.fromRGB(70, 100, 145),
    accentMuted = Color3.fromRGB(60, 85, 120),
    accentGlow = Color3.fromRGB(130, 170, 220),
    
    -- Status Colors
    success = Color3.fromRGB(75, 160, 115),
    successLight = Color3.fromRGB(95, 180, 135),
    successDark = Color3.fromRGB(55, 130, 90),
    
    warning = Color3.fromRGB(200, 165, 75),
    warningLight = Color3.fromRGB(220, 185, 95),
    warningDark = Color3.fromRGB(170, 140, 55),
    
    error = Color3.fromRGB(185, 85, 90),
    errorLight = Color3.fromRGB(205, 105, 110),
    errorDark = Color3.fromRGB(150, 65, 70),
    
    -- Toggle Colors
    toggleOn = Color3.fromRGB(75, 160, 115),
    toggleOnLight = Color3.fromRGB(95, 180, 135),
    toggleOff = Color3.fromRGB(45, 45, 55),
    toggleOffLight = Color3.fromRGB(55, 55, 65),
    
    -- Special Colors
    highlight = Color3.fromRGB(200, 180, 100),
    selection = Color3.fromRGB(90, 130, 180),
    overlay = Color3.fromRGB(0, 0, 0),
    
    -- Gradient Colors
    gradientStart = Color3.fromRGB(90, 130, 180),
    gradientEnd = Color3.fromRGB(130, 100, 180),
    
    -- Shadow
    shadow = Color3.fromRGB(0, 0, 0),
    
    -- White/Black
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
}

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          TWEEN CONFIGURATIONS                                  ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local tweens = {
    instant = TweenInfo.new(0),
    ultraFast = TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    medium = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    bounce = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    bounceIn = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    elastic = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    linear = TweenInfo.new(0.2, Enum.EasingStyle.Linear),
    spring = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0),
    fadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    fadeOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    slideIn = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    slideOut = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
}

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           UTILITY FUNCTIONS                                    ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local function getParent()
    local success, result = pcall(function()
        return gethui()
    end)
    if success and result then
        return result
    end
    return CoreGui
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function isVisible(part)
    if not part then return false end
    
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local ray = Ray.new(hrp.Position, (part.Position - hrp.Position).Unit * 500)
    local hit, _ = Workspace:FindPartOnRayWithIgnoreList(ray, {char})
    
    return hit == part or hit == nil or hit:IsDescendantOf(part.Parent)
end

local function createShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = colors.shadow
    shadow.ImageTransparency = transparency or 0.7
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function createGradient(parent, rotation, colors1, colors2)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors1 or colors.gradientStart),
        ColorSequenceKeypoint.new(1, colors2 or colors.gradientEnd)
    })
    gradient.Parent = parent
    return gradient
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or colors.border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createPadding(parent, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, padding or 8)
    pad.PaddingBottom = UDim.new(0, padding or 8)
    pad.PaddingLeft = UDim.new(0, padding or 8)
    pad.PaddingRight = UDim.new(0, padding or 8)
    pad.Parent = parent
    return pad
end

local function createListLayout(parent, padding, direction, alignment)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or 6)
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end

local function createGridLayout(parent, cellSize, cellPadding)
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = cellSize or UDim2.new(0, 100, 0, 100)
    grid.CellPadding = cellPadding or UDim2.new(0, 8, 0, 8)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = parent
    return grid
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              GUI CREATION                                      ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local gui = Instance.new("ScreenGui")
gui.Name = "IkaxuPremiumV4_" .. math.random(100000, 999999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                         DRAGGABLE TOGGLE BUTTON                                ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = colors.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.ZIndex = 1000

if savedData and savedData.togglePos then
    toggleBtn.Position = UDim2.new(0, savedData.togglePos.x, savedData.togglePos.y, -24)
else
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -24)
end
toggleBtn.Size = UDim2.new(0, 48, 0, 48)

createCorner(toggleBtn, 12)

local toggleStroke = createStroke(toggleBtn, colors.border, 1.5, 0.3)

local toggleShadow = createShadow(toggleBtn, 40, 0.8)

local toggleGlow = Instance.new("ImageLabel")
toggleGlow.Name = "Glow"
toggleGlow.Parent = toggleBtn
toggleGlow.BackgroundTransparency = 1
toggleGlow.Size = UDim2.new(1, 40, 1, 40)
toggleGlow.Position = UDim2.new(0, -20, 0, -20)
toggleGlow.Image = "rbxassetid://5028857084"
toggleGlow.ImageColor3 = colors.accent
toggleGlow.ImageTransparency = 0.9
toggleGlow.ZIndex = 999

local toggleIcon = Instance.new("TextLabel")
toggleIcon.Name = "Icon"
toggleIcon.Parent = toggleBtn
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBlack
toggleIcon.Text = "IX"
toggleIcon.TextColor3 = colors.textSecondary
toggleIcon.TextSize = 18
toggleIcon.ZIndex = 1001

local togglePulse = Instance.new("Frame")
togglePulse.Name = "Pulse"
togglePulse.Parent = toggleBtn
togglePulse.BackgroundColor3 = colors.accent
togglePulse.BackgroundTransparency = 1
togglePulse.Size = UDim2.new(1, 0, 1, 0)
togglePulse.ZIndex = 1000
createCorner(togglePulse, 12)

-- Toggle Button Drag System
local toggleDragging = false
local toggleDragStart = nil
local toggleStartPos = nil
local toggleLastClick = 0

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        toggleLastClick = tick()
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
        task.spawn(saveSettings)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - toggleDragStart
        local viewportSize = cam.ViewportSize
        local newX = clamp(toggleStartPos.X.Offset + delta.X, 0, viewportSize.X - 58)
        local newY = clamp(toggleStartPos.Y.Offset + delta.Y, -viewportSize.Y/2 + 34, viewportSize.Y/2 - 34)
        toggleBtn.Position = UDim2.new(0, newX, toggleStartPos.Y.Scale, newY)
    end
end)

-- Toggle Button Hover Effects
toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, tweens.fast, {Color = colors.accentLight, Transparency = 0}):Play()
    TweenService:Create(toggleIcon, tweens.fast, {TextColor3 = colors.textPrimary}):Play()
    TweenService:Create(toggleBtn, tweens.bounce, {Size = UDim2.new(0, 52, 0, 52)}):Play()
    TweenService:Create(toggleGlow, tweens.fast, {ImageTransparency = 0.7}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, tweens.fast, {Color = colors.border, Transparency = 0.3}):Play()
    TweenService:Create(toggleIcon, tweens.fast, {TextColor3 = colors.textSecondary}):Play()
    TweenService:Create(toggleBtn, tweens.bounce, {Size = UDim2.new(0, 48, 0, 48)}):Play()
    TweenService:Create(toggleGlow, tweens.fast, {ImageTransparency = 0.9}):Play()
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          MAIN WINDOW (16:9 LAYOUT)                             ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

-- 16:9 Proportional Size (640 x 360 base, scaled up)
local WINDOW_WIDTH = 720
local WINDOW_HEIGHT = 405

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = colors.background
main.BackgroundTransparency = cfg.uiTransparency
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.ZIndex = 10

createCorner(main, 16)

local mainStroke = createStroke(main, colors.border, 1.5, 1)

local mainShadow = Instance.new("ImageLabel")
mainShadow.Name = "Shadow"
mainShadow.Parent = main
mainShadow.BackgroundTransparency = 1
mainShadow.Size = UDim2.new(1, 80, 1, 80)
mainShadow.Position = UDim2.new(0, -40, 0, -40)
mainShadow.Image = "rbxassetid://5028857084"
mainShadow.ImageColor3 = colors.shadow
mainShadow.ImageTransparency = 1
mainShadow.ZIndex = 9

-- Draggable Main Window
local mainDragging = false
local mainDragStart = nil
local mainStartPos = nil

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local headerHeight = 52
        local relativeY = mousePos.Y - main.AbsolutePosition.Y
        
        if relativeY <= headerHeight then
            mainDragging = true
            mainDragStart = input.Position
            mainStartPos = main.Position
        end
    end
end)

main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if mainDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mainDragStart
        main.Position = UDim2.new(
            mainStartPos.X.Scale,
            mainStartPos.X.Offset + delta.X,
            mainStartPos.Y.Scale,
            mainStartPos.Y.Offset + delta.Y
        )
    end
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                                 HEADER                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = main
header.BackgroundColor3 = colors.surface
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 52)
header.ZIndex = 15

createCorner(header, 16)

-- Fix bottom corners
local headerFix = Instance.new("Frame")
headerFix.Name = "Fix"
headerFix.Parent = header
headerFix.BackgroundColor3 = colors.surface
headerFix.BackgroundTransparency = 0.2
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.ZIndex = 15

-- Header Bottom Line
local headerLine = Instance.new("Frame")
headerLine.Name = "Line"
headerLine.Parent = header
headerLine.BackgroundColor3 = colors.border
headerLine.BackgroundTransparency = 0.5
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.ZIndex = 16

-- Logo Container
local logoContainer = Instance.new("Frame")
logoContainer.Name = "LogoContainer"
logoContainer.Parent = header
logoContainer.BackgroundTransparency = 1
logoContainer.Position = UDim2.new(0, 20, 0, 0)
logoContainer.Size = UDim2.new(0, 200, 1, 0)
logoContainer.ZIndex = 16

-- Logo Icon
local logoIcon = Instance.new("Frame")
logoIcon.Name = "Icon"
logoIcon.Parent = logoContainer
logoIcon.BackgroundColor3 = colors.accent
logoIcon.Position = UDim2.new(0, 0, 0.5, -14)
logoIcon.Size = UDim2.new(0, 28, 0, 28)
logoIcon.ZIndex = 17

createCorner(logoIcon, 7)

local logoIconText = Instance.new("TextLabel")
logoIconText.Name = "Text"
logoIconText.Parent = logoIcon
logoIconText.BackgroundTransparency = 1
logoIconText.Size = UDim2.new(1, 0, 1, 0)
logoIconText.Font = Enum.Font.GothamBlack
logoIconText.Text = "VD"
logoIconText.TextColor3 = colors.white
logoIconText.TextSize = 12
logoIconText.ZIndex = 18

-- Title Text
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = logoContainer
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 38, 0, 8)
titleLabel.Size = UDim2.new(0, 150, 0, 18)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = SCRIPT_NAME
titleLabel.TextColor3 = colors.textPrimary
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 17

-- Subtitle Text
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Parent = logoContainer
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 38, 0, 26)
subtitleLabel.Size = UDim2.new(0, 150, 0, 14)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = SCRIPT_SUBTITLE .. "IKAXZU PREM • v5" ..
subtitleLabel.TextColor3 = colors.textMuted
subtitleLabel.TextSize = 10
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.ZIndex = 17

-- Header Right Controls
local headerControls = Instance.new("Frame")
headerControls.Name = "Controls"
headerControls.Parent = header
headerControls.BackgroundTransparency = 1
headerControls.Position = UDim2.new(1, -100, 0, 0)
headerControls.Size = UDim2.new(0, 90, 1, 0)
headerControls.ZIndex = 16

local controlsLayout = createListLayout(headerControls, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right)
controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Parent = headerControls
minBtn.BackgroundColor3 = colors.warning
minBtn.BackgroundTransparency = 1
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = colors.textMuted
minBtn.TextSize = 20
minBtn.AutoButtonColor = false
minBtn.ZIndex = 17
minBtn.LayoutOrder = 1

createCorner(minBtn, 7)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, tweens.fast, {BackgroundTransparency = 0.7, TextColor3 = colors.warning}):Play()
end)

minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, tweens.fast, {BackgroundTransparency = 1, TextColor3 = colors.textMuted}):Play()
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Parent = headerControls
closeBtn.BackgroundColor3 = colors.error
closeBtn.BackgroundTransparency = 1
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = colors.textMuted
closeBtn.TextSize = 20
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 17
closeBtn.LayoutOrder = 2

createCorner(closeBtn, 7)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, tweens.fast, {BackgroundTransparency = 0.7, TextColor3 = colors.error}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, tweens.fast, {BackgroundTransparency = 1, TextColor3 = colors.textMuted}):Play()
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              SIDEBAR                                           ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local SIDEBAR_WIDTH = 70

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Parent = main
sidebar.BackgroundColor3 = colors.surface
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 52)
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -52)
sidebar.ZIndex = 14

-- Sidebar Right Line
local sidebarLine = Instance.new("Frame")
sidebarLine.Name = "Line"
sidebarLine.Parent = sidebar
sidebarLine.BackgroundColor3 = colors.border
sidebarLine.BackgroundTransparency = 0.5
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.ZIndex = 14

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Parent = sidebar
tabContainer.BackgroundTransparency = 1
tabContainer.Position = UDim2.new(0, 6, 0, 12)
tabContainer.Size = UDim2.new(1, -12, 1, -24)
tabContainer.ZIndex = 15

local tabLayout = createListLayout(tabContainer, 4)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                            CONTENT AREA                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local content = Instance.new("Frame")
content.Name = "Content"
content.Parent = main
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, SIDEBAR_WIDTH + 12, 0, 64)
content.Size = UDim2.new(1, -(SIDEBAR_WIDTH + 24), 1, -76)
content.ZIndex = 14

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                         NOTIFICATION SYSTEM                                    ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local notifContainer = Instance.new("Frame")
notifContainer.Name = "Notifications"
notifContainer.Parent = gui
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -280, 0, 20)
notifContainer.Size = UDim2.new(0, 260, 0, 300)
notifContainer.ZIndex = 2000

local notifLayout = createListLayout(notifContainer, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(message, duration, notifType)
    local notifColor = colors.accent
    local notifIcon = "●"
    
    if notifType == "success" then
        notifColor = colors.success
        notifIcon = "✓"
    elseif notifType == "error" then
        notifColor = colors.error
        notifIcon = "✕"
    elseif notifType == "warning" or notifType == "warn" then
        notifColor = colors.warning
        notifIcon = "!"
    elseif notifType == "info" then
        notifColor = colors.accent
        notifIcon = "i"
    end
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Parent = notifContainer
    notif.BackgroundColor3 = colors.surface
    notif.BackgroundTransparency = 0.05
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 0, 0, 42)
    notif.ClipsDescendants = true
    notif.ZIndex = 2001
    
    createCorner(notif, 10)
    createStroke(notif, notifColor, 1, 0.6)
    createShadow(notif, 20, 0.85)
    
    -- Accent Line
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Parent = notif
    accentLine.BackgroundColor3 = notifColor
    accentLine.BorderSizePixel = 0
    accentLine.Size = UDim2.new(0, 3, 1, 0)
    accentLine.ZIndex = 2002
    
    createCorner(accentLine, 10)
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Parent = notif
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 12, 0, 0)
    icon.Size = UDim2.new(0, 24, 1, 0)
    icon.Font = Enum.Font.GothamBold
    icon.Text = notifIcon
    icon.TextColor3 = notifColor
    icon.TextSize = 14
    icon.ZIndex = 2002
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Parent = notif
    text.BackgroundTransparency = 1
    text.Position = UDim2.new(0, 40, 0, 0)
    text.Size = UDim2.new(1, -50, 1, 0)
    text.Font = Enum.Font.GothamMedium
    text.Text = message
    text.TextColor3 = colors.textPrimary
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextTruncate = Enum.TextTruncate.AtEnd
    text.TextTransparency = 1
    text.ZIndex = 2002
    
    -- Progress Bar
    local progressBar = Instance.new("Frame")
    progressBar.Name = "Progress"
    progressBar.Parent = notif
    progressBar.BackgroundColor3 = notifColor
    progressBar.BackgroundTransparency = 0.7
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.ZIndex = 2002
    
    -- Animate in
    TweenService:Create(notif, tweens.bounce, {Size = UDim2.new(0, 240, 0, 42)}):Play()
    task.delay(0.1, function()
        TweenService:Create(text, tweens.fast, {TextTransparency = 0}):Play()
    end)
    
    -- Progress animation
    local dur = duration or cfg.notificationDuration
    TweenService:Create(progressBar, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    
    -- Animate out
    task.delay(dur, function()
        TweenService:Create(text, tweens.fast, {TextTransparency = 1}):Play()
        TweenService:Create(notif, tweens.medium, {Size = UDim2.new(0, 0, 0, 42), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
    
    return notif
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           DRAWING OBJECTS                                      ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.Color = colors.accent
fovCircle.Transparency = 0.6
fovCircle.NumSides = 64
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1.5
auraCircle.Color = colors.error
auraCircle.Transparency = 0.5
auraCircle.NumSides = 64
auraCircle.Filled = false

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          TAB SYSTEM DATA                                       ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local pages = {}
local tabButtons = {}

local tabs = {
    {id = "home", name = "Home", icon = "⌂", tooltip = "Main Dashboard"},
    {id = "combat", name = "Combat", icon = "⚔", tooltip = "Combat Features"},
    {id = "movement", name = "Move", icon = "➤", tooltip = "Movement Features"},
    {id = "visual", name = "Visual", icon = "◐", tooltip = "Visual Settings"},
    {id = "esp", name = "ESP", icon = "◎", tooltip = "ESP Features"},
    {id = "player", name = "Player", icon = "♦", tooltip = "Player Options"},
    {id = "world", name = "World", icon = "◆", tooltip = "World Settings"},
    {id = "misc", name = "Misc", icon = "✦", tooltip = "Miscellaneous"},
}

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          PAGE CREATION                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local function createPage(id)
    local page = Instance.new("ScrollingFrame")
    page.Name = id
    page.Parent = content
    page.Active = true
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = colors.accent
    page.ScrollBarImageTransparency = 0.4
    page.Visible = false
    page.ZIndex = 15
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout = createListLayout(page, 8)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)
    
    pages[id] = page
    return page
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          UI COMPONENTS                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local function createSection(parent, title)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. title
    section.Parent = parent
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, 0, 0, 28)
    section.ZIndex = 16
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = section
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 2, 0, 6)
    titleLabel.Size = UDim2.new(1, -4, 0, 16)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title:upper()
    titleLabel.TextColor3 = colors.textMuted
    titleLabel.TextSize = 10
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 17
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.Parent = section
    line.BackgroundColor3 = colors.border
    line.BackgroundTransparency = 0.6
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 1, -1)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.ZIndex = 17
    
    return section
end

local function createToggle(parent, text, cfgKey, callback, description)
    local state = cfg[cfgKey] or false
    
    local container = Instance.new("TextButton")
    container.Name = "Toggle_" .. cfgKey
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, description and 48 or 38)
    container.Text = ""
    container.AutoButtonColor = false
    container.ZIndex = 16
    
    createCorner(container, 10)
    local stroke = createStroke(container, colors.border, 1, 0.7)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, description and 8 or 0)
    label.Size = UDim2.new(1, -70, 0, description and 18 or 38)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    
    -- Description
    if description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.Parent = container
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 14, 0, 26)
        desc.Size = UDim2.new(1, -70, 0, 14)
        desc.Font = Enum.Font.Gotham
        desc.Text = description
        desc.TextColor3 = colors.textDisabled
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.ZIndex = 17
    end
    
    -- Switch Background
    local switchBg = Instance.new("Frame")
    switchBg.Name = "SwitchBg"
    switchBg.Parent = container
    switchBg.AnchorPoint = Vector2.new(1, 0.5)
    switchBg.BackgroundColor3 = colors.toggleOff
    switchBg.Position = UDim2.new(1, -14, 0.5, 0)
    switchBg.Size = UDim2.new(0, 40, 0, 20)
    switchBg.ZIndex = 17
    
    createCorner(switchBg, 10)
    
    -- Switch Knob
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Parent = switchBg
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = colors.textMuted
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.ZIndex = 18
    
    createCorner(knob, 8)
    
    -- Knob Glow
    local knobGlow = Instance.new("Frame")
    knobGlow.Name = "Glow"
    knobGlow.Parent = knob
    knobGlow.BackgroundColor3 = colors.white
    knobGlow.BackgroundTransparency = 1
    knobGlow.Size = UDim2.new(1, 0, 1, 0)
    knobGlow.ZIndex = 19
    
    createCorner(knobGlow, 8)
    
    local function updateVisual(animate)
        local tweenInfo = animate and tweens.bounce or tweens.instant
        
        if state then
            TweenService:Create(switchBg, tweenInfo, {BackgroundColor3 = colors.toggleOn}):Play()
            TweenService:Create(knob, tweenInfo, {
                Position = UDim2.new(1, -18, 0.5, 0),
                BackgroundColor3 = colors.white
            }):Play()
            TweenService:Create(label, tweenInfo, {TextColor3 = colors.textPrimary}):Play()
            TweenService:Create(stroke, tweenInfo, {Color = colors.toggleOn, Transparency = 0.5}):Play()
        else
            TweenService:Create(switchBg, tweenInfo, {BackgroundColor3 = colors.toggleOff}):Play()
            TweenService:Create(knob, tweenInfo, {
                Position = UDim2.new(0, 2, 0.5, 0),
                BackgroundColor3 = colors.textMuted
            }):Play()
            TweenService:Create(label, tweenInfo, {TextColor3 = colors.textSecondary}):Play()
            TweenService:Create(stroke, tweenInfo, {Color = colors.border, Transparency = 0.7}):Play()
        end
    end
    
    local function toggle(noSave)
        state = not state
        cfg[cfgKey] = state
        updateVisual(true)
        
        -- Click feedback
        TweenService:Create(knobGlow, tweens.fast, {BackgroundTransparency = 0.5}):Play()
        task.delay(0.15, function()
            TweenService:Create(knobGlow, tweens.fast, {BackgroundTransparency = 1}):Play()
        end)
        
        pcall(callback, state)
        if not noSave then task.spawn(saveSettings) end
    end
    
    container.MouseButton1Click:Connect(function() toggle(false) end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.15}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
    end)
    
    -- Initialize
    updateVisual(false)
    
    local ref = {
        setState = function(v, noCallback)
            state = v
            cfg[cfgKey] = v
            updateVisual(true)
            if not noCallback then pcall(callback, state) end
        end,
        getState = function() return state end,
        apply = function() if state then pcall(callback, true) end end
    }
    
    toggleRefs[cfgKey] = ref
    return ref
end

local function createSlider(parent, text, min, max, cfgKey, callback, suffix, step, description)
    local value = clamp(cfg[cfgKey] or min, min, max)
    local dragging = false
    local stepSize = step or 1
    local suffixText = suffix or ""
    
    local container = Instance.new("Frame")
    container.Name = "Slider_" .. cfgKey
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, description and 58 or 52)
    container.ZIndex = 16
    
    createCorner(container, 10)
    createStroke(container, colors.border, 1, 0.7)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 8)
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    
    -- Description
    if description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.Parent = container
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 14, 0, 24)
        desc.Size = UDim2.new(0.6, 0, 0, 12)
        desc.Font = Enum.Font.Gotham
        desc.Text = description
        desc.TextColor3 = colors.textDisabled
        desc.TextSize = 9
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.ZIndex = 17
    end
    
    -- Value Display
    local valueBg = Instance.new("Frame")
    valueBg.Name = "ValueBg"
    valueBg.Parent = container
    valueBg.BackgroundColor3 = colors.accent
    valueBg.BackgroundTransparency = 0.85
    valueBg.Position = UDim2.new(1, -60, 0, 8)
    valueBg.Size = UDim2.new(0, 46, 0, 20)
    valueBg.ZIndex = 17
    
    createCorner(valueBg, 5)
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = valueBg
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(value) .. suffixText
    valueLabel.TextColor3 = colors.accent
    valueLabel.TextSize = 10
    valueLabel.ZIndex = 18
    
    -- Track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Parent = container
    track.BackgroundColor3 = colors.surfaceLight
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 14, 1, -18)
    track.Size = UDim2.new(1, -28, 0, 6)
    track.ZIndex = 17
    
    createCorner(track, 3)
    
    -- Fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Parent = track
    fill.BackgroundColor3 = colors.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.ZIndex = 18
    
    createCorner(fill, 3)
    
    -- Fill Glow
    local fillGlow = Instance.new("Frame")
    fillGlow.Name = "Glow"
    fillGlow.Parent = fill
    fillGlow.AnchorPoint = Vector2.new(1, 0.5)
    fillGlow.BackgroundColor3 = colors.accentGlow
    fillGlow.BackgroundTransparency = 0.3
    fillGlow.Position = UDim2.new(1, 0, 0.5, 0)
    fillGlow.Size = UDim2.new(0, 8, 0, 8)
    fillGlow.ZIndex = 19
    
    createCorner(fillGlow, 4)
    
    -- Hit Area
    local hitArea = Instance.new("TextButton")
    hitArea.Name = "HitArea"
    hitArea.Parent = track
    hitArea.BackgroundTransparency = 1
    hitArea.Position = UDim2.new(0, 0, 0, -8)
    hitArea.Size = UDim2.new(1, 0, 1, 16)
    hitArea.Text = ""
    hitArea.ZIndex = 20
    
    local function updateValue(input)
        local pos = clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local rawValue = min + (max - min) * pos
        
        -- Apply step
        if stepSize > 0 then
            value = math.floor(rawValue / stepSize + 0.5) * stepSize
        else
            value = rawValue
        end
        
        value = clamp(value, min, max)
        cfg[cfgKey] = value
        
        local fillPos = (value - min) / (max - min)
        TweenService:Create(fill, tweens.ultraFast, {Size = UDim2.new(fillPos, 0, 1, 0)}):Play()
        
        if stepSize >= 1 then
            valueLabel.Text = tostring(math.floor(value)) .. suffixText
        else
            valueLabel.Text = string.format("%.1f", value) .. suffixText
        end
        
        pcall(callback, value)
    end
    
    hitArea.MouseButton1Down:Connect(function()
        dragging = true
        TweenService:Create(fillGlow, tweens.fast, {Size = UDim2.new(0, 12, 0, 12), BackgroundTransparency = 0}):Play()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                TweenService:Create(fillGlow, tweens.fast, {Size = UDim2.new(0, 8, 0, 8), BackgroundTransparency = 0.3}):Play()
                task.spawn(saveSettings)
            end
        end
    end)
    
    hitArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateValue(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input)
        end
    end)
    
    -- Hover effect
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.15}):Play()
        end
    end)
    
    container.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
        end
    end)
    
    local ref = {
        setValue = function(v)
            value = clamp(v, min, max)
            cfg[cfgKey] = value
            local fillPos = (value - min) / (max - min)
            fill.Size = UDim2.new(fillPos, 0, 1, 0)
            if stepSize >= 1 then
                valueLabel.Text = tostring(math.floor(value)) .. suffixText
            else
                valueLabel.Text = string.format("%.1f", value) .. suffixText
            end
            pcall(callback, value)
        end,
        getValue = function() return value end
    }
    
    sliderRefs[cfgKey] = ref
    return ref
end

local function createButton(parent, text, callback, icon, description)
    local container = Instance.new("TextButton")
    container.Name = "Button_" .. text
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, description and 48 or 38)
    container.Text = ""
    container.AutoButtonColor = false
    container.ZIndex = 16
    
    createCorner(container, 10)
    local stroke = createStroke(container, colors.border, 1, 0.7)
    
    -- Icon
    if icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.Parent = container
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 14, 0, description and 8 or 0)
        iconLabel.Size = UDim2.new(0, 20, 0, description and 18 or 38)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Text = icon
        iconLabel.TextColor3 = colors.accent
        iconLabel.TextSize = 13
        iconLabel.ZIndex = 17
    end
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, icon and 40 or 14, 0, description and 8 or 0)
    label.Size = UDim2.new(1, icon and -54 or -28, 0, description and 18 or 38)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    
    -- Description
    if description then
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.Parent = container
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, icon and 40 or 14, 0, 26)
        desc.Size = UDim2.new(1, icon and -54 or -28, 0, 14)
        desc.Font = Enum.Font.Gotham
        desc.Text = description
        desc.TextColor3 = colors.textDisabled
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.ZIndex = 17
    end
    
    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Parent = container
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "›"
    arrow.TextColor3 = colors.textMuted
    arrow.TextSize = 16
    arrow.ZIndex = 17
    
    container.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(container, tweens.ultraFast, {BackgroundTransparency = 0}):Play()
        task.wait(0.08)
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
        pcall(callback)
    end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(label, tweens.fast, {TextColor3 = colors.textPrimary}):Play()
        TweenService:Create(arrow, tweens.fast, {TextColor3 = colors.accent}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(label, tweens.fast, {TextColor3 = colors.textSecondary}):Play()
        TweenService:Create(arrow, tweens.fast, {TextColor3 = colors.textMuted}):Play()
    end)
    
    return container
end

local function createDropdown(parent, text, options, cfgKey, callback)
    local selectedIndex = cfg[cfgKey] or 1
    local isOpen = false
    
    local container = Instance.new("Frame")
    container.Name = "Dropdown_" .. cfgKey
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 38)
    container.ClipsDescendants = true
    container.ZIndex = 50
    
    createCorner(container, 10)
    local stroke = createStroke(container, colors.border, 1, 0.7)
    
    -- Header
    local header = Instance.new("TextButton")
    header.Name = "Header"
    header.Parent = container
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 38)
    header.Text = ""
    header.AutoButtonColor = false
    header.ZIndex = 51
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = header
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 52
    
    -- Selected Value
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "Selected"
    selectedLabel.Parent = header
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
    selectedLabel.Size = UDim2.new(0.5, -30, 1, 0)
    selectedLabel.Font = Enum.Font.GothamMedium
    selectedLabel.Text = options[selectedIndex] or "Select"
    selectedLabel.TextColor3 = colors.accent
    selectedLabel.TextSize = 11
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    selectedLabel.ZIndex = 52
    
    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Parent = header
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = colors.textMuted
    arrow.TextSize = 10
    arrow.ZIndex = 52
    
    -- Options Container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Parent = container
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Position = UDim2.new(0, 0, 0, 42)
    optionsContainer.Size = UDim2.new(1, 0, 0, #options * 32)
    optionsContainer.ZIndex = 51
    
    local optionsLayout = createListLayout(optionsContainer, 2)
    
    local function closeDropdown()
        isOpen = false
        TweenService:Create(container, tweens.medium, {Size = UDim2.new(1, 0, 0, 38)}):Play()
        TweenService:Create(arrow, tweens.fast, {Rotation = 0}):Play()
        container.ZIndex = 50
    end
    
    local function openDropdown()
        isOpen = true
        local openHeight = 42 + #options * 32 + 8
        TweenService:Create(container, tweens.bounce, {Size = UDim2.new(1, 0, 0, openHeight)}):Play()
        TweenService:Create(arrow, tweens.fast, {Rotation = 180}):Play()
        container.ZIndex = 100
    end
    
    -- Create option buttons
    for i, option in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Name = "Option_" .. i
        optBtn.Parent = optionsContainer
        optBtn.BackgroundColor3 = colors.surfaceLight
        optBtn.BackgroundTransparency = 0.5
        optBtn.Size = UDim2.new(1, -16, 0, 30)
        optBtn.Position = UDim2.new(0, 8, 0, 0)
        optBtn.Text = option
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.TextColor3 = i == selectedIndex and colors.accent or colors.textSecondary
        optBtn.TextSize = 11
        optBtn.AutoButtonColor = false
        optBtn.ZIndex = 52
        optBtn.LayoutOrder = i
        
        createCorner(optBtn, 6)
        
        optBtn.MouseButton1Click:Connect(function()
            selectedIndex = i
            cfg[cfgKey] = i
            selectedLabel.Text = option
            
            -- Update visual
            for _, btn in ipairs(optionsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = colors.textSecondary
                end
            end
            optBtn.TextColor3 = colors.accent
            
            closeDropdown()
            pcall(callback, i, option)
            task.spawn(saveSettings)
        end)
        
        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, tweens.fast, {BackgroundTransparency = 0.2}):Play()
        end)
        
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, tweens.fast, {BackgroundTransparency = 0.5}):Play()
        end)
    end
    
    header.MouseButton1Click:Connect(function()
        if isOpen then
            closeDropdown()
        else
            openDropdown()
        end
    end)
    
    header.MouseEnter:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.15}):Play()
    end)
    
    header.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
        end
    end)
    
    return container
end

local function createKeybind(parent, text, cfgKey, callback)
    local key = cfg[cfgKey] or "None"
    local listening = false
    
    local container = Instance.new("TextButton")
    container.Name = "Keybind_" .. cfgKey
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 38)
    container.Text = ""
    container.AutoButtonColor = false
    container.ZIndex = 16
    
    createCorner(container, 10)
    local stroke = createStroke(container, colors.border, 1, 0.7)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    
    -- Key Display
    local keyBg = Instance.new("Frame")
    keyBg.Name = "KeyBg"
    keyBg.Parent = container
    keyBg.BackgroundColor3 = colors.surfaceLight
    keyBg.Position = UDim2.new(1, -80, 0.5, -12)
    keyBg.Size = UDim2.new(0, 66, 0, 24)
    keyBg.ZIndex = 17
    
    createCorner(keyBg, 6)
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Name = "Key"
    keyLabel.Parent = keyBg
    keyLabel.BackgroundTransparency = 1
    keyLabel.Size = UDim2.new(1, 0, 1, 0)
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.Text = key
    keyLabel.TextColor3 = colors.textPrimary
    keyLabel.TextSize = 10
    keyLabel.ZIndex = 18
    
    container.MouseButton1Click:Connect(function()
        listening = true
        keyLabel.Text = "..."
        TweenService:Create(keyBg, tweens.fast, {BackgroundColor3 = colors.accent}):Play()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not listening then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode.Name
            cfg[cfgKey] = key
            keyLabel.Text = key
            listening = false
            TweenService:Create(keyBg, tweens.fast, {BackgroundColor3 = colors.surfaceLight}):Play()
            pcall(callback, input.KeyCode)
            task.spawn(saveSettings)
        end
    end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.15}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
    end)
    
    return container
end

local function createColorPicker(parent, text, cfgKey, callback)
    local currentColor = Color3.fromRGB(cfg[cfgKey].r or 255, cfg[cfgKey].g or 0, cfg[cfgKey].b or 0)
    
    local container = Instance.new("TextButton")
    container.Name = "ColorPicker_" .. cfgKey
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 38)
    container.Text = ""
    container.AutoButtonColor = false
    container.ZIndex = 16
    
    createCorner(container, 10)
    createStroke(container, colors.border, 1, 0.7)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    
    -- Color Preview
    local colorPreview = Instance.new("Frame")
    colorPreview.Name = "Preview"
    colorPreview.Parent = container
    colorPreview.BackgroundColor3 = currentColor
    colorPreview.Position = UDim2.new(1, -50, 0.5, -10)
    colorPreview.Size = UDim2.new(0, 36, 0, 20)
    colorPreview.ZIndex = 17
    
    createCorner(colorPreview, 6)
    createStroke(colorPreview, colors.border, 1, 0.5)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.15}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tweens.fast, {BackgroundTransparency = 0.3}):Play()
    end)
    
    return container
end

local function createTextInput(parent, text, cfgKey, callback, placeholder)
    local container = Instance.new("Frame")
    container.Name = "TextInput_" .. cfgKey
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 38)
    container.ZIndex = 16
    
    createCorner(container, 10)
    local stroke = createStroke(container, colors.border, 1, 0.7)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = colors.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    
    -- Input Box
    local inputBg = Instance.new("Frame")
    inputBg.Name = "InputBg"
    inputBg.Parent = container
    inputBg.BackgroundColor3 = colors.surfaceLight
    inputBg.Position = UDim2.new(0.4, 10, 0.5, -12)
    inputBg.Size = UDim2.new(0.6, -24, 0, 24)
    inputBg.ZIndex = 17
    
    createCorner(inputBg, 6)
    
    local input = Instance.new("TextBox")
    input.Name = "Input"
    input.Parent = inputBg
    input.BackgroundTransparency = 1
    input.Size = UDim2.new(1, -16, 1, 0)
    input.Position = UDim2.new(0, 8, 0, 0)
    input.Font = Enum.Font.GothamMedium
    input.Text = cfg[cfgKey] or ""
    input.PlaceholderText = placeholder or "Enter value..."
    input.PlaceholderColor3 = colors.textDisabled
    input.TextColor3 = colors.textPrimary
    input.TextSize = 11
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false
    input.ZIndex = 18
    
    input.FocusLost:Connect(function()
        cfg[cfgKey] = input.Text
        pcall(callback, input.Text)
        task.spawn(saveSettings)
    end)
    
    input.Focused:Connect(function()
        TweenService:Create(stroke, tweens.fast, {Color = colors.accent}):Play()
    end)
    
    input:GetPropertyChangedSignal("Text"):Connect(function()
        -- Text changed
    end)
    
    return container
end

local function createInfoCard(parent, title, value, icon, color)
    local container = Instance.new("Frame")
    container.Name = "InfoCard"
    container.Parent = parent
    container.BackgroundColor3 = colors.card
    container.BackgroundTransparency = 0.2
    container.BorderSizePixel = 0
    container.Size = UDim2.new(0.48, 0, 0, 60)
    container.ZIndex = 16
    
    createCorner(container, 10)
    
    -- Icon Background
    local iconBg = Instance.new("Frame")
    iconBg.Name = "IconBg"
    iconBg.Parent = container
    iconBg.BackgroundColor3 = color or colors.accent
    iconBg.BackgroundTransparency = 0.85
    iconBg.Position = UDim2.new(0, 12, 0.5, -18)
    iconBg.Size = UDim2.new(0, 36, 0, 36)
    iconBg.ZIndex = 17
    
    createCorner(iconBg, 10)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Parent = iconBg
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon or "◆"
    iconLabel.TextColor3 = color or colors.accent
    iconLabel.TextSize = 16
    iconLabel.ZIndex = 18
    
    -- Value
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = container
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 58, 0, 12)
    valueLabel.Size = UDim2.new(1, -70, 0, 20)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = colors.textPrimary
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.ZIndex = 17
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = container
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 58, 0, 32)
    titleLabel.Size = UDim2.new(1, -70, 0, 16)
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.Text = title
    titleLabel.TextColor3 = colors.textMuted
    titleLabel.TextSize = 10
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 17
    
    return {
        container = container,
        updateValue = function(newValue)
            valueLabel.Text = tostring(newValue)
        end
    }
end

local function createSpacer(parent, height)
    local spacer = Instance.new("Frame")
    spacer.Name = "Spacer"
    spacer.Parent = parent
    spacer.BackgroundTransparency = 1
    spacer.Size = UDim2.new(1, 0, 0, height or 8)
    spacer.ZIndex = 16
    return spacer
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                         TAB BUTTON CREATION                                    ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabContainer
    btn.BackgroundColor3 = colors.card
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 16
    btn.LayoutOrder = i
    
    createCorner(btn, 10)
    
    -- Active Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = btn
    indicator.BackgroundColor3 = colors.accent
    indicator.Position = UDim2.new(0, 0, 0.5, -8)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.ZIndex = 17
    
    createCorner(indicator, 2)
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Parent = btn
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0.5, 0, 0, 4)
    iconLabel.AnchorPoint = Vector2.new(0.5, 0)
    iconLabel.Size = UDim2.new(1, 0, 0, 18)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = tab.icon
    iconLabel.TextColor3 = colors.textDisabled
    iconLabel.TextSize = 14
    iconLabel.ZIndex = 17
    
    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0.5, 0, 0, 22)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.Text = tab.name
    nameLabel.TextColor3 = colors.textDisabled
    nameLabel.TextSize = 9
    nameLabel.ZIndex = 17
    
    -- Create page
    local page = createPage(tab.id)
    tabButtons[tab.id] = {
        btn = btn,
        icon = iconLabel,
        name = nameLabel,
        indicator = indicator
    }
    
    btn.MouseButton1Click:Connect(function()
        -- Deactivate all tabs
        for id, data in pairs(tabButtons) do
            TweenService:Create(data.btn, tweens.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.icon, tweens.fast, {TextColor3 = colors.textDisabled}):Play()
            TweenService:Create(data.name, tweens.fast, {TextColor3 = colors.textDisabled}):Play()
            TweenService:Create(data.indicator, tweens.medium, {Size = UDim2.new(0, 3, 0, 0)}):Play()
            pages[id].Visible = false
        end
        
        -- Activate clicked tab
        TweenService:Create(btn, tweens.fast, {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(iconLabel, tweens.fast, {TextColor3 = colors.accent}):Play()
        TweenService:Create(nameLabel, tweens.fast, {TextColor3 = colors.textPrimary}):Play()
        TweenService:Create(indicator, tweens.bounce, {Size = UDim2.new(0, 3, 0, 16)}):Play()
        page.Visible = true
        activeTab = tab.id
    end)
    
    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, tweens.fast, {BackgroundTransparency = 0.7}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, tweens.fast, {BackgroundTransparency = 1}):Play()
        end
    end)
    
    -- Set first tab as active
    if i == 1 then
        btn.BackgroundTransparency = 0.5
        iconLabel.TextColor3 = colors.accent
        nameLabel.TextColor3 = colors.textPrimary
        indicator.Size = UDim2.new(0, 3, 0, 16)
        page.Visible = true
        activeTab = tab.id
    end
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                            CORE FUNCTIONS                                      ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local function clearAllESP()
    for player, data in pairs(espData) do
        pcall(function()
            if data.obj then
                if typeof(data.obj) == "Instance" then
                    data.obj:Destroy()
                else
                    data.obj:Remove()
                end
            end
            if data.tracer then data.tracer:Remove() end
            if data.healthBar then data.healthBar:Destroy() end
        end)
    end
    espData = {}
end

local function getClosestPlayerInFOV()
    local closest = nil
    local minDistance = cfg.aimfov
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and player.Character then
            local targetPart = player.Character:FindFirstChild(cfg.aimTargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                -- Team check
                if cfg.ignoreTeammates and player.Team == plr.Team then continue end
                
                -- Visibility check
                if cfg.aimVisibleCheck and not isVisible(targetPart) then continue end
                
                local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    
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
    local localHRP = char and char:FindFirstChild("HumanoidRootPart")
    
    if not localHRP then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                if cfg.ignoreTeammates and player.Team == plr.Team then continue end
                
                local distance = (hrp.Position - localHRP.Position).Magnitude
                
                if distance < minDistance then
                    closest = player
                    minDistance = distance
                end
            end
        end
    end
    
    return closest
end

local function fireHit(target)
    if not target or not target.Character then return end
    
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("attack") or name:find("hit") or name:find("damage") or name:find("punch") or name:find("combat") then
                pcall(function()
                    remote:FireServer(target.Character)
                end)
            end
        end
    end
end

local function enableGodMode()
    if immortal then return end
    immortal = true
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    humanoid.Name = "ProtectedHumanoid_" .. math.random(1000, 9999)
    humanoid.BreakJointsOnDeath = false
    
    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        pcall(function()
            humanoid:SetStateEnabled(state, false)
        end)
    end
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    conn.godHealth = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health ~= math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    conn.godLoop = RunService.Heartbeat:Connect(function()
        if humanoid.Health ~= math.huge then
            humanoid.Health = math.huge
        end
        if humanoid:GetState() == Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function disableGodMode()
    if not immortal then return end
    immortal = false
    
    if conn.godHealth then conn.godHealth:Disconnect() end
    if conn.godLoop then conn.godLoop:Disconnect() end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Name = "Humanoid"
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        
        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            pcall(function()
                humanoid:SetStateEnabled(state, true)
            end)
        end
    end
end

local function enableFly()
    if flyActive then return end
    flyActive = true
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 9e4
    flyBodyGyro.CFrame = cam.CFrame
    flyBodyGyro.Parent = hrp
    
    humanoid.PlatformStand = true
    
    conn.fly = RunService.RenderStepped:Connect(function()
        if not flyActive then return end
        
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            flyBodyVelocity.Velocity = direction.Unit * cfg.flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

local function disableFly()
    if not flyActive then return end
    flyActive = false
    
    if conn.fly then conn.fly:Disconnect() end
    
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
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

local function createPlayerESP(player)
    if espData[player] or not player.Character then return end
    
    local character = player.Character
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not hrp or not humanoid then return end
    
    local isSelected = cfg.selectedPlayer == player
    local selectedColor = colors.highlight
    
    if cfg.espMode == 1 then
        -- Nametag ESP
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. player.Name
        billboard.Parent = hrp
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local container = Instance.new("Frame")
        container.Name = "Container"
        container.Parent = billboard
        container.BackgroundColor3 = isSelected and selectedColor or colors.background
        container.BackgroundTransparency = 0.2
        container.Size = UDim2.new(1, 0, 1, 0)
        
        createCorner(container, 6)
        
        -- Name
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.Parent = container
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 0, 0, 2)
        nameLabel.Size = UDim2.new(1, 0, 0, 14)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = isSelected and colors.black or colors.textPrimary
        nameLabel.TextScaled = true
        
        -- Distance
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "Distance"
        distanceLabel.Parent = container
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Position = UDim2.new(0, 0, 0, 16)
        distanceLabel.Size = UDim2.new(1, 0, 0, 10)
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Text = "0m"
        distanceLabel.TextColor3 = isSelected and colors.black or colors.textMuted
        distanceLabel.TextScaled = true
        
        -- Health Bar
        local healthBg = Instance.new("Frame")
        healthBg.Name = "HealthBg"
        healthBg.Parent = container
        healthBg.BackgroundColor3 = colors.surface
        healthBg.Position = UDim2.new(0.1, 0, 0, 28)
        healthBg.Size = UDim2.new(0.8, 0, 0, 6)
        
        createCorner(healthBg, 3)
        
        local healthFill = Instance.new("Frame")
        healthFill.Name = "Fill"
        healthFill.Parent = healthBg
        healthFill.BackgroundColor3 = colors.success
        healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
        
        createCorner(healthFill, 3)
        
        espData[player] = {
            obj = billboard,
            distance = distanceLabel,
            healthFill = healthFill,
            humanoid = humanoid,
            type = "nametag"
        }
        
    elseif cfg.espMode == 2 then
        -- Highlight ESP
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        highlight.Parent = character
        highlight.FillColor = isSelected and selectedColor or colors.accent
        highlight.OutlineColor = isSelected and selectedColor or colors.textPrimary
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0.3
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        espData[player] = {
            obj = highlight,
            type = "highlight"
        }
        
    elseif cfg.espMode == 3 then
        -- Box ESP
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_" .. player.Name
        box.Parent = hrp
        box.Size = character:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = isSelected and selectedColor or colors.accent
        box.Transparency = 0.5
        
        espData[player] = {
            obj = box,
            type = "box"
        }
    end
    
    -- Add tracer if enabled
    if cfg.tracers then
        local tracer = Drawing.new("Line")
        tracer.Visible = true
        tracer.Color = isSelected and selectedColor or colors.accent
        tracer.Thickness = 1.5
        tracer.Transparency = 0.7
        
        if cfg.tracerOrigin == "Top" then
            tracer.From = Vector2.new(cam.ViewportSize.X / 2, 0)
        elseif cfg.tracerOrigin == "Center" then
            tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        else
            tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
        end
        
        if espData[player] then
            espData[player].tracer = tracer
        end
    end
end

local function updateAllESP()
    local localHRP = char and char:FindFirstChild("HumanoidRootPart")
    
    for player, data in pairs(espData) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end
        
        local hrp = player.Character.HumanoidRootPart
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        
        -- Calculate distance
        local distance = 0
        if localHRP then
            distance = (hrp.Position - localHRP.Position).Magnitude
        end
        
        -- Max distance check
        if distance > cfg.espMaxDistance then
            if data.obj then
                if typeof(data.obj) == "Instance" then
                    data.obj.Enabled = false
                end
            end
            if data.tracer then
                data.tracer.Visible = false
            end
            continue
        else
            if data.obj and typeof(data.obj) == "Instance" then
                data.obj.Enabled = true
            end
        end
        
        -- Update distance label
        if data.distance then
            data.distance.Text = math.floor(distance) .. "m"
        end
        
        -- Update health bar
        if data.healthFill and humanoid then
            local healthPercent = clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            data.healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            
            if healthPercent > 0.6 then
                data.healthFill.BackgroundColor3 = colors.success
            elseif healthPercent > 0.3 then
                data.healthFill.BackgroundColor3 = colors.warning
            else
                data.healthFill.BackgroundColor3 = colors.error
            end
        end
        
        -- RGB effect
        if cfg.espRgb then
            local rainbow = Color3.fromHSV(tick() % 6 / 6, 0.6, 0.9)
            if data.type == "box" then
                data.obj.Color3 = rainbow
            elseif data.type == "highlight" then
                data.obj.FillColor = rainbow
                data.obj.OutlineColor = rainbow
            end
        end
        
        -- Update tracer
        if data.tracer then
            local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                data.tracer.Visible = true
                data.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                
                if cfg.tracerOrigin == "Top" then
                    data.tracer.From = Vector2.new(cam.ViewportSize.X / 2, 0)
                elseif cfg.tracerOrigin == "Center" then
                    data.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                else
                    data.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                end
            else
                data.tracer.Visible = false
            end
        end
    end
end

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              HOME PAGE                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local homePage = pages["home"]

-- Player Card
local playerCard = Instance.new("Frame")
playerCard.Name = "PlayerCard"
playerCard.Parent = homePage
playerCard.BackgroundColor3 = colors.card
playerCard.BackgroundTransparency = 0.15
playerCard.BorderSizePixel = 0
playerCard.Size = UDim2.new(1, 0, 0, 80)
playerCard.ZIndex = 16

createCorner(playerCard, 12)

-- Avatar
local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "Avatar"
avatarFrame.Parent = playerCard
avatarFrame.BackgroundColor3 = colors.surfaceLight
avatarFrame.Position = UDim2.new(0, 14, 0.5, 0)
avatarFrame.AnchorPoint = Vector2.new(0, 0.5)
avatarFrame.Size = UDim2.new(0, 52, 0, 52)
avatarFrame.ZIndex = 17

createCorner(avatarFrame, 12)

local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "Image"
avatarImage.Parent = avatarFrame
avatarImage.BackgroundTransparency = 1
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.ZIndex = 18

createCorner(avatarImage, 12)

pcall(function()
    avatarImage.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

-- Player Name
local playerName = Instance.new("TextLabel")
playerName.Name = "Name"
playerName.Parent = playerCard
playerName.BackgroundTransparency = 1
playerName.Position = UDim2.new(0, 78, 0, 16)
playerName.Size = UDim2.new(1, -90, 0, 22)
playerName.Font = Enum.Font.GothamBold
playerName.Text = plr.Name
playerName.TextColor3 = colors.textPrimary
playerName.TextSize = 16
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.ZIndex = 17

-- Player Display Name
local playerDisplay = Instance.new("TextLabel")
playerDisplay.Name = "Display"
playerDisplay.Parent = playerCard
playerDisplay.BackgroundTransparency = 1
playerDisplay.Position = UDim2.new(0, 78, 0, 38)
playerDisplay.Size = UDim2.new(1, -90, 0, 16)
playerDisplay.Font = Enum.Font.GothamMedium
playerDisplay.Text = "@" .. plr.DisplayName
playerDisplay.TextColor3 = colors.textMuted
playerDisplay.TextSize = 11
playerDisplay.TextXAlignment = Enum.TextXAlignment.Left
playerDisplay.ZIndex = 17

-- Game Info
local gameInfo = Instance.new("TextLabel")
gameInfo.Name = "GameInfo"
gameInfo.Parent = playerCard
gameInfo.BackgroundTransparency = 1
gameInfo.Position = UDim2.new(0, 78, 0, 54)
gameInfo.Size = UDim2.new(1, -90, 0, 14)
gameInfo.Font = Enum.Font.Gotham
gameInfo.Text = "Playing: " .. (MarketplaceService:GetProductInfo(game.PlaceId).Name or "Unknown")
gameInfo.TextColor3 = colors.textDisabled
gameInfo.TextSize = 9
gameInfo.TextXAlignment = Enum.TextXAlignment.Left
gameInfo.TextTruncate = Enum.TextTruncate.AtEnd
gameInfo.ZIndex = 17

createSpacer(homePage, 4)

-- Stats Container
local statsContainer = Instance.new("Frame")
statsContainer.Name = "Stats"
statsContainer.Parent = homePage
statsContainer.BackgroundTransparency = 1
statsContainer.Size = UDim2.new(1, 0, 0, 68)
statsContainer.ZIndex = 16

local statsLayout = Instance.new("UIListLayout")
statsLayout.Parent = statsContainer
statsLayout.FillDirection = Enum.FillDirection.Horizontal
statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
statsLayout.Padding = UDim.new(0, 8)

local fpsCard = createInfoCard(statsContainer, "FPS", "60", "⚡", colors.success)
local pingCard = createInfoCard(statsContainer, "Ping", "0ms", "◈", colors.warning)

createSpacer(homePage, 4)

createSection(homePage, "Quick Actions")

createButton(homePage, "Reset Character", function()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
    notify("Character reset", 2, "success")
end, "↺", "Respawn your character")

createButton(homePage, "Rejoin Server", function()
    notify("Rejoining server...", 2, "warning")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, "⟳", "Reconnect to this server")

createButton(homePage, "Server Hop", function()
    notify("Finding new server...", 2, "warning")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, "⇄", "Join a different server")

createButton(homePage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied!", 2, "success")
    else
        notify("Clipboard not supported", 2, "error")
    end
end, "⎘", "Copy current server ID")

createSpacer(homePage, 4)

createSection(homePage, "Session Info")

-- Session Time Display
local sessionCard = Instance.new("Frame")
sessionCard.Name = "Session"
sessionCard.Parent = homePage
sessionCard.BackgroundColor3 = colors.card
sessionCard.BackgroundTransparency = 0.3
sessionCard.BorderSizePixel = 0
sessionCard.Size = UDim2.new(1, 0, 0, 38)
sessionCard.ZIndex = 16

createCorner(sessionCard, 10)

local sessionLabel = Instance.new("TextLabel")
sessionLabel.Name = "Label"
sessionLabel.Parent = sessionCard
sessionLabel.BackgroundTransparency = 1
sessionLabel.Position = UDim2.new(0, 14, 0, 0)
sessionLabel.Size = UDim2.new(0.5, 0, 1, 0)
sessionLabel.Font = Enum.Font.GothamMedium
sessionLabel.Text = "Session Time"
sessionLabel.TextColor3 = colors.textSecondary
sessionLabel.TextSize = 12
sessionLabel.TextXAlignment = Enum.TextXAlignment.Left
sessionLabel.ZIndex = 17

local sessionTime = Instance.new("TextLabel")
sessionTime.Name = "Time"
sessionTime.Parent = sessionCard
sessionTime.BackgroundTransparency = 1
sessionTime.Position = UDim2.new(0.5, 0, 0, 0)
sessionTime.Size = UDim2.new(0.5, -14, 1, 0)
sessionTime.Font = Enum.Font.GothamBold
sessionTime.Text = "00:00"
sessionTime.TextColor3 = colors.accent
sessionTime.TextSize = 12
sessionTime.TextXAlignment = Enum.TextXAlignment.Right
sessionTime.ZIndex = 17

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                             COMBAT PAGE                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local combatPage = pages["combat"]

createSection(combatPage, "Protection")

createToggle(combatPage, "God Mode", "god", function(state)
    if state then
        enableGodMode()
        notify("God Mode enabled", 2, "success")
    else
        disableGodMode()
        notify("God Mode disabled", 2)
    end
end, "Become invincible to all damage")

createToggle(combatPage, "Anti Void", "antiVoid", function(state)
    if state then
        local safePosition = char.HumanoidRootPart.CFrame
        conn.antiVoid = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp.Position.Y > -50 then
                    safePosition = hrp.CFrame
                end
                if hrp.Position.Y < -100 then
                    hrp.CFrame = safePosition
                end
            end
        end)
        notify("Anti Void enabled", 2, "success")
    else
        if conn.antiVoid then conn.antiVoid:Disconnect() end
        notify("Anti Void disabled", 2)
    end
end, "Prevents falling into the void")

createToggle(combatPage, "Auto Heal", "autoHeal", function(state)
    if state then
        conn.autoHeal = RunService.Heartbeat:Connect(function()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
                if healthPercent < cfg.autoHealPercent then
                    -- Try to find heal tools/abilities
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            local name = remote.Name:lower()
                            if name:find("heal") or name:find("regenerate") or name:find("health") then
                                pcall(function()
                                    remote:FireServer()
                                end)
                            end
                        end
                    end
                end
            end
        end)
        notify("Auto Heal enabled", 2, "success")
    else
        if conn.autoHeal then conn.autoHeal:Disconnect() end
        notify("Auto Heal disabled", 2)
    end
end, "Automatically heals when low")

createSlider(combatPage, "Heal Threshold", 10, 90, "autoHealPercent", function(value)
end, "%", 5, "Health % to trigger heal")

createSpacer(combatPage, 4)

createSection(combatPage, "Aimbot")

createToggle(combatPage, "Auto Aim", "aim", function(state)
    if state then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestPlayerInFOV()
            
            if cfg.aimStickyTarget and currentTarget and currentTarget.Character then
                local humanoid = currentTarget.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    target = currentTarget
                end
            end
            
            if target and target.Character then
                local targetPart = target.Character:FindFirstChild(cfg.aimTargetPart) or target.Character:FindFirstChild("HumanoidRootPart")
                
                if targetPart then
                    local targetPos = targetPart.Position
                    
                    -- Prediction
                    if cfg.aimPrediction and targetPart.Parent:FindFirstChild("HumanoidRootPart") then
                        local velocity = targetPart.Parent.HumanoidRootPart.Velocity
                        targetPos = targetPos + velocity * cfg.aimPredictionAmount
                    end
                    
                    -- Smooth aim
                    local currentCFrame = cam.CFrame
                    local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                    
                    cam.CFrame = currentCFrame:Lerp(targetCFrame, cfg.aimSmooth)
                    currentTarget = target
                end
            else
                currentTarget = nil
            end
        end)
        notify("Auto Aim enabled", 2, "success")
    else
        if conn.aim then conn.aim:Disconnect() end
        currentTarget = nil
        notify("Auto Aim disabled", 2)
    end
end, "Locks camera to nearest player")

createToggle(combatPage, "Show FOV Circle", "showfov", function(state)
    fovCircle.Visible = state
end, "Shows aim field of view circle")

createSlider(combatPage, "FOV Size", 50, 400, "aimfov", function(value)
    fovCircle.Radius = value
end, "px", 10, "Aimbot field of view radius")

createSlider(combatPage, "Aim Smoothness", 0.1, 1, "aimSmooth", function(value)
end, "", 0.05, "How smooth the aim is")

createDropdown(combatPage, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, "aimTargetPart", function(index, option)
    cfg.aimTargetPart = option
end)

createToggle(combatPage, "Sticky Target", "aimStickyTarget", function(state)
end, "Keeps aiming at same target")

createToggle(combatPage, "Aim Prediction", "aimPrediction", function(state)
end, "Predicts target movement")

createSlider(combatPage, "Prediction Amount", 0.05, 0.5, "aimPredictionAmount", function(value)
end, "", 0.05, "Movement prediction strength")

createSpacer(combatPage, 4)

createSection(combatPage, "Silent Aim")

createToggle(combatPage, "Silent Aim (FOV)", "silentAim", function(state)
    if state then
        conn.silentAim = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestPlayerInFOV()
                if target then
                    fireHit(target)
                end
            end
        end)
        notify("Silent Aim enabled", 2, "success")
    else
        if conn.silentAim then conn.silentAim:Disconnect() end
        notify("Silent Aim disabled", 2)
    end
end, "Hits target without aiming")

createToggle(combatPage, "Silent Aim (No FOV)", "silentNoFov", function(state)
    if state then
        conn.silentNoFov = mouse.Button1Down:Connect(function()
            if math.random(1, 100) <= cfg.hitChance then
                local target = getClosestPlayer()
                if target then
                    fireHit(target)
                end
            end
        end)
        notify("Silent Aim (No FOV) enabled", 2, "success")
    else
        if conn.silentNoFov then conn.silentNoFov:Disconnect() end
        notify("Silent Aim (No FOV) disabled", 2)
    end
end, "Hits closest player anywhere")

createSpacer(combatPage, 4)

createSection(combatPage, "Kill Aura")

createToggle(combatPage, "Kill Aura", "killaura", function(state)
    if state then
        conn.aura = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local targetCount = 0
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local distance = (player.Character)  
                    end
                 end
            end
        end
    end
end

.HumanoidRootPart.Position - hrp.Position).Magnitude
                        
                        if distance <= cfg.auraRange then
                            if cfg.ignoreTeammates and player.Team == plr.Team then continue end
                            
                            if math.random(1, 100) <= cfg.hitChance then
                                if cfg.auraMultiTarget then
                                    if targetCount < cfg.auraMaxTargets then
                                        fireHit(player)
                                        targetCount = targetCount + 1
                                    end
                                else
                                    fireHit(player)
                                    break
                                end
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
end, "Auto attacks nearby players")

createToggle(combatPage, "Show Aura Range", "showAura", function(state)
    auraCircle.Visible = state
end, "Shows kill aura range circle")

createSlider(combatPage, "Aura Range", 5, 50, "auraRange", function(value)
    auraCircle.Radius = value * 4
end, " studs", 1, "Attack range in studs")

createToggle(combatPage, "Multi Target", "auraMultiTarget", function(state)
end, "Attack multiple players at once")

createSlider(combatPage, "Max Targets", 1, 10, "auraMaxTargets", function(value)
end, "", 1, "Maximum simultaneous targets")

createSlider(combatPage, "Hit Chance", 50, 100, "hitChance", function(value)
end, "%", 5, "Probability of hitting")

createSpacer(combatPage, 4)

createSection(combatPage, "Auto Combat")

createToggle(combatPage, "Auto Attack", "autoAttack", function(state)
    if state then
        conn.autoAttack = RunService.Heartbeat:Connect(function()
            local target = getClosestPlayer()
            if target and target.Character then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHRP then
                    local distance = (targetHRP.Position - hrp.Position).Magnitude
                    if distance <= 15 then
                        fireHit(target)
                    end
                end
            end
        end)
        notify("Auto Attack enabled", 2, "success")
    else
        if conn.autoAttack then conn.autoAttack:Disconnect() end
        notify("Auto Attack disabled", 2)
    end
end, "Automatically attacks enemies")

createToggle(combatPage, "Auto Block", "autoBlock", function(state)
    if state then
        conn.autoBlock = RunService.Heartbeat:Connect(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("block") or name:find("defend") or name:find("guard") then
                        pcall(function()
                            remote:FireServer(true)
                        end)
                    end
                end
            end
        end)
        notify("Auto Block enabled", 2, "success")
    else
        if conn.autoBlock then conn.autoBlock:Disconnect() end
        notify("Auto Block disabled", 2)
    end
end, "Automatically blocks attacks")

createToggle(combatPage, "Auto Parry", "autoParry", function(state)
    if state then
        conn.autoParry = RunService.Heartbeat:Connect(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("parry") or name:find("counter") then
                        pcall(function()
                            remote:FireServer()
                        end)
                    end
                end
            end
        end)
        notify("Auto Parry enabled", 2, "success")
    else
        if conn.autoParry then conn.autoParry:Disconnect() end
        notify("Auto Parry disabled", 2)
    end
end, "Automatically parries attacks")

createToggle(combatPage, "Auto Dodge", "autoDodge", function(state)
    if state then
        conn.autoDodge = RunService.Heartbeat:Connect(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("dodge") or name:find("dash") or name:find("roll") then
                        pcall(function()
                            remote:FireServer()
                        end)
                    end
                end
            end
        end)
        notify("Auto Dodge enabled", 2, "success")
    else
        if conn.autoDodge then conn.autoDodge:Disconnect() end
        notify("Auto Dodge disabled", 2)
    end
end, "Automatically dodges attacks")

createSpacer(combatPage, 4)

createSection(combatPage, "Hitbox")

createToggle(combatPage, "Hitbox Expander", "hitboxExpander", function(state)
    if state then
        conn.hitbox = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(cfg.hitboxSize, cfg.hitboxSize, cfg.hitboxSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really red")
                        hrp.Material = Enum.Material.ForceField
                        hrp.CanCollide = false
                    end
                end
            end
        end)
        notify("Hitbox Expander enabled", 2, "success")
    else
        if conn.hitbox then conn.hitbox:Disconnect() end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                end
            end
        end
        notify("Hitbox Expander disabled", 2)
    end
end, "Expands enemy hitboxes")

createSlider(combatPage, "Hitbox Size", 2, 20, "hitboxSize", function(value)
end, " studs", 1, "Size of expanded hitbox")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                            MOVEMENT PAGE                                       ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local movementPage = pages["movement"]

createSection(movementPage, "Speed")

createToggle(movementPage, "Speed Hack", "speedHack", function(state)
    if not state then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = cfg.speedDefault
        end
    end
    notify(state and "Speed Hack enabled" or "Speed Hack disabled", 2, state and "success" or nil)
end, "Increases walk speed")

createSlider(movementPage, "Walk Speed", 16, 500, "speed", function(value)
    if cfg.speedHack then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end, "", 1, "Character walk speed")

createSpacer(movementPage, 4)

createSection(movementPage, "Flight")

createToggle(movementPage, "Fly", "fly", function(state)
    if state then
        enableFly()
        notify("Fly enabled - Use WASD + Space/Ctrl", 3, "success")
    else
        disableFly()
        notify("Fly disabled", 2)
    end
end, "Allows free flight movement")

createSlider(movementPage, "Fly Speed", 10, 200, "flySpeed", function(value)
end, "", 5, "Flight movement speed")

createKeybind(movementPage, "Fly Toggle Key", "flyKey", function(keyCode)
    notify("Fly key set to " .. keyCode.Name, 2, "success")
end)

createSpacer(movementPage, 4)

createSection(movementPage, "Noclip")

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
end, "Walk through walls and objects")

createKeybind(movementPage, "Noclip Toggle Key", "noclipKey", function(keyCode)
    notify("Noclip key set to " .. keyCode.Name, 2, "success")
end)

createSpacer(movementPage, 4)

createSection(movementPage, "Jump")

createToggle(movementPage, "Infinite Jump", "infiniteJump", function(state)
    if state then
        conn.infJump = UserInputService.JumpRequest:Connect(function()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        notify("Infinite Jump enabled", 2, "success")
    else
        if conn.infJump then conn.infJump:Disconnect() end
        notify("Infinite Jump disabled", 2)
    end
end, "Jump unlimited times in air")

createToggle(movementPage, "High Jump", "highJump", function(state)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = state and cfg.jumpPower or cfg.jumpDefault
    end
    notify(state and "High Jump enabled" or "High Jump disabled", 2, state and "success" or nil)
end, "Increases jump height")

createSlider(movementPage, "Jump Power", 50, 300, "jumpPower", function(value)
    if cfg.highJump then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end
end, "", 10, "Jump height power")

createSpacer(movementPage, 4)

createSection(movementPage, "Gravity")

createToggle(movementPage, "Low Gravity", "lowGravity", function(state)
    Workspace.Gravity = state and cfg.gravityAmount or defaultGravity
    notify(state and "Low Gravity enabled" or "Gravity restored", 2, state and "success" or nil)
end, "Reduces world gravity")

createSlider(movementPage, "Gravity Amount", 10, 196, "gravityAmount", function(value)
    if cfg.lowGravity then
        Workspace.Gravity = value
    end
end, "", 5, "Gravity strength")

createSpacer(movementPage, 4)

createSection(movementPage, "Teleportation")

createToggle(movementPage, "Click Teleport", "clickTeleport", function(state)
    if state then
        conn.clickTP = mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
        notify("Click Teleport enabled (Ctrl + Click)", 2, "success")
    else
        if conn.clickTP then conn.clickTP:Disconnect() end
        notify("Click Teleport disabled", 2)
    end
end, "Ctrl+Click to teleport")

createButton(movementPage, "Teleport Forward", function()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 50
        notify("Teleported forward", 2, "success")
    end
end, "➤", "Teleport 50 studs forward")

createButton(movementPage, "Teleport to Spawn", function()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        notify("Teleported to spawn", 2, "success")
    else
        notify("No spawn found", 2, "error")
    end
end, "⌂", "Teleport to spawn point")

createSpacer(movementPage, 4)

createSection(movementPage, "Waypoints")

local waypointNameInput = ""

createTextInput(movementPage, "Waypoint Name", "waypointName", function(text)
    waypointNameInput = text
end, "Enter waypoint name...")

createButton(movementPage, "Save Waypoint", function()
    if waypointNameInput ~= "" then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            savedWaypoints[waypointNameInput] = hrp.Position
            saveWaypoints()
            notify("Waypoint '" .. waypointNameInput .. "' saved!", 2, "success")
        end
    else
        notify("Enter a waypoint name first", 2, "warning")
    end
end, "◆", "Save current position")

createButton(movementPage, "Load Waypoint", function()
    if waypointNameInput ~= "" and savedWaypoints[waypointNameInput] then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(savedWaypoints[waypointNameInput])
            notify("Teleported to '" .. waypointNameInput .. "'", 2, "success")
        end
    else
        notify("Waypoint not found", 2, "error")
    end
end, "◇", "Teleport to saved waypoint")

createButton(movementPage, "Delete Waypoint", function()
    if waypointNameInput ~= "" and savedWaypoints[waypointNameInput] then
        savedWaypoints[waypointNameInput] = nil
        saveWaypoints()
        notify("Waypoint '" .. waypointNameInput .. "' deleted", 2, "success")
    else
        notify("Waypoint not found", 2, "error")
    end
end, "✕", "Delete saved waypoint")

createSpacer(movementPage, 4)

createSection(movementPage, "Character States")

createToggle(movementPage, "No Ragdoll", "noRagdoll", function(state)
    if state then
        conn.noRagdoll = RunService.Heartbeat:Connect(function()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            end
        end)
        notify("No Ragdoll enabled", 2, "success")
    else
        if conn.noRagdoll then conn.noRagdoll:Disconnect() end
        notify("No Ragdoll disabled", 2)
    end
end, "Prevents ragdoll state")

createToggle(movementPage, "No Fall Damage", "noFall", function(state)
    if state then
        conn.noFall = RunService.Heartbeat:Connect(function()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)
        notify("No Fall Damage enabled", 2, "success")
    else
        if conn.noFall then conn.noFall:Disconnect() end
        notify("No Fall Damage disabled", 2)
    end
end, "Prevents fall damage")

createToggle(movementPage, "Infinite Stamina", "infiniteStamina", function(state)
    if state then
        conn.stamina = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(plr.PlayerGui:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    local name = obj.Name:lower()
                    if name:find("stamina") or name:find("energy") or name:find("sprint") then
                        obj.Value = obj.Value < 100 and 100 or obj.Value
                    end
                end
            end
            for _, obj in pairs(plr:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    local name = obj.Name:lower()
                    if name:find("stamina") or name:find("energy") or name:find("sprint") then
                        obj.Value = obj.Value < 100 and 100 or obj.Value
                    end
                end
            end
        end)
        notify("Infinite Stamina enabled", 2, "success")
    else
        if conn.stamina then conn.stamina:Disconnect() end
        notify("Infinite Stamina disabled", 2)
    end
end, "Unlimited stamina/energy")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                             VISUAL PAGE                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local visualPage = pages["visual"]

createSection(visualPage, "World Effects")

createToggle(visualPage, "No Fog", "fog", function(state)
    if state then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
    notify(state and "Fog removed" or "Fog restored", 2, state and "success" or nil)
end, "Removes world fog")

createToggle(visualPage, "Fullbright", "bright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
    notify(state and "Fullbright enabled" or "Fullbright disabled", 2, state and "success" or nil)
end, "Makes everything bright")

createToggle(visualPage, "Time Control", "timeControl", function(state)
    if state then
        conn.timeControl = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = cfg.timeValue
        end)
        notify("Time Control enabled", 2, "success")
    else
        if conn.timeControl then conn.timeControl:Disconnect() end
        notify("Time Control disabled", 2)
    end
end, "Lock time of day")

createSlider(visualPage, "Time Value", 0, 24, "timeValue", function(value)
    if cfg.timeControl then
        Lighting.ClockTime = value
    end
end, "h", 0.5, "Hour of the day")

createSpacer(visualPage, 4)

createSection(visualPage, "Camera")

createSlider(visualPage, "Field of View", 30, 120, "fov", function(value)
    cam.FieldOfView = value
end, "°", 5, "Camera field of view")

createToggle(visualPage, "Free Camera", "freeCam", function(state)
    if state then
        local freeCamPos = cam.CFrame
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
        end
        
        conn.freeCam = RunService.RenderStepped:Connect(function()
            local moveVector = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            if moveVector.Magnitude > 0 then
                freeCamPos = freeCamPos + moveVector.Unit * cfg.freeCamSpeed
            end
            
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = CFrame.new(freeCamPos.Position) * (cam.CFrame - cam.CFrame.Position)
        end)
        notify("Free Camera enabled", 2, "success")
    else
        if conn.freeCam then conn.freeCam:Disconnect() end
        cam.CameraType = Enum.CameraType.Custom
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            cam.CameraSubject = humanoid
            humanoid.WalkSpeed = cfg.speedHack and cfg.speed or defaultSpeed
        end
        notify("Free Camera disabled", 2)
    end
end, "Detach camera from character")

createSlider(visualPage, "Free Cam Speed", 0.5, 5, "freeCamSpeed", function(value)
end, "", 0.1, "Camera movement speed")

createToggle(visualPage, "Third Person", "thirdPerson", function(state)
    if state then
        plr.CameraMaxZoomDistance = cfg.thirdPersonDistance
        plr.CameraMinZoomDistance = cfg.thirdPersonDistance
        notify("Third Person enabled", 2, "success")
    else
        plr.CameraMaxZoomDistance = 128
        plr.CameraMinZoomDistance = 0.5
        notify("Third Person disabled", 2)
    end
end, "Lock third person view")

createSlider(visualPage, "Camera Distance", 5, 50, "thirdPersonDistance", function(value)
    if cfg.thirdPerson then
        plr.CameraMaxZoomDistance = value
        plr.CameraMinZoomDistance = value
    end
end, " studs", 1, "Third person distance")

createToggle(visualPage, "No Camera Shake", "cameraShakeRemove", function(state)
    if state then
        conn.noShake = RunService.RenderStepped:Connect(function()
            for _, effect in pairs(cam:GetChildren()) do
                if effect:IsA("Script") or effect.Name:lower():find("shake") then
                    effect:Destroy()
                end
            end
        end)
        notify("Camera Shake removed", 2, "success")
    else
        if conn.noShake then conn.noShake:Disconnect() end
        notify("Camera Shake restored", 2)
    end
end, "Removes camera shake effects")

createSpacer(visualPage, 4)

createSection(visualPage, "Character")

createToggle(visualPage, "Invisible", "invisible", function(state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if state then
                if not part:GetAttribute("OrigTransparency") then
                    part:SetAttribute("OrigTransparency", part.Transparency)
                end
                part.Transparency = 1
            else
                local orig = part:GetAttribute("OrigTransparency")
                part.Transparency = orig or 0
            end
        elseif part:IsA("Decal") or part:IsA("Texture") then
            if state then
                if not part:GetAttribute("OrigTransparency") then
                    part:SetAttribute("OrigTransparency", part.Transparency)
                end
                part.Transparency = 1
            else
                local orig = part:GetAttribute("OrigTransparency")
                part.Transparency = orig or 0
            end
        end
    end
    notify(state and "Invisible enabled" or "Invisible disabled", 2, state and "success" or nil)
end, "Makes character invisible")

createSlider(visualPage, "Character Scale", 0.5, 3, "characterScale", function(value)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local bodyDepth = humanoid:FindFirstChild("BodyDepthScale")
        local bodyWidth = humanoid:FindFirstChild("BodyWidthScale")
        local bodyHeight = humanoid:FindFirstChild("BodyHeightScale")
        local headScale = humanoid:FindFirstChild("HeadScale")
        
        if bodyDepth then bodyDepth.Value = value end
        if bodyWidth then bodyWidth.Value = value end
        if bodyHeight then bodyHeight.Value = value end
        if headScale then headScale.Value = value end
    end
end, "x", 0.1, "Character body scale")

createSlider(visualPage, "Head Size", 0.5, 5, "headSize", function(value)
    local head = char:FindFirstChild("Head")
    if head then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local headScale = humanoid:FindFirstChild("HeadScale")
            if headScale then
                headScale.Value = value
            end
        end
    end
end, "x", 0.1, "Character head size")

createSpacer(visualPage, 4)

createSection(visualPage, "World Cleanup")

createToggle(visualPage, "No Particles", "noParticles", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = not state
        end
    end
    notify(state and "Particles removed" or "Particles restored", 2, state and "success" or nil)
end, "Removes all particles")

createToggle(visualPage, "No Effects", "noEffects", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
            if state then
                if not obj:GetAttribute("WasEnabled") then
                    obj:SetAttribute("WasEnabled", obj.Enabled or true)
                end
                obj.Enabled = false
            else
                local was = obj:GetAttribute("WasEnabled")
                if was ~= nil then obj.Enabled = was end
            end
        end
    end
    notify(state and "Effects removed" or "Effects restored", 2, state and "success" or nil)
end, "Removes fire, smoke, etc.")

createToggle(visualPage, "X-Ray Walls", "xray", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            local name = obj.Name:lower()
            if name:find("wall") or name:find("door") or name:find("barrier") or name:find("window") then
                if state then
                    if not obj:GetAttribute("OrigTransparency") then
                        obj:SetAttribute("OrigTransparency", obj.Transparency)
                    end
                    obj.Transparency = cfg.xrayTransparency
                else
                    local orig = obj:GetAttribute("OrigTransparency")
                    if orig then obj.Transparency = orig end
                end
            end
        end
    end
    notify(state and "X-Ray enabled" or "X-Ray disabled", 2, state and "success" or nil)
end, "See through walls")

createSlider(visualPage, "X-Ray Transparency", 0.3, 0.95, "xrayTransparency", function(value)
    if cfg.xray then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
                local name = obj.Name:lower()
                if name:find("wall") or name:find("door") or name:find("barrier") then
                    obj.Transparency = value
                end
            end
        end
    end
end, "", 0.05, "Wall transparency level")

createToggle(visualPage, "No Decals", "noDecals", function(state)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            if state then
                if not obj:GetAttribute("OrigTransparency") then
                    obj:SetAttribute("OrigTransparency", obj.Transparency)
                end
                obj.Transparency = 1
            else
                local orig = obj:GetAttribute("OrigTransparency")
                if orig then obj.Transparency = orig end
            end
        end
    end
    notify(state and "Decals hidden" or "Decals restored", 2, state and "success" or nil)
end, "Removes decals and textures")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                               ESP PAGE                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local espPage = pages["esp"]

createSection(espPage, "Player ESP")

createToggle(espPage, "Enable ESP", "esp", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                createPlayerESP(player)
            end
        end
        notify("ESP enabled", 2, "success")
    else
        clearAllESP()
        notify("ESP disabled", 2)
    end
end, "Show players through walls")

createDropdown(espPage, "ESP Mode", {"Nametag", "Highlight", "Box"}, "espMode", function(index, option)
    cfg.espMode = index
    if cfg.esp then
        clearAllESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                createPlayerESP(player)
            end
        end
    end
    notify("ESP Mode: " .. option, 2, "success")
end)

createToggle(espPage, "RGB Effect", "espRgb", function(state)
    notify(state and "RGB effect enabled" or "RGB effect disabled", 2, state and "success" or nil)
end, "Rainbow color cycling")

createToggle(espPage, "Team Check", "espTeamCheck", function(state)
    notify(state and "Team check enabled" or "Team check disabled", 2, state and "success" or nil)
end, "Hide teammates from ESP")

createSlider(espPage, "Max Distance", 100, 5000, "espMaxDistance", function(value)
end, "m", 100, "ESP visibility range")

createSpacer(espPage, 4)

createSection(espPage, "ESP Details")

createToggle(espPage, "Show Names", "espShowName", function(state)
end, "Display player names")

createToggle(espPage, "Show Distance", "espShowDistance", function(state)
end, "Display distance to player")

createToggle(espPage, "Show Health", "espShowHealth", function(state)
end, "Display health bars")

createSpacer(espPage, 4)

createSection(espPage, "Tracers")

createToggle(espPage, "Tracers", "tracers", function(state)
    if not state then
        for player, data in pairs(espData) do
            if data.tracer then
                data.tracer:Remove()
                data.tracer = nil
            end
        end
    else
        if cfg.esp then
            clearAllESP()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr then
                    createPlayerESP(player)
                end
            end
        end
    end
    notify(state and "Tracers enabled" or "Tracers disabled", 2, state and "success" or nil)
end, "Lines pointing to players")

createDropdown(espPage, "Tracer Origin", {"Bottom", "Center", "Top"}, "tracerOrigin", function(index, option)
    cfg.tracerOrigin = option
end)

createSpacer(espPage, 4)

createSection(espPage, "Additional ESP")

createToggle(espPage, "NPC ESP", "npcEsp", function(state)
    if state then
        conn.npcEsp = RunService.Heartbeat:Connect(function()
            for _, npc in pairs(Workspace:GetDescendants()) do
                if npc:IsA("Humanoid") and npc.Parent and not Players:GetPlayerFromCharacter(npc.Parent) then
                    local hrp = npc.Parent:FindFirstChild("HumanoidRootPart") or npc.Parent:FindFirstChild("Torso")
                    if hrp and not npcEspData[npc] then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = colors.warning
                        highlight.OutlineColor = colors.warning
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0.4
                        highlight.Parent = npc.Parent
                        npcEspData[npc] = highlight
                    end
                end
            end
        end)
        notify("NPC ESP enabled", 2, "success")
    else
        if conn.npcEsp then conn.npcEsp:Disconnect() end
        for npc, esp in pairs(npcEspData) do
            pcall(function() esp:Destroy() end)
        end
        npcEspData = {}
        notify("NPC ESP disabled", 2)
    end
end, "Highlights NPCs")

createToggle(espPage, "Item ESP", "itemEsp", function(state)
    if state then
        conn.itemEsp = RunService.Heartbeat:Connect(function()
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") or (item:IsA("BasePart") and item.Name:lower():find("item")) then
                    if not itemEspData[item] then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = colors.success
                        highlight.OutlineColor = colors.success
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0.4
                        highlight.Parent = item
                        itemEspData[item] = highlight
                    end
                end
            end
        end)
        notify("Item ESP enabled", 2, "success")
    else
        if conn.itemEsp then conn.itemEsp:Disconnect() end
        for item, esp in pairs(itemEspData) do
            pcall(function() esp:Destroy() end)
        end
        itemEspData = {}
        notify("Item ESP disabled", 2)
    end
end, "Highlights items")

createToggle(espPage, "Tool ESP", "toolEsp", function(state)
    if state then
        conn.toolEsp = RunService.Heartbeat:Connect(function()
            for _, tool in pairs(Workspace:GetDescendants()) do
                if tool:IsA("Tool") and not toolEspData[tool] then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        local billboard = Instance.new("BillboardGui")
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 60, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.Parent = handle
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundColor3 = colors.success
                        label.BackgroundTransparency = 0.3
                        label.TextColor3 = colors.white
                        label.Text = tool.Name
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = billboard
                        createCorner(label, 4)
                        
                        toolEspData[tool] = billboard
                    end
                end
            end
        end)
        notify("Tool ESP enabled", 2, "success")
    else
        if conn.toolEsp then conn.toolEsp:Disconnect() end
        for tool, esp in pairs(toolEspData) do
            pcall(function() esp:Destroy() end)
        end
        toolEspData = {}
        notify("Tool ESP disabled", 2)
    end
end, "Shows tool names")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                             PLAYER PAGE                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local playerPage = pages["player"]

createSection(playerPage, "Player List")

-- Player List Container
local playerListContainer = Instance.new("Frame")
playerListContainer.Name = "PlayerList"
playerListContainer.Parent = playerPage
playerListContainer.BackgroundColor3 = colors.card
playerListContainer.BackgroundTransparency = 0.2
playerListContainer.BorderSizePixel = 0
playerListContainer.Size = UDim2.new(1, 0, 0, 180)
playerListContainer.ZIndex = 16

createCorner(playerListContainer, 10)

local playerListScroll = Instance.new("ScrollingFrame")
playerListScroll.Name = "Scroll"
playerListScroll.Parent = playerListContainer
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 8, 0, 8)
playerListScroll.Size = UDim2.new(1, -16, 1, -16)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 4
playerListScroll.ScrollBarImageColor3 = colors.accent
playerListScroll.ZIndex = 17
playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local playerListLayout = createListLayout(playerListScroll, 4)

local function updatePlayerList()
    -- Clear existing
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create new buttons
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local isSelected = cfg.selectedPlayer == player
            
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = player.Name
            playerBtn.Parent = playerListScroll
            playerBtn.BackgroundColor3 = isSelected and colors.accentDark or colors.surfaceLight
            playerBtn.BackgroundTransparency = 0.3
            playerBtn.Size = UDim2.new(1, -4, 0, 36)
            playerBtn.Text = ""
            playerBtn.AutoButtonColor = false
            playerBtn.ZIndex = 18
            
            createCorner(playerBtn, 8)
            
            -- Avatar
            local avatar = Instance.new("ImageLabel")
            avatar.Name = "Avatar"
            avatar.Parent = playerBtn
            avatar.BackgroundColor3 = colors.surface
            avatar.Position = UDim2.new(0, 6, 0.5, -12)
            avatar.Size = UDim2.new(0, 24, 0, 24)
            avatar.ZIndex = 19
            
            createCorner(avatar, 6)
            
            pcall(function()
                avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            
            -- Name
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "Name"
            nameLabel.Parent = playerBtn
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0, 38, 0, 4)
            nameLabel.Size = UDim2.new(1, -90, 0, 14)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = isSelected and colors.accentGlow or colors.textPrimary
            nameLabel.TextSize = 11
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 19
            
            -- Display Name
            local displayLabel = Instance.new("TextLabel")
            displayLabel.Name = "Display"
            displayLabel.Parent = playerBtn
            displayLabel.BackgroundTransparency = 1
            displayLabel.Position = UDim2.new(0, 38, 0, 18)
            displayLabel.Size = UDim2.new(1, -90, 0, 12)
            displayLabel.Font = Enum.Font.Gotham
            displayLabel.Text = "@" .. player.DisplayName
            displayLabel.TextColor3 = colors.textMuted
            displayLabel.TextSize = 9
            displayLabel.TextXAlignment = Enum.TextXAlignment.Left
            displayLabel.ZIndex = 19
            
            -- Selection Icon
            if isSelected then
                local selIcon = Instance.new("TextLabel")
                selIcon.Name = "Selected"
                selIcon.Parent = playerBtn
                selIcon.BackgroundTransparency = 1
                selIcon.Position = UDim2.new(1, -30, 0, 0)
                selIcon.Size = UDim2.new(0, 24, 1, 0)
                selIcon.Font = Enum.Font.GothamBold
                selIcon.Text = "✓"
                selIcon.TextColor3 = colors.success
                selIcon.TextSize = 14
                selIcon.ZIndex = 19
            end
            
            playerBtn.MouseButton1Click:Connect(function()
                cfg.selectedPlayer = cfg.selectedPlayer == player and nil or player
                updatePlayerList()
                
                if cfg.esp then
                    clearAllESP()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= plr then createPlayerESP(p) end
                    end
                end
                
                notify(cfg.selectedPlayer and ("Selected: " .. player.Name) or "Deselected player", 2, cfg.selectedPlayer and "success" or nil)
            end)
            
            playerBtn.MouseEnter:Connect(function()
                if not isSelected then
                    TweenService:Create(playerBtn, tweens.fast, {BackgroundTransparency = 0.1}):Play()
                end
            end)
            
            playerBtn.MouseLeave:Connect(function()
                if not isSelected then
                    TweenService:Create(playerBtn, tweens.fast, {BackgroundTransparency = 0.3}):Play()
                end
            end)
        end
    end
end

updatePlayerList()

createSpacer(playerPage, 4)

createSection(playerPage, "Player Actions")

createButton(playerPage, "Teleport to Player", function()
    if cfg.selectedPlayer then
        teleportToPlayer(cfg.selectedPlayer)
        notify("Teleported to " .. cfg.selectedPlayer.Name, 2, "success")
    else
        notify("Select a player first", 2, "warning")
    end
end, "⤴", "Teleport behind selected player")

createButton(playerPage, "Spectate Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local humanoid = cfg.selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            cam.CameraSubject = humanoid
            notify("Spectating " .. cfg.selectedPlayer.Name, 2, "success")
        end
    else
        notify("Select a player first", 2, "warning")
    end
end, "◉", "Watch selected player")

createButton(playerPage, "Stop Spectating", function()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        cam.CameraSubject = humanoid
        notify("Stopped spectating", 2, "success")
    end
end, "◎", "Return camera to self")

createButton(playerPage, "Copy Username", function()
    if cfg.selectedPlayer and setclipboard then
        setclipboard(cfg.selectedPlayer.Name)
        notify("Username copied!", 2, "success")
    else
        notify("Select a player first", 2, "warning")
    end
end, "⎘", "Copy player's username")

createButton(playerPage, "View Profile", function()
    if cfg.selectedPlayer then
        -- Open profile (if possible)
        notify("Player ID: " .. cfg.selectedPlayer.UserId, 3, "info")
    else
        notify("Select a player first", 2, "warning")
    end
end, "♦", "View player information")

createButton(playerPage, "Refresh List", function()
    updatePlayerList()
    notify("Player list refreshed", 2, "success")
end, "↻", "Update player list")

createSpacer(playerPage, 4)

createSection(playerPage, "Target Settings")

createDropdown(playerPage, "Target Priority", {"Distance", "Health", "Random"}, "targetPriority", function(index, option)
    cfg.targetPriority = option
end)

createToggle(playerPage, "Ignore Teammates", "ignoreTeammates", function(state)
    notify(state and "Ignoring teammates" or "Targeting all players", 2, state and "success" or nil)
end, "Don't target same team")

createToggle(playerPage, "Ignore Friends", "ignoreFriends", function(state)
    notify(state and "Ignoring friends" or "Targeting all players", 2, state and "success" or nil)
end, "Don't target friends")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              WORLD PAGE                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local worldPage = pages["world"]

createSection(worldPage, "Auto Features")

createToggle(worldPage, "Auto Farm", "autoFarm", function(state)
    if state then
        conn.autoFarm = RunService.Heartbeat:Connect(function()
            -- Generic auto farm logic
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("collect") or name:find("pickup") or name:find("claim") or name:find("reward") then
                        pcall(function()
                            remote:FireServer()
                        end)
                    end
                end
            end
        end)
        notify("Auto Farm enabled", 2, "success")
    else
        if conn.autoFarm then conn.autoFarm:Disconnect() end
        notify("Auto Farm disabled", 2)
    end
end, "Automatically farms resources")

createToggle(worldPage, "Auto Collect", "autoCollect", function(state)
    if state then
        conn.autoCollect = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("BasePart") then
                    local name = item.Name:lower()
                    if name:find("coin") or name:find("gem") or name:find("orb") or name:find("collectible") or name:find("pickup") then
                        local distance = (item.Position - hrp.Position).Magnitude
                        if distance < 50 then
                            item.CFrame = hrp.CFrame
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
end, "Collects nearby items")

createToggle(worldPage, "Auto Quest", "autoQuest", function(state)
    if state then
        conn.autoQuest = RunService.Heartbeat:Connect(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:find("quest") or name:find("mission") or name:find("task") then
                        pcall(function()
                            remote:FireServer("accept")
                            remote:FireServer("complete")
                            remote:FireServer("claim")
                        end)
                    end
                end
            end
        end)
        notify("Auto Quest enabled", 2, "success")
    else
        if conn.autoQuest then conn.autoQuest:Disconnect() end
        notify("Auto Quest disabled", 2)
    end
end, "Auto accepts/completes quests")

createSpacer(worldPage, 4)

createSection(worldPage, "World Interaction")

createButton(worldPage, "Bring All Items", function()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local count = 0
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Tool") or (item:IsA("BasePart") and item.Name:lower():find("item")) then
                pcall(function()
                    item.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                    count = count + 1
                end)
            end
        end
        notify(count .. " items brought to you", 2, "success")
    end
end, "◆", "Teleport all items to you")

createButton(worldPage, "Remove All Tools", function()
    local count = 0
    for _, tool in pairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") then
            pcall(function()
                tool:Destroy()
                count = count + 1
            end)
        end
    end
    notify(count .. " tools removed", 2, "success")
end, "✕", "Delete all tools from workspace")

createButton(worldPage, "Kill All NPCs", function()
    local count = 0
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Humanoid") and not Players:GetPlayerFromCharacter(npc.Parent) then
            pcall(function()
                npc.Health = 0
                count = count + 1
            end)
        end
    end
    notify(count .. " NPCs killed", 2, "success")
end, "⚔", "Kill all NPCs in game")

createButton(worldPage, "Delete Invisible Walls", function()
    local count = 0
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Transparency >= 0.9 and part.CanCollide then
                local name = part.Name:lower()
                if name:find("wall") or name:find("barrier") or name:find("invisible") or name:find("collide") then
                    pcall(function()
                        part:Destroy()
                        count = count + 1
                    end)
                end
            end
        end
    end
    notify(count .. " invisible walls removed", 2, "success")
end, "▢", "Remove invisible barriers")

createSpacer(worldPage, 4)

createSection(worldPage, "Server Info")

createToggle(worldPage, "Show Server Info", "serverInfo", function(state)
    -- Will be displayed in watermark
end, "Display server information")

local serverInfoCard = Instance.new("Frame")
serverInfoCard.Name = "ServerInfo"
serverInfoCard.Parent = worldPage
serverInfoCard.BackgroundColor3 = colors.card
serverInfoCard.BackgroundTransparency = 0.2
serverInfoCard.BorderSizePixel = 0
serverInfoCard.Size = UDim2.new(1, 0, 0, 100)
serverInfoCard.ZIndex = 16

createCorner(serverInfoCard, 10)

local serverInfoLayout = createListLayout(serverInfoCard, 2)
serverInfoLayout.Padding = UDim.new(0, 6)
createPadding(serverInfoCard, 10)

local function createServerInfoLine(parent, label, value)
    local line = Instance.new("Frame")
    line.BackgroundTransparency = 1
    line.Size = UDim2.new(1, 0, 0, 16)
    line.Parent = parent
    line.ZIndex = 17
    
    local labelText = Instance.new("TextLabel")
    labelText.BackgroundTransparency = 1
    labelText.Size = UDim2.new(0.4, 0, 1, 0)
    labelText.Font = Enum.Font.GothamMedium
    labelText.Text = label
    labelText.TextColor3 = colors.textMuted
    labelText.TextSize = 10
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = line
    labelText.ZIndex = 18
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "Value"
    valueText.BackgroundTransparency = 1
    valueText.Position = UDim2.new(0.4, 0, 0, 0)
    valueText.Size = UDim2.new(0.6, 0, 1, 0)
    valueText.Font = Enum.Font.GothamBold
    valueText.Text = value
    valueText.TextColor3 = colors.textPrimary
    valueText.TextSize = 10
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = line
    valueText.ZIndex = 18
    
    return valueText
end

local serverIdLine = createServerInfoLine(serverInfoCard, "Server ID:", string.sub(game.JobId, 1, 8) .. "...")
local playersLine = createServerInfoLine(serverInfoCard, "Players:", #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
local placeIdLine = createServerInfoLine(serverInfoCard, "Place ID:", tostring(game.PlaceId))
local pingLine = createServerInfoLine(serverInfoCard, "Your Ping:", "0ms")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              MISC PAGE                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local miscPage = pages["misc"]

createSection(miscPage, "Utility")

createToggle(miscPage, "Anti AFK", "antiAfk", function(state)
    if state then
        setupAntiAFK()
        notify("Anti AFK enabled", 2, "success")
    else
        notify("Anti AFK disabled (requires rejoin)", 2, "warning")
    end
end, "Prevents being kicked for AFK")

createToggle(miscPage, "Auto Clicker", "autoClicker", function(state)
    if state then
        conn.autoClicker = RunService.Heartbeat:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                for i = 1, math.floor(cfg.autoClickerCPS / 60) do
                    mouse1click()
                end
            end
        end)
        notify("Auto Clicker enabled", 2, "success")
    else
        if conn.autoClicker then conn.autoClicker:Disconnect() end
        notify("Auto Clicker disabled", 2)
    end
end, "Automatically clicks mouse")

createSlider(miscPage, "Clicks Per Second", 1, 50, "autoClickerCPS", function(value)
end, " CPS", 1, "Auto clicker speed")

createSpacer(miscPage, 4)

createSection(miscPage, "Chat")

createToggle(miscPage, "Chat Spy", "chatSpy", function(state)
    if state then
        conn.chatSpy = Players.PlayerAdded:Connect(function(player)
            player.Chatted:Connect(function(message)
                if player ~= plr then
                    table.insert(chatLogs, {
                        player = player.Name,
                        message = message,
                        time = os.date("%H:%M:%S")
                    })
                    
                    if #chatLogs > 100 then
                        table.remove(chatLogs, 1)
                    end
                    
                    -- Notify for whispers
                    if cfg.chatSpyWhisper and message:sub(1, 3) == "/w " then
                        notify("[Whisper] " .. player.Name .. ": " .. message, 4, "info")
                    end
                end
            end)
        end)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                player.Chatted:Connect(function(message)
                    table.insert(chatLogs, {
                        player = player.Name,
                        message = message,
                        time = os.date("%H:%M:%S")
                    })
                    
                    if cfg.chatSpyWhisper and message:sub(1, 3) == "/w " then
                        notify("[Whisper] " .. player.Name .. ": " .. message, 4, "info")
                    end
                end)
            end
        end
        
        notify("Chat Spy enabled", 2, "success")
    else
        if conn.chatSpy then conn.chatSpy:Disconnect() end
        notify("Chat Spy disabled", 2)
    end
end, "See all chat messages")

createToggle(miscPage, "Spy Team Chat", "chatSpyTeam", function(state)
end, "Include team chat")

createToggle(miscPage, "Spy Whispers", "chatSpyWhisper", function(state)
end, "Show whisper notifications")

createSpacer(miscPage, 4)

createSection(miscPage, "Interface")

createToggle(miscPage, "Show Watermark", "watermark", function(state)
end, "Display script watermark")

createToggle(miscPage, "Show FPS", "fpsCounter", function(state)
end, "Display FPS counter")

createToggle(miscPage, "Show Ping", "pingDisplay", function(state)
end, "Display network ping")

createToggle(miscPage, "Show Coordinates", "coordsDisplay", function(state)
end, "Display player position")

createSlider(miscPage, "UI Transparency", 0, 0.5, "uiTransparency", function(value)
    main.BackgroundTransparency = value
end, "", 0.05, "Menu background opacity")

createSlider(miscPage, "Notification Duration", 1, 10, "notificationDuration", function(value)
end, "s", 0.5, "How long notifications show")

createSpacer(miscPage, 4)

createSection(miscPage, "Keybinds")

createKeybind(miscPage, "Toggle Menu", "toggleKey", function(keyCode)
    notify("Menu toggle key: " .. keyCode.Name, 2, "success")
end)

createKeybind(miscPage, "Speed Boost Key", "speedKey", function(keyCode)
    notify("Speed boost key: " .. keyCode.Name, 2, "success")
end)

createSpacer(miscPage, 4)

createSection(miscPage, "Script")

createButton(miscPage, "Save Settings", function()
    if saveSettings() then
        notify("Settings saved!", 2, "success")
    else
        notify("Failed to save settings", 2, "error")
    end
end, "◆", "Save current configuration")

createButton(miscPage, "Reset Settings", function()
    -- Reset to defaults
    for key, _ in pairs(cfg) do
        if type(cfg[key]) == "boolean" then
            cfg[key] = false
        end
    end
    cfg.speed = 16
    cfg.aimfov = 150
    cfg.fov = 70
    cfg.auraRange = 15
    cfg.hitChance = 100
    saveSettings()
    notify("Settings reset to defaults", 2, "success")
end, "↺", "Reset all settings")

createButton(miscPage, "Unload Script", function()
    notify("Unloading script...", 2, "warning")
    task.wait(0.5)
    
    -- Cleanup
    clearAllESP()
    fovCircle:Remove()
    auraCircle:Remove()
    
    for _, c in pairs(conn) do
        if c then pcall(function() c:Disconnect() end) end
    end
    
    disableGodMode()
    disableFly()
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = defaultSpeed
        humanoid.JumpPower = defaultJump
    end
    
    Workspace.Gravity = defaultGravity
    cam.FieldOfView = defaultFOV
    
    gui:Destroy()
end, "✕", "Completely remove script")

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                            WATERMARK                                           ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local watermark = Instance.new("Frame")
watermark.Name = "Watermark"
watermark.Parent = gui
watermark.BackgroundColor3 = colors.surface
watermark.BackgroundTransparency = 0.1
watermark.Position = UDim2.new(0, 20, 0, 20)
watermark.Size = UDim2.new(0, 200, 0, 24)
watermark.ZIndex = 500

createCorner(watermark, 6)
createStroke(watermark, colors.border, 1, 0.5)

local watermarkText = Instance.new("TextLabel")
watermarkText.Name = "Text"
watermarkText.Parent = watermark
watermarkText.BackgroundTransparency = 1
watermarkText.Position = UDim2.new(0, 10, 0, 0)
watermarkText.Size = UDim2.new(1, -20, 1, 0)
watermarkText.Font = Enum.Font.GothamBold
watermarkText.Text = SCRIPT_NAME .. " | 60 FPS | 0ms"
watermarkText.TextColor3 = colors.textPrimary
watermarkText.TextSize = 11
watermarkText.TextXAlignment = Enum.TextXAlignment.Left
watermarkText.ZIndex = 501

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                         MENU ANIMATIONS                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

local function openMenu()
    if menuOpen then return end
    menuOpen = true
    main.Visible = true
    main.BackgroundTransparency = 1
    main.Size = UDim2.new(0, 0, 0, 0)
    mainStroke.Transparency = 1
    mainShadow.ImageTransparency = 1
    
    TweenService:Create(main, tweens.bounce, {
        Size = UDim2.new(0, WINDOW_WIDTH, 0, WINDOW_HEIGHT),
        BackgroundTransparency = cfg.uiTransparency
    }):Play()
    
    TweenService:Create(mainStroke, tweens.medium, {Transparency = 0.3}):Play()
    TweenService:Create(mainShadow, tweens.slow, {ImageTransparency = 0.7}):Play()
end

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    
    TweenService:Create(main, tweens.medium, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(mainStroke, tweens.fast, {Transparency = 1}):Play()
    TweenService:Create(mainShadow, tweens.fast, {ImageTransparency = 1}):Play()
    
    task.delay(0.3, function()
        if not menuOpen then
            main.Visible = false
        end
    end)
    
    task.spawn(saveSettings)
end

-- Toggle Button Click
toggleBtn.MouseButton1Click:Connect(function()
    if tick() - toggleLastClick < 0.25 then
        if menuOpen then
            closeMenu()
        else
            openMenu()
        end
    end
end)

-- Close Button
closeBtn.MouseButton1Click:Connect(closeMenu)
minBtn.MouseButton1Click:Connect(closeMenu)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           KEYBIND HANDLERS                                     ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Toggle menu
    if input.KeyCode.Name == cfg.toggleKey then
        if menuOpen then
            closeMenu()
        else
            openMenu()
        end
    end
    
    -- Fly toggle
    if input.KeyCode.Name == cfg.flyKey and cfg.fly then
        if flyActive then
            disableFly()
            notify("Fly disabled", 2)
        else
            enableFly()
            notify("Fly enabled", 2, "success")
        end
    end
    
    -- Noclip toggle
    if input.KeyCode.Name == cfg.noclipKey then
        cfg.noclip = not cfg.noclip
        if toggleRefs.noclip then
            toggleRefs.noclip.setState(cfg.noclip)
        end
    end
    
    -- Speed boost (hold)
    if input.KeyCode.Name == cfg.speedKey and cfg.speedHack then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = cfg.speed * 2
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    -- Speed boost release
    if input.KeyCode.Name == cfg.speedKey and cfg.speedHack then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = cfg.speed
        end
    end
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              MAIN LOOP                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

conn.mainLoop = RunService.RenderStepped:Connect(function()
    -- FPS Counter
    frameCount = frameCount + 1
    if tick() - lastFrameTime >= 1 then
        currentFPS = frameCount
        frameCount = 0
        lastFrameTime = tick()
    end
    
    -- Ping (approximate)
    pcall(function()
        currentPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    
    -- Update watermark
    if cfg.watermark then
        watermark.Visible = true
        local watermarkParts = {SCRIPT_NAME}
        
        if cfg.fpsCounter then
            table.insert(watermarkParts, currentFPS .. " FPS")
        end
        
        if cfg.pingDisplay then
            table.insert(watermarkParts, math.floor(currentPing) .. "ms")
        end
        
        if cfg.coordsDisplay then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                table.insert(watermarkParts, string.format("%.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z))
            end
        end
        
        watermarkText.Text = table.concat(watermarkParts, " | ")
        watermark.Size = UDim2.new(0, watermarkText.TextBounds.X + 20, 0, 24)
    else
        watermark.Visible = false
    end
    
    -- Speed hack
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and cfg.speedHack then
        humanoid.WalkSpeed = cfg.speed
    end
    
    -- FOV circle
    if cfg.showfov then
        fovCircle.Visible = true
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = cfg.aimfov
    else
        fovCircle.Visible = false
    end
    
    -- Aura circle
    if cfg.showAura then
        auraCircle.Visible = true
        auraCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        auraCircle.Radius = cfg.auraRange * 4
    else
        auraCircle.Visible = false
    end
    
    -- ESP Update
    if cfg.esp then
        updateAllESP()
    end
    
    -- Session time
    cfg.sessionTime = os.time() - sessionStartTime
    sessionTime.Text = formatTime(cfg.sessionTime)
    
    -- Update info cards
    fpsCard.updateValue(currentFPS)
    pingCard.updateValue(math.floor(currentPing) .. "ms")
    
    -- Server info
    playersLine.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    pingLine.Text = math.floor(currentPing) .. "ms"
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                          PLAYER EVENTS                                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    
    if cfg.esp then
        createPlayerESP(player)
    end
    
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if espData[player] then
        pcall(function()
            if espData[player].obj then
                if typeof(espData[player].obj) == "Instance" then
                    espData[player].obj:Destroy()
                end
            end
            if espData[player].tracer then
                espData[player].tracer:Remove()
            end
        end)
        espData[player] = nil
    end
    
    if cfg.selectedPlayer == player then
        cfg.selectedPlayer = nil
    end
    
    updatePlayerList()
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                       CHARACTER RESPAWN HANDLER                                ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    task.wait(1)
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        defaultSpeed = humanoid.WalkSpeed
        defaultJump = humanoid.JumpPower
    end
    
    -- Re-apply active features
    for key, ref in pairs(toggleRefs) do
        if cfg[key] and ref.apply then
            pcall(function()
                ref.apply()
            end)
        end
    end
    
    -- Re-enable god mode if active
    if cfg.god then
        immortal = false
        enableGodMode()
    end
    
    -- Re-enable fly if active
    if cfg.fly then
        flyActive = false
        enableFly()
    end
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                           INITIALIZATION                                       ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

task.spawn(function()
    task.wait(0.5)
    
    -- Apply saved visual settings
    if cfg.fov ~= defaultFOV then
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
        Workspace.Gravity = cfg.gravityAmount
    end
    
    -- Count active features
    local activeCount = 0
    for key, value in pairs(cfg) do
        if value == true then
            activeCount = activeCount + 1
        end
    end
    
    -- Startup notifications
    notify(SCRIPT_NAME .. " v" .. SCRIPT_VERSION .. " loaded!", 4, "success")
    
    if activeCount > 0 then
        task.wait(0.5)
        notify(activeCount .. " saved settings restored", 3, "info")
    end
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              CLEANUP                                           ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

gui.Destroying:Connect(function()
    -- Cleanup ESP
    clearAllESP()
    
    -- Cleanup NPC ESP
    for _, esp in pairs(npcEspData) do
        pcall(function() esp:Destroy() end)
    end
    
    -- Cleanup Item ESP
    for _, esp in pairs(itemEspData) do
        pcall(function() esp:Destroy() end)
    end
    
    -- Cleanup Tool ESP
    for _, esp in pairs(toolEspData) do
        pcall(function() esp:Destroy() end)
    end
    
    -- Cleanup Drawing objects
    pcall(function() fovCircle:Remove() end)
    pcall(function() auraCircle:Remove() end)
    
    -- Disconnect all connections
    for name, connection in pairs(conn) do
        if connection then
            pcall(function() connection:Disconnect() end)
        end
    end
    
    -- Disable fly
    disableFly()
    
    -- Disable god mode
    disableGodMode()
    
    -- Restore defaults
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = defaultSpeed
        humanoid.JumpPower = defaultJump
    end
    
    Workspace.Gravity = defaultGravity
    cam.FieldOfView = defaultFOV
    
    -- Restore lighting
    Lighting.FogEnd = 1000
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
end)

-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                         SCRIPT COMPLETE                                        ║
-- ║                    IKAXU PREMIUM V4 - VIOLENCE DISTRICT                        ║
-- ║                        Professional 16:9 Layout                                ║
-- ║                       Modern Minimalist Design                                 ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

print([[
╔═══════════════════════════════════════════════════════════╗
║           IKAXU PREMIUM V4 - SUCCESSFULLY LOADED          ║
║                                                           ║
║  Features:                                                ║
║  • Professional 16:9 Layout                               ║
║  • Modern Minimalist Design                               ║
║  • Smooth Animations                                      ║
║  • Auto Save Settings                                     ║
║  • 70+ Premium Features                                   ║
║                                                           ║
║  Press RightShift or click the toggle to open menu        ║
╚═══════════════════════════════════════════════════════════╝
]])
            