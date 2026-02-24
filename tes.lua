--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║          VIOLENCE DISTRICT v4 — PREMIUM EDITION              ║
    ║              Professional 16:9 Minimalist GUI                ║
    ╚══════════════════════════════════════════════════════════════╝
]]

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

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = Workspace.CurrentCamera
local mouse = plr:GetMouse()

-- ══════════════════════════════════════════════════════════════
-- CONFIGURATION & SAVE SYSTEM
-- ══════════════════════════════════════════════════════════════

local SAVE_FILE = "vd4_premium_config.json"

local cfg = {
    -- Combat
    god = false,
    aim = false,
    aimfov = 120,
    showfov = false,
    silentAim = false,
    killaura = false,
    auraRange = 15,
    showAura = false,
    hitChance = 100,
    autoPunch = false,
    punchSpeed = 5,
    
    -- Movement
    speedHack = false,
    speed = 16,
    noclip = false,
    fly = false,
    flySpeed = 50,
    infiniteJump = false,
    jumpPower = 50,
    
    -- Visual
    esp = false,
    espMode = 1,
    espRgb = false,
    fog = false,
    bright = false,
    fov = 70,
    invisible = false,
    noParticles = false,
    xray = false,
    
    -- Character
    noRagdoll = false,
    infiniteStamina = false,
    antiVoid = false,
    lowGravity = false,
    autoHeal = false,
    healThreshold = 30,
    
    -- Sky
    skyMode = "default",
    
    -- Utility
    antiAfk = false,
    clickTp = false,
    autoCollect = false,
    collectRange = 50,
    noClipCam = false,
    freeCam = false,
    freeCamSpeed = 1,
    
    -- Player
    selectedPlayer = nil,
    
    -- Settings
    keybindMenu = "RightShift",
    notifications = true,
    sounds = true,
    autoSave = true
}

local function deepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local defaultCfg = deepCopy(cfg)

local function saveSettings()
    if not cfg.autoSave then return end
    local data = {cfg = cfg}
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
    if success and data and data.cfg then
        for k, v in pairs(data.cfg) do
            if cfg[k] ~= nil and type(v) ~= "userdata" then
                cfg[k] = v
            end
        end
    end
end

loadSettings()

-- ══════════════════════════════════════════════════════════════
-- UTILITIES & CONNECTIONS
-- ══════════════════════════════════════════════════════════════

local conn = {}
local espData = {}
local toggleRefs = {}
local immortal = false
local defaultSpeed = 16
local defaultGravity = 196.2
local defaultJumpPower = 50
local flying = false
local bodyGyro, bodyVelocity

-- Store original lighting
local originalLighting = {}
pcall(function()
    originalLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient
    }
end)

-- ══════════════════════════════════════════════════════════════
-- SKY SYSTEM
-- ══════════════════════════════════════════════════════════════

local SkySystem = {
    currentSky = nil,
    currentAtmosphere = nil,
    effects = {}
}

function SkySystem:cleanup()
    for _, effect in pairs(self.effects) do
        pcall(function() effect:Destroy() end)
    end
    self.effects = {}
    
    if self.currentSky then pcall(function() self.currentSky:Destroy() end) end
    if self.currentAtmosphere then pcall(function() self.currentAtmosphere:Destroy() end) end
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child.Name:find("VD4_") then
            pcall(function() child:Destroy() end)
        end
    end
end

function SkySystem:restore()
    self:cleanup()
    for prop, value in pairs(originalLighting) do
        pcall(function() Lighting[prop] = value end)
    end
    cfg.skyMode = "default"
end

function SkySystem:applyGalaxy()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then child:Destroy() end
    end
    
    local sky = Instance.new("Sky")
    sky.Name = "VD4_Sky"
    sky.SkyboxBk = "rbxassetid://6444884337"
    sky.SkyboxDn = "rbxassetid://6444884785"
    sky.SkyboxFt = "rbxassetid://6444884337"
    sky.SkyboxLf = "rbxassetid://6444884337"
    sky.SkyboxRt = "rbxassetid://6444884337"
    sky.SkyboxUp = "rbxassetid://6444884337"
    sky.StarCount = 5000
    sky.Parent = Lighting
    self.currentSky = sky
    
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD4_Atmo"
    atmo.Density = 0.4
    atmo.Color = Color3.fromRGB(20, 15, 40)
    atmo.Decay = Color3.fromRGB(60, 40, 80)
    atmo.Glare = 0.5
    atmo.Haze = 2
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD4_CC"
    cc.Brightness = -0.05
    cc.Contrast = 0.15
    cc.Saturation = 0.2
    cc.TintColor = Color3.fromRGB(200, 180, 255)
    cc.Parent = Lighting
    table.insert(self.effects, cc)
    
    Lighting.Brightness = 0.5
    Lighting.ClockTime = 0
    Lighting.Ambient = Color3.fromRGB(30, 25, 50)
    
    cfg.skyMode = "galaxy"
end

function SkySystem:applySunset()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then child:Destroy() end
    end
    
    local sky = Instance.new("Sky")
    sky.Name = "VD4_Sky"
    sky.SkyboxBk = "rbxassetid://1012890"
    sky.SkyboxDn = "rbxassetid://1012891"
    sky.SkyboxFt = "rbxassetid://1012887"
    sky.SkyboxLf = "rbxassetid://1012889"
    sky.SkyboxRt = "rbxassetid://1012888"
    sky.SkyboxUp = "rbxassetid://1012890"
    sky.StarCount = 1000
    sky.Parent = Lighting
    self.currentSky = sky
    
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD4_Atmo"
    atmo.Density = 0.35
    atmo.Color = Color3.fromRGB(255, 180, 120)
    atmo.Decay = Color3.fromRGB(255, 100, 80)
    atmo.Glare = 1.5
    atmo.Haze = 1.5
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD4_CC"
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = 0.3
    cc.TintColor = Color3.fromRGB(255, 220, 200)
    cc.Parent = Lighting
    table.insert(self.effects, cc)
    
    local rays = Instance.new("SunRaysEffect")
    rays.Name = "VD4_Rays"
    rays.Intensity = 0.15
    rays.Spread = 0.8
    rays.Parent = Lighting
    table.insert(self.effects, rays)
    
    Lighting.Brightness = 2.5
    Lighting.ClockTime = 18.5
    Lighting.Ambient = Color3.fromRGB(180, 120, 100)
    
    cfg.skyMode = "sunset"
end

function SkySystem:applyMorning()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then child:Destroy() end
    end
    
    local sky = Instance.new("Sky")
    sky.Name = "VD4_Sky"
    sky.SkyboxBk = "rbxassetid://152670934"
    sky.SkyboxDn = "rbxassetid://152670948"
    sky.SkyboxFt = "rbxassetid://152670899"
    sky.SkyboxLf = "rbxassetid://152670919"
    sky.SkyboxRt = "rbxassetid://152670913"
    sky.SkyboxUp = "rbxassetid://152670943"
    sky.StarCount = 0
    sky.Parent = Lighting
    self.currentSky = sky
    
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD4_Atmo"
    atmo.Density = 0.3
    atmo.Color = Color3.fromRGB(200, 220, 255)
    atmo.Decay = Color3.fromRGB(150, 180, 220)
    atmo.Glare = 0.8
    atmo.Haze = 1
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD4_CC"
    cc.Brightness = 0.08
    cc.Contrast = 0.05
    cc.Saturation = 0.15
    cc.TintColor = Color3.fromRGB(255, 250, 240)
    cc.Parent = Lighting
    table.insert(self.effects, cc)
    
    Lighting.Brightness = 3
    Lighting.ClockTime = 7
    Lighting.Ambient = Color3.fromRGB(150, 170, 200)
    Lighting.GlobalShadows = true
    
    cfg.skyMode = "morning"
end

function SkySystem:applyNight()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then child:Destroy() end
    end
    
    local sky = Instance.new("Sky")
    sky.Name = "VD4_Sky"
    sky.SkyboxBk = "rbxassetid://12064107"
    sky.SkyboxDn = "rbxassetid://12064152"
    sky.SkyboxFt = "rbxassetid://12064121"
    sky.SkyboxLf = "rbxassetid://12064115"
    sky.SkyboxRt = "rbxassetid://12064131"
    sky.SkyboxUp = "rbxassetid://12064141"
    sky.StarCount = 3000
    sky.MoonAngularSize = 12
    sky.Parent = Lighting
    self.currentSky = sky
    
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD4_Atmo"
    atmo.Density = 0.35
    atmo.Color = Color3.fromRGB(30, 40, 70)
    atmo.Decay = Color3.fromRGB(20, 30, 60)
    atmo.Glare = 0.2
    atmo.Haze = 2.5
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD4_CC"
    cc.Brightness = -0.1
    cc.Contrast = 0.2
    cc.Saturation = -0.1
    cc.TintColor = Color3.fromRGB(180, 190, 220)
    cc.Parent = Lighting
    table.insert(self.effects, cc)
    
    Lighting.Brightness = 0.3
    Lighting.ClockTime = 0
    Lighting.Ambient = Color3.fromRGB(30, 35, 50)
    
    cfg.skyMode = "night"
