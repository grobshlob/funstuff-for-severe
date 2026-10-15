--!optimize 2
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local ws = game:GetService("Workspace")
--would be really easy to add support since u would just have to hardcode any movement/equip ids. only problem is timing but i mean it should be the same for swings
_G.target = nil
_G.targetAnimator = nil
_G.swingPtr = nil
_G.targets = {}

_G.anims = {}
function tinmr()
    table.clear(_G.targets)
    for _, v in pairs(players:GetChildren()) do
        if v ~= lp and v.ClassName == "Player" then
            local tchar = v.Character
            local char = lp.Character
            if not tchar or not char then continue end
            local troot = tchar:FindFirstChild("HumanoidRootPart")
            if troot then
                if troot:IsA("Part") then
                    local head = tchar:FindFirstChild("Head")
                    --print(head.Name)
                    if not head then continue end
                    local ok, rpos = pcall(function() return troot.Position end)
                    if not ok then return end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root or not rpos then continue end
                    local dist = vector.magnitude(root.Position - rpos)
                    local vectordist = root.Position - rpos
                    local ndist = vector.normalize(vectordist)
                    local dot = vector.dot(head.CFrame.LookVector, ndist)
                    if dist <= 14 and (dot >= 0.8 and dot <= 1) then
                        if v.Name == "2grob" then print("ur fighting the owner pls stop") return end
                        local hum = tchar:FindFirstChild("Humanoid")
                        local anim = hum:FindFirstChild("Animator")
                        table.insert(_G.targets, {
                            worldpos = rpos,
                            animator = anim,
                            chara = tchar,
                            name = v.Name
                        })
                    end
                end
            end
        end
    end
    return worldpos
end
_G.current = {}
function getPlayingAnimationTracks(animator)
    local tracks = {}
    table.clear(_G.current)
    local ok, head = pcall(memory.readu64, animator, 0x9d0)
    if not ok or head == 0 then return tracks end

    local ok2, node = pcall(memory.readu64, head)
    if not ok2 then return tracks end

    local count = 0

    while node ~= 0 and node ~= head and count < 100 do
        count += 1
        local ok3, track = pcall(memory.readu64, node + 0x10)
        if ok3 and track ~= 0 then
            local ok6, stringptr = pcall(memory.readu64, track, 0xb8)
            local ok4, playing = pcall(memory.readu8, track, 0xa40)
            if ok6 and stringptr > 100000 then
                local ok5, timePos = pcall(memory.readf32, track, 0xd0)
                local ok7 , asset = pcall(memory.readstring, stringptr, 0xc0)
                if playing == 1 then
                    _G.current[asset] = true
                    table.insert(tracks, {
                        ptr = track,
                        timePosition = ok5 and timePos or 0,
                        assetid = ok7 and asset,
                    })
                else
                    _G.current[asset] = nil
                end
            end
        end
        local ok6, next = pcall(memory.readu64, node)
        if not ok6 then break end
        node = next
    end

    return tracks
end


_G.dontignore = {}
_G.ignore = {}

_G.loaded = false
local pid = game.PlaceId
local body = nil
local data = nil

if pid == 4282985734 or pid == 11979315221 or pid == 11979319180 or pid == 18594569228 then
    local ok_body, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/combatwarriors.json")
    end)
    if ok_body then body = result end
end
local ok_decode = false
if body then
    local success, decoded = pcall(function()
        return crypt.json.decode(body)
    end)
    if success then
        data = decoded
        ok_decode = true
    end
end
--thank you ai
function decode(game)
    local decodedJSON = data -- This is your array of animation objects
    _G.anims = decodedJSON
    print(game)
    for _, entry in pairs(decodedJSON) do
        -- Check if the entry has the required fields
        if type(entry) == "table" and entry.Name and entry.AnimationId then
            local animName = entry.Name
            local fullId = entry.AnimationId -- It already has "rbxassetid://" based on your segment
            
            -- Filter logic
            if game == "cw" then
                if animName:find("Equip") or animName:find("Finish") or animName:find("Flourish") or 
                   animName:find("Idle") or animName:find("Parr") or animName:find("Core") or 
                   animName:find("Gk") or animName:find("Walk") or animName:find("Run") or animName:find("Camera") or animName:find("Glory") or animName:find("Block") or animName:find("Startup") or animName:find("Inspect") or animName:find("GK") or animName:find("Sprint") or animName:find("Status") or animName:find("Effect") or animName:find("Viewport") or animName:find("Stomp") then
                    
                    ignore[fullId] = true
                else
                    dontignore[fullId] = true
                end
            elseif game == "gakuran" then
                if animName:find("Block") or animName:find("Guard") or animName:find("EHit") then
                    ignore[fullId] = true
                else
                    dontignore[fullId] = true
                end
            end
        end
    end
    local ignoreCount = 0
    for _ in pairs(ignore) do ignoreCount += 1 end
    
    local dontIgnoreCount = 0
    for _ in pairs(dontignore) do dontIgnoreCount += 1 end
    
    print("Successfully loaded JSON.")
    print("Ignored (Movement/Utility): " .. ignoreCount)
    print("Targeted (Attacks): " .. dontIgnoreCount)
end
if ok_decode and pid == 4282985734 or pid == 11979315221 or pid == 11979319180 or pid == 18594569228 then
    decode("cw")
else
    warn("Failed to decode JSON body. Send this to brog: " .. game.PlaceId)
end

--send_notification("script is currently down", "warning")
--task.wait(math.huge)
local lp = game.Players.LocalPlayer
_G.swingPtr = nil
local time = 0
local parried = {}
_G.loaded = false

task.spawn(function()
    while true do
        task.wait(0.03)
        if not _G.loaded then continue end
        --print("hi")
        tinmr()
        local divide = _G.slider or 1
        --print(divide)
        for _, t1 in pairs(_G.targets) do
            _G.targetAnimator = t1.animator
            worldpos = t1.worldpos

            local char = lp.Character
            if not char then continue end
            if not _G.targetAnimator then continue end

            local ok, tracks = pcall(getPlayingAnimationTracks, _G.targetAnimator)
            if not ok then continue end

            local foundSwingPtr = nil
            for _, t in ipairs(tracks) do
                if t.assetid and _G.dontignore[t.assetid] and not parried[t.ptr] then
                    time = tostring(t.timePosition)
                    foundSwingPtr = t.ptr
                    if _G.debug then
                        print("Detected non-ignored anim: " .. tostring(t.assetid))
                    end
                    if foundSwingPtr ~= nil and foundSwingPtr ~= _G.swingPtr then 
                        parried[t.ptr] = true
                        local root = char:FindFirstChild("HumanoidRootPart") 
                        if root and worldpos and vector.magnitude(root.Position - worldpos) <= 14 then
                            _G.swingPtr = foundSwingPtr
                            task.spawn(function()                   
                                print("swing started!")
                                local parrytime = time / divide - game:GetPing() / 1000
                                if _G.debug then print(parrytime) end
                                if parrytime >= 0 then
                                	task.wait(parrytime)
                                end
                                keypress(0x46) 
                                task.wait(0.01) 
                                keyrelease(0x46)
                                task.wait(0.8)
                                 _G.swingPtr = nil
                                parried[t.ptr] = nil
                            end)
                        end
                    end 
                end
            end      
        end
    end
end)
