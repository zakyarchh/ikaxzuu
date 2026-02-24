--- violence district v3
-- premium edition
-- professional gui + sky system

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

local SAVE_FILE = "vd3_premium_settings.json"

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
    god = false, aim = false, aimfov = 100, showfov = false,
    silentAim = false, silentNoFov = false,
    killaura = false, auraRange = 15, showAura = false,
    hitChance = 100,
    invisible = false,
    fog = false, bright = false, fov = 70, antiAfk = false,
    selectedPlayer = nil,
    noRagdoll = false, infiniteStamina = false,
    antiVoid = false, lowGravity = false,
    xray = false, noParticles = false,
    godV2 = false,
    cloneTransparency = 0.3,
    transitionSpeed = 2,
    anchorOffset = 10,
    skyMode = "default",
    skyIntensity = 1
}

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

-- Store original lighting
local originalLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogColor = Lighting.FogColor,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

-- ══════════════════════════════════════════════════════════════
-- SKY SYSTEM
-- ══════════════════════════════════════════════════════════════

local SkySystem = {
    currentSky = nil,
    currentAtmosphere = nil,
    currentBloom = nil,
    currentColorCorrection = nil,
    currentSunRays = nil,
    originalSky = nil,
    originalAtmosphere = nil
}

function SkySystem:backup()
    self.originalSky = Lighting:FindFirstChildOfClass("Sky")
    self.originalAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    
    if self.originalSky then
        self.originalSky = self.originalSky:Clone()
    end
    if self.originalAtmosphere then
        self.originalAtmosphere = self.originalAtmosphere:Clone()
    end
end

function SkySystem:cleanup()
    if self.currentSky then self.currentSky:Destroy() self.currentSky = nil end
    if self.currentAtmosphere then self.currentAtmosphere:Destroy() self.currentAtmosphere = nil end
    if self.currentBloom then self.currentBloom:Destroy() self.currentBloom = nil end
    if self.currentColorCorrection then self.currentColorCorrection:Destroy() self.currentColorCorrection = nil end
    if self.currentSunRays then self.currentSunRays:Destroy() self.currentSunRays = nil end
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("BloomEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect") then
            if child.Name:find("VD3_") then
                child:Destroy()
            end
        end
    end
end

function SkySystem:restore()
    self:cleanup()
    
    -- Remove custom sky/atmosphere
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") and child.Name:find("VD3_") then
            child:Destroy()
        end
        if child:IsA("Atmosphere") and child.Name:find("VD3_") then
            child:Destroy()
        end
    end
    
    -- Restore original lighting
    for prop, value in pairs(originalLighting) do
        pcall(function() Lighting[prop] = value end)
    end
    
    cfg.skyMode = "default"
end

function SkySystem:applyGalaxy()
    self:cleanup()
    
    -- Remove existing sky
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then child:Destroy() end
        if child:IsA("Atmosphere") then child:Destroy() end
    end
    
    -- Create galaxy sky
    local sky = Instance.new("Sky")
    sky.Name = "VD3_GalaxySky"
    sky.SkyboxBk = "rbxassetid://6444884337"
    sky.SkyboxDn = "rbxassetid://6444884785"
    sky.SkyboxFt = "rbxassetid://6444884337"
    sky.SkyboxLf = "rbxassetid://6444884337"
    sky.SkyboxRt = "rbxassetid://6444884337"
    sky.SkyboxUp = "rbxassetid://6444884337"
    sky.StarCount = 5000
    sky.MoonAngularSize = 15
    sky.SunAngularSize = 5
    sky.Parent = Lighting
    self.currentSky = sky
    
    -- Atmosphere
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD3_GalaxyAtmo"
    atmo.Density = 0.4
    atmo.Offset = 0.25
    atmo.Color = Color3.fromRGB(20, 15, 40)
    atmo.Decay = Color3.fromRGB(60, 40, 80)
    atmo.Glare = 0.5
    atmo.Haze = 2
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    -- Color correction
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD3_GalaxyCC"
    cc.Brightness = -0.05
    cc.Contrast = 0.15
    cc.Saturation = 0.2
    cc.TintColor = Color3.fromRGB(200, 180, 255)
    cc.Parent = Lighting
    self.currentColorCorrection = cc
    
    -- Bloom
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "VD3_GalaxyBloom"
    bloom.Intensity = 0.8
    bloom.Size = 30
    bloom.Threshold = 0.9
    bloom.Parent = Lighting
    self.currentBloom = bloom
    
    -- Lighting settings
    Lighting.Brightness = 0.5
    Lighting.ClockTime = 0
    Lighting.Ambient = Color3.fromRGB(30, 25, 50)
    Lighting.OutdoorAmbient = Color3.fromRGB(40, 35, 60)
    Lighting.FogColor = Color3.fromRGB(15, 10, 30)
    Lighting.FogEnd = 2000
    Lighting.FogStart = 100
    
    cfg.skyMode = "galaxy"
end

function SkySystem:applySunset()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then child:Destroy() end
        if child:IsA("Atmosphere") then child:Destroy() end
    end
    
    -- Sunset sky
    local sky = Instance.new("Sky")
    sky.Name = "VD3_SunsetSky"
    sky.SkyboxBk = "rbxassetid://1012890"
    sky.SkyboxDn = "rbxassetid://1012891"
    sky.SkyboxFt = "rbxassetid://1012887"
    sky.SkyboxLf = "rbxassetid://1012889"
    sky.SkyboxRt = "rbxassetid://1012888"
    sky.SkyboxUp = "rbxassetid://1012890"
    sky.StarCount = 1000
    sky.SunAngularSize = 20
    sky.MoonAngularSize = 8
    sky.Parent = Lighting
    self.currentSky = sky
    
    -- Atmosphere
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD3_SunsetAtmo"
    atmo.Density = 0.35
    atmo.Offset = 0.5
    atmo.Color = Color3.fromRGB(255, 180, 120)
    atmo.Decay = Color3.fromRGB(255, 100, 80)
    atmo.Glare = 1.5
    atmo.Haze = 1.5
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    -- Color correction
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD3_SunsetCC"
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = 0.3
    cc.TintColor = Color3.fromRGB(255, 220, 200)
    cc.Parent = Lighting
    self.currentColorCorrection = cc
    
    -- Sun rays
    local rays = Instance.new("SunRaysEffect")
    rays.Name = "VD3_SunsetRays"
    rays.Intensity = 0.15
    rays.Spread = 0.8
    rays.Parent = Lighting
    self.currentSunRays = rays
    
    -- Bloom
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "VD3_SunsetBloom"
    bloom.Intensity = 0.5
    bloom.Size = 40
    bloom.Threshold = 0.85
    bloom.Parent = Lighting
    self.currentBloom = bloom
    
    -- Lighting
    Lighting.Brightness = 2.5
    Lighting.ClockTime = 18.5
    Lighting.Ambient = Color3.fromRGB(180, 120, 100)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 140, 100)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 200, 150)
    Lighting.ColorShift_Bottom = Color3.fromRGB(200, 100, 80)
    Lighting.FogColor = Color3.fromRGB(255, 180, 140)
    Lighting.FogEnd = 3000
    Lighting.FogStart = 200
    
    cfg.skyMode = "sunset"
end

function SkySystem:applyMorning()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then child:Destroy() end
        if child:IsA("Atmosphere") then child:Destroy() end
    end
    
    -- Morning sky
    local sky = Instance.new("Sky")
    sky.Name = "VD3_MorningSky"
    sky.SkyboxBk = "rbxassetid://152670934"
    sky.SkyboxDn = "rbxassetid://152670948"
    sky.SkyboxFt = "rbxassetid://152670899"
    sky.SkyboxLf = "rbxassetid://152670919"
    sky.SkyboxRt = "rbxassetid://152670913"
    sky.SkyboxUp = "rbxassetid://152670943"
    sky.StarCount = 0
    sky.SunAngularSize = 15
    sky.MoonAngularSize = 5
    sky.Parent = Lighting
    self.currentSky = sky
    
    -- Atmosphere
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD3_MorningAtmo"
    atmo.Density = 0.3
    atmo.Offset = 0.4
    atmo.Color = Color3.fromRGB(200, 220, 255)
    atmo.Decay = Color3.fromRGB(150, 180, 220)
    atmo.Glare = 0.8
    atmo.Haze = 1
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    -- Color correction
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD3_MorningCC"
    cc.Brightness = 0.08
    cc.Contrast = 0.05
    cc.Saturation = 0.15
    cc.TintColor = Color3.fromRGB(255, 250, 240)
    cc.Parent = Lighting
    self.currentColorCorrection = cc
    
    -- Bloom
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "VD3_MorningBloom"
    bloom.Intensity = 0.3
    bloom.Size = 25
    bloom.Threshold = 0.9
    bloom.Parent = Lighting
    self.currentBloom = bloom
    
    -- Sun rays
    local rays = Instance.new("SunRaysEffect")
    rays.Name = "VD3_MorningRays"
    rays.Intensity = 0.08
    rays.Spread = 0.6
    rays.Parent = Lighting
    self.currentSunRays = rays
    
    -- Lighting
    Lighting.Brightness = 3
    Lighting.ClockTime = 7
    Lighting.Ambient = Color3.fromRGB(150, 170, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(180, 200, 230)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 250, 230)
    Lighting.ColorShift_Bottom = Color3.fromRGB(200, 210, 230)
    Lighting.FogColor = Color3.fromRGB(220, 230, 255)
    Lighting.FogEnd = 5000
    Lighting.FogStart = 500
    Lighting.GlobalShadows = true
    
    cfg.skyMode = "morning"
end

function SkySystem:applyNight()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then child:Destroy() end
        if child:IsA("Atmosphere") then child:Destroy() end
    end
    
    -- Night sky
    local sky = Instance.new("Sky")
    sky.Name = "VD3_NightSky"
    sky.SkyboxBk = "rbxassetid://12064107"
    sky.SkyboxDn = "rbxassetid://12064152"
    sky.SkyboxFt = "rbxassetid://12064121"
    sky.SkyboxLf = "rbxassetid://12064115"
    sky.SkyboxRt = "rbxassetid://12064131"
    sky.SkyboxUp = "rbxassetid://12064141"
    sky.StarCount = 3000
    sky.MoonAngularSize = 12
    sky.SunAngularSize = 1
    sky.Parent = Lighting
    self.currentSky = sky
    
    -- Atmosphere
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD3_NightAtmo"
    atmo.Density = 0.35
    atmo.Offset = 0.2
    atmo.Color = Color3.fromRGB(30, 40, 70)
    atmo.Decay = Color3.fromRGB(20, 30, 60)
    atmo.Glare = 0.2
    atmo.Haze = 2.5
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    -- Color correction
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD3_NightCC"
    cc.Brightness = -0.1
    cc.Contrast = 0.2
    cc.Saturation = -0.1
    cc.TintColor = Color3.fromRGB(180, 190, 220)
    cc.Parent = Lighting
    self.currentColorCorrection = cc
    
    -- Lighting
    Lighting.Brightness = 0.3
    Lighting.ClockTime = 0
    Lighting.Ambient = Color3.fromRGB(30, 35, 50)
    Lighting.OutdoorAmbient = Color3.fromRGB(40, 50, 80)
    Lighting.FogColor = Color3.fromRGB(20, 25, 40)
    Lighting.FogEnd = 1500
    Lighting.FogStart = 50
    
    cfg.skyMode = "night"
