local players = game.Players
local lp = players.LocalPlayer
local ws = game.Workspace
function getkiller()
  for _, v in pairs(players:GetChildren()) do
    if v.Name ~= players.LocalPlayer.Name and v.Team.Name == "Killer" then
      local chara = v.Character
      local hrp = chara.HumanoidRootPart
      hpos = hrp.Position
      local hum = chara.Humanoid
      animator = hum.Animator
    end
  end
  return animator, hpos
end
--send_notification("script is currently down", "warning")
--task.wait(math.huge)
local function getPlayingAnimationTracks()
    local tracks = {}
    local anima = getkiller()
    if anima then
	    local ok, head = pcall(memory.readu64, anima, 0x888)
	    if not ok or head == 0 then return tracks end

	    local ok2, node = pcall(memory.readu64, head)
	    if not ok2 then return tracks end

	    local count = 0

	    while node ~= 0 and node ~= head and count < 100 do
	        count += 1
	        local ok3, track = pcall(memory.readu64, node + 0x10)
	        if ok3 and track ~= 0 then
	            local ok6, stringptr = pcall(memory.readu64, track, 0xd0)
	            if ok6 and stringptr > 100000 then
	                local ok5, timePos = pcall(memory.readf32, track, 0xe8)
	                local ok7 , asset = pcall(memory.readstring, stringptr, 0xd8)
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
	end
	return tracks
end

local dontdihgnore = { 
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://80411309607666"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://138720291317243"] = true,
    ["rbxassetid://115244153053858"] = true,
    ["rbxassetid://106871536134254"] = true
}

local swingPtr = nil
task.spawn(function()
	while task.wait(0.016) do
	    local ok, tracks = pcall(getPlayingAnimationTracks)
	    if not ok then continue end
		if lp then
			if lp.Team.Name == "Spectator" then continue end
		    local foundSwingPtr = nil
		    for _, t in ipairs(tracks) do
		        if t.assetid and dontdihgnore[t.assetid] then
		            foundSwingPtr = t.ptr
		            tposition = t.timePosition
		            --print(tostring(t.assetid))
		            break
		        end
		    end
		    local ping = game:GetPing() / 1000
		    if foundSwingPtr ~= swingPtr then
		        if swingPtr ~= nil then
		            --print("Swing stopped!")
		        end
		        local _, tpos = getkiller()
		        local lpos = players.LocalPlayer.Character.HumanoidRootPart.Position
		        if tpos then
		        	local dist = vector.magnitude(tpos - lpos)
			        if foundSwingPtr ~= nil and dist <= 10 then
			            --print("Swing started!")
			            local hold = tposition - ping
			           -- print(hold)
			            if hold >= 0 then
			              task.wait(math.clamp(hold, 0, 0.4))
			            end
			            mouse2click()
			            --print("hi i should be in the middle")
			        end
			        swingPtr = foundSwingPtr
			    end
			end
		end
	end
end)
local cam = ws.CurrentCamera
local rs = game.RunService
_G.killesp = true
_G.genesp = true
local killerdata = {}
function getkiller2()
	killerdata = {}
	if _G.killesp then
		for _, p in pairs(players:GetChildren()) do
			if p and lp then
				if p.Name ~= lp.Name and p.Team.Name == "Killer" and lp.Team.Name ~= "Spectator" then
					local killerchar = p.Character
					local hrp = killerchar.HumanoidRootPart
					local hrppos = hrp.Position
					local screen, visk = cam:WorldToScreenPoint(hrppos)
					local chara = lp.Character
					local mroot = chara.HumanoidRootPart
					local dist = vector.magnitude(mroot.Position - hrppos)
					local hh = math.clamp(1750/ dist, 18, 100)
					local hw = math.clamp(1000 / dist, 10, 45)
					if visk then
						local A = Vector2.new(screen.X - hw, screen.Y - hh) 
						local B = Vector2.new(screen.X + hw, screen.Y - hh) 
						local C = Vector2.new(screen.X + hw, screen.Y + hh) 
						local D = Vector2.new(screen.X - hw, screen.Y + hh)
						table.insert(killerdata, {root = hrp, rootpos = hrppos, a = A, b = B, c = C, d = D, boxsize = size})
					end
				end
			end
		end
		
	end
	return killerdata
end
local data = {}
local function draw(part1, math1, math2, math3, math4, math5, math6, rgb)
	local part = part1
	local partpos = part.Position
	local screen, vis = cam:WorldToScreenPoint(partpos)
	local chara = lp.Character
	if not chara then return end
	local mroot = chara.HumanoidRootPart
	if not mroot then return end
	local dist = vector.magnitude(mroot.Position - partpos)
	local hh = math.clamp(math1 / dist, math2, math3)
	local hw = math.clamp(math4 / dist, math5, math6)
	if not _G.genesp then vis = false end
	if vis then
		local A = Vector2.new(screen.X - hw, screen.Y - hh) 
		local B = Vector2.new(screen.X + hw, screen.Y - hh) 
		local C = Vector2.new(screen.X + hw, screen.Y + hh) 
		local D = Vector2.new(screen.X - hw, screen.Y + hh)
		table.insert(data, {main = part, pos = partpos, a = A, b = B, c = C, d = D, boxsize = size, color = rgb})
	end
