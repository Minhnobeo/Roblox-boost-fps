-- Optimized Roblox FPS Booster Script with Terrain, Houses, and Trees Removal
-- Created by Grok 3 (xAI) on April 10, 2025
-- Fixed to allow character movement

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
            -- Không tắt CanCollide để nhân vật có thể đứng trên bề mặt
            -- obj.CanCollide = false
            -- Không cố định tất cả để tránh ảnh hưởng đến cơ chế game
            -- obj.Anchored = true
        elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false -- Tắt hiệu ứng
        elseif obj:IsA("ParticleEmitter") then
            obj.Enabled = false -- Tắt hạt
        elseif obj:IsA("Decal") then
            obj.Transparency = 1 -- Ẩn decal
        end
    end)
end

-- Hàm kiểm tra tên đối tượng có liên quan đến nhà, cây cối, hoặc địa hình
local function isTargetObject(obj)
    local name = obj.Name:lower()
    return name:find("tree") or name:find("house") or name:find("building") or name:find("grass") or name:find("leaf")
end

-- Xóa terrain, nhà cửa, và cây cối, nhưng giữ lại bề mặt di chuyển
local function removeTerrainHousesTrees()
    pcall(function()
        -- Xóa các đối tượng liên quan đến nhà, cây cối
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
                -- Bỏ qua các đối tượng có tên liên quan đến mặt đất hoặc đường
                local name = obj.Name:lower()
                if name:find("ground") or name:find("road") or name:find("floor") then
                    continue -- Giữ lại mặt đất/đường
                end
                if isTargetObject(obj) then
                    obj:Destroy()
                end
            end
        end

        -- Xóa Terrain nếu có (cảnh báo: có thể ảnh hưởng đến mặt đất)
        if Workspace:FindFirstChildOfClass("Terrain") then
            Workspace.Terrain:Clear()
        end
    end)
    print("Đã xóa nhà, cây và terrain (giữ lại bề mặt di chuyển).")
end

-- Optimize Workspace settings (one-time)
local function optimizeWorkspace()
    pcall(function()
        -- Không tắt trọng lực để nhân vật di chuyển bình thường
        -- Workspace.Gravity = 0
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
            -- Không tối ưu hóa nhân vật để tránh ảnh hưởng đến di chuyển
            if not part:IsA("BasePart") then
                optimizeObject(part)
            end
        end
    end
end

-- Initial optimization (run once)
optimizeLighting()
optimizeWorkspace()
removeTerrainHousesTrees() -- Xóa địa hình, nhà, cây cối
optimizeAll()
optimizeLocalPlayer()
print("FPS Booster: Optimized with terrain, houses, and trees removed. Character can move.")

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