end

function SkySystem:applyDawn()
    self:cleanup()
    
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then child:Destroy() end
        if child:IsA("Atmosphere") then child:Destroy() end
    end
    
    local sky = Instance.new("Sky")
    sky.Name = "VD3_DawnSky"
    sky.SkyboxBk = "rbxassetid://1012890"
    sky.SkyboxDn = "rbxassetid://1012891"
    sky.SkyboxFt = "rbxassetid://1012887"
    sky.SkyboxLf = "rbxassetid://1012889"
    sky.SkyboxRt = "rbxassetid://1012888"
    sky.SkyboxUp = "rbxassetid://1012890"
    sky.StarCount = 500
    sky.SunAngularSize = 18
    sky.MoonAngularSize = 6
    sky.Parent = Lighting
    self.currentSky = sky
    
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VD3_DawnAtmo"
    atmo.Density = 0.32
    atmo.Offset = 0.45
    atmo.Color = Color3.fromRGB(255, 200, 180)
    atmo.Decay = Color3.fromRGB(255, 150, 120)
    atmo.Glare = 1.2
    atmo.Haze = 1.2
    atmo.Parent = Lighting
    self.currentAtmosphere = atmo
    
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VD3_DawnCC"
    cc.Brightness = 0.03
    cc.Contrast = 0.08
    cc.Saturation = 0.25
    cc.TintColor = Color3.fromRGB(255, 235, 220)
    cc.Parent = Lighting
    self.currentColorCorrection = cc
    
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "VD3_DawnBloom"
    bloom.Intensity = 0.4
    bloom.Size = 35
    bloom.Threshold = 0.88
    bloom.Parent = Lighting
    self.currentBloom = bloom
    
    Lighting.Brightness = 2
    Lighting.ClockTime = 6
    Lighting.Ambient = Color3.fromRGB(160, 130, 120)
    Lighting.OutdoorAmbient = Color3.fromRGB(180, 150, 140)
    Lighting.FogColor = Color3.fromRGB(255, 200, 180)
    Lighting.FogEnd = 4000
    Lighting.FogStart = 300
    
    cfg.skyMode = "dawn"
end

SkySystem:backup()

-- ══════════════════════════════════════════════════════════════
-- GOD V2 SYSTEM
-- ══════════════════════════════════════════════════════════════

local GodV2 = {
    active = false,
    clone = nil,
    originalChar = nil,
    originalHRP = nil,
    originalHum = nil,
    cloneHRP = nil,
    cloneHum = nil,
    cloneAnimator = nil,
    conns = {},
    lastSafePos = nil,
    walkSpeed = 16,
    jumpPower = 50,
    isTransitioning = false,
    animationTracks = {}
}

function GodV2:getTransitionDuration()
    local speeds = {[1] = 0.5, [2] = 0.25, [3] = 0.12}
    return speeds[cfg.transitionSpeed] or 0.25
end

function GodV2:cleanup(smoothTransition)
    if self.isTransitioning then return end
    
    local transitionDuration = self:getTransitionDuration()
    
    for _, track in pairs(self.animationTracks) do
        pcall(function() track:Stop() end)
    end
    self.animationTracks = {}
    
    for _, c in pairs(self.conns) do
        if c then pcall(function() c:Disconnect() end) end
    end
    self.conns = {}
    
    if smoothTransition and self.clone and self.originalChar and self.cloneHRP and self.originalHRP then
        self.isTransitioning = true
        local targetCFrame = self.cloneHRP.CFrame
        self.originalHRP.Anchored = false
        
        for _, part in pairs(self.originalChar:GetDescendants()) do
            if part:IsA("BasePart") then
                local origTrans = part:GetAttribute("_GodV2_OrigTrans")
                if part.Name ~= "HumanoidRootPart" then
                    TweenService:Create(part, TweenInfo.new(transitionDuration * 0.5), {
                        Transparency = origTrans or 0
                    }):Play()
                end
                part.CanCollide = true
                part:SetAttribute("_GodV2_OrigTrans", nil)
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                local origTrans = part:GetAttribute("_GodV2_OrigTrans")
                TweenService:Create(part, TweenInfo.new(transitionDuration * 0.5), {
                    Transparency = origTrans or 0
                }):Play()
                part:SetAttribute("_GodV2_OrigTrans", nil)
            end
        end
        
        local startCFrame = self.originalHRP.CFrame
        local elapsed = 0
        
        local transitionConn
        transitionConn = RunService.Heartbeat:Connect(function(dt)
            elapsed = elapsed + dt
            local alpha = math.min(elapsed / transitionDuration, 1)
            local easedAlpha = 1 - math.pow(1 - alpha, 3)
            
            self.originalHRP.CFrame = startCFrame:Lerp(targetCFrame, easedAlpha)
            
            if alpha >= 1 then
                transitionConn:Disconnect()
                self.originalHRP.CFrame = targetCFrame
                
                if self.originalHum then
                    cam.CameraSubject = self.originalHum
                end
                
                if self.clone then
                    for _, part in pairs(self.clone:GetDescendants()) do
                        if part:IsA("BasePart") then
                            TweenService:Create(part, TweenInfo.new(transitionDuration * 0.3), {
                                Transparency = 1
                            }):Play()
                        end
                    end
                    
                    task.delay(transitionDuration * 0.4, function()
                        if self.clone then
                            self.clone:Destroy()
                            self.clone = nil
                        end
                    end)
                end
                
                self.isTransitioning = false
            end
        end)
        
        task.wait(transitionDuration + 0.1)
    else
        if self.clone then
            pcall(function() self.clone:Destroy() end)
            self.clone = nil
        end
        
        if self.originalChar then
            for _, part in pairs(self.originalChar:GetDescendants()) do
                if part:IsA("BasePart") then
                    local origTrans = part:GetAttribute("_GodV2_OrigTrans")
                    if origTrans ~= nil then
                        part.Transparency = origTrans
                        part:SetAttribute("_GodV2_OrigTrans", nil)
                    elseif part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    end
                    part.CanCollide = true
                end
                if part:IsA("Decal") or part:IsA("Texture") then
                    local origTrans = part:GetAttribute("_GodV2_OrigTrans")
                    if origTrans ~= nil then
                        part.Transparency = origTrans
                        part:SetAttribute("_GodV2_OrigTrans", nil)
                    else
                        part.Transparency = 0
                    end
                end
            end
            
            if self.originalHRP then
                self.originalHRP.Anchored = false
                self.originalHRP.CanCollide = true
            end
            
            if self.originalHum then
                cam.CameraSubject = self.originalHum
            end
        end
    end
    
    self.active = false
    self.originalChar = nil
    self.originalHRP = nil
    self.originalHum = nil
    self.cloneHRP = nil
    self.cloneHum = nil
    self.cloneAnimator = nil
    self.lastSafePos = nil
end

function GodV2:cloneCharacter()
    local original = self.originalChar
    if not original then return nil end
    
    local clone = Instance.new("Model")
    clone.Name = "PhantomEntity_" .. plr.UserId .. "_" .. math.random(10000, 99999)
    
    for _, child in pairs(original:GetChildren()) do
        pcall(function()
            if child:IsA("BasePart") or child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
                local cloned = child:Clone()
                for _, desc in pairs(cloned:GetDescendants()) do
                    if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("ModuleScript") then
                        desc:Destroy()
                    end
                end
                cloned.Parent = clone
            end
        end)
    end
    
    local hrp = clone:FindFirstChild("HumanoidRootPart")
    if hrp then clone.PrimaryPart = hrp end
    
    return clone
end

