--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor
local MathClamp  = math.clamp
local MathRound  = math.round

-- Cached Color3 constants for per-frame hover/toggle writes.
local _HC0: Color3 = Color3.fromRGB(103, 116, 137)
local _HC1: Color3 = Color3.fromRGB(61, 69, 82)
local _HC2: Color3 = Color3.fromRGB(255, 255, 255)
local _HC3: Color3 = Color3.fromRGB(185, 24, 164)
local _HC4: Color3 = Color3.fromRGB(92, 16, 81)
local _HC5: Color3 = Color3.fromRGB(79, 79, 79)
local _HC6: Color3 = Color3.fromRGB(179, 25, 107)

;(function(): ()

local E = {} -- holds all Drawing objects and widget state

-- Truncate a Drawing Text object so its rendered width fits maxW pixels.
-- Appends an ellipsis when trimming. Binary-search on TextBounds for O(log n)
-- property writes in the overflow path; zero-cost (one compare) when it fits.
local function _FitText(d: any, maxW: number)
    if d.TextBounds.X <= maxW then return end
    local full: string = d.Text
    local lo: number, hi: number = 0, #full
    while lo < hi do
        local mid: number = (lo + hi + 1) // 2
        d.Text = string.sub(full, 1, mid) .. "..."
        if d.TextBounds.X <= maxW then lo = mid else hi = mid - 1 end
    end
    d.Text = if lo == 0 then "..." else string.sub(full, 1, lo) .. "..."
end

-- Format a slider value for display: integers render bare, floats use %g to
-- trim trailing zeros (at most 6 significant digits).  Prevents rendering
-- floating-point noise like "44.24047862250109".
local function _FmtNum(v: number): string
    if v == MathFloor(v) then return tostring(MathFloor(v)) end
    return string.format("%g", v)
end

E.Square1 = Drawing.new("Square")
E.Square1Copy2 = Drawing.new("Square")
E.Square1Copy4 = Drawing.new("Square")
E.Square1Copy6 = Drawing.new("Square")
E.Line1 = Drawing.new("Line")
E.Text1 = Drawing.new("Text")
E.Dropdown1Background = Drawing.new("Square")
E.Dropdown1Text       = Drawing.new("Text")
E.Dropdown1Arrow      = Drawing.new("Text")
E.Dropdown1Selected   = "Combat Warriors"
E.Dropdown1Options    = { "Combat Warriors", "Violence District", "Gakuran" }
E.Dropdown1Open       = false
E.Dropdown1Fired      = true
E.Dropdown1FiredIdx   = 1
E.Dropdown1OptionBackground0 = Drawing.new("Square")
E.Dropdown1OptionText0       = Drawing.new("Text")
E.Dropdown1OptionBackground1 = Drawing.new("Square")
E.Dropdown1OptionText1       = Drawing.new("Text")
E.Dropdown1OptionBackground2 = Drawing.new("Square")
E.Dropdown1OptionText2       = Drawing.new("Text")
E.Dropdown1_OptBg     = { E.Dropdown1OptionBackground0, E.Dropdown1OptionBackground1, E.Dropdown1OptionBackground2 }
E.Dropdown1_OptTx     = { E.Dropdown1OptionText0, E.Dropdown1OptionText1, E.Dropdown1OptionText2 }
E.Circle1 = Drawing.new("Circle")
E.Circle2 = Drawing.new("Circle")
E.Line2 = Drawing.new("Line")
E.Line3 = Drawing.new("Line")
E.Line2Copy = Drawing.new("Line")
E.Line3Copy = Drawing.new("Line")
E.Line4 = Drawing.new("Line")
E.Line4Copy = Drawing.new("Line")
E.Line5 = Drawing.new("Line")
E.Line5Copy = Drawing.new("Line")
E.Line6 = Drawing.new("Line")
E.Line6Copy = Drawing.new("Line")
E.Button1Background = Drawing.new("Square")
E.Button1Text       = Drawing.new("Text")
E.Line1Copy2 = Drawing.new("Line")
E.Button1CopyBackground = Drawing.new("Square")
E.Button1CopyText       = Drawing.new("Text")
E.Button1CopyFired    = false
E.Text2 = Drawing.new("Text")
E.Text3 = Drawing.new("Text")
E.Line1Copy3 = Drawing.new("Line")
E.Button2Background = Drawing.new("Square")
E.Button2Text       = Drawing.new("Text")
E.Button2Fired    = false
E.Square3 = Drawing.new("Square")
E.Text4 = Drawing.new("Text")
E.Line1Copy4 = Drawing.new("Line")
E.Text4Copy = Drawing.new("Text")
E.Square1Copy = Drawing.new("Square")
E.Line1Copy6 = Drawing.new("Line")
E.Text1Copy = Drawing.new("Text")
E.Circle1Copy = Drawing.new("Circle")
E.Circle2Copy = Drawing.new("Circle")
E.Line2Copy2 = Drawing.new("Line")
E.Line3Copy2 = Drawing.new("Line")
E.Line2Copy3 = Drawing.new("Line")
E.Line3Copy3 = Drawing.new("Line")
E.Line4Copy2 = Drawing.new("Line")
E.Line4Copy3 = Drawing.new("Line")
E.Line5Copy2 = Drawing.new("Line")
E.Line5Copy3 = Drawing.new("Line")
E.Line6Copy2 = Drawing.new("Line")
E.Line6Copy3 = Drawing.new("Line")
E.Line1Copy7 = Drawing.new("Line")
E.Text3Copy = Drawing.new("Text")
E.Square1Copy3 = Drawing.new("Square")
E.Button1Copy3Background = Drawing.new("Square")
E.Button1Copy3Text       = Drawing.new("Text")
E.Button1Copy3Fired    = false
E.Text6 = Drawing.new("Text")
E.Line1Copy8 = Drawing.new("Line")
E.Switch2Track   = Drawing.new("Square")
E.Switch2Knob    = Drawing.new("Square")
E.Switch2Label   = Drawing.new("Text")
E.Switch2Enabled = false
E.Text6Copy = Drawing.new("Text")
E.Line1Copy9 = Drawing.new("Line")
E.Slider1Track    = Drawing.new("Square")
E.Slider1Fill     = Drawing.new("Square")
E.Slider1Knob     = Drawing.new("Square")
E.Slider1Label    = Drawing.new("Text")
E.Slider1Value    = 3
E.Slider1Dragging = false
E.Slider1Fired    = false
E.Slider1_LabelPrev = 3
E.Text7 = Drawing.new("Text")
E.Text7Copy = Drawing.new("Text")
E.Line1Copy11 = Drawing.new("Line")
E.Text1Copy2 = Drawing.new("Text")
E.Circle2Copy2 = Drawing.new("Circle")
E.Circle1Copy2 = Drawing.new("Circle")
E.Line2Copy4 = Drawing.new("Line")
E.Line3Copy4 = Drawing.new("Line")
E.Line2Copy5 = Drawing.new("Line")
E.Line3Copy5 = Drawing.new("Line")
E.Line4Copy4 = Drawing.new("Line")
E.Line4Copy5 = Drawing.new("Line")
E.Line5Copy4 = Drawing.new("Line")
E.Line5Copy5 = Drawing.new("Line")
E.Line6Copy4 = Drawing.new("Line")
E.Line6Copy5 = Drawing.new("Line")
E.Line1Copy12 = Drawing.new("Line")
E.Text3Copy2 = Drawing.new("Text")
E.Square1Copy5 = Drawing.new("Square")
E.Button1Copy5Background = Drawing.new("Square")
E.Button1Copy5Text       = Drawing.new("Text")
E.Button1Copy5Fired    = false
E.Switch2CopyTrack   = Drawing.new("Square")
E.Switch2CopyKnob    = Drawing.new("Square")
E.Switch2CopyLabel   = Drawing.new("Text")
E.Switch2CopyEnabled = false
E.Line1Copy13 = Drawing.new("Line")
E.Text6Copy2 = Drawing.new("Text")
E.Text6Copy3 = Drawing.new("Text")
E.Line1Copy14 = Drawing.new("Line")
E.Slider1CopyTrack    = Drawing.new("Square")
E.Slider1CopyFill     = Drawing.new("Square")
E.Slider1CopyKnob     = Drawing.new("Square")
E.Slider1CopyLabel    = Drawing.new("Text")
E.Slider1CopyValue    = 0.14
E.Slider1CopyDragging = false
E.Slider1CopyFired    = false
E.Slider1Copy_LabelPrev = 0.14
E.Text7Copy2 = Drawing.new("Text")
E.Text7Copy3 = Drawing.new("Text")
E.Text8 = Drawing.new("Text")
E.Switch2Copy2Track   = Drawing.new("Square")
E.Switch2Copy2Knob    = Drawing.new("Square")
E.Switch2Copy2Label   = Drawing.new("Text")
E.Switch2Copy2Enabled = false
E.Text8Copy = Drawing.new("Text")
E.Button1Copy2Background = Drawing.new("Square")
E.Button1Copy2Text       = Drawing.new("Text")
E.Line1Copy16 = Drawing.new("Line")
E.Text1Copy3 = Drawing.new("Text")
E.Circle1Copy3 = Drawing.new("Circle")
E.Circle2Copy3 = Drawing.new("Circle")
E.Line2Copy6 = Drawing.new("Line")
E.Line3Copy6 = Drawing.new("Line")
E.Line3Copy7 = Drawing.new("Line")
E.Line2Copy7 = Drawing.new("Line")
E.Line4Copy6 = Drawing.new("Line")
E.Line4Copy7 = Drawing.new("Line")
E.Line5Copy6 = Drawing.new("Line")
E.Line5Copy7 = Drawing.new("Line")
E.Line6Copy6 = Drawing.new("Line")
E.Line6Copy7 = Drawing.new("Line")
E.Line1Copy17 = Drawing.new("Line")
E.Text3Copy3 = Drawing.new("Text")
E.Square1Copy7 = Drawing.new("Square")
E.Button1Copy4Background = Drawing.new("Square")
E.Button1Copy4Text       = Drawing.new("Text")
E.Button1Copy4Fired    = false
E.Button1Copy6Background = Drawing.new("Square")
E.Button1Copy6Text       = Drawing.new("Text")
E.Text8Copy2 = Drawing.new("Text")
E.Text9 = Drawing.new("Text")
E.Line1Copy18 = Drawing.new("Line")
E.Dropdown2Background = Drawing.new("Square")
E.Dropdown2Text       = Drawing.new("Text")
E.Dropdown2Arrow      = Drawing.new("Text")
E.Dropdown2Selected   = "Option 1"
E.Dropdown2Options    = { "Option 1", "Option 2", "Option 3" }
E.Dropdown2Open       = false
E.Dropdown2Fired      = false
E.Dropdown2FiredIdx   = 0
E.Dropdown2SlotCount  = 0
E.Dropdown2OptionBackground0 = Drawing.new("Square")
E.Dropdown2OptionText0       = Drawing.new("Text")
E.Dropdown2OptionBackground1 = Drawing.new("Square")
E.Dropdown2OptionText1       = Drawing.new("Text")
E.Dropdown2OptionBackground2 = Drawing.new("Square")
E.Dropdown2OptionText2       = Drawing.new("Text")
E.Dropdown2OptionBackground3 = Drawing.new("Square")
E.Dropdown2OptionText3       = Drawing.new("Text")
E.Dropdown2OptionBackground4 = Drawing.new("Square")
E.Dropdown2OptionText4       = Drawing.new("Text")
E.Dropdown2OptionBackground5 = Drawing.new("Square")
E.Dropdown2OptionText5       = Drawing.new("Text")
E.Dropdown2OptionBackground6 = Drawing.new("Square")
E.Dropdown2OptionText6       = Drawing.new("Text")
E.Dropdown2OptionBackground7 = Drawing.new("Square")
E.Dropdown2OptionText7       = Drawing.new("Text")
E.Dropdown2OptionBackground8 = Drawing.new("Square")
E.Dropdown2OptionText8       = Drawing.new("Text")
E.Dropdown2OptionBackground9 = Drawing.new("Square")
E.Dropdown2OptionText9       = Drawing.new("Text")
E.Dropdown2OptionBackground10 = Drawing.new("Square")
E.Dropdown2OptionText10       = Drawing.new("Text")
E.Dropdown2OptionBackground11 = Drawing.new("Square")
E.Dropdown2OptionText11       = Drawing.new("Text")
E.Dropdown2OptionBackground12 = Drawing.new("Square")
E.Dropdown2OptionText12       = Drawing.new("Text")
E.Dropdown2OptionBackground13 = Drawing.new("Square")
E.Dropdown2OptionText13       = Drawing.new("Text")
E.Dropdown2OptionBackground14 = Drawing.new("Square")
E.Dropdown2OptionText14       = Drawing.new("Text")
E.Dropdown2OptionBackground15 = Drawing.new("Square")
E.Dropdown2OptionText15       = Drawing.new("Text")
E.Dropdown2OptionBackground16 = Drawing.new("Square")
E.Dropdown2OptionText16       = Drawing.new("Text")
E.Dropdown2OptionBackground17 = Drawing.new("Square")
E.Dropdown2OptionText17       = Drawing.new("Text")
E.Dropdown2OptionBackground18 = Drawing.new("Square")
E.Dropdown2OptionText18       = Drawing.new("Text")
E.Dropdown2OptionBackground19 = Drawing.new("Square")
E.Dropdown2OptionText19       = Drawing.new("Text")
E.Dropdown2_OptBg     = { E.Dropdown2OptionBackground0, E.Dropdown2OptionBackground1, E.Dropdown2OptionBackground2, E.Dropdown2OptionBackground3, E.Dropdown2OptionBackground4, E.Dropdown2OptionBackground5, E.Dropdown2OptionBackground6, E.Dropdown2OptionBackground7, E.Dropdown2OptionBackground8, E.Dropdown2OptionBackground9, E.Dropdown2OptionBackground10, E.Dropdown2OptionBackground11, E.Dropdown2OptionBackground12, E.Dropdown2OptionBackground13, E.Dropdown2OptionBackground14, E.Dropdown2OptionBackground15, E.Dropdown2OptionBackground16, E.Dropdown2OptionBackground17, E.Dropdown2OptionBackground18, E.Dropdown2OptionBackground19 }
E.Dropdown2_OptTx     = { E.Dropdown2OptionText0, E.Dropdown2OptionText1, E.Dropdown2OptionText2, E.Dropdown2OptionText3, E.Dropdown2OptionText4, E.Dropdown2OptionText5, E.Dropdown2OptionText6, E.Dropdown2OptionText7, E.Dropdown2OptionText8, E.Dropdown2OptionText9, E.Dropdown2OptionText10, E.Dropdown2OptionText11, E.Dropdown2OptionText12, E.Dropdown2OptionText13, E.Dropdown2OptionText14, E.Dropdown2OptionText15, E.Dropdown2OptionText16, E.Dropdown2OptionText17, E.Dropdown2OptionText18, E.Dropdown2OptionText19 }
E.Dropdown2_OptPrev   = table.create(20, "")
E.Text9Copy = Drawing.new("Text")
E.Line1Copy19 = Drawing.new("Line")
E.Switch3Track   = Drawing.new("Square")
E.Switch3Knob    = Drawing.new("Square")
E.Switch3Label   = Drawing.new("Text")
E.Switch3Enabled = true
E.Dropdown2CopyBackground = Drawing.new("Square")
E.Dropdown2CopyText       = Drawing.new("Text")
E.Dropdown2CopyArrow      = Drawing.new("Text")
E.Dropdown2CopySelected   = "Option 1"
E.Dropdown2CopyOptions    = { "Option 1", "Option 2", "Option 3" }
E.Dropdown2CopyOpen       = false
E.Dropdown2CopyFired      = false
E.Dropdown2CopyFiredIdx   = 0
E.Dropdown2CopySlotCount  = 0
E.Dropdown2CopyOptionBackground0 = Drawing.new("Square")
E.Dropdown2CopyOptionText0       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground1 = Drawing.new("Square")
E.Dropdown2CopyOptionText1       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground2 = Drawing.new("Square")
E.Dropdown2CopyOptionText2       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground3 = Drawing.new("Square")
E.Dropdown2CopyOptionText3       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground4 = Drawing.new("Square")
E.Dropdown2CopyOptionText4       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground5 = Drawing.new("Square")
E.Dropdown2CopyOptionText5       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground6 = Drawing.new("Square")
E.Dropdown2CopyOptionText6       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground7 = Drawing.new("Square")
E.Dropdown2CopyOptionText7       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground8 = Drawing.new("Square")
E.Dropdown2CopyOptionText8       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground9 = Drawing.new("Square")
E.Dropdown2CopyOptionText9       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground10 = Drawing.new("Square")
E.Dropdown2CopyOptionText10       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground11 = Drawing.new("Square")
E.Dropdown2CopyOptionText11       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground12 = Drawing.new("Square")
E.Dropdown2CopyOptionText12       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground13 = Drawing.new("Square")
E.Dropdown2CopyOptionText13       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground14 = Drawing.new("Square")
E.Dropdown2CopyOptionText14       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground15 = Drawing.new("Square")
E.Dropdown2CopyOptionText15       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground16 = Drawing.new("Square")
E.Dropdown2CopyOptionText16       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground17 = Drawing.new("Square")
E.Dropdown2CopyOptionText17       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground18 = Drawing.new("Square")
E.Dropdown2CopyOptionText18       = Drawing.new("Text")
E.Dropdown2CopyOptionBackground19 = Drawing.new("Square")
E.Dropdown2CopyOptionText19       = Drawing.new("Text")
E.Dropdown2Copy_OptBg     = { E.Dropdown2CopyOptionBackground0, E.Dropdown2CopyOptionBackground1, E.Dropdown2CopyOptionBackground2, E.Dropdown2CopyOptionBackground3, E.Dropdown2CopyOptionBackground4, E.Dropdown2CopyOptionBackground5, E.Dropdown2CopyOptionBackground6, E.Dropdown2CopyOptionBackground7, E.Dropdown2CopyOptionBackground8, E.Dropdown2CopyOptionBackground9, E.Dropdown2CopyOptionBackground10, E.Dropdown2CopyOptionBackground11, E.Dropdown2CopyOptionBackground12, E.Dropdown2CopyOptionBackground13, E.Dropdown2CopyOptionBackground14, E.Dropdown2CopyOptionBackground15, E.Dropdown2CopyOptionBackground16, E.Dropdown2CopyOptionBackground17, E.Dropdown2CopyOptionBackground18, E.Dropdown2CopyOptionBackground19 }
E.Dropdown2Copy_OptTx     = { E.Dropdown2CopyOptionText0, E.Dropdown2CopyOptionText1, E.Dropdown2CopyOptionText2, E.Dropdown2CopyOptionText3, E.Dropdown2CopyOptionText4, E.Dropdown2CopyOptionText5, E.Dropdown2CopyOptionText6, E.Dropdown2CopyOptionText7, E.Dropdown2CopyOptionText8, E.Dropdown2CopyOptionText9, E.Dropdown2CopyOptionText10, E.Dropdown2CopyOptionText11, E.Dropdown2CopyOptionText12, E.Dropdown2CopyOptionText13, E.Dropdown2CopyOptionText14, E.Dropdown2CopyOptionText15, E.Dropdown2CopyOptionText16, E.Dropdown2CopyOptionText17, E.Dropdown2CopyOptionText18, E.Dropdown2CopyOptionText19 }
E.Dropdown2Copy_OptPrev   = table.create(20, "")
E.Switch3CopyTrack   = Drawing.new("Square")
E.Switch3CopyKnob    = Drawing.new("Square")
E.Switch3CopyLabel   = Drawing.new("Text")
E.Switch3CopyEnabled = false
E.Text4Copy2 = Drawing.new("Text")
E.Text4Copy3 = Drawing.new("Text")
E.Line1Copy = Drawing.new("Line")
E.Line1Copy5 = Drawing.new("Line")
E.Line1Copy10 = Drawing.new("Line")
E.Line1Copy15 = Drawing.new("Line")

E.Square1DragActive     = false
E.Square1DragStartMouse = Vector2.new(0, 0)
E.Square1DragStartPos   = Vector2.new(0, 0)
E.Square1Copy2DragActive     = false
E.Square1Copy2DragStartMouse = Vector2.new(0, 0)
E.Square1Copy2DragStartPos   = Vector2.new(0, 0)
E.Square1Copy4DragActive     = false
E.Square1Copy4DragStartMouse = Vector2.new(0, 0)
E.Square1Copy4DragStartPos   = Vector2.new(0, 0)
E.Square1Copy6DragActive     = false
E.Square1Copy6DragStartMouse = Vector2.new(0, 0)
E.Square1Copy6DragStartPos   = Vector2.new(0, 0)

local ActiveTab: number = 1

local function SetTab(n: number): ()
    ActiveTab = n
    -- Tab 1
    E.Square1.Visible = n == 1 and true
    E.Line1.Visible = n == 1 and true
    E.Text1.Visible = n == 1 and true
    E.Dropdown1Background.Visible = n == 1 and true
    E.Dropdown1Text.Visible       = n == 1 and true
    E.Dropdown1Arrow.Visible      = n == 1 and true
    E.Dropdown1OptionBackground0.Visible = n == 1 and E.Dropdown1Open
    E.Dropdown1OptionText0.Visible       = n == 1 and E.Dropdown1Open
    E.Dropdown1OptionBackground1.Visible = n == 1 and E.Dropdown1Open
    E.Dropdown1OptionText1.Visible       = n == 1 and E.Dropdown1Open
    E.Dropdown1OptionBackground2.Visible = n == 1 and E.Dropdown1Open
    E.Dropdown1OptionText2.Visible       = n == 1 and E.Dropdown1Open
    E.Circle1.Visible = n == 1 and true
    E.Circle2.Visible = n == 1 and true
    E.Line2.Visible = n == 1 and true
    E.Line3.Visible = n == 1 and true
    E.Line2Copy.Visible = n == 1 and true
    E.Line3Copy.Visible = n == 1 and true
    E.Line4.Visible = n == 1 and true
    E.Line4Copy.Visible = n == 1 and true
    E.Line5.Visible = n == 1 and true
    E.Line5Copy.Visible = n == 1 and true
    E.Line6.Visible = n == 1 and true
    E.Line6Copy.Visible = n == 1 and true
    E.Button1Background.Visible = n == 1 and true
    E.Button1Text.Visible       = n == 1 and true
    E.Line1Copy2.Visible = n == 1 and true
    E.Button1CopyBackground.Visible = n == 1 and true
    E.Button1CopyText.Visible       = n == 1 and true
    E.Text2.Visible = n == 1 and true
    E.Text3.Visible = n == 1 and true
    E.Line1Copy3.Visible = n == 1 and true
    E.Button2Background.Visible = n == 1 and true
    E.Button2Text.Visible       = n == 1 and true
    E.Square3.Visible = n == 1 and true
    E.Text4.Visible = n == 1 and true
    E.Line1Copy4.Visible = n == 1 and true
    E.Text4Copy.Visible = n == 1 and true
    E.Square1Copy.Visible = n == 1 and true
    E.Text4Copy2.Visible = n == 1 and true
    E.Text4Copy3.Visible = n == 1 and true
    E.Line1Copy.Visible = n == 1 and true
    -- Tab 2
    E.Square1Copy2.Visible = n == 2 and true
    E.Line1Copy6.Visible = n == 2 and true
    E.Text1Copy.Visible = n == 2 and true
    E.Circle1Copy.Visible = n == 2 and true
    E.Circle2Copy.Visible = n == 2 and true
    E.Line2Copy2.Visible = n == 2 and true
    E.Line3Copy2.Visible = n == 2 and true
    E.Line2Copy3.Visible = n == 2 and true
    E.Line3Copy3.Visible = n == 2 and true
    E.Line4Copy2.Visible = n == 2 and true
    E.Line4Copy3.Visible = n == 2 and true
    E.Line5Copy2.Visible = n == 2 and true
    E.Line5Copy3.Visible = n == 2 and true
    E.Line6Copy2.Visible = n == 2 and true
    E.Line6Copy3.Visible = n == 2 and true
    E.Line1Copy7.Visible = n == 2 and true
    E.Text3Copy.Visible = n == 2 and true
    E.Square1Copy3.Visible = n == 2 and true
    E.Button1Copy3Background.Visible = n == 2 and true
    E.Button1Copy3Text.Visible       = n == 2 and true
    E.Text6.Visible = n == 2 and true
    E.Line1Copy8.Visible = n == 2 and true
    E.Switch2Track.Visible = n == 2 and true
    E.Switch2Knob.Visible  = n == 2 and true
    E.Switch2Label.Visible = n == 2 and true
    E.Text6Copy.Visible = n == 2 and true
    E.Line1Copy9.Visible = n == 2 and true
    E.Slider1Track.Visible = n == 2 and true
    E.Slider1Fill.Visible  = n == 2 and true
    E.Slider1Knob.Visible  = n == 2 and true
    E.Slider1Label.Visible = n == 2 and true
    E.Text7.Visible = n == 2 and true
    E.Text7Copy.Visible = n == 2 and true
    E.Text8Copy.Visible = n == 2 and true
    E.Line1Copy5.Visible = n == 2 and true
    -- Tab 3
    E.Square1Copy4.Visible = n == 3 and true
    E.Line1Copy11.Visible = n == 3 and true
    E.Text1Copy2.Visible = n == 3 and true
    E.Circle2Copy2.Visible = n == 3 and true
    E.Circle1Copy2.Visible = n == 3 and true
    E.Line2Copy4.Visible = n == 3 and true
    E.Line3Copy4.Visible = n == 3 and true
    E.Line2Copy5.Visible = n == 3 and true
    E.Line3Copy5.Visible = n == 3 and true
    E.Line4Copy4.Visible = n == 3 and true
    E.Line4Copy5.Visible = n == 3 and true
    E.Line5Copy4.Visible = n == 3 and true
    E.Line5Copy5.Visible = n == 3 and true
    E.Line6Copy4.Visible = n == 3 and true
    E.Line6Copy5.Visible = n == 3 and true
    E.Line1Copy12.Visible = n == 3 and true
    E.Text3Copy2.Visible = n == 3 and true
    E.Square1Copy5.Visible = n == 3 and true
    E.Button1Copy5Background.Visible = n == 3 and true
    E.Button1Copy5Text.Visible       = n == 3 and true
    E.Switch2CopyTrack.Visible = n == 3 and true
    E.Switch2CopyKnob.Visible  = n == 3 and true
    E.Switch2CopyLabel.Visible = n == 3 and true
    E.Line1Copy13.Visible = n == 3 and true
    E.Text6Copy2.Visible = n == 3 and true
    E.Text6Copy3.Visible = n == 3 and true
    E.Line1Copy14.Visible = n == 3 and true
    E.Slider1CopyTrack.Visible = n == 3 and true
    E.Slider1CopyFill.Visible  = n == 3 and true
    E.Slider1CopyKnob.Visible  = n == 3 and true
    E.Slider1CopyLabel.Visible = n == 3 and true
    E.Text7Copy2.Visible = n == 3 and true
    E.Text7Copy3.Visible = n == 3 and true
    E.Text8.Visible = n == 3 and true
    E.Switch2Copy2Track.Visible = n == 3 and true
    E.Switch2Copy2Knob.Visible  = n == 3 and true
    E.Switch2Copy2Label.Visible = n == 3 and true
    E.Button1Copy2Background.Visible = n == 3 and true
    E.Button1Copy2Text.Visible       = n == 3 and true
    E.Line1Copy10.Visible = n == 3 and true
    -- Tab 4
    E.Square1Copy6.Visible = n == 4 and true
    E.Line1Copy16.Visible = n == 4 and true
    E.Text1Copy3.Visible = n == 4 and true
    E.Circle1Copy3.Visible = n == 4 and true
    E.Circle2Copy3.Visible = n == 4 and true
    E.Line2Copy6.Visible = n == 4 and true
    E.Line3Copy6.Visible = n == 4 and true
    E.Line3Copy7.Visible = n == 4 and true
    E.Line2Copy7.Visible = n == 4 and true
    E.Line4Copy6.Visible = n == 4 and true
    E.Line4Copy7.Visible = n == 4 and true
    E.Line5Copy6.Visible = n == 4 and true
    E.Line5Copy7.Visible = n == 4 and true
    E.Line6Copy6.Visible = n == 4 and true
    E.Line6Copy7.Visible = n == 4 and true
    E.Line1Copy17.Visible = n == 4 and true
    E.Text3Copy3.Visible = n == 4 and true
    E.Square1Copy7.Visible = n == 4 and true
    E.Button1Copy4Background.Visible = n == 4 and true
    E.Button1Copy4Text.Visible       = n == 4 and true
    E.Button1Copy6Background.Visible = n == 4 and true
    E.Button1Copy6Text.Visible       = n == 4 and true
    E.Text8Copy2.Visible = n == 4 and true
    E.Text9.Visible = n == 4 and true
    E.Line1Copy18.Visible = n == 4 and true
    E.Dropdown2Background.Visible = n == 4 and true
    E.Dropdown2Text.Visible       = n == 4 and true
    E.Dropdown2Arrow.Visible      = n == 4 and true
    E.Dropdown2OptionBackground0.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText0.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground1.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText1.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground2.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText2.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground3.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText3.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground4.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText4.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground5.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText5.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground6.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText6.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground7.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText7.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground8.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText8.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground9.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText9.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground10.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText10.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground11.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText11.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground12.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText12.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground13.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText13.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground14.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText14.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground15.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText15.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground16.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText16.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground17.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText17.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground18.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText18.Visible       = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionBackground19.Visible = n == 4 and E.Dropdown2Open
    E.Dropdown2OptionText19.Visible       = n == 4 and E.Dropdown2Open
    E.Text9Copy.Visible = n == 4 and true
    E.Line1Copy19.Visible = n == 4 and true
    E.Switch3Track.Visible = n == 4 and true
    E.Switch3Knob.Visible  = n == 4 and true
    E.Switch3Label.Visible = n == 4 and true
    E.Dropdown2CopyBackground.Visible = n == 4 and true
    E.Dropdown2CopyText.Visible       = n == 4 and true
    E.Dropdown2CopyArrow.Visible      = n == 4 and true
    E.Dropdown2CopyOptionBackground0.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText0.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground1.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText1.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground2.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText2.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground3.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText3.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground4.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText4.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground5.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText5.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground6.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText6.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground7.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText7.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground8.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText8.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground9.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText9.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground10.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText10.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground11.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText11.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground12.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText12.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground13.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText13.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground14.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText14.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground15.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText15.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground16.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText16.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground17.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText17.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground18.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText18.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionBackground19.Visible = n == 4 and E.Dropdown2CopyOpen
    E.Dropdown2CopyOptionText19.Visible       = n == 4 and E.Dropdown2CopyOpen
    E.Switch3CopyTrack.Visible = n == 4 and true
    E.Switch3CopyKnob.Visible  = n == 4 and true
    E.Switch3CopyLabel.Visible = n == 4 and true
    E.Line1Copy15.Visible = n == 4 and true
end

do

    E.Square1.Position  = Vector2.new(739, 425)
    E.Square1.Size      = Vector2.new(462, 285)
    E.Square1.Color     = Color3.fromRGB(43, 43, 43)
    E.Square1.Opacity   = 0.66
    E.Square1.Filled    = true
    E.Square1.Thickness = 1
    E.Square1.Rounding  = 15
    E.Square1.ZIndex    = 0
    E.Square1.Visible   = true

    E.Square1Copy2.Position  = Vector2.new(848, 389)
    E.Square1Copy2.Size      = Vector2.new(272, 285)
    E.Square1Copy2.Color     = Color3.fromRGB(43, 43, 43)
    E.Square1Copy2.Opacity   = 0.66
    E.Square1Copy2.Filled    = true
    E.Square1Copy2.Thickness = 1
    E.Square1Copy2.Rounding  = 15
    E.Square1Copy2.ZIndex    = 0
    E.Square1Copy2.Visible   = true

    E.Square1Copy4.Position  = Vector2.new(908, 404)
    E.Square1Copy4.Size      = Vector2.new(272, 285)
    E.Square1Copy4.Color     = Color3.fromRGB(43, 43, 43)
    E.Square1Copy4.Opacity   = 0.66
    E.Square1Copy4.Filled    = true
    E.Square1Copy4.Thickness = 1
    E.Square1Copy4.Rounding  = 15
    E.Square1Copy4.ZIndex    = 0
    E.Square1Copy4.Visible   = true

    E.Square1Copy6.Position  = Vector2.new(887, 398)
    E.Square1Copy6.Size      = Vector2.new(272, 285)
    E.Square1Copy6.Color     = Color3.fromRGB(43, 43, 43)
    E.Square1Copy6.Opacity   = 0.66
    E.Square1Copy6.Filled    = true
    E.Square1Copy6.Thickness = 1
    E.Square1Copy6.Rounding  = 15
    E.Square1Copy6.ZIndex    = 0
    E.Square1Copy6.Visible   = true

    E.Line1.From      = Vector2.new(741, 470)
    E.Line1.To        = Vector2.new(1201, 470)
    E.Line1.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1.Opacity   = 0.44
    E.Line1.Thickness = 1
    E.Line1.ZIndex    = 1
    E.Line1.Visible   = true

    E.Text1.Position     = Vector2.new(816, 440)
    E.Text1.Text         = "BROG"
    E.Text1.Size         = 16
    E.Text1.Font         = 0
    E.Text1.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1.Opacity      = 1
    E.Text1.Center       = false
    E.Text1.Outline      = false
    E.Text1.ZIndex       = 1
    E.Text1.Visible      = true

    E.Dropdown1Background.Position  = Vector2.new(816, 519)
    E.Dropdown1Background.Size      = Vector2.new(150, 30)
    E.Dropdown1Background.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown1Background.Filled    = true
    E.Dropdown1Background.Thickness = 1
    E.Dropdown1Background.Rounding  = 8
    E.Dropdown1Background.ZIndex    = 1
    E.Dropdown1Background.Visible   = true

    E.Dropdown1Text.Position  = Vector2.new(824, 527)
    E.Dropdown1Text.Text      = E.Dropdown1Selected
    E.Dropdown1Text.Size      = 15
    E.Dropdown1Text.Font      = 2
    E.Dropdown1Text.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown1Text.Outline   = false
    E.Dropdown1Text.ZIndex    = 2
    E.Dropdown1Text.Visible   = true
    _FitText(E.Dropdown1Text, 122)

    E.Dropdown1Arrow.Position = Vector2.new(950, 527)
    E.Dropdown1Arrow.Text     = "▼"
    E.Dropdown1Arrow.Size     = 11
    E.Dropdown1Arrow.Font     = 2
    E.Dropdown1Arrow.Color    = Color3.fromRGB(185, 24, 164)
    E.Dropdown1Arrow.ZIndex   = 2
    E.Dropdown1Arrow.Visible  = true

    E.Dropdown1OptionBackground0.Position  = Vector2.new(816, 549)
    E.Dropdown1OptionBackground0.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground0.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown1OptionBackground0.Filled    = true
    E.Dropdown1OptionBackground0.Rounding  = 8
    E.Dropdown1OptionBackground0.ZIndex    = 3
    E.Dropdown1OptionBackground0.Visible   = false

    E.Dropdown1OptionText0.Position  = Vector2.new(824, 557)
    E.Dropdown1OptionText0.Text      = "Combat Warriors"
    E.Dropdown1OptionText0.Size      = 15
    E.Dropdown1OptionText0.Font      = 2
    E.Dropdown1OptionText0.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown1OptionText0.ZIndex    = 4
    E.Dropdown1OptionText0.Visible   = false
    _FitText(E.Dropdown1OptionText0, 134)

    E.Dropdown1OptionBackground1.Position  = Vector2.new(816, 579)
    E.Dropdown1OptionBackground1.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground1.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown1OptionBackground1.Filled    = true
    E.Dropdown1OptionBackground1.Rounding  = 8
    E.Dropdown1OptionBackground1.ZIndex    = 3
    E.Dropdown1OptionBackground1.Visible   = false

    E.Dropdown1OptionText1.Position  = Vector2.new(824, 587)
    E.Dropdown1OptionText1.Text      = "Violence District"
    E.Dropdown1OptionText1.Size      = 15
    E.Dropdown1OptionText1.Font      = 2
    E.Dropdown1OptionText1.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown1OptionText1.ZIndex    = 4
    E.Dropdown1OptionText1.Visible   = false
    _FitText(E.Dropdown1OptionText1, 134)

    E.Dropdown1OptionBackground2.Position  = Vector2.new(816, 609)
    E.Dropdown1OptionBackground2.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground2.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown1OptionBackground2.Filled    = true
    E.Dropdown1OptionBackground2.Rounding  = 8
    E.Dropdown1OptionBackground2.ZIndex    = 3
    E.Dropdown1OptionBackground2.Visible   = false

    E.Dropdown1OptionText2.Position  = Vector2.new(824, 617)
    E.Dropdown1OptionText2.Text      = "Gakuran"
    E.Dropdown1OptionText2.Size      = 15
    E.Dropdown1OptionText2.Font      = 2
    E.Dropdown1OptionText2.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown1OptionText2.ZIndex    = 4
    E.Dropdown1OptionText2.Visible   = false
    _FitText(E.Dropdown1OptionText2, 134)

    E.Circle1.Position  = Vector2.new(762, 442)
    E.Circle1.Radius    = 3.8125
    E.Circle1.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1.Opacity   = 1
    E.Circle1.Filled    = false
    E.Circle1.Thickness = 1
    E.Circle1.NumSides  = 64
    E.Circle1.ZIndex    = 1
    E.Circle1.Visible   = true

    E.Circle2.Position  = Vector2.new(777, 442)
    E.Circle2.Radius    = 3.8125
    E.Circle2.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle2.Opacity   = 1
    E.Circle2.Filled    = false
    E.Circle2.Thickness = 1
    E.Circle2.NumSides  = 64
    E.Circle2.ZIndex    = 1
    E.Circle2.Visible   = true

    E.Line2.From      = Vector2.new(758, 429)
    E.Line2.To        = Vector2.new(755, 437)
    E.Line2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2.Opacity   = 1
    E.Line2.Thickness = 1
    E.Line2.ZIndex    = 1
    E.Line2.Visible   = true

    E.Line3.From      = Vector2.new(758, 429)
    E.Line3.To        = Vector2.new(762, 435)
    E.Line3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3.Opacity   = 1
    E.Line3.Thickness = 1
    E.Line3.ZIndex    = 1
    E.Line3.Visible   = true

    E.Line2Copy.From      = Vector2.new(781, 429)
    E.Line2Copy.To        = Vector2.new(784, 437)
    E.Line2Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy.Opacity   = 1
    E.Line2Copy.Thickness = 1
    E.Line2Copy.ZIndex    = 1
    E.Line2Copy.Visible   = true

    E.Line3Copy.From      = Vector2.new(781, 429)
    E.Line3Copy.To        = Vector2.new(777, 435)
    E.Line3Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy.Opacity   = 1
    E.Line3Copy.Thickness = 1
    E.Line3Copy.ZIndex    = 1
    E.Line3Copy.Visible   = true

    E.Line4.From      = Vector2.new(770, 450)
    E.Line4.To        = Vector2.new(767, 456)
    E.Line4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4.Opacity   = 1
    E.Line4.Thickness = 1
    E.Line4.ZIndex    = 1
    E.Line4.Visible   = true

    E.Line4Copy.From      = Vector2.new(770, 451)
    E.Line4Copy.To        = Vector2.new(773, 457)
    E.Line4Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy.Opacity   = 1
    E.Line4Copy.Thickness = 1
    E.Line4Copy.ZIndex    = 1
    E.Line4Copy.Visible   = true

    E.Line5.From      = Vector2.new(753, 451)
    E.Line5.To        = Vector2.new(763, 453)
    E.Line5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5.Opacity   = 1
    E.Line5.Thickness = 1
    E.Line5.ZIndex    = 1
    E.Line5.Visible   = true

    E.Line5Copy.From      = Vector2.new(752, 457)
    E.Line5Copy.To        = Vector2.new(763, 455)
    E.Line5Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy.Opacity   = 1
    E.Line5Copy.Thickness = 1
    E.Line5Copy.ZIndex    = 1
    E.Line5Copy.Visible   = true

    E.Line6.From      = Vector2.new(777, 453)
    E.Line6.To        = Vector2.new(788, 450)
    E.Line6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6.Opacity   = 1
    E.Line6.Thickness = 1
    E.Line6.ZIndex    = 1
    E.Line6.Visible   = true

    E.Line6Copy.From      = Vector2.new(779, 455)
    E.Line6Copy.To        = Vector2.new(790, 457)
    E.Line6Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy.Opacity   = 1
    E.Line6Copy.Thickness = 1
    E.Line6Copy.ZIndex    = 1
    E.Line6Copy.Visible   = true

    E.Button1Background.Position  = Vector2.new(742, 486)
    E.Button1Background.Size      = Vector2.new(58, 34)
    E.Button1Background.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1Background.Filled    = true
    E.Button1Background.Thickness = 1
    E.Button1Background.Rounding  = 4
    E.Button1Background.ZIndex    = 1
    E.Button1Background.Visible   = true

    E.Button1Text.Position     = Vector2.new(771, 497)
    E.Button1Text.Text         = "Games"
    E.Button1Text.Size         = 11
    E.Button1Text.Font         = 2
    E.Button1Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Text.Center       = true
    E.Button1Text.Outline      = false
    E.Button1Text.ZIndex       = 2
    E.Button1Text.Visible      = true
    _FitText(E.Button1Text, 49.54416708872964)
    E.Button1Background.Opacity = 0.83
    E.Button1Text.Opacity = 0.83

    E.Line1Copy2.From      = Vector2.new(739, 660)
    E.Line1Copy2.To        = Vector2.new(802, 660)
    E.Line1Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy2.Opacity   = 0.44
    E.Line1Copy2.Thickness = 1
    E.Line1Copy2.ZIndex    = 1
    E.Line1Copy2.Visible   = true

    E.Button1CopyBackground.Position  = Vector2.new(746, 670)
    E.Button1CopyBackground.Size      = Vector2.new(50, 29)
    E.Button1CopyBackground.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1CopyBackground.Filled    = true
    E.Button1CopyBackground.Thickness = 1
    E.Button1CopyBackground.Rounding  = 4
    E.Button1CopyBackground.ZIndex    = 1
    E.Button1CopyBackground.Visible   = true

    E.Button1CopyText.Position     = Vector2.new(771, 681)
    E.Button1CopyText.Text         = "Settings"
    E.Button1CopyText.Size         = 7
    E.Button1CopyText.Font         = 2
    E.Button1CopyText.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1CopyText.Center       = true
    E.Button1CopyText.Outline      = false
    E.Button1CopyText.ZIndex       = 2
    E.Button1CopyText.Visible      = true
    _FitText(E.Button1CopyText, 42.29416708872964)
    E.Button1CopyBackground.Opacity = 0.44
    E.Button1CopyText.Opacity = 0.44

    E.Text2.Position     = Vector2.new(816, 484)
    E.Text2.Text         = "Selection"
    E.Text2.Size         = 16
    E.Text2.Font         = 0
    E.Text2.Color        = Color3.fromRGB(255, 255, 255)
    E.Text2.Opacity      = 1
    E.Text2.Center       = false
    E.Text2.Outline      = false
    E.Text2.ZIndex       = 1
    E.Text2.Visible      = true

    E.Text3.Position     = Vector2.new(854, 439)
    E.Text3.Text         = ":  LOADER"
    E.Text3.Size         = 16
    E.Text3.Font         = 0
    E.Text3.Color        = Color3.fromRGB(185, 24, 164)
    E.Text3.Opacity      = 1
    E.Text3.Center       = false
    E.Text3.Outline      = false
    E.Text3.ZIndex       = 1
    E.Text3.Visible      = true

    E.Line1Copy3.From      = Vector2.new(810, 507)
    E.Line1Copy3.To        = Vector2.new(1063, 507)
    E.Line1Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy3.Opacity   = 0.44
    E.Line1Copy3.Thickness = 1
    E.Line1Copy3.ZIndex    = 1
    E.Line1Copy3.Visible   = true

    E.Button2Background.Position  = Vector2.new(1039, 649)
    E.Button2Background.Size      = Vector2.new(120, 34)
    E.Button2Background.Color     = Color3.fromRGB(185, 24, 164)
    E.Button2Background.Filled    = true
    E.Button2Background.Thickness = 1
    E.Button2Background.Rounding  = 4
    E.Button2Background.ZIndex    = 1
    E.Button2Background.Visible   = true

    E.Button2Text.Position     = Vector2.new(1099, 658)
    E.Button2Text.Text         = "Load"
    E.Button2Text.Size         = 16
    E.Button2Text.Font         = 2
    E.Button2Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button2Text.Center       = true
    E.Button2Text.Outline      = false
    E.Button2Text.ZIndex       = 2
    E.Button2Text.Visible      = true
    _FitText(E.Button2Text, 112)

    E.Square3.Position  = Vector2.new(1036, 526)
    E.Square3.Size      = Vector2.new(127, 101)
    E.Square3.Color     = Color3.fromRGB(255, 255, 255)
    E.Square3.Opacity   = 0.42
    E.Square3.Filled    = false
    E.Square3.Thickness = 1
    E.Square3.Rounding  = 5
    E.Square3.ZIndex    = 1
    E.Square3.Visible   = true

    E.Text4.Position     = Vector2.new(1101, 553)
    E.Text4.Text         = "made by brog"
    E.Text4.Size         = 14
    E.Text4.Font         = 0
    E.Text4.Color        = Color3.fromRGB(185, 24, 164)
    E.Text4.Opacity      = 1
    E.Text4.Center       = true
    E.Text4.Outline      = false
    E.Text4.ZIndex       = 1
    E.Text4.Visible      = true

    E.Line1Copy4.From      = Vector2.new(1048, 579)
    E.Line1Copy4.To        = Vector2.new(1152, 579)
    E.Line1Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy4.Opacity   = 0.44
    E.Line1Copy4.Thickness = 1
    E.Line1Copy4.ZIndex    = 1
    E.Line1Copy4.Visible   = true

    E.Text4Copy.Position     = Vector2.new(1100, 535)
    E.Text4Copy.Text         = "Script"
    E.Text4Copy.Size         = 14
    E.Text4Copy.Font         = 0
    E.Text4Copy.Color        = Color3.fromRGB(185, 24, 164)
    E.Text4Copy.Opacity      = 1
    E.Text4Copy.Center       = true
    E.Text4Copy.Outline      = false
    E.Text4Copy.ZIndex       = 1
    E.Text4Copy.Visible      = true

    E.Square1Copy.Position  = Vector2.new(739, 425)
    E.Square1Copy.Size      = Vector2.new(462, 285)
    E.Square1Copy.Color     = Color3.fromRGB(185, 24, 164)
    E.Square1Copy.Opacity   = 0.66
    E.Square1Copy.Filled    = false
    E.Square1Copy.Thickness = 2
    E.Square1Copy.Rounding  = 15
    E.Square1Copy.ZIndex    = 1
    E.Square1Copy.Visible   = true

    E.Line1Copy6.From      = Vector2.new(849, 433)
    E.Line1Copy6.To        = Vector2.new(1120, 433)
    E.Line1Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy6.Opacity   = 0.44
    E.Line1Copy6.Thickness = 1
    E.Line1Copy6.ZIndex    = 1
    E.Line1Copy6.Visible   = true

    E.Text1Copy.Position     = Vector2.new(925, 404)
    E.Text1Copy.Text         = "BROG"
    E.Text1Copy.Size         = 16
    E.Text1Copy.Font         = 0
    E.Text1Copy.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy.Opacity      = 1
    E.Text1Copy.Center       = false
    E.Text1Copy.Outline      = false
    E.Text1Copy.ZIndex       = 1
    E.Text1Copy.Visible      = true

    E.Circle1Copy.Position  = Vector2.new(871, 406)
    E.Circle1Copy.Radius    = 3.8125
    E.Circle1Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy.Opacity   = 1
    E.Circle1Copy.Filled    = false
    E.Circle1Copy.Thickness = 1
    E.Circle1Copy.NumSides  = 64
    E.Circle1Copy.ZIndex    = 1
    E.Circle1Copy.Visible   = true

    E.Circle2Copy.Position  = Vector2.new(887, 406)
    E.Circle2Copy.Radius    = 3.8125
    E.Circle2Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle2Copy.Opacity   = 1
    E.Circle2Copy.Filled    = false
    E.Circle2Copy.Thickness = 1
    E.Circle2Copy.NumSides  = 64
    E.Circle2Copy.ZIndex    = 1
    E.Circle2Copy.Visible   = true

    E.Line2Copy2.From      = Vector2.new(867, 393)
    E.Line2Copy2.To        = Vector2.new(864, 401)
    E.Line2Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy2.Opacity   = 1
    E.Line2Copy2.Thickness = 1
    E.Line2Copy2.ZIndex    = 1
    E.Line2Copy2.Visible   = true

    E.Line3Copy2.From      = Vector2.new(867, 393)
    E.Line3Copy2.To        = Vector2.new(871, 399)
    E.Line3Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy2.Opacity   = 1
    E.Line3Copy2.Thickness = 1
    E.Line3Copy2.ZIndex    = 1
    E.Line3Copy2.Visible   = true

    E.Line2Copy3.From      = Vector2.new(890, 393)
    E.Line2Copy3.To        = Vector2.new(894, 401)
    E.Line2Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy3.Opacity   = 1
    E.Line2Copy3.Thickness = 1
    E.Line2Copy3.ZIndex    = 1
    E.Line2Copy3.Visible   = true

    E.Line3Copy3.From      = Vector2.new(890, 392)
    E.Line3Copy3.To        = Vector2.new(886, 399)
    E.Line3Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy3.Opacity   = 1
    E.Line3Copy3.Thickness = 1
    E.Line3Copy3.ZIndex    = 1
    E.Line3Copy3.Visible   = true

    E.Line4Copy2.From      = Vector2.new(879, 414)
    E.Line4Copy2.To        = Vector2.new(876, 420)
    E.Line4Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy2.Opacity   = 1
    E.Line4Copy2.Thickness = 1
    E.Line4Copy2.ZIndex    = 1
    E.Line4Copy2.Visible   = true

    E.Line4Copy3.From      = Vector2.new(879, 415)
    E.Line4Copy3.To        = Vector2.new(882, 421)
    E.Line4Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy3.Opacity   = 1
    E.Line4Copy3.Thickness = 1
    E.Line4Copy3.ZIndex    = 1
    E.Line4Copy3.Visible   = true

    E.Line5Copy2.From      = Vector2.new(862, 415)
    E.Line5Copy2.To        = Vector2.new(872, 417)
    E.Line5Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy2.Opacity   = 1
    E.Line5Copy2.Thickness = 1
    E.Line5Copy2.ZIndex    = 1
    E.Line5Copy2.Visible   = true

    E.Line5Copy3.From      = Vector2.new(861, 421)
    E.Line5Copy3.To        = Vector2.new(872, 419)
    E.Line5Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy3.Opacity   = 1
    E.Line5Copy3.Thickness = 1
    E.Line5Copy3.ZIndex    = 1
    E.Line5Copy3.Visible   = true

    E.Line6Copy2.From      = Vector2.new(886, 417)
    E.Line6Copy2.To        = Vector2.new(897, 414)
    E.Line6Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy2.Opacity   = 1
    E.Line6Copy2.Thickness = 1
    E.Line6Copy2.ZIndex    = 1
    E.Line6Copy2.Visible   = true

    E.Line6Copy3.From      = Vector2.new(888, 419)
    E.Line6Copy3.To        = Vector2.new(899, 421)
    E.Line6Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy3.Opacity   = 1
    E.Line6Copy3.Thickness = 1
    E.Line6Copy3.ZIndex    = 1
    E.Line6Copy3.Visible   = true

    E.Line1Copy7.From      = Vector2.new(848, 624)
    E.Line1Copy7.To        = Vector2.new(911, 624)
    E.Line1Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy7.Opacity   = 0.44
    E.Line1Copy7.Thickness = 1
    E.Line1Copy7.ZIndex    = 1
    E.Line1Copy7.Visible   = true

    E.Text3Copy.Position     = Vector2.new(963, 403)
    E.Text3Copy.Text         = ":  Combat Warriors"
    E.Text3Copy.Size         = 16
    E.Text3Copy.Font         = 0
    E.Text3Copy.Color        = Color3.fromRGB(185, 24, 164)
    E.Text3Copy.Opacity      = 1
    E.Text3Copy.Center       = false
    E.Text3Copy.Outline      = false
    E.Text3Copy.ZIndex       = 1
    E.Text3Copy.Visible      = true

    E.Square1Copy3.Position  = Vector2.new(848, 389)
    E.Square1Copy3.Size      = Vector2.new(272, 285)
    E.Square1Copy3.Color     = Color3.fromRGB(185, 24, 164)
    E.Square1Copy3.Opacity   = 0.66
    E.Square1Copy3.Filled    = false
    E.Square1Copy3.Thickness = 2
    E.Square1Copy3.Rounding  = 15
    E.Square1Copy3.ZIndex    = 1
    E.Square1Copy3.Visible   = true

    E.Button1Copy3Background.Position  = Vector2.new(851, 449)
    E.Button1Copy3Background.Size      = Vector2.new(58, 34)
    E.Button1Copy3Background.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1Copy3Background.Filled    = true
    E.Button1Copy3Background.Thickness = 1
    E.Button1Copy3Background.Rounding  = 4
    E.Button1Copy3Background.ZIndex    = 1
    E.Button1Copy3Background.Visible   = true

    E.Button1Copy3Text.Position     = Vector2.new(880, 460)
    E.Button1Copy3Text.Text         = "Parry"
    E.Button1Copy3Text.Size         = 11
    E.Button1Copy3Text.Font         = 2
    E.Button1Copy3Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Copy3Text.Center       = true
    E.Button1Copy3Text.Outline      = false
    E.Button1Copy3Text.ZIndex       = 2
    E.Button1Copy3Text.Visible      = true
    _FitText(E.Button1Copy3Text, 49.54416708872964)
    E.Button1Copy3Background.Opacity = 0.83
    E.Button1Copy3Text.Opacity = 0.83

    E.Text6.Position     = Vector2.new(929, 450)
    E.Text6.Text         = "Toggle"
    E.Text6.Size         = 16
    E.Text6.Font         = 0
    E.Text6.Color        = Color3.fromRGB(255, 255, 255)
    E.Text6.Opacity      = 1
    E.Text6.Center       = false
    E.Text6.Outline      = false
    E.Text6.ZIndex       = 1
    E.Text6.Visible      = true

    E.Line1Copy8.From      = Vector2.new(921, 470)
    E.Line1Copy8.To        = Vector2.new(1041, 470)
    E.Line1Copy8.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy8.Opacity   = 0.44
    E.Line1Copy8.Thickness = 1
    E.Line1Copy8.ZIndex    = 1
    E.Line1Copy8.Visible   = true

    E.Switch2Track.Position  = Vector2.new(929, 489)
    E.Switch2Track.Size      = Vector2.new(44, 22)
    E.Switch2Track.Color     = Color3.fromRGB(79, 79, 79)
    E.Switch2Track.Filled    = true
    E.Switch2Track.Thickness = 1
    E.Switch2Track.Rounding  = 11
    E.Switch2Track.ZIndex    = 1
    E.Switch2Track.Visible   = true

    E.Switch2Knob.Position  = Vector2.new(931, 491)
    E.Switch2Knob.Size      = Vector2.new(18, 18)
    E.Switch2Knob.Color     = Color3.fromRGB(250, 250, 250)
    E.Switch2Knob.Filled    = true
    E.Switch2Knob.Rounding  = 9
    E.Switch2Knob.ZIndex    = 2
    E.Switch2Knob.Visible   = true

    E.Switch2Label.Position     = Vector2.new(981, 492)
    E.Switch2Label.Text         = "Switch"
    E.Switch2Label.Size         = 16
    E.Switch2Label.Font         = 0
    E.Switch2Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Switch2Label.Outline      = false
    E.Switch2Label.ZIndex       = 2
    E.Switch2Label.Visible      = true

    E.Text6Copy.Position     = Vector2.new(925, 544)
    E.Text6Copy.Text         = "Timing"
    E.Text6Copy.Size         = 16
    E.Text6Copy.Font         = 0
    E.Text6Copy.Color        = Color3.fromRGB(255, 255, 255)
    E.Text6Copy.Opacity      = 1
    E.Text6Copy.Center       = false
    E.Text6Copy.Outline      = false
    E.Text6Copy.ZIndex       = 1
    E.Text6Copy.Visible      = true

    E.Line1Copy9.From      = Vector2.new(921, 565)
    E.Line1Copy9.To        = Vector2.new(1041, 565)
    E.Line1Copy9.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy9.Opacity   = 0.44
    E.Line1Copy9.Thickness = 1
    E.Line1Copy9.ZIndex    = 1
    E.Line1Copy9.Visible   = true

    E.Slider1Track.Position  = Vector2.new(925, 582)
    E.Slider1Track.Size      = Vector2.new(167, 14)
    E.Slider1Track.Color     = Color3.fromRGB(185, 24, 164)
    E.Slider1Track.Opacity   = 0.30
    E.Slider1Track.Filled    = true
    E.Slider1Track.ZIndex    = 1
    E.Slider1Track.Visible   = true

    E.Slider1Fill.Position   = Vector2.new(925, 582)
    E.Slider1Fill.Size       = Vector2.new(49, 14)
    E.Slider1Fill.Color      = Color3.fromRGB(185, 24, 164)
    E.Slider1Fill.Filled     = true
    E.Slider1Fill.ZIndex     = 2
    E.Slider1Fill.Visible    = true

    E.Slider1Knob.Position   = Vector2.new(969, 580)
    E.Slider1Knob.Size       = Vector2.new(10, 18)
    E.Slider1Knob.Color      = Color3.fromRGB(255, 255, 255)
    E.Slider1Knob.Filled     = true
    E.Slider1Knob.Rounding   = 2
    E.Slider1Knob.ZIndex     = 3
    E.Slider1Knob.Visible    = true

    E.Slider1Label.Position  = Vector2.new(1008, 566)
    E.Slider1Label.Text      = _FmtNum(E.Slider1Value) .. ""
    E.Slider1Label.Size      = 11
    E.Slider1Label.Font      = 0
    E.Slider1Label.Color     = Color3.fromRGB(185, 24, 164)
    E.Slider1Label.Center    = true
    E.Slider1Label.ZIndex    = 3
    E.Slider1Label.Visible   = true
    _FitText(E.Slider1Label, 166.97656374219468)

    E.Text7.Position     = Vector2.new(915, 600)
    E.Text7.Text         = "Late"
    E.Text7.Size         = 8
    E.Text7.Font         = 0
    E.Text7.Color        = Color3.fromRGB(179, 25, 107)
    E.Text7.Opacity      = 1
    E.Text7.Center       = false
    E.Text7.Outline      = false
    E.Text7.ZIndex       = 1
    E.Text7.Visible      = true

    E.Text7Copy.Position     = Vector2.new(1080, 600)
    E.Text7Copy.Text         = "Early"
    E.Text7Copy.Size         = 8
    E.Text7Copy.Font         = 0
    E.Text7Copy.Color        = Color3.fromRGB(179, 25, 107)
    E.Text7Copy.Opacity      = 1
    E.Text7Copy.Center       = false
    E.Text7Copy.Outline      = false
    E.Text7Copy.ZIndex       = 1
    E.Text7Copy.Visible      = true

    E.Line1Copy11.From      = Vector2.new(909, 448)
    E.Line1Copy11.To        = Vector2.new(1181, 448)
    E.Line1Copy11.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy11.Opacity   = 0.44
    E.Line1Copy11.Thickness = 1
    E.Line1Copy11.ZIndex    = 1
    E.Line1Copy11.Visible   = true

    E.Text1Copy2.Position     = Vector2.new(985, 419)
    E.Text1Copy2.Text         = "BROG"
    E.Text1Copy2.Size         = 16
    E.Text1Copy2.Font         = 0
    E.Text1Copy2.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy2.Opacity      = 1
    E.Text1Copy2.Center       = false
    E.Text1Copy2.Outline      = false
    E.Text1Copy2.ZIndex       = 1
    E.Text1Copy2.Visible      = true

    E.Circle2Copy2.Position  = Vector2.new(947, 421)
    E.Circle2Copy2.Radius    = 3.8125
    E.Circle2Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle2Copy2.Opacity   = 1
    E.Circle2Copy2.Filled    = false
    E.Circle2Copy2.Thickness = 1
    E.Circle2Copy2.NumSides  = 64
    E.Circle2Copy2.ZIndex    = 1
    E.Circle2Copy2.Visible   = true

    E.Circle1Copy2.Position  = Vector2.new(931, 421)
    E.Circle1Copy2.Radius    = 3.8125
    E.Circle1Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy2.Opacity   = 1
    E.Circle1Copy2.Filled    = false
    E.Circle1Copy2.Thickness = 1
    E.Circle1Copy2.NumSides  = 64
    E.Circle1Copy2.ZIndex    = 1
    E.Circle1Copy2.Visible   = true

    E.Line2Copy4.From      = Vector2.new(927, 408)
    E.Line2Copy4.To        = Vector2.new(924, 416)
    E.Line2Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy4.Opacity   = 1
    E.Line2Copy4.Thickness = 1
    E.Line2Copy4.ZIndex    = 1
    E.Line2Copy4.Visible   = true

    E.Line3Copy4.From      = Vector2.new(927, 408)
    E.Line3Copy4.To        = Vector2.new(931, 414)
    E.Line3Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy4.Opacity   = 1
    E.Line3Copy4.Thickness = 1
    E.Line3Copy4.ZIndex    = 1
    E.Line3Copy4.Visible   = true

    E.Line2Copy5.From      = Vector2.new(950, 408)
    E.Line2Copy5.To        = Vector2.new(954, 416)
    E.Line2Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy5.Opacity   = 1
    E.Line2Copy5.Thickness = 1
    E.Line2Copy5.ZIndex    = 1
    E.Line2Copy5.Visible   = true

    E.Line3Copy5.From      = Vector2.new(950, 407)
    E.Line3Copy5.To        = Vector2.new(946, 414)
    E.Line3Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy5.Opacity   = 1
    E.Line3Copy5.Thickness = 1
    E.Line3Copy5.ZIndex    = 1
    E.Line3Copy5.Visible   = true

    E.Line4Copy4.From      = Vector2.new(939, 429)
    E.Line4Copy4.To        = Vector2.new(936, 435)
    E.Line4Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy4.Opacity   = 1
    E.Line4Copy4.Thickness = 1
    E.Line4Copy4.ZIndex    = 1
    E.Line4Copy4.Visible   = true

    E.Line4Copy5.From      = Vector2.new(939, 430)
    E.Line4Copy5.To        = Vector2.new(942, 436)
    E.Line4Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy5.Opacity   = 1
    E.Line4Copy5.Thickness = 1
    E.Line4Copy5.ZIndex    = 1
    E.Line4Copy5.Visible   = true

    E.Line5Copy4.From      = Vector2.new(922, 430)
    E.Line5Copy4.To        = Vector2.new(932, 432)
    E.Line5Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy4.Opacity   = 1
    E.Line5Copy4.Thickness = 1
    E.Line5Copy4.ZIndex    = 1
    E.Line5Copy4.Visible   = true

    E.Line5Copy5.From      = Vector2.new(921, 436)
    E.Line5Copy5.To        = Vector2.new(932, 434)
    E.Line5Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy5.Opacity   = 1
    E.Line5Copy5.Thickness = 1
    E.Line5Copy5.ZIndex    = 1
    E.Line5Copy5.Visible   = true

    E.Line6Copy4.From      = Vector2.new(946, 432)
    E.Line6Copy4.To        = Vector2.new(957, 429)
    E.Line6Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy4.Opacity   = 1
    E.Line6Copy4.Thickness = 1
    E.Line6Copy4.ZIndex    = 1
    E.Line6Copy4.Visible   = true

    E.Line6Copy5.From      = Vector2.new(948, 434)
    E.Line6Copy5.To        = Vector2.new(959, 436)
    E.Line6Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy5.Opacity   = 1
    E.Line6Copy5.Thickness = 1
    E.Line6Copy5.ZIndex    = 1
    E.Line6Copy5.Visible   = true

    E.Line1Copy12.From      = Vector2.new(908, 639)
    E.Line1Copy12.To        = Vector2.new(971, 639)
    E.Line1Copy12.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy12.Opacity   = 0.44
    E.Line1Copy12.Thickness = 1
    E.Line1Copy12.ZIndex    = 1
    E.Line1Copy12.Visible   = true

    E.Text3Copy2.Position     = Vector2.new(1023, 418)
    E.Text3Copy2.Text         = ":  Gakuran"
    E.Text3Copy2.Size         = 16
    E.Text3Copy2.Font         = 0
    E.Text3Copy2.Color        = Color3.fromRGB(185, 24, 164)
    E.Text3Copy2.Opacity      = 1
    E.Text3Copy2.Center       = false
    E.Text3Copy2.Outline      = false
    E.Text3Copy2.ZIndex       = 1
    E.Text3Copy2.Visible      = true

    E.Square1Copy5.Position  = Vector2.new(908, 404)
    E.Square1Copy5.Size      = Vector2.new(272, 285)
    E.Square1Copy5.Color     = Color3.fromRGB(185, 24, 164)
    E.Square1Copy5.Opacity   = 0.66
    E.Square1Copy5.Filled    = false
    E.Square1Copy5.Thickness = 2
    E.Square1Copy5.Rounding  = 15
    E.Square1Copy5.ZIndex    = 1
    E.Square1Copy5.Visible   = true

    E.Button1Copy5Background.Position  = Vector2.new(911, 464)
    E.Button1Copy5Background.Size      = Vector2.new(58, 34)
    E.Button1Copy5Background.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1Copy5Background.Filled    = true
    E.Button1Copy5Background.Thickness = 1
    E.Button1Copy5Background.Rounding  = 4
    E.Button1Copy5Background.ZIndex    = 1
    E.Button1Copy5Background.Visible   = true

    E.Button1Copy5Text.Position     = Vector2.new(940, 475)
    E.Button1Copy5Text.Text         = "Parry"
    E.Button1Copy5Text.Size         = 11
    E.Button1Copy5Text.Font         = 2
    E.Button1Copy5Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Copy5Text.Center       = true
    E.Button1Copy5Text.Outline      = false
    E.Button1Copy5Text.ZIndex       = 2
    E.Button1Copy5Text.Visible      = true
    _FitText(E.Button1Copy5Text, 49.54416708872964)
    E.Button1Copy5Background.Opacity = 0.83
    E.Button1Copy5Text.Opacity = 0.83

    E.Switch2CopyTrack.Position  = Vector2.new(986, 503)
    E.Switch2CopyTrack.Size      = Vector2.new(44, 22)
    E.Switch2CopyTrack.Color     = Color3.fromRGB(79, 79, 79)
    E.Switch2CopyTrack.Filled    = true
    E.Switch2CopyTrack.Thickness = 1
    E.Switch2CopyTrack.Rounding  = 11
    E.Switch2CopyTrack.ZIndex    = 1
    E.Switch2CopyTrack.Visible   = true

    E.Switch2CopyKnob.Position  = Vector2.new(988, 505)
    E.Switch2CopyKnob.Size      = Vector2.new(18, 18)
    E.Switch2CopyKnob.Color     = Color3.fromRGB(250, 250, 250)
    E.Switch2CopyKnob.Filled    = true
    E.Switch2CopyKnob.Rounding  = 9
    E.Switch2CopyKnob.ZIndex    = 2
    E.Switch2CopyKnob.Visible   = true

    E.Switch2CopyLabel.Position     = Vector2.new(1038, 506)
    E.Switch2CopyLabel.Text         = "Switch"
    E.Switch2CopyLabel.Size         = 16
    E.Switch2CopyLabel.Font         = 0
    E.Switch2CopyLabel.Color        = Color3.fromRGB(255, 255, 255)
    E.Switch2CopyLabel.Outline      = false
    E.Switch2CopyLabel.ZIndex       = 2
    E.Switch2CopyLabel.Visible      = true

    E.Line1Copy13.From      = Vector2.new(978, 485)
    E.Line1Copy13.To        = Vector2.new(1098, 485)
    E.Line1Copy13.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy13.Opacity   = 0.44
    E.Line1Copy13.Thickness = 1
    E.Line1Copy13.ZIndex    = 1
    E.Line1Copy13.Visible   = true

    E.Text6Copy2.Position     = Vector2.new(986, 464)
    E.Text6Copy2.Text         = "Toggle"
    E.Text6Copy2.Size         = 16
    E.Text6Copy2.Font         = 0
    E.Text6Copy2.Color        = Color3.fromRGB(255, 255, 255)
    E.Text6Copy2.Opacity      = 1
    E.Text6Copy2.Center       = false
    E.Text6Copy2.Outline      = false
    E.Text6Copy2.ZIndex       = 1
    E.Text6Copy2.Visible      = true

    E.Text6Copy3.Position     = Vector2.new(982, 559)
    E.Text6Copy3.Text         = "Wind Up %"
    E.Text6Copy3.Size         = 16
    E.Text6Copy3.Font         = 0
    E.Text6Copy3.Color        = Color3.fromRGB(255, 255, 255)
    E.Text6Copy3.Opacity      = 1
    E.Text6Copy3.Center       = false
    E.Text6Copy3.Outline      = false
    E.Text6Copy3.ZIndex       = 1
    E.Text6Copy3.Visible      = true

    E.Line1Copy14.From      = Vector2.new(978, 580)
    E.Line1Copy14.To        = Vector2.new(1098, 580)
    E.Line1Copy14.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy14.Opacity   = 0.44
    E.Line1Copy14.Thickness = 1
    E.Line1Copy14.ZIndex    = 1
    E.Line1Copy14.Visible   = true

    E.Slider1CopyTrack.Position  = Vector2.new(982, 597)
    E.Slider1CopyTrack.Size      = Vector2.new(167, 14)
    E.Slider1CopyTrack.Color     = Color3.fromRGB(185, 24, 164)
    E.Slider1CopyTrack.Opacity   = 0.30
    E.Slider1CopyTrack.Filled    = true
    E.Slider1CopyTrack.ZIndex    = 1
    E.Slider1CopyTrack.Visible   = true

    E.Slider1CopyFill.Position   = Vector2.new(982, 597)
    E.Slider1CopyFill.Size       = Vector2.new(5, 14)
    E.Slider1CopyFill.Color      = Color3.fromRGB(185, 24, 164)
    E.Slider1CopyFill.Filled     = true
    E.Slider1CopyFill.ZIndex     = 2
    E.Slider1CopyFill.Visible    = true

    E.Slider1CopyKnob.Position   = Vector2.new(983, 595)
    E.Slider1CopyKnob.Size       = Vector2.new(10, 18)
    E.Slider1CopyKnob.Color      = Color3.fromRGB(255, 255, 255)
    E.Slider1CopyKnob.Filled     = true
    E.Slider1CopyKnob.Rounding   = 2
    E.Slider1CopyKnob.ZIndex     = 3
    E.Slider1CopyKnob.Visible    = true

    E.Slider1CopyLabel.Position  = Vector2.new(1066, 581)
    E.Slider1CopyLabel.Text      = _FmtNum(E.Slider1CopyValue) .. ""
    E.Slider1CopyLabel.Size      = 11
    E.Slider1CopyLabel.Font      = 0
    E.Slider1CopyLabel.Color     = Color3.fromRGB(185, 24, 164)
    E.Slider1CopyLabel.Center    = true
    E.Slider1CopyLabel.ZIndex    = 3
    E.Slider1CopyLabel.Visible   = true
    _FitText(E.Slider1CopyLabel, 166.97656374219468)

    E.Text7Copy2.Position     = Vector2.new(972, 615)
    E.Text7Copy2.Text         = "Late"
    E.Text7Copy2.Size         = 8
    E.Text7Copy2.Font         = 0
    E.Text7Copy2.Color        = Color3.fromRGB(179, 25, 107)
    E.Text7Copy2.Opacity      = 1
    E.Text7Copy2.Center       = false
    E.Text7Copy2.Outline      = false
    E.Text7Copy2.ZIndex       = 1
    E.Text7Copy2.Visible      = true

    E.Text7Copy3.Position     = Vector2.new(1137, 615)
    E.Text7Copy3.Text         = "Early"
    E.Text7Copy3.Size         = 8
    E.Text7Copy3.Font         = 0
    E.Text7Copy3.Color        = Color3.fromRGB(179, 25, 107)
    E.Text7Copy3.Opacity      = 1
    E.Text7Copy3.Center       = false
    E.Text7Copy3.Outline      = false
    E.Text7Copy3.ZIndex       = 1
    E.Text7Copy3.Visible      = true

    E.Text8.Position     = Vector2.new(927, 654)
    E.Text8.Text         = ";-;"
    E.Text8.Size         = 16
    E.Text8.Font         = 0
    E.Text8.Color        = Color3.fromRGB(255, 255, 255)
    E.Text8.Opacity      = 1
    E.Text8.Center       = false
    E.Text8.Outline      = false
    E.Text8.ZIndex       = 1
    E.Text8.Visible      = true

    E.Switch2Copy2Track.Position  = Vector2.new(981, 654)
    E.Switch2Copy2Track.Size      = Vector2.new(44, 22)
    E.Switch2Copy2Track.Color     = Color3.fromRGB(79, 79, 79)
    E.Switch2Copy2Track.Filled    = true
    E.Switch2Copy2Track.Thickness = 1
    E.Switch2Copy2Track.Rounding  = 11
    E.Switch2Copy2Track.ZIndex    = 1
    E.Switch2Copy2Track.Visible   = true

    E.Switch2Copy2Knob.Position  = Vector2.new(983, 656)
    E.Switch2Copy2Knob.Size      = Vector2.new(18, 18)
    E.Switch2Copy2Knob.Color     = Color3.fromRGB(250, 250, 250)
    E.Switch2Copy2Knob.Filled    = true
    E.Switch2Copy2Knob.Rounding  = 9
    E.Switch2Copy2Knob.ZIndex    = 2
    E.Switch2Copy2Knob.Visible   = true

    E.Switch2Copy2Label.Position     = Vector2.new(1033, 657)
    E.Switch2Copy2Label.Text         = "Debug Mode"
    E.Switch2Copy2Label.Size         = 16
    E.Switch2Copy2Label.Font         = 0
    E.Switch2Copy2Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Switch2Copy2Label.Outline      = false
    E.Switch2Copy2Label.ZIndex       = 2
    E.Switch2Copy2Label.Visible      = true

    E.Text8Copy.Position     = Vector2.new(883, 634)
    E.Text8Copy.Text         = ";-;"
    E.Text8Copy.Size         = 16
    E.Text8Copy.Font         = 0
    E.Text8Copy.Color        = Color3.fromRGB(255, 255, 255)
    E.Text8Copy.Opacity      = 1
    E.Text8Copy.Center       = false
    E.Text8Copy.Outline      = false
    E.Text8Copy.ZIndex       = 1
    E.Text8Copy.Visible      = true

    E.Button1Copy2Background.Position  = Vector2.new(912, 515)
    E.Button1Copy2Background.Size      = Vector2.new(58, 34)
    E.Button1Copy2Background.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1Copy2Background.Filled    = true
    E.Button1Copy2Background.Thickness = 1
    E.Button1Copy2Background.Rounding  = 4
    E.Button1Copy2Background.ZIndex    = 1
    E.Button1Copy2Background.Visible   = true

    E.Button1Copy2Text.Position     = Vector2.new(941, 526)
    E.Button1Copy2Text.Text         = "Misc"
    E.Button1Copy2Text.Size         = 11
    E.Button1Copy2Text.Font         = 2
    E.Button1Copy2Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Copy2Text.Center       = true
    E.Button1Copy2Text.Outline      = false
    E.Button1Copy2Text.ZIndex       = 2
    E.Button1Copy2Text.Visible      = true
    _FitText(E.Button1Copy2Text, 49.54416708872964)
    E.Button1Copy2Background.Opacity = 0.49
    E.Button1Copy2Text.Opacity = 0.49

    E.Line1Copy16.From      = Vector2.new(888, 442)
    E.Line1Copy16.To        = Vector2.new(1160, 442)
    E.Line1Copy16.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy16.Opacity   = 0.44
    E.Line1Copy16.Thickness = 1
    E.Line1Copy16.ZIndex    = 1
    E.Line1Copy16.Visible   = true

    E.Text1Copy3.Position     = Vector2.new(964, 413)
    E.Text1Copy3.Text         = "BROG"
    E.Text1Copy3.Size         = 16
    E.Text1Copy3.Font         = 0
    E.Text1Copy3.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy3.Opacity      = 1
    E.Text1Copy3.Center       = false
    E.Text1Copy3.Outline      = false
    E.Text1Copy3.ZIndex       = 1
    E.Text1Copy3.Visible      = true

    E.Circle1Copy3.Position  = Vector2.new(910, 415)
    E.Circle1Copy3.Radius    = 3.8125
    E.Circle1Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy3.Opacity   = 1
    E.Circle1Copy3.Filled    = false
    E.Circle1Copy3.Thickness = 1
    E.Circle1Copy3.NumSides  = 64
    E.Circle1Copy3.ZIndex    = 1
    E.Circle1Copy3.Visible   = true

    E.Circle2Copy3.Position  = Vector2.new(926, 415)
    E.Circle2Copy3.Radius    = 3.8125
    E.Circle2Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle2Copy3.Opacity   = 1
    E.Circle2Copy3.Filled    = false
    E.Circle2Copy3.Thickness = 1
    E.Circle2Copy3.NumSides  = 64
    E.Circle2Copy3.ZIndex    = 1
    E.Circle2Copy3.Visible   = true

    E.Line2Copy6.From      = Vector2.new(906, 402)
    E.Line2Copy6.To        = Vector2.new(903, 410)
    E.Line2Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy6.Opacity   = 1
    E.Line2Copy6.Thickness = 1
    E.Line2Copy6.ZIndex    = 1
    E.Line2Copy6.Visible   = true

    E.Line3Copy6.From      = Vector2.new(906, 402)
    E.Line3Copy6.To        = Vector2.new(910, 408)
    E.Line3Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy6.Opacity   = 1
    E.Line3Copy6.Thickness = 1
    E.Line3Copy6.ZIndex    = 1
    E.Line3Copy6.Visible   = true

    E.Line3Copy7.From      = Vector2.new(929, 401)
    E.Line3Copy7.To        = Vector2.new(925, 408)
    E.Line3Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3Copy7.Opacity   = 1
    E.Line3Copy7.Thickness = 1
    E.Line3Copy7.ZIndex    = 1
    E.Line3Copy7.Visible   = true

    E.Line2Copy7.From      = Vector2.new(929, 402)
    E.Line2Copy7.To        = Vector2.new(933, 410)
    E.Line2Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2Copy7.Opacity   = 1
    E.Line2Copy7.Thickness = 1
    E.Line2Copy7.ZIndex    = 1
    E.Line2Copy7.Visible   = true

    E.Line4Copy6.From      = Vector2.new(918, 423)
    E.Line4Copy6.To        = Vector2.new(915, 429)
    E.Line4Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy6.Opacity   = 1
    E.Line4Copy6.Thickness = 1
    E.Line4Copy6.ZIndex    = 1
    E.Line4Copy6.Visible   = true

    E.Line4Copy7.From      = Vector2.new(918, 424)
    E.Line4Copy7.To        = Vector2.new(921, 430)
    E.Line4Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy7.Opacity   = 1
    E.Line4Copy7.Thickness = 1
    E.Line4Copy7.ZIndex    = 1
    E.Line4Copy7.Visible   = true

    E.Line5Copy6.From      = Vector2.new(901, 424)
    E.Line5Copy6.To        = Vector2.new(911, 426)
    E.Line5Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy6.Opacity   = 1
    E.Line5Copy6.Thickness = 1
    E.Line5Copy6.ZIndex    = 1
    E.Line5Copy6.Visible   = true

    E.Line5Copy7.From      = Vector2.new(900, 430)
    E.Line5Copy7.To        = Vector2.new(911, 428)
    E.Line5Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy7.Opacity   = 1
    E.Line5Copy7.Thickness = 1
    E.Line5Copy7.ZIndex    = 1
    E.Line5Copy7.Visible   = true

    E.Line6Copy6.From      = Vector2.new(925, 426)
    E.Line6Copy6.To        = Vector2.new(936, 423)
    E.Line6Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy6.Opacity   = 1
    E.Line6Copy6.Thickness = 1
    E.Line6Copy6.ZIndex    = 1
    E.Line6Copy6.Visible   = true

    E.Line6Copy7.From      = Vector2.new(927, 428)
    E.Line6Copy7.To        = Vector2.new(938, 430)
    E.Line6Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy7.Opacity   = 1
    E.Line6Copy7.Thickness = 1
    E.Line6Copy7.ZIndex    = 1
    E.Line6Copy7.Visible   = true

    E.Line1Copy17.From      = Vector2.new(887, 633)
    E.Line1Copy17.To        = Vector2.new(950, 633)
    E.Line1Copy17.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy17.Opacity   = 0.44
    E.Line1Copy17.Thickness = 1
    E.Line1Copy17.ZIndex    = 1
    E.Line1Copy17.Visible   = true

    E.Text3Copy3.Position     = Vector2.new(1002, 412)
    E.Text3Copy3.Text         = ":  Gakuran"
    E.Text3Copy3.Size         = 16
    E.Text3Copy3.Font         = 0
    E.Text3Copy3.Color        = Color3.fromRGB(185, 24, 164)
    E.Text3Copy3.Opacity      = 1
    E.Text3Copy3.Center       = false
    E.Text3Copy3.Outline      = false
    E.Text3Copy3.ZIndex       = 1
    E.Text3Copy3.Visible      = true

    E.Square1Copy7.Position  = Vector2.new(887, 398)
    E.Square1Copy7.Size      = Vector2.new(272, 285)
    E.Square1Copy7.Color     = Color3.fromRGB(185, 24, 164)
    E.Square1Copy7.Opacity   = 0.66
    E.Square1Copy7.Filled    = false
    E.Square1Copy7.Thickness = 2
    E.Square1Copy7.Rounding  = 15
    E.Square1Copy7.ZIndex    = 1
    E.Square1Copy7.Visible   = true

    E.Button1Copy4Background.Position  = Vector2.new(890, 509)
    E.Button1Copy4Background.Size      = Vector2.new(58, 34)
    E.Button1Copy4Background.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1Copy4Background.Filled    = true
    E.Button1Copy4Background.Thickness = 1
    E.Button1Copy4Background.Rounding  = 4
    E.Button1Copy4Background.ZIndex    = 1
    E.Button1Copy4Background.Visible   = true

    E.Button1Copy4Text.Position     = Vector2.new(919, 520)
    E.Button1Copy4Text.Text         = "Misc"
    E.Button1Copy4Text.Size         = 11
    E.Button1Copy4Text.Font         = 2
    E.Button1Copy4Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Copy4Text.Center       = true
    E.Button1Copy4Text.Outline      = false
    E.Button1Copy4Text.ZIndex       = 2
    E.Button1Copy4Text.Visible      = true
    _FitText(E.Button1Copy4Text, 49.54416708872964)
    E.Button1Copy4Background.Opacity = 0.83
    E.Button1Copy4Text.Opacity = 0.83

    E.Button1Copy6Background.Position  = Vector2.new(890, 457)
    E.Button1Copy6Background.Size      = Vector2.new(58, 34)
    E.Button1Copy6Background.Color     = Color3.fromRGB(103, 116, 137)
    E.Button1Copy6Background.Filled    = true
    E.Button1Copy6Background.Thickness = 1
    E.Button1Copy6Background.Rounding  = 4
    E.Button1Copy6Background.ZIndex    = 1
    E.Button1Copy6Background.Visible   = true

    E.Button1Copy6Text.Position     = Vector2.new(919, 468)
    E.Button1Copy6Text.Text         = "Parry"
    E.Button1Copy6Text.Size         = 11
    E.Button1Copy6Text.Font         = 2
    E.Button1Copy6Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Copy6Text.Center       = true
    E.Button1Copy6Text.Outline      = false
    E.Button1Copy6Text.ZIndex       = 2
    E.Button1Copy6Text.Visible      = true
    _FitText(E.Button1Copy6Text, 49.54416708872964)
    E.Button1Copy6Background.Opacity = 0.49
    E.Button1Copy6Text.Opacity = 0.49

    E.Text8Copy2.Position     = Vector2.new(906, 648)
    E.Text8Copy2.Text         = ";-;"
    E.Text8Copy2.Size         = 16
    E.Text8Copy2.Font         = 0
    E.Text8Copy2.Color        = Color3.fromRGB(255, 255, 255)
    E.Text8Copy2.Opacity      = 1
    E.Text8Copy2.Center       = false
    E.Text8Copy2.Outline      = false
    E.Text8Copy2.ZIndex       = 1
    E.Text8Copy2.Visible      = true

    E.Text9.Position     = Vector2.new(960, 457)
    E.Text9.Text         = "Whitelist"
    E.Text9.Size         = 16
    E.Text9.Font         = 0
    E.Text9.Color        = Color3.fromRGB(255, 255, 255)
    E.Text9.Opacity      = 1
    E.Text9.Center       = false
    E.Text9.Outline      = false
    E.Text9.ZIndex       = 1
    E.Text9.Visible      = true

    E.Line1Copy18.From      = Vector2.new(955, 476)
    E.Line1Copy18.To        = Vector2.new(1075, 476)
    E.Line1Copy18.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy18.Opacity   = 0.44
    E.Line1Copy18.Thickness = 1
    E.Line1Copy18.ZIndex    = 1
    E.Line1Copy18.Visible   = true

    E.Dropdown2Background.Position  = Vector2.new(956, 484)
    E.Dropdown2Background.Size      = Vector2.new(150, 30)
    E.Dropdown2Background.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2Background.Filled    = true
    E.Dropdown2Background.Thickness = 1
    E.Dropdown2Background.Rounding  = 8
    E.Dropdown2Background.ZIndex    = 1
    E.Dropdown2Background.Visible   = true

    E.Dropdown2Text.Position  = Vector2.new(964, 491)
    E.Dropdown2Text.Text      = E.Dropdown2Selected
    E.Dropdown2Text.Size      = 16
    E.Dropdown2Text.Font      = 2
    E.Dropdown2Text.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2Text.Outline   = false
    E.Dropdown2Text.ZIndex    = 2
    E.Dropdown2Text.Visible   = true
    _FitText(E.Dropdown2Text, 122)

    E.Dropdown2Arrow.Position = Vector2.new(1090, 491)
    E.Dropdown2Arrow.Text     = "▼"
    E.Dropdown2Arrow.Size     = 12
    E.Dropdown2Arrow.Font     = 2
    E.Dropdown2Arrow.Color    = Color3.fromRGB(185, 24, 164)
    E.Dropdown2Arrow.ZIndex   = 2
    E.Dropdown2Arrow.Visible  = true

    E.Dropdown2OptionBackground0.Position  = Vector2.new(956, 514)
    E.Dropdown2OptionBackground0.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground0.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground0.Filled    = true
    E.Dropdown2OptionBackground0.Rounding  = 8
    E.Dropdown2OptionBackground0.ZIndex    = 3
    E.Dropdown2OptionBackground0.Visible   = false

    E.Dropdown2OptionText0.Position  = Vector2.new(964, 521)
    E.Dropdown2OptionText0.Text      = ""
    E.Dropdown2OptionText0.Size      = 16
    E.Dropdown2OptionText0.Font      = 2
    E.Dropdown2OptionText0.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText0.ZIndex    = 4
    E.Dropdown2OptionText0.Visible   = false

    E.Dropdown2OptionBackground1.Position  = Vector2.new(956, 544)
    E.Dropdown2OptionBackground1.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground1.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground1.Filled    = true
    E.Dropdown2OptionBackground1.Rounding  = 8
    E.Dropdown2OptionBackground1.ZIndex    = 3
    E.Dropdown2OptionBackground1.Visible   = false

    E.Dropdown2OptionText1.Position  = Vector2.new(964, 551)
    E.Dropdown2OptionText1.Text      = ""
    E.Dropdown2OptionText1.Size      = 16
    E.Dropdown2OptionText1.Font      = 2
    E.Dropdown2OptionText1.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText1.ZIndex    = 4
    E.Dropdown2OptionText1.Visible   = false

    E.Dropdown2OptionBackground2.Position  = Vector2.new(956, 574)
    E.Dropdown2OptionBackground2.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground2.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground2.Filled    = true
    E.Dropdown2OptionBackground2.Rounding  = 8
    E.Dropdown2OptionBackground2.ZIndex    = 3
    E.Dropdown2OptionBackground2.Visible   = false

    E.Dropdown2OptionText2.Position  = Vector2.new(964, 581)
    E.Dropdown2OptionText2.Text      = ""
    E.Dropdown2OptionText2.Size      = 16
    E.Dropdown2OptionText2.Font      = 2
    E.Dropdown2OptionText2.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText2.ZIndex    = 4
    E.Dropdown2OptionText2.Visible   = false

    E.Dropdown2OptionBackground3.Position  = Vector2.new(956, 604)
    E.Dropdown2OptionBackground3.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground3.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground3.Filled    = true
    E.Dropdown2OptionBackground3.Rounding  = 8
    E.Dropdown2OptionBackground3.ZIndex    = 3
    E.Dropdown2OptionBackground3.Visible   = false

    E.Dropdown2OptionText3.Position  = Vector2.new(964, 611)
    E.Dropdown2OptionText3.Text      = ""
    E.Dropdown2OptionText3.Size      = 16
    E.Dropdown2OptionText3.Font      = 2
    E.Dropdown2OptionText3.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText3.ZIndex    = 4
    E.Dropdown2OptionText3.Visible   = false

    E.Dropdown2OptionBackground4.Position  = Vector2.new(956, 634)
    E.Dropdown2OptionBackground4.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground4.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground4.Filled    = true
    E.Dropdown2OptionBackground4.Rounding  = 8
    E.Dropdown2OptionBackground4.ZIndex    = 3
    E.Dropdown2OptionBackground4.Visible   = false

    E.Dropdown2OptionText4.Position  = Vector2.new(964, 641)
    E.Dropdown2OptionText4.Text      = ""
    E.Dropdown2OptionText4.Size      = 16
    E.Dropdown2OptionText4.Font      = 2
    E.Dropdown2OptionText4.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText4.ZIndex    = 4
    E.Dropdown2OptionText4.Visible   = false

    E.Dropdown2OptionBackground5.Position  = Vector2.new(956, 664)
    E.Dropdown2OptionBackground5.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground5.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground5.Filled    = true
    E.Dropdown2OptionBackground5.Rounding  = 8
    E.Dropdown2OptionBackground5.ZIndex    = 3
    E.Dropdown2OptionBackground5.Visible   = false

    E.Dropdown2OptionText5.Position  = Vector2.new(964, 671)
    E.Dropdown2OptionText5.Text      = ""
    E.Dropdown2OptionText5.Size      = 16
    E.Dropdown2OptionText5.Font      = 2
    E.Dropdown2OptionText5.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText5.ZIndex    = 4
    E.Dropdown2OptionText5.Visible   = false

    E.Dropdown2OptionBackground6.Position  = Vector2.new(956, 694)
    E.Dropdown2OptionBackground6.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground6.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground6.Filled    = true
    E.Dropdown2OptionBackground6.Rounding  = 8
    E.Dropdown2OptionBackground6.ZIndex    = 3
    E.Dropdown2OptionBackground6.Visible   = false

    E.Dropdown2OptionText6.Position  = Vector2.new(964, 701)
    E.Dropdown2OptionText6.Text      = ""
    E.Dropdown2OptionText6.Size      = 16
    E.Dropdown2OptionText6.Font      = 2
    E.Dropdown2OptionText6.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText6.ZIndex    = 4
    E.Dropdown2OptionText6.Visible   = false

    E.Dropdown2OptionBackground7.Position  = Vector2.new(956, 724)
    E.Dropdown2OptionBackground7.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground7.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground7.Filled    = true
    E.Dropdown2OptionBackground7.Rounding  = 8
    E.Dropdown2OptionBackground7.ZIndex    = 3
    E.Dropdown2OptionBackground7.Visible   = false

    E.Dropdown2OptionText7.Position  = Vector2.new(964, 731)
    E.Dropdown2OptionText7.Text      = ""
    E.Dropdown2OptionText7.Size      = 16
    E.Dropdown2OptionText7.Font      = 2
    E.Dropdown2OptionText7.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText7.ZIndex    = 4
    E.Dropdown2OptionText7.Visible   = false

    E.Dropdown2OptionBackground8.Position  = Vector2.new(956, 754)
    E.Dropdown2OptionBackground8.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground8.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground8.Filled    = true
    E.Dropdown2OptionBackground8.Rounding  = 8
    E.Dropdown2OptionBackground8.ZIndex    = 3
    E.Dropdown2OptionBackground8.Visible   = false

    E.Dropdown2OptionText8.Position  = Vector2.new(964, 761)
    E.Dropdown2OptionText8.Text      = ""
    E.Dropdown2OptionText8.Size      = 16
    E.Dropdown2OptionText8.Font      = 2
    E.Dropdown2OptionText8.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText8.ZIndex    = 4
    E.Dropdown2OptionText8.Visible   = false

    E.Dropdown2OptionBackground9.Position  = Vector2.new(956, 784)
    E.Dropdown2OptionBackground9.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground9.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground9.Filled    = true
    E.Dropdown2OptionBackground9.Rounding  = 8
    E.Dropdown2OptionBackground9.ZIndex    = 3
    E.Dropdown2OptionBackground9.Visible   = false

    E.Dropdown2OptionText9.Position  = Vector2.new(964, 791)
    E.Dropdown2OptionText9.Text      = ""
    E.Dropdown2OptionText9.Size      = 16
    E.Dropdown2OptionText9.Font      = 2
    E.Dropdown2OptionText9.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText9.ZIndex    = 4
    E.Dropdown2OptionText9.Visible   = false

    E.Dropdown2OptionBackground10.Position  = Vector2.new(956, 814)
    E.Dropdown2OptionBackground10.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground10.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground10.Filled    = true
    E.Dropdown2OptionBackground10.Rounding  = 8
    E.Dropdown2OptionBackground10.ZIndex    = 3
    E.Dropdown2OptionBackground10.Visible   = false

    E.Dropdown2OptionText10.Position  = Vector2.new(964, 821)
    E.Dropdown2OptionText10.Text      = ""
    E.Dropdown2OptionText10.Size      = 16
    E.Dropdown2OptionText10.Font      = 2
    E.Dropdown2OptionText10.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText10.ZIndex    = 4
    E.Dropdown2OptionText10.Visible   = false

    E.Dropdown2OptionBackground11.Position  = Vector2.new(956, 844)
    E.Dropdown2OptionBackground11.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground11.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground11.Filled    = true
    E.Dropdown2OptionBackground11.Rounding  = 8
    E.Dropdown2OptionBackground11.ZIndex    = 3
    E.Dropdown2OptionBackground11.Visible   = false

    E.Dropdown2OptionText11.Position  = Vector2.new(964, 851)
    E.Dropdown2OptionText11.Text      = ""
    E.Dropdown2OptionText11.Size      = 16
    E.Dropdown2OptionText11.Font      = 2
    E.Dropdown2OptionText11.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText11.ZIndex    = 4
    E.Dropdown2OptionText11.Visible   = false

    E.Dropdown2OptionBackground12.Position  = Vector2.new(956, 874)
    E.Dropdown2OptionBackground12.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground12.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground12.Filled    = true
    E.Dropdown2OptionBackground12.Rounding  = 8
    E.Dropdown2OptionBackground12.ZIndex    = 3
    E.Dropdown2OptionBackground12.Visible   = false

    E.Dropdown2OptionText12.Position  = Vector2.new(964, 881)
    E.Dropdown2OptionText12.Text      = ""
    E.Dropdown2OptionText12.Size      = 16
    E.Dropdown2OptionText12.Font      = 2
    E.Dropdown2OptionText12.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText12.ZIndex    = 4
    E.Dropdown2OptionText12.Visible   = false

    E.Dropdown2OptionBackground13.Position  = Vector2.new(956, 904)
    E.Dropdown2OptionBackground13.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground13.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground13.Filled    = true
    E.Dropdown2OptionBackground13.Rounding  = 8
    E.Dropdown2OptionBackground13.ZIndex    = 3
    E.Dropdown2OptionBackground13.Visible   = false

    E.Dropdown2OptionText13.Position  = Vector2.new(964, 911)
    E.Dropdown2OptionText13.Text      = ""
    E.Dropdown2OptionText13.Size      = 16
    E.Dropdown2OptionText13.Font      = 2
    E.Dropdown2OptionText13.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText13.ZIndex    = 4
    E.Dropdown2OptionText13.Visible   = false

    E.Dropdown2OptionBackground14.Position  = Vector2.new(956, 934)
    E.Dropdown2OptionBackground14.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground14.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground14.Filled    = true
    E.Dropdown2OptionBackground14.Rounding  = 8
    E.Dropdown2OptionBackground14.ZIndex    = 3
    E.Dropdown2OptionBackground14.Visible   = false

    E.Dropdown2OptionText14.Position  = Vector2.new(964, 941)
    E.Dropdown2OptionText14.Text      = ""
    E.Dropdown2OptionText14.Size      = 16
    E.Dropdown2OptionText14.Font      = 2
    E.Dropdown2OptionText14.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText14.ZIndex    = 4
    E.Dropdown2OptionText14.Visible   = false

    E.Dropdown2OptionBackground15.Position  = Vector2.new(956, 964)
    E.Dropdown2OptionBackground15.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground15.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground15.Filled    = true
    E.Dropdown2OptionBackground15.Rounding  = 8
    E.Dropdown2OptionBackground15.ZIndex    = 3
    E.Dropdown2OptionBackground15.Visible   = false

    E.Dropdown2OptionText15.Position  = Vector2.new(964, 971)
    E.Dropdown2OptionText15.Text      = ""
    E.Dropdown2OptionText15.Size      = 16
    E.Dropdown2OptionText15.Font      = 2
    E.Dropdown2OptionText15.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText15.ZIndex    = 4
    E.Dropdown2OptionText15.Visible   = false

    E.Dropdown2OptionBackground16.Position  = Vector2.new(956, 994)
    E.Dropdown2OptionBackground16.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground16.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground16.Filled    = true
    E.Dropdown2OptionBackground16.Rounding  = 8
    E.Dropdown2OptionBackground16.ZIndex    = 3
    E.Dropdown2OptionBackground16.Visible   = false

    E.Dropdown2OptionText16.Position  = Vector2.new(964, 1001)
    E.Dropdown2OptionText16.Text      = ""
    E.Dropdown2OptionText16.Size      = 16
    E.Dropdown2OptionText16.Font      = 2
    E.Dropdown2OptionText16.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText16.ZIndex    = 4
    E.Dropdown2OptionText16.Visible   = false

    E.Dropdown2OptionBackground17.Position  = Vector2.new(956, 1024)
    E.Dropdown2OptionBackground17.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground17.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground17.Filled    = true
    E.Dropdown2OptionBackground17.Rounding  = 8
    E.Dropdown2OptionBackground17.ZIndex    = 3
    E.Dropdown2OptionBackground17.Visible   = false

    E.Dropdown2OptionText17.Position  = Vector2.new(964, 1031)
    E.Dropdown2OptionText17.Text      = ""
    E.Dropdown2OptionText17.Size      = 16
    E.Dropdown2OptionText17.Font      = 2
    E.Dropdown2OptionText17.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText17.ZIndex    = 4
    E.Dropdown2OptionText17.Visible   = false

    E.Dropdown2OptionBackground18.Position  = Vector2.new(956, 1054)
    E.Dropdown2OptionBackground18.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground18.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground18.Filled    = true
    E.Dropdown2OptionBackground18.Rounding  = 8
    E.Dropdown2OptionBackground18.ZIndex    = 3
    E.Dropdown2OptionBackground18.Visible   = false

    E.Dropdown2OptionText18.Position  = Vector2.new(964, 1061)
    E.Dropdown2OptionText18.Text      = ""
    E.Dropdown2OptionText18.Size      = 16
    E.Dropdown2OptionText18.Font      = 2
    E.Dropdown2OptionText18.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText18.ZIndex    = 4
    E.Dropdown2OptionText18.Visible   = false

    E.Dropdown2OptionBackground19.Position  = Vector2.new(956, 1084)
    E.Dropdown2OptionBackground19.Size      = Vector2.new(150, 30)
    E.Dropdown2OptionBackground19.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2OptionBackground19.Filled    = true
    E.Dropdown2OptionBackground19.Rounding  = 8
    E.Dropdown2OptionBackground19.ZIndex    = 3
    E.Dropdown2OptionBackground19.Visible   = false

    E.Dropdown2OptionText19.Position  = Vector2.new(964, 1091)
    E.Dropdown2OptionText19.Text      = ""
    E.Dropdown2OptionText19.Size      = 16
    E.Dropdown2OptionText19.Font      = 2
    E.Dropdown2OptionText19.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2OptionText19.ZIndex    = 4
    E.Dropdown2OptionText19.Visible   = false

    E.Text9Copy.Position     = Vector2.new(959, 559)
    E.Text9Copy.Text         = "Strict Target"
    E.Text9Copy.Size         = 16
    E.Text9Copy.Font         = 0
    E.Text9Copy.Color        = Color3.fromRGB(255, 255, 255)
    E.Text9Copy.Opacity      = 1
    E.Text9Copy.Center       = false
    E.Text9Copy.Outline      = false
    E.Text9Copy.ZIndex       = 1
    E.Text9Copy.Visible      = true

    E.Line1Copy19.From      = Vector2.new(953, 580)
    E.Line1Copy19.To        = Vector2.new(1113, 580)
    E.Line1Copy19.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy19.Opacity   = 0.44
    E.Line1Copy19.Thickness = 1
    E.Line1Copy19.ZIndex    = 1
    E.Line1Copy19.Visible   = true

    E.Switch3Track.Position  = Vector2.new(966, 527)
    E.Switch3Track.Size      = Vector2.new(44, 22)
    E.Switch3Track.Color     = Color3.fromRGB(179, 25, 107)
    E.Switch3Track.Filled    = true
    E.Switch3Track.Thickness = 1
    E.Switch3Track.Rounding  = 11
    E.Switch3Track.ZIndex    = 1
    E.Switch3Track.Visible   = true

    E.Switch3Knob.Position  = Vector2.new(990, 529)
    E.Switch3Knob.Size      = Vector2.new(18, 18)
    E.Switch3Knob.Color     = Color3.fromRGB(255, 255, 255)
    E.Switch3Knob.Filled    = true
    E.Switch3Knob.Rounding  = 9
    E.Switch3Knob.ZIndex    = 2
    E.Switch3Knob.Visible   = true

    E.Switch3Label.Position     = Vector2.new(1018, 530)
    E.Switch3Label.Text         = "Master Switch"
    E.Switch3Label.Size         = 16
    E.Switch3Label.Font         = 0
    E.Switch3Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Switch3Label.Outline      = false
    E.Switch3Label.ZIndex       = 2
    E.Switch3Label.Visible      = true

    E.Dropdown2CopyBackground.Position  = Vector2.new(960, 590)
    E.Dropdown2CopyBackground.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyBackground.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyBackground.Filled    = true
    E.Dropdown2CopyBackground.Thickness = 1
    E.Dropdown2CopyBackground.Rounding  = 8
    E.Dropdown2CopyBackground.ZIndex    = 1
    E.Dropdown2CopyBackground.Visible   = true

    E.Dropdown2CopyText.Position  = Vector2.new(968, 597)
    E.Dropdown2CopyText.Text      = E.Dropdown2CopySelected
    E.Dropdown2CopyText.Size      = 16
    E.Dropdown2CopyText.Font      = 2
    E.Dropdown2CopyText.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyText.Outline   = false
    E.Dropdown2CopyText.ZIndex    = 2
    E.Dropdown2CopyText.Visible   = true
    _FitText(E.Dropdown2CopyText, 122)

    E.Dropdown2CopyArrow.Position = Vector2.new(1094, 597)
    E.Dropdown2CopyArrow.Text     = "▼"
    E.Dropdown2CopyArrow.Size     = 12
    E.Dropdown2CopyArrow.Font     = 2
    E.Dropdown2CopyArrow.Color    = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyArrow.ZIndex   = 2
    E.Dropdown2CopyArrow.Visible  = true

    E.Dropdown2CopyOptionBackground0.Position  = Vector2.new(960, 620)
    E.Dropdown2CopyOptionBackground0.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground0.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground0.Filled    = true
    E.Dropdown2CopyOptionBackground0.Rounding  = 8
    E.Dropdown2CopyOptionBackground0.ZIndex    = 3
    E.Dropdown2CopyOptionBackground0.Visible   = false

    E.Dropdown2CopyOptionText0.Position  = Vector2.new(968, 627)
    E.Dropdown2CopyOptionText0.Text      = ""
    E.Dropdown2CopyOptionText0.Size      = 16
    E.Dropdown2CopyOptionText0.Font      = 2
    E.Dropdown2CopyOptionText0.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText0.ZIndex    = 4
    E.Dropdown2CopyOptionText0.Visible   = false

    E.Dropdown2CopyOptionBackground1.Position  = Vector2.new(960, 650)
    E.Dropdown2CopyOptionBackground1.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground1.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground1.Filled    = true
    E.Dropdown2CopyOptionBackground1.Rounding  = 8
    E.Dropdown2CopyOptionBackground1.ZIndex    = 3
    E.Dropdown2CopyOptionBackground1.Visible   = false

    E.Dropdown2CopyOptionText1.Position  = Vector2.new(968, 657)
    E.Dropdown2CopyOptionText1.Text      = ""
    E.Dropdown2CopyOptionText1.Size      = 16
    E.Dropdown2CopyOptionText1.Font      = 2
    E.Dropdown2CopyOptionText1.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText1.ZIndex    = 4
    E.Dropdown2CopyOptionText1.Visible   = false

    E.Dropdown2CopyOptionBackground2.Position  = Vector2.new(960, 680)
    E.Dropdown2CopyOptionBackground2.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground2.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground2.Filled    = true
    E.Dropdown2CopyOptionBackground2.Rounding  = 8
    E.Dropdown2CopyOptionBackground2.ZIndex    = 3
    E.Dropdown2CopyOptionBackground2.Visible   = false

    E.Dropdown2CopyOptionText2.Position  = Vector2.new(968, 687)
    E.Dropdown2CopyOptionText2.Text      = ""
    E.Dropdown2CopyOptionText2.Size      = 16
    E.Dropdown2CopyOptionText2.Font      = 2
    E.Dropdown2CopyOptionText2.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText2.ZIndex    = 4
    E.Dropdown2CopyOptionText2.Visible   = false

    E.Dropdown2CopyOptionBackground3.Position  = Vector2.new(960, 710)
    E.Dropdown2CopyOptionBackground3.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground3.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground3.Filled    = true
    E.Dropdown2CopyOptionBackground3.Rounding  = 8
    E.Dropdown2CopyOptionBackground3.ZIndex    = 3
    E.Dropdown2CopyOptionBackground3.Visible   = false

    E.Dropdown2CopyOptionText3.Position  = Vector2.new(968, 717)
    E.Dropdown2CopyOptionText3.Text      = ""
    E.Dropdown2CopyOptionText3.Size      = 16
    E.Dropdown2CopyOptionText3.Font      = 2
    E.Dropdown2CopyOptionText3.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText3.ZIndex    = 4
    E.Dropdown2CopyOptionText3.Visible   = false

    E.Dropdown2CopyOptionBackground4.Position  = Vector2.new(960, 740)
    E.Dropdown2CopyOptionBackground4.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground4.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground4.Filled    = true
    E.Dropdown2CopyOptionBackground4.Rounding  = 8
    E.Dropdown2CopyOptionBackground4.ZIndex    = 3
    E.Dropdown2CopyOptionBackground4.Visible   = false

    E.Dropdown2CopyOptionText4.Position  = Vector2.new(968, 747)
    E.Dropdown2CopyOptionText4.Text      = ""
    E.Dropdown2CopyOptionText4.Size      = 16
    E.Dropdown2CopyOptionText4.Font      = 2
    E.Dropdown2CopyOptionText4.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText4.ZIndex    = 4
    E.Dropdown2CopyOptionText4.Visible   = false

    E.Dropdown2CopyOptionBackground5.Position  = Vector2.new(960, 770)
    E.Dropdown2CopyOptionBackground5.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground5.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground5.Filled    = true
    E.Dropdown2CopyOptionBackground5.Rounding  = 8
    E.Dropdown2CopyOptionBackground5.ZIndex    = 3
    E.Dropdown2CopyOptionBackground5.Visible   = false

    E.Dropdown2CopyOptionText5.Position  = Vector2.new(968, 777)
    E.Dropdown2CopyOptionText5.Text      = ""
    E.Dropdown2CopyOptionText5.Size      = 16
    E.Dropdown2CopyOptionText5.Font      = 2
    E.Dropdown2CopyOptionText5.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText5.ZIndex    = 4
    E.Dropdown2CopyOptionText5.Visible   = false

    E.Dropdown2CopyOptionBackground6.Position  = Vector2.new(960, 800)
    E.Dropdown2CopyOptionBackground6.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground6.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground6.Filled    = true
    E.Dropdown2CopyOptionBackground6.Rounding  = 8
    E.Dropdown2CopyOptionBackground6.ZIndex    = 3
    E.Dropdown2CopyOptionBackground6.Visible   = false

    E.Dropdown2CopyOptionText6.Position  = Vector2.new(968, 807)
    E.Dropdown2CopyOptionText6.Text      = ""
    E.Dropdown2CopyOptionText6.Size      = 16
    E.Dropdown2CopyOptionText6.Font      = 2
    E.Dropdown2CopyOptionText6.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText6.ZIndex    = 4
    E.Dropdown2CopyOptionText6.Visible   = false

    E.Dropdown2CopyOptionBackground7.Position  = Vector2.new(960, 830)
    E.Dropdown2CopyOptionBackground7.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground7.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground7.Filled    = true
    E.Dropdown2CopyOptionBackground7.Rounding  = 8
    E.Dropdown2CopyOptionBackground7.ZIndex    = 3
    E.Dropdown2CopyOptionBackground7.Visible   = false

    E.Dropdown2CopyOptionText7.Position  = Vector2.new(968, 837)
    E.Dropdown2CopyOptionText7.Text      = ""
    E.Dropdown2CopyOptionText7.Size      = 16
    E.Dropdown2CopyOptionText7.Font      = 2
    E.Dropdown2CopyOptionText7.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText7.ZIndex    = 4
    E.Dropdown2CopyOptionText7.Visible   = false

    E.Dropdown2CopyOptionBackground8.Position  = Vector2.new(960, 860)
    E.Dropdown2CopyOptionBackground8.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground8.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground8.Filled    = true
    E.Dropdown2CopyOptionBackground8.Rounding  = 8
    E.Dropdown2CopyOptionBackground8.ZIndex    = 3
    E.Dropdown2CopyOptionBackground8.Visible   = false

    E.Dropdown2CopyOptionText8.Position  = Vector2.new(968, 867)
    E.Dropdown2CopyOptionText8.Text      = ""
    E.Dropdown2CopyOptionText8.Size      = 16
    E.Dropdown2CopyOptionText8.Font      = 2
    E.Dropdown2CopyOptionText8.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText8.ZIndex    = 4
    E.Dropdown2CopyOptionText8.Visible   = false

    E.Dropdown2CopyOptionBackground9.Position  = Vector2.new(960, 890)
    E.Dropdown2CopyOptionBackground9.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground9.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground9.Filled    = true
    E.Dropdown2CopyOptionBackground9.Rounding  = 8
    E.Dropdown2CopyOptionBackground9.ZIndex    = 3
    E.Dropdown2CopyOptionBackground9.Visible   = false

    E.Dropdown2CopyOptionText9.Position  = Vector2.new(968, 897)
    E.Dropdown2CopyOptionText9.Text      = ""
    E.Dropdown2CopyOptionText9.Size      = 16
    E.Dropdown2CopyOptionText9.Font      = 2
    E.Dropdown2CopyOptionText9.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText9.ZIndex    = 4
    E.Dropdown2CopyOptionText9.Visible   = false

    E.Dropdown2CopyOptionBackground10.Position  = Vector2.new(960, 920)
    E.Dropdown2CopyOptionBackground10.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground10.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground10.Filled    = true
    E.Dropdown2CopyOptionBackground10.Rounding  = 8
    E.Dropdown2CopyOptionBackground10.ZIndex    = 3
    E.Dropdown2CopyOptionBackground10.Visible   = false

    E.Dropdown2CopyOptionText10.Position  = Vector2.new(968, 927)
    E.Dropdown2CopyOptionText10.Text      = ""
    E.Dropdown2CopyOptionText10.Size      = 16
    E.Dropdown2CopyOptionText10.Font      = 2
    E.Dropdown2CopyOptionText10.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText10.ZIndex    = 4
    E.Dropdown2CopyOptionText10.Visible   = false

    E.Dropdown2CopyOptionBackground11.Position  = Vector2.new(960, 950)
    E.Dropdown2CopyOptionBackground11.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground11.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground11.Filled    = true
    E.Dropdown2CopyOptionBackground11.Rounding  = 8
    E.Dropdown2CopyOptionBackground11.ZIndex    = 3
    E.Dropdown2CopyOptionBackground11.Visible   = false

    E.Dropdown2CopyOptionText11.Position  = Vector2.new(968, 957)
    E.Dropdown2CopyOptionText11.Text      = ""
    E.Dropdown2CopyOptionText11.Size      = 16
    E.Dropdown2CopyOptionText11.Font      = 2
    E.Dropdown2CopyOptionText11.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText11.ZIndex    = 4
    E.Dropdown2CopyOptionText11.Visible   = false

    E.Dropdown2CopyOptionBackground12.Position  = Vector2.new(960, 980)
    E.Dropdown2CopyOptionBackground12.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground12.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground12.Filled    = true
    E.Dropdown2CopyOptionBackground12.Rounding  = 8
    E.Dropdown2CopyOptionBackground12.ZIndex    = 3
    E.Dropdown2CopyOptionBackground12.Visible   = false

    E.Dropdown2CopyOptionText12.Position  = Vector2.new(968, 987)
    E.Dropdown2CopyOptionText12.Text      = ""
    E.Dropdown2CopyOptionText12.Size      = 16
    E.Dropdown2CopyOptionText12.Font      = 2
    E.Dropdown2CopyOptionText12.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText12.ZIndex    = 4
    E.Dropdown2CopyOptionText12.Visible   = false

    E.Dropdown2CopyOptionBackground13.Position  = Vector2.new(960, 1010)
    E.Dropdown2CopyOptionBackground13.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground13.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground13.Filled    = true
    E.Dropdown2CopyOptionBackground13.Rounding  = 8
    E.Dropdown2CopyOptionBackground13.ZIndex    = 3
    E.Dropdown2CopyOptionBackground13.Visible   = false

    E.Dropdown2CopyOptionText13.Position  = Vector2.new(968, 1017)
    E.Dropdown2CopyOptionText13.Text      = ""
    E.Dropdown2CopyOptionText13.Size      = 16
    E.Dropdown2CopyOptionText13.Font      = 2
    E.Dropdown2CopyOptionText13.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText13.ZIndex    = 4
    E.Dropdown2CopyOptionText13.Visible   = false

    E.Dropdown2CopyOptionBackground14.Position  = Vector2.new(960, 1040)
    E.Dropdown2CopyOptionBackground14.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground14.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground14.Filled    = true
    E.Dropdown2CopyOptionBackground14.Rounding  = 8
    E.Dropdown2CopyOptionBackground14.ZIndex    = 3
    E.Dropdown2CopyOptionBackground14.Visible   = false

    E.Dropdown2CopyOptionText14.Position  = Vector2.new(968, 1047)
    E.Dropdown2CopyOptionText14.Text      = ""
    E.Dropdown2CopyOptionText14.Size      = 16
    E.Dropdown2CopyOptionText14.Font      = 2
    E.Dropdown2CopyOptionText14.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText14.ZIndex    = 4
    E.Dropdown2CopyOptionText14.Visible   = false

    E.Dropdown2CopyOptionBackground15.Position  = Vector2.new(960, 1070)
    E.Dropdown2CopyOptionBackground15.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground15.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground15.Filled    = true
    E.Dropdown2CopyOptionBackground15.Rounding  = 8
    E.Dropdown2CopyOptionBackground15.ZIndex    = 3
    E.Dropdown2CopyOptionBackground15.Visible   = false

    E.Dropdown2CopyOptionText15.Position  = Vector2.new(968, 1077)
    E.Dropdown2CopyOptionText15.Text      = ""
    E.Dropdown2CopyOptionText15.Size      = 16
    E.Dropdown2CopyOptionText15.Font      = 2
    E.Dropdown2CopyOptionText15.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText15.ZIndex    = 4
    E.Dropdown2CopyOptionText15.Visible   = false

    E.Dropdown2CopyOptionBackground16.Position  = Vector2.new(960, 1100)
    E.Dropdown2CopyOptionBackground16.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground16.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground16.Filled    = true
    E.Dropdown2CopyOptionBackground16.Rounding  = 8
    E.Dropdown2CopyOptionBackground16.ZIndex    = 3
    E.Dropdown2CopyOptionBackground16.Visible   = false

    E.Dropdown2CopyOptionText16.Position  = Vector2.new(968, 1107)
    E.Dropdown2CopyOptionText16.Text      = ""
    E.Dropdown2CopyOptionText16.Size      = 16
    E.Dropdown2CopyOptionText16.Font      = 2
    E.Dropdown2CopyOptionText16.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText16.ZIndex    = 4
    E.Dropdown2CopyOptionText16.Visible   = false

    E.Dropdown2CopyOptionBackground17.Position  = Vector2.new(960, 1130)
    E.Dropdown2CopyOptionBackground17.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground17.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground17.Filled    = true
    E.Dropdown2CopyOptionBackground17.Rounding  = 8
    E.Dropdown2CopyOptionBackground17.ZIndex    = 3
    E.Dropdown2CopyOptionBackground17.Visible   = false

    E.Dropdown2CopyOptionText17.Position  = Vector2.new(968, 1137)
    E.Dropdown2CopyOptionText17.Text      = ""
    E.Dropdown2CopyOptionText17.Size      = 16
    E.Dropdown2CopyOptionText17.Font      = 2
    E.Dropdown2CopyOptionText17.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText17.ZIndex    = 4
    E.Dropdown2CopyOptionText17.Visible   = false

    E.Dropdown2CopyOptionBackground18.Position  = Vector2.new(960, 1160)
    E.Dropdown2CopyOptionBackground18.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground18.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground18.Filled    = true
    E.Dropdown2CopyOptionBackground18.Rounding  = 8
    E.Dropdown2CopyOptionBackground18.ZIndex    = 3
    E.Dropdown2CopyOptionBackground18.Visible   = false

    E.Dropdown2CopyOptionText18.Position  = Vector2.new(968, 1167)
    E.Dropdown2CopyOptionText18.Text      = ""
    E.Dropdown2CopyOptionText18.Size      = 16
    E.Dropdown2CopyOptionText18.Font      = 2
    E.Dropdown2CopyOptionText18.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText18.ZIndex    = 4
    E.Dropdown2CopyOptionText18.Visible   = false

    E.Dropdown2CopyOptionBackground19.Position  = Vector2.new(960, 1190)
    E.Dropdown2CopyOptionBackground19.Size      = Vector2.new(150, 30)
    E.Dropdown2CopyOptionBackground19.Color     = Color3.fromRGB(59, 59, 59)
    E.Dropdown2CopyOptionBackground19.Filled    = true
    E.Dropdown2CopyOptionBackground19.Rounding  = 8
    E.Dropdown2CopyOptionBackground19.ZIndex    = 3
    E.Dropdown2CopyOptionBackground19.Visible   = false

    E.Dropdown2CopyOptionText19.Position  = Vector2.new(968, 1197)
    E.Dropdown2CopyOptionText19.Text      = ""
    E.Dropdown2CopyOptionText19.Size      = 16
    E.Dropdown2CopyOptionText19.Font      = 2
    E.Dropdown2CopyOptionText19.Color     = Color3.fromRGB(185, 24, 164)
    E.Dropdown2CopyOptionText19.ZIndex    = 4
    E.Dropdown2CopyOptionText19.Visible   = false

    E.Switch3CopyTrack.Position  = Vector2.new(963, 631)
    E.Switch3CopyTrack.Size      = Vector2.new(44, 22)
    E.Switch3CopyTrack.Color     = Color3.fromRGB(79, 79, 79)
    E.Switch3CopyTrack.Filled    = true
    E.Switch3CopyTrack.Thickness = 1
    E.Switch3CopyTrack.Rounding  = 11
    E.Switch3CopyTrack.ZIndex    = 1
    E.Switch3CopyTrack.Visible   = true

    E.Switch3CopyKnob.Position  = Vector2.new(965, 633)
    E.Switch3CopyKnob.Size      = Vector2.new(18, 18)
    E.Switch3CopyKnob.Color     = Color3.fromRGB(255, 255, 255)
    E.Switch3CopyKnob.Filled    = true
    E.Switch3CopyKnob.Rounding  = 9
    E.Switch3CopyKnob.ZIndex    = 2
    E.Switch3CopyKnob.Visible   = true

    E.Switch3CopyLabel.Position     = Vector2.new(1015, 634)
    E.Switch3CopyLabel.Text         = "Master Switch"
    E.Switch3CopyLabel.Size         = 16
    E.Switch3CopyLabel.Font         = 0
    E.Switch3CopyLabel.Color        = Color3.fromRGB(255, 255, 255)
    E.Switch3CopyLabel.Outline      = false
    E.Switch3CopyLabel.ZIndex       = 2
    E.Switch3CopyLabel.Visible      = true

    E.Text4Copy2.Position     = Vector2.new(1101, 587)
    E.Text4Copy2.Text         = "DM brog"
    E.Text4Copy2.Size         = 14
    E.Text4Copy2.Font         = 0
    E.Text4Copy2.Color        = Color3.fromRGB(185, 24, 164)
    E.Text4Copy2.Opacity      = 1
    E.Text4Copy2.Center       = true
    E.Text4Copy2.Outline      = false
    E.Text4Copy2.ZIndex       = 1
    E.Text4Copy2.Visible      = true

    E.Text4Copy3.Position     = Vector2.new(1101, 606)
    E.Text4Copy3.Text         = "for bugs/suggestions"
    E.Text4Copy3.Size         = 14
    E.Text4Copy3.Font         = 0
    E.Text4Copy3.Color        = Color3.fromRGB(185, 24, 164)
    E.Text4Copy3.Opacity      = 1
    E.Text4Copy3.Center       = true
    E.Text4Copy3.Outline      = false
    E.Text4Copy3.ZIndex       = 1
    E.Text4Copy3.Visible      = true

    E.Line1Copy.From      = Vector2.new(802, 426)
    E.Line1Copy.To        = Vector2.new(802, 709)
    E.Line1Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy.Opacity   = 0.44
    E.Line1Copy.Thickness = 1
    E.Line1Copy.ZIndex    = 2
    E.Line1Copy.Visible   = true

    E.Line1Copy5.From      = Vector2.new(911, 390)
    E.Line1Copy5.To        = Vector2.new(911, 673)
    E.Line1Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy5.Opacity   = 0.44
    E.Line1Copy5.Thickness = 1
    E.Line1Copy5.ZIndex    = 2
    E.Line1Copy5.Visible   = true

    E.Line1Copy10.From      = Vector2.new(971, 405)
    E.Line1Copy10.To        = Vector2.new(971, 688)
    E.Line1Copy10.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy10.Opacity   = 0.44
    E.Line1Copy10.Thickness = 1
    E.Line1Copy10.ZIndex    = 2
    E.Line1Copy10.Visible   = true

    E.Line1Copy15.From      = Vector2.new(950, 399)
    E.Line1Copy15.To        = Vector2.new(950, 682)
    E.Line1Copy15.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1Copy15.Opacity   = 0.44
    E.Line1Copy15.Thickness = 1
    E.Line1Copy15.ZIndex    = 2
    E.Line1Copy15.Visible   = true
    SetTab(1)
end

do
    local PrevLeftPressed: boolean = false

    local function OnDropdown1Change(selected: string, index: number): ()
        _G.picked = index
    end

    local function OnButton1CopyClick(): ()
        send_notification("will have options for different themes soon", "info")
    end

    local function OnButton2Click(): ()
        local cw = game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/logic.lua")
            local vd = game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/vd/logicomg.lua")
                local gaku = game:HttpGet("https://github.com/grobshlob/funstuff-for-severe/raw/refs/heads/main/folder/gakuran/updatedparry.luau")
                    local func = luau.load(gaku)
                    if _G.picked == 1 then SetTab(2) loadstring(cw) elseif _G.picked == 3 then SetTab(3) func() elseif _G.picked == 2 then send_notification("pls wait for an update", "info") end
    end

    local function OnButton1Copy3Click(): ()
        
    end

    local function OnSwitch2Toggle(state: boolean): ()
        
    end

    local function OnSlider1Change(value: number): ()
        _G.slider = value
    end

    local function OnButton1Copy5Click(): ()
        
    end

    local function OnSwitch2CopyToggle(state: boolean): ()
        
    end

    local function OnSlider1CopyChange(value: number): ()
        _G.slider = value
    end

    local function OnSwitch2Copy2Toggle(state: boolean): ()
        
    end

    local function OnButton1Copy4Click(): ()
        
    end

    local function OnDropdown2Change(selected: string, index: number): ()
        if _G.whitelist[selected] then
            _G.whitelist[selected] = nil
        else
                _G.whitelist[selected] = true
            end
    end

    local function OnSwitch3Toggle(state: boolean): ()
        
    end

    local function OnDropdown2CopyChange(selected: string, index: number): ()
        if _G.strict[selected] then
            _G.strict[selected] = nil
        else
                _G.strict[selected] = true
            end
    end

    local function OnSwitch3CopyToggle(state: boolean): ()
        
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip input when Roblox unfocused
        local Mouse: Vector2       = UserInputService:GetMouseLocation() * _G.dpi
        local LeftPressed: boolean = isleftpressed()
        local LeftClicked: boolean = LeftPressed and not PrevLeftPressed

        if ActiveTab == 2 and LeftClicked then
            local Pos  = E.Switch2Track.Position
            local Size = E.Switch2Track.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Switch2Enabled = not E.Switch2Enabled
                if E.Switch2Enabled then
                    E.Switch2Track.Color   = _HC6
                    E.Switch2Knob.Position = Pos + Vector2.new(24, 2)
                else
                    E.Switch2Track.Color   = _HC5
                    E.Switch2Knob.Position = Pos + Vector2.new(2, 2)
                end
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Switch2CopyTrack.Position
            local Size = E.Switch2CopyTrack.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Switch2CopyEnabled = not E.Switch2CopyEnabled
                if E.Switch2CopyEnabled then
                    E.Switch2CopyTrack.Color   = _HC6
                    E.Switch2CopyKnob.Position = Pos + Vector2.new(24, 2)
                else
                    E.Switch2CopyTrack.Color   = _HC5
                    E.Switch2CopyKnob.Position = Pos + Vector2.new(2, 2)
                end
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Switch2Copy2Track.Position
            local Size = E.Switch2Copy2Track.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Switch2Copy2Enabled = not E.Switch2Copy2Enabled
                if E.Switch2Copy2Enabled then
                    E.Switch2Copy2Track.Color   = _HC6
                    E.Switch2Copy2Knob.Position = Pos + Vector2.new(24, 2)
                else
                    E.Switch2Copy2Track.Color   = _HC5
                    E.Switch2Copy2Knob.Position = Pos + Vector2.new(2, 2)
                end
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Switch3Track.Position
            local Size = E.Switch3Track.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Switch3Enabled = not E.Switch3Enabled
                if E.Switch3Enabled then
                    E.Switch3Track.Color   = _HC6
                    E.Switch3Knob.Position = Pos + Vector2.new(24, 2)
                else
                    E.Switch3Track.Color   = _HC5
                    E.Switch3Knob.Position = Pos + Vector2.new(2, 2)
                end
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Switch3CopyTrack.Position
            local Size = E.Switch3CopyTrack.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Switch3CopyEnabled = not E.Switch3CopyEnabled
                if E.Switch3CopyEnabled then
                    E.Switch3CopyTrack.Color   = _HC6
                    E.Switch3CopyKnob.Position = Pos + Vector2.new(24, 2)
                else
                    E.Switch3CopyTrack.Color   = _HC5
                    E.Switch3CopyKnob.Position = Pos + Vector2.new(2, 2)
                end
            end
        end

        if ActiveTab == 1 and LeftClicked then
            do
                local Pos  = E.Dropdown1Background.Position
                local Size = E.Dropdown1Background.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown1Open = not E.Dropdown1Open
                end
            end
            if E.Dropdown1Open then
                local Pos  = E.Dropdown1OptionBackground0.Position
                local Size = E.Dropdown1OptionBackground0.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown1Selected = "Combat Warriors"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 1
                    E.Dropdown1Fired    = true
                end
            end
            if E.Dropdown1Open then
                local Pos  = E.Dropdown1OptionBackground1.Position
                local Size = E.Dropdown1OptionBackground1.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown1Selected = "Violence District"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 2
                    E.Dropdown1Fired    = true
                end
            end
            if E.Dropdown1Open then
                local Pos  = E.Dropdown1OptionBackground2.Position
                local Size = E.Dropdown1OptionBackground2.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown1Selected = "Gakuran"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 3
                    E.Dropdown1Fired    = true
                end
            end
        end

        if ActiveTab == 4 and LeftClicked then
            do
                local Pos  = E.Dropdown2Background.Position
                local Size = E.Dropdown2Background.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown2Open = not E.Dropdown2Open
                end
            end
            if E.Dropdown2Open then
                local BgPos  = E.Dropdown2Background.Position
                local BgSize = E.Dropdown2Background.Size
                for _i = 1, E.Dropdown2SlotCount do
                    local SlotY = BgPos.Y + BgSize.Y * _i
                    if Mouse.X >= BgPos.X and Mouse.X <= BgPos.X + BgSize.X
                    and Mouse.Y >= SlotY and Mouse.Y < SlotY + BgSize.Y then
                        E.Dropdown2Selected = tostring(E.Dropdown2Options[_i] or "")
                        E.Dropdown2Open     = false
                        E.Dropdown2FiredIdx = _i
                        E.Dropdown2Fired    = true
                        break
                    end
                end
            end
        end
        if ActiveTab == 4 and E.Dropdown2Open then
            local _opts = (function() local pl = game:GetService("Players")
local lp = pl.LocalPlayer
local t = {}
for _, p in pairs(pl:GetChildren()) do
    if p.Name ~= lp.Name then
		local char = p.Character
		local lpchar = lp.Character
		if not char or not lpchar then continue end
		local part = char:FindFirstChild("HumanoidRootPart")
		local lppart = lpchar:FindFirstChild("HumanoidRootPart")
		if not part or not lppart then continue end
		if vector.magnitude(part.Position - lppart.Position) <= 75 then
			t[#t+1] = p.Name 
		end
    end
end
return t end)()
            if type(_opts) ~= "table" then _opts = {} end
            E.Dropdown2Options   = _opts
            E.Dropdown2SlotCount = math.min(#_opts, 20)
        end

        if ActiveTab == 4 and LeftClicked then
            do
                local Pos  = E.Dropdown2CopyBackground.Position
                local Size = E.Dropdown2CopyBackground.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown2CopyOpen = not E.Dropdown2CopyOpen
                end
            end
            if E.Dropdown2CopyOpen then
                local BgPos  = E.Dropdown2CopyBackground.Position
                local BgSize = E.Dropdown2CopyBackground.Size
                for _i = 1, E.Dropdown2CopySlotCount do
                    local SlotY = BgPos.Y + BgSize.Y * _i
                    if Mouse.X >= BgPos.X and Mouse.X <= BgPos.X + BgSize.X
                    and Mouse.Y >= SlotY and Mouse.Y < SlotY + BgSize.Y then
                        E.Dropdown2CopySelected = tostring(E.Dropdown2CopyOptions[_i] or "")
                        E.Dropdown2CopyOpen     = false
                        E.Dropdown2CopyFiredIdx = _i
                        E.Dropdown2CopyFired    = true
                        break
                    end
                end
            end
        end
        if ActiveTab == 4 and E.Dropdown2CopyOpen then
            local _opts = (function() local pl = game:GetService("Players")
local lp = pl.LocalPlayer
local t = {}
for _, p in pairs(pl:GetChildren()) do
    if p.Name ~= lp.Name then
		local char = p.Character
		local lpchar = lp.Character
		if not char or not lpchar then continue end
		local part = char:FindFirstChild("HumanoidRootPart")
		local lppart = lpchar:FindFirstChild("HumanoidRootPart")
		if not part or not lppart then continue end
		if vector.magnitude(part.Position - lppart.Position) <= 75 then
			t[#t+1] = p.Name 
		end
    end
end
return t end)()
            if type(_opts) ~= "table" then _opts = {} end
            E.Dropdown2CopyOptions   = _opts
            E.Dropdown2CopySlotCount = math.min(#_opts, 20)
        end

        do
            local Pos  = E.Slider1Track.Position
            local Size = E.Slider1Track.Size
            local InRange: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                                 and Mouse.Y >= Pos.Y - 4 and Mouse.Y <= Pos.Y + Size.Y + 4
            if ActiveTab == 2 and LeftPressed and (E.Slider1Dragging or InRange) then
                E.Slider1Dragging = true
                local T: number = MathClamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Raw: number = 0.1 + T * (10 - 0.1)
                E.Slider1Value         = MathFloor(Raw / 0.1 + 0.5) * 0.1
                E.Slider1Fired         = true
            elseif not LeftPressed then
                E.Slider1Dragging = false
            end
        end

        do
            local Pos  = E.Slider1CopyTrack.Position
            local Size = E.Slider1CopyTrack.Size
            local InRange: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                                 and Mouse.Y >= Pos.Y - 4 and Mouse.Y <= Pos.Y + Size.Y + 4
            if ActiveTab == 3 and LeftPressed and (E.Slider1CopyDragging or InRange) then
                E.Slider1CopyDragging = true
                local T: number = MathClamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Raw: number = 0.05 + T * (3 - 0.05)
                E.Slider1CopyValue         = MathFloor(Raw / 0.01 + 0.5) * 0.01
                E.Slider1CopyFired         = true
            elseif not LeftPressed then
                E.Slider1CopyDragging = false
            end
        end

        do
            local Pos  = E.Button1Background.Position
            local Size = E.Button1Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 1 and Over and LeftClicked then
                SetTab(1)
            end
        end

        do
            local Pos  = E.Button1CopyBackground.Position
            local Size = E.Button1CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 1 and Over and LeftClicked then
                E.Button1CopyFired   = true
            end
        end

        do
            local Pos  = E.Button2Background.Position
            local Size = E.Button2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 1 and Over and LeftClicked then
                E.Button2Fired   = true
            end
        end

        do
            local Pos  = E.Button1Copy3Background.Position
            local Size = E.Button1Copy3Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 2 and Over and LeftClicked then
                E.Button1Copy3Fired   = true
            end
        end

        do
            local Pos  = E.Button1Copy5Background.Position
            local Size = E.Button1Copy5Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 3 and Over and LeftClicked then
                E.Button1Copy5Fired   = true
            end
        end

        do
            local Pos  = E.Button1Copy2Background.Position
            local Size = E.Button1Copy2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 3 and Over and LeftClicked then
                SetTab(4)
            end
        end

        do
            local Pos  = E.Button1Copy4Background.Position
            local Size = E.Button1Copy4Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 4 and Over and LeftClicked then
                E.Button1Copy4Fired   = true
            end
        end

        do
            local Pos  = E.Button1Copy6Background.Position
            local Size = E.Button1Copy6Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 4 and Over and LeftClicked then
                SetTab(3)
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1.Position
            local SquareSize: Vector2 = E.Square1.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Dropdown1Background.Position
                local ChildSize = E.Dropdown1Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Button1Background.Position
                local ChildSize = E.Button1Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Button1CopyBackground.Position
                local ChildSize = E.Button1CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Button2Background.Position
                local ChildSize = E.Button2Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1DragActive or OnSquare) then
                if not E.Square1DragActive then
                    E.Square1DragActive     = true
                    E.Square1DragStartMouse = Mouse
                    E.Square1DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1DragActive = false
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy2.Position
            local SquareSize: Vector2 = E.Square1Copy2.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Button1Copy3Background.Position
                local ChildSize = E.Button1Copy3Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Switch2Track.Position
                local ChildSize = E.Switch2Track.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Slider1Track.Position
                local ChildSize = E.Slider1Track.Size
                if E.Slider1Dragging
                or (Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y - 8 and Mouse.Y <= ChildPos.Y + ChildSize.Y + 8) then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1Copy2DragActive or OnSquare) then
                if not E.Square1Copy2DragActive then
                    E.Square1Copy2DragActive     = true
                    E.Square1Copy2DragStartMouse = Mouse
                    E.Square1Copy2DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1Copy2DragActive = false
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy4.Position
            local SquareSize: Vector2 = E.Square1Copy4.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Button1Copy5Background.Position
                local ChildSize = E.Button1Copy5Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Switch2CopyTrack.Position
                local ChildSize = E.Switch2CopyTrack.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Slider1CopyTrack.Position
                local ChildSize = E.Slider1CopyTrack.Size
                if E.Slider1CopyDragging
                or (Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y - 8 and Mouse.Y <= ChildPos.Y + ChildSize.Y + 8) then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Switch2Copy2Track.Position
                local ChildSize = E.Switch2Copy2Track.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Button1Copy2Background.Position
                local ChildSize = E.Button1Copy2Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1Copy4DragActive or OnSquare) then
                if not E.Square1Copy4DragActive then
                    E.Square1Copy4DragActive     = true
                    E.Square1Copy4DragStartMouse = Mouse
                    E.Square1Copy4DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1Copy4DragActive = false
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy6.Position
            local SquareSize: Vector2 = E.Square1Copy6.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Button1Copy4Background.Position
                local ChildSize = E.Button1Copy4Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Button1Copy6Background.Position
                local ChildSize = E.Button1Copy6Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Dropdown2Background.Position
                local ChildSize = E.Dropdown2Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Switch3Track.Position
                local ChildSize = E.Switch3Track.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Dropdown2CopyBackground.Position
                local ChildSize = E.Dropdown2CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Switch3CopyTrack.Position
                local ChildSize = E.Switch3CopyTrack.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1Copy6DragActive or OnSquare) then
                if not E.Square1Copy6DragActive then
                    E.Square1Copy6DragActive     = true
                    E.Square1Copy6DragStartMouse = Mouse
                    E.Square1Copy6DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1Copy6DragActive = false
            end
        end

        PrevLeftPressed = LeftPressed
    end)

    do
        local function _noopWait(_: number?) end  -- legacy wait() in a toggle body is now a no-op (callbacks are edge-triggered, not per-frame)
        local _prevSwitch2: boolean = E.Switch2Enabled  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevSwitch2Copy: boolean = E.Switch2CopyEnabled  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevSwitch2Copy2: boolean = E.Switch2Copy2Enabled  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevSwitch3: boolean = E.Switch3Enabled  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevSwitch3Copy: boolean = E.Switch3CopyEnabled  -- edge-trigger tracker: fire the callback only when the state actually changes
        RunService.PostLocal:Connect(function()
            if not isrbxactive() then return end
            if E.Dropdown1Fired then
                local _i: number = E.Dropdown1FiredIdx
                E.Dropdown1Fired = false
                task.spawn(OnDropdown1Change, E.Dropdown1Selected, _i)
            end
            if E.Button1CopyFired then
                E.Button1CopyFired = false
                task.spawn(OnButton1CopyClick)
            end
            if E.Button2Fired then
                E.Button2Fired = false
                task.spawn(OnButton2Click)
            end
            if E.Button1Copy3Fired then
                E.Button1Copy3Fired = false
                task.spawn(OnButton1Copy3Click)
            end
            if E.Slider1Fired then
                E.Slider1Fired = false
                task.spawn(OnSlider1Change, E.Slider1Value)
            end
            if E.Button1Copy5Fired then
                E.Button1Copy5Fired = false
                task.spawn(OnButton1Copy5Click)
            end
            if E.Slider1CopyFired then
                E.Slider1CopyFired = false
                task.spawn(OnSlider1CopyChange, E.Slider1CopyValue)
            end
            if E.Button1Copy4Fired then
                E.Button1Copy4Fired = false
                task.spawn(OnButton1Copy4Click)
            end
            if E.Dropdown2Fired then
                local _i: number = E.Dropdown2FiredIdx
                E.Dropdown2Fired = false
                task.spawn(OnDropdown2Change, E.Dropdown2Selected, _i)
            end
            if E.Dropdown2CopyFired then
                local _i: number = E.Dropdown2CopyFiredIdx
                E.Dropdown2CopyFired = false
                task.spawn(OnDropdown2CopyChange, E.Dropdown2CopySelected, _i)
            end

            if E.Switch2Enabled ~= _prevSwitch2 then
                local state: boolean = E.Switch2Enabled
                _prevSwitch2 = state
                task.spawn(function()
                    local wait = _noopWait
                    if state then
                        _G.loaded = true
                    else
                            _G.loaded = false
                        end
                end)
            end

            if E.Switch2CopyEnabled ~= _prevSwitch2Copy then
                local state: boolean = E.Switch2CopyEnabled
                _prevSwitch2Copy = state
                task.spawn(function()
                    local wait = _noopWait
                    if state then
                        _G.loaded = true
                    else
                            _G.loaded = false
                        end
                end)
            end

            if E.Switch2Copy2Enabled ~= _prevSwitch2Copy2 then
                local state: boolean = E.Switch2Copy2Enabled
                _prevSwitch2Copy2 = state
                task.spawn(function()
                    local wait = _noopWait
                    if state then
                        _G.debug = true
                    else
                            _G.debug = false
                        end
                end)
            end

            if E.Switch3Enabled ~= _prevSwitch3 then
                local state: boolean = E.Switch3Enabled
                _prevSwitch3 = state
                task.spawn(function()
                    local wait = _noopWait
                    if not state then while task.wait(0.5) do _G.whitelist = {} end end
                end)
            end

            if E.Switch3CopyEnabled ~= _prevSwitch3Copy then
                local state: boolean = E.Switch3CopyEnabled
                _prevSwitch3Copy = state
                task.spawn(function()
                    local wait = _noopWait
                    if state then
                        strictmode = true
                    else
                            strictmode = false
                        end
                end)
            end
        end)
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation() * _G.dpi

        E.Dropdown1Text.Text  = E.Dropdown1Selected
        _FitText(E.Dropdown1Text, 122)
        E.Dropdown1Arrow.Text = if E.Dropdown1Open then "▲" else "▼"
        E.Dropdown1OptionBackground0.Visible = ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionText0.Visible       = ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionBackground1.Visible = ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionText1.Visible       = ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionBackground2.Visible = ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionText2.Visible       = ActiveTab == 1 and E.Dropdown1Open

        do
            local _BgPos   = E.Dropdown2Background.Position
            local _BgSize  = E.Dropdown2Background.Size
            local _OptBg   = E.Dropdown2_OptBg
            local _OptTx   = E.Dropdown2_OptTx
            local _OptPrev = E.Dropdown2_OptPrev
            local _Options = E.Dropdown2Options
            local _Count   = E.Dropdown2SlotCount
            E.Dropdown2Text.Text  = E.Dropdown2Selected
            _FitText(E.Dropdown2Text, 122)
            E.Dropdown2Arrow.Text = if E.Dropdown2Open then "▲" else "▼"
            for _i = 1, 20 do
                local _bg = _OptBg[_i]
                local _tx = _OptTx[_i]
                local _show: boolean = ActiveTab == 4 and E.Dropdown2Open and _i <= _Count
                _bg.Visible = _show
                _tx.Visible = _show
                if _show then
                    _bg.Position = Vector2.new(_BgPos.X, _BgPos.Y + _BgSize.Y * _i)
                    _bg.Size     = _BgSize
                    _tx.Position = Vector2.new(_BgPos.X + 6, _BgPos.Y + _BgSize.Y * _i + 4)
                    local _opt = _Options[_i]
                    local _str = if type(_opt) == "string" then _opt else tostring(_opt or "")
                    if _str ~= _OptPrev[_i] then
                        _tx.Text     = _str
                        _FitText(_tx, 134)
                        _OptPrev[_i] = _str
                    end
                end
            end
        end

        do
            local _BgPos   = E.Dropdown2CopyBackground.Position
            local _BgSize  = E.Dropdown2CopyBackground.Size
            local _OptBg   = E.Dropdown2Copy_OptBg
            local _OptTx   = E.Dropdown2Copy_OptTx
            local _OptPrev = E.Dropdown2Copy_OptPrev
            local _Options = E.Dropdown2CopyOptions
            local _Count   = E.Dropdown2CopySlotCount
            E.Dropdown2CopyText.Text  = E.Dropdown2CopySelected
            _FitText(E.Dropdown2CopyText, 122)
            E.Dropdown2CopyArrow.Text = if E.Dropdown2CopyOpen then "▲" else "▼"
            for _i = 1, 20 do
                local _bg = _OptBg[_i]
                local _tx = _OptTx[_i]
                local _show: boolean = ActiveTab == 4 and E.Dropdown2CopyOpen and _i <= _Count
                _bg.Visible = _show
                _tx.Visible = _show
                if _show then
                    _bg.Position = Vector2.new(_BgPos.X, _BgPos.Y + _BgSize.Y * _i)
                    _bg.Size     = _BgSize
                    _tx.Position = Vector2.new(_BgPos.X + 6, _BgPos.Y + _BgSize.Y * _i + 4)
                    local _opt = _Options[_i]
                    local _str = if type(_opt) == "string" then _opt else tostring(_opt or "")
                    if _str ~= _OptPrev[_i] then
                        _tx.Text     = _str
                        _FitText(_tx, 134)
                        _OptPrev[_i] = _str
                    end
                end
            end
        end

        do
            local T: number  = MathClamp((E.Slider1Value - 0.1) / 9.9, 0, 1)
            local FW: number = E.Slider1Track.Size.X * T
            E.Slider1Fill.Size     = Vector2.new(FW, E.Slider1Track.Size.Y)
            E.Slider1Knob.Position = Vector2.new(E.Slider1Track.Position.X + FW - 5, E.Slider1Track.Position.Y - 2)
            if E.Slider1Value ~= E.Slider1_LabelPrev then
                E.Slider1Label.Text = _FmtNum(E.Slider1Value) .. ""
                _FitText(E.Slider1Label, 166.97656374219468)
                E.Slider1_LabelPrev = E.Slider1Value
            end
        end
        do
            local T: number  = MathClamp((E.Slider1CopyValue - 0.05) / 2.95, 0, 1)
            local FW: number = E.Slider1CopyTrack.Size.X * T
            E.Slider1CopyFill.Size     = Vector2.new(FW, E.Slider1CopyTrack.Size.Y)
            E.Slider1CopyKnob.Position = Vector2.new(E.Slider1CopyTrack.Position.X + FW - 5, E.Slider1CopyTrack.Position.Y - 2)
            if E.Slider1CopyValue ~= E.Slider1Copy_LabelPrev then
                E.Slider1CopyLabel.Text = _FmtNum(E.Slider1CopyValue) .. ""
                _FitText(E.Slider1CopyLabel, 166.97656374219468)
                E.Slider1Copy_LabelPrev = E.Slider1CopyValue
            end
        end

        do
            local Pos  = E.Button1Background.Position
            local Size = E.Button1Background.Size
            local Over:  boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            local IsAct: boolean = ActiveTab == 1
            E.Button1Background.Color = if IsAct then _HC1 elseif Over then _HC1 else _HC0
            E.Button1Text.Color       = if IsAct then _HC2 else _HC2
        end
        do
            local Pos  = E.Button1CopyBackground.Position
            local Size = E.Button1CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button1CopyBackground.Color = if Over then _HC1 else _HC0
        end
        do
            local Pos  = E.Button2Background.Position
            local Size = E.Button2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2Background.Color = if Over then _HC4 else _HC3
        end
        do
            local Pos  = E.Button1Copy3Background.Position
            local Size = E.Button1Copy3Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button1Copy3Background.Color = if Over then _HC1 else _HC0
        end
        do
            local Pos  = E.Button1Copy5Background.Position
            local Size = E.Button1Copy5Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button1Copy5Background.Color = if Over then _HC1 else _HC0
        end
        do
            local Pos  = E.Button1Copy2Background.Position
            local Size = E.Button1Copy2Background.Size
            local Over:  boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            local IsAct: boolean = ActiveTab == 4
            E.Button1Copy2Background.Color = if IsAct then _HC1 elseif Over then _HC1 else _HC0
            E.Button1Copy2Text.Color       = if IsAct then _HC2 else _HC2
        end
        do
            local Pos  = E.Button1Copy4Background.Position
            local Size = E.Button1Copy4Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button1Copy4Background.Color = if Over then _HC1 else _HC0
        end
        do
            local Pos  = E.Button1Copy6Background.Position
            local Size = E.Button1Copy6Background.Size
            local Over:  boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            local IsAct: boolean = ActiveTab == 3
            E.Button1Copy6Background.Color = if IsAct then _HC1 elseif Over then _HC1 else _HC0
            E.Button1Copy6Text.Color       = if IsAct then _HC2 else _HC2
        end

        if E.Square1DragActive then
            local NewPos: Vector2 = E.Square1DragStartPos + (Mouse - E.Square1DragStartMouse)
            E.Square1.Position = NewPos

            E.Line1.From = NewPos + Vector2.new(2, 45)
            E.Line1.To   = NewPos + Vector2.new(462, 45)

            E.Line1Copy.From = NewPos + Vector2.new(63, 1)
            E.Line1Copy.To   = NewPos + Vector2.new(63, 284)

            E.Text1.Position = NewPos + Vector2.new(77, 15)

            E.Dropdown1Background.Position = NewPos + Vector2.new(77, 94)
            E.Dropdown1Text.Position       = NewPos + Vector2.new(85, 102)
            E.Dropdown1Arrow.Position      = NewPos + Vector2.new(211, 102)
            E.Dropdown1OptionBackground0.Position = NewPos + Vector2.new(77, 124)
            E.Dropdown1OptionText0.Position       = NewPos + Vector2.new(85, 132)
            E.Dropdown1OptionBackground1.Position = NewPos + Vector2.new(77, 154)
            E.Dropdown1OptionText1.Position       = NewPos + Vector2.new(85, 162)
            E.Dropdown1OptionBackground2.Position = NewPos + Vector2.new(77, 184)
            E.Dropdown1OptionText2.Position       = NewPos + Vector2.new(85, 192)

            E.Circle1.Position = NewPos + Vector2.new(23, 17)

            E.Circle2.Position = NewPos + Vector2.new(38, 17)

            E.Line2.From = NewPos + Vector2.new(19, 4)
            E.Line2.To   = NewPos + Vector2.new(16, 12)

            E.Line3.From = NewPos + Vector2.new(19, 4)
            E.Line3.To   = NewPos + Vector2.new(23, 10)

            E.Line2Copy.From = NewPos + Vector2.new(42, 4)
            E.Line2Copy.To   = NewPos + Vector2.new(45, 12)

            E.Line3Copy.From = NewPos + Vector2.new(42, 4)
            E.Line3Copy.To   = NewPos + Vector2.new(38, 10)

            E.Line4.From = NewPos + Vector2.new(31, 25)
            E.Line4.To   = NewPos + Vector2.new(28, 31)

            E.Line4Copy.From = NewPos + Vector2.new(31, 26)
            E.Line4Copy.To   = NewPos + Vector2.new(34, 32)

            E.Line5.From = NewPos + Vector2.new(14, 26)
            E.Line5.To   = NewPos + Vector2.new(24, 28)

            E.Line5Copy.From = NewPos + Vector2.new(13, 32)
            E.Line5Copy.To   = NewPos + Vector2.new(24, 30)

            E.Line6.From = NewPos + Vector2.new(38, 28)
            E.Line6.To   = NewPos + Vector2.new(49, 25)

            E.Line6Copy.From = NewPos + Vector2.new(40, 30)
            E.Line6Copy.To   = NewPos + Vector2.new(51, 32)

            E.Button1Background.Position = NewPos + Vector2.new(3, 61)
            E.Button1Text.Position       = NewPos + Vector2.new(32, 72)

            E.Line1Copy2.From = NewPos + Vector2.new(0, 235)
            E.Line1Copy2.To   = NewPos + Vector2.new(63, 235)

            E.Button1CopyBackground.Position = NewPos + Vector2.new(7, 245)
            E.Button1CopyText.Position       = NewPos + Vector2.new(32, 256)

            E.Text2.Position = NewPos + Vector2.new(77, 59)

            E.Text3.Position = NewPos + Vector2.new(115, 14)

            E.Line1Copy3.From = NewPos + Vector2.new(71, 82)
            E.Line1Copy3.To   = NewPos + Vector2.new(324, 82)

            E.Button2Background.Position = NewPos + Vector2.new(300, 224)
            E.Button2Text.Position       = NewPos + Vector2.new(360, 233)

            E.Square3.Position = NewPos + Vector2.new(297, 101)

            E.Text4.Position = NewPos + Vector2.new(362, 128)

            E.Line1Copy4.From = NewPos + Vector2.new(309, 154)
            E.Line1Copy4.To   = NewPos + Vector2.new(413, 154)

            E.Text4Copy.Position = NewPos + Vector2.new(361, 110)

            E.Square1Copy.Position = NewPos + Vector2.new(0, 0)

            E.Text4Copy2.Position = NewPos + Vector2.new(362, 162)

            E.Text4Copy3.Position = NewPos + Vector2.new(362, 181)
        end

        if E.Square1Copy2DragActive then
            local NewPos: Vector2 = E.Square1Copy2DragStartPos + (Mouse - E.Square1Copy2DragStartMouse)
            E.Square1Copy2.Position = NewPos

            E.Line1Copy5.From = NewPos + Vector2.new(63, 1)
            E.Line1Copy5.To   = NewPos + Vector2.new(63, 284)

            E.Line1Copy6.From = NewPos + Vector2.new(1, 44)
            E.Line1Copy6.To   = NewPos + Vector2.new(272, 44)

            E.Text1Copy.Position = NewPos + Vector2.new(77, 15)

            E.Circle1Copy.Position = NewPos + Vector2.new(23, 17)

            E.Circle2Copy.Position = NewPos + Vector2.new(39, 17)

            E.Line2Copy2.From = NewPos + Vector2.new(19, 4)
            E.Line2Copy2.To   = NewPos + Vector2.new(16, 12)

            E.Line3Copy2.From = NewPos + Vector2.new(19, 4)
            E.Line3Copy2.To   = NewPos + Vector2.new(23, 10)

            E.Line2Copy3.From = NewPos + Vector2.new(42, 4)
            E.Line2Copy3.To   = NewPos + Vector2.new(46, 12)

            E.Line3Copy3.From = NewPos + Vector2.new(42, 3)
            E.Line3Copy3.To   = NewPos + Vector2.new(38, 10)

            E.Line4Copy2.From = NewPos + Vector2.new(31, 25)
            E.Line4Copy2.To   = NewPos + Vector2.new(28, 31)

            E.Line4Copy3.From = NewPos + Vector2.new(31, 26)
            E.Line4Copy3.To   = NewPos + Vector2.new(34, 32)

            E.Line5Copy2.From = NewPos + Vector2.new(14, 26)
            E.Line5Copy2.To   = NewPos + Vector2.new(24, 28)

            E.Line5Copy3.From = NewPos + Vector2.new(13, 32)
            E.Line5Copy3.To   = NewPos + Vector2.new(24, 30)

            E.Line6Copy2.From = NewPos + Vector2.new(38, 28)
            E.Line6Copy2.To   = NewPos + Vector2.new(49, 25)

            E.Line6Copy3.From = NewPos + Vector2.new(40, 30)
            E.Line6Copy3.To   = NewPos + Vector2.new(51, 32)

            E.Line1Copy7.From = NewPos + Vector2.new(0, 235)
            E.Line1Copy7.To   = NewPos + Vector2.new(63, 235)

            E.Text3Copy.Position = NewPos + Vector2.new(115, 14)

            E.Square1Copy3.Position = NewPos + Vector2.new(0, 0)

            E.Button1Copy3Background.Position = NewPos + Vector2.new(3, 60)
            E.Button1Copy3Text.Position       = NewPos + Vector2.new(32, 71)

            E.Text6.Position = NewPos + Vector2.new(81, 61)

            E.Line1Copy8.From = NewPos + Vector2.new(73, 81)
            E.Line1Copy8.To   = NewPos + Vector2.new(193, 81)

            E.Switch2Track.Position    = NewPos + Vector2.new(81, 100)
            E.Switch2Knob.Position     = NewPos + Vector2.new(if E.Switch2Enabled then 105 else 83, 102)
            E.Switch2Label.Position    = NewPos + Vector2.new(133, 103)

            E.Text6Copy.Position = NewPos + Vector2.new(77, 155)

            E.Line1Copy9.From = NewPos + Vector2.new(73, 176)
            E.Line1Copy9.To   = NewPos + Vector2.new(193, 176)

            E.Slider1Track.Position = NewPos + Vector2.new(77, 193)
            E.Slider1Fill.Position  = NewPos + Vector2.new(77, 193)
            E.Slider1Knob.Position  = NewPos + Vector2.new(77 + E.Slider1Fill.Size.X - 5, 193 - 2)
            E.Slider1Label.Position = NewPos + Vector2.new(160, 177)

            E.Text7.Position = NewPos + Vector2.new(67, 211)

            E.Text7Copy.Position = NewPos + Vector2.new(232, 211)
        end

        if E.Square1Copy4DragActive then
            local NewPos: Vector2 = E.Square1Copy4DragStartPos + (Mouse - E.Square1Copy4DragStartMouse)
            E.Square1Copy4.Position = NewPos

            E.Line1Copy10.From = NewPos + Vector2.new(63, 1)
            E.Line1Copy10.To   = NewPos + Vector2.new(63, 284)

            E.Line1Copy11.From = NewPos + Vector2.new(1, 44)
            E.Line1Copy11.To   = NewPos + Vector2.new(273, 44)

            E.Text1Copy2.Position = NewPos + Vector2.new(77, 15)

            E.Circle2Copy2.Position = NewPos + Vector2.new(39, 17)

            E.Circle1Copy2.Position = NewPos + Vector2.new(23, 17)

            E.Line2Copy4.From = NewPos + Vector2.new(19, 4)
            E.Line2Copy4.To   = NewPos + Vector2.new(16, 12)

            E.Line3Copy4.From = NewPos + Vector2.new(19, 4)
            E.Line3Copy4.To   = NewPos + Vector2.new(23, 10)

            E.Line2Copy5.From = NewPos + Vector2.new(42, 4)
            E.Line2Copy5.To   = NewPos + Vector2.new(46, 12)

            E.Line3Copy5.From = NewPos + Vector2.new(42, 3)
            E.Line3Copy5.To   = NewPos + Vector2.new(38, 10)

            E.Line4Copy4.From = NewPos + Vector2.new(31, 25)
            E.Line4Copy4.To   = NewPos + Vector2.new(28, 31)

            E.Line4Copy5.From = NewPos + Vector2.new(31, 26)
            E.Line4Copy5.To   = NewPos + Vector2.new(34, 32)

            E.Line5Copy4.From = NewPos + Vector2.new(14, 26)
            E.Line5Copy4.To   = NewPos + Vector2.new(24, 28)

            E.Line5Copy5.From = NewPos + Vector2.new(13, 32)
            E.Line5Copy5.To   = NewPos + Vector2.new(24, 30)

            E.Line6Copy4.From = NewPos + Vector2.new(38, 28)
            E.Line6Copy4.To   = NewPos + Vector2.new(49, 25)

            E.Line6Copy5.From = NewPos + Vector2.new(40, 30)
            E.Line6Copy5.To   = NewPos + Vector2.new(51, 32)

            E.Line1Copy12.From = NewPos + Vector2.new(0, 235)
            E.Line1Copy12.To   = NewPos + Vector2.new(63, 235)

            E.Text3Copy2.Position = NewPos + Vector2.new(115, 14)

            E.Square1Copy5.Position = NewPos + Vector2.new(0, 0)

            E.Button1Copy5Background.Position = NewPos + Vector2.new(3, 60)
            E.Button1Copy5Text.Position       = NewPos + Vector2.new(32, 71)

            E.Switch2CopyTrack.Position    = NewPos + Vector2.new(78, 99)
            E.Switch2CopyKnob.Position     = NewPos + Vector2.new(if E.Switch2CopyEnabled then 102 else 80, 101)
            E.Switch2CopyLabel.Position    = NewPos + Vector2.new(130, 102)

            E.Line1Copy13.From = NewPos + Vector2.new(70, 81)
            E.Line1Copy13.To   = NewPos + Vector2.new(190, 81)

            E.Text6Copy2.Position = NewPos + Vector2.new(78, 60)

            E.Text6Copy3.Position = NewPos + Vector2.new(74, 155)

            E.Line1Copy14.From = NewPos + Vector2.new(70, 176)
            E.Line1Copy14.To   = NewPos + Vector2.new(190, 176)

            E.Slider1CopyTrack.Position = NewPos + Vector2.new(74, 193)
            E.Slider1CopyFill.Position  = NewPos + Vector2.new(74, 193)
            E.Slider1CopyKnob.Position  = NewPos + Vector2.new(74 + E.Slider1CopyFill.Size.X - 5, 193 - 2)
            E.Slider1CopyLabel.Position = NewPos + Vector2.new(157, 177)

            E.Text7Copy2.Position = NewPos + Vector2.new(64, 211)

            E.Text7Copy3.Position = NewPos + Vector2.new(229, 211)

            E.Text8.Position = NewPos + Vector2.new(19, 250)

            E.Switch2Copy2Track.Position    = NewPos + Vector2.new(73, 250)
            E.Switch2Copy2Knob.Position     = NewPos + Vector2.new(if E.Switch2Copy2Enabled then 97 else 75, 252)
            E.Switch2Copy2Label.Position    = NewPos + Vector2.new(125, 253)

            E.Button1Copy2Background.Position = NewPos + Vector2.new(4, 111)
            E.Button1Copy2Text.Position       = NewPos + Vector2.new(33, 122)
        end

        if E.Square1Copy6DragActive then
            local NewPos: Vector2 = E.Square1Copy6DragStartPos + (Mouse - E.Square1Copy6DragStartMouse)
            E.Square1Copy6.Position = NewPos

            E.Line1Copy15.From = NewPos + Vector2.new(63, 1)
            E.Line1Copy15.To   = NewPos + Vector2.new(63, 284)

            E.Line1Copy16.From = NewPos + Vector2.new(1, 44)
            E.Line1Copy16.To   = NewPos + Vector2.new(273, 44)

            E.Text1Copy3.Position = NewPos + Vector2.new(77, 15)

            E.Circle1Copy3.Position = NewPos + Vector2.new(23, 17)

            E.Circle2Copy3.Position = NewPos + Vector2.new(39, 17)

            E.Line2Copy6.From = NewPos + Vector2.new(19, 4)
            E.Line2Copy6.To   = NewPos + Vector2.new(16, 12)

            E.Line3Copy6.From = NewPos + Vector2.new(19, 4)
            E.Line3Copy6.To   = NewPos + Vector2.new(23, 10)

            E.Line3Copy7.From = NewPos + Vector2.new(42, 3)
            E.Line3Copy7.To   = NewPos + Vector2.new(38, 10)

            E.Line2Copy7.From = NewPos + Vector2.new(42, 4)
            E.Line2Copy7.To   = NewPos + Vector2.new(46, 12)

            E.Line4Copy6.From = NewPos + Vector2.new(31, 25)
            E.Line4Copy6.To   = NewPos + Vector2.new(28, 31)

            E.Line4Copy7.From = NewPos + Vector2.new(31, 26)
            E.Line4Copy7.To   = NewPos + Vector2.new(34, 32)

            E.Line5Copy6.From = NewPos + Vector2.new(14, 26)
            E.Line5Copy6.To   = NewPos + Vector2.new(24, 28)

            E.Line5Copy7.From = NewPos + Vector2.new(13, 32)
            E.Line5Copy7.To   = NewPos + Vector2.new(24, 30)

            E.Line6Copy6.From = NewPos + Vector2.new(38, 28)
            E.Line6Copy6.To   = NewPos + Vector2.new(49, 25)

            E.Line6Copy7.From = NewPos + Vector2.new(40, 30)
            E.Line6Copy7.To   = NewPos + Vector2.new(51, 32)

            E.Line1Copy17.From = NewPos + Vector2.new(0, 235)
            E.Line1Copy17.To   = NewPos + Vector2.new(63, 235)

            E.Text3Copy3.Position = NewPos + Vector2.new(115, 14)

            E.Square1Copy7.Position = NewPos + Vector2.new(0, 0)

            E.Button1Copy4Background.Position = NewPos + Vector2.new(3, 111)
            E.Button1Copy4Text.Position       = NewPos + Vector2.new(32, 122)

            E.Button1Copy6Background.Position = NewPos + Vector2.new(3, 59)
            E.Button1Copy6Text.Position       = NewPos + Vector2.new(32, 70)

            E.Text8Copy2.Position = NewPos + Vector2.new(19, 250)

            E.Text9.Position = NewPos + Vector2.new(73, 59)

            E.Line1Copy18.From = NewPos + Vector2.new(68, 78)
            E.Line1Copy18.To   = NewPos + Vector2.new(188, 78)

            E.Dropdown2Background.Position = NewPos + Vector2.new(69, 86)
            E.Dropdown2Text.Position       = NewPos + Vector2.new(77, 93)
            E.Dropdown2Arrow.Position      = NewPos + Vector2.new(203, 93)
            E.Dropdown2OptionBackground0.Position = NewPos + Vector2.new(69, 116)
            E.Dropdown2OptionText0.Position       = NewPos + Vector2.new(77, 123)
            E.Dropdown2OptionBackground1.Position = NewPos + Vector2.new(69, 146)
            E.Dropdown2OptionText1.Position       = NewPos + Vector2.new(77, 153)
            E.Dropdown2OptionBackground2.Position = NewPos + Vector2.new(69, 176)
            E.Dropdown2OptionText2.Position       = NewPos + Vector2.new(77, 183)
            E.Dropdown2OptionBackground3.Position = NewPos + Vector2.new(69, 206)
            E.Dropdown2OptionText3.Position       = NewPos + Vector2.new(77, 213)
            E.Dropdown2OptionBackground4.Position = NewPos + Vector2.new(69, 236)
            E.Dropdown2OptionText4.Position       = NewPos + Vector2.new(77, 243)
            E.Dropdown2OptionBackground5.Position = NewPos + Vector2.new(69, 266)
            E.Dropdown2OptionText5.Position       = NewPos + Vector2.new(77, 273)
            E.Dropdown2OptionBackground6.Position = NewPos + Vector2.new(69, 296)
            E.Dropdown2OptionText6.Position       = NewPos + Vector2.new(77, 303)
            E.Dropdown2OptionBackground7.Position = NewPos + Vector2.new(69, 326)
            E.Dropdown2OptionText7.Position       = NewPos + Vector2.new(77, 333)
            E.Dropdown2OptionBackground8.Position = NewPos + Vector2.new(69, 356)
            E.Dropdown2OptionText8.Position       = NewPos + Vector2.new(77, 363)
            E.Dropdown2OptionBackground9.Position = NewPos + Vector2.new(69, 386)
            E.Dropdown2OptionText9.Position       = NewPos + Vector2.new(77, 393)
            E.Dropdown2OptionBackground10.Position = NewPos + Vector2.new(69, 416)
            E.Dropdown2OptionText10.Position       = NewPos + Vector2.new(77, 423)
            E.Dropdown2OptionBackground11.Position = NewPos + Vector2.new(69, 446)
            E.Dropdown2OptionText11.Position       = NewPos + Vector2.new(77, 453)
            E.Dropdown2OptionBackground12.Position = NewPos + Vector2.new(69, 476)
            E.Dropdown2OptionText12.Position       = NewPos + Vector2.new(77, 483)
            E.Dropdown2OptionBackground13.Position = NewPos + Vector2.new(69, 506)
            E.Dropdown2OptionText13.Position       = NewPos + Vector2.new(77, 513)
            E.Dropdown2OptionBackground14.Position = NewPos + Vector2.new(69, 536)
            E.Dropdown2OptionText14.Position       = NewPos + Vector2.new(77, 543)
            E.Dropdown2OptionBackground15.Position = NewPos + Vector2.new(69, 566)
            E.Dropdown2OptionText15.Position       = NewPos + Vector2.new(77, 573)
            E.Dropdown2OptionBackground16.Position = NewPos + Vector2.new(69, 596)
            E.Dropdown2OptionText16.Position       = NewPos + Vector2.new(77, 603)
            E.Dropdown2OptionBackground17.Position = NewPos + Vector2.new(69, 626)
            E.Dropdown2OptionText17.Position       = NewPos + Vector2.new(77, 633)
            E.Dropdown2OptionBackground18.Position = NewPos + Vector2.new(69, 656)
            E.Dropdown2OptionText18.Position       = NewPos + Vector2.new(77, 663)
            E.Dropdown2OptionBackground19.Position = NewPos + Vector2.new(69, 686)
            E.Dropdown2OptionText19.Position       = NewPos + Vector2.new(77, 693)

            E.Text9Copy.Position = NewPos + Vector2.new(72, 161)

            E.Line1Copy19.From = NewPos + Vector2.new(66, 182)
            E.Line1Copy19.To   = NewPos + Vector2.new(226, 182)

            E.Switch3Track.Position    = NewPos + Vector2.new(79, 129)
            E.Switch3Knob.Position     = NewPos + Vector2.new(if E.Switch3Enabled then 103 else 81, 131)
            E.Switch3Label.Position    = NewPos + Vector2.new(131, 132)

            E.Dropdown2CopyBackground.Position = NewPos + Vector2.new(73, 192)
            E.Dropdown2CopyText.Position       = NewPos + Vector2.new(81, 199)
            E.Dropdown2CopyArrow.Position      = NewPos + Vector2.new(207, 199)
            E.Dropdown2CopyOptionBackground0.Position = NewPos + Vector2.new(73, 222)
            E.Dropdown2CopyOptionText0.Position       = NewPos + Vector2.new(81, 229)
            E.Dropdown2CopyOptionBackground1.Position = NewPos + Vector2.new(73, 252)
            E.Dropdown2CopyOptionText1.Position       = NewPos + Vector2.new(81, 259)
            E.Dropdown2CopyOptionBackground2.Position = NewPos + Vector2.new(73, 282)
            E.Dropdown2CopyOptionText2.Position       = NewPos + Vector2.new(81, 289)
            E.Dropdown2CopyOptionBackground3.Position = NewPos + Vector2.new(73, 312)
            E.Dropdown2CopyOptionText3.Position       = NewPos + Vector2.new(81, 319)
            E.Dropdown2CopyOptionBackground4.Position = NewPos + Vector2.new(73, 342)
            E.Dropdown2CopyOptionText4.Position       = NewPos + Vector2.new(81, 349)
            E.Dropdown2CopyOptionBackground5.Position = NewPos + Vector2.new(73, 372)
            E.Dropdown2CopyOptionText5.Position       = NewPos + Vector2.new(81, 379)
            E.Dropdown2CopyOptionBackground6.Position = NewPos + Vector2.new(73, 402)
            E.Dropdown2CopyOptionText6.Position       = NewPos + Vector2.new(81, 409)
            E.Dropdown2CopyOptionBackground7.Position = NewPos + Vector2.new(73, 432)
            E.Dropdown2CopyOptionText7.Position       = NewPos + Vector2.new(81, 439)
            E.Dropdown2CopyOptionBackground8.Position = NewPos + Vector2.new(73, 462)
            E.Dropdown2CopyOptionText8.Position       = NewPos + Vector2.new(81, 469)
            E.Dropdown2CopyOptionBackground9.Position = NewPos + Vector2.new(73, 492)
            E.Dropdown2CopyOptionText9.Position       = NewPos + Vector2.new(81, 499)
            E.Dropdown2CopyOptionBackground10.Position = NewPos + Vector2.new(73, 522)
            E.Dropdown2CopyOptionText10.Position       = NewPos + Vector2.new(81, 529)
            E.Dropdown2CopyOptionBackground11.Position = NewPos + Vector2.new(73, 552)
            E.Dropdown2CopyOptionText11.Position       = NewPos + Vector2.new(81, 559)
            E.Dropdown2CopyOptionBackground12.Position = NewPos + Vector2.new(73, 582)
            E.Dropdown2CopyOptionText12.Position       = NewPos + Vector2.new(81, 589)
            E.Dropdown2CopyOptionBackground13.Position = NewPos + Vector2.new(73, 612)
            E.Dropdown2CopyOptionText13.Position       = NewPos + Vector2.new(81, 619)
            E.Dropdown2CopyOptionBackground14.Position = NewPos + Vector2.new(73, 642)
            E.Dropdown2CopyOptionText14.Position       = NewPos + Vector2.new(81, 649)
            E.Dropdown2CopyOptionBackground15.Position = NewPos + Vector2.new(73, 672)
            E.Dropdown2CopyOptionText15.Position       = NewPos + Vector2.new(81, 679)
            E.Dropdown2CopyOptionBackground16.Position = NewPos + Vector2.new(73, 702)
            E.Dropdown2CopyOptionText16.Position       = NewPos + Vector2.new(81, 709)
            E.Dropdown2CopyOptionBackground17.Position = NewPos + Vector2.new(73, 732)
            E.Dropdown2CopyOptionText17.Position       = NewPos + Vector2.new(81, 739)
            E.Dropdown2CopyOptionBackground18.Position = NewPos + Vector2.new(73, 762)
            E.Dropdown2CopyOptionText18.Position       = NewPos + Vector2.new(81, 769)
            E.Dropdown2CopyOptionBackground19.Position = NewPos + Vector2.new(73, 792)
            E.Dropdown2CopyOptionText19.Position       = NewPos + Vector2.new(81, 799)

            E.Switch3CopyTrack.Position    = NewPos + Vector2.new(76, 233)
            E.Switch3CopyKnob.Position     = NewPos + Vector2.new(if E.Switch3CopyEnabled then 100 else 78, 235)
            E.Switch3CopyLabel.Position    = NewPos + Vector2.new(128, 236)
        end

    end)
end
end)()
