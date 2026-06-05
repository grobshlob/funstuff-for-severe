local ws = game:GetService("Workspace")

local function exclude(instance)
    local current = instance.Parent
    while current and current ~= ws and current ~= game do
        if current:IsA("Folder") or current:IsA("Model") then
            local nameLower = string.lower(current.Name)
            if string.find(nameLower, "bridge") then
                return true 
            end
        end
        current = current.Parent
    end
    
    return false
end

local function batch(instancesarray, size)
    local batch = size or 100
    
    for i = 1, #instancesarray, batch do
        for j = i, math.min(i + batch - 1, #instancesarray) do
            local instance = instancesarray[j]
            
            if instance and (instance:IsA("BasePart") or instance:IsA("Part")) and instance.CanCollide then
                local floorcheck = instance.CFrame.UpVector.Y > 0.7
                if not exclude(instance) and not floorcheck then
                    instance.CanCollide = false
                end
            end
        end
        task.wait(0.1)
    end
    print("all done")
end

task.spawn(function()
    while true do
        local geo = ws:FindFirstChild("WORKSPACE_Geometry")
        if geo then
            local parts = geo:GetDescendants()
            batch(parts, _G.size)
        end
        task.wait(_G.scandelay or 5)
    end
end)
