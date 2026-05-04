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
local target = nil
local targetAnimator = nil
local baseline = {}
local swingPtr = nil
local baselineSampled = false

local function get2dDistance(a, b)
    return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2)
end

local function mousepos()
    return uis:GetMouseLocation()
end

local function tinmr()
    local name = nil
    local color = Color3.new(0, 1, 0)
    local mpos = uis:GetMouseLocation()
    for _, v in pairs(players:GetChildren()) do
        if v ~= lp then
            local tchar = v.Character
            if not tchar then return end
            local root = tchar:FindFirstChild("HumanoidRootPart").Position
            for _, parts in pairs(tchar:GetChildren()) do
                if parts:IsA("BasePart") then
                    local screenpos = cam:WorldToScreenPoint(parts.Position)
                    local screenpos2 = cam:WorldToScreenPoint(root)
                    if get2dDistance(mpos, screenpos) <= radius + 10 then
                        color = Color3.new(1, 0, 0)
                        name = v.Name
                        spos = screenpos2
                        worldpos = root
                    end
                end
            end
        end
    end
    return color, name, spos, worldpos
end

local function getPlayingAnimationTracks(animator)
    local tracks = {}
    local ok, topguy = pcall(memory.readu64, animator, 0x868)
    if not ok or head == 0 then return tracks end

    local ok2, bottomguys = pcall(memory.readu64, topguy)
    if not ok2 then return tracks end

    local count = 0
    while bottomguys ~= 0 and bottomguys ~= head and count < 100 do
        count += 1
        local ok3, track = pcall(memory.readu64, bottomguys + 0x10)
        if ok3 and track ~= 0 then
            local ok4, isPlaying = pcall(memory.readu8, track, 0xa18)
            if ok4 and isPlaying == 1 then
                local ok5, timePos = pcall(memory.readf32, track, 0xe8)
                local ok6, asset = pcall(memory.readstring, track, 0xd0)
                table.insert(tracks, {
                    ptr = track,
                    timePosition = ok5 and timePos or 0,
                    assetid = ok6 and asset,
                })
            end
        end
        local ok6, next = pcall(memory.readu64, bottomguys)
        if not ok6 then break end
        bottomguys = next
    end
    return tracks
end

local function sampleBaseline()
    baseline = {}
    swingPtr = nil
    baselineSampled = false
    --since the ptrs apparently change(according to claude) i made it so it detects any animations before swinging.
    --maybe hardcode assetids for games? or see if its looped
    print("sampling baseline for target")
    for i = 1, 60 do
        task.wait(0.1)
        if not targetAnimator then break end
        for _, t in ipairs(getPlayingAnimationTracks(targetAnimator)) do
            baseline[t.ptr] = true
        end
    end
    baselineSampled = true
    print("ready! tracking:", target.Name)
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
                        target = v
                        local tchar = v.Character
                        if tchar then
                            local hum = tchar:FindFirstChildOfClass("Humanoid")
                            if hum then
                                targetAnimator = hum:FindFirstChildOfClass("Animator")
                                task.spawn(sampleBaseline)
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

-- animation tracking loop
task.spawn(function()
    while true do
        task.wait(0.016)
        if not targetAnimator or not baselineSampled then continue end

        local ok, tracks = pcall(getPlayingAnimationTracks, targetAnimator)
        if not ok then continue end

        local foundSwingPtr = nil
        for _, t in ipairs(tracks) do
            if not baseline[t.ptr] then
                foundSwingPtr = t.ptr
                break
            end
        end

        if foundSwingPtr ~= swingPtr then
            if swingPtr ~= nil then
                print(target.Name .. " swing stopped!")
            end
            if foundSwingPtr ~= nil then
                print(target.Name .. " swing started!")
                task.wait(0.1)
                keypress(0x46)
                keyrelease(0x46)
            end
            swingPtr = foundSwingPtr
        end
    end
end)

RunService.Render:Connect(function()
    local color, name, spos, worldpos = tinmr()
    DrawingImmediate.Circle(mousepos(), radius, color, 1, 200, 2)
    if name and spos then
        DrawingImmediate.Text(spos, 25, color, 1, name, true)
        if target and name == target.Name then
            DrawingImmediate.Text(
                Vector2.new(spos.X, spos.Y - 30),
                20,
                Color3.new(1, 1, 0),
                1,
                "[LOCKED]",
                true
            )
        end
    end
end)
