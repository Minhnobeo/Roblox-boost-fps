-- Roblox Ultra FPS Booster
-- Created by Grok 3 (xAI) on April 10, 2025
-- Removes unnecessary objects and adds temporary ground for movement

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
        Lighting.Brightness = 0
        Lighting.ClockTime = 12
    end)
end

-- Vô hiệu hóa Terrain
local function disableTerrain()
    pcall(function()
        Workspace.Terrain:Clear()
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterTransparency = 1
        Workspace.Terrain.WaterReflectance = 0
    end)
end

-- Hàm kiểm tra có phải NPC hoặc người chơi
local function isCharacterOrNPC(obj)
    return obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart")
end

-- Xóa mọi thứ trừ nhân vật và NPC
local function cleanEnvironment()
    pcall(function()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if not obj:IsDescendantOf(Character) and not isCharacterOrNPC(obj) then
                obj:Destroy()
            end
        end
    end)
end

-- Tắt hiệu ứng không cần thiết
local function disableEffects()
    pcall(function()
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Decal") then
                obj.Transparency = 1
            end
        end
    end)
end

-- Thêm mặt đất tạm thời để nhân vật di chuyển
local function addTemporaryGround()
    pcall(function()
        local ground = Instance.new("Part")
        ground.Size = Vector3.new(1000, 1, 1000) -- Kích thước lớn để nhân vật di chuyển thoải mái
        ground.Position = Vector3.new(0, -1, 0) -- Đặt dưới nhân vật
        ground.Anchored = true -- Cố định
        ground.CanCollide = true -- Cho phép nhân vật đứng lên
        ground.Material = Enum.Material.SmoothPlastic
        ground.Parent = Workspace
        print("Đã thêm mặt đất tạm thời để nhân vật di chuyển.")
    end)
end

-- Optimize Workspace settings (one-time)
local function optimizeWorkspace()
    pcall(function()
        Workspace.FallenPartsDestroyHeight = -500 -- Xóa phần rơi sớm hơn
    end)
end

-- Initial optimization (run once)
optimizeLighting()
disableTerrain()
cleanEnvironment()
disableEffects()
optimizeWorkspace()
addTemporaryGround() -- Thêm mặt đất tạm thời
print("Ultra FPS Booster: Environment cleaned, temporary ground added.")

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

-- Đảm bảo nhân vật mới được bảo vệ
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    Character = character
    print("Nhân vật mới được bảo vệ.")
end)
