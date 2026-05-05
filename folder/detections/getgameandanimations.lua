--!optimize 2
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local char = lp.Character
local root = char:FindFirstChild("HumanoidRootPart")
local ws = game:GetService("Workspace")
local cam = ws.CurrentCamera
local radius = 60
--would be really easy to add support since u would just have to hardcode any movement/equip ids. only problem is timing but i mean it should be the same for swings
_G.target = nil
_G.targetAnimator = nil
_G.swingPtr = nil

local function get2dDistance(a, b)
    return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2)
end
function getDistance(a, b)
    return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2 + (a.Z - b.Z)^2)
end

local function mousepos()
    return uis:GetMouseLocation()
end

function tinmr()
    local name = nil
    local color = Color3.new(0, 1, 0)
    local mpos = uis:GetMouseLocation()
    for _, v in pairs(players:GetChildren()) do
        if v ~= lp then
            local tchar = v.Character
            if not tchar then continue end
            local root = tchar:FindFirstChild("HumanoidRootPart")
            if root then
                local rpos = root.Position
                local screenpos2 = cam:WorldToScreenPoint(rpos)
                if get2dDistance(mpos, screenpos2) <= radius + 10 then
                    color = Color3.new(1, 0, 0)
                    name = v.Name
                    spos = screenpos2
                    worldpos = rpos
                end
            end
        end
    end
    return color, name, spos, worldpos
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
_G.loaded = false
local pid = game.PlaceId
local body = nil
local data = nil

if pid == 4282985734 or pid == 11979315221 or pid == 11979319180 then
    local ok_body, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/combatwarriors.json")
    end)
    if ok_body then body = result end
elseif pid == 8767500166 then
    local ok_body, result = pcall(function()
        return nil
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
if ok_decode and pid == 4282985734 or pid == 11979315221 then
    local decodedJSON = data -- This is your array of animation objects
    print("game: Combat Warriors")
    for _, entry in pairs(decodedJSON) do
        -- Check if the entry has the required fields
        if type(entry) == "table" and entry.Name and entry.AnimationId then
            local animName = entry.Name
            local fullId = entry.AnimationId -- It already has "rbxassetid://" based on your segment
            
            -- Filter logic
            if animName:find("Equip") or animName:find("Finish") or animName:find("Flourish") or 
               animName:find("Idle") or animName:find("Parry") or animName:find("Core") or 
               animName:find("Gk") or animName:find("Walk") or animName:find("Run") or animName:find("Camera") or animName:find("Glory") or animName:find("Block") or animName:find("Startup") or animName:find("Inspect") or animName:find("GK") or animName:find("Sprint") or animName:find("Status") or animName:find("Effect") or animName:find("Viewport") then
                
                ignore[fullId] = true
            else
                dontignore[fullId] = true
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
elseif ok_decode and pid == 8767500166 then 
    
else
    warn("Failed to decode JSON body.")
end
-- lock target on left click
local lastClick = false
task.spawn(function()
    while true do
        task.wait(0.016)
        local clicking = isleftpressed()
        if clicking and not lastClick then
            local color, name, sp, wp = tinmr()
            if name then
                for _, v in pairs(players:GetChildren()) do
                    if v.Name == name and v ~= lp then
                        _G.target = v
                        local tchar = v.Character
                        if tchar then
                            local hum = tchar:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local anim = hum:FindFirstChildOfClass("Animator")
                                if anim then
                                    _G.targetAnimator = anim
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
        lastClick = clicking
    end
end)

RunService.Render:Connect(function()
    local color, name, spos, worldpos = tinmr()
    DrawingImmediate.Circle(mousepos(), radius, color, 1, 200, 2)
    if name and spos then
        DrawingImmediate.Text(spos, 10, color, 1, name, true)
        if _G.target and name == _G.target.Name then
            DrawingImmediate.Text(
                Vector2.new(spos.X, spos.Y - 30),
                10,
                Color3.new(1, 1, 0),
                1,
                "[LOCKED]",
                true
            )
        end
    end
end)
