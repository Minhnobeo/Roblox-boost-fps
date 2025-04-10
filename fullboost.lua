-- Roblox FullBoost Lite: Lightweight FPS Booster
-- Created by Grok 3 (xAI) on April 10, 2025
-- Boosts FPS lightly while preserving terrain and basic graphics

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Tắt hiệu ứng ánh sáng
local function optimizeLighting()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.FogStart = 1e10
        Lighting.Brightness = 1
    end)
end

-- Tối ưu hóa Terrain (giữ lại địa hình, chỉ tắt hiệu ứng nước)
local function optimizeTerrain()
    pcall(function()
        Terrain.WaterWaveSize = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end)
end

-- Tắt các hiệu ứng nặng (Particle, Trail, Smoke, Fire, Sparkles, Post-Effects)
local function disableHeavyEffects()
    pcall(function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
    end)
end

-- Tối ưu Workspace
local function optimizeWorkspace()
    pcall(function()
        Workspace.FallenPartsDestroyHeight = -5000
        Workspace.GlobalShadows = false
    end)
end

-- Giảm chất lượng đồ họa
local function optimizeRendering()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        game:GetService("UserSettings"):GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
end

-- Initial optimization (run once)
optimizeLighting()
optimizeTerrain()
disableHeavyEffects()
optimizeWorkspace()
optimizeRendering()
print("FullBoost Lite: Tăng FPS nhẹ, giữ lại địa hình và đồ họa cơ bản.")

-- Tối ưu camera và hiệu ứng mới thêm vào sau này
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        task.defer(function()
            pcall(function()
                if obj and obj.Parent then
                    obj.Enabled = false
                end
            end)
        end)
    end
end)

-- Periodic cleanup (lightweight, every 5 seconds)
local lastCleanup = tick()
RunService.Stepped:Connect(function()
    if tick() - lastCleanup >= 5 then -- Chỉ chạy mỗi 5 giây
        for _, debris in pairs(Workspace:GetChildren()) do
            if debris:IsA("Debris") then
                task.defer(function()
                    pcall(function()
                        if debris and debris.Parent then
                            debris:Destroy()
                        end
                    end)
                end)
            end
        end
        lastCleanup = tick()
    end
end)
