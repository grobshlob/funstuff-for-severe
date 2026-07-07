--!optimize 2
local skid1 = game:GetService("RunService")
local skid2 = game:GetService("UserInputService")
local skid3 = game:GetService("Players")
local skid4 = skid3.LocalPlayer
local skid5 = game:GetService("Workspace")

_G.skid6 = nil
_G.skid7 = nil
_G.skid8 = nil
_G.stopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskiddingstopskidding9 = {}
_G.skid10 = {}

function skid11()
    table.clear(_G.skid9)
    local skid12 = skid3:GetChildren()
    for skid13, skid14 in pairs(skid12) do
        if skid14 ~= skid4 and skid14.ClassName == "Player" then
            local skid15 = skid14.Character
            local skid16 = skid4.Character
            if not skid15 or not skid16 then continue end
            local skid17 = skid15:FindFirstChild("HumanoidRootPart")
            if skid17 then
                if skid17:IsA("Part") then
                    local skid18 = skid15:FindFirstChild("Head")
                    if not skid18 then continue end
                    local skid19, skid20 = pcall(function() return skid17.Position end)
                    if not skid19 then return end
                    local skid21 = skid16:FindFirstChild("HumanoidRootPart")
                    if not skid21 or not skid20 then continue end
                    local skid22 = vector.magnitude(skid21.Position - skid20)
                    local skid23 = skid21.Position - skid20
                    local skid24 = vector.normalize(skid23)
                    local skid25 = vector.dot(skid18.CFrame.LookVector, skid24)
                    if skid22 <= 14 and (skid25 >= 0.8 and skid25 <= 1) then
                        if skid14.Name == "2grob" then
                            print("ur fighting the owner pls stop")
                            return
                        end
                        local skid26 = skid15:FindFirstChild("Humanoid")
                        local skid27 = skid26:FindFirstChild("Animator")
                        table.insert(_G.skid9, {
                            worldpos = skid20,
                            animator = skid27,
                            chara = skid15,
                            name = skid14.Name
                        })
                    end
                end
            end
        end
    end
    return worldpos
end

_G.skid28 = {}
function skid29(skid30)
    local skid31 = {}
    table.clear(_G.skid28)
    local skid32, skid33 = pcall(memory.readu64, skid30, 0x9d0)
    if not skid32 or skid33 == 0 then return skid31 end
    local skid34, skid35 = pcall(memory.readu64, skid33)
    if not skid34 then return skid31 end
    local skid36 = 0
    while skid35 ~= 0 and skid35 ~= skid33 and skid36 < 100 do
        skid36 += 1
        local skid37, skid38 = pcall(memory.readu64, skid35 + 0x10)
        if skid37 and skid38 ~= 0 then
            local skid39, skid40 = pcall(memory.readu64, skid38, 0xb8)
            local skid41, skid42 = pcall(memory.readu8, skid38, 0xa40)
            if skid39 and skid40 > 100000 then
                local skid43, skid44 = pcall(memory.readf32, skid38, 0xd0)
                local skid45, skid46 = pcall(memory.readstring, skid40, 0xc0)
                if skid42 == 1 then
                    _G.skid28[skid46] = true
                    table.insert(skid31, {
                        ptr = skid38,
                        timePosition = skid43 and skid44 or 0,
                        assetid = skid45 and skid46,
                    })
                else
                    _G.skid28[skid46] = nil
                end
            end
        end
        local skid47, skid48 = pcall(memory.readu64, skid35)
        if not skid47 then break end
        skid35 = skid48
    end
    return skid31
end

_G.skid49 = {}
_G.skid50 = {}
_G.skid51 = false

local skid52 = game.PlaceId
local skid53 = nil
local skid54 = nil

if skid52 == 4282985734 or skid52 == 11979315221 or skid52 == 11979319180 or skid52 == 18594569228 then
    local skid55, skid56 = pcall(function() 
        return game:HttpGet("https://githubusercontent.com") 
    end)
    if skid55 then skid53 = skid56 end
elseif skid52 == 128736949265057 then
    local skid55, skid56 = pcall(function() 
        return game:HttpGet("https://githubusercontent.com") 
    end)
    if skid55 then skid53 = skid56 end
end

local skid57 = false
if skid53 then
    local skid58, skid59 = pcall(function() return crypt.json.decode(skid53) end)
    if skid58 then
        skid54 = skid59
        skid57 = true
    end
end

function skid60(skid61)
    local skid62 = skid54
    _G.skid10 = skid62
    print(skid61)
    for skid63, skid64 in pairs(skid62) do
        if type(skid64) == "table" and skid64.Name and skid64.AnimationId then
            local skid65 = skid64.Name
            local skid66 = skid64.AnimationId
            if skid61 == "cw" then
                if skid65:find("Equip") or skid65:find("Finish") or skid65:find("Flourish") or skid65:find("Idle") or skid65:find("Parr") or skid65:find("Core") or skid65:find("Gk") or skid65:find("Walk") or skid65:find("Run") or skid65:find("Camera") or skid65:find("Glory") or skid65:find("Block") or skid65:find("Startup") or skid65:find("Inspect") or skid65:find("GK") or skid65:find("Sprint") or skid65:find("Status") or skid65:find("Effect") or skid65:find("Viewport") or skid65:find("Stomp") then
                    _G.skid50[skid66] = true
                else
                    _G.skid49[skid66] = true
                end
            elseif skid61 == "gakuran" then
                if skid65:find("Block") or skid65:find("Guard") or skid65:find("EHit") then
                    _G.skid50[skid66] = true
                else
                    _G.skid49[skid66] = true
                end
            end
        end
    end
    local skid67 = 0
    for _ in pairs(_G.skid50) do skid67 += 1 end
    local skid68 = 0
    for _ in pairs(_G.skid49) do skid68 += 1 end
    print("Successfully loaded JSON.")
    print("Ignored (Movement/Utility): " .. skid67)
    print("Targeted (Attacks): " .. skid68)
end

if skid57 and (skid52 == 4282985734 or skid52 == 11979315221 or skid52 == 11979319180 or skid52 == 18594569228) then
    skid60("cw")
elseif skid57 and skid52 == 128736949265057 then
    skid60("gakuran")
else
    warn("Failed to decode JSON body. Send this to brog: " .. game.PlaceId)
end
