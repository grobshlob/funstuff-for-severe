--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor
local MathClamp  = math.clamp
local MathRound  = math.round
local TableFind  = table.find

-- Cached Color3 constants for per-frame hover/toggle writes.
local _HC0: Color3 = Color3.fromRGB(103, 53, 126)
local _HC1: Color3 = Color3.fromRGB(204, 0, 139)
local _HC2: Color3 = Color3.fromRGB(77, 144, 255)
local _HC3: Color3 = Color3.fromRGB(106, 168, 255)
local _HC4: Color3 = Color3.fromRGB(255, 255, 255)
local _HC5: Color3 = Color3.fromRGB(194, 0, 78)
local _HC6: Color3 = Color3.fromRGB(255, 0, 0)

;(function(): ()

local E = {} -- holds all Drawing objects and widget state

-- DestroyUI infrastructure: every connection is tracked so it can be
-- disconnected, and every Drawing object is :Remove()d when triggered.
local _Destroyed: boolean = false
local _Conns: {RBXScriptConnection} = table.create(4)

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

E.Square1Copy = Drawing.new("Square")
E.Square6 = Drawing.new("Square")
E.Square6Copy = Drawing.new("Square")
E.Square6Copy2 = Drawing.new("Square")
E.Square6Copy3 = Drawing.new("Square")
E.Square1Copy7 = Drawing.new("Square")
E.Square1Copy8 = Drawing.new("Square")
E.Square1Copy12 = Drawing.new("Square")
E.Square1 = Drawing.new("Square")
E.Square1Copy2 = Drawing.new("Square")
E.Square1Copy3 = Drawing.new("Square")
E.Square1Copy9 = Drawing.new("Square")
E.Square1Copy14 = Drawing.new("Square")
E.Dropdown1Background = Drawing.new("Square")
E.Dropdown1Text       = Drawing.new("Text")
E.Dropdown1Arrow      = Drawing.new("Text")
E.Dropdown1Selected   = "Combat Warriors"
E.Dropdown1Options    = { "Combat Warriors", "Violence District", "Type Soul (OWNER ONLY)" }
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
E.Line1 = Drawing.new("Line")
E.Text1 = Drawing.new("Text")
E.Text1Copy = Drawing.new("Text")
E.Line4 = Drawing.new("Line")
E.Line5 = Drawing.new("Line")
E.Line6 = Drawing.new("Line")
E.Line7 = Drawing.new("Line")
E.Line8 = Drawing.new("Line")
E.Line8Copy = Drawing.new("Line")
E.Line9 = Drawing.new("Line")
E.Line9Copy = Drawing.new("Line")
E.Text2 = Drawing.new("Text")
E.Square2 = Drawing.new("Square")
E.Text3 = Drawing.new("Text")
E.Text3Copy = Drawing.new("Text")
E.Text3Copy2 = Drawing.new("Text")
E.Text3Copy3 = Drawing.new("Text")
E.Button1Background = Drawing.new("Square")
E.Button1Text       = Drawing.new("Text")
E.Button1Fired    = false
E.Line1Copy = Drawing.new("Line")
E.Circle1 = Drawing.new("Circle")
E.Text1Copy2 = Drawing.new("Text")
E.Text1Copy3 = Drawing.new("Text")
E.Line4Copy = Drawing.new("Line")
E.Line5Copy = Drawing.new("Line")
E.Line6Copy = Drawing.new("Line")
E.Line7Copy = Drawing.new("Line")
E.Line8Copy2 = Drawing.new("Line")
E.Line8Copy3 = Drawing.new("Line")
E.Line9Copy2 = Drawing.new("Line")
E.Line9Copy3 = Drawing.new("Line")
E.Line10 = Drawing.new("Line")
E.Line10Copy = Drawing.new("Line")
E.Line10Copy2 = Drawing.new("Line")
E.Line10Copy3 = Drawing.new("Line")
E.Text1Copy4 = Drawing.new("Text")
E.Text1Copy5 = Drawing.new("Text")
E.Line4Copy2 = Drawing.new("Line")
E.Line5Copy2 = Drawing.new("Line")
E.Line6Copy2 = Drawing.new("Line")
E.Line7Copy2 = Drawing.new("Line")
E.Line8Copy4 = Drawing.new("Line")
E.Line8Copy5 = Drawing.new("Line")
E.Line9Copy4 = Drawing.new("Line")
E.Line9Copy5 = Drawing.new("Line")
E.Text2Copy2 = Drawing.new("Text")
E.Line10Copy4 = Drawing.new("Line")
E.Line10Copy5 = Drawing.new("Line")
E.Checkbox1Background = Drawing.new("Square")
E.Checkbox1Fill       = Drawing.new("Square")
E.Checkbox1Label      = Drawing.new("Text")
E.Checkbox1Checked    = true
E.Checkbox1CopyBackground = Drawing.new("Square")
E.Checkbox1CopyFill       = Drawing.new("Square")
E.Checkbox1CopyLabel      = Drawing.new("Text")
E.Checkbox1CopyChecked    = true
E.Checkbox1Copy2Background = Drawing.new("Square")
E.Checkbox1Copy2Fill       = Drawing.new("Square")
E.Checkbox1Copy2Label      = Drawing.new("Text")
E.Checkbox1Copy2Checked    = true
E.Square1Copy5 = Drawing.new("Square")
E.Text7 = Drawing.new("Text")
E.Square1Copy6 = Drawing.new("Square")
E.Text7Copy = Drawing.new("Text")
E.Text1Copy6 = Drawing.new("Text")
E.Text1Copy7 = Drawing.new("Text")
E.Line4Copy3 = Drawing.new("Line")
E.Line5Copy3 = Drawing.new("Line")
E.Line6Copy3 = Drawing.new("Line")
E.Line7Copy3 = Drawing.new("Line")
E.Line8Copy6 = Drawing.new("Line")
E.Line8Copy7 = Drawing.new("Line")
E.Line9Copy6 = Drawing.new("Line")
E.Line9Copy7 = Drawing.new("Line")
E.Text2Copy3 = Drawing.new("Text")
E.Line10Copy6 = Drawing.new("Line")
E.Line10Copy7 = Drawing.new("Line")
E.Square1Copy10 = Drawing.new("Square")
E.Checkbox3Background = Drawing.new("Square")
E.Checkbox3Fill       = Drawing.new("Square")
E.Checkbox3Label      = Drawing.new("Text")
E.Checkbox3Checked    = false
E.Checkbox3CopyBackground = Drawing.new("Square")
E.Checkbox3CopyFill       = Drawing.new("Square")
E.Checkbox3CopyLabel      = Drawing.new("Text")
E.Checkbox3CopyChecked    = false
E.Checkbox3Copy2Background = Drawing.new("Square")
E.Checkbox3Copy2Fill       = Drawing.new("Square")
E.Checkbox3Copy2Label      = Drawing.new("Text")
E.Checkbox3Copy2Checked    = false
E.Checkbox4Background = Drawing.new("Square")
E.Checkbox4Fill       = Drawing.new("Square")
E.Checkbox4Label      = Drawing.new("Text")
E.Checkbox4Checked    = true
E.Text8 = Drawing.new("Text")
E.Square1Copy11 = Drawing.new("Square")
E.Text8Copy = Drawing.new("Text")
E.Checkbox5Background = Drawing.new("Square")
E.Checkbox5Fill       = Drawing.new("Square")
E.Checkbox5Label      = Drawing.new("Text")
E.Checkbox5Checked    = false
E.Button4Background = Drawing.new("Square")
E.Button4Text       = Drawing.new("Text")
E.Keybind1Background  = Drawing.new("Square")
E.Keybind1Text        = Drawing.new("Text")
E.Keybind1Key         = "F1"
E.Keybind1Waiting     = false
E.Keybind1WaitReady   = false
E.Keybind1DisplayText = "[F1]"
E.Square2Copy = Drawing.new("Square")
E.Text3Copy4 = Drawing.new("Text")
E.Checkbox1Copy3Background = Drawing.new("Square")
E.Checkbox1Copy3Fill       = Drawing.new("Square")
E.Checkbox1Copy3Label      = Drawing.new("Text")
E.Checkbox1Copy3Checked    = true
E.Text1Copy8 = Drawing.new("Text")
E.Text1Copy9 = Drawing.new("Text")
E.Line4Copy4 = Drawing.new("Line")
E.Line5Copy4 = Drawing.new("Line")
E.Line6Copy4 = Drawing.new("Line")
E.Line7Copy4 = Drawing.new("Line")
E.Line8Copy8 = Drawing.new("Line")
E.Line8Copy9 = Drawing.new("Line")
E.Line9Copy8 = Drawing.new("Line")
E.Line9Copy9 = Drawing.new("Line")
E.Line10Copy8 = Drawing.new("Line")
E.Line10Copy9 = Drawing.new("Line")
E.Text9 = Drawing.new("Text")
E.Slider1Track    = Drawing.new("Square")
E.Slider1Fill     = Drawing.new("Square")
E.Slider1Knob     = Drawing.new("Square")
E.Slider1Label    = Drawing.new("Text")
E.Slider1Value    = 1
E.Slider1Dragging = false
E.Slider1Fired    = false
E.Slider1_LabelPrev = 1
E.Text10 = Drawing.new("Text")
E.Text11 = Drawing.new("Text")
E.Text11Copy = Drawing.new("Text")
E.Checkbox6Background = Drawing.new("Square")
E.Checkbox6Fill       = Drawing.new("Square")
E.Checkbox6Label      = Drawing.new("Text")
E.Checkbox6Checked    = false
E.Checkbox1Copy4Background = Drawing.new("Square")
E.Checkbox1Copy4Fill       = Drawing.new("Square")
E.Checkbox1Copy4Label      = Drawing.new("Text")
E.Checkbox1Copy4Checked    = true
E.Checkbox1Copy5Background = Drawing.new("Square")
E.Checkbox1Copy5Fill       = Drawing.new("Square")
E.Checkbox1Copy5Label      = Drawing.new("Text")
E.Checkbox1Copy5Checked    = true
E.Circle1Copy = Drawing.new("Circle")
E.Circle1Copy6 = Drawing.new("Circle")
E.Circle1Copy2 = Drawing.new("Circle")
E.Circle1Copy3 = Drawing.new("Circle")
E.Circle1Copy4 = Drawing.new("Circle")
E.Circle1Copy5 = Drawing.new("Circle")
E.Circle1Copy7 = Drawing.new("Circle")
E.Circle1Copy8 = Drawing.new("Circle")
E.Circle1Copy9 = Drawing.new("Circle")
E.Square1Copy13 = Drawing.new("Square")
E.Line1Copy2 = Drawing.new("Line")
E.Line1Copy3 = Drawing.new("Line")
E.Line1Copy4 = Drawing.new("Line")
E.Line1Copy5 = Drawing.new("Line")
E.Line1Copy6 = Drawing.new("Line")
E.Line1Copy7 = Drawing.new("Line")
E.Line1Copy8 = Drawing.new("Line")
E.Line1Copy9 = Drawing.new("Line")
E.Line1Copy10 = Drawing.new("Line")
E.Line1Copy11 = Drawing.new("Line")
E.Button2Background = Drawing.new("Square")
E.Button2Text       = Drawing.new("Text")
E.Button2Fired    = false
E.Button2CopyBackground = Drawing.new("Square")
E.Button2CopyText       = Drawing.new("Text")
E.Button2CopyFired    = false
E.Button2Copy2Background = Drawing.new("Square")
E.Button2Copy2Text       = Drawing.new("Text")
E.Button2Copy2Fired    = false
E.Button2Copy3Background = Drawing.new("Square")
E.Button2Copy3Text       = Drawing.new("Text")
E.Button2Copy3Fired    = false

E.Square1CopyDragActive     = false
E.Square1CopyDragStartMouse = Vector2.new(0, 0)
E.Square1CopyDragStartPos   = Vector2.new(0, 0)
E.Square1DragActive     = false
E.Square1DragStartMouse = Vector2.new(0, 0)
E.Square1DragStartPos   = Vector2.new(0, 0)
E.Square1Copy2DragActive     = false
E.Square1Copy2DragStartMouse = Vector2.new(0, 0)
E.Square1Copy2DragStartPos   = Vector2.new(0, 0)
E.Square1Copy3DragActive     = false
E.Square1Copy3DragStartMouse = Vector2.new(0, 0)
E.Square1Copy3DragStartPos   = Vector2.new(0, 0)
E.Square1Copy9DragActive     = false
E.Square1Copy9DragStartMouse = Vector2.new(0, 0)
E.Square1Copy9DragStartPos   = Vector2.new(0, 0)
E.Square1Copy14DragActive     = false
E.Square1Copy14DragStartMouse = Vector2.new(0, 0)
E.Square1Copy14DragStartPos   = Vector2.new(0, 0)
@native local function _eOut(t: number): number local u: number = 1 - t return 1 - u * u * u end
E._UIAt = os.clock()      -- entrance clock (slide / fade)
E._slideDone = false

local UIVisible: boolean = true

local ActiveTab: number = 1

local function SetTab(n: number): ()
    ActiveTab = n
    -- Tab 1
    E.Square1Copy.Visible = UIVisible and n == 1 and true
    E.Square1.Visible = UIVisible and n == 1 and true
    E.Dropdown1Background.Visible = UIVisible and n == 1 and true
    E.Dropdown1Text.Visible       = UIVisible and n == 1 and true
    E.Dropdown1Arrow.Visible      = UIVisible and n == 1 and true
    E.Dropdown1OptionBackground0.Visible = UIVisible and n == 1 and E.Dropdown1Open
    E.Dropdown1OptionText0.Visible       = UIVisible and n == 1 and E.Dropdown1Open
    E.Dropdown1OptionBackground1.Visible = UIVisible and n == 1 and E.Dropdown1Open
    E.Dropdown1OptionText1.Visible       = UIVisible and n == 1 and E.Dropdown1Open
    E.Dropdown1OptionBackground2.Visible = UIVisible and n == 1 and E.Dropdown1Open
    E.Dropdown1OptionText2.Visible       = UIVisible and n == 1 and E.Dropdown1Open
    E.Line1.Visible = UIVisible and n == 1 and true
    E.Text1.Visible = UIVisible and n == 1 and true
    E.Text1Copy.Visible = UIVisible and n == 1 and true
    E.Line4.Visible = UIVisible and n == 1 and true
    E.Line5.Visible = UIVisible and n == 1 and true
    E.Line6.Visible = UIVisible and n == 1 and true
    E.Line7.Visible = UIVisible and n == 1 and true
    E.Line8.Visible = UIVisible and n == 1 and true
    E.Line8Copy.Visible = UIVisible and n == 1 and true
    E.Line9.Visible = UIVisible and n == 1 and true
    E.Line9Copy.Visible = UIVisible and n == 1 and true
    E.Text2.Visible = UIVisible and n == 1 and true
    E.Square2.Visible = UIVisible and n == 1 and true
    E.Text3.Visible = UIVisible and n == 1 and true
    E.Text3Copy.Visible = UIVisible and n == 1 and true
    E.Text3Copy2.Visible = UIVisible and n == 1 and true
    E.Text3Copy3.Visible = UIVisible and n == 1 and true
    E.Button1Background.Visible = UIVisible and n == 1 and true
    E.Button1Text.Visible       = UIVisible and n == 1 and true
    E.Line1Copy.Visible = UIVisible and n == 1 and true
    E.Circle1.Visible = UIVisible and n == 1 and true
    E.Line10Copy2.Visible = UIVisible and n == 1 and true
    E.Line10Copy3.Visible = UIVisible and n == 1 and true
    E.Button4Background.Visible = UIVisible and n == 1 and false
    E.Button4Text.Visible       = UIVisible and n == 1 and false
    E.Keybind1Background.Visible = UIVisible and n == 1 and true
    E.Keybind1Text.Visible       = UIVisible and n == 1 and true
    E.Square2Copy.Visible = UIVisible and n == 1 and true
    E.Text3Copy4.Visible = UIVisible and n == 1 and true
    E.Circle1Copy.Visible = UIVisible and n == 1 and true
    -- Tab 2
    E.Square6.Visible = UIVisible and n == 2 and true
    E.Square1Copy2.Visible = UIVisible and n == 2 and true
    E.Text1Copy2.Visible = UIVisible and n == 2 and true
    E.Text1Copy3.Visible = UIVisible and n == 2 and true
    E.Line4Copy.Visible = UIVisible and n == 2 and true
    E.Line5Copy.Visible = UIVisible and n == 2 and true
    E.Line6Copy.Visible = UIVisible and n == 2 and true
    E.Line7Copy.Visible = UIVisible and n == 2 and true
    E.Line8Copy2.Visible = UIVisible and n == 2 and true
    E.Line8Copy3.Visible = UIVisible and n == 2 and true
    E.Line9Copy2.Visible = UIVisible and n == 2 and true
    E.Line9Copy3.Visible = UIVisible and n == 2 and true
    E.Line10.Visible = UIVisible and n == 2 and true
    E.Line10Copy.Visible = UIVisible and n == 2 and true
    E.Slider1Track.Visible = UIVisible and n == 2 and true
    E.Slider1Fill.Visible  = UIVisible and n == 2 and true
    E.Slider1Knob.Visible  = UIVisible and n == 2 and true
    E.Slider1Label.Visible = UIVisible and n == 2 and true
    E.Text10.Visible = UIVisible and n == 2 and true
    E.Text11.Visible = UIVisible and n == 2 and true
    E.Text11Copy.Visible = UIVisible and n == 2 and true
    E.Checkbox6Background.Visible = UIVisible and n == 2 and true
    E.Checkbox6Label.Visible      = UIVisible and n == 2 and true
    E.Checkbox6Fill.Visible       = UIVisible and n == 2 and E.Checkbox6Checked
    E.Circle1Copy6.Visible = UIVisible and n == 2 and true
    E.Circle1Copy2.Visible = UIVisible and n == 2 and true
    E.Line1Copy2.Visible = UIVisible and n == 2 and true
    E.Line1Copy11.Visible = UIVisible and n == 2 and true
    E.Button2Background.Visible = UIVisible and n == 2 and false
    E.Button2Text.Visible       = UIVisible and n == 2 and false
    -- Tab 3
    E.Square6Copy.Visible = UIVisible and n == 3 and true
    E.Square1Copy7.Visible = UIVisible and n == 3 and true
    E.Square1Copy8.Visible = UIVisible and n == 3 and true
    E.Square1Copy3.Visible = UIVisible and n == 3 and true
    E.Text1Copy4.Visible = UIVisible and n == 3 and true
    E.Text1Copy5.Visible = UIVisible and n == 3 and true
    E.Line4Copy2.Visible = UIVisible and n == 3 and true
    E.Line5Copy2.Visible = UIVisible and n == 3 and true
    E.Line6Copy2.Visible = UIVisible and n == 3 and true
    E.Line7Copy2.Visible = UIVisible and n == 3 and true
    E.Line8Copy4.Visible = UIVisible and n == 3 and true
    E.Line8Copy5.Visible = UIVisible and n == 3 and true
    E.Line9Copy4.Visible = UIVisible and n == 3 and true
    E.Line9Copy5.Visible = UIVisible and n == 3 and true
    E.Text2Copy2.Visible = UIVisible and n == 3 and true
    E.Line10Copy4.Visible = UIVisible and n == 3 and true
    E.Line10Copy5.Visible = UIVisible and n == 3 and true
    E.Checkbox1Background.Visible = UIVisible and n == 3 and true
    E.Checkbox1Label.Visible      = UIVisible and n == 3 and true
    E.Checkbox1Fill.Visible       = UIVisible and n == 3 and E.Checkbox1Checked
    E.Checkbox1CopyBackground.Visible = UIVisible and n == 3 and true
    E.Checkbox1CopyLabel.Visible      = UIVisible and n == 3 and true
    E.Checkbox1CopyFill.Visible       = UIVisible and n == 3 and E.Checkbox1CopyChecked
    E.Checkbox1Copy2Background.Visible = UIVisible and n == 3 and true
    E.Checkbox1Copy2Label.Visible      = UIVisible and n == 3 and true
    E.Checkbox1Copy2Fill.Visible       = UIVisible and n == 3 and E.Checkbox1Copy2Checked
    E.Square1Copy5.Visible = UIVisible and n == 3 and true
    E.Text7.Visible = UIVisible and n == 3 and true
    E.Square1Copy6.Visible = UIVisible and n == 3 and true
    E.Text7Copy.Visible = UIVisible and n == 3 and true
    E.Checkbox1Copy3Background.Visible = UIVisible and n == 3 and true
    E.Checkbox1Copy3Label.Visible      = UIVisible and n == 3 and true
    E.Checkbox1Copy3Fill.Visible       = UIVisible and n == 3 and E.Checkbox1Copy3Checked
    E.Checkbox1Copy4Background.Visible = UIVisible and n == 3 and true
    E.Checkbox1Copy4Label.Visible      = UIVisible and n == 3 and true
    E.Checkbox1Copy4Fill.Visible       = UIVisible and n == 3 and E.Checkbox1Copy4Checked
    E.Checkbox1Copy5Background.Visible = UIVisible and n == 3 and true
    E.Checkbox1Copy5Label.Visible      = UIVisible and n == 3 and true
    E.Checkbox1Copy5Fill.Visible       = UIVisible and n == 3 and E.Checkbox1Copy5Checked
    E.Circle1Copy3.Visible = UIVisible and n == 3 and true
    E.Circle1Copy4.Visible = UIVisible and n == 3 and true
    E.Line1Copy3.Visible = UIVisible and n == 3 and true
    E.Line1Copy4.Visible = UIVisible and n == 3 and true
    E.Line1Copy5.Visible = UIVisible and n == 3 and true
    E.Button2CopyBackground.Visible = UIVisible and n == 3 and true
    E.Button2CopyText.Visible       = UIVisible and n == 3 and true
    -- Tab 4
    E.Square6Copy2.Visible = UIVisible and n == 4 and true
    E.Square6Copy3.Visible = UIVisible and n == 4 and true
    E.Square1Copy12.Visible = UIVisible and n == 4 and true
    E.Square1Copy9.Visible = UIVisible and n == 4 and true
    E.Square1Copy14.Visible = UIVisible and n == 4 and true
    E.Text1Copy6.Visible = UIVisible and n == 4 and true
    E.Text1Copy7.Visible = UIVisible and n == 4 and true
    E.Line4Copy3.Visible = UIVisible and n == 4 and true
    E.Line5Copy3.Visible = UIVisible and n == 4 and true
    E.Line6Copy3.Visible = UIVisible and n == 4 and true
    E.Line7Copy3.Visible = UIVisible and n == 4 and true
    E.Line8Copy6.Visible = UIVisible and n == 4 and true
    E.Line8Copy7.Visible = UIVisible and n == 4 and true
    E.Line9Copy6.Visible = UIVisible and n == 4 and true
    E.Line9Copy7.Visible = UIVisible and n == 4 and true
    E.Text2Copy3.Visible = UIVisible and n == 4 and true
    E.Line10Copy6.Visible = UIVisible and n == 4 and true
    E.Line10Copy7.Visible = UIVisible and n == 4 and true
    E.Square1Copy10.Visible = UIVisible and n == 4 and true
    E.Checkbox3Background.Visible = UIVisible and n == 4 and true
    E.Checkbox3Label.Visible      = UIVisible and n == 4 and true
    E.Checkbox3Fill.Visible       = UIVisible and n == 4 and E.Checkbox3Checked
    E.Checkbox3CopyBackground.Visible = UIVisible and n == 4 and true
    E.Checkbox3CopyLabel.Visible      = UIVisible and n == 4 and true
    E.Checkbox3CopyFill.Visible       = UIVisible and n == 4 and E.Checkbox3CopyChecked
    E.Checkbox3Copy2Background.Visible = UIVisible and n == 4 and true
    E.Checkbox3Copy2Label.Visible      = UIVisible and n == 4 and true
    E.Checkbox3Copy2Fill.Visible       = UIVisible and n == 4 and E.Checkbox3Copy2Checked
    E.Checkbox4Background.Visible = UIVisible and n == 4 and true
    E.Checkbox4Label.Visible      = UIVisible and n == 4 and true
    E.Checkbox4Fill.Visible       = UIVisible and n == 4 and E.Checkbox4Checked
    E.Text8.Visible = UIVisible and n == 4 and true
    E.Square1Copy11.Visible = UIVisible and n == 4 and true
    E.Text8Copy.Visible = UIVisible and n == 4 and true
    E.Checkbox5Background.Visible = UIVisible and n == 4 and true
    E.Checkbox5Label.Visible      = UIVisible and n == 4 and true
    E.Checkbox5Fill.Visible       = UIVisible and n == 4 and E.Checkbox5Checked
    E.Text1Copy8.Visible = UIVisible and n == 4 and true
    E.Text1Copy9.Visible = UIVisible and n == 4 and true
    E.Line4Copy4.Visible = UIVisible and n == 4 and true
    E.Line5Copy4.Visible = UIVisible and n == 4 and true
    E.Line6Copy4.Visible = UIVisible and n == 4 and true
    E.Line7Copy4.Visible = UIVisible and n == 4 and true
    E.Line8Copy8.Visible = UIVisible and n == 4 and true
    E.Line8Copy9.Visible = UIVisible and n == 4 and true
    E.Line9Copy8.Visible = UIVisible and n == 4 and true
    E.Line9Copy9.Visible = UIVisible and n == 4 and true
    E.Line10Copy8.Visible = UIVisible and n == 4 and true
    E.Line10Copy9.Visible = UIVisible and n == 4 and true
    E.Text9.Visible = UIVisible and n == 4 and true
    E.Circle1Copy5.Visible = UIVisible and n == 4 and true
    E.Circle1Copy7.Visible = UIVisible and n == 4 and true
    E.Circle1Copy8.Visible = UIVisible and n == 4 and true
    E.Circle1Copy9.Visible = UIVisible and n == 4 and true
    E.Square1Copy13.Visible = UIVisible and n == 4 and true
    E.Line1Copy6.Visible = UIVisible and n == 4 and true
    E.Line1Copy7.Visible = UIVisible and n == 4 and true
    E.Line1Copy8.Visible = UIVisible and n == 4 and true
    E.Line1Copy9.Visible = UIVisible and n == 4 and true
    E.Line1Copy10.Visible = UIVisible and n == 4 and true
    E.Button2Copy2Background.Visible = UIVisible and n == 4 and false
    E.Button2Copy2Text.Visible       = UIVisible and n == 4 and false
    E.Button2Copy3Background.Visible = UIVisible and n == 4 and false
    E.Button2Copy3Text.Visible       = UIVisible and n == 4 and false
end

do

    E.Square1Copy.Position  = Vector2.new(648, 338)
    E.Square1Copy.Size      = Vector2.new(549, 325)
    E.Square1Copy.Color     = Color3.fromRGB(44, 26, 81)
    E.Square1Copy.Opacity   = 0.34
    E.Square1Copy.Filled    = true
    E.Square1Copy.Thickness = 2
    E.Square1Copy.Rounding  = 33
    E.Square1Copy.ZIndex    = -670000000
    E.Square1Copy.Visible   = true

    E.Square6.Position  = Vector2.new(789, 459)
    E.Square6.Size      = Vector2.new(214, 227)
    E.Square6.Color     = Color3.fromRGB(44, 26, 81)
    E.Square6.Opacity   = 0.50
    E.Square6.Filled    = true
    E.Square6.Thickness = 1
    E.Square6.Rounding  = 33
    E.Square6.ZIndex    = -11
    E.Square6.Visible   = true

    E.Square6Copy.Position  = Vector2.new(804, 427)
    E.Square6Copy.Size      = Vector2.new(405, 236)
    E.Square6Copy.Color     = Color3.fromRGB(44, 26, 81)
    E.Square6Copy.Opacity   = 0.50
    E.Square6Copy.Filled    = true
    E.Square6Copy.Thickness = 1
    E.Square6Copy.Rounding  = 33
    E.Square6Copy.ZIndex    = -11
    E.Square6Copy.Visible   = true

    E.Square6Copy2.Position  = Vector2.new(185, 233)
    E.Square6Copy2.Size      = Vector2.new(405, 204)
    E.Square6Copy2.Color     = Color3.fromRGB(44, 26, 81)
    E.Square6Copy2.Opacity   = 0.50
    E.Square6Copy2.Filled    = true
    E.Square6Copy2.Thickness = 1
    E.Square6Copy2.Rounding  = 33
    E.Square6Copy2.ZIndex    = -11
    E.Square6Copy2.Visible   = true

    E.Square6Copy3.Position  = Vector2.new(829, 418)
    E.Square6Copy3.Size      = Vector2.new(327, 139)
    E.Square6Copy3.Color     = Color3.fromRGB(44, 26, 81)
    E.Square6Copy3.Opacity   = 0.50
    E.Square6Copy3.Filled    = true
    E.Square6Copy3.Thickness = 1
    E.Square6Copy3.Rounding  = 33
    E.Square6Copy3.ZIndex    = -11
    E.Square6Copy3.Visible   = true

    E.Square1Copy7.Position  = Vector2.new(823, 483)
    E.Square1Copy7.Size      = Vector2.new(177, 169)
    E.Square1Copy7.Color     = Color3.fromRGB(46, 0, 138)
    E.Square1Copy7.Opacity   = 0.36
    E.Square1Copy7.Filled    = true
    E.Square1Copy7.Thickness = 6
    E.Square1Copy7.Rounding  = 5
    E.Square1Copy7.ZIndex    = -10
    E.Square1Copy7.Visible   = true

    E.Square1Copy8.Position  = Vector2.new(1017, 484)
    E.Square1Copy8.Size      = Vector2.new(177, 104)
    E.Square1Copy8.Color     = Color3.fromRGB(46, 0, 138)
    E.Square1Copy8.Opacity   = 0.31
    E.Square1Copy8.Filled    = true
    E.Square1Copy8.Thickness = 6
    E.Square1Copy8.Rounding  = 5
    E.Square1Copy8.ZIndex    = -10
    E.Square1Copy8.Visible   = true

    E.Square1Copy12.Position  = Vector2.new(197, 289)
    E.Square1Copy12.Size      = Vector2.new(283, 134)
    E.Square1Copy12.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy12.Opacity   = 0.11
    E.Square1Copy12.Filled    = true
    E.Square1Copy12.Thickness = 3
    E.Square1Copy12.Rounding  = 10
    E.Square1Copy12.ZIndex    = -1
    E.Square1Copy12.Visible   = true

    E.Square1.Position  = Vector2.new(648, 338)
    E.Square1.Size      = Vector2.new(549, 325)
    E.Square1.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1.Opacity   = 1
    E.Square1.Filled    = false
    E.Square1.Thickness = 6
    E.Square1.Rounding  = 33
    E.Square1.ZIndex    = 0
    E.Square1.Visible   = true

    E.Square1Copy2.Position  = Vector2.new(789, 459)
    E.Square1Copy2.Size      = Vector2.new(214, 227)
    E.Square1Copy2.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy2.Opacity   = 1
    E.Square1Copy2.Filled    = false
    E.Square1Copy2.Thickness = 6
    E.Square1Copy2.Rounding  = 33
    E.Square1Copy2.ZIndex    = 0
    E.Square1Copy2.Visible   = true

    E.Square1Copy3.Position  = Vector2.new(804, 427)
    E.Square1Copy3.Size      = Vector2.new(407, 240)
    E.Square1Copy3.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy3.Opacity   = 1
    E.Square1Copy3.Filled    = false
    E.Square1Copy3.Thickness = 6
    E.Square1Copy3.Rounding  = 33
    E.Square1Copy3.ZIndex    = 0
    E.Square1Copy3.Visible   = true

    E.Square1Copy9.Position  = Vector2.new(185, 233)
    E.Square1Copy9.Size      = Vector2.new(407, 204)
    E.Square1Copy9.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy9.Opacity   = 1
    E.Square1Copy9.Filled    = false
    E.Square1Copy9.Thickness = 6
    E.Square1Copy9.Rounding  = 33
    E.Square1Copy9.ZIndex    = 0
    E.Square1Copy9.Visible   = true

    E.Square1Copy14.Position  = Vector2.new(829, 418)
    E.Square1Copy14.Size      = Vector2.new(330, 139)
    E.Square1Copy14.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy14.Opacity   = 1
    E.Square1Copy14.Filled    = false
    E.Square1Copy14.Thickness = 6
    E.Square1Copy14.Rounding  = 33
    E.Square1Copy14.ZIndex    = 0
    E.Square1Copy14.Visible   = true

    E.Dropdown1Background.Position  = Vector2.new(666, 417)
    E.Dropdown1Background.Size      = Vector2.new(212, 59)
    E.Dropdown1Background.Color     = Color3.fromRGB(69, 66, 87)
    E.Dropdown1Background.Filled    = true
    E.Dropdown1Background.Thickness = 1
    E.Dropdown1Background.Rounding  = 8
    E.Dropdown1Background.ZIndex    = 1
    E.Dropdown1Background.Visible   = true

    E.Dropdown1Text.Position  = Vector2.new(674, 437)
    E.Dropdown1Text.Text      = E.Dropdown1Selected
    E.Dropdown1Text.Size      = 19
    E.Dropdown1Text.Font      = 2
    E.Dropdown1Text.Color     = Color3.fromRGB(204, 0, 139)
    E.Dropdown1Text.Outline   = false
    E.Dropdown1Text.ZIndex    = 2
    E.Dropdown1Text.Visible   = true
    _FitText(E.Dropdown1Text, 183.52167077241995)

    E.Dropdown1Arrow.Position = Vector2.new(861, 437)
    E.Dropdown1Arrow.Text     = "▼"
    E.Dropdown1Arrow.Size     = 15
    E.Dropdown1Arrow.Font     = 2
    E.Dropdown1Arrow.Color    = Color3.fromRGB(204, 0, 139)
    E.Dropdown1Arrow.ZIndex   = 2
    E.Dropdown1Arrow.Visible  = true

    E.Dropdown1OptionBackground0.Position  = Vector2.new(666, 476)
    E.Dropdown1OptionBackground0.Size      = Vector2.new(212, 59)
    E.Dropdown1OptionBackground0.Color     = Color3.fromRGB(69, 66, 87)
    E.Dropdown1OptionBackground0.Filled    = true
    E.Dropdown1OptionBackground0.Rounding  = 8
    E.Dropdown1OptionBackground0.ZIndex    = 3
    E.Dropdown1OptionBackground0.Visible   = false

    E.Dropdown1OptionText0.Position  = Vector2.new(674, 496)
    E.Dropdown1OptionText0.Text      = "Combat Warriors"
    E.Dropdown1OptionText0.Size      = 19
    E.Dropdown1OptionText0.Font      = 2
    E.Dropdown1OptionText0.Color     = Color3.fromRGB(204, 0, 139)
    E.Dropdown1OptionText0.ZIndex    = 4
    E.Dropdown1OptionText0.Visible   = false
    _FitText(E.Dropdown1OptionText0, 195.52167077241995)

    E.Dropdown1OptionBackground1.Position  = Vector2.new(666, 535)
    E.Dropdown1OptionBackground1.Size      = Vector2.new(212, 59)
    E.Dropdown1OptionBackground1.Color     = Color3.fromRGB(69, 66, 87)
    E.Dropdown1OptionBackground1.Filled    = true
    E.Dropdown1OptionBackground1.Rounding  = 8
    E.Dropdown1OptionBackground1.ZIndex    = 3
    E.Dropdown1OptionBackground1.Visible   = false

    E.Dropdown1OptionText1.Position  = Vector2.new(674, 556)
    E.Dropdown1OptionText1.Text      = "Violence District"
    E.Dropdown1OptionText1.Size      = 19
    E.Dropdown1OptionText1.Font      = 2
    E.Dropdown1OptionText1.Color     = Color3.fromRGB(204, 0, 139)
    E.Dropdown1OptionText1.ZIndex    = 4
    E.Dropdown1OptionText1.Visible   = false
    _FitText(E.Dropdown1OptionText1, 195.52167077241995)

    E.Dropdown1OptionBackground2.Position  = Vector2.new(666, 595)
    E.Dropdown1OptionBackground2.Size      = Vector2.new(212, 59)
    E.Dropdown1OptionBackground2.Color     = Color3.fromRGB(69, 66, 87)
    E.Dropdown1OptionBackground2.Filled    = true
    E.Dropdown1OptionBackground2.Rounding  = 8
    E.Dropdown1OptionBackground2.ZIndex    = 3
    E.Dropdown1OptionBackground2.Visible   = false

    E.Dropdown1OptionText2.Position  = Vector2.new(674, 615)
    E.Dropdown1OptionText2.Text      = "Type Soul (OWNER ONLY)"
    E.Dropdown1OptionText2.Size      = 19
    E.Dropdown1OptionText2.Font      = 2
    E.Dropdown1OptionText2.Color     = Color3.fromRGB(204, 0, 139)
    E.Dropdown1OptionText2.ZIndex    = 4
    E.Dropdown1OptionText2.Visible   = false
    _FitText(E.Dropdown1OptionText2, 195.52167077241995)

    E.Line1.From      = Vector2.new(656, 393)
    E.Line1.To        = Vector2.new(1185, 393)
    E.Line1.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1.Opacity   = 0.36
    E.Line1.Thickness = 1
    E.Line1.ZIndex    = 1
    E.Line1.Visible   = true

    E.Text1.Position     = Vector2.new(719, 356)
    E.Text1.Text         = "BROG"
    E.Text1.Size         = 23
    E.Text1.Font         = 0
    E.Text1.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1.Opacity      = 1
    E.Text1.Center       = false
    E.Text1.Outline      = false
    E.Text1.ZIndex       = 1
    E.Text1.Visible      = true

    E.Text1Copy.Position     = Vector2.new(774, 355)
    E.Text1Copy.Text         = ":   HUB"
    E.Text1Copy.Size         = 23
    E.Text1Copy.Font         = 0
    E.Text1Copy.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy.Opacity      = 1
    E.Text1Copy.Center       = false
    E.Text1Copy.Outline      = false
    E.Text1Copy.ZIndex       = 1
    E.Text1Copy.Visible      = true

    E.Line4.From      = Vector2.new(670, 360)
    E.Line4.To        = Vector2.new(673, 352)
    E.Line4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4.Opacity   = 1
    E.Line4.Thickness = 1
    E.Line4.ZIndex    = 1
    E.Line4.Visible   = true

    E.Line5.From      = Vector2.new(673, 351)
    E.Line5.To        = Vector2.new(677, 358)
    E.Line5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5.Opacity   = 1
    E.Line5.Thickness = 1
    E.Line5.ZIndex    = 1
    E.Line5.Visible   = true

    E.Line6.From      = Vector2.new(689, 358)
    E.Line6.To        = Vector2.new(693, 351)
    E.Line6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6.Opacity   = 1
    E.Line6.Thickness = 1
    E.Line6.ZIndex    = 1
    E.Line6.Visible   = true

    E.Line7.From      = Vector2.new(693, 351)
    E.Line7.To        = Vector2.new(697, 360)
    E.Line7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7.Opacity   = 1
    E.Line7.Thickness = 1
    E.Line7.ZIndex    = 1
    E.Line7.Visible   = true

    E.Line8.From      = Vector2.new(665, 371)
    E.Line8.To        = Vector2.new(673, 373)
    E.Line8.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8.Opacity   = 1
    E.Line8.Thickness = 1
    E.Line8.ZIndex    = 1
    E.Line8.Visible   = true

    E.Line8Copy.From      = Vector2.new(664, 376)
    E.Line8Copy.To        = Vector2.new(674, 376)
    E.Line8Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy.Opacity   = 1
    E.Line8Copy.Thickness = 1
    E.Line8Copy.ZIndex    = 1
    E.Line8Copy.Visible   = true

    E.Line9.From      = Vector2.new(692, 376)
    E.Line9.To        = Vector2.new(701, 378)
    E.Line9.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9.Opacity   = 1
    E.Line9.Thickness = 1
    E.Line9.ZIndex    = 1
    E.Line9.Visible   = true

    E.Line9Copy.From      = Vector2.new(693, 374)
    E.Line9Copy.To        = Vector2.new(701, 372)
    E.Line9Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy.Opacity   = 1
    E.Line9Copy.Thickness = 1
    E.Line9Copy.ZIndex    = 1
    E.Line9Copy.Visible   = true

    E.Text2.Position     = Vector2.new(1074, 356)
    E.Text2.Text         = "Text"
    E.Text2.Size         = 19
    E.Text2.Font         = 0
    E.Text2.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2.Opacity      = 1
    E.Text2.Center       = false
    E.Text2.Outline      = false
    E.Text2.ZIndex       = 1
    E.Text2.Visible      = true

    E.Square2.Position  = Vector2.new(916, 417)
    E.Square2.Size      = Vector2.new(269, 145)
    E.Square2.Color     = Color3.fromRGB(235, 0, 215)
    E.Square2.Opacity   = 0.28
    E.Square2.Filled    = false
    E.Square2.Thickness = 5
    E.Square2.Rounding  = 20
    E.Square2.ZIndex    = 1
    E.Square2.Visible   = true

    E.Text3.Position     = Vector2.new(949, 435)
    E.Text3.Text         = "If you experience any bugs"
    E.Text3.Size         = 13
    E.Text3.Font         = 2
    E.Text3.Color        = Color3.fromRGB(92, 92, 92)
    E.Text3.Opacity      = 1
    E.Text3.Center       = false
    E.Text3.Outline      = false
    E.Text3.ZIndex       = 1
    E.Text3.Visible      = true

    E.Text3Copy.Position     = Vector2.new(904, 630)
    E.Text3Copy.Text         = "Toggle Key"
    E.Text3Copy.Size         = 13
    E.Text3Copy.Font         = 2
    E.Text3Copy.Color        = Color3.fromRGB(92, 92, 92)
    E.Text3Copy.Opacity      = 1
    E.Text3Copy.Center       = false
    E.Text3Copy.Outline      = false
    E.Text3Copy.ZIndex       = 1
    E.Text3Copy.Visible      = true

    E.Text3Copy2.Position     = Vector2.new(949, 504)
    E.Text3Copy2.Text         = "IF YOU LOAD TYPE SOUL"
    E.Text3Copy2.Size         = 16
    E.Text3Copy2.Font         = 2
    E.Text3Copy2.Color        = Color3.fromRGB(92, 92, 92)
    E.Text3Copy2.Opacity      = 1
    E.Text3Copy2.Center       = false
    E.Text3Copy2.Outline      = false
    E.Text3Copy2.ZIndex       = 1
    E.Text3Copy2.Visible      = true

    E.Text3Copy3.Position     = Vector2.new(945, 532)
    E.Text3Copy3.Text         = "YOUR ROBLOX WILL CRASH"
    E.Text3Copy3.Size         = 16
    E.Text3Copy3.Font         = 2
    E.Text3Copy3.Color        = Color3.fromRGB(92, 92, 92)
    E.Text3Copy3.Opacity      = 1
    E.Text3Copy3.Center       = false
    E.Text3Copy3.Outline      = false
    E.Text3Copy3.ZIndex       = 1
    E.Text3Copy3.Visible      = true

    E.Button1Background.Position  = Vector2.new(957, 573)
    E.Button1Background.Size      = Vector2.new(184, 39)
    E.Button1Background.Color     = Color3.fromRGB(103, 53, 126)
    E.Button1Background.Filled    = true
    E.Button1Background.Thickness = 1
    E.Button1Background.Rounding  = 4
    E.Button1Background.ZIndex    = 1
    E.Button1Background.Visible   = true

    E.Button1Text.Position     = Vector2.new(1049, 585)
    E.Button1Text.Text         = "LOAD"
    E.Button1Text.Size         = 16
    E.Button1Text.Font         = 2
    E.Button1Text.Color        = Color3.fromRGB(204, 0, 139)
    E.Button1Text.Center       = true
    E.Button1Text.Outline      = false
    E.Button1Text.ZIndex       = 2
    E.Button1Text.Visible      = true
    _FitText(E.Button1Text, 175.6340733710631)

    E.Line1Copy.From      = Vector2.new(965, 490)
    E.Line1Copy.To        = Vector2.new(1141, 490)
    E.Line1Copy.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy.Opacity   = 0.36
    E.Line1Copy.Thickness = 1
    E.Line1Copy.ZIndex    = 1
    E.Line1Copy.Visible   = true

    E.Circle1.Position  = Vector2.new(678, 365)
    E.Circle1.Radius    = 3.675981117494274
    E.Circle1.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1.Opacity   = 1
    E.Circle1.Filled    = false
    E.Circle1.Thickness = 1
    E.Circle1.NumSides  = 64
    E.Circle1.ZIndex    = 1
    E.Circle1.Visible   = true

    E.Text1Copy2.Position     = Vector2.new(876, 474)
    E.Text1Copy2.Text         = "BROG"
    E.Text1Copy2.Size         = 26
    E.Text1Copy2.Font         = 3
    E.Text1Copy2.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy2.Opacity      = 1
    E.Text1Copy2.Center       = false
    E.Text1Copy2.Outline      = false
    E.Text1Copy2.ZIndex       = 1
    E.Text1Copy2.Visible      = true

    E.Text1Copy3.Position     = Vector2.new(842, 653)
    E.Text1Copy3.Text         = "Combat Warriors"
    E.Text1Copy3.Size         = 17
    E.Text1Copy3.Font         = 0
    E.Text1Copy3.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy3.Opacity      = 1
    E.Text1Copy3.Center       = false
    E.Text1Copy3.Outline      = false
    E.Text1Copy3.ZIndex       = 1
    E.Text1Copy3.Visible      = true

    E.Line4Copy.From      = Vector2.new(811, 480)
    E.Line4Copy.To        = Vector2.new(815, 472)
    E.Line4Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy.Opacity   = 1
    E.Line4Copy.Thickness = 1
    E.Line4Copy.ZIndex    = 1
    E.Line4Copy.Visible   = true

    E.Line5Copy.From      = Vector2.new(815, 472)
    E.Line5Copy.To        = Vector2.new(819, 479)
    E.Line5Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy.Opacity   = 1
    E.Line5Copy.Thickness = 1
    E.Line5Copy.ZIndex    = 1
    E.Line5Copy.Visible   = true

    E.Line6Copy.From      = Vector2.new(831, 479)
    E.Line6Copy.To        = Vector2.new(835, 472)
    E.Line6Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy.Opacity   = 1
    E.Line6Copy.Thickness = 1
    E.Line6Copy.ZIndex    = 1
    E.Line6Copy.Visible   = true

    E.Line7Copy.From      = Vector2.new(835, 472)
    E.Line7Copy.To        = Vector2.new(839, 481)
    E.Line7Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7Copy.Opacity   = 1
    E.Line7Copy.Thickness = 1
    E.Line7Copy.ZIndex    = 1
    E.Line7Copy.Visible   = true

    E.Line8Copy2.From      = Vector2.new(807, 492)
    E.Line8Copy2.To        = Vector2.new(815, 494)
    E.Line8Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy2.Opacity   = 1
    E.Line8Copy2.Thickness = 1
    E.Line8Copy2.ZIndex    = 1
    E.Line8Copy2.Visible   = true

    E.Line8Copy3.From      = Vector2.new(806, 497)
    E.Line8Copy3.To        = Vector2.new(816, 497)
    E.Line8Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy3.Opacity   = 1
    E.Line8Copy3.Thickness = 1
    E.Line8Copy3.ZIndex    = 1
    E.Line8Copy3.Visible   = true

    E.Line9Copy2.From      = Vector2.new(834, 497)
    E.Line9Copy2.To        = Vector2.new(843, 499)
    E.Line9Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy2.Opacity   = 1
    E.Line9Copy2.Thickness = 1
    E.Line9Copy2.ZIndex    = 1
    E.Line9Copy2.Visible   = true

    E.Line9Copy3.From      = Vector2.new(835, 495)
    E.Line9Copy3.To        = Vector2.new(843, 493)
    E.Line9Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy3.Opacity   = 1
    E.Line9Copy3.Thickness = 1
    E.Line9Copy3.ZIndex    = 1
    E.Line9Copy3.Visible   = true

    E.Line10.From      = Vector2.new(825, 493)
    E.Line10.To        = Vector2.new(823, 497)
    E.Line10.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10.Opacity   = 1
    E.Line10.Thickness = 1
    E.Line10.ZIndex    = 1
    E.Line10.Visible   = true

    E.Line10Copy.From      = Vector2.new(825, 493)
    E.Line10Copy.To        = Vector2.new(828, 498)
    E.Line10Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy.Opacity   = 1
    E.Line10Copy.Thickness = 1
    E.Line10Copy.ZIndex    = 1
    E.Line10Copy.Visible   = true

    E.Line10Copy2.From      = Vector2.new(683, 370)
    E.Line10Copy2.To        = Vector2.new(686, 375)
    E.Line10Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy2.Opacity   = 1
    E.Line10Copy2.Thickness = 1
    E.Line10Copy2.ZIndex    = 1
    E.Line10Copy2.Visible   = true

    E.Line10Copy3.From      = Vector2.new(683, 370)
    E.Line10Copy3.To        = Vector2.new(681, 374)
    E.Line10Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy3.Opacity   = 1
    E.Line10Copy3.Thickness = 1
    E.Line10Copy3.ZIndex    = 1
    E.Line10Copy3.Visible   = true

    E.Text1Copy4.Position     = Vector2.new(875, 443)
    E.Text1Copy4.Text         = "BROG"
    E.Text1Copy4.Size         = 23
    E.Text1Copy4.Font         = 0
    E.Text1Copy4.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy4.Opacity      = 1
    E.Text1Copy4.Center       = false
    E.Text1Copy4.Outline      = false
    E.Text1Copy4.ZIndex       = 1
    E.Text1Copy4.Visible      = true

    E.Text1Copy5.Position     = Vector2.new(929, 444)
    E.Text1Copy5.Text         = ":   Violence District"
    E.Text1Copy5.Size         = 17
    E.Text1Copy5.Font         = 0
    E.Text1Copy5.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy5.Opacity      = 1
    E.Text1Copy5.Center       = false
    E.Text1Copy5.Outline      = false
    E.Text1Copy5.ZIndex       = 1
    E.Text1Copy5.Visible      = true

    E.Line4Copy2.From      = Vector2.new(826, 448)
    E.Line4Copy2.To        = Vector2.new(830, 440)
    E.Line4Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy2.Opacity   = 1
    E.Line4Copy2.Thickness = 1
    E.Line4Copy2.ZIndex    = 1
    E.Line4Copy2.Visible   = true

    E.Line5Copy2.From      = Vector2.new(830, 440)
    E.Line5Copy2.To        = Vector2.new(834, 447)
    E.Line5Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy2.Opacity   = 1
    E.Line5Copy2.Thickness = 1
    E.Line5Copy2.ZIndex    = 1
    E.Line5Copy2.Visible   = true

    E.Line6Copy2.From      = Vector2.new(846, 447)
    E.Line6Copy2.To        = Vector2.new(850, 440)
    E.Line6Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy2.Opacity   = 1
    E.Line6Copy2.Thickness = 1
    E.Line6Copy2.ZIndex    = 1
    E.Line6Copy2.Visible   = true

    E.Line7Copy2.From      = Vector2.new(850, 440)
    E.Line7Copy2.To        = Vector2.new(853, 449)
    E.Line7Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7Copy2.Opacity   = 1
    E.Line7Copy2.Thickness = 1
    E.Line7Copy2.ZIndex    = 1
    E.Line7Copy2.Visible   = true

    E.Line8Copy4.From      = Vector2.new(822, 460)
    E.Line8Copy4.To        = Vector2.new(830, 462)
    E.Line8Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy4.Opacity   = 1
    E.Line8Copy4.Thickness = 1
    E.Line8Copy4.ZIndex    = 1
    E.Line8Copy4.Visible   = true

    E.Line8Copy5.From      = Vector2.new(821, 465)
    E.Line8Copy5.To        = Vector2.new(831, 465)
    E.Line8Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy5.Opacity   = 1
    E.Line8Copy5.Thickness = 1
    E.Line8Copy5.ZIndex    = 1
    E.Line8Copy5.Visible   = true

    E.Line9Copy4.From      = Vector2.new(849, 465)
    E.Line9Copy4.To        = Vector2.new(858, 467)
    E.Line9Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy4.Opacity   = 1
    E.Line9Copy4.Thickness = 1
    E.Line9Copy4.ZIndex    = 1
    E.Line9Copy4.Visible   = true

    E.Line9Copy5.From      = Vector2.new(850, 463)
    E.Line9Copy5.To        = Vector2.new(858, 461)
    E.Line9Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy5.Opacity   = 1
    E.Line9Copy5.Thickness = 1
    E.Line9Copy5.ZIndex    = 1
    E.Line9Copy5.Visible   = true

    E.Text2Copy2.Position     = Vector2.new(1145, 445)
    E.Text2Copy2.Text         = "Text"
    E.Text2Copy2.Size         = 17
    E.Text2Copy2.Font         = 0
    E.Text2Copy2.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2Copy2.Opacity      = 1
    E.Text2Copy2.Center       = false
    E.Text2Copy2.Outline      = false
    E.Text2Copy2.ZIndex       = 1
    E.Text2Copy2.Visible      = true

    E.Line10Copy4.From      = Vector2.new(840, 461)
    E.Line10Copy4.To        = Vector2.new(838, 465)
    E.Line10Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy4.Opacity   = 1
    E.Line10Copy4.Thickness = 1
    E.Line10Copy4.ZIndex    = 1
    E.Line10Copy4.Visible   = true

    E.Line10Copy5.From      = Vector2.new(840, 461)
    E.Line10Copy5.To        = Vector2.new(843, 466)
    E.Line10Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy5.Opacity   = 1
    E.Line10Copy5.Thickness = 1
    E.Line10Copy5.ZIndex    = 1
    E.Line10Copy5.Visible   = true

    E.Checkbox1Background.Position  = Vector2.new(828, 518)
    E.Checkbox1Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Background.Filled    = true
    E.Checkbox1Background.Thickness = 1
    E.Checkbox1Background.ZIndex    = 1
    E.Checkbox1Background.Visible   = true

    E.Checkbox1Fill.Position  = Vector2.new(831, 521)
    E.Checkbox1Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Fill.Filled    = true
    E.Checkbox1Fill.ZIndex    = 2
    E.Checkbox1Fill.Visible   = true

    E.Checkbox1Label.Position     = Vector2.new(860, 522)
    E.Checkbox1Label.Text         = "Generator ESP"
    E.Checkbox1Label.Size         = 16
    E.Checkbox1Label.Font         = 2
    E.Checkbox1Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Label.Outline      = true
    E.Checkbox1Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Label.ZIndex       = 2
    E.Checkbox1Label.Visible      = true

    E.Checkbox1CopyBackground.Position  = Vector2.new(828, 554)
    E.Checkbox1CopyBackground.Size      = Vector2.new(26, 24)
    E.Checkbox1CopyBackground.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1CopyBackground.Filled    = true
    E.Checkbox1CopyBackground.Thickness = 1
    E.Checkbox1CopyBackground.ZIndex    = 1
    E.Checkbox1CopyBackground.Visible   = true

    E.Checkbox1CopyFill.Position  = Vector2.new(831, 557)
    E.Checkbox1CopyFill.Size      = Vector2.new(20, 18)
    E.Checkbox1CopyFill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1CopyFill.Filled    = true
    E.Checkbox1CopyFill.ZIndex    = 2
    E.Checkbox1CopyFill.Visible   = true

    E.Checkbox1CopyLabel.Position     = Vector2.new(860, 559)
    E.Checkbox1CopyLabel.Text         = "Killer ESP"
    E.Checkbox1CopyLabel.Size         = 16
    E.Checkbox1CopyLabel.Font         = 2
    E.Checkbox1CopyLabel.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1CopyLabel.Outline      = true
    E.Checkbox1CopyLabel.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1CopyLabel.ZIndex       = 2
    E.Checkbox1CopyLabel.Visible      = true

    E.Checkbox1Copy2Background.Position  = Vector2.new(1025, 519)
    E.Checkbox1Copy2Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Copy2Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Copy2Background.Filled    = true
    E.Checkbox1Copy2Background.Thickness = 1
    E.Checkbox1Copy2Background.ZIndex    = 1
    E.Checkbox1Copy2Background.Visible   = true

    E.Checkbox1Copy2Fill.Position  = Vector2.new(1028, 522)
    E.Checkbox1Copy2Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Copy2Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Copy2Fill.Filled    = true
    E.Checkbox1Copy2Fill.ZIndex    = 2
    E.Checkbox1Copy2Fill.Visible   = true

    E.Checkbox1Copy2Label.Position     = Vector2.new(1057, 523)
    E.Checkbox1Copy2Label.Text         = "Auto Parry"
    E.Checkbox1Copy2Label.Size         = 16
    E.Checkbox1Copy2Label.Font         = 2
    E.Checkbox1Copy2Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy2Label.Outline      = true
    E.Checkbox1Copy2Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Copy2Label.ZIndex       = 2
    E.Checkbox1Copy2Label.Visible      = true

    E.Square1Copy5.Position  = Vector2.new(823, 483)
    E.Square1Copy5.Size      = Vector2.new(177, 170)
    E.Square1Copy5.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy5.Opacity   = 1
    E.Square1Copy5.Filled    = false
    E.Square1Copy5.Thickness = 6
    E.Square1Copy5.Rounding  = 5
    E.Square1Copy5.ZIndex    = 1
    E.Square1Copy5.Visible   = true

    E.Text7.Position     = Vector2.new(830, 496)
    E.Text7.Text         = "ESP"
    E.Text7.Size         = 16
    E.Text7.Font         = 0
    E.Text7.Color        = Color3.fromRGB(204, 0, 139)
    E.Text7.Opacity      = 1
    E.Text7.Center       = false
    E.Text7.Outline      = false
    E.Text7.ZIndex       = 1
    E.Text7.Visible      = true

    E.Square1Copy6.Position  = Vector2.new(1017, 484)
    E.Square1Copy6.Size      = Vector2.new(177, 104)
    E.Square1Copy6.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy6.Opacity   = 1
    E.Square1Copy6.Filled    = false
    E.Square1Copy6.Thickness = 6
    E.Square1Copy6.Rounding  = 5
    E.Square1Copy6.ZIndex    = 1
    E.Square1Copy6.Visible   = true

    E.Text7Copy.Position     = Vector2.new(1023, 496)
    E.Text7Copy.Text         = "Automation"
    E.Text7Copy.Size         = 16
    E.Text7Copy.Font         = 0
    E.Text7Copy.Color        = Color3.fromRGB(204, 0, 139)
    E.Text7Copy.Opacity      = 1
    E.Text7Copy.Center       = false
    E.Text7Copy.Outline      = false
    E.Text7Copy.ZIndex       = 1
    E.Text7Copy.Visible      = true

    E.Text1Copy6.Position     = Vector2.new(256, 249)
    E.Text1Copy6.Text         = "BROG"
    E.Text1Copy6.Size         = 23
    E.Text1Copy6.Font         = 0
    E.Text1Copy6.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy6.Opacity      = 1
    E.Text1Copy6.Center       = false
    E.Text1Copy6.Outline      = false
    E.Text1Copy6.ZIndex       = 1
    E.Text1Copy6.Visible      = true

    E.Text1Copy7.Position     = Vector2.new(310, 250)
    E.Text1Copy7.Text         = ":   Bridger Western"
    E.Text1Copy7.Size         = 17
    E.Text1Copy7.Font         = 0
    E.Text1Copy7.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy7.Opacity      = 1
    E.Text1Copy7.Center       = false
    E.Text1Copy7.Outline      = false
    E.Text1Copy7.ZIndex       = 1
    E.Text1Copy7.Visible      = true

    E.Line4Copy3.From      = Vector2.new(207, 254)
    E.Line4Copy3.To        = Vector2.new(211, 246)
    E.Line4Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy3.Opacity   = 1
    E.Line4Copy3.Thickness = 1
    E.Line4Copy3.ZIndex    = 1
    E.Line4Copy3.Visible   = true

    E.Line5Copy3.From      = Vector2.new(211, 246)
    E.Line5Copy3.To        = Vector2.new(215, 253)
    E.Line5Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy3.Opacity   = 1
    E.Line5Copy3.Thickness = 1
    E.Line5Copy3.ZIndex    = 1
    E.Line5Copy3.Visible   = true

    E.Line6Copy3.From      = Vector2.new(227, 253)
    E.Line6Copy3.To        = Vector2.new(231, 246)
    E.Line6Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy3.Opacity   = 1
    E.Line6Copy3.Thickness = 1
    E.Line6Copy3.ZIndex    = 1
    E.Line6Copy3.Visible   = true

    E.Line7Copy3.From      = Vector2.new(231, 246)
    E.Line7Copy3.To        = Vector2.new(234, 255)
    E.Line7Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7Copy3.Opacity   = 1
    E.Line7Copy3.Thickness = 1
    E.Line7Copy3.ZIndex    = 1
    E.Line7Copy3.Visible   = true

    E.Line8Copy6.From      = Vector2.new(203, 266)
    E.Line8Copy6.To        = Vector2.new(211, 268)
    E.Line8Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy6.Opacity   = 1
    E.Line8Copy6.Thickness = 1
    E.Line8Copy6.ZIndex    = 1
    E.Line8Copy6.Visible   = true

    E.Line8Copy7.From      = Vector2.new(202, 271)
    E.Line8Copy7.To        = Vector2.new(212, 271)
    E.Line8Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy7.Opacity   = 1
    E.Line8Copy7.Thickness = 1
    E.Line8Copy7.ZIndex    = 1
    E.Line8Copy7.Visible   = true

    E.Line9Copy6.From      = Vector2.new(231, 269)
    E.Line9Copy6.To        = Vector2.new(239, 267)
    E.Line9Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy6.Opacity   = 1
    E.Line9Copy6.Thickness = 1
    E.Line9Copy6.ZIndex    = 1
    E.Line9Copy6.Visible   = true

    E.Line9Copy7.From      = Vector2.new(230, 271)
    E.Line9Copy7.To        = Vector2.new(239, 273)
    E.Line9Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy7.Opacity   = 1
    E.Line9Copy7.Thickness = 1
    E.Line9Copy7.ZIndex    = 1
    E.Line9Copy7.Visible   = true

    E.Text2Copy3.Position     = Vector2.new(525, 251)
    E.Text2Copy3.Text         = "Text"
    E.Text2Copy3.Size         = 16
    E.Text2Copy3.Font         = 0
    E.Text2Copy3.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2Copy3.Opacity      = 1
    E.Text2Copy3.Center       = false
    E.Text2Copy3.Outline      = false
    E.Text2Copy3.ZIndex       = 1
    E.Text2Copy3.Visible      = true

    E.Line10Copy6.From      = Vector2.new(221, 267)
    E.Line10Copy6.To        = Vector2.new(219, 271)
    E.Line10Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy6.Opacity   = 1
    E.Line10Copy6.Thickness = 1
    E.Line10Copy6.ZIndex    = 1
    E.Line10Copy6.Visible   = true

    E.Line10Copy7.From      = Vector2.new(221, 267)
    E.Line10Copy7.To        = Vector2.new(224, 272)
    E.Line10Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy7.Opacity   = 1
    E.Line10Copy7.Thickness = 1
    E.Line10Copy7.ZIndex    = 1
    E.Line10Copy7.Visible   = true

    E.Square1Copy10.Position  = Vector2.new(197, 289)
    E.Square1Copy10.Size      = Vector2.new(283, 134)
    E.Square1Copy10.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy10.Opacity   = 1
    E.Square1Copy10.Filled    = false
    E.Square1Copy10.Thickness = 3
    E.Square1Copy10.Rounding  = 10
    E.Square1Copy10.ZIndex    = 1
    E.Square1Copy10.Visible   = true

    E.Checkbox3Background.Position  = Vector2.new(219, 342)
    E.Checkbox3Background.Size      = Vector2.new(20, 20)
    E.Checkbox3Background.Color     = Color3.fromRGB(204, 0, 139)
    E.Checkbox3Background.Filled    = true
    E.Checkbox3Background.Thickness = 1
    E.Checkbox3Background.ZIndex    = 1
    E.Checkbox3Background.Visible   = true

    E.Checkbox3Fill.Position  = Vector2.new(222, 345)
    E.Checkbox3Fill.Size      = Vector2.new(14, 14)
    E.Checkbox3Fill.Color     = Color3.fromRGB(255, 0, 174)
    E.Checkbox3Fill.Filled    = true
    E.Checkbox3Fill.ZIndex    = 2
    E.Checkbox3Fill.Visible   = false

    E.Checkbox3Label.Position     = Vector2.new(245, 344)
    E.Checkbox3Label.Text         = "Auto Fish"
    E.Checkbox3Label.Size         = 16
    E.Checkbox3Label.Font         = 2
    E.Checkbox3Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox3Label.Outline      = true
    E.Checkbox3Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox3Label.ZIndex       = 2
    E.Checkbox3Label.Visible      = true

    E.Checkbox3CopyBackground.Position  = Vector2.new(219, 366)
    E.Checkbox3CopyBackground.Size      = Vector2.new(20, 20)
    E.Checkbox3CopyBackground.Color     = Color3.fromRGB(204, 0, 139)
    E.Checkbox3CopyBackground.Filled    = true
    E.Checkbox3CopyBackground.Thickness = 1
    E.Checkbox3CopyBackground.ZIndex    = 1
    E.Checkbox3CopyBackground.Visible   = true

    E.Checkbox3CopyFill.Position  = Vector2.new(222, 369)
    E.Checkbox3CopyFill.Size      = Vector2.new(14, 14)
    E.Checkbox3CopyFill.Color     = Color3.fromRGB(255, 0, 174)
    E.Checkbox3CopyFill.Filled    = true
    E.Checkbox3CopyFill.ZIndex    = 2
    E.Checkbox3CopyFill.Visible   = false

    E.Checkbox3CopyLabel.Position     = Vector2.new(245, 368)
    E.Checkbox3CopyLabel.Text         = "Auto Lumber"
    E.Checkbox3CopyLabel.Size         = 16
    E.Checkbox3CopyLabel.Font         = 2
    E.Checkbox3CopyLabel.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox3CopyLabel.Outline      = true
    E.Checkbox3CopyLabel.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox3CopyLabel.ZIndex       = 2
    E.Checkbox3CopyLabel.Visible      = true

    E.Checkbox3Copy2Background.Position  = Vector2.new(219, 392)
    E.Checkbox3Copy2Background.Size      = Vector2.new(20, 20)
    E.Checkbox3Copy2Background.Color     = Color3.fromRGB(204, 0, 139)
    E.Checkbox3Copy2Background.Filled    = true
    E.Checkbox3Copy2Background.Thickness = 1
    E.Checkbox3Copy2Background.ZIndex    = 1
    E.Checkbox3Copy2Background.Visible   = true

    E.Checkbox3Copy2Fill.Position  = Vector2.new(222, 395)
    E.Checkbox3Copy2Fill.Size      = Vector2.new(14, 14)
    E.Checkbox3Copy2Fill.Color     = Color3.fromRGB(255, 0, 174)
    E.Checkbox3Copy2Fill.Filled    = true
    E.Checkbox3Copy2Fill.ZIndex    = 2
    E.Checkbox3Copy2Fill.Visible   = false

    E.Checkbox3Copy2Label.Position     = Vector2.new(245, 394)
    E.Checkbox3Copy2Label.Text         = "semi-Auto Roka"
    E.Checkbox3Copy2Label.Size         = 16
    E.Checkbox3Copy2Label.Font         = 2
    E.Checkbox3Copy2Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox3Copy2Label.Outline      = true
    E.Checkbox3Copy2Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox3Copy2Label.ZIndex       = 2
    E.Checkbox3Copy2Label.Visible      = true

    E.Checkbox4Background.Position  = Vector2.new(219, 316)
    E.Checkbox4Background.Size      = Vector2.new(20, 20)
    E.Checkbox4Background.Color     = Color3.fromRGB(204, 0, 139)
    E.Checkbox4Background.Filled    = true
    E.Checkbox4Background.Thickness = 1
    E.Checkbox4Background.ZIndex    = 1
    E.Checkbox4Background.Visible   = true

    E.Checkbox4Fill.Position  = Vector2.new(222, 319)
    E.Checkbox4Fill.Size      = Vector2.new(14, 14)
    E.Checkbox4Fill.Color     = Color3.fromRGB(255, 0, 174)
    E.Checkbox4Fill.Filled    = true
    E.Checkbox4Fill.ZIndex    = 2
    E.Checkbox4Fill.Visible   = true

    E.Checkbox4Label.Position     = Vector2.new(245, 318)
    E.Checkbox4Label.Text         = "Auto Sell"
    E.Checkbox4Label.Size         = 16
    E.Checkbox4Label.Font         = 2
    E.Checkbox4Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox4Label.Outline      = true
    E.Checkbox4Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox4Label.ZIndex       = 2
    E.Checkbox4Label.Visible      = true

    E.Text8.Position     = Vector2.new(214, 294)
    E.Text8.Text         = "Automation"
    E.Text8.Size         = 16
    E.Text8.Font         = 0
    E.Text8.Color        = Color3.fromRGB(92, 92, 92)
    E.Text8.Opacity      = 1
    E.Text8.Center       = false
    E.Text8.Outline      = false
    E.Text8.ZIndex       = 1
    E.Text8.Visible      = true

    E.Square1Copy11.Position  = Vector2.new(492, 289)
    E.Square1Copy11.Size      = Vector2.new(88, 71)
    E.Square1Copy11.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy11.Opacity   = 1
    E.Square1Copy11.Filled    = false
    E.Square1Copy11.Thickness = 3
    E.Square1Copy11.Rounding  = 10
    E.Square1Copy11.ZIndex    = 1
    E.Square1Copy11.Visible   = true

    E.Text8Copy.Position     = Vector2.new(500, 294)
    E.Text8Copy.Text         = "Fun"
    E.Text8Copy.Size         = 16
    E.Text8Copy.Font         = 0
    E.Text8Copy.Color        = Color3.fromRGB(92, 92, 92)
    E.Text8Copy.Opacity      = 1
    E.Text8Copy.Center       = false
    E.Text8Copy.Outline      = false
    E.Text8Copy.ZIndex       = 1
    E.Text8Copy.Visible      = true

    E.Checkbox5Background.Position  = Vector2.new(500, 326)
    E.Checkbox5Background.Size      = Vector2.new(20, 20)
    E.Checkbox5Background.Color     = Color3.fromRGB(204, 0, 139)
    E.Checkbox5Background.Filled    = true
    E.Checkbox5Background.Thickness = 1
    E.Checkbox5Background.ZIndex    = 1
    E.Checkbox5Background.Visible   = true

    E.Checkbox5Fill.Position  = Vector2.new(503, 329)
    E.Checkbox5Fill.Size      = Vector2.new(14, 14)
    E.Checkbox5Fill.Color     = Color3.fromRGB(255, 0, 174)
    E.Checkbox5Fill.Filled    = true
    E.Checkbox5Fill.ZIndex    = 2
    E.Checkbox5Fill.Visible   = false

    E.Checkbox5Label.Position     = Vector2.new(526, 329)
    E.Checkbox5Label.Text         = "TP Projectile"
    E.Checkbox5Label.Size         = 14
    E.Checkbox5Label.Font         = 2
    E.Checkbox5Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox5Label.Outline      = true
    E.Checkbox5Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox5Label.ZIndex       = 2
    E.Checkbox5Label.Visible      = true

    E.Button4Background.Position  = Vector2.new(666, 349)
    E.Button4Background.Size      = Vector2.new(38, 34)
    E.Button4Background.Color     = Color3.fromRGB(77, 144, 255)
    E.Button4Background.Filled    = true
    E.Button4Background.Thickness = 1
    E.Button4Background.Rounding  = 4
    E.Button4Background.ZIndex    = 1
    E.Button4Background.Visible   = false

    E.Button4Text.Position     = Vector2.new(685, 358)
    E.Button4Text.Text         = "Button"
    E.Button4Text.Size         = 16
    E.Button4Text.Font         = 2
    E.Button4Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button4Text.Center       = true
    E.Button4Text.Outline      = false
    E.Button4Text.ZIndex       = 2
    E.Button4Text.Visible      = false
    _FitText(E.Button4Text, 29.666721407587602)
    E.Button4Background.Opacity = 0
    E.Button4Text.Opacity = 0

    E.Keybind1Background.Position  = Vector2.new(998, 622)
    E.Keybind1Background.Size      = Vector2.new(100, 30)
    E.Keybind1Background.Color     = Color3.fromRGB(103, 53, 126)
    E.Keybind1Background.Filled    = true
    E.Keybind1Background.Thickness = 1
    E.Keybind1Background.Rounding  = 4
    E.Keybind1Background.ZIndex    = 1
    E.Keybind1Background.Visible   = true

    E.Keybind1Text.Position     = Vector2.new(1048, 629)
    E.Keybind1Text.Text         = E.Keybind1DisplayText
    E.Keybind1Text.Size         = 16
    E.Keybind1Text.Font         = 2
    E.Keybind1Text.Color        = Color3.fromRGB(204, 0, 139)
    E.Keybind1Text.Center       = true
    E.Keybind1Text.Outline      = false
    E.Keybind1Text.ZIndex       = 2
    E.Keybind1Text.Visible      = true

    E.Square2Copy.Position  = Vector2.new(897, 623)
    E.Square2Copy.Size      = Vector2.new(93, 24)
    E.Square2Copy.Color     = Color3.fromRGB(235, 0, 215)
    E.Square2Copy.Opacity   = 0.28
    E.Square2Copy.Filled    = false
    E.Square2Copy.Thickness = 5
    E.Square2Copy.Rounding  = 20
    E.Square2Copy.ZIndex    = 1
    E.Square2Copy.Visible   = true

    E.Text3Copy4.Position     = Vector2.new(969, 455)
    E.Text3Copy4.Text         = "If you experience any bugs"
    E.Text3Copy4.Size         = 13
    E.Text3Copy4.Font         = 2
    E.Text3Copy4.Color        = Color3.fromRGB(92, 92, 92)
    E.Text3Copy4.Opacity      = 1
    E.Text3Copy4.Center       = false
    E.Text3Copy4.Outline      = false
    E.Text3Copy4.ZIndex       = 1
    E.Text3Copy4.Visible      = true

    E.Checkbox1Copy3Background.Position  = Vector2.new(1025, 554)
    E.Checkbox1Copy3Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Copy3Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Copy3Background.Filled    = true
    E.Checkbox1Copy3Background.Thickness = 1
    E.Checkbox1Copy3Background.ZIndex    = 1
    E.Checkbox1Copy3Background.Visible   = true

    E.Checkbox1Copy3Fill.Position  = Vector2.new(1028, 557)
    E.Checkbox1Copy3Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Copy3Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Copy3Fill.Filled    = true
    E.Checkbox1Copy3Fill.ZIndex    = 2
    E.Checkbox1Copy3Fill.Visible   = true

    E.Checkbox1Copy3Label.Position     = Vector2.new(1057, 559)
    E.Checkbox1Copy3Label.Text         = "Auto gen"
    E.Checkbox1Copy3Label.Size         = 16
    E.Checkbox1Copy3Label.Font         = 2
    E.Checkbox1Copy3Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy3Label.Outline      = true
    E.Checkbox1Copy3Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Copy3Label.ZIndex       = 2
    E.Checkbox1Copy3Label.Visible      = true

    E.Text1Copy8.Position     = Vector2.new(900, 434)
    E.Text1Copy8.Text         = "BROG"
    E.Text1Copy8.Size         = 23
    E.Text1Copy8.Font         = 0
    E.Text1Copy8.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy8.Opacity      = 1
    E.Text1Copy8.Center       = false
    E.Text1Copy8.Outline      = false
    E.Text1Copy8.ZIndex       = 1
    E.Text1Copy8.Visible      = true

    E.Text1Copy9.Position     = Vector2.new(954, 435)
    E.Text1Copy9.Text         = ":  Pilgrammed"
    E.Text1Copy9.Size         = 17
    E.Text1Copy9.Font         = 0
    E.Text1Copy9.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy9.Opacity      = 1
    E.Text1Copy9.Center       = false
    E.Text1Copy9.Outline      = false
    E.Text1Copy9.ZIndex       = 1
    E.Text1Copy9.Visible      = true

    E.Line4Copy4.From      = Vector2.new(851, 439)
    E.Line4Copy4.To        = Vector2.new(855, 431)
    E.Line4Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy4.Opacity   = 1
    E.Line4Copy4.Thickness = 1
    E.Line4Copy4.ZIndex    = 1
    E.Line4Copy4.Visible   = true

    E.Line5Copy4.From      = Vector2.new(855, 431)
    E.Line5Copy4.To        = Vector2.new(859, 438)
    E.Line5Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy4.Opacity   = 1
    E.Line5Copy4.Thickness = 1
    E.Line5Copy4.ZIndex    = 1
    E.Line5Copy4.Visible   = true

    E.Line6Copy4.From      = Vector2.new(871, 438)
    E.Line6Copy4.To        = Vector2.new(875, 431)
    E.Line6Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy4.Opacity   = 1
    E.Line6Copy4.Thickness = 1
    E.Line6Copy4.ZIndex    = 1
    E.Line6Copy4.Visible   = true

    E.Line7Copy4.From      = Vector2.new(875, 431)
    E.Line7Copy4.To        = Vector2.new(878, 440)
    E.Line7Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7Copy4.Opacity   = 1
    E.Line7Copy4.Thickness = 1
    E.Line7Copy4.ZIndex    = 1
    E.Line7Copy4.Visible   = true

    E.Line8Copy8.From      = Vector2.new(847, 451)
    E.Line8Copy8.To        = Vector2.new(855, 453)
    E.Line8Copy8.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy8.Opacity   = 1
    E.Line8Copy8.Thickness = 1
    E.Line8Copy8.ZIndex    = 1
    E.Line8Copy8.Visible   = true

    E.Line8Copy9.From      = Vector2.new(846, 456)
    E.Line8Copy9.To        = Vector2.new(856, 456)
    E.Line8Copy9.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy9.Opacity   = 1
    E.Line8Copy9.Thickness = 1
    E.Line8Copy9.ZIndex    = 1
    E.Line8Copy9.Visible   = true

    E.Line9Copy8.From      = Vector2.new(875, 454)
    E.Line9Copy8.To        = Vector2.new(883, 452)
    E.Line9Copy8.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy8.Opacity   = 1
    E.Line9Copy8.Thickness = 1
    E.Line9Copy8.ZIndex    = 1
    E.Line9Copy8.Visible   = true

    E.Line9Copy9.From      = Vector2.new(874, 456)
    E.Line9Copy9.To        = Vector2.new(883, 458)
    E.Line9Copy9.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy9.Opacity   = 1
    E.Line9Copy9.Thickness = 1
    E.Line9Copy9.ZIndex    = 1
    E.Line9Copy9.Visible   = true

    E.Line10Copy8.From      = Vector2.new(865, 452)
    E.Line10Copy8.To        = Vector2.new(863, 456)
    E.Line10Copy8.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy8.Opacity   = 1
    E.Line10Copy8.Thickness = 1
    E.Line10Copy8.ZIndex    = 1
    E.Line10Copy8.Visible   = true

    E.Line10Copy9.From      = Vector2.new(865, 452)
    E.Line10Copy9.To        = Vector2.new(868, 457)
    E.Line10Copy9.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy9.Opacity   = 1
    E.Line10Copy9.Thickness = 1
    E.Line10Copy9.ZIndex    = 1
    E.Line10Copy9.Visible   = true

    E.Text9.Position     = Vector2.new(856, 475)
    E.Text9.Text         = "Boss"
    E.Text9.Size         = 16
    E.Text9.Font         = 0
    E.Text9.Color        = Color3.fromRGB(102, 102, 102)
    E.Text9.Opacity      = 1
    E.Text9.Center       = false
    E.Text9.Outline      = false
    E.Text9.ZIndex       = 1
    E.Text9.Visible      = true

    E.Slider1Track.Position  = Vector2.new(832, 607)
    E.Slider1Track.Size      = Vector2.new(131, 13)
    E.Slider1Track.Color     = Color3.fromRGB(255, 0, 136)
    E.Slider1Track.Opacity   = 0.30
    E.Slider1Track.Filled    = true
    E.Slider1Track.ZIndex    = 1
    E.Slider1Track.Visible   = true

    E.Slider1Fill.Position   = Vector2.new(832, 607)
    E.Slider1Fill.Size       = Vector2.new(0, 13)
    E.Slider1Fill.Color      = Color3.fromRGB(255, 0, 136)
    E.Slider1Fill.Filled     = true
    E.Slider1Fill.ZIndex     = 2
    E.Slider1Fill.Visible    = true

    E.Slider1Knob.Position   = Vector2.new(827, 605)
    E.Slider1Knob.Size       = Vector2.new(10, 17)
    E.Slider1Knob.Color      = Color3.fromRGB(255, 255, 255)
    E.Slider1Knob.Filled     = true
    E.Slider1Knob.Rounding   = 2
    E.Slider1Knob.ZIndex     = 3
    E.Slider1Knob.Visible    = true

    E.Slider1Label.Position  = Vector2.new(897, 591)
    E.Slider1Label.Text      = _FmtNum(E.Slider1Value) .. ""
    E.Slider1Label.Size      = 11
    E.Slider1Label.Font      = 0
    E.Slider1Label.Color     = Color3.fromRGB(255, 0, 136)
    E.Slider1Label.Center    = true
    E.Slider1Label.ZIndex    = 3
    E.Slider1Label.Visible   = true
    _FitText(E.Slider1Label, 130.75)

    E.Text10.Position     = Vector2.new(856, 568)
    E.Text10.Text         = "Timing value"
    E.Text10.Size         = 16
    E.Text10.Font         = 0
    E.Text10.Color        = Color3.fromRGB(102, 102, 102)
    E.Text10.Opacity      = 1
    E.Text10.Center       = false
    E.Text10.Outline      = false
    E.Text10.ZIndex       = 1
    E.Text10.Visible      = true

    E.Text11.Position     = Vector2.new(824, 626)
    E.Text11.Text         = "late"
    E.Text11.Size         = 11
    E.Text11.Font         = 0
    E.Text11.Color        = Color3.fromRGB(255, 0, 136)
    E.Text11.Opacity      = 1
    E.Text11.Center       = false
    E.Text11.Outline      = false
    E.Text11.ZIndex       = 1
    E.Text11.Visible      = true

    E.Text11Copy.Position     = Vector2.new(951, 626)
    E.Text11Copy.Text         = "early"
    E.Text11Copy.Size         = 11
    E.Text11Copy.Font         = 0
    E.Text11Copy.Color        = Color3.fromRGB(255, 0, 136)
    E.Text11Copy.Opacity      = 1
    E.Text11Copy.Center       = false
    E.Text11Copy.Outline      = false
    E.Text11Copy.ZIndex       = 1
    E.Text11Copy.Visible      = true

    E.Checkbox6Background.Position  = Vector2.new(835, 520)
    E.Checkbox6Background.Size      = Vector2.new(34, 27)
    E.Checkbox6Background.Color     = Color3.fromRGB(171, 6, 183)
    E.Checkbox6Background.Filled    = true
    E.Checkbox6Background.Thickness = 1
    E.Checkbox6Background.ZIndex    = 1
    E.Checkbox6Background.Visible   = true

    E.Checkbox6Fill.Position  = Vector2.new(838, 523)
    E.Checkbox6Fill.Size      = Vector2.new(28, 21)
    E.Checkbox6Fill.Color     = Color3.fromRGB(212, 0, 255)
    E.Checkbox6Fill.Filled    = true
    E.Checkbox6Fill.ZIndex    = 2
    E.Checkbox6Fill.Visible   = false

    E.Checkbox6Label.Position     = Vector2.new(875, 526)
    E.Checkbox6Label.Text         = "Auto Parry"
    E.Checkbox6Label.Size         = 16
    E.Checkbox6Label.Font         = 2
    E.Checkbox6Label.Color        = Color3.fromRGB(102, 102, 102)
    E.Checkbox6Label.Outline      = false
    E.Checkbox6Label.ZIndex       = 2
    E.Checkbox6Label.Visible      = true

    E.Checkbox1Copy4Background.Position  = Vector2.new(829, 588)
    E.Checkbox1Copy4Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Copy4Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Copy4Background.Filled    = true
    E.Checkbox1Copy4Background.Thickness = 1
    E.Checkbox1Copy4Background.ZIndex    = 1
    E.Checkbox1Copy4Background.Visible   = true

    E.Checkbox1Copy4Fill.Position  = Vector2.new(832, 591)
    E.Checkbox1Copy4Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Copy4Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Copy4Fill.Filled    = true
    E.Checkbox1Copy4Fill.ZIndex    = 2
    E.Checkbox1Copy4Fill.Visible   = true

    E.Checkbox1Copy4Label.Position     = Vector2.new(861, 592)
    E.Checkbox1Copy4Label.Text         = "Vault ESP"
    E.Checkbox1Copy4Label.Size         = 16
    E.Checkbox1Copy4Label.Font         = 2
    E.Checkbox1Copy4Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy4Label.Outline      = true
    E.Checkbox1Copy4Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Copy4Label.ZIndex       = 2
    E.Checkbox1Copy4Label.Visible      = true

    E.Checkbox1Copy5Background.Position  = Vector2.new(829, 619)
    E.Checkbox1Copy5Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Copy5Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Copy5Background.Filled    = true
    E.Checkbox1Copy5Background.Thickness = 1
    E.Checkbox1Copy5Background.ZIndex    = 1
    E.Checkbox1Copy5Background.Visible   = true

    E.Checkbox1Copy5Fill.Position  = Vector2.new(832, 622)
    E.Checkbox1Copy5Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Copy5Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Copy5Fill.Filled    = true
    E.Checkbox1Copy5Fill.ZIndex    = 2
    E.Checkbox1Copy5Fill.Visible   = true

    E.Checkbox1Copy5Label.Position     = Vector2.new(861, 623)
    E.Checkbox1Copy5Label.Text         = "Pallet ESP"
    E.Checkbox1Copy5Label.Size         = 16
    E.Checkbox1Copy5Label.Font         = 2
    E.Checkbox1Copy5Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy5Label.Outline      = true
    E.Checkbox1Copy5Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Copy5Label.ZIndex       = 2
    E.Checkbox1Copy5Label.Visible      = true

    E.Circle1Copy.Position  = Vector2.new(691, 365)
    E.Circle1Copy.Radius    = 3.675981117494274
    E.Circle1Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy.Opacity   = 1
    E.Circle1Copy.Filled    = false
    E.Circle1Copy.Thickness = 1
    E.Circle1Copy.NumSides  = 64
    E.Circle1Copy.ZIndex    = 2
    E.Circle1Copy.Visible   = true

    E.Circle1Copy6.Position  = Vector2.new(831, 486)
    E.Circle1Copy6.Radius    = 3.675981117494274
    E.Circle1Copy6.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy6.Opacity   = 1
    E.Circle1Copy6.Filled    = false
    E.Circle1Copy6.Thickness = 1
    E.Circle1Copy6.NumSides  = 64
    E.Circle1Copy6.ZIndex    = 2
    E.Circle1Copy6.Visible   = true

    E.Circle1Copy2.Position  = Vector2.new(819, 486)
    E.Circle1Copy2.Radius    = 3.675981117494274
    E.Circle1Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy2.Opacity   = 1
    E.Circle1Copy2.Filled    = false
    E.Circle1Copy2.Thickness = 1
    E.Circle1Copy2.NumSides  = 64
    E.Circle1Copy2.ZIndex    = 2
    E.Circle1Copy2.Visible   = true

    E.Circle1Copy3.Position  = Vector2.new(847, 453)
    E.Circle1Copy3.Radius    = 3.675981117494274
    E.Circle1Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy3.Opacity   = 1
    E.Circle1Copy3.Filled    = false
    E.Circle1Copy3.Thickness = 1
    E.Circle1Copy3.NumSides  = 64
    E.Circle1Copy3.ZIndex    = 2
    E.Circle1Copy3.Visible   = true

    E.Circle1Copy4.Position  = Vector2.new(834, 453)
    E.Circle1Copy4.Radius    = 3.675981117494274
    E.Circle1Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy4.Opacity   = 1
    E.Circle1Copy4.Filled    = false
    E.Circle1Copy4.Thickness = 1
    E.Circle1Copy4.NumSides  = 64
    E.Circle1Copy4.ZIndex    = 2
    E.Circle1Copy4.Visible   = true

    E.Circle1Copy5.Position  = Vector2.new(227, 259)
    E.Circle1Copy5.Radius    = 3.675981117494274
    E.Circle1Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy5.Opacity   = 1
    E.Circle1Copy5.Filled    = false
    E.Circle1Copy5.Thickness = 1
    E.Circle1Copy5.NumSides  = 64
    E.Circle1Copy5.ZIndex    = 2
    E.Circle1Copy5.Visible   = true

    E.Circle1Copy7.Position  = Vector2.new(215, 259)
    E.Circle1Copy7.Radius    = 3.675981117494274
    E.Circle1Copy7.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy7.Opacity   = 1
    E.Circle1Copy7.Filled    = false
    E.Circle1Copy7.Thickness = 1
    E.Circle1Copy7.NumSides  = 64
    E.Circle1Copy7.ZIndex    = 2
    E.Circle1Copy7.Visible   = true

    E.Circle1Copy8.Position  = Vector2.new(871, 445)
    E.Circle1Copy8.Radius    = 3.675981117494274
    E.Circle1Copy8.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy8.Opacity   = 1
    E.Circle1Copy8.Filled    = false
    E.Circle1Copy8.Thickness = 1
    E.Circle1Copy8.NumSides  = 64
    E.Circle1Copy8.ZIndex    = 2
    E.Circle1Copy8.Visible   = true

    E.Circle1Copy9.Position  = Vector2.new(859, 445)
    E.Circle1Copy9.Radius    = 3.675981117494274
    E.Circle1Copy9.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy9.Opacity   = 1
    E.Circle1Copy9.Filled    = false
    E.Circle1Copy9.Thickness = 1
    E.Circle1Copy9.NumSides  = 64
    E.Circle1Copy9.ZIndex    = 2
    E.Circle1Copy9.Visible   = true

    E.Square1Copy13.Position  = Vector2.new(492, 289)
    E.Square1Copy13.Size      = Vector2.new(88, 71)
    E.Square1Copy13.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy13.Opacity   = 0.12
    E.Square1Copy13.Filled    = true
    E.Square1Copy13.Thickness = 3
    E.Square1Copy13.Rounding  = 10
    E.Square1Copy13.ZIndex    = 2
    E.Square1Copy13.Visible   = true

    E.Line1Copy2.From      = Vector2.new(800, 506)
    E.Line1Copy2.To        = Vector2.new(991, 506)
    E.Line1Copy2.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy2.Opacity   = 0.33
    E.Line1Copy2.Thickness = 1
    E.Line1Copy2.ZIndex    = 3
    E.Line1Copy2.Visible   = true

    E.Line1Copy3.From      = Vector2.new(815, 475)
    E.Line1Copy3.To        = Vector2.new(1203, 475)
    E.Line1Copy3.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy3.Opacity   = 0.33
    E.Line1Copy3.Thickness = 1
    E.Line1Copy3.ZIndex    = 3
    E.Line1Copy3.Visible   = true

    E.Line1Copy4.From      = Vector2.new(834, 513)
    E.Line1Copy4.To        = Vector2.new(988, 513)
    E.Line1Copy4.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy4.Opacity   = 0.33
    E.Line1Copy4.Thickness = 1
    E.Line1Copy4.ZIndex    = 3
    E.Line1Copy4.Visible   = true

    E.Line1Copy5.From      = Vector2.new(1025, 513)
    E.Line1Copy5.To        = Vector2.new(1178, 513)
    E.Line1Copy5.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy5.Opacity   = 0.33
    E.Line1Copy5.Thickness = 1
    E.Line1Copy5.ZIndex    = 3
    E.Line1Copy5.Visible   = true

    E.Line1Copy6.From      = Vector2.new(196, 281)
    E.Line1Copy6.To        = Vector2.new(583, 281)
    E.Line1Copy6.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy6.Opacity   = 0.33
    E.Line1Copy6.Thickness = 1
    E.Line1Copy6.ZIndex    = 3
    E.Line1Copy6.Visible   = true

    E.Line1Copy7.From      = Vector2.new(208, 311)
    E.Line1Copy7.To        = Vector2.new(473, 310)
    E.Line1Copy7.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy7.Opacity   = 0.33
    E.Line1Copy7.Thickness = 1
    E.Line1Copy7.ZIndex    = 3
    E.Line1Copy7.Visible   = true

    E.Line1Copy8.From      = Vector2.new(497, 310)
    E.Line1Copy8.To        = Vector2.new(574, 310)
    E.Line1Copy8.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy8.Opacity   = 0.33
    E.Line1Copy8.Thickness = 1
    E.Line1Copy8.ZIndex    = 3
    E.Line1Copy8.Visible   = true

    E.Line1Copy9.From      = Vector2.new(840, 466)
    E.Line1Copy9.To        = Vector2.new(1149, 466)
    E.Line1Copy9.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy9.Opacity   = 0.33
    E.Line1Copy9.Thickness = 1
    E.Line1Copy9.ZIndex    = 3
    E.Line1Copy9.Visible   = true

    E.Line1Copy10.From      = Vector2.new(842, 495)
    E.Line1Copy10.To        = Vector2.new(1002, 495)
    E.Line1Copy10.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy10.Opacity   = 0.33
    E.Line1Copy10.Thickness = 1
    E.Line1Copy10.ZIndex    = 3
    E.Line1Copy10.Visible   = true

    E.Line1Copy11.From      = Vector2.new(809, 587)
    E.Line1Copy11.To        = Vector2.new(990, 587)
    E.Line1Copy11.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy11.Opacity   = 0.33
    E.Line1Copy11.Thickness = 1
    E.Line1Copy11.ZIndex    = 3
    E.Line1Copy11.Visible   = true

    E.Button2Background.Position  = Vector2.new(814, 474)
    E.Button2Background.Size      = Vector2.new(23, 23)
    E.Button2Background.Color     = Color3.fromRGB(194, 0, 78)
    E.Button2Background.Filled    = false
    E.Button2Background.Thickness = 1
    E.Button2Background.Rounding  = 4
    E.Button2Background.ZIndex    = 4
    E.Button2Background.Visible   = false

    E.Button2Text.Position     = Vector2.new(826, 477)
    E.Button2Text.Text         = "."
    E.Button2Text.Size         = 16
    E.Button2Text.Font         = 2
    E.Button2Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button2Text.Center       = true
    E.Button2Text.Outline      = false
    E.Button2Text.ZIndex       = 5
    E.Button2Text.Visible      = false
    _FitText(E.Button2Text, 15.014568727466553)
    E.Button2Background.Opacity = 0
    E.Button2Text.Opacity = 0

    E.Button2CopyBackground.Position  = Vector2.new(829, 442)
    E.Button2CopyBackground.Size      = Vector2.new(23, 23)
    E.Button2CopyBackground.Color     = Color3.fromRGB(194, 0, 78)
    E.Button2CopyBackground.Filled    = false
    E.Button2CopyBackground.Thickness = 1
    E.Button2CopyBackground.Rounding  = 4
    E.Button2CopyBackground.ZIndex    = 4
    E.Button2CopyBackground.Visible   = true

    E.Button2CopyText.Position     = Vector2.new(841, 445)
    E.Button2CopyText.Text         = "."
    E.Button2CopyText.Size         = 16
    E.Button2CopyText.Font         = 2
    E.Button2CopyText.Color        = Color3.fromRGB(255, 255, 255)
    E.Button2CopyText.Center       = true
    E.Button2CopyText.Outline      = false
    E.Button2CopyText.ZIndex       = 5
    E.Button2CopyText.Visible      = true
    _FitText(E.Button2CopyText, 15.014568727466553)
    E.Button2CopyBackground.Opacity = 0
    E.Button2CopyText.Opacity = 0

    E.Button2Copy2Background.Position  = Vector2.new(210, 248)
    E.Button2Copy2Background.Size      = Vector2.new(23, 23)
    E.Button2Copy2Background.Color     = Color3.fromRGB(194, 0, 78)
    E.Button2Copy2Background.Filled    = false
    E.Button2Copy2Background.Thickness = 1
    E.Button2Copy2Background.Rounding  = 4
    E.Button2Copy2Background.ZIndex    = 4
    E.Button2Copy2Background.Visible   = false

    E.Button2Copy2Text.Position     = Vector2.new(221, 251)
    E.Button2Copy2Text.Text         = "."
    E.Button2Copy2Text.Size         = 16
    E.Button2Copy2Text.Font         = 2
    E.Button2Copy2Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button2Copy2Text.Center       = true
    E.Button2Copy2Text.Outline      = false
    E.Button2Copy2Text.ZIndex       = 5
    E.Button2Copy2Text.Visible      = false
    _FitText(E.Button2Copy2Text, 15.014568727466553)
    E.Button2Copy2Background.Opacity = 0
    E.Button2Copy2Text.Opacity = 0

    E.Button2Copy3Background.Position  = Vector2.new(854, 433)
    E.Button2Copy3Background.Size      = Vector2.new(23, 23)
    E.Button2Copy3Background.Color     = Color3.fromRGB(194, 0, 78)
    E.Button2Copy3Background.Filled    = false
    E.Button2Copy3Background.Thickness = 1
    E.Button2Copy3Background.Rounding  = 4
    E.Button2Copy3Background.ZIndex    = 4
    E.Button2Copy3Background.Visible   = false

    E.Button2Copy3Text.Position     = Vector2.new(866, 437)
    E.Button2Copy3Text.Text         = "."
    E.Button2Copy3Text.Size         = 16
    E.Button2Copy3Text.Font         = 2
    E.Button2Copy3Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button2Copy3Text.Center       = true
    E.Button2Copy3Text.Outline      = false
    E.Button2Copy3Text.ZIndex       = 5
    E.Button2Copy3Text.Visible      = false
    _FitText(E.Button2Copy3Text, 15.014568727466553)
    E.Button2Copy3Background.Opacity = 0
    E.Button2Copy3Text.Opacity = 0

    local _PlayerName: string = game.Players.LocalPlayer.Name
    E.Text2.Text = _PlayerName
    E.Text2Copy2.Text = _PlayerName
    E.Text2Copy3.Text = _PlayerName
    SetTab(1)
end

do
    local PrevLeftPressed: boolean = false
    local PrevKeys: {string} = {}

local function _DestroyUI(): ()
    if _Destroyed then return end
    _Destroyed = true
    for _, c in _Conns do c:Disconnect() end
    table.clear(_Conns)
    if E.Square1Copy then E.Square1Copy:Remove() end
    if E.Square6 then E.Square6:Remove() end
    if E.Square6Copy then E.Square6Copy:Remove() end
    if E.Square6Copy2 then E.Square6Copy2:Remove() end
    if E.Square6Copy3 then E.Square6Copy3:Remove() end
    if E.Square1Copy7 then E.Square1Copy7:Remove() end
    if E.Square1Copy8 then E.Square1Copy8:Remove() end
    if E.Square1Copy12 then E.Square1Copy12:Remove() end
    if E.Square1 then E.Square1:Remove() end
    if E.Square1Copy2 then E.Square1Copy2:Remove() end
    if E.Square1Copy3 then E.Square1Copy3:Remove() end
    if E.Square1Copy9 then E.Square1Copy9:Remove() end
    if E.Square1Copy14 then E.Square1Copy14:Remove() end
    if E.Dropdown1Background then E.Dropdown1Background:Remove() end
    if E.Dropdown1Text then E.Dropdown1Text:Remove() end
    if E.Dropdown1Arrow then E.Dropdown1Arrow:Remove() end
    if E.Dropdown1OptionBackground0 then E.Dropdown1OptionBackground0:Remove() end
    if E.Dropdown1OptionText0 then E.Dropdown1OptionText0:Remove() end
    if E.Dropdown1OptionBackground1 then E.Dropdown1OptionBackground1:Remove() end
    if E.Dropdown1OptionText1 then E.Dropdown1OptionText1:Remove() end
    if E.Dropdown1OptionBackground2 then E.Dropdown1OptionBackground2:Remove() end
    if E.Dropdown1OptionText2 then E.Dropdown1OptionText2:Remove() end
    if E.Line1 then E.Line1:Remove() end
    if E.Text1 then E.Text1:Remove() end
    if E.Text1Copy then E.Text1Copy:Remove() end
    if E.Line4 then E.Line4:Remove() end
    if E.Line5 then E.Line5:Remove() end
    if E.Line6 then E.Line6:Remove() end
    if E.Line7 then E.Line7:Remove() end
    if E.Line8 then E.Line8:Remove() end
    if E.Line8Copy then E.Line8Copy:Remove() end
    if E.Line9 then E.Line9:Remove() end
    if E.Line9Copy then E.Line9Copy:Remove() end
    if E.Text2 then E.Text2:Remove() end
    if E.Square2 then E.Square2:Remove() end
    if E.Text3 then E.Text3:Remove() end
    if E.Text3Copy then E.Text3Copy:Remove() end
    if E.Text3Copy2 then E.Text3Copy2:Remove() end
    if E.Text3Copy3 then E.Text3Copy3:Remove() end
    if E.Button1Background then E.Button1Background:Remove() end
    if E.Button1Text then E.Button1Text:Remove() end
    if E.Line1Copy then E.Line1Copy:Remove() end
    if E.Circle1 then E.Circle1:Remove() end
    if E.Text1Copy2 then E.Text1Copy2:Remove() end
    if E.Text1Copy3 then E.Text1Copy3:Remove() end
    if E.Line4Copy then E.Line4Copy:Remove() end
    if E.Line5Copy then E.Line5Copy:Remove() end
    if E.Line6Copy then E.Line6Copy:Remove() end
    if E.Line7Copy then E.Line7Copy:Remove() end
    if E.Line8Copy2 then E.Line8Copy2:Remove() end
    if E.Line8Copy3 then E.Line8Copy3:Remove() end
    if E.Line9Copy2 then E.Line9Copy2:Remove() end
    if E.Line9Copy3 then E.Line9Copy3:Remove() end
    if E.Line10 then E.Line10:Remove() end
    if E.Line10Copy then E.Line10Copy:Remove() end
    if E.Line10Copy2 then E.Line10Copy2:Remove() end
    if E.Line10Copy3 then E.Line10Copy3:Remove() end
    if E.Text1Copy4 then E.Text1Copy4:Remove() end
    if E.Text1Copy5 then E.Text1Copy5:Remove() end
    if E.Line4Copy2 then E.Line4Copy2:Remove() end
    if E.Line5Copy2 then E.Line5Copy2:Remove() end
    if E.Line6Copy2 then E.Line6Copy2:Remove() end
    if E.Line7Copy2 then E.Line7Copy2:Remove() end
    if E.Line8Copy4 then E.Line8Copy4:Remove() end
    if E.Line8Copy5 then E.Line8Copy5:Remove() end
    if E.Line9Copy4 then E.Line9Copy4:Remove() end
    if E.Line9Copy5 then E.Line9Copy5:Remove() end
    if E.Text2Copy2 then E.Text2Copy2:Remove() end
    if E.Line10Copy4 then E.Line10Copy4:Remove() end
    if E.Line10Copy5 then E.Line10Copy5:Remove() end
    if E.Checkbox1Background then E.Checkbox1Background:Remove() end
    if E.Checkbox1Fill then E.Checkbox1Fill:Remove() end
    if E.Checkbox1Label then E.Checkbox1Label:Remove() end
    if E.Checkbox1CopyBackground then E.Checkbox1CopyBackground:Remove() end
    if E.Checkbox1CopyFill then E.Checkbox1CopyFill:Remove() end
    if E.Checkbox1CopyLabel then E.Checkbox1CopyLabel:Remove() end
    if E.Checkbox1Copy2Background then E.Checkbox1Copy2Background:Remove() end
    if E.Checkbox1Copy2Fill then E.Checkbox1Copy2Fill:Remove() end
    if E.Checkbox1Copy2Label then E.Checkbox1Copy2Label:Remove() end
    if E.Square1Copy5 then E.Square1Copy5:Remove() end
    if E.Text7 then E.Text7:Remove() end
    if E.Square1Copy6 then E.Square1Copy6:Remove() end
    if E.Text7Copy then E.Text7Copy:Remove() end
    if E.Text1Copy6 then E.Text1Copy6:Remove() end
    if E.Text1Copy7 then E.Text1Copy7:Remove() end
    if E.Line4Copy3 then E.Line4Copy3:Remove() end
    if E.Line5Copy3 then E.Line5Copy3:Remove() end
    if E.Line6Copy3 then E.Line6Copy3:Remove() end
    if E.Line7Copy3 then E.Line7Copy3:Remove() end
    if E.Line8Copy6 then E.Line8Copy6:Remove() end
    if E.Line8Copy7 then E.Line8Copy7:Remove() end
    if E.Line9Copy6 then E.Line9Copy6:Remove() end
    if E.Line9Copy7 then E.Line9Copy7:Remove() end
    if E.Text2Copy3 then E.Text2Copy3:Remove() end
    if E.Line10Copy6 then E.Line10Copy6:Remove() end
    if E.Line10Copy7 then E.Line10Copy7:Remove() end
    if E.Square1Copy10 then E.Square1Copy10:Remove() end
    if E.Checkbox3Background then E.Checkbox3Background:Remove() end
    if E.Checkbox3Fill then E.Checkbox3Fill:Remove() end
    if E.Checkbox3Label then E.Checkbox3Label:Remove() end
    if E.Checkbox3CopyBackground then E.Checkbox3CopyBackground:Remove() end
    if E.Checkbox3CopyFill then E.Checkbox3CopyFill:Remove() end
    if E.Checkbox3CopyLabel then E.Checkbox3CopyLabel:Remove() end
    if E.Checkbox3Copy2Background then E.Checkbox3Copy2Background:Remove() end
    if E.Checkbox3Copy2Fill then E.Checkbox3Copy2Fill:Remove() end
    if E.Checkbox3Copy2Label then E.Checkbox3Copy2Label:Remove() end
    if E.Checkbox4Background then E.Checkbox4Background:Remove() end
    if E.Checkbox4Fill then E.Checkbox4Fill:Remove() end
    if E.Checkbox4Label then E.Checkbox4Label:Remove() end
    if E.Text8 then E.Text8:Remove() end
    if E.Square1Copy11 then E.Square1Copy11:Remove() end
    if E.Text8Copy then E.Text8Copy:Remove() end
    if E.Checkbox5Background then E.Checkbox5Background:Remove() end
    if E.Checkbox5Fill then E.Checkbox5Fill:Remove() end
    if E.Checkbox5Label then E.Checkbox5Label:Remove() end
    if E.Button4Background then E.Button4Background:Remove() end
    if E.Button4Text then E.Button4Text:Remove() end
    if E.Keybind1Background then E.Keybind1Background:Remove() end
    if E.Keybind1Text then E.Keybind1Text:Remove() end
    if E.Square2Copy then E.Square2Copy:Remove() end
    if E.Text3Copy4 then E.Text3Copy4:Remove() end
    if E.Checkbox1Copy3Background then E.Checkbox1Copy3Background:Remove() end
    if E.Checkbox1Copy3Fill then E.Checkbox1Copy3Fill:Remove() end
    if E.Checkbox1Copy3Label then E.Checkbox1Copy3Label:Remove() end
    if E.Text1Copy8 then E.Text1Copy8:Remove() end
    if E.Text1Copy9 then E.Text1Copy9:Remove() end
    if E.Line4Copy4 then E.Line4Copy4:Remove() end
    if E.Line5Copy4 then E.Line5Copy4:Remove() end
    if E.Line6Copy4 then E.Line6Copy4:Remove() end
    if E.Line7Copy4 then E.Line7Copy4:Remove() end
    if E.Line8Copy8 then E.Line8Copy8:Remove() end
    if E.Line8Copy9 then E.Line8Copy9:Remove() end
    if E.Line9Copy8 then E.Line9Copy8:Remove() end
    if E.Line9Copy9 then E.Line9Copy9:Remove() end
    if E.Line10Copy8 then E.Line10Copy8:Remove() end
    if E.Line10Copy9 then E.Line10Copy9:Remove() end
    if E.Text9 then E.Text9:Remove() end
    if E.Slider1Track then E.Slider1Track:Remove() end
    if E.Slider1Fill then E.Slider1Fill:Remove() end
    if E.Slider1Knob then E.Slider1Knob:Remove() end
    if E.Slider1Label then E.Slider1Label:Remove() end
    if E.Text10 then E.Text10:Remove() end
    if E.Text11 then E.Text11:Remove() end
    if E.Text11Copy then E.Text11Copy:Remove() end
    if E.Checkbox6Background then E.Checkbox6Background:Remove() end
    if E.Checkbox6Fill then E.Checkbox6Fill:Remove() end
    if E.Checkbox6Label then E.Checkbox6Label:Remove() end
    if E.Checkbox1Copy4Background then E.Checkbox1Copy4Background:Remove() end
    if E.Checkbox1Copy4Fill then E.Checkbox1Copy4Fill:Remove() end
    if E.Checkbox1Copy4Label then E.Checkbox1Copy4Label:Remove() end
    if E.Checkbox1Copy5Background then E.Checkbox1Copy5Background:Remove() end
    if E.Checkbox1Copy5Fill then E.Checkbox1Copy5Fill:Remove() end
    if E.Checkbox1Copy5Label then E.Checkbox1Copy5Label:Remove() end
    if E.Circle1Copy then E.Circle1Copy:Remove() end
    if E.Circle1Copy6 then E.Circle1Copy6:Remove() end
    if E.Circle1Copy2 then E.Circle1Copy2:Remove() end
    if E.Circle1Copy3 then E.Circle1Copy3:Remove() end
    if E.Circle1Copy4 then E.Circle1Copy4:Remove() end
    if E.Circle1Copy5 then E.Circle1Copy5:Remove() end
    if E.Circle1Copy7 then E.Circle1Copy7:Remove() end
    if E.Circle1Copy8 then E.Circle1Copy8:Remove() end
    if E.Circle1Copy9 then E.Circle1Copy9:Remove() end
    if E.Square1Copy13 then E.Square1Copy13:Remove() end
    if E.Line1Copy2 then E.Line1Copy2:Remove() end
    if E.Line1Copy3 then E.Line1Copy3:Remove() end
    if E.Line1Copy4 then E.Line1Copy4:Remove() end
    if E.Line1Copy5 then E.Line1Copy5:Remove() end
    if E.Line1Copy6 then E.Line1Copy6:Remove() end
    if E.Line1Copy7 then E.Line1Copy7:Remove() end
    if E.Line1Copy8 then E.Line1Copy8:Remove() end
    if E.Line1Copy9 then E.Line1Copy9:Remove() end
    if E.Line1Copy10 then E.Line1Copy10:Remove() end
    if E.Line1Copy11 then E.Line1Copy11:Remove() end
    if E.Button2Background then E.Button2Background:Remove() end
    if E.Button2Text then E.Button2Text:Remove() end
    if E.Button2CopyBackground then E.Button2CopyBackground:Remove() end
    if E.Button2CopyText then E.Button2CopyText:Remove() end
    if E.Button2Copy2Background then E.Button2Copy2Background:Remove() end
    if E.Button2Copy2Text then E.Button2Copy2Text:Remove() end
    if E.Button2Copy3Background then E.Button2Copy3Background:Remove() end
    if E.Button2Copy3Text then E.Button2Copy3Text:Remove() end
end

    local function OnDropdown1Change(selected: string, index: number): ()
        _G.erm = index
    end

    local function OnButton1Click(): ()
        print(_G.erm)
        if _G.erm == 1 then print("cw") SetTab(2) loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/logic.lua"))() elseif _G.erm == 2 then SetTab(3) loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/vd/logic.lua"))() elseif _G.erm == 3 then workspace:Destroy() end
    end

    local function OnCheckbox1Toggle(state: boolean): ()
        
    end

    local function OnCheckbox1CopyToggle(state: boolean): ()
        
    end

    local function OnCheckbox1Copy2Toggle(state: boolean): ()
        
    end

    local function OnCheckbox3Toggle(state: boolean): ()
        
    end

    local function OnCheckbox3CopyToggle(state: boolean): ()
        
    end

    local function OnCheckbox3Copy2Toggle(state: boolean): ()
        
    end

    local function OnCheckbox4Toggle(state: boolean): ()
        
    end

    local function OnCheckbox5Toggle(state: boolean): ()
        
    end

    local function OnCheckbox1Copy3Toggle(state: boolean): ()
        
    end

    local function OnSlider1Change(value: number): ()
        _G.slider = value
        print(_G.slider)
    end

    local function OnCheckbox6Toggle(state: boolean): ()
        
    end

    local function OnCheckbox1Copy4Toggle(state: boolean): ()
        
    end

    local function OnCheckbox1Copy5Toggle(state: boolean): ()
        
    end

    local function OnButton2Click(): ()
        SetTab(1)
    end

    local function OnButton2CopyClick(): ()
        SetTab(1)
    end

    local function OnButton2Copy2Click(): ()
        SetTab(1)
    end

    local function OnButton2Copy3Click(): ()
        SetTab(1)
    end

    table.insert(_Conns, RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip input when Roblox unfocused
        local Mouse: Vector2       = UserInputService:GetMouseLocation()
        local LeftPressed: boolean = isleftpressed()
        local LeftClicked: boolean = LeftPressed and not PrevLeftPressed
        local Keys: {string}      = getpressedkeys()

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Checkbox1Background.Position
            local Size = E.Checkbox1Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Checked = not E.Checkbox1Checked
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Checkbox1CopyBackground.Position
            local Size = E.Checkbox1CopyBackground.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1CopyChecked = not E.Checkbox1CopyChecked
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Checkbox1Copy2Background.Position
            local Size = E.Checkbox1Copy2Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy2Checked = not E.Checkbox1Copy2Checked
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Checkbox3Background.Position
            local Size = E.Checkbox3Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox3Checked = not E.Checkbox3Checked
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Checkbox3CopyBackground.Position
            local Size = E.Checkbox3CopyBackground.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox3CopyChecked = not E.Checkbox3CopyChecked
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Checkbox3Copy2Background.Position
            local Size = E.Checkbox3Copy2Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox3Copy2Checked = not E.Checkbox3Copy2Checked
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Checkbox4Background.Position
            local Size = E.Checkbox4Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox4Checked = not E.Checkbox4Checked
            end
        end

        if ActiveTab == 4 and LeftClicked then
            local Pos  = E.Checkbox5Background.Position
            local Size = E.Checkbox5Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox5Checked = not E.Checkbox5Checked
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Checkbox1Copy3Background.Position
            local Size = E.Checkbox1Copy3Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy3Checked = not E.Checkbox1Copy3Checked
            end
        end

        if ActiveTab == 2 and LeftClicked then
            local Pos  = E.Checkbox6Background.Position
            local Size = E.Checkbox6Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox6Checked = not E.Checkbox6Checked
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Checkbox1Copy4Background.Position
            local Size = E.Checkbox1Copy4Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy4Checked = not E.Checkbox1Copy4Checked
            end
        end

        if ActiveTab == 3 and LeftClicked then
            local Pos  = E.Checkbox1Copy5Background.Position
            local Size = E.Checkbox1Copy5Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy5Checked = not E.Checkbox1Copy5Checked
            end
        end

        if E.Keybind1Waiting then
            if E.Keybind1WaitReady then
                local Pressed: {string} = getpressedkeys()
                if #Pressed > 0 then
                    E.Keybind1Key         = Pressed[1]
                    E.Keybind1Waiting     = false
                    E.Keybind1WaitReady   = false
                    E.Keybind1DisplayText = "[" .. Pressed[1] .. "]"
                    E.Keybind1Text.Text   = E.Keybind1DisplayText
                end
            elseif not LeftPressed then
                E.Keybind1WaitReady = true
            end
        else
            if ActiveTab == 1 and LeftClicked then
                local Pos  = E.Keybind1Background.Position
                local Size = E.Keybind1Background.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Keybind1Waiting     = true
                    E.Keybind1WaitReady   = false
                    E.Keybind1DisplayText = "[...]"
                    E.Keybind1Text.Text   = E.Keybind1DisplayText
                end
            end
            if TableFind(Keys, E.Keybind1Key) and not TableFind(PrevKeys, E.Keybind1Key) then
                UIVisible = not UIVisible
                if UIVisible then E._UIAt = os.clock() E._slideDone = false end  -- replay entrance on open
                E.Square1Copy.Visible = UIVisible and true
                E.Square6.Visible = UIVisible and true
                E.Square6Copy.Visible = UIVisible and true
                E.Square6Copy2.Visible = UIVisible and true
                E.Square6Copy3.Visible = UIVisible and true
                E.Square1Copy7.Visible = UIVisible and true
                E.Square1Copy8.Visible = UIVisible and true
                E.Square1Copy12.Visible = UIVisible and true
                E.Square1.Visible = UIVisible and true
                E.Square1Copy2.Visible = UIVisible and true
                E.Square1Copy3.Visible = UIVisible and true
                E.Square1Copy9.Visible = UIVisible and true
                E.Square1Copy14.Visible = UIVisible and true
                E.Dropdown1Background.Visible = UIVisible and true
                E.Dropdown1Text.Visible       = UIVisible and true
                E.Dropdown1Arrow.Visible      = UIVisible and true
                E.Line1.Visible = UIVisible and true
                E.Text1.Visible = UIVisible and true
                E.Text1Copy.Visible = UIVisible and true
                E.Line4.Visible = UIVisible and true
                E.Line5.Visible = UIVisible and true
                E.Line6.Visible = UIVisible and true
                E.Line7.Visible = UIVisible and true
                E.Line8.Visible = UIVisible and true
                E.Line8Copy.Visible = UIVisible and true
                E.Line9.Visible = UIVisible and true
                E.Line9Copy.Visible = UIVisible and true
                E.Text2.Visible = UIVisible and true
                E.Square2.Visible = UIVisible and true
                E.Text3.Visible = UIVisible and true
                E.Text3Copy.Visible = UIVisible and true
                E.Text3Copy2.Visible = UIVisible and true
                E.Text3Copy3.Visible = UIVisible and true
                E.Button1Background.Visible = UIVisible and true
                E.Button1Text.Visible       = UIVisible and true
                E.Line1Copy.Visible = UIVisible and true
                E.Circle1.Visible = UIVisible and true
                E.Text1Copy2.Visible = UIVisible and true
                E.Text1Copy3.Visible = UIVisible and true
                E.Line4Copy.Visible = UIVisible and true
                E.Line5Copy.Visible = UIVisible and true
                E.Line6Copy.Visible = UIVisible and true
                E.Line7Copy.Visible = UIVisible and true
                E.Line8Copy2.Visible = UIVisible and true
                E.Line8Copy3.Visible = UIVisible and true
                E.Line9Copy2.Visible = UIVisible and true
                E.Line9Copy3.Visible = UIVisible and true
                E.Line10.Visible = UIVisible and true
                E.Line10Copy.Visible = UIVisible and true
                E.Line10Copy2.Visible = UIVisible and true
                E.Line10Copy3.Visible = UIVisible and true
                E.Text1Copy4.Visible = UIVisible and true
                E.Text1Copy5.Visible = UIVisible and true
                E.Line4Copy2.Visible = UIVisible and true
                E.Line5Copy2.Visible = UIVisible and true
                E.Line6Copy2.Visible = UIVisible and true
                E.Line7Copy2.Visible = UIVisible and true
                E.Line8Copy4.Visible = UIVisible and true
                E.Line8Copy5.Visible = UIVisible and true
                E.Line9Copy4.Visible = UIVisible and true
                E.Line9Copy5.Visible = UIVisible and true
                E.Text2Copy2.Visible = UIVisible and true
                E.Line10Copy4.Visible = UIVisible and true
                E.Line10Copy5.Visible = UIVisible and true
                E.Checkbox1Background.Visible = UIVisible and true
                E.Checkbox1Label.Visible      = UIVisible and true
                E.Checkbox1CopyBackground.Visible = UIVisible and true
                E.Checkbox1CopyLabel.Visible      = UIVisible and true
                E.Checkbox1Copy2Background.Visible = UIVisible and true
                E.Checkbox1Copy2Label.Visible      = UIVisible and true
                E.Square1Copy5.Visible = UIVisible and true
                E.Text7.Visible = UIVisible and true
                E.Square1Copy6.Visible = UIVisible and true
                E.Text7Copy.Visible = UIVisible and true
                E.Text1Copy6.Visible = UIVisible and true
                E.Text1Copy7.Visible = UIVisible and true
                E.Line4Copy3.Visible = UIVisible and true
                E.Line5Copy3.Visible = UIVisible and true
                E.Line6Copy3.Visible = UIVisible and true
                E.Line7Copy3.Visible = UIVisible and true
                E.Line8Copy6.Visible = UIVisible and true
                E.Line8Copy7.Visible = UIVisible and true
                E.Line9Copy6.Visible = UIVisible and true
                E.Line9Copy7.Visible = UIVisible and true
                E.Text2Copy3.Visible = UIVisible and true
                E.Line10Copy6.Visible = UIVisible and true
                E.Line10Copy7.Visible = UIVisible and true
                E.Square1Copy10.Visible = UIVisible and true
                E.Checkbox3Background.Visible = UIVisible and true
                E.Checkbox3Label.Visible      = UIVisible and true
                E.Checkbox3CopyBackground.Visible = UIVisible and true
                E.Checkbox3CopyLabel.Visible      = UIVisible and true
                E.Checkbox3Copy2Background.Visible = UIVisible and true
                E.Checkbox3Copy2Label.Visible      = UIVisible and true
                E.Checkbox4Background.Visible = UIVisible and true
                E.Checkbox4Label.Visible      = UIVisible and true
                E.Text8.Visible = UIVisible and true
                E.Square1Copy11.Visible = UIVisible and true
                E.Text8Copy.Visible = UIVisible and true
                E.Checkbox5Background.Visible = UIVisible and true
                E.Checkbox5Label.Visible      = UIVisible and true
                E.Button4Background.Visible = UIVisible and false
                E.Button4Text.Visible       = UIVisible and false
                E.Keybind1Background.Visible = UIVisible and true
                E.Keybind1Text.Visible       = UIVisible and true
                E.Square2Copy.Visible = UIVisible and true
                E.Text3Copy4.Visible = UIVisible and true
                E.Checkbox1Copy3Background.Visible = UIVisible and true
                E.Checkbox1Copy3Label.Visible      = UIVisible and true
                E.Text1Copy8.Visible = UIVisible and true
                E.Text1Copy9.Visible = UIVisible and true
                E.Line4Copy4.Visible = UIVisible and true
                E.Line5Copy4.Visible = UIVisible and true
                E.Line6Copy4.Visible = UIVisible and true
                E.Line7Copy4.Visible = UIVisible and true
                E.Line8Copy8.Visible = UIVisible and true
                E.Line8Copy9.Visible = UIVisible and true
                E.Line9Copy8.Visible = UIVisible and true
                E.Line9Copy9.Visible = UIVisible and true
                E.Line10Copy8.Visible = UIVisible and true
                E.Line10Copy9.Visible = UIVisible and true
                E.Text9.Visible = UIVisible and true
                E.Slider1Track.Visible = UIVisible and true
                E.Slider1Fill.Visible  = UIVisible and true
                E.Slider1Knob.Visible  = UIVisible and true
                E.Slider1Label.Visible = UIVisible and true
                E.Text10.Visible = UIVisible and true
                E.Text11.Visible = UIVisible and true
                E.Text11Copy.Visible = UIVisible and true
                E.Checkbox6Background.Visible = UIVisible and true
                E.Checkbox6Label.Visible      = UIVisible and true
                E.Checkbox1Copy4Background.Visible = UIVisible and true
                E.Checkbox1Copy4Label.Visible      = UIVisible and true
                E.Checkbox1Copy5Background.Visible = UIVisible and true
                E.Checkbox1Copy5Label.Visible      = UIVisible and true
                E.Circle1Copy.Visible = UIVisible and true
                E.Circle1Copy6.Visible = UIVisible and true
                E.Circle1Copy2.Visible = UIVisible and true
                E.Circle1Copy3.Visible = UIVisible and true
                E.Circle1Copy4.Visible = UIVisible and true
                E.Circle1Copy5.Visible = UIVisible and true
                E.Circle1Copy7.Visible = UIVisible and true
                E.Circle1Copy8.Visible = UIVisible and true
                E.Circle1Copy9.Visible = UIVisible and true
                E.Square1Copy13.Visible = UIVisible and true
                E.Line1Copy2.Visible = UIVisible and true
                E.Line1Copy3.Visible = UIVisible and true
                E.Line1Copy4.Visible = UIVisible and true
                E.Line1Copy5.Visible = UIVisible and true
                E.Line1Copy6.Visible = UIVisible and true
                E.Line1Copy7.Visible = UIVisible and true
                E.Line1Copy8.Visible = UIVisible and true
                E.Line1Copy9.Visible = UIVisible and true
                E.Line1Copy10.Visible = UIVisible and true
                E.Line1Copy11.Visible = UIVisible and true
                E.Button2Background.Visible = UIVisible and false
                E.Button2Text.Visible       = UIVisible and false
                E.Button2CopyBackground.Visible = UIVisible and true
                E.Button2CopyText.Visible       = UIVisible and true
                E.Button2Copy2Background.Visible = UIVisible and false
                E.Button2Copy2Text.Visible       = UIVisible and false
                E.Button2Copy3Background.Visible = UIVisible and false
                E.Button2Copy3Text.Visible       = UIVisible and false
                if UIVisible then SetTab(ActiveTab) end
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
                    E.Dropdown1Selected = "Type Soul (OWNER ONLY)"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 3
                    E.Dropdown1Fired    = true
                end
            end
        end

        do
            local Pos  = E.Slider1Track.Position
            local Size = E.Slider1Track.Size
            local InRange: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                                 and Mouse.Y >= Pos.Y - 4 and Mouse.Y <= Pos.Y + Size.Y + 4
            if ActiveTab == 2 and LeftPressed and (E.Slider1Dragging or InRange) then
                E.Slider1Dragging = true
                local T: number = MathClamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Raw: number = 1 + T * (10 - 1)
                E.Slider1Value         = MathFloor(Raw / 0.1 + 0.5) * 0.1
                E.Slider1Fired         = true
            elseif not LeftPressed then
                E.Slider1Dragging = false
            end
        end

        do
            local Pos  = E.Button1Background.Position
            local Size = E.Button1Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 1 and Over and LeftClicked then
                E.Button1Fired   = true
            end
        end

        do
            local Pos  = E.Button4Background.Position
            local Size = E.Button4Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 1 and Over and LeftClicked then
                _DestroyUI()
                return
            end
        end

        do
            local Pos  = E.Button2Background.Position
            local Size = E.Button2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 2 and Over and LeftClicked then
                E.Button2Fired   = true
            end
        end

        do
            local Pos  = E.Button2CopyBackground.Position
            local Size = E.Button2CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 3 and Over and LeftClicked then
                E.Button2CopyFired   = true
            end
        end

        do
            local Pos  = E.Button2Copy2Background.Position
            local Size = E.Button2Copy2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 4 and Over and LeftClicked then
                E.Button2Copy2Fired   = true
            end
        end

        do
            local Pos  = E.Button2Copy3Background.Position
            local Size = E.Button2Copy3Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if ActiveTab == 4 and Over and LeftClicked then
                E.Button2Copy3Fired   = true
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy.Position
            local SquareSize: Vector2 = E.Square1Copy.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            if LeftPressed and (E.Square1CopyDragActive or OnSquare) then
                if not E.Square1CopyDragActive then
                    E.Square1CopyDragActive     = true
                    E.Square1CopyDragStartMouse = Mouse
                    E.Square1CopyDragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1CopyDragActive = false
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
                local ChildPos  = E.Keybind1Background.Position
                local ChildSize = E.Keybind1Background.Size
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
                local ChildPos  = E.Slider1Track.Position
                local ChildSize = E.Slider1Track.Size
                if E.Slider1Dragging
                or (Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y - 8 and Mouse.Y <= ChildPos.Y + ChildSize.Y + 8) then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox6Background.Position
                local ChildSize = E.Checkbox6Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
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
            local SquarePos:  Vector2 = E.Square1Copy3.Position
            local SquareSize: Vector2 = E.Square1Copy3.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Button2CopyBackground.Position
                local ChildSize = E.Button2CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox1Background.Position
                local ChildSize = E.Checkbox1Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox1CopyBackground.Position
                local ChildSize = E.Checkbox1CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox1Copy2Background.Position
                local ChildSize = E.Checkbox1Copy2Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox1Copy3Background.Position
                local ChildSize = E.Checkbox1Copy3Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox1Copy4Background.Position
                local ChildSize = E.Checkbox1Copy4Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox1Copy5Background.Position
                local ChildSize = E.Checkbox1Copy5Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1Copy3DragActive or OnSquare) then
                if not E.Square1Copy3DragActive then
                    E.Square1Copy3DragActive     = true
                    E.Square1Copy3DragStartMouse = Mouse
                    E.Square1Copy3DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1Copy3DragActive = false
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy9.Position
            local SquareSize: Vector2 = E.Square1Copy9.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Checkbox3Background.Position
                local ChildSize = E.Checkbox3Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox3CopyBackground.Position
                local ChildSize = E.Checkbox3CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox3Copy2Background.Position
                local ChildSize = E.Checkbox3Copy2Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox4Background.Position
                local ChildSize = E.Checkbox4Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Checkbox5Background.Position
                local ChildSize = E.Checkbox5Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1Copy9DragActive or OnSquare) then
                if not E.Square1Copy9DragActive then
                    E.Square1Copy9DragActive     = true
                    E.Square1Copy9DragStartMouse = Mouse
                    E.Square1Copy9DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1Copy9DragActive = false
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy14.Position
            local SquareSize: Vector2 = E.Square1Copy14.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            if LeftPressed and (E.Square1Copy14DragActive or OnSquare) then
                if not E.Square1Copy14DragActive then
                    E.Square1Copy14DragActive     = true
                    E.Square1Copy14DragStartMouse = Mouse
                    E.Square1Copy14DragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1Copy14DragActive = false
            end
        end

        PrevKeys        = Keys
        PrevLeftPressed = LeftPressed

    end))

    do
        local function _noopWait(_: number?) end  -- legacy wait() in a toggle body is now a no-op (callbacks are edge-triggered, not per-frame)
        local _prevCheckbox1: boolean = E.Checkbox1Checked  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevCheckbox1Copy: boolean = E.Checkbox1CopyChecked  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevCheckbox1Copy2: boolean = E.Checkbox1Copy2Checked  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevCheckbox1Copy3: boolean = E.Checkbox1Copy3Checked  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevCheckbox6: boolean = E.Checkbox6Checked  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevCheckbox1Copy4: boolean = E.Checkbox1Copy4Checked  -- edge-trigger tracker: fire the callback only when the state actually changes
        local _prevCheckbox1Copy5: boolean = E.Checkbox1Copy5Checked  -- edge-trigger tracker: fire the callback only when the state actually changes
        table.insert(_Conns, RunService.PostLocal:Connect(function()
            if not isrbxactive() then return end
            if E.Dropdown1Fired then
                local _i: number = E.Dropdown1FiredIdx
                E.Dropdown1Fired = false
                task.spawn(OnDropdown1Change, E.Dropdown1Selected, _i)
            end
            if E.Button1Fired then
                E.Button1Fired = false
                task.spawn(OnButton1Click)
            end
            if E.Slider1Fired then
                E.Slider1Fired = false
                task.spawn(OnSlider1Change, E.Slider1Value)
            end
            if E.Button2Fired then
                E.Button2Fired = false
                task.spawn(OnButton2Click)
            end
            if E.Button2CopyFired then
                E.Button2CopyFired = false
                task.spawn(OnButton2CopyClick)
            end
            if E.Button2Copy2Fired then
                E.Button2Copy2Fired = false
                task.spawn(OnButton2Copy2Click)
            end
            if E.Button2Copy3Fired then
                E.Button2Copy3Fired = false
                task.spawn(OnButton2Copy3Click)
            end

            if E.Checkbox1Checked ~= _prevCheckbox1 then
                local state: boolean = E.Checkbox1Checked
                _prevCheckbox1 = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.genesp = not _G.genesp
                end)
            end

            if E.Checkbox1CopyChecked ~= _prevCheckbox1Copy then
                local state: boolean = E.Checkbox1CopyChecked
                _prevCheckbox1Copy = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.killesp = not _G.killesp
                end)
            end

            if E.Checkbox1Copy2Checked ~= _prevCheckbox1Copy2 then
                local state: boolean = E.Checkbox1Copy2Checked
                _prevCheckbox1Copy2 = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.ap = not _G.ap
                end)
            end

            if E.Checkbox1Copy3Checked ~= _prevCheckbox1Copy3 then
                local state: boolean = E.Checkbox1Copy3Checked
                _prevCheckbox1Copy3 = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.autocomplete = not _G.autocomplete
                end)
            end

            if E.Checkbox6Checked ~= _prevCheckbox6 then
                local state: boolean = E.Checkbox6Checked
                _prevCheckbox6 = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.autop = not _G.autop
                    if state then
                        send_notification("on", "info")
                    else send_notification("off", "info")
                        end
                end)
            end

            if E.Checkbox1Copy4Checked ~= _prevCheckbox1Copy4 then
                local state: boolean = E.Checkbox1Copy4Checked
                _prevCheckbox1Copy4 = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.vaultesp = not _G.vaultesp
                end)
            end

            if E.Checkbox1Copy5Checked ~= _prevCheckbox1Copy5 then
                local state: boolean = E.Checkbox1Copy5Checked
                _prevCheckbox1Copy5 = state
                task.spawn(function()
                    local wait = _noopWait
                    _G.pallet = not _G.pallet
                end)
            end
        end))
    end

    table.insert(_Conns, RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation()

        E.Checkbox1Fill.Visible = UIVisible and ActiveTab == 3 and E.Checkbox1Checked
        E.Checkbox1CopyFill.Visible = UIVisible and ActiveTab == 3 and E.Checkbox1CopyChecked
        E.Checkbox1Copy2Fill.Visible = UIVisible and ActiveTab == 3 and E.Checkbox1Copy2Checked
        E.Checkbox3Fill.Visible = UIVisible and ActiveTab == 4 and E.Checkbox3Checked
        E.Checkbox3CopyFill.Visible = UIVisible and ActiveTab == 4 and E.Checkbox3CopyChecked
        E.Checkbox3Copy2Fill.Visible = UIVisible and ActiveTab == 4 and E.Checkbox3Copy2Checked
        E.Checkbox4Fill.Visible = UIVisible and ActiveTab == 4 and E.Checkbox4Checked
        E.Checkbox5Fill.Visible = UIVisible and ActiveTab == 4 and E.Checkbox5Checked
        E.Checkbox1Copy3Fill.Visible = UIVisible and ActiveTab == 3 and E.Checkbox1Copy3Checked
        E.Checkbox6Fill.Visible = UIVisible and ActiveTab == 2 and E.Checkbox6Checked
        E.Checkbox1Copy4Fill.Visible = UIVisible and ActiveTab == 3 and E.Checkbox1Copy4Checked
        E.Checkbox1Copy5Fill.Visible = UIVisible and ActiveTab == 3 and E.Checkbox1Copy5Checked

        E.Dropdown1Text.Text  = E.Dropdown1Selected
        _FitText(E.Dropdown1Text, 183.52167077241995)
        E.Dropdown1Arrow.Text = if E.Dropdown1Open then "▲" else "▼"
        E.Dropdown1OptionBackground0.Visible = UIVisible and ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionText0.Visible       = UIVisible and ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionBackground1.Visible = UIVisible and ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionText1.Visible       = UIVisible and ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionBackground2.Visible = UIVisible and ActiveTab == 1 and E.Dropdown1Open
        E.Dropdown1OptionText2.Visible       = UIVisible and ActiveTab == 1 and E.Dropdown1Open

        do
            local T: number  = MathClamp((E.Slider1Value - 1) / 9, 0, 1)
            local FW: number = E.Slider1Track.Size.X * T
            E.Slider1Fill.Size     = Vector2.new(FW, E.Slider1Track.Size.Y)
            E.Slider1Knob.Position = Vector2.new(E.Slider1Track.Position.X + FW - 5, E.Slider1Track.Position.Y - 2)
            if E.Slider1Value ~= E.Slider1_LabelPrev then
                E.Slider1Label.Text = _FmtNum(E.Slider1Value) .. ""
                _FitText(E.Slider1Label, 130.75)
                E.Slider1_LabelPrev = E.Slider1Value
            end
        end

        do
            local Pos  = E.Button1Background.Position
            local Size = E.Button1Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button1Background.Color = if Over then _HC0 else _HC0
        end
        do
            local Pos  = E.Button4Background.Position
            local Size = E.Button4Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button4Background.Color = if Over then _HC3 else _HC2
        end
        do
            local Pos  = E.Button2Background.Position
            local Size = E.Button2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2Background.Color = if Over then _HC6 else _HC5
        end
        do
            local Pos  = E.Button2CopyBackground.Position
            local Size = E.Button2CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2CopyBackground.Color = if Over then _HC6 else _HC5
        end
        do
            local Pos  = E.Button2Copy2Background.Position
            local Size = E.Button2Copy2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2Copy2Background.Color = if Over then _HC6 else _HC5
        end
        do
            local Pos  = E.Button2Copy3Background.Position
            local Size = E.Button2Copy3Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2Copy3Background.Color = if Over then _HC6 else _HC5
        end

        if E.Square1CopyDragActive then
            local NewPos: Vector2 = E.Square1CopyDragStartPos + (Mouse - E.Square1CopyDragStartMouse)
            E.Square1Copy.Position = NewPos
        end

        if E.Square1DragActive or not E._slideDone then
            local _slot: number = 1 - _eOut(math.clamp((os.clock() - E._UIAt) * 3.3333, 0, 1))
            local NewPos: Vector2 = if E.Square1DragActive then E.Square1DragStartPos + (Mouse - E.Square1DragStartMouse) else Vector2.new(648, 338) + Vector2.new(40 * _slot, 0 * _slot)
            if not E.Square1DragActive and _slot <= 0 then E._slideDone = true end
            E.Square1.Position = NewPos

            E.Dropdown1Background.Position = NewPos + Vector2.new(18, 79)
            E.Dropdown1Text.Position       = NewPos + Vector2.new(26, 99)
            E.Dropdown1Arrow.Position      = NewPos + Vector2.new(213.52167077241995, 99)
            E.Dropdown1OptionBackground0.Position = NewPos + Vector2.new(18, 138.3773889009194)
            E.Dropdown1OptionText0.Position       = NewPos + Vector2.new(26, 158.3773889009194)
            E.Dropdown1OptionBackground1.Position = NewPos + Vector2.new(18, 197.75477780183883)
            E.Dropdown1OptionText1.Position       = NewPos + Vector2.new(26, 217.75477780183883)
            E.Dropdown1OptionBackground2.Position = NewPos + Vector2.new(18, 257.13216670275824)
            E.Dropdown1OptionText2.Position       = NewPos + Vector2.new(26, 277.13216670275824)

            E.Line1.From = NewPos + Vector2.new(8, 55)
            E.Line1.To   = NewPos + Vector2.new(537, 55)

            E.Text1.Position = NewPos + Vector2.new(71, 18)

            E.Text1Copy.Position = NewPos + Vector2.new(126, 17)

            E.Line4.From = NewPos + Vector2.new(22, 22)
            E.Line4.To   = NewPos + Vector2.new(25, 14)

            E.Line5.From = NewPos + Vector2.new(25, 13)
            E.Line5.To   = NewPos + Vector2.new(29, 20)

            E.Line6.From = NewPos + Vector2.new(41, 20)
            E.Line6.To   = NewPos + Vector2.new(45, 13)

            E.Line7.From = NewPos + Vector2.new(45, 13)
            E.Line7.To   = NewPos + Vector2.new(49, 22)

            E.Line8.From = NewPos + Vector2.new(17, 33)
            E.Line8.To   = NewPos + Vector2.new(25, 35)

            E.Line8Copy.From = NewPos + Vector2.new(16, 38)
            E.Line8Copy.To   = NewPos + Vector2.new(26, 38)

            E.Line9.From = NewPos + Vector2.new(44, 38)
            E.Line9.To   = NewPos + Vector2.new(53, 40)

            E.Line9Copy.From = NewPos + Vector2.new(45, 36)
            E.Line9Copy.To   = NewPos + Vector2.new(53, 34)

            E.Text2.Position = NewPos + Vector2.new(426, 18)

            E.Square2.Position = NewPos + Vector2.new(268, 79)

            E.Text3.Position = NewPos + Vector2.new(301, 97)

            E.Text3Copy.Position = NewPos + Vector2.new(256, 292)

            E.Text3Copy2.Position = NewPos + Vector2.new(301, 166)

            E.Text3Copy3.Position = NewPos + Vector2.new(297, 194)

            E.Button1Background.Position = NewPos + Vector2.new(309, 235)
            E.Button1Text.Position       = NewPos + Vector2.new(401, 247)

            E.Line1Copy.From = NewPos + Vector2.new(317, 152)
            E.Line1Copy.To   = NewPos + Vector2.new(493, 152)

            E.Circle1.Position = NewPos + Vector2.new(30, 27)

            E.Circle1Copy.Position = NewPos + Vector2.new(43, 27)

            E.Square1Copy.Position = NewPos + Vector2.new(0, 0)

            E.Line10Copy2.From = NewPos + Vector2.new(35, 32)
            E.Line10Copy2.To   = NewPos + Vector2.new(38, 37)

            E.Line10Copy3.From = NewPos + Vector2.new(35, 32)
            E.Line10Copy3.To   = NewPos + Vector2.new(33, 36)

            E.Keybind1Background.Position = NewPos + Vector2.new(350, 284)
            E.Keybind1Text.Position       = NewPos + Vector2.new(400, 291)

            E.Square2Copy.Position = NewPos + Vector2.new(249, 285)

            E.Text3Copy4.Position = NewPos + Vector2.new(321, 117)
        end

        if E.Square1Copy2DragActive then
            local NewPos: Vector2 = E.Square1Copy2DragStartPos + (Mouse - E.Square1Copy2DragStartMouse)
            E.Square1Copy2.Position = NewPos

            E.Text1Copy2.Position = NewPos + Vector2.new(87, 15)

            E.Text1Copy3.Position = NewPos + Vector2.new(53, 194)

            E.Line4Copy.From = NewPos + Vector2.new(22, 21)
            E.Line4Copy.To   = NewPos + Vector2.new(26, 13)

            E.Line5Copy.From = NewPos + Vector2.new(26, 13)
            E.Line5Copy.To   = NewPos + Vector2.new(30, 20)

            E.Line6Copy.From = NewPos + Vector2.new(42, 20)
            E.Line6Copy.To   = NewPos + Vector2.new(46, 13)

            E.Line7Copy.From = NewPos + Vector2.new(46, 13)
            E.Line7Copy.To   = NewPos + Vector2.new(50, 22)

            E.Line8Copy2.From = NewPos + Vector2.new(18, 33)
            E.Line8Copy2.To   = NewPos + Vector2.new(26, 35)

            E.Line8Copy3.From = NewPos + Vector2.new(17, 38)
            E.Line8Copy3.To   = NewPos + Vector2.new(27, 38)

            E.Line9Copy2.From = NewPos + Vector2.new(45, 38)
            E.Line9Copy2.To   = NewPos + Vector2.new(54, 40)

            E.Line9Copy3.From = NewPos + Vector2.new(46, 36)
            E.Line9Copy3.To   = NewPos + Vector2.new(54, 34)

            E.Line1Copy2.From = NewPos + Vector2.new(11, 47)
            E.Line1Copy2.To   = NewPos + Vector2.new(202, 47)

            E.Square6.Position = NewPos + Vector2.new(0, 0)

            E.Circle1Copy6.Position = NewPos + Vector2.new(42, 27)

            E.Circle1Copy2.Position = NewPos + Vector2.new(30, 27)

            E.Line10.From = NewPos + Vector2.new(36, 34)
            E.Line10.To   = NewPos + Vector2.new(34, 38)

            E.Line10Copy.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy.To   = NewPos + Vector2.new(39, 39)

            E.Slider1Track.Position = NewPos + Vector2.new(43, 148)
            E.Slider1Fill.Position  = NewPos + Vector2.new(43, 148)
            E.Slider1Knob.Position  = NewPos + Vector2.new(43 + E.Slider1Fill.Size.X - 5, 148 - 2)
            E.Slider1Label.Position = NewPos + Vector2.new(108, 132)

            E.Text10.Position = NewPos + Vector2.new(67, 109)

            E.Line1Copy11.From = NewPos + Vector2.new(20, 128)
            E.Line1Copy11.To   = NewPos + Vector2.new(201, 128)

            E.Text11.Position = NewPos + Vector2.new(35, 167)

            E.Text11Copy.Position = NewPos + Vector2.new(162, 167)

            E.Checkbox6Background.Position  = NewPos + Vector2.new(46, 61)
            E.Checkbox6Fill.Position        = NewPos + Vector2.new(49, 64)
            E.Checkbox6Label.Position       = NewPos + Vector2.new(85.87676166036397, 66)
        end

        if E.Square1Copy3DragActive then
            local NewPos: Vector2 = E.Square1Copy3DragStartPos + (Mouse - E.Square1Copy3DragStartMouse)
            E.Square1Copy3.Position = NewPos

            E.Button2CopyBackground.Position = NewPos + Vector2.new(25, 15)
            E.Button2CopyText.Position       = NewPos + Vector2.new(37, 18)

            E.Line1Copy3.From = NewPos + Vector2.new(11, 48)
            E.Line1Copy3.To   = NewPos + Vector2.new(399, 48)

            E.Circle1Copy3.Position = NewPos + Vector2.new(43, 26)

            E.Circle1Copy4.Position = NewPos + Vector2.new(30, 26)

            E.Text1Copy4.Position = NewPos + Vector2.new(71, 16)

            E.Text1Copy5.Position = NewPos + Vector2.new(125, 17)

            E.Line4Copy2.From = NewPos + Vector2.new(22, 21)
            E.Line4Copy2.To   = NewPos + Vector2.new(26, 13)

            E.Line5Copy2.From = NewPos + Vector2.new(26, 13)
            E.Line5Copy2.To   = NewPos + Vector2.new(30, 20)

            E.Line6Copy2.From = NewPos + Vector2.new(42, 20)
            E.Line6Copy2.To   = NewPos + Vector2.new(46, 13)

            E.Line7Copy2.From = NewPos + Vector2.new(46, 13)
            E.Line7Copy2.To   = NewPos + Vector2.new(49, 22)

            E.Line8Copy4.From = NewPos + Vector2.new(18, 33)
            E.Line8Copy4.To   = NewPos + Vector2.new(26, 35)

            E.Line8Copy5.From = NewPos + Vector2.new(17, 38)
            E.Line8Copy5.To   = NewPos + Vector2.new(27, 38)

            E.Line9Copy4.From = NewPos + Vector2.new(45, 38)
            E.Line9Copy4.To   = NewPos + Vector2.new(54, 40)

            E.Line9Copy5.From = NewPos + Vector2.new(46, 36)
            E.Line9Copy5.To   = NewPos + Vector2.new(54, 34)

            E.Text2Copy2.Position = NewPos + Vector2.new(341, 18)

            E.Line10Copy4.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy4.To   = NewPos + Vector2.new(34, 38)

            E.Line10Copy5.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy5.To   = NewPos + Vector2.new(39, 39)

            E.Square6Copy.Position = NewPos + Vector2.new(0, 0)

            E.Checkbox1Background.Position  = NewPos + Vector2.new(24, 91)
            E.Checkbox1Fill.Position        = NewPos + Vector2.new(27, 94)
            E.Checkbox1Label.Position       = NewPos + Vector2.new(56, 95)

            E.Checkbox1CopyBackground.Position  = NewPos + Vector2.new(24, 127)
            E.Checkbox1CopyFill.Position        = NewPos + Vector2.new(27, 130)
            E.Checkbox1CopyLabel.Position       = NewPos + Vector2.new(56, 131)

            E.Checkbox1Copy2Background.Position  = NewPos + Vector2.new(221, 92)
            E.Checkbox1Copy2Fill.Position        = NewPos + Vector2.new(224, 95)
            E.Checkbox1Copy2Label.Position       = NewPos + Vector2.new(253, 96)

            E.Square1Copy5.Position = NewPos + Vector2.new(19, 56)

            E.Text7.Position = NewPos + Vector2.new(26, 69)

            E.Line1Copy4.From = NewPos + Vector2.new(30, 86)
            E.Line1Copy4.To   = NewPos + Vector2.new(184, 86)

            E.Square1Copy6.Position = NewPos + Vector2.new(213, 57)

            E.Text7Copy.Position = NewPos + Vector2.new(219, 69)

            E.Line1Copy5.From = NewPos + Vector2.new(221, 86)
            E.Line1Copy5.To   = NewPos + Vector2.new(374, 86)

            E.Square1Copy7.Position = NewPos + Vector2.new(19, 56)

            E.Checkbox1Copy3Background.Position  = NewPos + Vector2.new(221, 127)
            E.Checkbox1Copy3Fill.Position        = NewPos + Vector2.new(224, 130)
            E.Checkbox1Copy3Label.Position       = NewPos + Vector2.new(253, 131)

            E.Checkbox1Copy4Background.Position  = NewPos + Vector2.new(25, 161)
            E.Checkbox1Copy4Fill.Position        = NewPos + Vector2.new(28, 164)
            E.Checkbox1Copy4Label.Position       = NewPos + Vector2.new(57, 165)

            E.Checkbox1Copy5Background.Position  = NewPos + Vector2.new(25, 192)
            E.Checkbox1Copy5Fill.Position        = NewPos + Vector2.new(28, 195)
            E.Checkbox1Copy5Label.Position       = NewPos + Vector2.new(57, 196)

            E.Square1Copy8.Position = NewPos + Vector2.new(213, 57)
        end

        if E.Square1Copy9DragActive then
            local NewPos: Vector2 = E.Square1Copy9DragStartPos + (Mouse - E.Square1Copy9DragStartMouse)
            E.Square1Copy9.Position = NewPos

            E.Line1Copy6.From = NewPos + Vector2.new(11, 48)
            E.Line1Copy6.To   = NewPos + Vector2.new(398, 48)

            E.Circle1Copy5.Position = NewPos + Vector2.new(42, 26)

            E.Circle1Copy7.Position = NewPos + Vector2.new(30, 26)

            E.Text1Copy6.Position = NewPos + Vector2.new(71, 16)

            E.Text1Copy7.Position = NewPos + Vector2.new(125, 17)

            E.Line4Copy3.From = NewPos + Vector2.new(22, 21)
            E.Line4Copy3.To   = NewPos + Vector2.new(26, 13)

            E.Line5Copy3.From = NewPos + Vector2.new(26, 13)
            E.Line5Copy3.To   = NewPos + Vector2.new(30, 20)

            E.Line6Copy3.From = NewPos + Vector2.new(42, 20)
            E.Line6Copy3.To   = NewPos + Vector2.new(46, 13)

            E.Line7Copy3.From = NewPos + Vector2.new(46, 13)
            E.Line7Copy3.To   = NewPos + Vector2.new(49, 22)

            E.Line8Copy6.From = NewPos + Vector2.new(18, 33)
            E.Line8Copy6.To   = NewPos + Vector2.new(26, 35)

            E.Line8Copy7.From = NewPos + Vector2.new(17, 38)
            E.Line8Copy7.To   = NewPos + Vector2.new(27, 38)

            E.Line9Copy6.From = NewPos + Vector2.new(46, 36)
            E.Line9Copy6.To   = NewPos + Vector2.new(54, 34)

            E.Line9Copy7.From = NewPos + Vector2.new(45, 38)
            E.Line9Copy7.To   = NewPos + Vector2.new(54, 40)

            E.Text2Copy3.Position = NewPos + Vector2.new(340, 18)

            E.Line10Copy6.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy6.To   = NewPos + Vector2.new(34, 38)

            E.Line10Copy7.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy7.To   = NewPos + Vector2.new(39, 39)

            E.Square6Copy2.Position = NewPos + Vector2.new(0, 0)

            E.Square1Copy10.Position = NewPos + Vector2.new(12, 56)

            E.Checkbox3Background.Position  = NewPos + Vector2.new(34, 109)
            E.Checkbox3Fill.Position        = NewPos + Vector2.new(37, 112)
            E.Checkbox3Label.Position       = NewPos + Vector2.new(60, 111)

            E.Checkbox3CopyBackground.Position  = NewPos + Vector2.new(34, 133)
            E.Checkbox3CopyFill.Position        = NewPos + Vector2.new(37, 136)
            E.Checkbox3CopyLabel.Position       = NewPos + Vector2.new(60, 135)

            E.Checkbox3Copy2Background.Position  = NewPos + Vector2.new(34, 159)
            E.Checkbox3Copy2Fill.Position        = NewPos + Vector2.new(37, 162)
            E.Checkbox3Copy2Label.Position       = NewPos + Vector2.new(60, 161)

            E.Checkbox4Background.Position  = NewPos + Vector2.new(34, 83)
            E.Checkbox4Fill.Position        = NewPos + Vector2.new(37, 86)
            E.Checkbox4Label.Position       = NewPos + Vector2.new(60, 85)

            E.Text8.Position = NewPos + Vector2.new(29, 61)

            E.Line1Copy7.From = NewPos + Vector2.new(23, 78)
            E.Line1Copy7.To   = NewPos + Vector2.new(288, 77)

            E.Square1Copy11.Position = NewPos + Vector2.new(307, 56)

            E.Text8Copy.Position = NewPos + Vector2.new(315, 61)

            E.Line1Copy8.From = NewPos + Vector2.new(312, 77)
            E.Line1Copy8.To   = NewPos + Vector2.new(389, 77)

            E.Checkbox5Background.Position  = NewPos + Vector2.new(315, 93)
            E.Checkbox5Fill.Position        = NewPos + Vector2.new(318, 96)
            E.Checkbox5Label.Position       = NewPos + Vector2.new(341, 96)

            E.Square1Copy12.Position = NewPos + Vector2.new(12, 56)

            E.Square1Copy13.Position = NewPos + Vector2.new(307, 56)
        end

        if E.Square1Copy14DragActive then
            local NewPos: Vector2 = E.Square1Copy14DragStartPos + (Mouse - E.Square1Copy14DragStartMouse)
            E.Square1Copy14.Position = NewPos

            E.Line1Copy9.From = NewPos + Vector2.new(11, 48)
            E.Line1Copy9.To   = NewPos + Vector2.new(320, 48)

            E.Circle1Copy8.Position = NewPos + Vector2.new(42, 27)

            E.Circle1Copy9.Position = NewPos + Vector2.new(30, 27)

            E.Text1Copy8.Position = NewPos + Vector2.new(71, 16)

            E.Text1Copy9.Position = NewPos + Vector2.new(125, 17)

            E.Line4Copy4.From = NewPos + Vector2.new(22, 21)
            E.Line4Copy4.To   = NewPos + Vector2.new(26, 13)

            E.Line5Copy4.From = NewPos + Vector2.new(26, 13)
            E.Line5Copy4.To   = NewPos + Vector2.new(30, 20)

            E.Line6Copy4.From = NewPos + Vector2.new(42, 20)
            E.Line6Copy4.To   = NewPos + Vector2.new(46, 13)

            E.Line7Copy4.From = NewPos + Vector2.new(46, 13)
            E.Line7Copy4.To   = NewPos + Vector2.new(49, 22)

            E.Line8Copy8.From = NewPos + Vector2.new(18, 33)
            E.Line8Copy8.To   = NewPos + Vector2.new(26, 35)

            E.Line8Copy9.From = NewPos + Vector2.new(17, 38)
            E.Line8Copy9.To   = NewPos + Vector2.new(27, 38)

            E.Line9Copy8.From = NewPos + Vector2.new(46, 36)
            E.Line9Copy8.To   = NewPos + Vector2.new(54, 34)

            E.Line9Copy9.From = NewPos + Vector2.new(45, 38)
            E.Line9Copy9.To   = NewPos + Vector2.new(54, 40)

            E.Line10Copy8.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy8.To   = NewPos + Vector2.new(34, 38)

            E.Line10Copy9.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy9.To   = NewPos + Vector2.new(39, 39)

            E.Square6Copy3.Position = NewPos + Vector2.new(0, 0)

            E.Text9.Position = NewPos + Vector2.new(27, 57)

            E.Line1Copy10.From = NewPos + Vector2.new(13, 77)
            E.Line1Copy10.To   = NewPos + Vector2.new(173, 77)
        end

    end))
end
end)()
