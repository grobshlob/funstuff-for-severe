local ws = workspace
local cam = ws.CurrentCamera

local drawnParts = {} 
local y = 1

function findmuzzle()
	for _, c in pairs(cam:GetChildren()) do
		if c.ClassName == "Model" then
			if string.find(c.Name, "Main") then muzzle = nil return end
			for _, b in pairs(c:GetChildren()) do
				if not b:FindFirstChild("Arm") then
					if b.ClassName == "Part" and #b:GetChildren() == 1 then
						for _, n in pairs(b:GetChildren()) do
							if n.ClassName == "SpecialMesh" then
								muzzle = n.Parent
								return
							end
						end
					end
				end
			end
		end
	end
end
function check(a, b)
	return (a * b) > 0
end
local drawn = {}
local data = {}
game.RunService.PostLocal:Connect(function()
	findmuzzle()
	if not muzzle then return end
	if isleftpressed() and muzzle then
		y = 1
		local pos = muzzle.Position
		local lv = muzzle.CFrame.LookVector
		if check(lv.Y, cam.CFrame.LookVector.Y) then y = -1 end
		y = y
		local forward = vector.normalize(lv) * vector.create(45, 45 * y, 45)
		local new = pos + forward
		local shot = os.clock()
		table.insert(data, {pos = pos, new = new, shot = shot})
	end
end)

game.RunService.RenderUnrestricted:Connect(function()
	for i, stuff in pairs(data) do
		local age = os.clock() - stuff.shot
		if age <= 2 then
			local spos_muzzle, vis1 = cam:WorldToScreenPoint(stuff.pos)
			local spos_end, vis2 = cam:WorldToScreenPoint(stuff.new)
			if not vis1 or not vis2 then return end
			DrawingImmediate.Line(spos_muzzle, spos_end, Color3.fromRGB(118, 0, 118), 0.5, 5, 5)
			
		else
			table.remove(data, i)
		end
	end
end)