function GodV2:applyCloneTransparency()
    if not self.clone then return end
    local transparency = cfg.cloneTransparency or 0.3
    
    for _, part in pairs(self.clone:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not part:GetAttribute("_CloneOrigTrans") then
                part:SetAttribute("_CloneOrigTrans", part.Transparency)
            end
            local baseTrans = part:GetAttribute("_CloneOrigTrans") or 0
            part.Transparency = math.max(baseTrans, transparency)
        end
        if part:IsA("Decal") or part:IsA("Texture") then
            if not part:GetAttribute("_CloneOrigTrans") then
                part:SetAttribute("_CloneOrigTrans", part.Transparency)
            end
            local baseTrans = part:GetAttribute("_CloneOrigTrans") or 0
            part.Transparency = math.max(baseTrans, transparency * 0.7)
        end
    end
end

function GodV2:setupProtectedHumanoid()
    if not self.clone then return nil end
    
    local existingHum = self.clone:FindFirstChildOfClass("Humanoid")
    if existingHum then existingHum:Destroy() end
    
    local hum = Instance.new("Humanoid")
    hum.Name = "PhantomCore"
    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    hum.BreakJointsOnDeath = false
    hum.WalkSpeed = self.walkSpeed
    hum.JumpPower = self.jumpPower
    
    local disableStates = {
        Enum.HumanoidStateType.Dead,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Physics
    }
    
    for _, state in ipairs(disableStates) do
        pcall(function() hum:SetStateEnabled(state, false) end)
    end
    
    hum.Parent = self.clone
    
    local animator = Instance.new("Animator")
    animator.Parent = hum
    self.cloneAnimator = animator
    
    return hum
end

function GodV2:activate()
    if self.active or self.isTransitioning then return false end
    
    char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    
    self.originalChar = char
    self.originalHRP = char.HumanoidRootPart
    self.originalHum = hum
    self.walkSpeed = hum.WalkSpeed
    self.jumpPower = hum.JumpPower
    self.lastSafePos = self.originalHRP.CFrame
    
    self.clone = self:cloneCharacter()
    if not self.clone then return false end
    
    self.cloneHum = self:setupProtectedHumanoid()
    if not self.cloneHum then
        self.clone:Destroy()
        return false
    end
    
    self.cloneHRP = self.clone:FindFirstChild("HumanoidRootPart")
    if not self.cloneHRP then
        self.clone:Destroy()
        return false
    end
    
    self.clone:SetPrimaryPartCFrame(self.originalHRP.CFrame)
    self.clone.Parent = Workspace
    
    self:applyCloneTransparency()
    
    for _, part in pairs(self.originalChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part:SetAttribute("_GodV2_OrigTrans", part.Transparency)
            part.Transparency = 1
            part.CanCollide = false
        end
        if part:IsA("Decal") or part:IsA("Texture") then
            part:SetAttribute("_GodV2_OrigTrans", part.Transparency)
            part.Transparency = 1
        end
    end
    
    self.originalHRP.Anchored = true
    
    local transitionDuration = self:getTransitionDuration()
    cam.CameraSubject = self.cloneHum
    
    -- Protection systems
    self.conns.healthProtect = RunService.Heartbeat:Connect(function()
        if self.cloneHum then
            if self.cloneHum.Health ~= math.huge then self.cloneHum.Health = math.huge end
            if self.cloneHum.MaxHealth ~= math.huge then self.cloneHum.MaxHealth = math.huge end
        end
    end)
    
    self.conns.stateProtect = self.cloneHum.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Dead or new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown then
            self.cloneHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    
    -- Movement
    self.conns.movement = RunService.RenderStepped:Connect(function()
        if not self.active or not self.cloneHum then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        local camCF = cam.CFrame
        local camLook = (camCF.LookVector * Vector3.new(1, 0, 1))
        local camRight = (camCF.RightVector * Vector3.new(1, 0, 1))
        
        if camLook.Magnitude > 0.01 then camLook = camLook.Unit else camLook = Vector3.new(0, 0, -1) end
        if camRight.Magnitude > 0.01 then camRight = camRight.Unit else camRight = Vector3.new(1, 0, 0) end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRight end
        
        if moveDir.Magnitude > 0.01 then
            self.cloneHum:Move(moveDir.Unit, false)
        else
            self.cloneHum:Move(Vector3.new(0, 0, 0), false)
        end
        
        self.cloneHum.WalkSpeed = cfg.speedHack and cfg.speed or self.walkSpeed
    end)
    
    self.conns.jump = UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not self.active or not self.cloneHum then return end
        if input.KeyCode == Enum.KeyCode.Space then
            local state = self.cloneHum:GetState()
            if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
                self.cloneHum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    
    -- Anchor follow
    self.conns.anchorFollow = RunService.Heartbeat:Connect(function()
        if not self.active or not self.cloneHRP or not self.originalHRP then return end
        
        local clonePos = self.cloneHRP.Position
        local offset = cfg.anchorOffset or 10
        
        self.originalHRP.CFrame = CFrame.new(clonePos.X, clonePos.Y - offset, clonePos.Z)
        self.originalHRP.Anchored = true
        self.originalHRP.Velocity = Vector3.new(0, 0, 0)
        
        if clonePos.Y > -50 then self.lastSafePos = self.cloneHRP.CFrame end
    end)
    
    -- Anti-void
    self.conns.antiVoid = RunService.Heartbeat:Connect(function()
        if not self.active or not self.cloneHRP then return end
        if self.cloneHRP.Position.Y < -100 and self.lastSafePos then
            self.clone:SetPrimaryPartCFrame(self.lastSafePos)
        end
    end)
    
    -- Touch protection
    for _, part in pairs(self.clone:GetDescendants()) do
        if part:IsA("BasePart") then
            self.conns["touch_" .. part.Name .. "_" .. math.random(10000, 99999)] = part.Touched:Connect(function(hit)
                if not self.active then return end
                local hitName = hit.Name:lower()
                if hitName:find("kill") or hitName:find("lava") or hitName:find("death") or hitName:find("damage") or hitName:find("trap") then
                    if self.cloneHRP and self.lastSafePos then
                        self.clone:SetPrimaryPartCFrame(self.lastSafePos + Vector3.new(0, 3, 0))
                    end
                    if self.cloneHum then self.cloneHum.Health = math.huge end
                end
            end)
        end
    end
    
    self.active = true
    return true
end

function GodV2:toggle()
    if self.isTransitioning then return self.active end
    
    if self.active then
        self:cleanup(true)
        cfg.godV2 = false
        return false
    else
        local success = self:activate()
        if success then cfg.godV2 = true end
        return success
    end
end

function GodV2:onCharacterAdded(newChar)
    local wasActive = self.active or cfg.godV2
    if self.active then self:cleanup(false) end
    
    task.wait(1.5)
    char = newChar
    
    if wasActive and cfg.godV2 then
        task.wait(0.5)
        self:activate()
    end
end

function GodV2:updateConfig()
    if self.active then self:applyCloneTransparency() end
end

-- ══════════════════════════════════════════════════════════════
-- PROFESSIONAL COLOR PALETTE
-- ══════════════════════════════════════════════════════════════

local col = {
    -- Base colors (very dark, minimal)
    bg = Color3.fromRGB(12, 12, 14),
    bgSecondary = Color3.fromRGB(16, 16, 19),
    surface = Color3.fromRGB(20, 20, 24),
    surfaceHover = Color3.fromRGB(26, 26, 31),
    card = Color3.fromRGB(24, 24, 28),
    cardHover = Color3.fromRGB(30, 30, 36),
    elevated = Color3.fromRGB(32, 32, 38),
    
    -- Border colors
    border = Color3.fromRGB(40, 40, 48),
    borderLight = Color3.fromRGB(52, 52, 62),
    borderActive = Color3.fromRGB(65, 75, 95),
    
    -- Text colors
    text = Color3.fromRGB(220, 220, 225),
    textSecondary = Color3.fromRGB(160, 160, 170),
    textMuted = Color3.fromRGB(100, 100, 112),
    textDim = Color3.fromRGB(70, 70, 80),
    
    -- Accent colors (muted, professional)
    accent = Color3.fromRGB(75, 95, 130),
    accentHover = Color3.fromRGB(90, 115, 155),
    accentMuted = Color3.fromRGB(55, 70, 95),
    accentGlow = Color3.fromRGB(100, 125, 165),
    
    -- State colors
    success = Color3.fromRGB(60, 120, 85),
    successGlow = Color3.fromRGB(75, 145, 100),
    error = Color3.fromRGB(130, 60, 65),
    errorGlow = Color3.fromRGB(160, 75, 80),
    warning = Color3.fromRGB(140, 115, 55),
    warningGlow = Color3.fromRGB(170, 140, 70),
    
    -- Toggle colors
    toggleOff = Color3.fromRGB(42, 42, 50),
    toggleOn = Color3.fromRGB(55, 95, 75),
    toggleKnobOff = Color3.fromRGB(90, 90, 100),
    toggleKnobOn = Color3.fromRGB(120, 180, 145),
    
    -- Special
    phantom = Color3.fromRGB(85, 105, 145),
    phantomGlow = Color3.fromRGB(110, 135, 180),
    sky = Color3.fromRGB(70, 100, 140),
    skyGlow = Color3.fromRGB(95, 130, 175)
}

-- ══════════════════════════════════════════════════════════════
-- TWEEN PRESETS
-- ══════════════════════════════════════════════════════════════

local tween = {
    instant = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    fast = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    normal = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    smooth = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    bounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    elastic = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    spring = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
}

-- ══════════════════════════════════════════════════════════════
-- GUI HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════

local function getParent()
    local s, r = pcall(function() return gethui() end)
    return s and r or CoreGui
end

local function createRipple(parent, x, y, color)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = color or col.accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0, x - 5, 0, y - 5)
    ripple.Size = UDim2.new(0, 10, 0, 10)
    ripple.ZIndex = parent.ZIndex + 5
    ripple.Parent = parent
    
    local corner = Instance.new("UICorner", ripple)
    corner.CornerRadius = UDim.new(1, 0)
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    
    TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, x - maxSize/2, 0, y - maxSize/2),
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(0.55, function()
        ripple:Destroy()
    end)
end

local function addHoverEffect(element, options)
    options = options or {}
    local scaleUp = options.scale or 1
    local bgColor = options.bgColor
    local borderColor = options.borderColor
    local textColor = options.textColor
    local glowElement = options.glow
    
    element.MouseEnter:Connect(function()
        if scaleUp ~= 1 then
            TweenService:Create(element, tween.fast, {Size = element.Size * scaleUp}):Play()
        end
        if bgColor then
            TweenService:Create(element, tween.fast, {BackgroundTransparency = bgColor}):Play()
        end
        if borderColor and element:FindFirstChildOfClass("UIStroke") then
            TweenService:Create(element:FindFirstChildOfClass("UIStroke"), tween.fast, {Color = borderColor}):Play()
        end
        if glowElement then
            TweenService:Create(glowElement, tween.normal, {ImageTransparency = 0.7}):Play()
        end
    end)
    
    element.MouseLeave:Connect(function()
        if scaleUp ~= 1 then
            TweenService:Create(element, tween.fast, {Size = element.Size / scaleUp}):Play()
        end
        if bgColor then
            TweenService:Create(element, tween.fast, {BackgroundTransparency = options.bgOriginal or 0.3}):Play()
        end
        if borderColor and element:FindFirstChildOfClass("UIStroke") then
            TweenService:Create(element:FindFirstChildOfClass("UIStroke"), tween.fast, {Color = options.borderOriginal or col.border}):Play()
        end
        if glowElement then
            TweenService:Create(glowElement, tween.normal, {ImageTransparency = 0.92}):Play()
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- MAIN GUI CREATION
-- ══════════════════════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "VD3_Premium_" .. math.random(10000, 99999)
gui.Parent = getParent()
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = gui
toggleBtn.BackgroundColor3 = col.surface
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.ZIndex = 100

if savedData and savedData.togglePos then
    toggleBtn.Position = UDim2.new(0, savedData.togglePos.x, savedData.togglePos.y, -22)
else
    toggleBtn.Position = UDim2.new(0, 16, 0.5, -22)
end
toggleBtn.Size = UDim2.new(0, 44, 0, 44)

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 12)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = col.border
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.5

local toggleGlow = Instance.new("ImageLabel", toggleBtn)
toggleGlow.BackgroundTransparency = 1
toggleGlow.Size = UDim2.new(1, 35, 1, 35)
toggleGlow.Position = UDim2.new(0, -17, 0, -17)
toggleGlow.Image = "rbxassetid://5028857084"
toggleGlow.ImageColor3 = col.accent
toggleGlow.ImageTransparency = 0.92
toggleGlow.ZIndex = 99

local toggleIcon = Instance.new("TextLabel", toggleBtn)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Text = "V"
toggleIcon.TextColor3 = col.textMuted
toggleIcon.TextSize = 18
toggleIcon.ZIndex = 101

-- Subtle breathing animation for toggle button
task.spawn(function()
    while gui.Parent do
        TweenService:Create(toggleGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.85
        }):Play()
        task.wait(2)
        TweenService:Create(toggleGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.95
        }):Play()
        task.wait(2)
    end
end)

-- Drag system
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
    TweenService:Create(toggleStroke, tween.fast, {Color = col.accentGlow, Transparency = 0}):Play()
    TweenService:Create(toggleIcon, tween.fast, {TextColor3 = col.text}):Play()
    TweenService:Create(toggleBtn, tween.bounce, {Size = UDim2.new(0, 48, 0, 48)}):Play()
    TweenService:Create(toggleGlow, tween.fast, {ImageTransparency = 0.6}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, tween.fast, {Color = col.border, Transparency = 0.5}):Play()
    TweenService:Create(toggleIcon, tween.fast, {TextColor3 = col.textMuted}):Play()
    TweenService:Create(toggleBtn, tween.bounce, {Size = UDim2.new(0, 44, 0, 44)}):Play()
    TweenService:Create(toggleGlow, tween.fast, {ImageTransparency = 0.92}):Play()
end)

-- Main Window
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

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = col.border
mainStroke.Thickness = 1
mainStroke.Transparency = 1

local mainShadow = Instance.new("ImageLabel", main)
mainShadow.BackgroundTransparency = 1
mainShadow.Size = UDim2.new(1, 80, 1, 80)
mainShadow.Position = UDim2.new(0, -40, 0, -40)
mainShadow.Image = "rbxassetid://5028857084"
mainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
mainShadow.ImageTransparency = 1
mainShadow.ZIndex = 9

-- Header
local header = Instance.new("Frame", main)
header.Name = "Header"
header.BackgroundColor3 = col.bgSecondary
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 42)
header.ZIndex = 12

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 14)

local headerFix = Instance.new("Frame", header)
headerFix.BackgroundColor3 = col.bgSecondary
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.ZIndex = 12

local headerLine = Instance.new("Frame", header)
headerLine.BackgroundColor3 = col.border
headerLine.BackgroundTransparency = 0.5
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.ZIndex = 12

