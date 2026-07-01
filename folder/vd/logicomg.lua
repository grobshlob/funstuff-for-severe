local severeui = loadstring(game:HttpGet("https://raw.githubusercontent.com/okdude42/ui-lib/refs/heads/main/SevereLib.lua"))()
--print(_G.dpi)
local window = severeui:createwindow({
	Title = "Brog: Violence District",
	Version = ";-;",
	Keybind = "LeftAlt",
	ConfigFolder = "hiimbrog", -- this is what the folder in workspace will be named, this is where your configs save
	CustomResolution = Vector2.new(350, 160), -- adjust ui resolution
	DPIScale = _G.dpi, --only use if you have a custom scale set or 4k res, increments of .25
	
	DefaultTab = "Exploits", 
	TabAlignment = "Center", -- options: "Left", "Center", "Right"
	
	DefaultColor = Color3.fromRGB(28, 27, 31),
	DefaultAccent = Color3.fromRGB(208, 188, 255),
	DefaultSnowfall = true,
	DefaultScale = 1.0,
	DefaultFont = 5 -- all fonts are at the bottom of the script
})

-- create tabs
local vd = window:createtab("Exploits")
local vdesp = window:createtab("ESP")
window:createlabel(vd, "Auto Parry")
window:createseparator(vd, 1)
window:createtoggle(vd, {
	Name = "Toggle",
	Col = 1,
	Default = true,
	Callback = function(state) if state then _G.auto = true else _G.auto = false end end
})

window:createtoggle(vdesp, {
		Name = "Gens",
		Col = 1,
		Default = true,
		Callback = function(state) if state then _G.genesp = true else _G.genesp = false end end
})
window:createtoggle(vdesp, {
		Name = "Killer",
		Col = 1,
		Default = true,
		Callback = function(state) if state then _G.killesp = true else _G.killesp = false end end
})
window:createtoggle(vdesp, {
		Name = "Windows",
		Col = 2,
		Default = true,
		Callback = function(state) if state then _G.vaultesp = true else _G.vaultesp = false end end
})
window:createtoggle(vdesp, {
		Name = "Pallets",
		Col = 2,
		Default = true,
		Callback = function(state) if state then _G.pallet = true else _G.pallet = false end end
})

_G.vaultesp = false
_G.pallet = false
_G.killesp = false
_G.genesp = false
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
	    local ok, head = pcall(memory.readu64, anima, 0x9e8)
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
_G.auto = false
task.spawn(function()
	while task.wait(0.016) do
		if not _G.auto then continue end
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
local function draw(part, color, opacity, color2)
	local point = PointInstance.new(part)
	local sq = Drawing.new("Square")
	sq.Color = color2 or color
	sq.Opacity = opacity or 1
	sq.Visible = true
	sq.Filled = false
	sq.Thickness = 1.85
	local insq = Drawing.new("Square")
	insq.Color = color2 or color
	insq.Opacity = 0.25
	insq.Visible = true
	insq.Filled = true
	local config = {
		[sq] = {
			Link = part,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5)
		},
		[insq] = {
			Link = part,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}
	}
	Drawing.attach(config)
end
local killerdata = {}
function getkiller2()
	killerdata = {}
	if _G.killesp then
		for _, p in pairs(players:GetChildren()) do
			if p and lp then
				if p.Name ~= lp.Name and p.Team.Name == "Killer" and lp.Team.Name ~= "Spectator" then
					local killerchar = p.Character
					local hrp = killerchar.HumanoidRootPart
					draw(killerchar, Color3.fromRGB(255, 0, 0), 1)
				end
			end
		end	
	end
end
local data = {}
local pfind = false
local wfind = false
local drawn = false
local function checkmap()
	local map = ws.Map
	if #map:GetChildren() <= 0 then
		drawn = false
		return false 
	end
