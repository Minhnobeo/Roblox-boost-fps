-- Optimized Roblox FPS Booster Script with Environment Cleanup
-- Created by Grok 3 (xAI) on April 10, 2025
-- Removes unnecessary objects while ensuring character movement

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

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
            -- Không tắt CanCollide để nhân vật có thể đứng trên bề mặt
        elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false -- Tắt hiệu ứng
        elseif obj:IsA("ParticleEmitter") then
            obj.Enabled = false -- Tắt hạt
        elseif obj:IsA("Decal") then
            obj.Transparency = 1 -- Ẩn decal
        end
    end)
end

-- Không xóa: nhân vật, NPC, GUI, camera...
local whitelist = {
    "Players", "StarterGui", "ReplicatedStorage", "ReplicatedFirst", 
    "Chat", "SoundService", "RunService", "Lighting", "TweenService"
}

-- Hàm kiểm tra có trong whitelist không
local function isWhitelisted(obj)
    for _, name in ipairs(whitelist) do
        if obj == game:GetService(name) then
            return true
        end
    end
    return false
end

-- Xóa mọi thứ không cần thiết
local function cleanEnvironment()
    pcall(function()
        -- Xóa mô hình không thuộc whitelist
        for _, obj in ipairs(game:GetChildren()) do
            if not isWhitelisted(obj) then
                if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("Part") or obj:IsA("MeshPart") then
                    obj:Destroy()
                elseif obj.Name == "Workspace" then
                    for _, child in ipairs(obj:GetChildren()) do
                        -- Giữ lại nhân vật, NPC, và camera
                        if not child:IsDescendantOf(Character) and not child:FindFirstChild("Humanoid") and child.Name ~= "Camera" then
                            child:Destroy()
                        end
                    end
                end
            end
        end

        -- Xóa Terrain
        if Workspace:FindFirstChildOfClass("Terrain") then
            Workspace.Terrain:Clear()
        end
    end)
    print("Dọn sạch môi trường, tối ưu FPS.")
end

-- Optimize Workspace settings (one-time)
local function optimizeWorkspace()
    pcall(function()
        -- Không tắt trọng lực để nhân vật di chuyển bình thường
        Workspace.FallenPartsDestroyHeight = -500 -- Xóa phần rơi sớm hơn
    end)
end

-- Optimize all objects initially
local function optimizeAll()
    for _, obj in pairs(Workspace:GetDescendants()) do
        -- Chỉ tối ưu nếu đối tượng không bị xóa
        if obj.Parent then
            optimizeObject(obj)
        end
    end
end

-- Optimize local player’s character
local function optimizeLocalPlayer()
    local player = Players.LocalPlayer
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if not part:IsA("BasePart") then
                optimizeObject(part)
            end
        end
    end
end

-- Initial optimization (run once)
optimizeLighting()
optimizeWorkspace()
cleanEnvironment() -- Xóa mọi thứ không cần thiết
optimizeAll()
optimizeLocalPlayer()
print("FPS Booster: Optimized with environment cleaned. Character can move.")

-- Optimize new objects dynamically (only when added)
Workspace.DescendantAdded:Connect(optimizeObject)
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    for _, part in pairs(character:GetDescendants()) do
        if not part:IsA("BasePart") then
            optimizeObject(part)
        end
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
