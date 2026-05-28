--!strict
--!optimize 2

local RunService = game:GetService("RunService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor

;(function(): ()

local E = {} -- holds all Drawing objects and widget state

E.Square1 = Drawing.new("Square")

do
    E.img = Drawing.new("Image")
    E.img.Visible = true
    E.img.Url = "https://files.catbox.moe/jtar71.png"
    E.img.Size = Vector2.new(500, 300)
    E.img.Position = Vector2.new(0, 0)
    E.Square1.Position  = Vector2.new(-56, -40)
    E.Square1.Size      = Vector2.new(2416, 1383)
    E.Square1.Color     = Color3.fromRGB(112, 112, 112)
    E.Square1.Opacity   = 0.5
    E.Square1.Filled    = true
    E.Square1.Thickness = 1
    E.Square1.ZIndex    = 0
    E.Square1.Visible   = true
end

end)()
task.wait(10)
Drawing.clear()