end

-- ══════════════════════════════════════════════════════════════
-- PROFESSIONAL COLOR PALETTE (16:9 Optimized)
-- ══════════════════════════════════════════════════════════════

local theme = {
    -- Background layers
    bg = Color3.fromRGB(18, 18, 22),
    bgAlt = Color3.fromRGB(22, 22, 27),
    surface = Color3.fromRGB(28, 28, 34),
    surfaceAlt = Color3.fromRGB(34, 34, 42),
    card = Color3.fromRGB(38, 38, 46),
    cardHover = Color3.fromRGB(45, 45, 55),
    
    -- Borders
    border = Color3.fromRGB(55, 55, 65),
    borderLight = Color3.fromRGB(70, 70, 82),
    borderActive = Color3.fromRGB(90, 110, 140),
    
    -- Text
    textPrimary = Color3.fromRGB(245, 245, 248),
    textSecondary = Color3.fromRGB(180, 180, 192),
    textMuted = Color3.fromRGB(120, 120, 135),
    textDim = Color3.fromRGB(80, 80, 95),
    
    -- Accent (soft blue)
    accent = Color3.fromRGB(100, 140, 200),
    accentHover = Color3.fromRGB(120, 160, 220),
    accentMuted = Color3.fromRGB(70, 100, 150),
    accentGlow = Color3.fromRGB(140, 180, 240),
    
    -- States
    success = Color3.fromRGB(75, 160, 110),
    successGlow = Color3.fromRGB(95, 190, 130),
    error = Color3.fromRGB(200, 85, 95),
    errorGlow = Color3.fromRGB(230, 100, 110),
    warning = Color3.fromRGB(220, 180, 80),
    warningGlow = Color3.fromRGB(240, 200, 100),
    
    -- Toggle
    toggleOff = Color3.fromRGB(50, 50, 60),
    toggleOn = Color3.fromRGB(70, 130, 105),
    knobOff = Color3.fromRGB(140, 140, 155),
    knobOn = Color3.fromRGB(200, 255, 220),
    
    -- Slider
    sliderTrack = Color3.fromRGB(45, 45, 55),
    sliderFill = Color3.fromRGB(100, 140, 200),
    sliderKnob = Color3.fromRGB(255, 255, 255),
    
    -- Shadow
    shadow = Color3.fromRGB(0, 0, 0)
}

-- ══════════════════════════════════════════════════════════════
-- TWEEN PRESETS (Smooth Animations)
-- ══════════════════════════════════════════════════════════════

local anim = {
    instant = TweenInfo.new(0.05, Enum.EasingStyle.Linear),
    fast = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    normal = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    spring = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0),
    menuOpen = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    menuClose = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
}

-- ══════════════════════════════════════════════════════════════
-- GUI INITIALIZATION
-- ══════════════════════════════════════════════════════════════

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

local gui = Instance.new("ScreenGui")
gui.Name = "VD4_" .. math.random(100000, 999999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- ══════════════════════════════════════════════════════════════
-- 16:9 MAIN WINDOW
-- ══════════════════════════════════════════════════════════════

-- Calculate 16:9 proportional size
local viewportSize = cam.ViewportSize
local guiWidth = math.min(680, viewportSize.X * 0.45)
local guiHeight = guiWidth * (9/16) + 60 -- Add extra for header
guiHeight = math.min(guiHeight, viewportSize.Y * 0.75)

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = theme.bg
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
main.BackgroundTransparency = 1

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = theme.border
mainStroke.Thickness = 1
mainStroke.Transparency = 1

-- Shadow
local shadowHolder = Instance.new("Frame", main)
shadowHolder.Name = "ShadowHolder"
shadowHolder.BackgroundTransparency = 1
shadowHolder.Size = UDim2.new(1, 100, 1, 100)
shadowHolder.Position = UDim2.new(0, -50, 0, -50)
shadowHolder.ZIndex = 0

local shadow = Instance.new("ImageLabel", shadowHolder)
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = theme.shadow
shadow.ImageTransparency = 1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)

-- ══════════════════════════════════════════════════════════════
-- HEADER (Top Bar)
-- ══════════════════════════════════════════════════════════════

local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = theme.bgAlt
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 52)
header.ZIndex = 20

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 16)

-- Fix bottom corners
local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = theme.bgAlt
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -14)
headerFix.Size = UDim2.new(1, 0, 0, 14)
headerFix.ZIndex = 20

-- Header divider
local headerDivider = Instance.new("Frame", header)
headerDivider.BackgroundColor3 = theme.border
headerDivider.BackgroundTransparency = 0.5
headerDivider.BorderSizePixel = 0
headerDivider.Position = UDim2.new(0, 0, 1, -1)
headerDivider.Size = UDim2.new(1, 0, 0, 1)
headerDivider.ZIndex = 21

-- Logo area
local logoArea = Instance.new("Frame", header)
logoArea.BackgroundTransparency = 1
logoArea.Position = UDim2.new(0, 20, 0, 0)
logoArea.Size = UDim2.new(0, 250, 1, 0)
logoArea.ZIndex = 21

local logoIcon = Instance.new("TextLabel", logoArea)
logoIcon.BackgroundTransparency = 1
logoIcon.Position = UDim2.new(0, 0, 0.5, -12)
logoIcon.Size = UDim2.new(0, 24, 0, 24)
logoIcon.Font = Enum.Font.GothamBold
logoIcon.Text = "◈"
logoIcon.TextColor3 = theme.accent
logoIcon.TextSize = 20
logoIcon.ZIndex = 22

local logoTitle = Instance.new("TextLabel", logoArea)
logoTitle.BackgroundTransparency = 1
logoTitle.Position = UDim2.new(0, 32, 0, 10)
logoTitle.Size = UDim2.new(0, 180, 0, 18)
logoTitle.Font = Enum.Font.GothamBold
logoTitle.Text = "Violence District"
logoTitle.TextColor3 = theme.textPrimary
logoTitle.TextSize = 15
logoTitle.TextXAlignment = Enum.TextXAlignment.Left
logoTitle.ZIndex = 22

local logoSubtitle = Instance.new("TextLabel", logoArea)
logoSubtitle.BackgroundTransparency = 1
logoSubtitle.Position = UDim2.new(0, 32, 0, 28)
logoSubtitle.Size = UDim2.new(0, 180, 0, 14)
logoSubtitle.Font = Enum.Font.Gotham
logoSubtitle.Text = "Premium Edition v4"
logoSubtitle.TextColor3 = theme.textMuted
logoSubtitle.TextSize = 10
logoSubtitle.TextXAlignment = Enum.TextXAlignment.Left
logoSubtitle.ZIndex = 22

-- Version badge
local versionBadge = Instance.new("Frame", logoArea)
versionBadge.BackgroundColor3 = theme.accentMuted
versionBadge.BackgroundTransparency = 0.7
versionBadge.Position = UDim2.new(0, 145, 0, 12)
versionBadge.Size = UDim2.new(0, 32, 0, 16)
versionBadge.ZIndex = 22
Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0, 4)

local versionText = Instance.new("TextLabel", versionBadge)
versionText.BackgroundTransparency = 1
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.Font = Enum.Font.GothamBold
versionText.Text = "v4.0"
versionText.TextColor3 = theme.accent
versionText.TextSize = 9
versionText.ZIndex = 23

-- Window controls
local controlsArea = Instance.new("Frame", header)
controlsArea.BackgroundTransparency = 1
controlsArea.Position = UDim2.new(1, -90, 0, 0)
controlsArea.Size = UDim2.new(0, 80, 1, 0)
controlsArea.ZIndex = 21

local minimizeBtn = Instance.new("TextButton", controlsArea)
minimizeBtn.BackgroundColor3 = theme.surface
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Position = UDim2.new(0, 0, 0.5, -14)
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Text = ""
minimizeBtn.AutoButtonColor = false
minimizeBtn.ZIndex = 22
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

