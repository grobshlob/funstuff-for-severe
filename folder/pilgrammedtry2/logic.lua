local ws = game:GetService("Workspace") 
local players = game:GetService("Players")
local lp = players.LocalPlayer
local pgui = lp:FindFirstChild("PlayerGui")
local guiholder = pgui:FindFirstChild("ScreenGui")
local textoffset = 0xdb0
function freshchar()
	local chara = lp.Character
	if not chara then return end
	local root = chara:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local rpos = root.Position
	return chara, root, rpos
end
local mob = ws:FindFirstChild("Mobs")
local zones = {
	["The King's Den"] = {
		mobs = {"Thief King", "Thief", "PrairieCave1", "Pebble", "PrairieCave2"}
	}
}

function getzone()
	local zonegui = guiholder:FindFirstChild("ZoneText")
	local zonetext = zonegui:FindFirstChild("Title")
	local zonestring = memory.readstring(zonetext, textoffset)
	if zones[zonestring] then return zones[zonestring] end
	return false
end
function getindividualmobs(obj, zone, current)
	if zone[obj.Name] then
		current[obj] = true
		if not infocache[obj] then
			local hum = obj:FindFirstChild("Human") 
            if hum then 
                local anim = hum:FindFirstChild("Animator") 
                if anim then 
                    infocache[obj] = { 
                        humanoid = hum, 
                        animator = anim, 
                        model = obj 
                    } 
                    print(obj.Name) 
                end 
			end
		end
	end
end
local infocache = {}
function getmobs()
	local Zone = getzone()
	if not Zone then
		if next(infocache) ~= nil then table.clear(infocache) end
		return
	end
	local currentmobs = {}
	if zone then
		local active = zone.mobs
		for _, obj in pairs(mob:GetChildren()) do
			local match = false
			for _, act in pairs(active) do
				if obj:IsA("Folder") and string.find(obj.Name, act) then
					for _, sub in pairs(obj:GetChildren()) do
						getindividualmobs(obj, active, currentmobs)
					end
				else
					getindividualmobs(obj, active, currentmobs)
				end
			end
		end	
	end
	for obj, clear in pairs(infocache) do
		if not currentmobs[obj] or not clear.model or not clear.model.Parent then
			infocache[obj] = nil
		end
	end
end
task.spawn(function()
	while true do
		task.wait(1)
		getmobs()
		for _, info in pairs(infocache) do
			print(info.model.Name)
		end
	end
end)
