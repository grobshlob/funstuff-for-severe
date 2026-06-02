local players = game:GetService("Players")
local lp = players.LocalPlayer
local ws = game:GetService("Workspace")
local mobs = ws:FindFirstChild("Mobs")
function getlpchar()
	char = lp.Character
	if char then
		root = char:FindFirstChild("HumanoidRootPart")
		if root then
			lpos = root.Position
		end
	end
	return char, root, lpos
end
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
		local ok6, stringptr = pcall(memory.readu64, track, 0xd0)
		if ok6 then
			local ok5, timePos = pcall(memory.readf32, track, 0xe8)
			local ok7 , asset = pcall(memory.readstring, stringptr, 0xd0)
			table.insert(tracks, {
				ptr = track,
				timePosition = ok5 and timePos or 0,
				assetid = ok7 and tostring(asset) or "",
			})
		end
	end
	local nextNode = memory.readu64(node) 
	if nextNode == 0 or nextNode == node or nextNode == head then
		nextNode = memory.readu64(node + 0x8)
	end        
	if nextNode == 0 or nextNode == node or nextNode == head then break end
		node = nextNode
	end
	return tracks
end


_G.near = {}
_G.boss = nil
local link = game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/pilgrammedtry2/timings.json")
print("Raw Content Length: " .. #link)
local didit, decode = pcall(function() return crypt.json.decode(link) end)
local stuff = {}

local function getdata(place)
    for key, data in pairs(place) do
        if type(data) == "table" then
            if data.timing and data.type then
                local animid = data.id or tostring(_)  
				local skillname = tostring(key)
				local skilltype = data.type
                stuff[animid] = {
					bossname = data.boss,
                    delay = data.timing,
                    type = data.type,
                    distance = data.distance or 0,
                    skill = skillname,
					multi = data.amount
                }
				if skilltype == "multi" then
					stuff[animid] = {
						subtract = data.sub,
						multiply = data.multiplier,
						maximum = data.max
					}
				end
            else
                getdata(data)
            end
        end
    end
end
if didit then
	getdata(decode)
	print("did it")
end
function getboss(id)
	local selected = _G.boss
	local data = stuff[id]
	local boss = data.bossname
	local path = mobs:FindFirstChild(boss)
	local humanoid = path:FindFirstChild("Human")
	local humanoidrootpart = path:FindFirstChild("HumanoidRootPart")
	local rootposition = humanoidrootpart.Position
	table.insert(_G.near, {
		hum = humanoid,
		anim = humanoid:FindFirstChild("Animator"),
		hrp = humanoidrootpart,
		hpos = rootposition,
		target = boss
	})		
end

function waittime(id)
	local data = stuff[id]
	local delay = data.delay
	print(delay)
	local ping = game:GetPing() / 1000
	local holdtime = delay - ping
	return holdtime
end
local last = 0
function press()
	if os.clock() - last < .25 then
		return
	end
	last = os.clock()
	print("pressed")
	keypress(0x46)
	task.wait(0.15)
	keyrelease(0x46)
end
function hold(id)
	if os.clock() - last < .25 then
		return
	end
	last = os.clock()
	keypress(0x46)
	task.wait(waittime(id))
	keyrelease(0x46)
end
local proccessed = {}
local scheduled = {}
function parry()
	for _, v in pairs(_G.near) do
		local animator = v.anim
		local theirpos = v.hpos
		local tracks1 = getPlayingAnimationTracks(animator)
		for _, i in pairs(tracks1) do
			local idmem = i.assetid
			if idmem == "" then continue end
			if idmem ~= "rbxassetid://14079307927" and idmem ~= "rbxassetid://14069005805" and idmem ~= "rbxassetid://14070371463" and idmem ~= "rbxassetid://14071657488" and idmem ~= "rbxassetid://16930848691" then
				--print(idmem)
			end
			local key = 
				v.target .. 
				idmem
			if stuff[idmem] and not proccessed[key] then
				print("Found")
				proccessed[key] = os.clock()
				local data = stuff[idmem]
				local skillname = data.skill
				local type = data.type
				local name = data.bossname
				local check = data.distance
				local amountparry = data.multi
				print(skillname, type, name, check)
				if type == "normal" then
					scheduled[key] = true
					task.spawn(function()
						if holdtime <= 0.0075 then
							print("insta")
							press()
							task.wait(0.1)
							scheduled[key] = nil
						else
							task.wait(holdtime)
							press()
							task.wait(0.1)
							scheduled[key] = nil
						end
					end)
				elseif type == "multi" then
					scheduled[key] = true
					task.spawn(function()
						for i = 1, amountparry do
							if holdtime <= 0.0075 then
								print("insta")
								press()
								task.wait(0.1)
								scheduled[key] = nil
							else
								task.wait(holdtime)
								press()
								task.wait(0.1)
								scheduled[key] = nil
							end
						end
					end)
				elseif type == "dodge" then
					scheduled[key] = true
					task.spawn(function()
						keypress(0x10)
						task.wait(0.1)
						keypress(0x51)
						task.wait(0.1)
						keyrelease(0x51)
						task.wait(0.2)
						keyrelease(0x10)
						scheduled[key] = nil
					end)
				elseif type == "distance" then
					
						
					
				local holdtime = waittime(idmem)
				--print(i.assetid)
				for ptr, t in pairs(proccessed) do
					if os.clock() - t > 1 then
						proccessed[ptr] = nil
					end
				end
			else
				--print(idmem)
			end
		end
	end
end
task.spawn(function()
	while true do
		task.wait(0.5)
		getraceandanimator()
	end
end)
task.spawn(function()
	while true do
		task.wait(0.03)
		parry()
	end
end)


















--grobbrog