-- Logo
local logoContainer = Instance.new("Frame", header)
logoContainer.BackgroundTransparency = 1
logoContainer.Position = UDim2.new(0, 14, 0, 0)
logoContainer.Size = UDim2.new(0, 180, 1, 0)
logoContainer.ZIndex = 13

local logoIcon = Instance.new("TextLabel", logoContainer)
logoIcon.BackgroundTransparency = 1
logoIcon.Position = UDim2.new(0, 0, 0.5, -10)
logoIcon.Size = UDim2.new(0, 20, 0, 20)
logoIcon.Font = Enum.Font.GothamBold
logoIcon.Text = "◆"
logoIcon.TextColor3 = col.accent
logoIcon.TextSize = 14
logoIcon.ZIndex = 14

local logoText = Instance.new("TextLabel", logoContainer)
logoText.BackgroundTransparency = 1
logoText.Position = UDim2.new(0, 26, 0, 0)
logoText.Size = UDim2.new(0, 120, 1, 0)
logoText.Font = Enum.Font.GothamBold
logoText.Text = "ikaxzu premium"
logoText.TextColor3 = col.text
logoText.TextSize = 13
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.ZIndex = 14

local versionBadge = Instance.new("Frame", logoContainer)
versionBadge.BackgroundColor3 = col.accentMuted
versionBadge.BackgroundTransparency = 0.7
versionBadge.Position = UDim2.new(0, 128, 0.5, -9)
versionBadge.Size = UDim2.new(0, 28, 0, 18)
versionBadge.ZIndex = 14
Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0, 5)

local versionText = Instance.new("TextLabel", versionBadge)
versionText.BackgroundTransparency = 1
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.Font = Enum.Font.GothamBold
versionText.Text = "v3"
versionText.TextColor3 = col.accent
versionText.TextSize = 9
versionText.ZIndex = 15

-- Window controls
local controlsContainer = Instance.new("Frame", header)
controlsContainer.BackgroundTransparency = 1
controlsContainer.Position = UDim2.new(1, -70, 0, 0)
controlsContainer.Size = UDim2.new(0, 60, 1, 0)
controlsContainer.ZIndex = 13

local minBtn = Instance.new("TextButton", controlsContainer)
minBtn.BackgroundColor3 = col.surface
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(0, 0, 0.5, -12)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Text = ""
minBtn.AutoButtonColor = false
minBtn.ZIndex = 14
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local minIcon = Instance.new("TextLabel", minBtn)
minIcon.BackgroundTransparency = 1
minIcon.Size = UDim2.new(1, 0, 1, 0)
minIcon.Font = Enum.Font.GothamBold
minIcon.Text = "−"
minIcon.TextColor3 = col.textDim
minIcon.TextSize = 16
minIcon.ZIndex = 15

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, tween.fast, {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(minIcon, tween.fast, {TextColor3 = col.warning}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, tween.fast, {BackgroundTransparency = 1}):Play()
    TweenService:Create(minIcon, tween.fast, {TextColor3 = col.textDim}):Play()
end)

local closeBtn = Instance.new("TextButton", controlsContainer)
closeBtn.BackgroundColor3 = col.surface
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0, 30, 0.5, -12)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Text = ""
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local closeIcon = Instance.new("TextLabel", closeBtn)
closeIcon.BackgroundTransparency = 1
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.Font = Enum.Font.GothamBold
closeIcon.Text = "×"
closeIcon.TextColor3 = col.textDim
closeIcon.TextSize = 18
closeIcon.ZIndex = 15

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, tween.fast, {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(closeIcon, tween.fast, {TextColor3 = col.error}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, tween.fast, {BackgroundTransparency = 1}):Play()
    TweenService:Create(closeIcon, tween.fast, {TextColor3 = col.textDim}):Play()
end)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = col.bgSecondary
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.Size = UDim2.new(0, 100, 1, -42)
sidebar.ZIndex = 11

local sidebarLine = Instance.new("Frame", sidebar)
sidebarLine.BackgroundColor3 = col.border
sidebarLine.BackgroundTransparency = 0.5
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 0)
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.ZIndex = 11

local tabContainer = Instance.new("Frame", sidebar)
tabContainer.BackgroundTransparency = 1
tabContainer.Position = UDim2.new(0, 8, 0, 12)
tabContainer.Size = UDim2.new(1, -16, 1, -24)
tabContainer.ZIndex = 12

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.Padding = UDim.new(0, 3)

-- Content area
local content = Instance.new("Frame", main)
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 108, 0, 50)
content.Size = UDim2.new(1, -116, 1, -58)
content.ZIndex = 11

-- Notification container
local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "Notifications"
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -250, 0, 14)
notifContainer.Size = UDim2.new(0, 240, 0, 250)
notifContainer.ZIndex = 200

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

-- ══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════════════════════════════════

local function notify(msg, duration, notifType)
    local notifColor = col.accent
    local icon = "●"
    
    if notifType == "success" then 
        notifColor = col.success
        icon = "✓"
    elseif notifType == "error" then 
        notifColor = col.error
        icon = "✕"
    elseif notifType == "warn" then 
        notifColor = col.warning
        icon = "!"
    elseif notifType == "phantom" then 
        notifColor = col.phantom
        icon = "◈"
    elseif notifType == "sky" then
        notifColor = col.sky
        icon = "☀"
    end

    local notif = Instance.new("Frame", notifContainer)
    notif.BackgroundColor3 = col.surface
    notif.BackgroundTransparency = 0.05
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, 0, 0, 38)
    notif.ClipsDescendants = true
    notif.ZIndex = 201

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
    
    local notifStroke = Instance.new("UIStroke", notif)
    notifStroke.Color = notifColor
    notifStroke.Thickness = 1
    notifStroke.Transparency = 0.8

    local accentBar = Instance.new("Frame", notif)
    accentBar.BackgroundColor3 = notifColor
    accentBar.BorderSizePixel = 0
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 10)

    local iconLabel = Instance.new("TextLabel", notif)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 0)
    iconLabel.Size = UDim2.new(0, 20, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextColor3 = notifColor
    iconLabel.TextSize = 13
    iconLabel.TextTransparency = 1
    iconLabel.ZIndex = 202

    local msgLabel = Instance.new("TextLabel", notif)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Position = UDim2.new(0, 38, 0, 0)
    msgLabel.Size = UDim2.new(1, -50, 1, 0)
    msgLabel.Font = Enum.Font.GothamMedium
    msgLabel.Text = msg
    msgLabel.TextColor3 = col.text
    msgLabel.TextSize = 11
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextTransparency = 1
    msgLabel.ZIndex = 202

    -- Animate in
    TweenService:Create(notif, tween.bounce, {Size = UDim2.new(0, 220, 0, 38)}):Play()
    task.delay(0.08, function()
        TweenService:Create(iconLabel, tween.fast, {TextTransparency = 0}):Play()
        TweenService:Create(msgLabel, tween.fast, {TextTransparency = 0}):Play()
        TweenService:Create(notifStroke, tween.normal, {Transparency = 0.4}):Play()
    end)

    -- Animate out
    task.delay(duration or 2.5, function()
        TweenService:Create(iconLabel, tween.fast, {TextTransparency = 1}):Play()
        TweenService:Create(msgLabel, tween.fast, {TextTransparency = 1}):Play()
        TweenService:Create(notif, tween.normal, {
            Size = UDim2.new(0, 0, 0, 38),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.25)
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
    {id = "esp", name = "ESP", icon = "◎"},
    {id = "sky", name = "Sky", icon = "☀"},
    {id = "players", name = "Players", icon = "♦"},
    {id = "about", name = "About", icon = "✦"},
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
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = col.accent
    page.ScrollBarImageTransparency = 0.6
    page.Visible = false
    page.ZIndex = 12
    page.ScrollingDirection = Enum.ScrollingDirection.Y

    local padding = Instance.new("UIPadding", page)
    padding.PaddingRight = UDim.new(0, 4)

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    pages[id] = page
    return page
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id
    btn.Parent = tabContainer
    btn.BackgroundColor3 = col.card
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 13

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = col.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.5, -8)
    indicator.Size = UDim2.new(0, 2, 0, 0)
    indicator.ZIndex = 14
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.Size = UDim2.new(0, 18, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = tab.icon
    iconLabel.TextColor3 = col.textDim
    iconLabel.TextSize = 11
    iconLabel.ZIndex = 14

    local nameLabel = Instance.new("TextLabel", btn)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 30, 0, 0)
    nameLabel.Size = UDim2.new(1, -35, 1, 0)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.Text = tab.name
    nameLabel.TextColor3 = col.textDim
    nameLabel.TextSize = 11
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14

    local page = createPage(tab.id)
    tabButtons[tab.id] = {btn = btn, icon = iconLabel, text = nameLabel, indicator = indicator}

    btn.MouseButton1Click:Connect(function()
        if activeTab == tab.id then return end
        
        -- Deactivate all tabs
        for id, data in pairs(tabButtons) do
            TweenService:Create(data.btn, tween.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.icon, tween.fast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.text, tween.fast, {TextColor3 = col.textDim}):Play()
            TweenService:Create(data.indicator, tween.normal, {Size = UDim2.new(0, 2, 0, 0)}):Play()
            pages[id].Visible = false
        end

        -- Activate selected tab
        TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(iconLabel, tween.fast, {TextColor3 = col.accent}):Play()
        TweenService:Create(nameLabel, tween.fast, {TextColor3 = col.text}):Play()
        TweenService:Create(indicator, tween.bounce, {Size = UDim2.new(0, 2, 0, 16)}):Play()
        
        page.Visible = true
        activeTab = tab.id
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.7}):Play()
            TweenService:Create(iconLabel, tween.fast, {TextColor3 = col.textMuted}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if activeTab ~= tab.id then
            TweenService:Create(btn, tween.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(iconLabel, tween.fast, {TextColor3 = col.textDim}):Play()
        end
    end)

    -- Set first tab as active
    if i == 1 then
        btn.BackgroundTransparency = 0.5
        iconLabel.TextColor3 = col.accent
        nameLabel.TextColor3 = col.text
        indicator.Size = UDim2.new(0, 2, 0, 16)
        page.Visible = true
        activeTab = tab.id
    end
end

-- ══════════════════════════════════════════════════════════════
-- UI COMPONENT BUILDERS
-- ══════════════════════════════════════════════════════════════

local function createSection(parent, text)
    local section = Instance.new("Frame", parent)
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, 0, 0, 22)
    section.ZIndex = 13

    local label = Instance.new("TextLabel", section)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 2, 0, 2)
    label.Size = UDim2.new(1, -4, 1, -4)
    label.Font = Enum.Font.GothamBold
    label.Text = text:upper()
    label.TextColor3 = col.textDim
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    
    return section
end

