-- Full Auto FPS Boost Script by Minhnobeo + ChatGPT
pcall(function()

    -- Clear Terrain
    if workspace:FindFirstChildOfClass("Terrain") then
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        terrain:Clear()
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
    end

    -- Lighting Settings
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 1e10
    lighting.Brightness = 0
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end

    -- Settings
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    -- Remove effects from workspace
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Explosion") then
            v:Destroy()
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("Sound") then
            v.Volume = 0
        elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("TextLabel") or v:IsA("ImageLabel") or v:IsA("TextButton") then
            v:Destroy()
        end
    end

    -- Remove GUI from Player
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player:FindFirstChild("PlayerGui") then
            for _, gui in pairs(player.PlayerGui:GetChildren()) do
                gui:Destroy()
            end
        end
    end

    -- Camera Optimization
    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraType = Enum.CameraType.Custom
        camera.FieldOfView = 70
    end

    -- Mute all
    game:GetService("UserSettings"):GetService("UserGameSettings").MasterVolume = 0

    -- Remove click detectors and touches
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") or obj:IsA("TouchTransmitter") then
            obj:Destroy()
        end
    end

    print("[FPS BOOST] Đã tối ưu toàn bộ - FPS tăng tối đa!")
end)

-- Tắt bóng của tất cả BasePart
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.CastShadow = false
    end
end

-- Xoá Decal, Texture và SpecialMesh
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SpecialMesh") then
        obj:Destroy()
    end
end

-- Giữ nguyên tốc độ nhân vật hoặc chỉnh nhẹ nếu cần
for _, hum in pairs(workspace:GetDescendants()) do
    if hum:IsA("Humanoid") then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end