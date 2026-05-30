local players = game.Players 
local ws = game.Workspace 
local rs = game.RunService 

function getkiller()
    local animator, hrp = nil, nil
    for _, v in pairs(players:GetChildren()) do 
        if v.Name ~= players.LocalPlayer.Name and v.Team and v.Team.Name == "Killer" then 
            local chara = v.Character 
            if chara then
                hrp = chara:FindFirstChild("HumanoidRootPart")
                local hum = chara:FindFirstChild("Humanoid")
                if hum then
                    animator = hum:FindFirstChild("Animator")
                end
            end
            break
        end 
    end 
    return animator, hrp 
end 

local function getPlayingAnimationTracks() 
    local tracks = {} 
    local anima = getkiller() 
    if anima then 
        local ok, head = pcall(memory.readu64, anima, 0x868) 
        if not ok or head == 0 then return tracks end 
        local ok2, node = pcall(memory.readu64, head) 
        if not ok2 then return tracks end 
        local count = 0 
        while node ~= 0 and node ~= head and count < 100 do 
            count += 1 
            local ok3, track = pcall(memory.readu64, node + 0x10) 
            if ok3 and track ~= 0 then 
                local ok6, stringptr = pcall(memory.readu64, track, 0xd0) 
                if ok6 and stringptr > 100000 then 
                    local ok5, timePos = pcall(memory.readf32, track, 0xe8) 
                    local ok7 , asset = pcall(memory.readstring, stringptr, 0xd0) 
                    table.insert(tracks, { 
                        ptr = track, 
                        timePosition = ok5 and timePos or 0, 
                        assetid = ok7 and asset, 
                    }) 
                end 
            end 
            local ok6, next = pcall(memory.readu64, node) 
            if not ok6 then break end 
            node = next 
        end 
    end 
    return tracks 
end 

local dontdihgnore = { 
    ["rbxassetid://113255068724446"] = true, 
    ["rbxassetid://129784271201071"] = true, 
    ["rbxassetid://117042998468241"] = true, 
    ["rbxassetid://118907603246885"] = true, 
    ["rbxassetid://80411309607666"] = true, 
    ["rbxassetid://122812055447896"] = true, 
    ["rbxassetid://110355011987939"] = true, 
    ["rbxassetid://135002183282873"] = true, 
    ["rbxassetid://105374834496520"] = true, 
    ["rbxassetid://138720291317243"] = true, 
    ["rbxassetid://115244153053858"] = true, 
    ["rbxassetid://106871536134254"] = true 
} 

local swingPtr = nil 

task.spawn(function() 
    while task.wait(0.016) do 
        if _G.ap then 
            local ok, tracks = pcall(getPlayingAnimationTracks) 
            if not ok then continue end 
            local foundSwingPtr = nil 
            local tposition = 0
            for _, t in ipairs(tracks) do 
                if t.assetid and dontdihgnore[t.assetid] then 
                    foundSwingPtr = t.ptr 
                    tposition = t.timePosition 
                    print(tostring(t.assetid)) 
                    break 
                end 
            end 
            local ping = game:GetPing() / 1000 
            if foundSwingPtr ~= swingPtr then 
                if swingPtr ~= nil then 
                    print("Swing stopped!") 
                end 
                local _, tpos = getkiller() 
                if players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local lpos = players.LocalPlayer.Character.HumanoidRootPart.Position 
                    if tpos then 
                        local dist = (tpos.Position - lpos).Magnitude
                        if foundSwingPtr ~= nil and dist < 10 then 
                            print("Swing started!") 
                            local hold = tposition - ping 
                            print(hold) 
                            if hold >= 0 then 
                                task.wait(tposition / 1.4 - ping) 
                            end 
                            mouse2click() 
                            print("hi i should be in the middle") 
                        end 
                    end
                end
                swingPtr = foundSwingPtr 
            end 
        end 
    end 
end) 

local activeCluster = nil 
local activePoints = {} 
local lastMapChildrenCount = -1 
local isScanning = false 

local function clearDrawings() 
    if activeCluster then 
        pcall(function() 
            activeCluster:Pause() 
            activeCluster:Destroy() 
        end) 
        activeCluster = nil 
    end 
    for _, point in ipairs(activePoints) do 
        pcall(function() if point then point:Destroy() end end) 
    end 
    table.clear(activePoints) 
end 