local minimizeIcon = Instance.new("TextLabel", minimizeBtn)
minimizeIcon.BackgroundTransparency = 1
minimizeIcon.Size = UDim2.new(1, 0, 1, 0)
minimizeIcon.Font = Enum.Font.GothamBold
minimizeIcon.Text = "—"
minimizeIcon.TextColor3 = theme.textMuted
minimizeIcon.TextSize = 14
minimizeIcon.ZIndex = 23

local closeBtn = Instance.new("TextButton", controlsArea)
closeBtn.BackgroundColor3 = theme.surface
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0, 36, 0.5, -14)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Text = ""
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 22
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local closeIcon = Instance.new("TextLabel", closeBtn)
closeIcon.BackgroundTransparency = 1
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.Font = Enum.Font.GothamBold
closeIcon.Text = "×"
closeIcon.TextColor3 = theme.textMuted
closeIcon.TextSize = 18
closeIcon.ZIndex = 23

-- Button hover effects
minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, anim.fast, {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(minimizeIcon, anim.fast, {TextColor3 = theme.warning}):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, anim.fast, {BackgroundTransparency = 1}):Play()
    TweenService:Create(minimizeIcon, anim.fast, {TextColor3 = theme.textMuted}):Play()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, anim.fast, {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(closeIcon, anim.fast, {TextColor3 = theme.error}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, anim.fast, {BackgroundTransparency = 1}):Play()
    TweenService:Create(closeIcon, anim.fast, {TextColor3 = theme.textMuted}):Play()
end)

-- ══════════════════════════════════════════════════════════════
-- SIDEBAR (Left Navigation)
-- ══════════════════════════════════════════════════════════════

local sidebarWidth = 70

local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = theme.bgAlt
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 52)
sidebar.Size = UDim2.new(0, sidebarWidth, 1, -52)
sidebar.ZIndex = 15

-- Sidebar divider
local sidebarDivider = Instance.new("Frame", sidebar)
sidebarDivider.BackgroundColor3 = theme.border
sidebarDivider.BackgroundTransparency = 0.5
sidebarDivider.BorderSizePixel = 0
sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.ZIndex = 16

-- Tab container
local tabContainer = Instance.new("Frame", sidebar)
tabContainer.BackgroundTransparency = 1
tabContainer.Position = UDim2.new(0, 0, 0, 12)
tabContainer.Size = UDim2.new(1, 0, 1, -24)
tabContainer.ZIndex = 16

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.Padding = UDim.new(0, 6)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ══════════════════════════════════════════════════════════════
-- CONTENT AREA (Right Side)
-- ══════════════════════════════════════════════════════════════

local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, sidebarWidth + 12, 0, 60)
content.Size = UDim2.new(1, -sidebarWidth - 24, 1, -72)
content.ZIndex = 12

-- ══════════════════════════════════════════════════════════════
-- TOGGLE BUTTON (Mini)
-- ══════════════════════════════════════════════════════════════

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Name = "ToggleButton"
toggleBtn.BackgroundColor3 = theme.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Position = UDim2.new(0, 18, 0.5, -22)
toggleBtn.Size = UDim2.new(0, 44, 0, 44)
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 100

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = theme.border
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.3

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Text = "◈"
toggleIcon.TextColor3 = theme.textMuted
toggleIcon.TextSize = 20
toggleIcon.ZIndex = 101

-- Glow effect
local toggleGlow = Instance.new("ImageLabel", toggleBtn)
toggleGlow.BackgroundTransparency = 1
toggleGlow.Size = UDim2.new(1, 30, 1, 30)
toggleGlow.Position = UDim2.new(0, -15, 0, -15)
toggleGlow.Image = "rbxassetid://5028857084"
toggleGlow.ImageColor3 = theme.accent
toggleGlow.ImageTransparency = 0.9
toggleGlow.ZIndex = 99

-- Dragging for toggle button
local dragging = false
local dragStart, startPos
local lastClickTime = 0

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        lastClickTime = tick()
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
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
    TweenService:Create(toggleStroke, anim.fast, {Color = theme.accent, Transparency = 0}):Play()
    TweenService:Create(toggleIcon, anim.fast, {TextColor3 = theme.accent}):Play()
    TweenService:Create(toggleBtn, anim.bounce, {Size = UDim2.new(0, 48, 0, 48)}):Play()
    TweenService:Create(toggleGlow, anim.normal, {ImageTransparency = 0.6}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, anim.fast, {Color = theme.border, Transparency = 0.3}):Play()
    TweenService:Create(toggleIcon, anim.fast, {TextColor3 = theme.textMuted}):Play()
    TweenService:Create(toggleBtn, anim.bounce, {Size = UDim2.new(0, 44, 0, 44)}):Play()
    TweenService:Create(toggleGlow, anim.normal, {ImageTransparency = 0.9}):Play()
end)

-- ══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════════════════════════════════

local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifications"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -280, 0, 20)
notifContainer.Size = UDim2.new(0, 270, 0, 300)
notifContainer.ZIndex = 200

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function notify(msg, duration, notifType)
    if not cfg.notifications then return end
    
    local color = theme.accent
    local icon = "●"
    
    if notifType == "success" then color = theme.success; icon = "✓"
    elseif notifType == "error" then color = theme.error; icon = "✕"
    elseif notifType == "warn" then color = theme.warning; icon = "!"
    elseif notifType == "sky" then color = theme.accent; icon = "☀"
    end

    local notif = Instance.new("Frame", notifContainer)
    notif.BackgroundColor3 = theme.surface
    notif.BackgroundTransparency = 0.02
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 0, 0, 42)
    notif.ClipsDescendants = true
    notif.ZIndex = 201

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
    
    local notifStroke = Instance.new("UIStroke", notif)
    notifStroke.Color = color
    notifStroke.Thickness = 1
    notifStroke.Transparency = 0.7

    local accentBar = Instance.new("Frame", notif)
    accentBar.BackgroundColor3 = color
    accentBar.BorderSizePixel = 0
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 10)

    local iconLbl = Instance.new("TextLabel", notif)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Position = UDim2.new(0, 14, 0, 0)
    iconLbl.Size = UDim2.new(0, 22, 1, 0)
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Text = icon
    iconLbl.TextColor3 = color
    iconLbl.TextSize = 14
    iconLbl.TextTransparency = 1
    iconLbl.ZIndex = 202

    local msgLbl = Instance.new("TextLabel", notif)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Position = UDim2.new(0, 40, 0, 0)
    msgLbl.Size = UDim2.new(1, -55, 1, 0)
    msgLbl.Font = Enum.Font.GothamMedium
    msgLbl.Text = msg
    msgLbl.TextColor3 = theme.textPrimary
    msgLbl.TextSize = 12
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextTransparency = 1
    msgLbl.ZIndex = 202

    -- Animate in
    TweenService:Create(notif, anim.bounce, {Size = UDim2.new(0, 250, 0, 42)}):Play()
    task.delay(0.08, function()
        TweenService:Create(iconLbl, anim.fast, {TextTransparency = 0}):Play()
        TweenService:Create(msgLbl, anim.fast, {TextTransparency = 0}):Play()
        TweenService:Create(notifStroke, anim.normal, {Transparency = 0.3}):Play()
    end)

    -- Animate out
    task.delay(duration or 3, function()
        TweenService:Create(iconLbl, anim.fast, {TextTransparency = 1}):Play()
        TweenService:Create(msgLbl, anim.fast, {TextTransparency = 1}):Play()
        TweenService:Create(notif, anim.normal, {Size = UDim2.new(0, 0, 0, 42), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ══════════════════════════════════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════════════════════════════════

local pages = {}
local tabButtons = {}
local activeTab = nil

local tabs = {
    {id = "home", name = "Home", icon = "◆"},
    {id = "combat", name = "Combat", icon = "⚔"},
    {id = "movement", name = "Move", icon = "➤"},
    {id = "visual", name = "Visual", icon = "◐"},
    {id = "sky", name = "Sky", icon = "☀"},
    {id = "player", name = "Players", icon = "♦"},
    {id = "settings", name = "Settings", icon = "⚙"},
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
    page.ScrollBarImageColor3 = theme.accent
    page.ScrollBarImageTransparency = 0.5
    page.Visible = false
    page.ZIndex = 13
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.TopImage = "rbxassetid://5234388158"
    page.MidImage = "rbxassetid://5234388158"
    page.BottomImage = "rbxassetid://5234388158"

    local padding = Instance.new("UIPadding", page)
    padding.PaddingRight = UDim.new(0, 8)

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    pages[id] = page
    return page
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabContainer
    btn.BackgroundColor3 = theme.card
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 17

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    -- Active indicator (left bar)
    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.5, -10)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.ZIndex = 18
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 0, 0, 8)
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = tab.icon
    iconLabel.TextColor3 = theme.textDim
    iconLabel.TextSize = 16
    iconLabel.ZIndex = 18

    local nameLabel = Instance.new("TextLabel", btn)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 0, 0, 30)
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Text = tab.name
    nameLabel.TextColor3 = theme.textDim
    nameLabel.TextSize = 8
    nameLabel.ZIndex = 18

    local page = createPage(tab.id)
    tabButtons[tab.id] = {btn = btn, icon = iconLabel, name = nameLabel, indicator = indicator}

    btn.MouseButton1Click:Connect(function()
        if activeTab == tab.id then return end
        
        -- Deactivate all
        for id, data in pairs(tabButtons) do
            TweenService:Create(data.btn, anim.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.icon, anim.fast, {TextColor3 = theme.textDim}):Play()
            TweenService:Create(data.name, anim.fast, {TextColor3 = theme.textDim}):Play()
            TweenService:Create(data.indicator, anim.normal, {Size = UDim2.new(0, 3, 0, 0)}):Play()
            pages[id].Visible = false
        end

        -- Activate selected
        TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.6}):Play()
        TweenService:Create(iconLabel, anim.fast, {TextColor3 = theme.accent}):Play()
        TweenService:Create(nameLabel, anim.fast, {TextColor3 = theme.textSecondary}):Play()
        TweenService:Create(indicator, anim.bounce, {Size = UDim2.new(0, 3, 0, 20)}):Play()
        
        -- Fade in page
        page.Visible = true
        
        activeTab = tab.id
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.75}):Play()
            TweenService:Create(iconLabel, anim.fast, {TextColor3 = theme.textMuted}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, anim.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(iconLabel, anim.fast, {TextColor3 = theme.textDim}):Play()
        end
    end)

    -- Set first tab as default
    if i == 1 then
        btn.BackgroundTransparency = 0.6
        iconLabel.TextColor3 = theme.accent
        nameLabel.TextColor3 = theme.textSecondary
        indicator.Size = UDim2.new(0, 3, 0, 20)
        page.Visible = true
        activeTab = tab.id
    end
