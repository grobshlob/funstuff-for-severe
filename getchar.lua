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
_G.characters = {}
function tinmr(folder)
	_G.characters = {}
	local color = Color3.new(0, 1, 0)
	local mpos = uis:GetMouseLocation()
	if _G.cleared then
		for _, v in pairs(folder:GetDescendants()) do
			if v ~= lp and v:IsA("Model") then
				local tchar = v.Character
				if not tchar then return end
				local troot = tchar:FindFirstChild("HumanoidRootPart")
				if troot then
					local tpos = troot.Position
					local screenpos = cam:WorldToScreenPoint(tpos)
					local screenpos2 = cam:WorldToScreenPoint(troot)
					local hum = tchar:FindFirstChild("Humanoid")
					local anim = hum:FindFirstChild("Animator")
					if get2dDistance(mpos, screenpos) <= radius + 10 then
						table.insert(_G.characters, {
							color = Color3.new(1, 0, 0),
							name = v.Name,
							spos = screenpos2,
							worldpos = troot,
							character = tchar,
							animator = anim,
							}
						)	
					end
				end
			end
		end
	end
end
_G.targetAnimator = nil
local clicked = false
task.spawn(function()
	while true do
		task.wait(0.016)
		if isleftpressed() and not clicked and not _G.character == {} then
			clicked = true
			for _, v in pairs(_G.characters) do
				chara = v.character
				if chara then
					for _, g in pairs(chara:GetChildren()) do
						if g.Name == "Humanoid" then
							if g:FindFirstChild("Animator") then
								_G.targetAnimator = g
							end
						end
					end
				end
			end
		end
	end
end)
RunService.Render:Connect(function()
	if _G.characters then
		for _, v in pairs(_G.characters) do
			name = v.name
			color = color
			spos = spos
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
					10,
					color,
					1,
					name,
					true
				)
			end
		end
	end
end)
