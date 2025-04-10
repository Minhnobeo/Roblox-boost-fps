-- FullBoost.lua: Roblox FPS Optimization Script
-- Created by MinhNobeo, enhanced by Grok 3 (xAI)
-- Last updated: April 10, 2025

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- Configuration (Adjust these values as needed)
local Config = {
    DisableShadows = true,          -- Disable all shadows
    DisableFog = true,             -- Remove fog effects
    DisableEffects = true,         -- Disable smoke, fire, sparkles, etc.
    ReduceTextures = true,         -- Simplify materials and textures
    BrightnessLevel = 0.5,         -- Set custom brightness (0 to 1)
    OptimizeInterval = 1,          -- Time (seconds) between optimization checks
    DontOptimizeTag = "DontOptimize" -- Tag to skip optimization for specific objects
}

-- Store original settings for restoration
local OriginalSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    Brightness = Lighting.Brightness,
    ShadowSoftness = Lighting.ShadowSoftness
}

-- Apply initial lighting optimizations
local function applyLightingOptimizations()
    local success, err = pcall(function()
        if Config.DisableShadows then
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 0
        end
        if Config.DisableFog then
            Lighting.FogStart = 100000
            Lighting.FogEnd = 100000
        end
        Lighting.Brightness = Config.BrightnessLevel
        Lighting.ClockTime = 12 -- Fixed time to avoid dynamic lighting changes
    end)
    if not success then
        warn("Error applying lighting optimizations: " .. err)
    end
end

-- Optimize individual objects
local function optimizeObject(obj)
    if CollectionService:HasTag(obj, Config.DontOptimizeTag) then
        return -- Skip objects tagged with DontOptimize
    end

    local success, err = pcall(function()
        if obj:IsA("BasePart") then
            if Config.DisableShadows then
                obj.CastShadow = false
            end
            if Config.ReduceTextures then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
            obj.Anchored = true -- Anchor to reduce physics calculations
            obj.CanCollide = false -- Disable collisions unless necessary
        elseif Config.DisableEffects then
            if obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("ParticleEmitter") then
                obj.Rate = 0 -- Reduce particle emissions
            elseif obj:IsA("Decal") and Config.ReduceTextures then
                obj.Transparency = 1 -- Hide unnecessary decals
            end
        end
    end)
    if not success then
        warn("Error optimizing object " .. obj.Name .. ": " .. err)
    end
end

-- Optimize all existing objects
local function optimizeAllObjects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        optimizeObject(obj)
    end
end

-- Restore original settings (optional)
local function restoreOriginalSettings()
    local success, err = pcall(function()
        Lighting.GlobalShadows = OriginalSettings.GlobalShadows
        Lighting.FogStart = OriginalSettings.FogStart
        Lighting.FogEnd = OriginalSettings.FogEnd
        Lighting.Brightness = OriginalSettings.Brightness
        Lighting.ShadowSoftness = OriginalSettings.ShadowSoftness
    end)
    if not success then
        warn("Error restoring settings: " .. err)
    else
        print("FPS Boost: Original settings restored.")
    end
end

-- Initial optimization
applyLightingOptimizations()
optimizeAllObjects()
print("FPS Boost: Initial optimizations applied successfully.")

-- Dynamic optimization for new objects
Workspace.DescendantAdded:Connect(optimizeObject)

-- Periodic optimization check using RunService (more efficient than while loop)
local lastCheck = tick()
RunService.Heartbeat:Connect(function()
    if tick() - lastCheck >= Config.OptimizeInterval then
        optimizeAllObjects() -- Re-optimize periodically
        lastCheck = tick()
    end
end)

-- Optional: Uncomment the line below to test restoration after 30 seconds
-- task.delay(30, restoreOriginalSettings)
