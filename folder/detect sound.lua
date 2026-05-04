local holder = game.Players.LocalPlayer.Character

local function getsounds()
    local tracks = {}
    for _, v in pairs(holder:GetDescendants()) do
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
--blackout revival
local ignore = { 
  ["rbxassetid://14798996116"] = true,
  ["rbxassetid://9114461977"] = true,
  ["rbxassetid://7719563607"] = true,
}


local swingPtr = nil

while task.wait(0.016) do
	local ok, tracks = pcall(getsounds)
	if not ok then continue end
	
	local foundsound = false
	for _, t in ipairs(tracks) do
		if t.asset and not ignore[t.asset] then
			sound = t.playing
			foundsound = true
			print("Detected non-ignored anim: " .. tostring(t.asset), tostring(t.name), tostring(t.time)) --find missed anims
			break
		end
	end
	for _, i in ipairs(tracks) do
		local parrytime = i.time / 1.65
		if sound ~= 1 and tostring(i.name) == "MeleeSound" then
			print("Swing stopped!")
		end
		if foundsound and tostring(i.name) == "MeleeSound" then
			print("Swing started!")
			task.wait(parrytime)
			print("hi i should be in the middle")
		end
	end
end
