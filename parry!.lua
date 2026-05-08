local mobfolder = game.Workspace.EnemyFolder 
local lp = game.Players.LocalPlayer 
local tracking = {}

local function getd(a, b) 
	return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2 + (a.Z - b.Z)^2) 
end 

local function getdy(a, b) 
	return math.sqrt((a.Y - b.Y)^2) 
end 

local function parry() 
	keypress(0x46) 
	task.wait(0.05) 
	keyrelease(0x46) 
end 

local function process() 
	local char = lp.Character 
	local root = char and char:FindFirstChild("HumanoidRootPart") 
	if not root then return end 
	local rpos = root.Position 

	for _, v in pairs(mobfolder:GetChildren()) do 
		local name = v.Name
		local hrp = v:FindFirstChild("HumanoidRootPart")
		local highlight = v:FindFirstChild("PreAttackHighlight")
		local highlightjump = v:FindFirstChild("Highlight")
		local bullet = v:FindFirstChild("RaygunBullet")
		local rocket = v:FindFirstChild("Base")
		local sound = nil
		if rocket then
			sound = rocket:FindFirstChild("RocketSound")
		end

		if not tracking[v] then
			if string.find(name, "Drone") and highlight then
				tracking[v] = true
				task.spawn(function()
					task.wait(0.65) 
					parry()
					task.wait(0.5) 
					tracking[v] = nil
				end)
			end

			if (string.find(name, "SillyDude") or string.find(name, "Swordenner") or string.find(name, "Dueler")) and highlight then 
				if hrp and getd(hrp.Position, rpos) < 50 then 
					tracking[v] = true 
					task.spawn(function() task.wait(0.565) parry() task.wait(.35) tracking[v] = nil end) 
				end 
			end

			if string.find(name, "Jumpo") and highlight then 
				tracking[v] = true 
				task.spawn(function() task.wait(0.8) parry() task.wait(0.5) tracking[v] = nil end) 
			end

			if string.find(name, "DESTRUCTOR") and highlight and hrp then 
				tracking[v] = true 
				if getdy(hrp.Position, rpos) > 4 and not highlightjump then 
					task.spawn(function() task.wait(3.3) parry() task.wait(0.5) tracking[v] = nil end) 
				else 
					task.spawn(function() task.wait(0.6) parry() task.wait(0.5) tracking[v] = nil end) 
				end 
				if highlightjump then
					task.spawn(function() task.wait(0.5) keypress(0x20) task.wait(1) keyrelease(0x20) task.wait(0.25) tracking[v] = nil end)
				end
			end 

			if string.find(name, "Automaton") then
				if highlightjump then
					tracking[v] = true
					task.spawn(function() keypress(0x20) task.wait(0.1) keyrelease(0x20) task.wait(0.5) tracking[v] = nil end)
				elseif highlight then
					tracking[v] = true
					task.spawn(function() task.wait(0.75) parry() task.wait(0.5) tracking[v] = nil end)
				end
			end
			if sound and string.find(name, "Spider") then
				tracking[v] = true
				task.spawn(function() task.wait(3.75) parry() task.wait(0.25) tracking[v] = nil end)
			end
			if bullet and (string.find(name, "Raygunniger") or string.find(name, "Dueler")) then 
				if getd(bullet.Position, rpos) < 12 then 
					tracking[v] = true
					task.spawn(function()
						parry()
						task.wait(0.2)
						tracking[v] = nil
					end)
				end 
			end 
		end
	end 
end 

task.spawn(function() 
	while true do 
		task.wait(0.01) 
		process() 
	end 
end)