local function createToggle(parent, text, cfgKey, callback)
    local state = cfg[cfgKey] or false

    local container = Instance.new("TextButton", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 38)
    container.Text = ""
    container.AutoButtonColor = false
    container.ZIndex = 13

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 9)

    local containerStroke = Instance.new("UIStroke", container)
    containerStroke.Color = col.border
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.7

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14

    local switch = Instance.new("Frame", container)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.BackgroundColor3 = col.toggleOff
    switch.BorderSizePixel = 0
    switch.Position = UDim2.new(1, -12, 0.5, 0)
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.ZIndex = 14
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = col.toggleKnobOff
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.ZIndex = 15
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function updateVisual(animate)
        local tweenInfo = animate and tween.bounce or TweenInfo.new(0)
        
        if state then
            TweenService:Create(switch, animate and tween.normal or tweenInfo, {BackgroundColor3 = col.toggleOn}):Play()
            TweenService:Create(knob, tweenInfo, {Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = col.toggleKnobOn}):Play()
            TweenService:Create(label, animate and tween.fast or tweenInfo, {TextColor3 = col.text}):Play()
            TweenService:Create(containerStroke, animate and tween.fast or tweenInfo, {Color = col.success, Transparency = 0.5}):Play()
        else
            TweenService:Create(switch, animate and tween.normal or tweenInfo, {BackgroundColor3 = col.toggleOff}):Play()
            TweenService:Create(knob, tweenInfo, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = col.toggleKnobOff}):Play()
            TweenService:Create(label, animate and tween.fast or tweenInfo, {TextColor3 = col.textSecondary}):Play()
            TweenService:Create(containerStroke, animate and tween.fast or tweenInfo, {Color = col.border, Transparency = 0.7}):Play()
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
        TweenService:Create(container, tween.fast, {BackgroundTransparency = 0.2}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tween.fast, {BackgroundTransparency = 0.4}):Play()
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

local function createSlider(parent, text, min, max, cfgKey, callback, isFloat)
    local val = cfg[cfgKey] or min
    local dragging = false

    local container = Instance.new("Frame", parent)
    container.BackgroundColor3 = col.card
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 50)
    container.ZIndex = 13

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 9)

    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 6)
    label.Size = UDim2.new(0.65, 0, 0, 16)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = col.textSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14

    local valueBg = Instance.new("Frame", container)
    valueBg.BackgroundColor3 = col.accentMuted
    valueBg.BackgroundTransparency = 0.7
    valueBg.Position = UDim2.new(1, -50, 0, 6)
    valueBg.Size = UDim2.new(0, 38, 0, 18)
    valueBg.ZIndex = 14
    Instance.new("UICorner", valueBg).CornerRadius = UDim.new(0, 5)

    local valueLabel = Instance.new("TextLabel", valueBg)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = isFloat and string.format("%.1f", val) or tostring(val)
    valueLabel.TextColor3 = col.accent
    valueLabel.TextSize = 10
    valueLabel.ZIndex = 15

    local track = Instance.new("Frame", container)
    track.BackgroundColor3 = col.elevated
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 14, 0, 32)
    track.Size = UDim2.new(1, -28, 0, 6)
    track.ZIndex = 14
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.BackgroundColor3 = col.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.ZIndex = 15
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.BackgroundColor3 = col.text
    knob.BorderSizePixel = 0
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.ZIndex = 16
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hitArea = Instance.new("TextButton", track)
    hitArea.BackgroundTransparency = 1
    hitArea.Size = UDim2.new(1, 0, 1, 12)
    hitArea.Position = UDim2.new(0, 0, 0, -6)
    hitArea.Text = ""
    hitArea.ZIndex = 17

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        
        if isFloat then
            val = min + (max - min) * pos
            val = math.floor(val * 10) / 10
        else
            val = math.floor(min + (max - min) * pos)
        end
        
        cfg[cfgKey] = val
        
        TweenService:Create(fill, tween.instant, {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        TweenService:Create(knob, tween.instant, {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
        
        valueLabel.Text = isFloat and string.format("%.1f", val) or tostring(val)
        pcall(callback, val)
    end

    hitArea.MouseButton1Down:Connect(function() 
        dragging = true 
        TweenService:Create(knob, tween.fast, {Size = UDim2.new(0, 14, 0, 14)}):Play()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            TweenService:Create(knob, tween.fast, {Size = UDim2.new(0, 12, 0, 12)}):Play()
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
        TweenService:Create(container, tween.fast, {BackgroundTransparency = 0.2}):Play()
    end)
    
    container.MouseLeave:Connect(function()
        TweenService:Create(container, tween.fast, {BackgroundTransparency = 0.4}):Play()
    end)
    
    return {
        setValue = function(newVal)
            val = newVal
            cfg[cfgKey] = val
            local pos = (val - min) / (max - min)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            knob.Position = UDim2.new(pos, 0, 0.5, 0)
            valueLabel.Text = isFloat and string.format("%.1f", val) or tostring(val)
        end
    }
end

local function createButton(parent, text, callback, icon)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = col.card
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    btn.ClipsDescendants = true

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

    if icon then
        local iconLabel = Instance.new("TextLabel", btn)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 14, 0, 0)
        iconLabel.Size = UDim2.new(0, 18, 1, 0)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Text = icon
        iconLabel.TextColor3 = col.accent
        iconLabel.TextSize = 12
        iconLabel.ZIndex = 14
    end

    local textLabel = Instance.new("TextLabel", btn)
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, icon and 36 or 14, 0, 0)
    textLabel.Size = UDim2.new(1, icon and -50 or -28, 1, 0)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.Text = text
    textLabel.TextColor3 = col.textSecondary
    textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 14

    btn.MouseButton1Click:Connect(function()
        -- Ripple effect
        local mousePos = UserInputService:GetMouseLocation()
        local relX = mousePos.X - btn.AbsolutePosition.X
        local relY = mousePos.Y - btn.AbsolutePosition.Y
        createRipple(btn, relX, relY, col.accent)
        
        pcall(callback)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(textLabel, tween.fast, {TextColor3 = col.text}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(textLabel, tween.fast, {TextColor3 = col.textSecondary}):Play()
    end)

    return btn
end

local function createSkyButton(parent, text, skyType, icon, description)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = col.card
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 55)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    btn.ClipsDescendants = true

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = col.border
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 0)
    iconLabel.Size = UDim2.new(0, 28, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextColor3 = col.sky
    iconLabel.TextSize = 18
    iconLabel.ZIndex = 14

    local titleLabel = Instance.new("TextLabel", btn)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 50, 0, 10)
    titleLabel.Size = UDim2.new(1, -100, 0, 18)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = text
    titleLabel.TextColor3 = col.text
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 14

    local descLabel = Instance.new("TextLabel", btn)
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 50, 0, 28)
    descLabel.Size = UDim2.new(1, -60, 0, 16)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = col.textDim
    descLabel.TextSize = 9
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 14

    local activeIndicator = Instance.new("Frame", btn)
    activeIndicator.BackgroundColor3 = col.success
    activeIndicator.BackgroundTransparency = 1
    activeIndicator.Position = UDim2.new(1, -30, 0.5, -5)
    activeIndicator.Size = UDim2.new(0, 10, 0, 10)
    activeIndicator.ZIndex = 15
    Instance.new("UICorner", activeIndicator).CornerRadius = UDim.new(1, 0)

    local function updateActive()
        if cfg.skyMode == skyType then
            TweenService:Create(activeIndicator, tween.fast, {BackgroundTransparency = 0}):Play()
            TweenService:Create(btnStroke, tween.fast, {Color = col.sky, Transparency = 0.3}):Play()
        else
            TweenService:Create(activeIndicator, tween.fast, {BackgroundTransparency = 1}):Play()
            TweenService:Create(btnStroke, tween.fast, {Color = col.border, Transparency = 0.6}):Play()
        end
    end

    btn.MouseButton1Click:Connect(function()
        createRipple(btn, btn.AbsoluteSize.X / 2, btn.AbsoluteSize.Y / 2, col.sky)
        
        if skyType == "default" then
            SkySystem:restore()
            notify("sky restored to default", 2, "sky")
        elseif skyType == "galaxy" then
            SkySystem:applyGalaxy()
            notify("galaxy sky applied", 2, "sky")
        elseif skyType == "sunset" then
            SkySystem:applySunset()
            notify("sunset sky applied", 2, "sky")
        elseif skyType == "morning" then
            SkySystem:applyMorning()
            notify("morning sky applied", 2, "sky")
        elseif skyType == "night" then
            SkySystem:applyNight()
            notify("night sky applied", 2, "sky")
        elseif skyType == "dawn" then
            SkySystem:applyDawn()
            notify("dawn sky applied", 2, "sky")
        end
        
        task.spawn(saveSettings)
        
        -- Update all sky buttons
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                local indicator = child:FindFirstChild("Frame")
                local stroke = child:FindFirstChildOfClass("UIStroke")
                if indicator and stroke then
                    -- Will be updated by each button's updateActive
                end
            end
        end
        updateActive()
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(iconLabel, tween.fast, {TextColor3 = col.skyGlow}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(iconLabel, tween.fast, {TextColor3 = col.sky}):Play()
    end)

    updateActive()
    
    return {updateActive = updateActive}
end

local function createInfoCard(parent, title, value, icon)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = col.card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, 50)
    card.ZIndex = 13
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local iconLabel = Instance.new("TextLabel", card)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 14, 0, 0)
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon or "●"
    iconLabel.TextColor3 = col.accent
    iconLabel.TextSize = 16
    iconLabel.ZIndex = 14

    local titleLabel = Instance.new("TextLabel", card)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.Size = UDim2.new(1, -60, 0, 16)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Text = title
    titleLabel.TextColor3 = col.textSecondary
    titleLabel.TextSize = 10
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 14

    local valueLabel = Instance.new("TextLabel", card)
    valueLabel.Name = "Value"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 50, 0, 24)
    valueLabel.Size = UDim2.new(1, -60, 0, 18)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = value
    valueLabel.TextColor3 = col.text
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.ZIndex = 14

    return card
end

local function createTextBlock(parent, text)
    local container = Instance.new("Frame", parent)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ZIndex = 13

    local textLabel = Instance.new("TextLabel", container)
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 6, 0, 4)
    textLabel.Size = UDim2.new(1, -12, 0, 0)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text
    textLabel.TextColor3 = col.textMuted
    textLabel.TextSize = 10
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.RichText = true
    textLabel.ZIndex = 14
    
    return container
end

-- ══════════════════════════════════════════════════════════════
-- CORE FUNCTIONS
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
    
    if conn.godH then conn.godH:Disconnect() end
    if conn.godL then conn.godL:Disconnect() end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = 100
        hum.Health = 100
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
    plr.Idled:Connect(function()
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
        bb.Size = UDim2.new(0, 65, 0, 24)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        
        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = col.bg
        bg.BackgroundTransparency = 0.2
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        
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
        hl.FillColor = col.accent
        hl.OutlineColor = col.text
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.4
        
        espData[player] = {obj = hl, type = "highlight"}
        
    elseif cfg.espMode == 3 then
        local box = Instance.new("BoxHandleAdornment", hrp)
        box.Size = ch:GetExtentsSize()
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = col.accent
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
-- PAGE CONTENT CREATION
-- ══════════════════════════════════════════════════════════════

-- HOME PAGE
local homePage = pages["home"]

createSection(homePage, "Player Info")

local playerCard = Instance.new("Frame", homePage)
playerCard.BackgroundColor3 = col.card
playerCard.BackgroundTransparency = 0.2
playerCard.Size = UDim2.new(1, 0, 0, 60)
playerCard.ZIndex = 13
Instance.new("UICorner", playerCard).CornerRadius = UDim.new(0, 10)

local avatar = Instance.new("ImageLabel", playerCard)
avatar.BackgroundColor3 = col.elevated
avatar.Position = UDim2.new(0, 12, 0.5, -20)
avatar.Size = UDim2.new(0, 40, 0, 40)
avatar.ZIndex = 14
Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 10)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local playerName = Instance.new("TextLabel", playerCard)
playerName.BackgroundTransparency = 1
playerName.Position = UDim2.new(0, 62, 0, 12)
playerName.Size = UDim2.new(1, -75, 0, 18)
playerName.Font = Enum.Font.GothamBold
playerName.Text = plr.Name
playerName.TextColor3 = col.text
playerName.TextSize = 14
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.ZIndex = 14

