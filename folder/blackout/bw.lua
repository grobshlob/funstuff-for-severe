loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/detect%20sound.lua"))()
local lp = game.Players.LocalPlayer
_G.active = false
_G.OnKeybind1Change = function(key: string)
    _G.active = not _G.active
    print("status: " .. tostring(_G.active))
end
local time = 0
task.spawn(function()
    repeat task.wait(0.5) until _G.loaded == true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/bw%20gui.lua"))()
    while true do
        task.wait(0.016)
        local char = lp.Character
        if not char then continue end
        local _, _, _, worldpos = tinmr()
        if not _G.targetsoundmaker or not _G.active then continue end
        local ok, tracks = pcall(getsounds, _G.targetsounmaker)
        if not ok then continue end
        
        local foundsound = false
        for _, t in ipairs(tracks) do
            if t.asset and not ignore[t.asset] then
                sound = t.playing
                foundsound = true
                if _G.debug then
                    --print("Detected non-ignored anim: " .. tostring(t.asset), tostring(t.name), tostring(t.time)) --find missed anims
                end
                break
            end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not worldpos then continue end
        local rpos = root.Position
        for _, i in ipairs(tracks) do
            if getDistance(rpos, worldpos) < 14 then
                local parrytime = i.time / 3.65
                if parrytime >= 0.3 then parrytime = 0.15 end
                if sound ~= 1 and tostring(i.name) == "MeleeSound" then
                    print("Swing stopped!")
                end
                if foundsound and tostring(i.name) == "MeleeSound" then            
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
                    end)
                end
            end
        end
    end
end)
