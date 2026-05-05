--!optimize 2
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local char = lp.Character
local root = char:FindFirstChild("HumanoidRootPart")
local ws = game:GetService("Workspace")
--would be really easy to add support since u would just have to hardcode any movement/equip ids. only problem is timing but i mean it should be the same for swings
_G.target = nil
_G.targetsoundmaker = nil
_G.targets = {}
function getDistance(a, b)
    return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2 + (a.Z - b.Z)^2)
end

function tinmr()
    table.clear(_G.targets)
    for _, v in pairs(players:GetChildren()) do
        if v ~= lp then
            local tchar = v.Character
            if not tchar then continue end
            local troot = tchar:FindFirstChild("HumanoidRootPart")
            if troot then
                local rpos = troot.Position
                local root = char:FindFirstChild("HumanoidRootPart")
                if getDistance(root.Position, rpos) <= 14 then
                    table.insert(_G.targets, {
                        worldpos = rpos,
                        name = v.Name
                    })
                end
            end
        end
    end
    return worldpos
end
--thank you hashmka i skidded your method because ai couldnt figure it out
local function getsounds(soundmaker)
    local tracks = {}
    for _, v in pairs(soundmaker:GetDescendants()) do
    	if v:IsA("Sound") then
    		local play = memory.readu8(v, 0x154)
    		if play == 1 then
    			local id = memory.readstring(v, 0xe0)
                local playback = memory.readf32(v, 0x130)
    			table.insert(tracks, {
    				asset = id,
    				playing = play,
    				name = v.Name,
                    time = playback
    				}
    			)
    		end
    	end
    end
    return tracks
end


_G.dontignore = {}
_G.ignore = {}
_G.loaded = false
local pid = game.PlaceId
local body = nil
local data = nil

if pid == 15432890326 then
    local ok_body, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/blackout/blackoutrevivals.json")
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
if ok_decode and pid == 15432890326 then 
    print("game: blackout revival")
    local decodedJSON = data -- This is your array of animation objects
    for _, entry in pairs(decodedJSON) do
        if type(entry) == "table" and entry.Name and entry.SoundId then
            local soundName = entry.Name
            local fullId = entry.SoundId -- It already has "rbxassetid://" based on your segment
            
            -- Filter logic
            if soundName:find("Equip") then
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
else
    warn("Failed to decode JSON body.")
end