local gameInfo = Instance.new("TextLabel", playerCard)
gameInfo.BackgroundTransparency = 1
gameInfo.Position = UDim2.new(0, 62, 0, 32)
gameInfo.Size = UDim2.new(1, -75, 0, 14)
gameInfo.Font = Enum.Font.Gotham
gameInfo.Text = "violence district • premium"
gameInfo.TextColor3 = col.textDim
gameInfo.TextSize = 10
gameInfo.TextXAlignment = Enum.TextXAlignment.Left
gameInfo.ZIndex = 14

createSection(homePage, "Quick Actions")

createButton(homePage, "Reset Character", function()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    notify("character reset", 2, "success")
end, "↺")

createButton(homePage, "Rejoin Server", function()
    notify("rejoining...", 2, "warn")
    task.wait(0.5)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end, "⟳")

createButton(homePage, "Server Hop", function()
    notify("finding server...", 2, "warn")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, plr)
end, "⇄")

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
        notify("no ragdoll enabled", 2, "success")
    else
        if conn.noRagdoll then conn.noRagdoll:Disconnect() end
        notify("no ragdoll disabled", 2)
    end
end)

createToggle(homePage, "Anti Void", "antiVoid", function(v)
    if v then
        local safePos = char.HumanoidRootPart.CFrame
        conn.antiVoid2 = RunService.Heartbeat:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp.Position.Y > -50 then safePos = hrp.CFrame end
                if hrp.Position.Y < -100 then hrp.CFrame = safePos end
            end
        end)
        notify("anti void enabled", 2, "success")
    else
        if conn.antiVoid2 then conn.antiVoid2:Disconnect() end
        notify("anti void disabled", 2)
    end
end)

createToggle(homePage, "Low Gravity", "lowGravity", function(v)
    Workspace.Gravity = v and 50 or defaultGravity
    notify(v and "low gravity enabled" or "gravity restored", 2, v and "success" or nil)
end)

createToggle(homePage, "Anti AFK", "antiAfk", function(v)
    if v then setupAntiAFK() notify("anti afk enabled", 2, "success")
    else notify("anti afk disabled", 2) end
end)

-- COMBAT PAGE
local combatPage = pages["combat"]

createSection(combatPage, "Protection")

createToggle(combatPage, "God Mode", "god", function(v)
    if v then enableGod() notify("god mode enabled", 2, "success")
    else disableGod() notify("god mode disabled", 2) end
end)

createSection(combatPage, "God V2 • Phantom System")

-- God V2 Card
local godV2Card = Instance.new("Frame", combatPage)
godV2Card.BackgroundColor3 = col.card
godV2Card.BackgroundTransparency = 0.1
godV2Card.Size = UDim2.new(1, 0, 0, 95)
godV2Card.ZIndex = 13
Instance.new("UICorner", godV2Card).CornerRadius = UDim.new(0, 12)

local godV2Stroke = Instance.new("UIStroke", godV2Card)
godV2Stroke.Color = col.phantomGlow
godV2Stroke.Thickness = 1
godV2Stroke.Transparency = 0.6

local godV2Icon = Instance.new("TextLabel", godV2Card)
godV2Icon.BackgroundTransparency = 1
godV2Icon.Position = UDim2.new(0, 14, 0, 14)
godV2Icon.Size = UDim2.new(0, 24, 0, 24)
godV2Icon.Font = Enum.Font.GothamBold
godV2Icon.Text = "◈"
godV2Icon.TextColor3 = col.phantom
godV2Icon.TextSize = 18
godV2Icon.ZIndex = 14

local godV2Title = Instance.new("TextLabel", godV2Card)
godV2Title.BackgroundTransparency = 1
godV2Title.Position = UDim2.new(0, 44, 0, 12)
godV2Title.Size = UDim2.new(0, 80, 0, 18)
godV2Title.Font = Enum.Font.GothamBold
godV2Title.Text = "GOD V2"
godV2Title.TextColor3 = col.text
godV2Title.TextSize = 13
godV2Title.TextXAlignment = Enum.TextXAlignment.Left
godV2Title.ZIndex = 14

local godV2Desc = Instance.new("TextLabel", godV2Card)
godV2Desc.BackgroundTransparency = 1
godV2Desc.Position = UDim2.new(0, 14, 0, 42)
godV2Desc.Size = UDim2.new(1, -28, 0, 28)
godV2Desc.Font = Enum.Font.Gotham
godV2Desc.Text = "creates phantom clone as active avatar. immune to damage, kill bricks, and death."
godV2Desc.TextColor3 = col.textDim
godV2Desc.TextSize = 9
godV2Desc.TextWrapped = true
godV2Desc.TextXAlignment = Enum.TextXAlignment.Left
godV2Desc.ZIndex = 14

-- Toggle switch for God V2
local godV2Switch = Instance.new("TextButton", godV2Card)
godV2Switch.BackgroundColor3 = col.toggleOff
godV2Switch.Position = UDim2.new(1, -58, 0, 12)
godV2Switch.Size = UDim2.new(0, 44, 0, 22)
godV2Switch.Text = ""
godV2Switch.AutoButtonColor = false
godV2Switch.ZIndex = 15
Instance.new("UICorner", godV2Switch).CornerRadius = UDim.new(1, 0)

local godV2Knob = Instance.new("Frame", godV2Switch)
godV2Knob.AnchorPoint = Vector2.new(0, 0.5)
godV2Knob.BackgroundColor3 = col.toggleKnobOff
godV2Knob.Position = UDim2.new(0, 2, 0.5, 0)
godV2Knob.Size = UDim2.new(0, 18, 0, 18)
godV2Knob.ZIndex = 16
Instance.new("UICorner", godV2Knob).CornerRadius = UDim.new(1, 0)

local godV2Status = Instance.new("TextLabel", godV2Card)
godV2Status.BackgroundTransparency = 1
godV2Status.Position = UDim2.new(0, 14, 1, -22)
godV2Status.Size = UDim2.new(0.5, 0, 0, 14)
godV2Status.Font = Enum.Font.GothamMedium
godV2Status.Text = "● inactive"
godV2Status.TextColor3 = col.textDim
godV2Status.TextSize = 9
godV2Status.TextXAlignment = Enum.TextXAlignment.Left
godV2Status.ZIndex = 14

local function updateGodV2Visual(active)
    if active then
        TweenService:Create(godV2Switch, tween.normal, {BackgroundColor3 = col.toggleOn}):Play()
        TweenService:Create(godV2Knob, tween.bounce, {Position = UDim2.new(1, -20, 0.5, 0), BackgroundColor3 = col.toggleKnobOn}):Play()
        TweenService:Create(godV2Stroke, tween.fast, {Color = col.phantomGlow, Transparency = 0}):Play()
        TweenService:Create(godV2Icon, tween.fast, {TextColor3 = col.phantomGlow}):Play()
        godV2Status.Text = "● phantom active"
        godV2Status.TextColor3 = col.success
    else
        TweenService:Create(godV2Switch, tween.normal, {BackgroundColor3 = col.toggleOff}):Play()
        TweenService:Create(godV2Knob, tween.bounce, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = col.toggleKnobOff}):Play()
        TweenService:Create(godV2Stroke, tween.fast, {Color = col.phantomGlow, Transparency = 0.6}):Play()
        TweenService:Create(godV2Icon, tween.fast, {TextColor3 = col.phantom}):Play()
        godV2Status.Text = "● inactive"
        godV2Status.TextColor3 = col.textDim
    end
end

godV2Switch.MouseButton1Click:Connect(function()
    if GodV2.isTransitioning then return end
    local result = GodV2:toggle()
    updateGodV2Visual(result)
    task.spawn(saveSettings)
    notify(result and "phantom clone activated" or "phantom clone deactivated", 2.5, result and "phantom" or "warn")
end)

createSection(combatPage, "God V2 Config")

createSlider(combatPage, "Clone Transparency", 0.1, 0.5, "cloneTransparency", function(v)
    if GodV2.active then GodV2:updateConfig() end
end, true)

createSlider(combatPage, "Anchor Offset", 5, 20, "anchorOffset", function(v) end)

createSection(combatPage, "Aimbot")

createToggle(combatPage, "Auto Aim", "aim", function(v)
    if v then
        conn.aim = RunService.RenderStepped:Connect(function()
            local target = getClosestInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
        notify("auto aim enabled", 2, "success")
    else
        if conn.aim then conn.aim:Disconnect() end
        notify("auto aim disabled", 2)
    end
end)

createToggle(combatPage, "Show FOV Circle", "showfov", function(v) end)

createSlider(combatPage, "FOV Size", 50, 350, "aimfov", function(v) end)

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
        notify("kill aura enabled", 2, "success")
    else
        if conn.aura then conn.aura:Disconnect() end
        notify("kill aura disabled", 2)
    end
end)

createSlider(combatPage, "Aura Range", 10, 30, "auraRange", function(v) end)
createSlider(combatPage, "Hit Chance %", 50, 100, "hitChance", function(v) end)

-- MOVEMENT PAGE
local movePage = pages["movement"]

createSection(movePage, "Speed")

createToggle(movePage, "Speed Hack", "speedHack", function(v)
    if not v then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = defaultSpeed end
    end
    notify(v and "speed hack enabled" or "speed hack disabled", 2, v and "success" or nil)
end)

createSlider(movePage, "Walk Speed", 16, 300, "speed", function(v) end)

createSection(movePage, "Physics")

createToggle(movePage, "Noclip", "noclip", function(v)
    if v then
        conn.noclip = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
        notify("noclip enabled", 2, "success")
    else
        if conn.noclip then conn.noclip:Disconnect() end
        notify("noclip disabled", 2)
    end
end)

-- VISUAL PAGE
local visualPage = pages["visual"]

createSection(visualPage, "World")

createToggle(visualPage, "Remove Fog", "fog", function(v)
    Lighting.FogEnd = v and 100000 or 1000
    notify(v and "fog removed" or "fog restored", 2, v and "success" or nil)
end)

createToggle(visualPage, "Fullbright", "bright", function(v)
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
    notify(v and "fullbright enabled" or "fullbright disabled", 2, v and "success" or nil)
end)

createSlider(visualPage, "Field of View", 70, 120, "fov", function(v)
    cam.FieldOfView = v
end)

createSection(visualPage, "Character")

createToggle(visualPage, "Invisible", "invisible", function(v)
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = v and 1 or 0
        end
    end
    notify(v and "invisible enabled" or "invisible disabled", 2, v and "success" or nil)
end)

createToggle(visualPage, "X-Ray Walls", "xray", function(v)
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
    notify(v and "x-ray enabled" or "x-ray disabled", 2, v and "success" or nil)
end)

-- ESP PAGE
local espPage = pages["esp"]

createSection(espPage, "ESP Settings")

createToggle(espPage, "Enable ESP", "esp", function(v)
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then createESP(p) end
        end
        notify("esp enabled", 2, "success")
    else
        clearESP()
        notify("esp disabled", 2)
    end
end)

createToggle(espPage, "RGB Effect", "espRgb", function(v) end)

