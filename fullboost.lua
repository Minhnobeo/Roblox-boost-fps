for _, obj in pairs(game:GetDescendants()) do
    -- Xóa các hiệu ứng ánh sáng, particle, mesh, decal không cần thiết
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
        obj:Destroy()
    end
    if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ShirtGraphic") then
        obj:Destroy()
    end
    if obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
        obj:Destroy()
    end
end

for _, part in pairs(workspace:GetChildren()) do
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
        local isGround = part:IsA("Terrain") or part.Name:lower():find("base") or part.Name:lower():find("ground")

        if not isPlayer and not isNPC and not isGround then
            part:Destroy()
        end
    end
end

-- Tối ưu thêm: tắt shadows, giảm chất lượng
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.EagerBulkExecution = false

print("Tối ưu hoàn tất.")
