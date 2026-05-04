local animator = game.Players.LocalPlayer.Character.Humanoid.Animator

local function getPlayingAnimationTracks()
    local tracks = {}
    local ok, head = pcall(memory.readu64, animator, 0x868)
    if not ok or head == 0 then return tracks end

    local ok2, node = pcall(memory.readu64, head)
    if not ok2 then return tracks end

    local count = 0

    while node ~= 0 and node ~= head and count < 100 do
        count += 1
        local ok3, track = pcall(memory.readu64, node + 0x10)
        if ok3 and track ~= 0 then
            local ok4, isPlaying = pcall(memory.readu8, track, 0xa18)
            local ok6, stringptr = pcall(memory.readu64, track, 0xd0)
            if ok4 and isPlaying == 1 and ok6 and stringptr > 100000 then
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

    return tracks
end

local ignore = { 
    ["rbxassetid://180435571"] = true,
    ["rbxassetid://4639817538"] = true,
    ["rbxassetid://6786106507"] = true,
    ["rbxassetid://6789165310"] = true,
    ["rbxassetid://6789231619"] = true,
    ["rbxassetid://8799308611"] = true,
    ["rbxassetid://0"] = true,
    ["rbxassetid://6820400023"] = true,
    ["rbxassetid://8799576671"] = true,
    ["rbxassetid://9279203398"] = true,
    ["rbxassetid://7479225627"] = true
}

local swingPtr = nil

while task.wait(0.016) do
    local ok, tracks = pcall(getPlayingAnimationTracks)
    if not ok then continue end

    local foundSwingPtr = nil
    for _, t in ipairs(tracks) do
        if t.assetid and not ignore[t.assetid] then
            foundSwingPtr = t.ptr
            --print("Detected non-ignored anim: " .. tostring(t.assetid)) --find missed anims
            break
        end
    end

    if foundSwingPtr ~= swingPtr then
        if swingPtr ~= nil then
            print("Swing stopped!")
        end
        if foundSwingPtr ~= nil then
            print("Swing started!")
             task.wait(0.1)
            print("hi i should be in the middle")
        end
        swingPtr = foundSwingPtr
    end
end