end

-- ══════════════════════════════════════════════════════════════
-- UI COMPONENT BUILDERS
-- ══════════════════════════════════════════════════════════════

local function createSection(parent, title)
    local section = Instance.new("Frame", parent)
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, 0, 0, 28)
    section.ZIndex = 14

    local label = Instance.new("TextLabel", section)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 4, 0, 6)
    label.Size = UDim2.new(1, -8, 0, 16)
    label.Font = Enum.Font.GothamBold
    label.Text = title:upper()
    label.TextColor3 = theme.textDim
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    
    return section
end

local function createToggle(parent, text, cfgKey, callback)
    local state = cfg[cfgKey] or false

    local container = Instance.new("TextButton", parent)
    container.BackgroundColor3 = theme.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 44)
    container.Text = ""
    container.AutoButtonColor = false
    container.ZIndex = 14

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

    local containerStroke = Instance.new("UIStroke", container)
    containerStroke.Color = theme.border
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.7

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 16, 0, 0)
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = theme.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 15

    local switch = Instance.new("Frame", container)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = theme.toggleOff
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -14, 0.5, 0)
    switch.Size = UDim2.new(0, 42, 0, 22)
    switch.ZIndex = 15
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = theme.knobOff
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(0, 3, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.ZIndex = 16
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    -- Knob inner shadow/glow
    local knobGlow = Instance.new("UIStroke", knob)
    knobGlow.Color = theme.shadow
    knobGlow.Thickness = 1
    knobGlow.Transparency = 0.8

    local function updateVisual(animate)
        local tweenInfo = animate and anim.bounce or anim.instant
        
        if state then
            TweenService:Create(switch, animate and anim.normal or anim.instant, {BackgroundColor3 = theme.toggleOn}):Play()
            TweenService:Create(knob, tweenInfo, {
                Position = UDim2.new(1, -19, 0.5, 0),
                BackgroundColor3 = theme.knobOn
            }):Play()
            TweenService:Create(label, anim.fast, {TextColor3 = theme.textPrimary}):Play()
            TweenService:Create(containerStroke, anim.fast, {Color = theme.success, Transparency = 0.4}):Play()
        else
            TweenService:Create(switch, animate and anim.normal or anim.instant, {BackgroundColor3 = theme.toggleOff}):Play()
            TweenService:Create(knob, tweenInfo, {
                Position = UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = theme.knobOff
            }):Play()
            TweenService:Create(label, anim.fast, {TextColor3 = theme.textSecondary}):Play()
            TweenService:Create(containerStroke, anim.fast, {Color = theme.border, Transparency = 0.7}):Play()
        end
    end

    local function toggle()
        state = not state
        cfg[cfgKey] = state
        updateVisual(true)
        pcall(callback, state)
        task.spawn(saveSettings)
    end

    container.MouseButton1Click:Connect(toggle)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, anim.fast, {BackgroundTransparency = 0.15}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, anim.fast, {BackgroundTransparency = 0.3}):Play()
    end)

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

local function createSlider(parent, text, min, max, cfgKey, callback, suffix)
    -- Validate and clamp initial value
    local val = cfg[cfgKey]
    if val == nil or val < min then val = min end
    if val > max then val = max end
    cfg[cfgKey] = val
    
    local dragging = false
    suffix = suffix or ""

    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = theme.card
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 58)
    container.ZIndex = 14

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 16, 0, 8)
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = theme.textSecondary
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 15

    -- Value display with background
    local valueBg = Instance.new("Frame", container)
    valueBg.BackgroundColor3 = theme.accentMuted
    valueBg.BackgroundTransparency = 0.65
    valueBg.Position = UDim2.new(1, -60, 0, 8)
    valueBg.Size = UDim2.new(0, 48, 0, 20)
    valueBg.ZIndex = 15
    Instance.new("UICorner", valueBg).CornerRadius = UDim.new(0, 6)

    local valueLabel = Instance.new("TextLabel", valueBg)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(math.floor(val)) .. suffix
    valueLabel.TextColor3 = theme.accent
    valueLabel.TextSize = 11
    valueLabel.ZIndex = 16

    -- Track
    local track = Instance.new("Frame", container)
    track.BackgroundColor3 = theme.sliderTrack
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 16, 0, 38)
    track.Size = UDim2.new(1, -32, 0, 8)
    track.ZIndex = 15
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    -- Fill
    local fillPercent = math.clamp((val - min) / (max - min), 0, 1)
    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = theme.sliderFill
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(fillPercent, 0, 1, 0)
    fill.ZIndex = 16
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    -- Knob
    local knob = Instance.new("Frame", track)
    knob.BackgroundColor3 = theme.sliderKnob
    knob.BorderSizePixel = 0
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(fillPercent, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.ZIndex = 17
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = theme.accentMuted
    knobStroke.Thickness = 2
    knobStroke.Transparency = 0.3

    -- Hit area
    local hitArea = Instance.new("TextButton", track)
    hitArea.BackgroundTransparency = 1
    hitArea.Size = UDim2.new(1, 0, 1, 16)
    hitArea.Position = UDim2.new(0, 0, 0, -8)
    hitArea.Text = ""
    hitArea.ZIndex = 18

    local function updateSlider(input)
        local trackAbsPos = track.AbsolutePosition.X
        local trackAbsSize = track.AbsoluteSize.X
        
        local relX = input.Position.X - trackAbsPos
        local percent = math.clamp(relX / trackAbsSize, 0, 1)
        
        -- Calculate value with proper rounding
        local rawVal = min + (max - min) * percent
        val = math.floor(rawVal + 0.5) -- Round to nearest integer
        val = math.clamp(val, min, max) -- Ensure within bounds
        
        cfg[cfgKey] = val
        
        -- Recalculate percent from actual value for visual consistency
        local actualPercent = (val - min) / (max - min)
        
        TweenService:Create(fill, anim.instant, {Size = UDim2.new(actualPercent, 0, 1, 0)}):Play()
        TweenService:Create(knob, anim.instant, {Position = UDim2.new(actualPercent, 0, 0.5, 0)}):Play()
        
        valueLabel.Text = tostring(val) .. suffix
        pcall(callback, val)
    end

    hitArea.MouseButton1Down:Connect(function() 
        dragging = true 
        TweenService:Create(knob, anim.fast, {Size = UDim2.new(0, 20, 0, 20)}):Play()
        TweenService:Create(knobStroke, anim.fast, {Color = theme.accent}):Play()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            TweenService:Create(knob, anim.fast, {Size = UDim2.new(0, 16, 0, 16)}):Play()
            TweenService:Create(knobStroke, anim.fast, {Color = theme.accentMuted}):Play()
            task.spawn(saveSettings)
        end
    end)
    
    hitArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, anim.fast, {BackgroundTransparency = 0.15}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, anim.fast, {BackgroundTransparency = 0.3}):Play()
    end)
    
    return {
        setValue = function(newVal)
            newVal = math.clamp(newVal, min, max)
            val = math.floor(newVal + 0.5)
            cfg[cfgKey] = val
            local percent = (val - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, 0, 0.5, 0)
            valueLabel.Text = tostring(val) .. suffix
        end,
        getValue = function() return val end
    }
