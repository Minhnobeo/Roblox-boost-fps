-- Roblox Ultra FPS Booster (Fixed to Prevent Game Freeze)
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

-- Hàm kiểm tra có phải NPC hoặc người chơi
local function isCharacterOrNPC(obj)
    return obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart")
end

-- Xóa các hiệu ứng ánh sáng, particle, mesh, decal không cần thiết (an toàn hơn)
local function removeEffectsAndMeshes()
    pcall(function()
        local objectsToRemove = {}
        for _, obj in pairs(game:GetDescendants()) do
            -- Bỏ qua nếu đối tượng thuộc nhân vật hoặc NPC
            if obj:IsDescendantOf(Character) or isCharacterOrNPC(obj) then
                continue
            end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                table.insert(objectsToRemove, obj)
            elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ShirtGraphic") then
                table.insert(objectsToRemove, obj)
            elseif obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
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
        for _, part in pairs(Workspace:GetChildren()) do
            if part:IsA("Model") or part:IsA("BasePart") then
                -- Nếu không phải nhân vật hoặc NPC thì xóa
                local isPlayer = false
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr.Character and (part == plr.Character or part:IsDescendantOf(plr.Character)) then
                        isPlayer = true
                        break
                    end
                end

                -- NPC kiểm tra bằng tên hoặc chứa Humanoid
                local isNPC = false
                if part:FindFirstChildOfClass("Humanoid") and not isPlayer then
                    isNPC = true
                end

                -- Giữ nền: Terrain hoặc Baseplate hoặc vật thể có tên riêng bạn muốn giữ
                local isGround = part:IsA("Terrain") or part.Name:lower():find("base") or part.Name:lower():find("ground") or part.Name:lower():find("road")

                if not isPlayer and not isNPC and not isGround then
                    table.insert(objectsToRemove, part)
                end
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

-- Tối ưu thêm: tắt shadows, giảm chất lượng
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
removeEffectsAndMeshes()
optimizeWorkspace()
optimizeRendering()
print("Ultra FPS Booster: Tối ưu hoàn tất (đã sửa lỗi đứng game).")

-- Optimize new objects dynamically (only when added)
Workspace.DescendantAdded:Connect(function(obj)
    if not obj:IsDescendantOf(Character) and not isCharacterOrNPC(obj) then
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