createSection(espPage, "ESP Modes")

createButton(espPage, "Name Tag Mode", function()
    cfg.espMode = 1
    clearESP()
    if cfg.esp then for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end end
    notify("esp: name tag", 2, "success")
    task.spawn(saveSettings)
end, "◇")

createButton(espPage, "Highlight Mode", function()
    cfg.espMode = 2
    clearESP()
    if cfg.esp then for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end end
    notify("esp: highlight", 2, "success")
    task.spawn(saveSettings)
end, "◈")

createButton(espPage, "Box Mode", function()
    cfg.espMode = 3
    clearESP()
    if cfg.esp then for _, p in pairs(Players:GetPlayers()) do if p ~= plr then createESP(p) end end end
    notify("esp: box", 2, "success")
    task.spawn(saveSettings)
end, "▢")

-- SKY PAGE
local skyPage = pages["sky"]

createSection(skyPage, "Sky Presets")

local skyButtons = {}

skyButtons.default = createSkyButton(skyPage, "Default", "default", "◯", "restore original map lighting")
skyButtons.galaxy = createSkyButton(skyPage, "Galaxy", "galaxy", "✦", "deep space with stars and nebula colors")
skyButtons.sunset = createSkyButton(skyPage, "Sunset", "sunset", "☀", "warm orange and pink evening sky")
skyButtons.morning = createSkyButton(skyPage, "Morning", "morning", "◐", "fresh blue sky with soft sunlight")
skyButtons.night = createSkyButton(skyPage, "Night", "night", "☾", "dark sky with moonlight and stars")
skyButtons.dawn = createSkyButton(skyPage, "Dawn", "dawn", "◑", "early morning with warm horizon glow")

createSection(skyPage, "Info")

local skyInfo = Instance.new("Frame", skyPage)
skyInfo.BackgroundColor3 = col.card
skyInfo.BackgroundTransparency = 0.4
skyInfo.Size = UDim2.new(1, 0, 0, 50)
skyInfo.ZIndex = 13
Instance.new("UICorner", skyInfo).CornerRadius = UDim.new(0, 8)

local skyInfoText = Instance.new("TextLabel", skyInfo)
skyInfoText.BackgroundTransparency = 1
skyInfoText.Position = UDim2.new(0, 12, 0, 0)
skyInfoText.Size = UDim2.new(1, -24, 1, 0)
skyInfoText.Font = Enum.Font.Gotham
skyInfoText.Text = "sky presets modify lighting, atmosphere, and visual effects. changes are client-side only and won't affect other players."
skyInfoText.TextColor3 = col.textDim
skyInfoText.TextSize = 9
skyInfoText.TextWrapped = true
skyInfoText.TextXAlignment = Enum.TextXAlignment.Left
skyInfoText.ZIndex = 14

-- PLAYERS PAGE
local playersPage = pages["players"]

createSection(playersPage, "Player List")

local playerListContainer = Instance.new("Frame", playersPage)
playerListContainer.BackgroundColor3 = col.card
playerListContainer.BackgroundTransparency = 0.3
playerListContainer.Size = UDim2.new(1, 0, 0, 140)
playerListContainer.ZIndex = 13
Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 10)

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.BackgroundTransparency = 1
playerListScroll.Position = UDim2.new(0, 6, 0, 6)
playerListScroll.Size = UDim2.new(1, -12, 1, -12)
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.ScrollBarThickness = 2
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
            btn.BackgroundColor3 = isSel and col.accentMuted or col.elevated
            btn.BackgroundTransparency = isSel and 0.4 or 0.5
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 15
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
            
            local name = Instance.new("TextLabel", btn)
            name.BackgroundTransparency = 1
            name.Position = UDim2.new(0, 12, 0, 0)
            name.Size = UDim2.new(1, -45, 1, 0)
            name.Font = Enum.Font.GothamMedium
            name.Text = player.Name
            name.TextColor3 = col.text
            name.TextSize = 11
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.ZIndex = 16
            
            if isSel then
                local indicator = Instance.new("Frame", btn)
                indicator.BackgroundColor3 = col.accent
                indicator.Position = UDim2.new(1, -24, 0.5, -4)
                indicator.Size = UDim2.new(0, 8, 0, 8)
                indicator.ZIndex = 16
                Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
            end
            
            btn.MouseButton1Click:Connect(function()
                cfg.selectedPlayer = cfg.selectedPlayer == player and nil or player
                notify(cfg.selectedPlayer and ("selected " .. player.Name) or "deselected", 2, cfg.selectedPlayer and "success" or nil)
                updatePlayerList()
            end)
            
            btn.MouseEnter:Connect(function()
                if not isSel then TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.3}):Play() end
            end)
            btn.MouseLeave:Connect(function()
                if not isSel then TweenService:Create(btn, tween.fast, {BackgroundTransparency = 0.5}):Play() end
            end)
        end
    end
end

updatePlayerList()

createSection(playersPage, "Actions")

createButton(playersPage, "Teleport to Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character and cfg.selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cfg.selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            notify("teleported", 2, "success")
        end
    else
        notify("select a player first", 2, "warn")
    end
end, "⤴")

createButton(playersPage, "Spectate Player", function()
    if cfg.selectedPlayer and cfg.selectedPlayer.Character then
        local hum = cfg.selectedPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            cam.CameraSubject = hum
            notify("spectating " .. cfg.selectedPlayer.Name, 2, "success")
        end
    else
        notify("select a player first", 2, "warn")
    end
end, "◉")

createButton(playersPage, "Stop Spectate", function()
    local hum = char:FindFirstChild("Humanoid")
    if hum then cam.CameraSubject = hum notify("stopped spectating", 2, "success") end
end, "◎")

createButton(playersPage, "Refresh List", function()
    updatePlayerList()
    notify("list refreshed", 2, "success")
end, "↻")

-- ABOUT PAGE
local aboutPage = pages["about"]

-- Title Card
local aboutTitleCard = Instance.new("Frame", aboutPage)
aboutTitleCard.BackgroundColor3 = col.card
aboutTitleCard.BackgroundTransparency = 0.2
aboutTitleCard.Size = UDim2.new(1, 0, 0, 75)
aboutTitleCard.ZIndex = 13
Instance.new("UICorner", aboutTitleCard).CornerRadius = UDim.new(0, 12)

local aboutTitleStroke = Instance.new("UIStroke", aboutTitleCard)
aboutTitleStroke.Color = col.phantom
aboutTitleStroke.Thickness = 1
aboutTitleStroke.Transparency = 0.7

local aboutIcon = Instance.new("TextLabel", aboutTitleCard)
aboutIcon.BackgroundTransparency = 1
aboutIcon.Position = UDim2.new(0, 18, 0, 16)
aboutIcon.Size = UDim2.new(0, 32, 0, 32)
aboutIcon.Font = Enum.Font.GothamBold
aboutIcon.Text = "✦"
aboutIcon.TextColor3 = col.phantom
aboutIcon.TextSize = 26
aboutIcon.ZIndex = 14

local aboutTitle = Instance.new("TextLabel", aboutTitleCard)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Position = UDim2.new(0, 58, 0, 14)
aboutTitle.Size = UDim2.new(1, -70, 0, 22)
aboutTitle.Font = Enum.Font.GothamBold
aboutTitle.Text = "About"
aboutTitle.TextColor3 = col.text
aboutTitle.TextSize = 17
aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
aboutTitle.ZIndex = 14

local aboutSubtitle = Instance.new("TextLabel", aboutTitleCard)
aboutSubtitle.BackgroundTransparency = 1
aboutSubtitle.Position = UDim2.new(0, 58, 0, 38)
aboutSubtitle.Size = UDim2.new(1, -70, 0, 16)
aboutSubtitle.Font = Enum.Font.Gotham
aboutSubtitle.Text = "the story behind god v2"
aboutSubtitle.TextColor3 = col.textDim
aboutSubtitle.TextSize = 10
aboutSubtitle.TextXAlignment = Enum.TextXAlignment.Left
aboutSubtitle.ZIndex = 14

-- About Content
local aboutContent1 = [[
<font color="rgb(160,160,170)">Script ini awalnya tidak dibuat dengan tujuan besar. Tidak ada ambisi untuk membuat sesuatu yang rumit atau kompleks. Semua dimulai dari rasa penasaran kecil tentang bagaimana sistem karakter di roblox bekerja. Tentang bagaimana kamera bisa berpindah, bagaimana clone bisa dibuat stabil tanpa glitch, bagaimana pergerakan bisa terasa lebih halus.</font>

<font color="rgb(160,160,170)">Awalnya hanya eksperimen sederhana. Mengganti CameraSubject, menduplikasi karakter, memahami HumanoidRootPart, mencoba memperbaiki bug kecil yang muncul tanpa diduga. Setiap error yang muncul terasa seperti teka-teki. Setiap solusi kecil memberi rasa puas.</font>

<font color="rgb(220,220,225)">Namun seiring waktu, alasan di balik pengembangan script ini berubah.</font>

<font color="rgb(160,160,170)">Ada fase dalam hidup di mana semuanya terasa berbeda. Seseorang yang dulu selalu ada, perlahan tidak lagi berada di tempat yang sama. Bukan karena pertengkaran besar. Bukan karena drama yang berlebihan. Hanya keadaan yang berubah, jarak yang tercipta, dan waktu yang tidak bisa diputar kembali.</font>
]]

createTextBlock(aboutPage, aboutContent1)

local aboutContent2 = [[
<font color="rgb(85,105,145)">Yang tersisa adalah ruang kosong.</font>

<font color="rgb(160,160,170)">Hal-hal kecil yang dulu terasa biasa, tiba-tiba terasa hilang. Percakapan sederhana. Candaan ringan. Kehadiran yang tidak perlu dijelaskan. Semua itu perlahan menjadi kenangan.</font>

<font color="rgb(160,160,170)">Di masa itu, hari terasa lebih panjang dari biasanya. Malam terasa lebih sunyi. Pikiran sering berjalan sendiri tanpa arah.</font>

<font color="rgb(220,220,225)">Di tengah rasa sepi itulah scripting menjadi tempat bertahan.</font>

<font color="rgb(160,160,170)">Setiap baris kode menjadi cara untuk mengalihkan pikiran. Setiap bug yang berhasil diperbaiki menjadi kemenangan kecil. Setiap sistem yang berhasil berjalan tanpa error memberi rasa bahwa setidaknya masih ada sesuatu yang bisa dikendalikan.</font>
]]

createTextBlock(aboutPage, aboutContent2)

local aboutContent3 = [[
<font color="rgb(110,135,180)">God v2 lahir dari proses itu.</font>

<font color="rgb(160,160,170)">Konsep clone dalam fitur ini bukan sekadar teknis. Clone melambangkan sisi diri yang tetap berjalan, tetap terlihat kuat, tetap bergerak maju di depan orang lain. Versi yang terlihat stabil, tidak goyah, tidak menunjukkan apa pun.</font>

<font color="rgb(160,160,170)">Sementara tubuh asli yang berada di bawah, yang hanya mengikuti tanpa terlihat jelas, melambangkan perasaan yang sebenarnya. Perasaan yang mungkin tidak selalu ditunjukkan. Rasa kehilangan yang tetap ada, tetapi tidak selalu diperlihatkan.</font>

<font color="rgb(85,105,145)">Ketika fitur diaktifkan dan kamera berpindah ke clone, itu seperti fase di mana seseorang mencoba menjadi versi yang lebih kuat dari dirinya sendiri. Berjalan seperti biasa. Terlihat normal. Tetap berfungsi.</font>

<font color="rgb(160,160,170)">Namun tubuh asli tetap ada di bawahnya.</font>
]]

