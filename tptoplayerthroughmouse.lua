local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local char = lp.Character
local root = char:FindFirstChild("HumanoidRootPart")
local ws = game:GetService("Workspace")
local cam = ws.CurrentCamera
local radius = 60
local function get2dDistance(a, b)
	return math.sqrt((a.X - b.X)^2 + (a.Y - b.Y)^2)
end

local function mousepos()
	return uis:GetMouseLocation()
end
local function tinmr()
	local name = nil
	local color = Color3.new(0, 1, 0)
	local mpos = uis:GetMouseLocation()
	for _, v in pairs(players:GetChildren()) do
		if v ~= lp then
			local tchar = v.Character
			if not tchar then return end
			local troot = tchar:FindFirstChild("HumanoidRootPart")
			if not troot then return end
			local tpos = troot.Position
			local screenpos = cam:WorldToScreenPoint(tpos)
			if get2dDistance (mpos, screenpos) <= radius + 15 then
				color = Color3.new(1, 0, 0)
				name = v.Name
				spos = screenpos
				worldpos = tpos
			end
		end
	end
	return color, name, spos, worldpos
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
