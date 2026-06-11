task.spawn(function()
    --loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/waiting.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/detections/getgameandanimations.lua"))()
end)
--send_notification("script is currently down", "warning")
--task.wait(math.huge)
local lp = game.Players.LocalPlayer
_G.swingPtr = nil
local time = 0
local parried = {}
local turnedon = false
task.spawn(function()
    while _G.loaded do
        if _G.loaded == true and not turnedon then
            send_notification("on", "info")
        end
        turnedon = true
        task.wait(0.008)
        tinmr()
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
                        if root and worldpos and getDistance(root.Position, worldpos) <= 14 then
                            _G.swingPtr = foundSwingPtr
                            task.spawn(function()                   
                                print("swing started!")
                                local parrytime = time / _G.slider - game:GetPing() / 1000
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
