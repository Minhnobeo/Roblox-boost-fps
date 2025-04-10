-- Optimized Roblox FPS Booster Script with Terrain, Houses, and Trees Removal
-- Created by Grok 3 (xAI) on April 10, 2025
-- Designed to reduce lag without causing stuttering

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Optimize Lighting settings (one-time)
local function optimizeLighting()
    pcall(function()
        Lighting.GlobalShadows = false -- Tắt bóng toàn cục
        Lighting.FogStart = 100000 -- Tắt sương mù
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1 -- Độ sáng trung bình
        Lighting.ClockTime = 12 -- Cố định ánh sáng
    end)
end

-- Optimize individual objects
local function optimizeObject(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.CastShadow = false -- Tắt bóng
            obj.Material = Enum.Material.SmoothPlastic -- Giảm chất lượng texture
            obj.Anchored = true -- Cố định để giảm vật lý
            obj.CanCollide = false -- Tắt va chạm
        elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false -- Tắt hiệu ứng
        elseif obj:IsA("ParticleEmitter") then
            obj.Enabled = false -- Tắt hạt
        elseif obj:IsA("Decal") then
            obj.Transparency = 1 -- Ẩn decal
        end
    end)
end

-- Remove terrain, houses, and trees
local function removeTerrainHousesTrees()
    pcall(function()
        -- Xóa địa hình (Terrain)
        Terrain:Clear() -- Xóa toàn bộ địa hình (cỏ, đất, nước, v.v.)

        -- Xóa nhà cửa và cây cối
        for _, obj in pairs(Workspace:GetChildren()) do
            -- Xóa các đối tượng có tên liên quan đến nhà cửa
            if obj:IsA("Model") then
                local name = obj.Name:lower()
                if name:find("house") or name:find("building") or name:find("home") then
                    obj:Destroy()
                elseif name:find("tree") or name:find("plant") or name:find("bush") then
                    obj:Destroy()
                end
            end
        end
    end)
end

-- Optimize Workspace settings (one-time)
local function optimizeWorkspace()
    pcall(function()
        Workspace.Gravity = 0 -- Tắt trọng lực
        Workspace.FallenPartsDestroyHeight = -500 -- Xóa phần rơi sớm hơn
    end)
end

-- Optimize all objects initially
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

-- Initial optimization (run once)
optimizeLighting()
optimizeWorkspace()
removeTerrainHousesTrees() -- Xóa địa hình, nhà, cây cối
optimizeAll()
optimizeLocalPlayer()
print("FPS Booster: Optimized with terrain, houses, and trees removed.")

-- Optimize new objects dynamically (only when added)
Workspace.DescendantAdded:Connect(optimizeObject)
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    for _, part in pairs(character:GetDescendants()) do
        optimizeObject(part)
    end
end)

-- Periodic cleanup (lightweight, every 5 seconds)
local lastCleanup = tick()
RunService.Stepped:Connect(function()
    if tick() - lastCleanup >= 5 then -- Chỉ chạy mỗi 5 giây
        for _, debris in pairs(Workspace:GetChildren()) do
            if debris:IsA("Debris") then
                debris:Destroy()
            end
        end
        lastCleanup = tick()
    end
end)
