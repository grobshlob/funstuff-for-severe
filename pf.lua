local ws = workspace
local cam = ws.CurrentCamera
local DrawingAttach = Drawing.attach
local PointNew = PointInstance.new
local drawnParts = {} 
local y = 1
--ai,  it would only draw it on one dog tag
local function findAllDogBases()
    local bases = {}
    local ignore = ws:FindFirstChild("Ignore")
    if not ignore then return bases end
    local folder = ignore:FindFirstChild("GunDrop")
    if not folder then return bases end
    for _, v in ipairs(folder:GetChildren()) do
        if v.Name == "DogTag" then
            local base = v:FindFirstChild("Base")
            if base then
                table.insert(bases, base)
            end
        end
    end
    return bases
end
--
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
local function draw(part, color, thickness)
    local point = PointNew(part)
    local col = color or Color3.fromRGB(255, 0, 0)
    local thick = thickness or 1.85
    
    local sq = Drawing.new("Square")
    sq.Visible = true
    sq.Thickness = thick
    sq.Color = col
    sq.Filled = false
    sq.Opacity = 1
    
    local insq = Drawing.new("Square")
    insq.Visible = true
    insq.Thickness = thick
    insq.Color = col
    insq.Filled = true
    insq.Opacity = 0.5
    
    DrawingAttach({
        [sq] = { Link = point, Size = UDim2.fromScale(5, 10), AnchorPoint = Vector2.new(0.5, 1.5) },
        [insq] = { Link = point, Size = UDim2.fromScale(5, 10), AnchorPoint = Vector2.new(0.5, 1.5) }
    })
end
task.spawn(function()
	while task.wait(0.1) do
		findmuzzle()
		if not muzzle then print("none found") continue end
		if isleftpressed() and muzzle then
			y = 1
			task.spawn(function()
				local pos = muzzle.Position
				local point = Point3D.new(pos)
				local lv = muzzle.CFrame.LookVector
				if check(lv.Y, cam.CFrame.LookVector.Y) then y = -1 end
				y = y
				local forward = vector.normalize(lv) * vector.create(45, 45 * y, 45)
				local new = Point3D.new(pos + forward)
				local line = Drawing.new("Line")
				line.Visible = true
				line.Opacity = 0.5
				line.Thickness = 5
				line.Color = Color3.fromRGB(190, 0, 190)
				local cfg = Drawing.attach{
					[line] = {
						From = point,
						To = new
					}
				}
				task.wait(2)
				cfg:Destroy()
				line:Remove()
			end)
		end
		local targets = findAllDogBases()
		if not targets then continue end
		for _, part in ipairs(targets) do
			if drawnParts[part] then continue end
  			draw(part, Color3.fromRGB(118, 0, 118), 3)
  			drawnParts[part] = true
		end
	end
end)