end

local function createButton(parent, text, callback, icon)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = theme.card
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 14
    btn.ClipsDescendants = true

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    if icon then
        local iconLbl = Instance.new("TextLabel", btn)
        iconLbl.BackgroundTransparency = 1
        iconLbl.Position = UDim2.new(0, 16, 0, 0)
        iconLbl.Size = UDim2.new(0, 20, 1, 0)
        iconLbl.Font = Enum.Font.GothamBold
        iconLbl.Text = icon
        iconLbl.TextColor3 = theme.accent
        iconLbl.TextSize = 14
        iconLbl.ZIndex = 15
    end

    local textLbl = Instance.new("TextLabel", btn)
    textLbl.BackgroundTransparency = 1
    textLbl.Position = UDim2.new(0, icon and 42 or 16, 0, 0)
    textLbl.Size = UDim2.new(1, icon and -58 or -32, 1, 0)
    textLbl.Font = Enum.Font.GothamMedium
    textLbl.Text = text
    textLbl.TextColor3 = theme.textSecondary
    textLbl.TextSize = 12
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.ZIndex = 15

    -- Ripple effect
    local function createRipple(x, y)
        local ripple = Instance.new("Frame", btn)
        ripple.BackgroundColor3 = theme.accent
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        ripple.Position = UDim2.new(0, x - 10, 0, y - 10)
        ripple.Size = UDim2.new(0, 20, 0, 20)
        ripple.ZIndex = 16
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        
        local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.5
        
        TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            Position = UDim2.new(0, x - maxSize/2, 0, y - maxSize/2),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.55, function() ripple:Destroy() end)
    end

    btn.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local relX = mousePos.X - btn.AbsolutePosition.X
        local relY = mousePos.Y - btn.AbsolutePosition.Y
        createRipple(relX, relY)
        pcall(callback)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(textLbl, anim.fast, {TextColor3 = theme.textPrimary}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(textLbl, anim.fast, {TextColor3 = theme.textSecondary}):Play()
    end)

    return btn
end

local function createSkyButton(parent, title, skyType, icon, description)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = theme.card
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 60)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 14
    btn.ClipsDescendants = true

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = theme.border
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6

    local iconLbl = Instance.new("TextLabel", btn)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Position = UDim2.new(0, 16, 0, 0)
    iconLbl.Size = UDim2.new(0, 30, 1, 0)
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Text = icon
    iconLbl.TextColor3 = theme.accent
    iconLbl.TextSize = 22
    iconLbl.ZIndex = 15

    local titleLbl = Instance.new("TextLabel", btn)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 54, 0, 12)
    titleLbl.Size = UDim2.new(1, -110, 0, 18)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.textPrimary
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 15

    local descLbl = Instance.new("TextLabel", btn)
    descLbl.BackgroundTransparency = 1
    descLbl.Position = UDim2.new(0, 54, 0, 32)
    descLbl.Size = UDim2.new(1, -70, 0, 16)
    descLbl.Font = Enum.Font.Gotham
    descLbl.Text = description
    descLbl.TextColor3 = theme.textDim
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 15

    -- Active indicator
    local activeIndicator = Instance.new("Frame", btn)
    activeIndicator.BackgroundColor3 = theme.success
    activeIndicator.BackgroundTransparency = 1
    activeIndicator.Position = UDim2.new(1, -32, 0.5, -6)
    activeIndicator.Size = UDim2.new(0, 12, 0, 12)
    activeIndicator.ZIndex = 16
    Instance.new("UICorner", activeIndicator).CornerRadius = UDim.new(1, 0)

    local function updateActive()
        if cfg.skyMode == skyType then
            TweenService:Create(activeIndicator, anim.fast, {BackgroundTransparency = 0}):Play()
            TweenService:Create(btnStroke, anim.fast, {Color = theme.accent, Transparency = 0.2}):Play()
        else
            TweenService:Create(activeIndicator, anim.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(btnStroke, anim.fast, {Color = theme.border, Transparency = 0.6}):Play()
        end
    end

    btn.MouseButton1Click:Connect(function()
        if skyType == "default" then
            SkySystem:restore()
            notify("Sky restored to default", 2.5, "sky")
        elseif skyType == "galaxy" then
            SkySystem:applyGalaxy()
            notify("Galaxy sky applied", 2.5, "sky")
        elseif skyType == "sunset" then
            SkySystem:applySunset()
            notify("Sunset sky applied", 2.5, "sky")
        elseif skyType == "morning" then
            SkySystem:applyMorning()
            notify("Morning sky applied", 2.5, "sky")
        elseif skyType == "night" then
            SkySystem:applyNight()
            notify("Night sky applied", 2.5, "sky")
        end
        
        task.spawn(saveSettings)
        
        -- Update all sky buttons
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChild("UpdateActive") then
                -- Will be handled by individual buttons
            end
        end
        updateActive()
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(iconLbl, anim.fast, {TextColor3 = theme.accentGlow}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.25}):Play()
        TweenService:Create(iconLbl, anim.fast, {TextColor3 = theme.accent}):Play()
    end)

    updateActive()
    
    -- Store update function reference
    local updateFunc = Instance.new("BindableFunction", btn)
    updateFunc.Name = "UpdateActive"
    
    return {updateActive = updateActive}
end

local function createInfoCard(parent, title, value, icon)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = theme.card
    card.BackgroundTransparency = 0.25
    card.Size = UDim2.new(1, 0, 0, 56)
    card.ZIndex = 14
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local iconLbl = Instance.new("TextLabel", card)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Position = UDim2.new(0, 16, 0, 0)
    iconLbl.Size = UDim2.new(0, 28, 1, 0)
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Text = icon or "●"
    iconLbl.TextColor3 = theme.accent
    iconLbl.TextSize = 18
    iconLbl.ZIndex = 15

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 52, 0, 10)
    titleLbl.Size = UDim2.new(1, -65, 0, 16)
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.textMuted
    titleLbl.TextSize = 10
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 15

    local valueLbl = Instance.new("TextLabel", card)
    valueLbl.Name = "Value"
    valueLbl.BackgroundTransparency = 1
    valueLbl.Position = UDim2.new(0, 52, 0, 28)
    valueLbl.Size = UDim2.new(1, -65, 0, 18)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.Text = value
    valueLbl.TextColor3 = theme.textPrimary
    valueLbl.TextSize = 14
    valueLbl.TextXAlignment = Enum.TextXAlignment.Left
    valueLbl.ZIndex = 15

    return card
end

-- ══════════════════════════════════════════════════════════════
-- CORE FEATURE FUNCTIONS
-- ══════════════════════════════════════════════════════════════

local function clearESP()
    for _, data in pairs(espData) do
        pcall(function()
            if data.obj then
                if typeof(data.obj) == "Instance" then data.obj:Destroy() end
            end
        end)
    end
    espData = {}
end

local function enableGod()
    if immortal then return end
    immortal = true
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
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
    
    if conn.godH then conn.godH:Disconnect(); conn.godH = nil end
    if conn.godL then conn.godL:Disconnect(); conn.godL = nil end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = 100
        hum.Health = 100
        for _, st in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            pcall(function() hum:SetStateEnabled(st, true) end)
        end
    end
end

