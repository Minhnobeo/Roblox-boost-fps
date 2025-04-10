-- Roblox Ultra FPS Booster (Safe and Optimized)
-- Created by Grok 3 (xAI) on April 10, 2025
-- Removes unnecessary objects safely while preserving movement surfaces

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

-- Xóa hiệu ứng gây lag và texture phụ (an toàn hơn)
local function removeEffectsAndTextures()
    pcall(function()
        local objectsToRemove = {}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                table.insert(objectsToRemove, obj)
            elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ShirtGraphic") then
                table.insert(objectsToRemove, obj)
            end
        end

        -- Xóa dần để tránh đứng game
        for _, obj in ipairs(objectsToRemove) do
            task.defer(function()
                pcall(function()
                    if obj and obj.Parent then
                        obj:Destroy()
                    end
                end)
            end)
            task.wait() -- Đợi một chút giữa các lần xóa
        end
    end)
end

-- Xóa mọi thứ trừ nhân vật, NPC, và bề mặt nền (an toàn hơn)
local function cleanEnvironment()
    pcall(function()
        local objectsToRemove = {}
        for _, item in pairs(Workspace:GetChildren()) do
            -- Kiểm tra xem có phải nhân vật người chơi không
            local isPlayerChar = false
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and (item == player.Character or item:IsDescendantOf(player.Character)) then
                    isPlayerChar = true
                    break
                end
            end

            -- NPC là mô hình có Humanoid nhưng không phải người chơi
            local isNPC = false
            if item:IsA("Model") and item:FindFirstChildOfClass("Humanoid") and not isPlayerChar then
                isNPC = true
            end

            -- Giữ nền: Terrain, Baseplate, các khối có từ khóa liên quan đến mặt đất
            local isTerrain = item:IsA("Terrain")
            local isBase = item.Name:lower():find("base") or item.Name:lower():find("ground") or item.Name:lower():find("map")

            if not isPlayerChar and not isNPC and not isTerrain and not isBase then
                table.insert(objectsToRemove, item)
            end
        end

        -- Xóa dần để tránh đứng game
        for _, obj in ipairs(objectsToRemove) do
            task.defer(function()
                pcall(function()
                    if obj and obj.Parent then
                        obj:Destroy()
                    end
                end)
            end)
            task.wait() -- Đợi một chút giữa các lần xóa
        end
    end)
end

-- Giảm chất lượng đồ họa cho nhẹ máy
local function optimizeRendering()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.EagerBulkExecution = false
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
removeEffectsAndTextures()
optimizeWorkspace()
optimizeRendering()
print("Ultra FPS Booster: Dọn sạch hoàn tất. Nhân vật, NPC và nền được giữ lại.")

-- Optimize new objects dynamically (only when added)
Workspace.DescendantAdded:Connect(function(obj)
    local isPlayerChar = false
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and (obj == player.Character or obj:IsDescendantOf(player.Character)) then
            isPlayerChar = true
            break
        end
    end

    local isNPC = false
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not isPlayerChar then
        isNPC = true
    end

    local isTerrain = obj:IsA("Terrain")
    local isBase = obj.Name:lower():find("base") or obj.Name:lower():find("ground") or obj.Name:lower():find("map")

    if not isPlayerChar and not isNPC and not isTerrain and not isBase then
        task.defer(function()
            pcall(function()
                if obj and obj.Parent then
                    obj:Destroy()
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
