loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/detections/detect%20sound.lua"))()
local lp = game.Players.LocalPlayer
_G.active = false
_G.OnKeybind1Change = function(key: string)
    _G.active = not _G.active
    print("status: " .. tostring(_G.active))
end
local time = 0
local parried = {}
task.spawn(function()
    repeat task.wait(0.5) until _G.loaded == true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/blackout/bw%20gui.lua"))()
    while true do
        task.wait(0.008)
        local char = lp.Character
        if not char then continue end
        tinmr()
        for _, t1 in pairs(_G.targets) do
            local targetsoundmaker = t1.name
            local worldpos = t1.worldpos
            if not targetsoundmaker or not _G.active then continue end
            local ok, tracks = pcall(getsounds, targetsoundmaker)
            if not ok then continue end
            
            local foundsound = false
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root or not worldpos then continue end
            local rpos = root.Position
            for _, t in ipairs(tracks) do
                if t.asset and not ignore[t.asset] then
                    local sound = t.playing
                    local foundsound = true
                    local key = targetsoundmaker .. tostring(t.asset)
                    if not parried[key] then
                        if getDistance(rpos, worldpos) < 14 then
                        
                            task.spawn(function()
                                local parrytime = t.time / 3.65
                                if parrytime >= 0.3 then parrytime = 0.15 end
                                if sound ~= 1 and tostring(t.name) == "MeleeSound" then
                                    print("Swing stopped!")
                                end
                                if foundsound and tostring(t.name) == "MeleeSound" then            
                                    print("Swing started!")
                                    sound = 1
                                    foundsound = false
                                    --print(tostring(i.name), tostring(i.asset))
                                    task.spawn(function()
                                        keyrelease(0x51)
                                        task.wait(parrytime)
                                        keypress(0x51)
                                        task.wait(0.01)
                                        keyrelease(0x51)
                                        task.wait(0.25)
                                        parried[key] = nil
                                    end)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)