local function getClosestInFOV()
    local closest, minD = nil, cfg.aimfov
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < minD then closest, minD = p, d end
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
    conn.antiAFK = plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function createESP(player)
    if espData[player] or not player.Character then return end
    local ch = player.Character
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if cfg.espMode == 1 then
        local bb = Instance.new("BillboardGui", hrp)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 70, 0, 26)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)
        
        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = theme.bg
        bg.BackgroundTransparency = 0.15
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        
        local nm = Instance.new("TextLabel", bg)
        nm.Size = UDim2.new(1, 0, 0.55, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamBold
        nm.Text = player.Name
        nm.TextColor3 = theme.textPrimary
        nm.TextScaled = true
        
        local dst = Instance.new("TextLabel", bg)
        dst.Position = UDim2.new(0, 0, 0.55, 0)
        dst.Size = UDim2.new(1, 0, 0.45, 0)
        dst.BackgroundTransparency = 1
        dst.Font = Enum.Font.Gotham
        dst.TextColor3 = theme.textMuted
        dst.TextScaled = true
        
        espData[player] = {obj = bb, dist = dst, type = "nametag"}
        
    elseif cfg.espMode == 2 then
        local hl = Instance.new("Highlight", ch)
        hl.FillColor = theme.accent
        hl.OutlineColor = theme.textPrimary
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.3
        
        espData[player] = {obj = hl, type = "highlight"}
        
    elseif cfg.espMode == 3 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = theme.accent
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
            local rainbow = Color3.fromHSV(tick() % 6 / 6, 0.5, 0.9)
            if data.type == "box" then data.obj.Color3 = rainbow
            elseif data.type == "highlight" then data.obj.FillColor = rainbow end
        end
    end
end

local function enableFly()
    if flying then return end
    flying = true
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 1000000
    bodyGyro.D = 500
    
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    conn.fly = RunService.RenderStepped:Connect(function()
        if not flying then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        local camCF = cam.CFrame
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * cfg.flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        bodyGyro.CFrame = camCF
    end)
end

local function disableFly()
    if not flying then return end
    flying = false
    
    if conn.fly then conn.fly:Disconnect(); conn.fly = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
end

-- ══════════════════════════════════════════════════════════════
-- PAGE CONTENT
-- ══════════════════════════════════════════════════════════════

-- HOME PAGE
local homePage = pages["home"]

createSection(homePage, "Player Info")

local playerCard = Instance.new("Frame", homePage)
playerCard.BackgroundColor3 = theme.card
playerCard.BackgroundTransparency = 0.2
playerCard.Size = UDim2.new(1, 0, 0, 65)
playerCard.ZIndex = 14
Instance.new("UICorner", playerCard).CornerRadius = UDim.new(0, 12)

local avatar = Instance.new("ImageLabel", playerCard)
avatar.BackgroundColor3 = theme.surfaceAlt
avatar.Position = UDim2.new(0, 14, 0.5, -22)
avatar.Size = UDim2.new(0, 44, 0, 44)
avatar.ZIndex = 15
Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 10)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local playerName = Instance.new("TextLabel", playerCard)
playerName.BackgroundTransparency = 1
playerName.Position = UDim2.new(0, 68, 0, 14)
playerName.Size = UDim2.new(1, -80, 0, 20)
playerName.Font = Enum.Font.GothamBold
playerName.Text = plr.Name
playerName.TextColor3 = theme.textPrimary
playerName.TextSize = 15
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.ZIndex = 15

local gameInfo = Instance.new("TextLabel", playerCard)
gameInfo.BackgroundTransparency = 1
gameInfo.Position = UDim2.new(0, 68, 0, 36)
gameInfo.Size = UDim2.new(1, -80, 0, 14)
gameInfo.Font = Enum.Font.Gotham
gameInfo.Text = "Violence District • Premium Edition"
gameInfo.TextColor3 = theme.textDim
gameInfo.TextSize = 10
gameInfo.TextXAlignment = Enum.TextXAlignment.Left
gameInfo.ZIndex = 15

createSection(homePage, "Quick Actions")

createButton(homePage, "Reset Character", function()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    notify("Character reset", 2, "success")
end, "↺")

createButton(homePage, "Rejoin Server", function()
    notify("Rejoining server...", 2, "warn")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, "⟳")

createButton(homePage, "Server Hop", function()
    notify("Finding new server...", 2, "warn")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, "⇄")

createButton(homePage, "Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Server ID copied!", 2, "success")
    else
        notify("Not supported", 2, "error")
    end
end, "⎘")

createSection(homePage, "Character")

createToggle(homePage, "No Ragdoll", "noRagdoll", function(v)
    if v then
        conn.noRagdoll = RunService.Heartbeat:Connect(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end)
        notify("No ragdoll enabled", 2, "success")
    else
        if conn.noRagdoll then conn.noRagdoll:Disconnect(); conn.noRagdoll = nil end
        notify("No ragdoll disabled", 2)
    end
end)

createToggle(homePage, "Anti Void", "antiVoid", function(v)
    if v then
        local safePos = char.HumanoidRootPart.CFrame
        conn.antiVoid = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp.Position.Y > -50 then safePos = hrp.CFrame end
                if hrp.Position.Y < -100 then hrp.CFrame = safePos end
            end
        end)
        notify("Anti void enabled", 2, "success")
    else
        if conn.antiVoid then conn.antiVoid:Disconnect(); conn.antiVoid = nil end
        notify("Anti void disabled", 2)
    end
end)

createToggle(homePage, "Low Gravity", "lowGravity", function(v)
    Workspace.Gravity = v and 50 or defaultGravity
    notify(v and "Low gravity enabled" or "Gravity restored", 2, v and "success" or nil)
end)

createToggle(homePage, "Auto Heal", "autoHeal", function(v)
    if v then
        conn.autoHeal = RunService.Heartbeat:Connect(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth * (cfg.healThreshold / 100) then
                hum.Health = hum.MaxHealth
            end
        end)
        notify("Auto heal enabled", 2, "success")
    else
        if conn.autoHeal then conn.autoHeal:Disconnect(); conn.autoHeal = nil end
        notify("Auto heal disabled", 2)
    end
end)

createSlider(homePage, "Heal Threshold", 10, 90, "healThreshold", function(v) end, "%")

-- COMBAT PAGE
local combatPage = pages["combat"]

createSection(combatPage, "Protection")

createToggle(combatPage, "God Mode", "god", function(v)
    if v then 
        enableGod()
        notify("God mode enabled", 2, "success")
    else 
        disableGod()
        notify("God mode disabled", 2)
    end
end)

createSection(combatPage, "Aimbot")

createToggle(combatPage, "Auto Aim", "aim", function(v)
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
        notify("Auto aim enabled", 2, "success")
    else
        if conn.aim then conn.aim:Disconnect(); conn.aim = nil end
        notify("Auto aim disabled", 2)
    end
end)

createToggle(combatPage, "Show FOV Circle", "showfov", function(v) end)

createSlider(combatPage, "FOV Size", 50, 400, "aimfov", function(v) end, "")

createSection(combatPage, "Kill Aura")

createToggle(combatPage, "Kill Aura", "killaura", function(v)
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
        notify("Kill aura enabled", 2, "success")
    else
        if conn.aura then conn.aura:Disconnect(); conn.aura = nil end
        notify("Kill aura disabled", 2)
    end
end)

createToggle(combatPage, "Show Aura Range", "showAura", function(v) end)

createSlider(combatPage, "Aura Range", 5, 35, "auraRange", function(v) end, "m")
createSlider(combatPage, "Hit Chance", 25, 100, "hitChance", function(v) end, "%")

createSection(combatPage, "Auto Attack")

createToggle(combatPage, "Auto Punch", "autoPunch", function(v)
    if v then
        conn.autoPunch = RunService.Heartbeat:Connect(function()
            -- Simulate mouse click for punching
            local target = getClosestInFOV()
            if target and target.Character then
                -- Find and fire attack remotes
                fireHit(target)
            end
        end)
        notify("Auto punch enabled", 2, "success")
    else
        if conn.autoPunch then conn.autoPunch:Disconnect(); conn.autoPunch = nil end
        notify("Auto punch disabled", 2)
    end
end)

createSlider(combatPage, "Punch Speed", 1, 20, "punchSpeed", function(v) end, "/s")

-- MOVEMENT PAGE
local movePage = pages["movement"]

createSection(movePage, "Speed")

createToggle(movePage, "Speed Hack", "speedHack", function(v)
    if not v then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = defaultSpeed end
    end
    notify(v and "Speed hack enabled" or "Speed hack disabled", 2, v and "success" or nil)
end)

createSlider(movePage, "Walk Speed", 16, 500, "speed", function(v) end, "")

createSection(movePage, "Flight")

