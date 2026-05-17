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
function getDistance(a, b)
    return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2 + (a.Z - b.Z)^2)
end

function tinmr()
    table.clear(_G.targets)
    for _, v in pairs(players:GetChildren()) do
        if v ~= lp then
            local tchar = v.Character
            local char = lp.Character
            if not tchar or not char then continue end
            local troot = tchar:FindFirstChild("HumanoidRootPart")
            if troot then
                local rpos = troot.Position
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root or not rpos then continue end
                if getDistance(root.Position, rpos) <= 14 then
                    local hum = tchar:FindFirstChild("Humanoid")
                    local anim = hum:FindFirstChild("Animator")
                    table.insert(_G.targets, {
                        worldpos = rpos,
                        animator = anim
                    })
                end
            end
        end
    end
    return worldpos
end
--thank you hashmka i skidded your method because ai couldnt figure it out
function getPlayingAnimationTracks(animator)
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


_G.dontignore = {}
_G.ignore = {}
_G.dodge = {}
_G.multi = {}
_G.loaded = false
local pid = game.PlaceId
local body = nil
local data = nil

if pid == 4282985734 or pid == 11979315221 or pid == 11979319180 or pid == 18594569228 then
    local ok_body, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/combatwarriors.json")
    end)
    if ok_body then body = result end
elseif pid == 6735572261 then
    local ok_body, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/pilgrammed/pilgrammed.json")
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
    print("game: Combat Warriors")
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
            elseif game == "pil" then
                --PILGRAMMED IS GETTING DELAYED MORE THAN WALLCHECK ;-;
                --gonna have to remove/add/add time to some animations
                if animName:find("Slash") or animName:find("Swing") or animName:find("Alt") or animName:find("Smack") or animName:find("Strike") or animName:find("Stab") or animName:find("Overhead") or animName:find("Cleave") or animName:find("Vertical") or animName:find("Lunge") or animName:find("Uppercut") or animName:find("Fist")
                    or animName:find("Punch") or animName:find("Kick") or animName:find("Bite") or animName:find("Chomp") or animName:find("Tongue") or animName:find("Jab") or animName:find("Sweep") or animName:find("Bash") or animName:find("Heavy") or animName:find("Smash") then
                        dontignore[fullId] = true
                elseif animName:find("Laser") or animName:find("Beam") or animName:find("Breath") or animName:find("Blast") or animName:find("Spit") or animName:find("Acid") or animName:find("Nova") or animName:find("Boom") or animName:find("Quake") or animName:find("Spin") or animName:find("Stomp") or animName:find("Charge") or animName:find("Rush") or animName:find("LungeSlam") or animName:find("Leap") or animName:find("JumpSlam") or animName:find("FlightSlam") or animName:find("Shoot") or
                       animName:find("Fire") or animName:find("Spine") or animName:find("Grab") or animName:find("Slam") or animName:find("Cannon") or animName:find("Orb") or animName:find("Wave") or animName:find("Beams") or animName:find("SpinShoot") or animName:find("Psychic") or animName:find("Meteor") or animName:find("Snap") or animName:find("Cast") or animName:find("Spill") or animName:find("Twirl") or animName:find("Throw") or animName:find("Burst") or animName:find("Cero") or animName:find("Deadeye") or
                        animName:find("Strafe") or animName:find("SlideSword") or animName:find("Crackers") or animName:find("Feint") or animName:find("Special") or animName:find("Dodge") or animName:find("Aerial") or animName:find("Execute") or animName:find("Air") or animName:find("Backstep") or animName:find("Fountain") or animName:find("Spew") or animName:find("Leap") or animName:find("Warp") or animName:find("Twist") or animName:find("Float") or animName:find("Charge") or animName:find("Swipe") or animName:find("Dive") or animName:find("Unleash") then
                        _G.dodge[fullId] = true
                elseif animName:find("Combo") or animName:find("Three") or animName:find("Strikes") or animName:find("Flurry") then
                    _G.multi[fullId] = true
                else
                    ignore[fullId] = true
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
    _G.loaded = true
end
if ok_decode and pid == 4282985734 or pid == 11979315221 or pid == 11979319180 then
    decode("cw")
elseif pid == 6735572261 then 
    decode("pil")
else
    warn("Failed to decode JSON body.")
end

