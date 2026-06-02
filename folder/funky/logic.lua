local pl = game:GetService("Players") 
local lp = pl.LocalPlayer 
local ws = game:GetService("Workspace") 
local rs = game:GetService("RunService") 
local pgui = lp.PlayerGui 
local url = "https://offsets.imtheo.lol/offsets.json" 

-- GLOBAL KEY MAPS
local laneKeys = { Lane1 = 0x41, Lane2 = 0x53, Lane3 = 0x57, Lane4 = 0x44 }

local success, responseBody = pcall(function() return game:HttpGet(url) end) 

function getoffset() 
    if success and responseBody then 
        local decodeSuccess, decodedTable = pcall(function() return crypt.json.decode(responseBody) end) 
        if decodeSuccess and decodedTable and decodedTable.Offsets then 
            local guiOffsets = decodedTable.Offsets.GuiBase2D 
            return guiOffsets.AbsolutePosition, guiOffsets.AbsoluteSize 
        else 
            warn("Website data retrieved, but failed to parse JSON structure.") 
        end 
    else 
        warn("Failed to fetch data from the website. Check your URL or internet connection.") 
    end 
end 

local memf32 = memory.readf32 
local side = nil 

function findgui() 
    local ok, main = pcall(function() return pgui:FindFirstChild("Window") end) 
    if ok and main then 
        local ancestor = main:FindFirstChild("Game") 
        local hud = ancestor:FindFirstChild("HUD") 
        local bar = hud:FindFirstChild("Healthbar") 
        for _, lol in pairs(bar:GetChildren()) do 
            if string.find(lol.Name, "Right") or string.find(lol.Name, "Left") then
                for _, nub in pairs(lol:GetChildren()) do 
                    if nub:IsA("ImageLabel") and nub.Name == lp.DisplayName then 
                        side = string.find(lol.Name, "Right") and "Right" or "Left"
                    end 
                end 
            end 
        end 
    end 
    return side 
end 

local positionOffset, sizeOffset = getoffset() 

function lane1notes(whichside) 
    local lanes = { Lane1 = {}, Lane2 = {}, Lane3 = {}, Lane4 = {} }
    
    local ok, main = pcall(function() return pgui:FindFirstChild("Window") end) 
    if ok and main then 
        local ancestor = main:FindFirstChild("Game") 
        local field = ancestor:FindFirstChild("Fields") 
        local sideObj = field:FindFirstChild(whichside) 
        if sideObj then
            local holder = sideObj:FindFirstChild("Inner") 
            for _, hoop in pairs(holder:GetChildren()) do 
                for _, LOL in pairs(hoop:GetChildren()) do 
                    if LOL.Name == "Notes" and #LOL:GetChildren() > 0 then 
                        local laneName = LOL.Parent.Name 
                        
                        for _, lo in pairs(LOL:GetChildren()) do 
                            if lo:IsA("Frame") and lanes[laneName] then 
                                local isHold = false
                                local headLabel = nil
                                
                                for _, gh in pairs(lo:GetDescendants()) do 
                                    if gh:IsA("ImageLabel") then 
                                        if not headLabel then headLabel = gh end 
                                        
                                        local specialheight = memf32(gh, sizeOffset + 4) 
                                        if specialheight and specialheight ~= 168 and specialheight > 0 then 
                                            isHold = true
                                        end 
                                    end
                                end
                                
                                if headLabel then
                                    local receptor = hoop:FindFirstChild("Receptor") 
                                    local receptorY = memf32(receptor, positionOffset + 4)
                                    local headY = memf32(headLabel, positionOffset + 4) 
                                    
                                    if headY == receptorY then headY = memf32(lo, positionOffset + 4) end

                                    table.insert(lanes[laneName], {
                                        headY = headY, 
                                        key = laneKeys[laneName], 
                                        receptory = receptorY, 
                                        special = isHold, 
                                        name = lo.Name
                                    }) 
                                end
                            end 
                        end 
                    end 
                end 
            end 
        end 
    end 
    return lanes
end 

function press(key) 
    keypress(key) 
    keyrelease(key) 
end 

local hitNotesCache = {}
local activeHolds = {}
local MAX_HIT_DISTANCE = 45 

rs.PostModel:Connect(function() 
    if not side then 
        side = findgui() 
    end 
    if not side then return end

    local lanes = lane1notes(side) 

    for _, name in pairs({"Lane1", "Lane2", "Lane3", "Lane4"}) do
        local targetKey = laneKeys[name]
        local currentNoteStillExists = false

        -- Scan to see if the note we are currently holding is still present on screen
        if activeHolds[targetKey] then
            for _, v in pairs(lanes[name]) do
                if v.name == activeHolds[targetKey] then
                    currentNoteStillExists = true
                    break
                end
            end
            
            -- PRESENCE RELEASE: If the note object is gone, release the key instantly!
            if not currentNoteStillExists then
                keyrelease(targetKey)
                activeHolds[targetKey] = nil
            end
        end

        -- Note Tapping and Initialization loop
        for _, v in pairs(lanes[name]) do 
            local headDistance = v.headY - v.receptory

            if not hitNotesCache[v.name] and not activeHolds[targetKey] then
                if (headDistance >= -8 and headDistance <= MAX_HIT_DISTANCE) or (headDistance <= 8 and headDistance >= -MAX_HIT_DISTANCE) then
                    hitNotesCache[v.name] = true
                    
                    if v.special then
                        -- Lock down the hold: store the note's unique name
                        activeHolds[targetKey] = v.name
                        keypress(targetKey)
                    else
                        -- Normal tap
                        press(targetKey)
                    end
                    
                    task.delay(0.1, function() 
                        hitNotesCache[v.name] = nil 
                    end)
                    break
                end
            end
        end 
    end
end)
