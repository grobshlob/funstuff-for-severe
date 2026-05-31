local players = game.Players
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

local function getPlayingAnimationTracks()
    local tracks = {}
    local anima = getkiller()
    if anima then
	    local ok, head = pcall(memory.readu64, anima, 0x868)
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
	            print("Swing stopped!")
	        end
	        local _, tpos = getkiller()
	        local lpos = players.LocalPlayer.Character.HumanoidRootPart.Position
	        if tpos then
	        	local dist = vector.magnitude(tpos - lpos)
		        if foundSwingPtr ~= nil and dist <= 10 then
		            --print("Swing started!")
		            local hold = tposition - ping
		            --print(hold)
		            if hold >= 0 then
		              task.wait(math.clamp(hold, 0, 0.4)
		            end
		            mouse2click()
		            --print("hi i should be in the middle")
		        end
		        swingPtr = foundSwingPtr
		    end
		end
	end
end)
local lp = players.LocalPlayer
local cam = ws.CurrentCamera
local rs = game.RunService
_G.killesp = true
_G.genesp = true
_G.palletesp = true
_G.destroypallets = false
local killerdata = {}
function getkiller2()
	killerdata = {}
	if _G.killesp then
		for _, p in pairs(players:GetChildren()) do
			if p.Name ~= lp.Name and p.Team.Name == "Killer" and lp.Team.Name ~= "Spectator" then
				local killerchar = p.Character
				local hrp = killerchar.HumanoidRootPart
				local hrppos = hrp.Position
				local screen, visk = cam:WorldToScreenPoint(hrppos)
				local chara = lp.Character
				local mroot = chara.HumanoidRootPart
				local dist = vector.magnitude(mroot.Position - hrppos)
				local hh = math.clamp(1750/ dist, 20, 90)
				local hw = math.clamp(1000 / dist, 12, 45)
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
	return killerdata
end
local data = {}
function getgens()
	data = {}
	if not _G.genesp then return data end
	if _G.genesp then
		local ok2, map = pcall(function() return ws.Map end)
		if ok2 and #map:GetChildren() > 0 then
			local ok, folder = pcall(function() return map:FindFirstChild("Generators") or map:FindFirstChild("Generator") or map:FindFirstChild("Gens") or map:FindFirstChild("newGenerators") end)
			if ok then
				if #folder:GetChildren() > 0 and lp.Team.Name ~= "Spectator" then
					for _, v in pairs(folder:GetChildren()) do
						local part = v.HitBox
						local partpos = part.Position
						local screen, vis = cam:WorldToScreenPoint(partpos)
						local chara = lp.Character
						local mroot = chara.HumanoidRootPart
						if not mroot then return end
						local dist = vector.magnitude(mroot.Position - partpos)
						local hh = math.clamp(1500 / dist, 17, 70)
						local hw = math.clamp(1750 / dist, 30, 150)
						if not _G.genesp then vis = false end
						if vis then
							local A = Vector2.new(screen.X - hw, screen.Y - hh) 
							local B = Vector2.new(screen.X + hw, screen.Y - hh) 
							local C = Vector2.new(screen.X + hw, screen.Y + hh) 
							local D = Vector2.new(screen.X - hw, screen.Y + hh)
							table.insert(data, {main = part, genpart = partpos, a = A, b = B, c = C, d = D, boxsize = size})
						end
					end
				end
			end
		end
	end
	return data
end
local function destroypallets()
	if lp.Team.Name == "Killer" then 
		local ok, map = pcall(function() return ws.Map end)
		if ok then
			local pallet = map.Pallets
			if pallet then
				if _G.destroypallets then
					for _, onbro in pairs(pallet:GetChildren()) do
						onbro:Destroy()
					end
				end
			end
		end
	end
end

task.spawn(function()
	while true do 
		task.wait(3)
		destroypallets()
	end
end)
rs.Render:Connect(function()
	local data = getgens()
	for _, i in pairs(data) do
		local check = i.main
		if check then
			local position = i.genpart
			DrawingImmediate.FilledQuad(i.a, i.b, i.c, i.d, Color3.fromRGB(118, 0, 118), 0.5)
		end
	end
end)

rs.Render:Connect(function()
	local killerdata = getkiller2()
	for _, i in pairs(killerdata) do
		local check = i.root
		if check then
			local position = i.genpart
			DrawingImmediate.FilledQuad(i.a, i.b, i.c, i.d, Color3.fromRGB(235, 0, 0), 0.5)
		end
	end
end)

