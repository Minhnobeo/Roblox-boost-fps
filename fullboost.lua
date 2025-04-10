-- FullBoost Lite: Tăng FPS nhẹ, giữ lại địa hình và đồ họa cơ bản
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
        v.Enabled = false
    end
end

-- Tắt bóng đổ và tối ưu workspace
local ws = game:GetService("Workspace")
ws.FallenPartsDestroyHeight = -5000
ws.GlobalShadows = false
pcall(function() ws.Terrain.WaterWaveSize = 0 end)
pcall(function() ws.Terrain.WaterReflectance = 0 end)

-- Tắt hiệu ứng ánh sáng mạnh
local lighting = game:GetService("Lighting")
lighting.GlobalShadows = false
lighting.FogEnd = 1e10
lighting.Brightness = 1

-- Tối ưu hóa chất lượng game
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

-- Tắt tính năng mô phỏng vật lý không cần thiết
game:GetService("UserSettings"):GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

-- Tối ưu camera và hiệu ứng mới thêm vào sau này
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        obj.Enabled = false
    end
end)