end
function getgens()
	data = {}
	local ok2, map = pcall(function() return ws.Map end)
	if lp.Team.Name == "Spectator" then return end
	for _, v in pairs(map:GetChildren()) do
		if string.find(v.Name, "Model") then
			if _G.pallet then
				for _, b in pairs(v:GetChildren()) do
					if string.find(b.Name, "Palletwrong") then
						for _, pparts in pairs(b:GetChildren()) do
							if pparts.Name == "PrimaryPartPallet" then
								draw(pparts, Color3.fromRGB(250, 200, 152))
							end
						end
					end
				end
			end
		end
		if v.ClassName == "Folder" then
			for _, b in pairs(v:GetChildren()) do
				if string.find(b.Name, "Window") then
					for _, n in pairs(b:GetChildren()) do
						if n.Name == "Bottom" then
							draw(n, Color3.fromRGB(252, 248, 237))
						end
					end
				end
				if string.find(b.Name, "Model") then
					for _, n in pairs(b:GetChildren()) do
						if string.find(n.Name, "Window") then
							for _, wpart in pairs(n:GetChildren()) do
								if wpart.Name == "Bottom" then
									draw(wpart, Color3.fromRGB(252, 248, 237))
								end
							end
						end
						if string.find(n.Name, "Palletwrong") then
							for _, ppart in pairs(n:GetChildren()) do
								if ppart.Name == "PrimaryPartPallet" then
									draw(ppart, Color3.fromRGB(250, 200, 152))
								end
							end
						end
					end
				end
				if string.find(b.Name, "Nature") then
					for _, n in pairs(b:GetChildren()) do
						if string.find(n.Name, "Palletwrong") then
							for _, ppart in pairs(n:GetChildren()) do
								if ppart.Name == "PrimaryPartPallet" then
									draw(ppart, Color3.fromRGB(250, 200, 152))
								end
							end
						end
					end
				end		
			end
		end				
		if string.find(v.Name, "Gen") and _G.genesp then
			local folder = v
			if folder then
				if #folder:GetChildren() > 0 and lp.Team.Name ~= "" then
					for _, v in pairs(folder:GetChildren()) do
						if v:FindFirstChild("GeneratorBody") then
							local repair = v:GetAttribute("RepairProgress")
							local progress = tonumber(repair)
							if progress < 100 then
								draw(v:FindFirstChild("GeneratorBody"), Color3.fromRGB(118, 0, 118))
							elseif progress >= 100 then
								draw(v:FindFirstChild("GeneratorBody"), Color3.fromRGB(34, 139, 34))
							end
						else print("not found?")
						end
					end
				end
			end
		end
		if string.find(v.Name, "Vault") and _G.vaultesp and not wfind then
			local folder = v
			if folder then
				if #folder:GetChildren() > 0 then
					for _, windows in pairs(folder:GetChildren()) do
						draw(windows:FindFirstChild("Bottom"), Color3.fromRGB(252, 248, 237))
					end
				end
			end
		elseif string.find(v.Name, "Window") and _G.vaultesp and not wfind then
			local window = v
			for _, b in pairs(window:GetChildren()) do
				if b.Name == "Bottom" then
					draw(b, Color3.fromRGB(252, 248, 237))
				end
			end
		end
		if string.find(v.Name, "Pallets") and _G.pallet and v.Name ~= "Palletwrong" and not pfind then
			if v then
				if #v:GetChildren() > 0 then
					for _, pals in pairs(v:GetChildren()) do
						if pals:FindFirstChild("HumanoidRootPart") then 
							draw(pals.HumanoidRootPart, Color3.fromRGB(250, 200, 152))
						end
					end
				end
			end
		elseif string.find(v.Name, "Palletwrong") and _G.pallet and not pfind then
			for _, p in pairs(v:GetChildren()) do
				if p.Name == "HumanoidRootPart" then
					draw(p, Color3.fromRGB(250, 200, 152))
				end
			end
		end
	end
	drawn = true
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
_G.autocomplete = false
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
task.spawn(function() 
	while task.wait(1) do
		if not checkmap() and not drawn then
			getgens()
			getkiller2()
		end
	end
end)
