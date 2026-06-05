local ws = game:GetService("Workspace")

local function batch(instancesarray, size)
    for i = 1, #instancesarray, size do
        for j = i, math.min(i + size - 1, #instancesarray) do
            local instance = instancesarray[j]
            if instance and (instance:IsA("Part") or instance:IsA("BasePart")) and instance.CanCollide then
                instance.CanCollide = false
            end
        end
        task.wait(0.1) 
    end
    send_notification("all done")
end

task.spawn(function()
    while true do
        local geo = ws:FindFirstChild("WORKSPACE_Geometry")
        if geo then
            local mobs = geometryFolder:GetDescendants()
            batch(mobs, _G.size)
        end
        task.wait(_G.scandelay) 
    end
end)
