local size = Vector2.new(5, 5) 
local canvas = Vector2.new(600, 600) 
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local clearkey = "C" 
function mousepos()
    return uis:GetMouseLocation()
end

local viewport = workspace.Camera.ViewportSize

local startX = (viewport.X / 2) - (canvas.X / 2)
local startY = (viewport.Y / 2) - (canvas.Y / 2)

local x_Positions = {}
local y_Positions = {}
local yx_Positions = {}

for i = startX, startX + canvas.X, size.X do
    table.insert(x_Positions, i)
end
for i = startY, startY + canvas.Y, size.Y do
    table.insert(y_Positions, i)
end

for _, px in pairs(x_Positions) do
    for _, py in pairs(y_Positions) do
        local slot = Vector2.new(px, py)
        table.insert(yx_Positions, slot)
    end
end

local drawn = {} 

function clear()
    local keys = getpressedkeys()
    if keys then
        for _, key in pairs(keys) do
            if key == clearkey or tostring(key) == tostring(clearkey) then
                drawn = {}
                break
            end
        end
    end
end

rs.Render:Connect(function()
    clear()
    
    DrawingImmediate.FilledRectangle(
        Vector2.new(startX, startY), 
        canvas, 
        Color3.new(0.5, 0.5, 0.5), 
        1, 
        1
    )
    
    if isleftpressed and isleftpressed() then
        local mpos = mousepos()
        
        if mpos.X >= startX and mpos.X <= startX + canvas.X and
           mpos.Y >= startY and mpos.Y <= startY + canvas.Y then
            
            for _, slot in ipairs(yx_Positions) do
                if math.abs(mpos.X - slot.X) <= size.X and math.abs(mpos.Y - slot.Y) <= size.Y then
                    local key = slot.X .. "_" .. slot.Y
                    drawn[key] = slot 
                    break
                end
            end
        end
    end
    
    for _, slot in pairs(drawn) do
        DrawingImmediate.FilledRectangle(
            slot, 
            size, 
            Color3.new(1, 1, 1), 
            1
        )
    end
end)
