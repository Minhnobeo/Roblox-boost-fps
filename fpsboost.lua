-- BOOST FPS SCRIPT (universal)
pcall(function()
    -- Xóa toàn bộ hiệu ứng ánh sáng, hạt, v.v.
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v:Destroy()
        elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
            v.Enabled = false
        elseif v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end

    -- Xóa địa hình (terrain)
    if workspace:FindFirstChildOfClass("Terrain") then
        workspace.Terrain:Clear()
    end

    -- Tắt shadow, chỉnh chất lượng thấp
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game:GetService("Lighting").GlobalShadows = false

    -- Giảm hiệu ứng nước nếu có
    game:GetService("Lighting").WaterWaveSize = 0
    game:GetService("Lighting").WaterWaveSpeed = 0
    game:GetService("Lighting").WaterReflectance = 0
    game:GetService("Lighting").WaterTransparency = 1

    -- Tối ưu nhân vật và các chi tiết khác
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        end
    end

    print("[+] FPS BOOST LOADED SUCCESSFULLY")
end)
