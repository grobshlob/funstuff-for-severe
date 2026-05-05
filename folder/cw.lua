loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/getgameandanimations.lua"))()
local lp = game.Players.LocalPlayer
_G.active = false
_G.swingPtr = nil
_G.OnKeybind1Change = function(key: string)
    _G.active = not _G.active
    print("status: " .. tostring(_G.active))
end
local time = 0
local parried = false
task.spawn(function()
    repeat task.wait(0.5) until _G.loaded == true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/cw%20gui.lua"))()
    while true do
        task.wait(0.008)
        local char = lp.Character
        if not char then continue end
        local _, _, _, worldpos = tinmr()
        if not _G.targetAnimator then continue end
        if not _G.active then continue end

        local ok, tracks = pcall(getPlayingAnimationTracks, _G.targetAnimator)
        if not ok then continue end

        local foundSwingPtr = nil
        for _, t in ipairs(tracks) do
            if t.assetid and _G.dontignore[t.assetid] and not parried then
                time = tostring(t.timePosition)
                foundSwingPtr = t.ptr
                if _G.debug then
                    print("Detected non-ignored anim: " .. tostring(t.assetid))
                end
                break
            end
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not worldpos then continue end
        local rpos = root.Position         
        if _G.swingPtr ~= nil then
            print(_G.target.Name .. " swing stopped!")
            _G.swingPtr = nil
        end
        local parried = false
        if foundSwingPtr ~= nil and foundSwingPtr ~= _G.swingPtr and not parried then 
            parried = not parried
            local _, _, _, worldpos = tinmr()
            local root = char:FindFirstChild("HumanoidRootPart") 
            if root and worldpos and getDistance(root.Position, worldpos) < 12.5 then 
                _G.swingPtr = foundSwingPtr
                print(_G.target.Name .. " swing started!")
                local parrytime = time / 3.85
                print(parrytime)
                if parrytime >= 0.17 then parrytime = 0.15 print(parrytime) end
                keyrelease(0x46) 
                task.wait(parrytime) 
                keypress(0x46) 
                task.wait(0.01) 
                keyrelease(0x46) 
                parried = not parried
            end 
        end
    end
end)
