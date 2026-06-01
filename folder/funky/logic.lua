
local pl = game:GetService("Players")
local lp = pl.LocalPlayer
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")
local cam = ws.CurrentCamera
local pgui = lp.PlayerGui
local url = "https://offsets.imtheo.lol/version-2b1721d47abf49aa/offsets.json"
local success, responseBody = pcall(function()
    return game:HttpGet(url)
end)
function getoffset()
	if success and responseBody then
	    local decodeSuccess, decodedTable = pcall(function()
	        return crypt.json.decode(responseBody)
	    end)
	    if decodeSuccess and decodedTable and decodedTable.Offsets then
	        local guiOffsets = decodedTable.Offsets.GuiBase2D
	        
	        local positionOffset = guiOffsets.AbsolutePosition
	        local sizeOffset = guiOffsets.AbsoluteSize
	        return positionOffset, sizeOffset
	    else
	        warn("Website data retrieved, but failed to parse JSON structure.")
	    end
	else
	    warn("Failed to fetch data from the website. Check your URL or internet connection.")
	end
end
local memu32 = memory.readu32
local memu64 = memory.readu64
local memf32 = memory.readf32
local side = nil
function findgui()
	local ok, main = pcall(function() return pgui:FindFirstChild("Window") end)
	if ok and main then
		local ancestor = main:FindFirstChild("Game")
		local hud= ancestor:FindFirstChild("HUD")
		local bar = hud:FindFirstChild("Healthbar")
		for _, lol in pairs(bar:GetChildren()) do
			if string.find(lol.Name, "Right") then
				for _, nub in pairs(lol:GetChildren()) do
					if nub:IsA("ImageLabel") then
						local n = nub.Name
						if n == lp.DisplayName then side = "Right" end
					end
				end
			end
			if string.find(lol.Name, "Left") then
				for _, nob in pairs(lol:GetChildren()) do
					if nob:IsA("ImageLabel") then
						local n = nob.Name
						if n == lp.DisplayName then side = "Left" end
					end
				end
			end
		end
	end
	return side
end
local positionOffset, sizeOffset = getoffset()
local note = {}
function lane1notes(whichside, lane)
	local chara, r, rp, rts, vis = fresh()
	if chara then
		local ok, main = pcall(function() return pgui:FindFirstChild("Window") end)
		if ok and main then
			local ancestor = main:FindFirstChild("Game")
			local field = ancestor:FindFirstChild("Fields")
			local side = field:FindFirstChild(whichside)
			local holder = side:FindFirstChild("Inner")
			for _, hoop in pairs(holder:GetChildren()) do
				if hoop.Name == lane then
					for _, LOL in pairs(hoop:GetChildren()) do
					--	print("2")
						if LOL.Name == "Notes" then
							--print("3")
							if #LOL:GetChildren() > 0 then
								for _, lo in pairs(LOL:GetChildren()) do
									if lo:IsA("Frame") then
										for _, gh in pairs(lo:GetDescendants()) do
											--print(gh.Name)
											if gh:IsA("ImageLabel") then 
												local specialheight = memf32(gh, sizeOffset + 4) 
												if specialheight ~= 168 then 
													local holdtime = 0.2 + (0.084 * math.sqrt(specialheight))
													print(holdtime)
													table.insert(note, {special = true, hold = holdtime})
												end
												
											end  				
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return note
end