createTextBlock(aboutPage, aboutContent3)

local aboutContent4 = [[
<font color="rgb(220,220,225)">Dan ketika fitur dimatikan, tubuh asli naik kembali ke posisi clone dengan halus. Itu melambangkan proses menerima. Proses kembali menjadi diri sendiri sepenuhnya. Tanpa topeng. Tanpa lapisan tambahan.</font>

<font color="rgb(160,160,170)">Script ini dibuat di malam-malam panjang. Dibuat saat dunia terasa terlalu sunyi. Dibuat saat belajar menjadi cara untuk tetap bergerak maju. Tidak ada niat dramatis. Tidak ada keinginan berlebihan. Hanya proses kecil untuk tetap berdiri.</font>

<font color="rgb(160,160,170)">Setiap detail dalam god v2 — dari transisi kamera yang smooth, transparansi clone yang halus, hingga perpindahan posisi yang tidak kasar — dibuat dengan pemikiran yang tenang. Stabilitas sistem mencerminkan keinginan untuk membuat sesuatu yang tidak mudah runtuh.</font>
]]

createTextBlock(aboutPage, aboutContent4)

local aboutContent5 = [[
<font color="rgb(85,105,145)">Tab About ini bukan untuk mencari simpati. Ini hanya penjelasan jujur bahwa terkadang, dari rasa kehilangan bisa lahir sesuatu yang produktif. Bahwa kesedihan tidak selalu menghentikan langkah. Terkadang, ia hanya mengubah arah.</font>

<font color="rgb(220,220,225)">Dan seperti god v2 yang bisa dinyalakan dan dimatikan dengan stabil, hidup pun memiliki fase. Ada saatnya menjadi kuat di luar. Ada saatnya kembali menjadi diri sendiri dengan tenang.</font>

<font color="rgb(110,135,180)">Script ini adalah pengingat bahwa meskipun sesuatu pergi, bukan berarti semuanya berhenti. Terkadang itu hanya awal dari perjalanan yang berbeda.</font>
]]

createTextBlock(aboutPage, aboutContent5)

-- Separator
local separator = Instance.new("Frame", aboutPage)
separator.BackgroundColor3 = col.border
separator.BackgroundTransparency = 0.6
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.new(0, 10, 0, 0)
separator.ZIndex = 13

createSection(aboutPage, "Technical")

local techCard = Instance.new("Frame", aboutPage)
techCard.BackgroundColor3 = col.card
techCard.BackgroundTransparency = 0.4
techCard.Size = UDim2.new(1, 0, 0, 100)
techCard.ZIndex = 13
Instance.new("UICorner", techCard).CornerRadius = UDim.new(0, 10)

local techText = Instance.new("TextLabel", techCard)
techText.BackgroundTransparency = 1
techText.Position = UDim2.new(0, 14, 0, 12)
techText.Size = UDim2.new(1, -28, 1, -24)
techText.Font = Enum.Font.Gotham
techText.Text = "◈ Clone POV System — camera & control transfer\n◈ Phantom Protection — immune to damage & kill bricks\n◈ Smooth Transition — seamless state changes\n◈ Anchor Sync — original follows clone horizontally\n◈ Animation Sync — clone mirrors player animations\n◈ Anti-Void — automatic void protection"
techText.TextColor3 = col.textMuted
techText.TextSize = 9
techText.TextXAlignment = Enum.TextXAlignment.Left
techText.TextYAlignment = Enum.TextYAlignment.Top
techText.ZIndex = 14

-- Quote Card
local quoteCard = Instance.new("Frame", aboutPage)
quoteCard.BackgroundColor3 = col.phantom
quoteCard.BackgroundTransparency = 0.85
quoteCard.Size = UDim2.new(1, 0, 0, 55)
quoteCard.ZIndex = 13
Instance.new("UICorner", quoteCard).CornerRadius = UDim.new(0, 10)

local quoteStroke = Instance.new("UIStroke", quoteCard)
quoteStroke.Color = col.phantom
quoteStroke.Thickness = 1
quoteStroke.Transparency = 0.6

local quoteText = Instance.new("TextLabel", quoteCard)
quoteText.BackgroundTransparency = 1
quoteText.Position = UDim2.new(0, 16, 0, 0)
quoteText.Size = UDim2.new(1, -32, 1, 0)
quoteText.Font = Enum.Font.GothamMedium
quoteText.Text = "\"sometimes the strongest version of yourself is the one you create when no one is watching.\""
quoteText.TextColor3 = col.phantomGlow
quoteText.TextSize = 10
quoteText.TextXAlignment = Enum.TextXAlignment.Center
quoteText.TextYAlignment = Enum.TextYAlignment.Center
quoteText.TextWrapped = true
quoteText.ZIndex = 14

-- Credits
createSection(aboutPage, "Credits")

local creditsCard = Instance.new("Frame", aboutPage)
creditsCard.BackgroundColor3 = col.card
creditsCard.BackgroundTransparency = 0.4
creditsCard.Size = UDim2.new(1, 0, 0, 55)
creditsCard.ZIndex = 13
Instance.new("UICorner", creditsCard).CornerRadius = UDim.new(0, 10)

local creditsText = Instance.new("TextLabel", creditsCard)
creditsText.BackgroundTransparency = 1
creditsText.Size = UDim2.new(1, 0, 1, 0)
creditsText.Font = Enum.Font.Gotham
creditsText.Text = "developed with quiet persistence\nviolence district v3 — god v2 phantom system\n© 2024"
creditsText.TextColor3 = col.textDim
creditsText.TextSize = 10
creditsText.ZIndex = 14

-- End spacer
local endSpacer = Instance.new("Frame", aboutPage)
endSpacer.BackgroundTransparency = 1
endSpacer.Size = UDim2.new(1, 0, 0, 20)

-- ══════════════════════════════════════════════════════════════
-- DRAWING OBJECTS
-- ══════════════════════════════════════════════════════════════

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = col.accent
fovCircle.Transparency = 0.6
fovCircle.NumSides = 64
fovCircle.Filled = false

local auraCircle = Drawing.new("Circle")
auraCircle.Visible = false
auraCircle.Thickness = 1
auraCircle.Color = col.error
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
    mainShadow.ImageTransparency = 1
    
    -- Animate open
    TweenService:Create(main, tween.bounce, {
        Size = UDim2.new(0, 520, 0, 360),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(mainStroke, tween.smooth, {Transparency = 0.5}):Play()
    TweenService:Create(mainShadow, tween.slow, {ImageTransparency = 0.7}):Play()
    
    -- Animate toggle button
    TweenService:Create(toggleIcon, tween.fast, {TextColor3 = col.accent}):Play()
end

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    
    -- Animate close
    TweenService:Create(main, tween.normal, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(mainStroke, tween.fast, {Transparency = 1}):Play()
    TweenService:Create(mainShadow, tween.fast, {ImageTransparency = 1}):Play()
    TweenService:Create(toggleIcon, tween.fast, {TextColor3 = col.textMuted}):Play()
    
    task.delay(0.25, function()
        if not menuOpen then main.Visible = false end
    end)
end

-- Toggle button click
toggleBtn.MouseButton1Click:Connect(function()
    if tick() - lastClick < 0.15 then
        if menuOpen then closeMenu() else openMenu() end
    end
end)

-- Window controls
closeBtn.MouseButton1Click:Connect(closeMenu)
minBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════════════════════════════
-- MAIN LOOP
-- ══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    -- Speed hack (not God V2)
    if not GodV2.active then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and cfg.speedHack then
            hum.WalkSpeed = cfg.speed
        end
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
    if activeTab == "players" then updatePlayerList() end
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        pcall(function() espData[p].obj:Destroy() end)
        espData[p] = nil
    end
    if cfg.selectedPlayer == p then cfg.selectedPlayer = nil end
    if activeTab == "players" then updatePlayerList() end
end)

plr.CharacterAdded:Connect(function(c)
    char = c
    task.wait(1)
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then defaultSpeed = hum.WalkSpeed end
    
    -- God V2 respawn handler
    GodV2:onCharacterAdded(c)
    
    -- Update visual
    if cfg.godV2 then
        task.wait(2)
        updateGodV2Visual(GodV2.active)
    end
    
    -- Re-apply toggles
    for key, ref in pairs(toggleRefs) do
        if cfg[key] and key ~= "godV2" then
            pcall(function() ref.apply() end)
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- KEYBOARD SHORTCUTS
-- ══════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Right Shift = toggle menu
    if input.KeyCode == Enum.KeyCode.RightShift then
        if menuOpen then closeMenu() else openMenu() end
    end
    
    -- F4 = toggle God V2
    if input.KeyCode == Enum.KeyCode.F4 then
        if not GodV2.isTransitioning then
            local result = GodV2:toggle()
            updateGodV2Visual(result)
            task.spawn(saveSettings)
            notify(result and "phantom clone activated" or "phantom clone deactivated", 2, result and "phantom" or "warn")
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
    
    -- Apply saved sky
    if cfg.skyMode and cfg.skyMode ~= "default" then
        task.wait(0.5)
        if cfg.skyMode == "galaxy" then SkySystem:applyGalaxy()
        elseif cfg.skyMode == "sunset" then SkySystem:applySunset()
        elseif cfg.skyMode == "morning" then SkySystem:applyMorning()
        elseif cfg.skyMode == "night" then SkySystem:applyNight()
        elseif cfg.skyMode == "dawn" then SkySystem:applyDawn()
        end
    end
    
    -- God V2 restore
    if cfg.godV2 then
        task.wait(1.5)
        local result = GodV2:activate()
        if result then
            updateGodV2Visual(true)
            notify("phantom clone restored", 2.5, "phantom")
        end
    end
    
    -- Count active features
    local activeCount = 0
    for _, v in pairs(cfg) do
        if v == true then activeCount = activeCount + 1 end
    end
    
    notify("violence district v3 loaded", 3, "success")
    if activeCount > 0 then
        notify(activeCount .. " settings restored", 2.5)
    end
end)

-- ══════════════════════════════════════════════════════════════
-- CLEANUP
-- ══════════════════════════════════════════════════════════════

gui.Destroying:Connect(function()
    -- Cleanup God V2
    GodV2:cleanup(false)
    
    -- Cleanup ESP
    clearESP()
    
    -- Cleanup Drawing
    pcall(function() fovCircle:Remove() end)
    pcall(function() auraCircle:Remove() end)
    
    -- Restore sky
    SkySystem:restore()
    
    -- Disconnect connections
    for _, c in pairs(conn) do
        if c then pcall(function() c:Disconnect() end) end
    end
    
    -- Restore gravity
    Workspace.Gravity = defaultGravity
end)

-- ══════════════════════════════════════════════════════════════
-- INIT MESSAGE
-- ══════════════════════════════════════════════════════════════

print("════════════════════════════════════════════")
print("  Violence District v3 — Premium Edition")
print("  God V2 Phantom + Sky System")
print("════════════════════════════════════════════")
print("  Hotkeys:")
print("  • Right Shift — Toggle Menu")
print("  • F4 — Quick Toggle God V2")
print("════════════════════════════════════════════")