createToggle(movePage, "Fly", "fly", function(v)
    if v then 
        enableFly()
        notify("Flight enabled (Space=Up, Ctrl=Down)", 3, "success")
    else 
        disableFly()
        notify("Flight disabled", 2)
    end
end)

createSlider(movePage, "Fly Speed", 10, 200, "flySpeed", function(v) end, "")

createSection(movePage, "Jump")

createToggle(movePage, "Infinite Jump", "infiniteJump", function(v)
    if v then
        conn.infJump = UserInputService.JumpRequest:Connect(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        notify("Infinite jump enabled", 2, "success")
    else
        if conn.infJump then conn.infJump:Disconnect(); conn.infJump = nil end
        notify("Infinite jump disabled", 2)
    end
end)

createSlider(movePage, "Jump Power", 50, 300, "jumpPower", function(v)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v end
end, "")

createSection(movePage, "Physics")

createToggle(movePage, "Noclip", "noclip", function(v)
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
        notify("Noclip enabled", 2, "success")
    else
        if conn.noclip then conn.noclip:Disconnect(); conn.noclip = nil end
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.CanCollide = true
            end
        end
        notify("Noclip disabled", 2)
    end
end)

-- VISUAL PAGE
local visualPage = pages["visual"]

createSection(visualPage, "World")

createToggle(visualPage, "Remove Fog", "fog", function(v)
    Lighting.FogEnd = v and 100000 or (originalLighting.FogEnd or 1000)
    notify(v and "Fog removed" or "Fog restored", 2, v and "success" or nil)
end)

createToggle(visualPage, "Fullbright", "bright", function(v)
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = originalLighting.Brightness or 1
        Lighting.ClockTime = originalLighting.ClockTime or 12
        Lighting.GlobalShadows = originalLighting.GlobalShadows ~= false
        Lighting.Ambient = originalLighting.Ambient or Color3.fromRGB(0, 0, 0)
    end
    notify(v and "Fullbright enabled" or "Fullbright disabled", 2, v and "success" or nil)
end)

createSlider(visualPage, "Field of View", 70, 120, "fov", function(v)
    cam.FieldOfView = v
end, "°")

createToggle(visualPage, "No Particles", "noParticles", function(v)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = not v
        end
    end
    notify(v and "Particles disabled" or "Particles enabled", 2, v and "success" or nil)
end)

createSection(visualPage, "Character")

createToggle(visualPage, "Invisible", "invisible", function(v)
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            if v then
                if not p:GetAttribute("_origTrans") then
                    p:SetAttribute("_origTrans", p.Transparency)
                end
                p.Transparency = 1
            else
                local orig = p:GetAttribute("_origTrans")
                p.Transparency = orig or 0
            end
        end
    end
    notify(v and "Invisible enabled" or "Invisible disabled", 2, v and "success" or nil)
end)

createToggle(visualPage, "X-Ray Walls", "xray", function(v)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            local n = obj.Name:lower()
            if n:find("wall") or n:find("door") or n:find("window") then
                if v then
                    if not obj:GetAttribute("_xrayOrig") then
                        obj:SetAttribute("_xrayOrig", obj.Transparency)
                    end
                    obj.Transparency = 0.7
                else
                    local orig = obj:GetAttribute("_xrayOrig")
                    if orig then obj.Transparency = orig end
                end
            end
        end
    end
    notify(v and "X-Ray enabled" or "X-Ray disabled", 2, v and "success" or nil)
end)

createSection(visualPage, "ESP")

createToggle(visualPage, "Enable ESP", "esp", function(v)
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
        notify("ESP enabled", 2, "success")
    else
        clearESP()
        notify("ESP disabled", 2)
    end
end)

createToggle(visualPage, "RGB ESP", "espRgb", function(v) end)

createButton(visualPage, "ESP: Name Tags", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then 
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= plr then createESP(p) end 
        end 
    end
    notify("ESP mode: Name Tags", 2, "success")
    task.spawn(saveSettings)
end, "◇")

createButton(visualPage, "ESP: Highlight", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then 
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= plr then createESP(p) end 
        end 
    end
    notify("ESP mode: Highlight", 2, "success")
    task.spawn(saveSettings)
end, "◈")

createButton(visualPage, "ESP: Box", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then 
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= plr then createESP(p) end 
        end 
    end
    notify("ESP mode: Box", 2, "success")
    task.spawn(saveSettings)
end, "▢")

-- SKY PAGE
local skyPage = pages["sky"]

createSection(skyPage, "Sky Presets")

local skyButtons = {}
skyButtons.default = createSkyButton(skyPage, "Default", "default", "◯", "Restore original map lighting")
skyButtons.galaxy = createSkyButton(skyPage, "Galaxy", "galaxy", "✦", "Deep space with stars and nebula")
skyButtons.sunset = createSkyButton(skyPage, "Sunset", "sunset", "☀", "Warm orange and pink evening")
skyButtons.morning = createSkyButton(skyPage, "Morning", "morning", "◐", "Fresh blue sky with soft light")
skyButtons.night = createSkyButton(skyPage, "Night", "night", "☾", "Dark sky with moonlight")

createSection(skyPage, "Information")

local skyInfoCard = Instance.new("Frame", skyPage)
skyInfoCard.BackgroundColor3 = theme.card
skyInfoCard.BackgroundTransparency = 0.35
skyInfoCard.Size = UDim2.new(1, 0, 0, 55)
skyInfoCard.ZIndex = 14
Instance.new("UICorner", skyInfoCard).CornerRadius = UDim.new(0, 10)

local skyInfoText = Instance.new("TextLabel", skyInfoCard)
skyInfoText.BackgroundTransparency = 1
skyInfoText.Position = UDim2.new(0, 14, 0, 0)
skyInfoText.Size = UDim2.new(1, -28, 1, 0)
skyInfoText.Font = Enum.Font.Gotham
skyInfoText.Text = "Sky presets modify lighting, atmosphere, and visual effects. Changes are client-side only and don't affect other players."
skyInfoText.TextColor3 = theme.textDim
skyInfoText.TextSize = 10
skyInfoText.TextWrapped = true
skyInfoText.TextXAlignment = Enum.TextXAlignment.Left
skyInfoText.ZIndex = 15

-- PLAYER PAGE
local playerPage = pages["player"]

createSection(playerPage, "Player List")

local playerListContainer = Instance.new("Frame", playerPage)
playerListContainer.BackgroundColor3 = theme.card
playerListContainer.BackgroundTransparency = 0.25
playerListContainer.Size = UDim2.new(1, 0, 0, 150)
playerListContainer.ZIndex = 14
Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 12)

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 8, 0, 8)
playerListScroll.Size = UDim2.new(1, -16, 1, -16)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 3
playerListScroll.ScrollBarImageColor3 = theme.accent
playerListScroll.ZIndex = 15

local playerListLayout = Instance.new("UIListLayout", playerListScroll)
playerListLayout.Padding = UDim.new(0, 5)

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
            btn.BackgroundColor3 = isSel and theme.accentMuted or theme.surfaceAlt
            btn.BackgroundTransparency = isSel and 0.35 or 0.45
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 16
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            
            local name = Instance.new("TextLabel", btn)
            name.BackgroundTransparency = 1
            name.Position = UDim2.new(0, 14, 0, 0)
            name.Size = UDim2.new(1, -50, 1, 0)
            name.Font = Enum.Font.GothamMedium
            name.Text = player.Name
            name.TextColor3 = theme.textPrimary
            name.TextSize = 12
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.ZIndex = 17
            
            if isSel then
                local indicator = Instance.new("Frame", btn)
                indicator.BackgroundColor3 = theme.accent
                indicator.Position = UDim2.new(1, -28, 0.5, -5)
                indicator.Size = UDim2.new(0, 10, 0, 10)
                indicator.ZIndex = 17
                Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
            end
            
            btn.MouseButton1Click:Connect(function()
                cfg.selectedPlayer = cfg.selectedPlayer == player and nil or player
                notify(cfg.selectedPlayer and ("Selected " .. player.Name) or "Deselected", 2, cfg.selectedPlayer and "success" or nil)
                updatePlayerList()
            end)
            
            btn.MouseEnter:Connect(function()
                if not isSel then 
                    TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.25}):Play() 
                end
            end)
            btn.MouseLeave:Connect(function()
                if not isSel then 
                    TweenService:Create(btn, anim.fast, {BackgroundTransparency = 0.45}):Play() 
                end
            end)
        end
    end
end

updatePlayerList()

createSection(playerPage, "Actions")

