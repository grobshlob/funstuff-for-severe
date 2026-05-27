--!strict
--!optimize 2

local RunService = game:GetService("RunService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor

;(function(): ()

local E = {} -- holds all Drawing objects and widget state

E.Square2 = Drawing.new("Square")
E.Line2 = Drawing.new("Line")
E.Line3 = Drawing.new("Line")
E.Line4 = Drawing.new("Line")
E.Line5 = Drawing.new("Line")
E.Line6 = Drawing.new("Line")
E.Line7 = Drawing.new("Line")
E.Line8 = Drawing.new("Line")
E.Line9 = Drawing.new("Line")
E.Line10 = Drawing.new("Line")
E.Line11 = Drawing.new("Line")
E.Polyline1 = Drawing.new("Polyline")
E.Line12 = Drawing.new("Line")
E.Line13 = Drawing.new("Line")
E.Line14 = Drawing.new("Line")
E.Line15 = Drawing.new("Line")
E.Line16 = Drawing.new("Line")
E.Line17 = Drawing.new("Line")
E.Line5Copy = Drawing.new("Line")
E.Line4Copy = Drawing.new("Line")
E.Line3Copy = Drawing.new("Line")
E.Line6Copy = Drawing.new("Line")
E.Line18 = Drawing.new("Line")
E.Line19 = Drawing.new("Line")
E.Line20 = Drawing.new("Line")
E.Line21 = Drawing.new("Line")
E.Line22 = Drawing.new("Line")
E.Line23 = Drawing.new("Line")
E.Line23Copy = Drawing.new("Line")
E.Line23Copy2 = Drawing.new("Line")
E.Line23Copy3 = Drawing.new("Line")
E.Line23Copy4 = Drawing.new("Line")
E.Line23Copy5 = Drawing.new("Line")
E.Line23Copy6 = Drawing.new("Line")
E.Line6Copy2 = Drawing.new("Line")
E.Line6Copy3 = Drawing.new("Line")
E.Line6Copy4 = Drawing.new("Line")
E.Line6Copy5 = Drawing.new("Line")
E.Line6Copy6 = Drawing.new("Line")
E.Line6Copy7 = Drawing.new("Line")
E.Line6Copy8 = Drawing.new("Line")
E.Line6Copy9 = Drawing.new("Line")
E.Line6Copy10 = Drawing.new("Line")
E.Line24 = Drawing.new("Line")
E.Line24Copy = Drawing.new("Line")
E.Line24Copy2 = Drawing.new("Line")
E.Line24Copy3 = Drawing.new("Line")
E.Line24Copy4 = Drawing.new("Line")
E.Line24Copy5 = Drawing.new("Line")
E.Line24Copy6 = Drawing.new("Line")
E.Line24Copy7 = Drawing.new("Line")
E.Line24Copy8 = Drawing.new("Line")
E.Line24Copy9 = Drawing.new("Line")
E.Line23Copy7 = Drawing.new("Line")
E.Line23Copy8 = Drawing.new("Line")
E.Line24Copy10 = Drawing.new("Line")
E.Line23Copy9 = Drawing.new("Line")
E.Line23Copy10 = Drawing.new("Line")

do

    E.Square2.Position  = Vector2.new(-434, -634)
    E.Square2.Size      = Vector2.new(2696, 1939)
    E.Square2.Color     = Color3.fromRGB(92, 92, 92)
    E.Square2.Opacity   = 0.36
    E.Square2.Filled    = true
    E.Square2.Thickness = 1
    E.Square2.ZIndex    = -1
    E.Square2.Visible   = true

    E.Line2.From      = Vector2.new(832, 703)
    E.Line2.To        = Vector2.new(876, 706)
    E.Line2.Color     = Color3.fromRGB(240, 0, 164)
    E.Line2.Opacity   = 1
    E.Line2.Thickness = 1
    E.Line2.ZIndex    = 0
    E.Line2.Visible   = true

    E.Line3.From      = Vector2.new(832, 703)
    E.Line3.To        = Vector2.new(842, 638)
    E.Line3.Color     = Color3.fromRGB(240, 0, 164)
    E.Line3.Opacity   = 1
    E.Line3.Thickness = 1
    E.Line3.ZIndex    = 0
    E.Line3.Visible   = true

    E.Line4.From      = Vector2.new(842, 640)
    E.Line4.To        = Vector2.new(864, 549)
    E.Line4.Color     = Color3.fromRGB(240, 0, 164)
    E.Line4.Opacity   = 1
    E.Line4.Thickness = 1
    E.Line4.ZIndex    = 0
    E.Line4.Visible   = true

    E.Line5.From      = Vector2.new(864, 549)
    E.Line5.To        = Vector2.new(893, 500)
    E.Line5.Color     = Color3.fromRGB(240, 0, 164)
    E.Line5.Opacity   = 1
    E.Line5.Thickness = 1
    E.Line5.ZIndex    = 0
    E.Line5.Visible   = true

    E.Line6.From      = Vector2.new(894, 499)
    E.Line6.To        = Vector2.new(971, 459)
    E.Line6.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6.Opacity   = 1
    E.Line6.Thickness = 1
    E.Line6.ZIndex    = 0
    E.Line6.Visible   = true

    E.Line7.From      = Vector2.new(968, 460)
    E.Line7.To        = Vector2.new(1009, 451)
    E.Line7.Color     = Color3.fromRGB(240, 0, 164)
    E.Line7.Opacity   = 1
    E.Line7.Thickness = 1
    E.Line7.ZIndex    = 0
    E.Line7.Visible   = true

    E.Line8.From      = Vector2.new(951, 442)
    E.Line8.To        = Vector2.new(1009, 452)
    E.Line8.Color     = Color3.fromRGB(240, 0, 164)
    E.Line8.Opacity   = 1
    E.Line8.Thickness = 1
    E.Line8.ZIndex    = 0
    E.Line8.Visible   = true

    E.Line9.From      = Vector2.new(906, 445)
    E.Line9.To        = Vector2.new(952, 443)
    E.Line9.Color     = Color3.fromRGB(240, 0, 164)
    E.Line9.Opacity   = 1
    E.Line9.Thickness = 1
    E.Line9.ZIndex    = 0
    E.Line9.Visible   = true

    E.Line10.From      = Vector2.new(853, 453)
    E.Line10.To        = Vector2.new(909, 445)
    E.Line10.Color     = Color3.fromRGB(240, 0, 164)
    E.Line10.Opacity   = 1
    E.Line10.Thickness = 1
    E.Line10.ZIndex    = 0
    E.Line10.Visible   = true

    E.Line11.From      = Vector2.new(883, 430)
    E.Line11.To        = Vector2.new(855, 452)
    E.Line11.Color     = Color3.fromRGB(240, 0, 164)
    E.Line11.Opacity   = 1
    E.Line11.Thickness = 1
    E.Line11.ZIndex    = 0
    E.Line11.Visible   = true

    E.Polyline1.Points    = { Vector2.new(883, 430), Vector2.new(920, 413) }
    E.Polyline1.Color     = Color3.fromRGB(240, 0, 164)
    E.Polyline1.Opacity   = 1
    E.Polyline1.Filled    = false
    E.Polyline1.Thickness = 1
    E.Polyline1.ZIndex    = 0
    E.Polyline1.Visible   = true

    E.Line12.From      = Vector2.new(918, 413)
    E.Line12.To        = Vector2.new(980, 400)
    E.Line12.Color     = Color3.fromRGB(240, 0, 164)
    E.Line12.Opacity   = 1
    E.Line12.Thickness = 1
    E.Line12.ZIndex    = 0
    E.Line12.Visible   = true

    E.Line13.From      = Vector2.new(979, 400)
    E.Line13.To        = Vector2.new(1019, 405)
    E.Line13.Color     = Color3.fromRGB(240, 0, 164)
    E.Line13.Opacity   = 1
    E.Line13.Thickness = 1
    E.Line13.ZIndex    = 0
    E.Line13.Visible   = true

    E.Line14.From      = Vector2.new(1019, 405)
    E.Line14.To        = Vector2.new(1036, 412)
    E.Line14.Color     = Color3.fromRGB(240, 0, 164)
    E.Line14.Opacity   = 1
    E.Line14.Thickness = 1
    E.Line14.ZIndex    = 0
    E.Line14.Visible   = true

    E.Line15.From      = Vector2.new(1017, 382)
    E.Line15.To        = Vector2.new(1036, 412)
    E.Line15.Color     = Color3.fromRGB(240, 0, 164)
    E.Line15.Opacity   = 1
    E.Line15.Thickness = 1
    E.Line15.ZIndex    = 0
    E.Line15.Visible   = true

    E.Line16.From      = Vector2.new(985, 348)
    E.Line16.To        = Vector2.new(1018, 384)
    E.Line16.Color     = Color3.fromRGB(240, 0, 164)
    E.Line16.Opacity   = 1
    E.Line16.Thickness = 1
    E.Line16.ZIndex    = 0
    E.Line16.Visible   = true

    E.Line17.From      = Vector2.new(958, 329)
    E.Line17.To        = Vector2.new(986, 349)
    E.Line17.Color     = Color3.fromRGB(240, 0, 164)
    E.Line17.Opacity   = 1
    E.Line17.Thickness = 1
    E.Line17.ZIndex    = 0
    E.Line17.Visible   = true

    E.Line5Copy.From      = Vector2.new(907, 552)
    E.Line5Copy.To        = Vector2.new(936, 503)
    E.Line5Copy.Color     = Color3.fromRGB(240, 0, 164)
    E.Line5Copy.Opacity   = 1
    E.Line5Copy.Thickness = 1
    E.Line5Copy.ZIndex    = 0
    E.Line5Copy.Visible   = true

    E.Line4Copy.From      = Vector2.new(885, 643)
    E.Line4Copy.To        = Vector2.new(907, 551)
    E.Line4Copy.Color     = Color3.fromRGB(240, 0, 164)
    E.Line4Copy.Opacity   = 1
    E.Line4Copy.Thickness = 1
    E.Line4Copy.ZIndex    = 0
    E.Line4Copy.Visible   = true

    E.Line3Copy.From      = Vector2.new(876, 707)
    E.Line3Copy.To        = Vector2.new(885, 641)
    E.Line3Copy.Color     = Color3.fromRGB(240, 0, 164)
    E.Line3Copy.Opacity   = 1
    E.Line3Copy.Thickness = 1
    E.Line3Copy.ZIndex    = 0
    E.Line3Copy.Visible   = true

    E.Line6Copy.From      = Vector2.new(937, 502)
    E.Line6Copy.To        = Vector2.new(1022, 479)
    E.Line6Copy.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy.Opacity   = 1
    E.Line6Copy.Thickness = 1
    E.Line6Copy.ZIndex    = 0
    E.Line6Copy.Visible   = true

    E.Line18.From      = Vector2.new(958, 328)
    E.Line18.To        = Vector2.new(1007, 332)
    E.Line18.Color     = Color3.fromRGB(240, 0, 164)
    E.Line18.Opacity   = 1
    E.Line18.Thickness = 1
    E.Line18.ZIndex    = 0
    E.Line18.Visible   = true

    E.Line19.From      = Vector2.new(1008, 333)
    E.Line19.To        = Vector2.new(1047, 346)
    E.Line19.Color     = Color3.fromRGB(240, 0, 164)
    E.Line19.Opacity   = 1
    E.Line19.Thickness = 1
    E.Line19.ZIndex    = 0
    E.Line19.Visible   = true

    E.Line20.From      = Vector2.new(1044, 345)
    E.Line20.To        = Vector2.new(1079, 381)
    E.Line20.Color     = Color3.fromRGB(240, 0, 164)
    E.Line20.Opacity   = 1
    E.Line20.Thickness = 1
    E.Line20.ZIndex    = 0
    E.Line20.Visible   = true

    E.Line21.From      = Vector2.new(1079, 381)
    E.Line21.To        = Vector2.new(1092, 406)
    E.Line21.Color     = Color3.fromRGB(240, 0, 164)
    E.Line21.Opacity   = 1
    E.Line21.Thickness = 1
    E.Line21.ZIndex    = 0
    E.Line21.Visible   = true

    E.Line22.From      = Vector2.new(1091, 406)
    E.Line22.To        = Vector2.new(1106, 384)
    E.Line22.Color     = Color3.fromRGB(240, 0, 164)
    E.Line22.Opacity   = 1
    E.Line22.Thickness = 1
    E.Line22.ZIndex    = 0
    E.Line22.Visible   = true

    E.Line23.From      = Vector2.new(1106, 386)
    E.Line23.To        = Vector2.new(1140, 361)
    E.Line23.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23.Opacity   = 1
    E.Line23.Thickness = 1
    E.Line23.ZIndex    = 0
    E.Line23.Visible   = true

    E.Line23Copy.From      = Vector2.new(1141, 361)
    E.Line23Copy.To        = Vector2.new(1151, 359)
    E.Line23Copy.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy.Opacity   = 1
    E.Line23Copy.Thickness = 1
    E.Line23Copy.ZIndex    = 0
    E.Line23Copy.Visible   = true

    E.Line23Copy2.From      = Vector2.new(1188, 362)
    E.Line23Copy2.To        = Vector2.new(1205, 365)
    E.Line23Copy2.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy2.Opacity   = 1
    E.Line23Copy2.Thickness = 1
    E.Line23Copy2.ZIndex    = 0
    E.Line23Copy2.Visible   = true

    E.Line23Copy3.From      = Vector2.new(1187, 385)
    E.Line23Copy3.To        = Vector2.new(1205, 366)
    E.Line23Copy3.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy3.Opacity   = 1
    E.Line23Copy3.Thickness = 1
    E.Line23Copy3.ZIndex    = 0
    E.Line23Copy3.Visible   = true

    E.Line23Copy4.From      = Vector2.new(1163, 400)
    E.Line23Copy4.To        = Vector2.new(1189, 383)
    E.Line23Copy4.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy4.Opacity   = 1
    E.Line23Copy4.Thickness = 1
    E.Line23Copy4.ZIndex    = 0
    E.Line23Copy4.Visible   = true

    E.Line23Copy5.From      = Vector2.new(1138, 414)
    E.Line23Copy5.To        = Vector2.new(1165, 399)
    E.Line23Copy5.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy5.Opacity   = 1
    E.Line23Copy5.Thickness = 1
    E.Line23Copy5.ZIndex    = 0
    E.Line23Copy5.Visible   = true

    E.Line23Copy6.From      = Vector2.new(1118, 428)
    E.Line23Copy6.To        = Vector2.new(1139, 414)
    E.Line23Copy6.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy6.Opacity   = 1
    E.Line23Copy6.Thickness = 1
    E.Line23Copy6.ZIndex    = 0
    E.Line23Copy6.Visible   = true

    E.Line6Copy2.From      = Vector2.new(1022, 478)
    E.Line6Copy2.To        = Vector2.new(1010, 529)
    E.Line6Copy2.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy2.Opacity   = 1
    E.Line6Copy2.Thickness = 1
    E.Line6Copy2.ZIndex    = 0
    E.Line6Copy2.Visible   = true

    E.Line6Copy3.From      = Vector2.new(1010, 526)
    E.Line6Copy3.To        = Vector2.new(1014, 577)
    E.Line6Copy3.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy3.Opacity   = 1
    E.Line6Copy3.Thickness = 1
    E.Line6Copy3.ZIndex    = 0
    E.Line6Copy3.Visible   = true

    E.Line6Copy4.From      = Vector2.new(1014, 576)
    E.Line6Copy4.To        = Vector2.new(1022, 603)
    E.Line6Copy4.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy4.Opacity   = 1
    E.Line6Copy4.Thickness = 1
    E.Line6Copy4.ZIndex    = 0
    E.Line6Copy4.Visible   = true

    E.Line6Copy5.From      = Vector2.new(1022, 604)
    E.Line6Copy5.To        = Vector2.new(1037, 588)
    E.Line6Copy5.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy5.Opacity   = 1
    E.Line6Copy5.Thickness = 1
    E.Line6Copy5.ZIndex    = 0
    E.Line6Copy5.Visible   = true

    E.Line6Copy6.From      = Vector2.new(1045, 535)
    E.Line6Copy6.To        = Vector2.new(1037, 590)
    E.Line6Copy6.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy6.Opacity   = 1
    E.Line6Copy6.Thickness = 1
    E.Line6Copy6.ZIndex    = 0
    E.Line6Copy6.Visible   = true

    E.Line6Copy7.From      = Vector2.new(1050, 487)
    E.Line6Copy7.To        = Vector2.new(1044, 537)
    E.Line6Copy7.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy7.Opacity   = 1
    E.Line6Copy7.Thickness = 1
    E.Line6Copy7.ZIndex    = 0
    E.Line6Copy7.Visible   = true

    E.Line6Copy8.From      = Vector2.new(1063, 521)
    E.Line6Copy8.To        = Vector2.new(1050, 486)
    E.Line6Copy8.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy8.Opacity   = 1
    E.Line6Copy8.Thickness = 1
    E.Line6Copy8.ZIndex    = 0
    E.Line6Copy8.Visible   = true

    E.Line6Copy9.From      = Vector2.new(1071, 560)
    E.Line6Copy9.To        = Vector2.new(1063, 520)
    E.Line6Copy9.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy9.Opacity   = 1
    E.Line6Copy9.Thickness = 1
    E.Line6Copy9.ZIndex    = 0
    E.Line6Copy9.Visible   = true

    E.Line6Copy10.From      = Vector2.new(1085, 589)
    E.Line6Copy10.To        = Vector2.new(1072, 561)
    E.Line6Copy10.Color     = Color3.fromRGB(240, 0, 164)
    E.Line6Copy10.Opacity   = 1
    E.Line6Copy10.Thickness = 1
    E.Line6Copy10.ZIndex    = 0
    E.Line6Copy10.Visible   = true

    E.Line24.From      = Vector2.new(1095, 624)
    E.Line24.To        = Vector2.new(1085, 589)
    E.Line24.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24.Opacity   = 1
    E.Line24.Thickness = 1
    E.Line24.ZIndex    = 0
    E.Line24.Visible   = true

    E.Line24Copy.From      = Vector2.new(1096, 624)
    E.Line24Copy.To        = Vector2.new(1109, 579)
    E.Line24Copy.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy.Opacity   = 1
    E.Line24Copy.Thickness = 1
    E.Line24Copy.ZIndex    = 0
    E.Line24Copy.Visible   = true

    E.Line24Copy2.From      = Vector2.new(1107, 582)
    E.Line24Copy2.To        = Vector2.new(1101, 527)
    E.Line24Copy2.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy2.Opacity   = 1
    E.Line24Copy2.Thickness = 1
    E.Line24Copy2.ZIndex    = 0
    E.Line24Copy2.Visible   = true

    E.Line24Copy3.From      = Vector2.new(1101, 530)
    E.Line24Copy3.To        = Vector2.new(1098, 464)
    E.Line24Copy3.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy3.Opacity   = 1
    E.Line24Copy3.Thickness = 1
    E.Line24Copy3.ZIndex    = 0
    E.Line24Copy3.Visible   = true

    E.Line24Copy4.From      = Vector2.new(1101, 466)
    E.Line24Copy4.To        = Vector2.new(1133, 498)
    E.Line24Copy4.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy4.Opacity   = 1
    E.Line24Copy4.Thickness = 1
    E.Line24Copy4.ZIndex    = 0
    E.Line24Copy4.Visible   = true

    E.Line24Copy5.From      = Vector2.new(1132, 497)
    E.Line24Copy5.To        = Vector2.new(1160, 521)
    E.Line24Copy5.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy5.Opacity   = 1
    E.Line24Copy5.Thickness = 1
    E.Line24Copy5.ZIndex    = 0
    E.Line24Copy5.Visible   = true

    E.Line24Copy6.From      = Vector2.new(1159, 519)
    E.Line24Copy6.To        = Vector2.new(1184, 548)
    E.Line24Copy6.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy6.Opacity   = 1
    E.Line24Copy6.Thickness = 1
    E.Line24Copy6.ZIndex    = 0
    E.Line24Copy6.Visible   = true

    E.Line24Copy7.From      = Vector2.new(1182, 545)
    E.Line24Copy7.To        = Vector2.new(1197, 567)
    E.Line24Copy7.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy7.Opacity   = 1
    E.Line24Copy7.Thickness = 1
    E.Line24Copy7.ZIndex    = 0
    E.Line24Copy7.Visible   = true

    E.Line24Copy8.From      = Vector2.new(1192, 527)
    E.Line24Copy8.To        = Vector2.new(1198, 567)
    E.Line24Copy8.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy8.Opacity   = 1
    E.Line24Copy8.Thickness = 1
    E.Line24Copy8.ZIndex    = 0
    E.Line24Copy8.Visible   = true

    E.Line24Copy9.From      = Vector2.new(1176, 491)
    E.Line24Copy9.To        = Vector2.new(1192, 529)
    E.Line24Copy9.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy9.Opacity   = 1
    E.Line24Copy9.Thickness = 1
    E.Line24Copy9.ZIndex    = 0
    E.Line24Copy9.Visible   = true

    E.Line23Copy7.From      = Vector2.new(1133, 432)
    E.Line23Copy7.To        = Vector2.new(1117, 427)
    E.Line23Copy7.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy7.Opacity   = 1
    E.Line23Copy7.Thickness = 1
    E.Line23Copy7.ZIndex    = 0
    E.Line23Copy7.Visible   = true

    E.Line23Copy8.From      = Vector2.new(1156, 455)
    E.Line23Copy8.To        = Vector2.new(1132, 432)
    E.Line23Copy8.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy8.Opacity   = 1
    E.Line23Copy8.Thickness = 1
    E.Line23Copy8.ZIndex    = 0
    E.Line23Copy8.Visible   = true

    E.Line24Copy10.From      = Vector2.new(1154, 453)
    E.Line24Copy10.To        = Vector2.new(1175, 491)
    E.Line24Copy10.Color     = Color3.fromRGB(240, 0, 164)
    E.Line24Copy10.Opacity   = 1
    E.Line24Copy10.Thickness = 1
    E.Line24Copy10.ZIndex    = 0
    E.Line24Copy10.Visible   = true

    E.Line23Copy9.From      = Vector2.new(1151, 359)
    E.Line23Copy9.To        = Vector2.new(1167, 357)
    E.Line23Copy9.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy9.Opacity   = 1
    E.Line23Copy9.Thickness = 1
    E.Line23Copy9.ZIndex    = 0
    E.Line23Copy9.Visible   = true

    E.Line23Copy10.From      = Vector2.new(1167, 357)
    E.Line23Copy10.To        = Vector2.new(1192, 362)
    E.Line23Copy10.Color     = Color3.fromRGB(240, 0, 164)
    E.Line23Copy10.Opacity   = 1
    E.Line23Copy10.Thickness = 1
    E.Line23Copy10.ZIndex    = 0
    E.Line23Copy10.Visible   = true
end

end)()
