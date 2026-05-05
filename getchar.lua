local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local char = lp.Character
local root = char:FindFirstChild("HumanoidRootPart")
local ws = game:GetService("Workspace")
local cam = ws.CurrentCamera
local function get2dDistance(a, b)
	return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2)
end

local function mousepos()
	return uis:GetMouseLocation()
end
local function tinmr(folder)
	_G.characters = {}
	local color = Color3.new(0, 1, 0)
	local mpos = uis:GetMouseLocation()
	for _, v in pairs(folder:GetDescendants()) do
		if v ~= lp then
			local tchar = v.Character
			if not tchar then return end
			local troot = tchar:FindFirstChild("HumanoidRootPart")
			if troot then
				local tpos = troot.Position
				local screenpos = cam:WorldToScreenPoint(tpos)
				local screenpos2 = cam:WorldToScreenPoint(troot)
				if get2dDistance(mpos, screenpos) <= radius + 10 then
					table.insert(_G.characters, {
						color = Color3.new(1, 0, 0)
						name = v.Name
						spos = screenpos2
						worldpos = troot
						character = tchar
						}
					)	
				end
			end
		end
	end
	return color, name, spos, worldpos
end
_G.animator = nil
local clicked = false
task.spawn(function()
	while true do
		task.wait(0.016)
		if leftispressed() and not clicked then
			clicked = true
			for _, v in pairs(_G.Characters) do
				chara = v.character
				if chara then
					for _, g in pairs(chara:GetChildren()) do
						if g.Name == "Humanoid" then
							if g:FindFirstChild("Animator") then
								_G.animator = g
							end
						end
					end
				end
			end
		end
	end
end
RunService.Render:Connect(function()
	
	local color, name, spos, worldpos = tinmr()
	DrawingImmediate.Circle(
		mousepos(), 
		radius, 
		color,
		1, 
		200,
		2
	)
	if name and spos then
		DrawingImmediate.Text(
			spos,
			25,
			color,
			1,
			name,
			true
		)
		if isleftpressed() then
			root.CFrame = CFrame.new(worldpos)
		end
	end
end)