createButton(playerPage, "Teleport to Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character and cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cfg.selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            notify("Teleported to " .. cfg.selectedPlayer.Name, 2, "success")
        end
    else
        notify("Select a player first", 2, "warn")
    end
end, "⤴")

createButton(playerPage, "Spectate Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local hum = cfg.selectedPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            cam.CameraSubject = hum
            notify("Spectating " .. cfg.selectedPlayer.Name, 2, "success")
        end
    else
        notify("Select a player first", 2, "warn")
    end
end, "◉")

createButton(playerPage, "Stop Spectating", function()
    local hum = char:FindFirstChild("Humanoid")
    if hum then 
        cam.CameraSubject = hum 
        notify("Stopped spectating", 2, "success") 
    end
end, "◎")

createButton(playerPage, "Refresh List", function()
    updatePlayerList()
    notify("Player list refreshed", 2, "success")
end, "↻")

createSection(playerPage, "Utility")

createToggle(playerPage, "Click Teleport", "clickTp", function(v)
    if v then
        conn.clickTp = mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and mouse.Target then
                    hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
        notify("Click TP enabled (Alt + Click)", 2.5, "success")
    else
        if conn.clickTp then conn.clickTp:Disconnect(); conn.clickTp = nil end
        notify("Click TP disabled", 2)
    end
end)

-- SETTINGS PAGE
local settingsPage = pages["settings"]

createSection(settingsPage, "General")

createToggle(settingsPage, "Notifications", "notifications", function(v)
    -- Just saves the setting
end)

createToggle(settingsPage, "Auto Save Settings", "autoSave", function(v)
    notify(v and "Auto save enabled" or "Auto save disabled", 2, v and "success" or nil)
end)

createToggle(settingsPage, "Anti AFK", "antiAfk", function(v)
    if v then 
        setupAntiAFK()
        notify("Anti AFK enabled", 2, "success")
    else 
        if conn.antiAFK then conn.antiAFK:Disconnect(); conn.antiAFK = nil end
        notify("Anti AFK disabled", 2)
    end
end)

createSection(settingsPage, "Actions")

createButton(settingsPage, "Save Settings Now", function()
    saveSettings()
    notify("Settings saved!", 2, "success")
end, "💾")

createButton(settingsPage, "Reset All Settings", function()
    for k, v in pairs(defaultCfg) do
        cfg[k] = v
    end
    saveSettings()
    notify("Settings reset to default", 2.5, "warn")
end, "↺")

createButton(settingsPage, "Destroy GUI", function()
    notify("Goodbye!", 1.5, "warn")
    task.wait(1.5)
    gui:Destroy()
end, "✕")

createSection(settingsPage, "Information")

local infoCard = Instance.new("Frame", settingsPage)
infoCard.BackgroundColor3 = theme.card
infoCard.BackgroundTransparency = 0.3
infoCard.Size = UDim2.new(1, 0, 0, 85)
infoCard.ZIndex = 14
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 10)

local infoText = Instance.new("TextLabel", infoCard)
infoText.BackgroundTransparency = 1
infoText.Position = UDim2.new(0, 14, 0, 10)
infoText.Size = UDim2.new(1, -28, 1, -20)
infoText.Font = Enum.Font.Gotham
infoText.Text = "Violence District v4 — Premium Edition\n\nHotkeys:\n• Right Shift — Toggle Menu\n• Alt + Click — Click Teleport (when enabled)"
infoText.TextColor3 = theme.textMuted
infoText.TextSize = 10
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.ZIndex = 15

-- ══════════════════════════════════════════════════════════════
-- DRAWING OBJECTS
-- ══════════════════════════════════════════════════════════════

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.Color = theme.accent
fovCircle.Transparency = 0.5
fovCircle.NumSides = 64
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1.5
auraCircle.Color = theme.error
auraCircle.Transparency = 0.5
auraCircle.NumSides = 64
auraCircle.Filled = false

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
    shadow.ImageTransparency = 1
    
    TweenService:Create(main, anim.menuOpen, {
        Size = UDim2.new(0, guiWidth, 0, guiHeight),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(mainStroke, anim.smooth, {Transparency = 0.5}):Play()
    TweenService:Create(shadow, anim.slow, {ImageTransparency = 0.6}):Play()
    TweenService:Create(toggleIcon, anim.fast, {TextColor3 = theme.accent}):Play()
end

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    
    TweenService:Create(main, anim.menuClose, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(mainStroke, anim.fast, {Transparency = 1}):Play()
    TweenService:Create(shadow, anim.fast, {ImageTransparency = 1}):Play()
    TweenService:Create(toggleIcon, anim.fast, {TextColor3 = theme.textMuted}):Play()
    
    task.delay(0.3, function()
        if not menuOpen then main.Visible = false end
    end)
end

toggleBtn.MouseButton1Click:Connect(function()
    if tick() - lastClickTime < 0.18 then
        if menuOpen then closeMenu() else openMenu() end
    end
end)

closeBtn.MouseButton1Click:Connect(closeMenu)
minimizeBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════════════════════════════
-- MAIN LOOP
-- ══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    -- Speed hack
    if cfg.speedHack and not flying then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = cfg.speed end
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
    
    -- ESP update
    if cfg.esp then updateESP() end
end)

-- ══════════════════════════════════════════════════════════════
-- EVENT CONNECTIONS
-- ══════════════════════════════════════════════════════════════

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.esp then createESP(p) end
    end)
    if activeTab == "player" then updatePlayerList() end
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        pcall(function() espData[p].obj:Destroy() end)
        espData[p] = nil
    end
    if cfg.selectedPlayer == p then cfg.selectedPlayer = nil end
    if activeTab == "player" then updatePlayerList() end
end)

plr.CharacterAdded:Connect(function(c)
    char = c
    task.wait(1)
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then 
        defaultSpeed = hum.WalkSpeed 
        defaultJumpPower = hum.JumpPower
    end
    
    -- Disable flying on respawn
    if flying then disableFly() end
    
    -- Re-apply toggles
    for key, ref in pairs(toggleRefs) do
        if cfg[key] then
            pcall(function() ref.apply() end)
        end
    end
end)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        if menuOpen then closeMenu() else openMenu() end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- INITIALIZE
-- ══════════════════════════════════════════════════════════════

task.spawn(function()
    task.wait(0.5)
    
    -- Apply saved settings
    if cfg.fov and cfg.fov ~= 70 then cam.FieldOfView = cfg.fov end
    if cfg.fog then Lighting.FogEnd = 100000 end
    if cfg.bright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
    if cfg.lowGravity then Workspace.Gravity = 50 end
    
    -- Apply saved sky
    if cfg.skyMode and cfg.skyMode ~= "default" then
        task.wait(0.5)
        if cfg.skyMode == "galaxy" then SkySystem:applyGalaxy()
        elseif cfg.skyMode == "sunset" then SkySystem:applySunset()
        elseif cfg.skyMode == "morning" then SkySystem:applyMorning()
        elseif cfg.skyMode == "night" then SkySystem:applyNight()
        end
    end
    
    -- Count active features
    local activeCount = 0
    for _, v in pairs(cfg) do
        if v == true then activeCount = activeCount + 1 end
    end
    
    notify("Violence District v4 loaded", 3, "success")
    if activeCount > 0 then
        notify(activeCount .. " settings restored", 2.5)
    end
end)

-- ══════════════════════════════════════════════════════════════
-- CLEANUP
-- ══════════════════════════════════════════════════════════════

gui.Destroying:Connect(function()
    -- Cleanup ESP
    clearESP()
    
    -- Cleanup Drawing
    pcall(function() fovCircle:Remove() end)
    pcall(function() auraCircle:Remove() end)
    
    -- Restore sky
    SkySystem:restore()
    
    -- Disable fly
    if flying then disableFly() end
    
    -- Disconnect all connections
    for _, c in pairs(conn) do
        if c then pcall(function() c:Disconnect() end) end
    end
    
    -- Restore defaults
    Workspace.Gravity = defaultGravity
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = defaultSpeed
        hum.JumpPower = defaultJumpPower
    end
end)

-- ══════════════════════════════════════════════════════════════
-- CONSOLE MESSAGE
-- ══════════════════════════════════════════════════════════════

print("════════════════════════════════════════════════════")
print("   Violence District v4 — Premium Edition")
print("   Professional 16:9 Minimalist GUI")
print("════════════════════════════════════════════════════")
print("   Hotkey: Right Shift — Toggle Menu")
print("════════════════════════════════════════════════════")