--getgc made by le hashmka 
local gc = luau.load(game:HttpGet("https://raw.githubusercontent.com/Sploiter13/severe/refs/heads/main/gc.luau",true),{debugName = "gc"})()
print("hi")
local clock1 = os.clock()
print(gc.setgc("SpreadBase", 0))
print(gc.setgc("SpreadAddFPSZoom", 0))
print(gc.setgc("SpreadAddFPSHip", 0))
print(gc.setgc("SpreadAddTPSZoom", 0))
print(gc.setgc("SpreadAddTPSHip", 0))
print(gc.setgc("PivotPoint", Vector3.new(0, 0, 0)))
send_notificatiom("no recoil and no spread done, other values will be set for cleaner recoil", "info")
print(gc.setgc("KickUpForce", 0))
print(gc.setgc("KickUpSpeed", 0))
print(gc.setgc("KickUpBounce", 0))
print(gc.setgc("KickUpCameraInfluence", 0))
print(gc.setgc("KickUpGunInfluence", 0))
print(gc.setgc("RaiseForce", 0))
print(gc.setgc("RaiseSpeed", 0))
print(gc.setgc("RaiseBounce", 0))
print(gc.setgc("RaiseInfluence", 0))
print(gc.setgc("ShiftForce", 0))
print(gc.setgc("ShiftSpeed", 0))
print(gc.setgc("ShiftBounce", 0))
print(gc.setgc("ShiftCameraInfluence", 0))
print(gc.setgc("ShiftGunInfluence", 0))
print(gc.setgc("SlideForce", 0))
print(gc.setgc("SlideSpeed", 0))
print(gc.setgc("SlideBounce", 0))
print(gc.setgc("SlideInfluence", 0))
print(gc.setgc("ShiftRoll", 0))
print(gc.setgc("RollRightBias", 0))
print(gc.setgc("RollLeftBias", 0))
local totaltime = os.clock() - clock1
send_notification("took " .. totaltime .. " seconds. enjoy", "success")
--[[
SpreadAddFPSZoom = 0 -- 0.125
SpreadAddFPSHip = 0 -- 4.42
SpreadAddTPSZoom = 0 -- 4.42
SpreadAddTPSHip = 0 -- 4.42
PivotPoint = Vector3.new(0,0,0)
KickUpForce = 0 -- 0.5
KickUpSpeed = 0 -- 1.8
KickUpBounce = 0 -- 1
KickUpCameraInfluence = 0 -- 1.3
KickUpGunInfluence = 0 -- 0.5
RaiseForce = 0
RaiseSpeed = 0 -- 10
RaiseBounce = 0 -- 1
RaiseInfluence = 0 -- 1
ShiftForce = 0 -- 0.67
ShiftSpeed = 0 -- 2.65
ShiftBounce = 0 -- 1
ShiftCameraInfluence = 0 -- 0.4
ShiftGunInfluence = 0 -- 0.5
SlideForce = 0 -- 3.88
SlideSpeed = 0 -- 3.52
SlideBounce = 0 -- 1
SlideInfluence = 0 -- 2.2
ShiftRoll = 0 -- 10
RollRightBias = 0 -- 1
RollLeftBias = 0 -- -1
]]