end
_G.vaultesp = true
_G.pallet = true
function getgens()
	data = {}
	if not _G.genesp then return data end
	if _G.genesp then
		local ok2, map = pcall(function() return ws.Map end)
		for _, v in pairs(map:GetChildren()) do
			if string.find(v.Name, "Gen") then
				local folder = v
				if folder then
					if #folder:GetChildren() > 0 and lp.Team.Name ~= "Spectator" and lp.Team.Name ~= "Killer" then
						for _, v in pairs(folder:GetChildren()) do
							draw(v.HitBox, 1500, 13, 80, 1750, 20, 150, Color3.fromRGB(118, 0, 118))
						end
					end
				end
			end
			if string.find(v.Name, "Vault") and _G.vaultesp then
				local folder = v
				if folder then
					if #folder:GetChildren() > 0 and lp.Team.Name ~= "Spectator" then
						for _, windows in pairs(folder:GetChildren()) do
							draw(windows:FindFirstChild("Bottom"), 1250, 9, 20, 750, 15, 30, Color3.fromRGB(252,248,237))
						end
					end
				end
			elseif string.find(v.Name, "Window") and _G.vaultesp and lp.Team.Name ~= "Spectator" then
				local window = v
				for _, b in pairs(window:GetChildren()) do
					if b.Name == "Bottom" then
						draw(b, 1250, 9, 20, 3000, 15, 30, Color3.fromRGB(252,248,237))
					end
				end
			end
			if string.find(v.Name, "Pallets") and _G.pallet and v.Name ~= "Palletwrong" and lp.Team.Name ~= "Spectator" then
				if v then
					if #v:GetChildren() > 0 then
						for _, pals in pairs(v:GetChildren()) do
							draw(pals.HumanoidRootPart, 1500, 15, 60, 1500, 15, 60, Color3.fromRGB(34, 139, 34))
						end
					end
				end
			elseif string.find(v.Name, "Palletwrong") and _G.pallet and lp.Team.Name ~= "Spectator" then
				for _, p in pairs(v:GetChildren()) do
					if p.Name == "HumanoidRootPart" then
						draw(p, 2500, 20, 60, 1500, 20, 60, Color3.fromRGB(34, 139, 34))
					end
				end
			end
		end
	end
	return data
end

--ai
local function fetchOffsets()
    local success, response = pcall(function()
        return game:HttpGet("https://offsets.imtheo.lol/offsets.json")
    end)

    if not success or not response then 
        warn("Failed to fetch offsets via HttpGet")
        return nil 
    end
    return crypt.json.decode(response)
end

local FullData = fetchOffsets()
local FrameRotation = 0 

if FullData then
    local offsets = FullData.Offsets or FullData
    local rotationValue = offsets.GuiObject and offsets.GuiObject.Rotation

    if rotationValue then
        FrameRotation = tonumber(rotationValue)
    else
        warn("Could not find 'Rotation' offset inside GuiObject.")
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
local function normalizeAngle(angle)
    angle = angle % 360
    if angle < 0 then
        angle = angle + 360
    end
    return angle
end
local function getAngleDifference(angle1, angle2)
    angle1 = normalizeAngle(angle1)
    angle2 = normalizeAngle(angle2)
    local diff = math.abs(angle1 - angle2)
    if diff > 180 then
        diff = 360 - diff
    end
    return diff
end
local function isRotationClose(rotation1, rotation2, threshold)
    threshold = threshold or 5
    local difference = getAngleDifference(rotation1, rotation2)
    return difference <= threshold
end
--
rs.Render:Connect(function()
	local data = getgens()
	for _, i in pairs(data) do
		local check = i.main
		if check then
			local position = i.pos
			DrawingImmediate.FilledQuad(i.a, i.b, i.c, i.d, i.color, 0.4)
			DrawingImmediate.Quad(i.a, i.b, i.c, i.d, i.color, 1)
		end
	end
end)
_G.autocomplete = true
rs.PostData:Connect(function()
	if _G.autocomplete then
		if lp.Team.Name == "Spectator" then return end
		local CheckPrompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
		if CheckPrompt and #CheckPrompt:GetChildren() > 0 then
			local Line = CheckPrompt.Check.Line
			local Goal = CheckPrompt.Check.Goal

			local Rotation = memory.readf32(Line, FrameRotation)
			local GoalRotation = memory.readf32(Goal, FrameRotation)

			Rotation = normalizeAngle(Rotation)
			GoalRotation = normalizeAngle(GoalRotation)

			local lowerSuccess = normalizeAngle(104 + GoalRotation)
			local upperSuccess = normalizeAngle(114 + GoalRotation)
			local upperNeutral = normalizeAngle(159 + GoalRotation)

			if lowerSuccess <= Rotation and Rotation <= upperSuccess then
				keypress(32)
				keyrelease(32)
			end
		end
	end
end)
rs.Render:Connect(function()		
	local killerdata = getkiller2()
	for _, i in pairs(killerdata) do
		local check = i.root
		if check then
			local position = i.genpart
			DrawingImmediate.FilledQuad(i.a, i.b, i.c, i.d, Color3.fromRGB(235, 0, 0), 0.4)
			DrawingImmediate.Quad(i.a, i.b, i.c, i.d, Color3.fromRGB(235, 0, 0), 1)
		end
	end
end)
