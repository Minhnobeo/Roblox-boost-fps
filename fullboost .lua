-- Ultimate Roblox FPS Booster Script
-- Created by Grok 3 (xAI) on April 10, 2025
-- Runs continuously to maximize FPS, no restoration

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Optimize Lighting settings
local function optimizeLighting()
    pcall(function()
        Lighting.GlobalShadows = false -- Tắt bóng toàn cục
        Lighting.ShadowSoftness = 0 -- Giảm độ mềm của bóng
        Lighting.FogStart = 100000 -- Tắt sương mù
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1 -- Độ sáng trung bình
        Lighting.ClockTime = 12 -- Cố định ánh sáng để giảm tính toán
        Lighting.Ambient = Color3.new(1, 1, 1) -- Giảm ánh sáng môi trường
    end)
end

-- Optimize individual objects
local function optimizeObject(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.CastShadow = false -- Tắt bóng
            obj.Material = Enum.Material.SmoothPlastic -- Giảm chất lượng texture
            obj.Reflectance = 0 -- Tắt phản chiếu
            obj.Anchored = true -- Cố định để giảm vật lý
            obj.CanCollide = false -- Tắt va chạm
        elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false -- Tắt hiệu ứng
        elseif obj:IsA("ParticleEmitter") then
            obj.Rate = 0 -- Tắt hạt
            obj.Enabled = false
        elseif obj:IsA("Explosion") then
            obj.BlastPressure = 0 -- Giảm hiệu ứng nổ
            obj.BlastRadius = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1 -- Ẩn texture/decals
        end
    end)
end

-- Optimize Workspace settings
local function optimizeWorkspace()
    pcall(function()
        Workspace.Gravity = 0 -- Tắt trọng lực
        Workspace.FallenPartsDestroyHeight = 0 -- Xóa ngay phần rơi
    end)
end

-- Optimize all objects in game
local function optimizeAll()
    for _, obj in pairs(Workspace:GetDescendants()) do
        optimizeObject(obj)
    end
end

-- Optimize local player’s character
local function optimizeLocalPlayer()
    local player = Players.LocalPlayer
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            optimizeObject(part)
        end
    end
end

-- Initial boost
optimizeLighting()
optimizeWorkspace()
optimizeAll()
optimizeLocalPlayer()
print("FPS Booster: Running at maximum performance.")

-- Boost new objects dynamically
Workspace.DescendantAdded:Connect(optimizeObject)
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    for _, part in pairs(character:GetDescendants()) do
        optimizeObject(part)
    end
end)

-- Continuous boost with RunService
RunService.Heartbeat:Connect(function()
    optimizeAll() -- Liên tục tối ưu mọi thứ
end)

-- Clean up debris instantly
RunService.Stepped:Connect(function()
    for _, debris in pairs(Workspace:GetChildren()) do
        if debris:IsA("Debris") then
            debris:Destroy()
        end
    end
end)
