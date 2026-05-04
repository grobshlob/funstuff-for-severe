loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/getgameandanimations.lua"))()
task.spawn(function()
    while true do
        task.wait(0.016)
        local _, _, _, worldpos = tinmr()
        if not targetAnimator then continue end

        local ok, tracks = pcall(getPlayingAnimationTracks, targetAnimator)
        if not ok then continue end

        local foundSwingPtr = nil
        for _, t in ipairs(tracks) do
            if t.assetid and dontignore[t.assetid] then
                foundSwingPtr = t.ptr
                if _G.debug then
                    print("Detected non-ignored anim: " .. tostring(t.assetid))
                end
                break
            end
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not worldpos then return end
        local rpos = root.Position
        if foundSwingPtr ~= swingPtr and getDistance(rpos, worldpos) < 20 then
            if swingPtr ~= nil then
                print(target.Name .. " swing stopped!")
            end
            if foundSwingPtr ~= nil then
                print(target.Name .. " swing started!")
                task.wait(0.075)
                keypress(0x46)
                task.wait(0.1)
                keyrelease(0x46)
            end
            swingPtr = foundSwingPtr
        end
    end
end)
