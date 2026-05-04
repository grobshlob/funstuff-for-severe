loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/getgameandanimations.lua"))()
local lp = game.Players.LocalPlayer
_G.debug = true
task.spawn(function()
    repeat task.wait(0.5) until _G.loaded == true
    print("active")
    while true do
        task.wait(0.016)
        local char = lp.Character
        if not char then return end
        local _, _, _, worldpos = tinmr()
        if not _G.targetAnimator then continue end
        print("im here")

        local ok, tracks = pcall(getPlayingAnimationTracks, _G.targetAnimator)
        if not ok then continue end

        local foundSwingPtr = nil
        for _, t in ipairs(tracks) do
            if t.assetid and _G.dontignore[t.assetid] then
            
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
        print(getDistance(rpos, worldpos))
        if foundSwingPtr ~= swingPtr and getDistance(rpos, worldpos) < 20 then
        	print("hi im here")
            if _G.swingPtr ~= nil then
                print(_G.target.Name .. " swing stopped!")
            end
            if foundSwingPtr ~= nil then
                print(_G.target.Name .. " swing started!")
                task.wait(0.075)
                keypress(0x46)
                task.wait(0.1)
                keyrelease(0x46)
            end
            _G.swingPtr = foundSwingPtr
        end
    end
end)
