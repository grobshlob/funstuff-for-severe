local severeui = loadstring(game:HttpGet("https://raw.githubusercontent.com/okdude42/ui-lib/refs/heads/main/SevereLib.lua"))()

local window = severeui:createwindow({
    Title = "Brog: Gakuran",
    Version = ";-;",
    Keybind = "LeftAlt",
    ConfigFolder = "hiimbrog", -- this is what the folder in workspace will be named, this is where your configs save
    CustomResolution = Vector2.new(350, 160), -- adjust ui resolution
    DPIScale = _G.dpi, --only use if you have a custom scale set or 4k res, increments of .25
    
    DefaultTab = "Main", 
    TabAlignment = "Center", -- options: "Left", "Center", "Right"
    
    DefaultColor = Color3.fromRGB(28, 27, 31),
    DefaultAccent = Color3.fromRGB(208, 188, 255),
    DefaultSnowfall = true,
    DefaultScale = 1.0,
    DefaultFont = 5 -- all fonts are at the bottom of the script
})

-- create tabs
local cw = window:createtab("Main")
window:createlabel(cw, "Auto Parry")
window:createseparator(cw, 1)
window:createtoggle(cw, {
	Name = "Toggle",
	Col = 1,
	Default = false,
	Callback = function(state) if state then _G.loaded = not _G.loaded send_notification("on", "success") end end
})
window:createlabel(cw, "Modify", 2)
window:createseparator(cw, 2)
window:createslider(cw, {
	Name = "Time",
	Col = 2,
	Min = 0.1, Max = 10, Default = 0.31415,
	Step = 0.1,
	Callback = function(val) _G.slider = val end
})
task.spawn(function()
    --loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/waiting.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/detections/getgameandanimations.lua"))()
end)
--send_notification("script is currently down", "warning")
--task.wait(math.huge)
_G.debug = true
local lp = game.Players.LocalPlayer
_G.swingPtr = nil
local time = 0
local parried = {}
_G.loaded = true

task.spawn(function()
    while true do
        task.wait(0.04)
        
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
					parry, dodge = false, false
					for _, stuff in pairs(_G.anims) do
						if stuff.AnimationId == t.assetid then
							print(stuff.Name)
							if string.find(stuff.Name, "M2") then
								 dodge = true
								 parry = false
								 break
							else
								parry = true
								break
							end
						end
					end
                    foundSwingPtr = t.ptr
                    if _G.debug then
                        print("Detected non-ignored anim: " .. tostring(t.assetid))
                    end
                    if foundSwingPtr ~= nil and foundSwingPtr ~= _G.swingPtr and not parried[t.ptr] then 
                        parried[t.ptr] = true
                        local root = char:FindFirstChild("HumanoidRootPart") 
                        if root and worldpos and vector.magnitude(root.Position - worldpos) <= 14 then
                            _G.swingPtr = foundSwingPtr
                            local parrytime = time / divide - game:GetPing() / 1000
                            print(parrytime)
                            --if parrytime < 0.06 then continue end
                            task.spawn(function()                   
                                print("swing started!")
                                --if t.timePosition < 0.08 then continue end
                               -- local parrytime = time / divide - game:GetPing() / 1000
                                if _G.debug then print(parrytime) end
                                if parrytime >= 0 then
                                	task.wait(parrytime)
                                end
								if parry then
	                                keypress(0x46) 
	                                task.wait(0.3) 
	                                keyrelease(0x46)
								elseif dodge then
									keypress(0x51) 
	                                task.wait(0.05) 
	                                keyrelease(0x51)
								end
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