local function scanAndSetup() 
    if isScanning then return end 
    isScanning = true 
    clearDrawings() 

    local attachConfig = {} 

    if _G.killesp then
        local _, killerPart = getkiller()
        if killerPart and killerPart:IsA("BasePart") then
            local succ, killerTracker = pcall(function() return PointInstance.new(killerPart) end)
            if succ and killerTracker then
                table.insert(activePoints, killerTracker)

                local kOutline = Drawing.new("Square")
                kOutline.Color = Color3.fromRGB(255, 0, 0) 
                kOutline.Opacity = 0.8
                kOutline.Thickness = 1.5
                kOutline.Filled = false
                kOutline.Rounding = 0
                kOutline.ZIndex = 6
                kOutline.Visible = true

                attachConfig[kOutline] = { 
                    Link = killerTracker, 
                    -- FIXED: Uses proportional scaling with a clamped pixel buffer boundary 
                    Size = UDim2.new(3, -20, 5, -30), 
                    AnchorPoint = Vector2.new(0.5, 0.5) 
                }
            end
        end
    end

    local mapsFolder = ws:FindFirstChild("Map")
    if mapsFolder and mapsFolder.Parent and _G.genesp then 
        local success, objects = pcall(function() return mapsFolder:GetDescendants() end)
        if success and objects then
            for _, v in ipairs(objects) do 
                if v and v.Parent and string.sub(v.Name, 1, 3) == "Gen" then 
                    local targetPart = v:FindFirstChild("RootPart") 
                    if targetPart and targetPart:IsA("BasePart") and targetPart.Parent then 
                        local pointSuccess, pointTracker = pcall(function() return PointInstance.new(targetPart) end)
                        
                        if pointSuccess and pointTracker then 
                            table.insert(activePoints, pointTracker) 

                            local fillSquare = Drawing.new("Square") 
                            fillSquare.Color = Color3.fromRGB(118, 0, 118) 
                            fillSquare.Opacity = 0.25 
                            fillSquare.Filled = true 
                            fillSquare.ZIndex = 0 
                            fillSquare.Visible = true 

                            local outlineSquare = Drawing.new("Square") 
                            outlineSquare.Color = Color3.fromRGB(255, 255, 255) 
                            outlineSquare.Opacity = 0.8 
                            outlineSquare.Thickness = 1.5 
                            outlineSquare.Filled = false 
                            outlineSquare.Rounding = 0 
                            outlineSquare.ZIndex = 1 
                            outlineSquare.Visible = true 

                            -- FIXED: Scale remains completely dynamic (3, 2), but the negative offset blocks (-40, -30)
                            -- act as a safety padding constraint so close-up frames never blow up past your view.
                            local safeDynamicSize = UDim2.new(3, -40, 2, -30)

                            attachConfig[fillSquare] = { Link = pointTracker, Size = safeDynamicSize, AnchorPoint = Vector2.new(0.5, 0.5) } 
                            attachConfig[outlineSquare] = { Link = pointTracker, Size = safeDynamicSize, AnchorPoint = Vector2.new(0.5, 0.5) } 
                        end 
                    end 
                end 
            end 
        end
    end 

    if next(attachConfig) then 
        pcall(function() activeCluster = Drawing.attach(attachConfig) end) 
    end 
    isScanning = false 
end 

task.spawn(function() 
    while true do 
        task.wait(0.5) 
        local mapsFolder = ws:FindFirstChild("Map") 
        if mapsFolder and mapsFolder.Parent then 
            local ok, currentChildren = pcall(function() return mapsFolder:GetChildren() end) 
            if ok and currentChildren then 
                local currentCount = #currentChildren 
                if currentCount ~= lastMapChildrenCount then 
                    lastMapChildrenCount = currentCount 
                    if currentCount == 0 then 
                        clearDrawings() 
                    else 
                        task.wait(0.4) 
                        scanAndSetup() 
                    end 
                end 
                
                for _, point in ipairs(activePoints) do 
                    if point and (not point.Active or not point.CFrame) then 
                        clearDrawings() 
                        lastMapChildrenCount = -1 
                        break 
                    end 
                end 
            else 
                if lastMapChildrenCount ~= 0 then 
                    lastMapChildrenCount = 0 
                    clearDrawings() 
                end 
            end 
        else 
            if lastMapChildrenCount ~= 0 then 
                lastMapChildrenCount = 0 
                clearDrawings() 
            else
                scanAndSetup()
            end 
        end 
    end 
end) 

pcall(scanAndSetup)
