--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor
local MathClamp  = math.clamp
local MathRound  = math.round

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
E.Slider1Track    = Drawing.new("Square")
E.Slider1Fill     = Drawing.new("Square")
E.Slider1Knob     = Drawing.new("Square")
E.Slider1Label    = Drawing.new("Text")
E.Slider1Value    = 50
E.Slider1Dragging = false
E.Slider1Fired    = false
E.Slider1_LabelPrev = 50
E.Slider1CopyTrack    = Drawing.new("Square")
E.Slider1CopyFill     = Drawing.new("Square")
E.Slider1CopyKnob     = Drawing.new("Square")
E.Slider1CopyLabel    = Drawing.new("Text")
E.Slider1CopyValue    = 50
E.Slider1CopyDragging = false
E.Slider1CopyFired    = false
E.Slider1Copy_LabelPrev = 50
E.Slider1Copy2Track    = Drawing.new("Square")
E.Slider1Copy2Fill     = Drawing.new("Square")
E.Slider1Copy2Knob     = Drawing.new("Square")
E.Slider1Copy2Label    = Drawing.new("Text")
E.Slider1Copy2Value    = 50
E.Slider1Copy2Dragging = false
E.Slider1Copy2Fired    = false
E.Slider1Copy2_LabelPrev = 50
E.Line1 = Drawing.new("Line")
E.Line2 = Drawing.new("Line")
E.Line3 = Drawing.new("Line")
E.Square2 = Drawing.new("Square")
E.Dropdown1Background = Drawing.new("Square")
E.Dropdown1Text       = Drawing.new("Text")
E.Dropdown1Arrow      = Drawing.new("Text")
E.Dropdown1Selected   = "Forcefield"
E.Dropdown1Options    = { "Forcefield", "Neon", "Cracked Lava", "Ice", "Glass" }
E.Dropdown1Open       = false
E.Dropdown1Fired      = false
E.Dropdown1FiredIdx   = 0
E.Dropdown1OptionBackground0 = Drawing.new("Square")
E.Dropdown1OptionText0       = Drawing.new("Text")
E.Dropdown1OptionBackground1 = Drawing.new("Square")
E.Dropdown1OptionText1       = Drawing.new("Text")
E.Dropdown1OptionBackground2 = Drawing.new("Square")
E.Dropdown1OptionText2       = Drawing.new("Text")
E.Dropdown1OptionBackground3 = Drawing.new("Square")
E.Dropdown1OptionText3       = Drawing.new("Text")
E.Dropdown1OptionBackground4 = Drawing.new("Square")
E.Dropdown1OptionText4       = Drawing.new("Text")
E.Dropdown1_OptBg     = { E.Dropdown1OptionBackground0, E.Dropdown1OptionBackground1, E.Dropdown1OptionBackground2, E.Dropdown1OptionBackground3, E.Dropdown1OptionBackground4 }
E.Dropdown1_OptTx     = { E.Dropdown1OptionText0, E.Dropdown1OptionText1, E.Dropdown1OptionText2, E.Dropdown1OptionText3, E.Dropdown1OptionText4 }

E.Square1DragActive     = false
E.Square1DragStartMouse = Vector2.new(0, 0)
E.Square1DragStartPos   = Vector2.new(0, 0)

do

    E.Square1.Position  = Vector2.new(737, 298)
    E.Square1.Size      = Vector2.new(468, 346)
    E.Square1.Color     = Color3.fromRGB(27, 24, 32)
    E.Square1.Opacity   = 1
    E.Square1.Filled    = true
    E.Square1.Thickness = 1
    E.Square1.ZIndex    = 0
    E.Square1.Visible   = true

    E.Slider1Track.Position  = Vector2.new(783, 360)
    E.Slider1Track.Size      = Vector2.new(200, 10)
    E.Slider1Track.Color     = Color3.fromRGB(255, 0, 0)
    E.Slider1Track.Opacity   = 0.30
    E.Slider1Track.Filled    = true
    E.Slider1Track.ZIndex    = 1
    E.Slider1Track.Visible   = true

    E.Slider1Fill.Position   = Vector2.new(783, 360)
    E.Slider1Fill.Size       = Vector2.new(39, 10)
    E.Slider1Fill.Color      = Color3.fromRGB(255, 0, 0)
    E.Slider1Fill.Filled     = true
    E.Slider1Fill.ZIndex     = 2
    E.Slider1Fill.Visible    = true

    E.Slider1Knob.Position   = Vector2.new(817, 358)
    E.Slider1Knob.Size       = Vector2.new(10, 14)
    E.Slider1Knob.Color      = Color3.fromRGB(255, 255, 255)
    E.Slider1Knob.Filled     = true
    E.Slider1Knob.Rounding   = 2
    E.Slider1Knob.ZIndex     = 3
    E.Slider1Knob.Visible    = true

    E.Slider1Label.Position  = Vector2.new(883, 344)
    E.Slider1Label.Text      = _FmtNum(E.Slider1Value) .. ""
    E.Slider1Label.Size      = 11
    E.Slider1Label.Font      = 0
    E.Slider1Label.Color     = Color3.fromRGB(255, 0, 0)
    E.Slider1Label.Center    = true
    E.Slider1Label.ZIndex    = 3
    E.Slider1Label.Visible   = true
    _FitText(E.Slider1Label, 200)

    E.Slider1CopyTrack.Position  = Vector2.new(783, 382)
    E.Slider1CopyTrack.Size      = Vector2.new(200, 10)
    E.Slider1CopyTrack.Color     = Color3.fromRGB(0, 255, 64)
    E.Slider1CopyTrack.Opacity   = 0.30
    E.Slider1CopyTrack.Filled    = true
    E.Slider1CopyTrack.ZIndex    = 1
    E.Slider1CopyTrack.Visible   = true

    E.Slider1CopyFill.Position   = Vector2.new(783, 382)
    E.Slider1CopyFill.Size       = Vector2.new(39, 10)
    E.Slider1CopyFill.Color      = Color3.fromRGB(0, 255, 64)
    E.Slider1CopyFill.Filled     = true
    E.Slider1CopyFill.ZIndex     = 2
    E.Slider1CopyFill.Visible    = true

    E.Slider1CopyKnob.Position   = Vector2.new(817, 380)
    E.Slider1CopyKnob.Size       = Vector2.new(10, 14)
    E.Slider1CopyKnob.Color      = Color3.fromRGB(255, 255, 255)
    E.Slider1CopyKnob.Filled     = true
    E.Slider1CopyKnob.Rounding   = 2
    E.Slider1CopyKnob.ZIndex     = 3
    E.Slider1CopyKnob.Visible    = true

    E.Slider1CopyLabel.Position  = Vector2.new(883, 366)
    E.Slider1CopyLabel.Text      = _FmtNum(E.Slider1CopyValue) .. ""
    E.Slider1CopyLabel.Size      = 11
    E.Slider1CopyLabel.Font      = 0
    E.Slider1CopyLabel.Color     = Color3.fromRGB(0, 255, 64)
    E.Slider1CopyLabel.Center    = true
    E.Slider1CopyLabel.ZIndex    = 3
    E.Slider1CopyLabel.Visible   = true
    _FitText(E.Slider1CopyLabel, 200)

    E.Slider1Copy2Track.Position  = Vector2.new(783, 406)
    E.Slider1Copy2Track.Size      = Vector2.new(200, 10)
    E.Slider1Copy2Track.Color     = Color3.fromRGB(17, 0, 255)
    E.Slider1Copy2Track.Opacity   = 0.30
    E.Slider1Copy2Track.Filled    = true
    E.Slider1Copy2Track.ZIndex    = 1
    E.Slider1Copy2Track.Visible   = true
   E.Square2.Position  = Vector2.new(1065, 371)
   E.Square2.Size      = Vector2.new(38, 37)
   E.Square2.Color     = Color3.fromRGB(255, 255, 255)
    E.Square2.Opacity   = 1
    E.Square2.Filled    = true
    E.Square2.Thickness = 1
    E.Square2.ZIndex    = 1
    E.Square2.Visible   = true
    E.Slider1Copy2Fill.Position   = Vector2.new(783, 406)
    E.Slider1Copy2Fill.Size       = Vector2.new(39, 10)
    E.Slider1Copy2Fill.Color      = Color3.fromRGB(17, 0, 255)
    E.Slider1Copy2Fill.Filled     = true
    E.Slider1Copy2Fill.ZIndex     = 2
    E.Slider1Copy2Fill.Visible    = true

    E.Slider1Copy2Knob.Position   = Vector2.new(817, 404)
    E.Slider1Copy2Knob.Size       = Vector2.new(10, 14)
    E.Slider1Copy2Knob.Color      = Color3.fromRGB(255, 255, 255)
    E.Slider1Copy2Knob.Filled     = true
    E.Slider1Copy2Knob.Rounding   = 2
    E.Slider1Copy2Knob.ZIndex     = 3
    E.Slider1Copy2Knob.Visible    = true

    E.Slider1Copy2Label.Position  = Vector2.new(883, 390)
    E.Slider1Copy2Label.Text      = _FmtNum(E.Slider1Copy2Value) .. ""
    E.Slider1Copy2Label.Size      = 11
    E.Slider1Copy2Label.Font      = 0
    E.Slider1Copy2Label.Color     = Color3.fromRGB(17, 0, 255)
    E.Slider1Copy2Label.Center    = true
    E.Slider1Copy2Label.ZIndex    = 3
    E.Slider1Copy2Label.Visible   = true
    _FitText(E.Slider1Copy2Label, 200)

    E.Line1.From      = Vector2.new(1003, 368)
    E.Line1.To        = Vector2.new(1047, 381)
    E.Line1.Color     = Color3.fromRGB(255, 255, 255)
    E.Line1.Opacity   = 1
    E.Line1.Thickness = 1
    E.Line1.ZIndex    = 1
    E.Line1.Visible   = true

    E.Line2.From      = Vector2.new(1003, 387)
    E.Line2.To        = Vector2.new(1047, 387)
    E.Line2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line2.Opacity   = 1
    E.Line2.Thickness = 1
    E.Line2.ZIndex    = 1
    E.Line2.Visible   = true

    E.Line3.From      = Vector2.new(1005, 408)
    E.Line3.To        = Vector2.new(1048, 394)
    E.Line3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line3.Opacity   = 1
    E.Line3.Thickness = 1
    E.Line3.ZIndex    = 1
    E.Line3.Visible   = true
    E.Dropdown1Background.Position  = Vector2.new(751, 440)
    E.Dropdown1Background.Size      = Vector2.new(150, 30)
    E.Dropdown1Background.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1Background.Filled    = true
    E.Dropdown1Background.Thickness = 1
    E.Dropdown1Background.ZIndex    = 1
    E.Dropdown1Background.Visible   = true

    E.Dropdown1Text.Position  = Vector2.new(759, 447)
    E.Dropdown1Text.Text      = E.Dropdown1Selected
    E.Dropdown1Text.Size      = 16
    E.Dropdown1Text.Font      = 2
    E.Dropdown1Text.Color     = Color3.fromRGB(0, 0, 0)
    E.Dropdown1Text.Outline   = true
    E.Dropdown1Text.OutlineColor = Vector3.new(0, 0, 0)
    E.Dropdown1Text.ZIndex    = 2
    E.Dropdown1Text.Visible   = true
    _FitText(E.Dropdown1Text, 122)

    E.Dropdown1Arrow.Position = Vector2.new(885, 447)
    E.Dropdown1Arrow.Text     = "▼"
    E.Dropdown1Arrow.Size     = 12
    E.Dropdown1Arrow.Font     = 2
    E.Dropdown1Arrow.Color    = Color3.fromRGB(0, 0, 0)
    E.Dropdown1Arrow.ZIndex   = 2
    E.Dropdown1Arrow.Visible  = true

    E.Dropdown1OptionBackground0.Position  = Vector2.new(751, 470)
    E.Dropdown1OptionBackground0.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground0.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1OptionBackground0.Filled    = true
    E.Dropdown1OptionBackground0.ZIndex    = 3
    E.Dropdown1OptionBackground0.Visible   = false

    E.Dropdown1OptionText0.Position  = Vector2.new(759, 477)
    E.Dropdown1OptionText0.Text      = "Forcefield"
    E.Dropdown1OptionText0.Size      = 16
    E.Dropdown1OptionText0.Font      = 2
    E.Dropdown1OptionText0.Color     = Color3.fromRGB(0, 0, 0)
    E.Dropdown1OptionText0.ZIndex    = 4
    E.Dropdown1OptionText0.Visible   = false
    _FitText(E.Dropdown1OptionText0, 134)

    E.Dropdown1OptionBackground1.Position  = Vector2.new(751, 500)
    E.Dropdown1OptionBackground1.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground1.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1OptionBackground1.Filled    = true
    E.Dropdown1OptionBackground1.ZIndex    = 3
    E.Dropdown1OptionBackground1.Visible   = false

    E.Dropdown1OptionText1.Position  = Vector2.new(759, 507)
    E.Dropdown1OptionText1.Text      = "Neon"
    E.Dropdown1OptionText1.Size      = 16
    E.Dropdown1OptionText1.Font      = 2
    E.Dropdown1OptionText1.Color     = Color3.fromRGB(0, 0, 0)
    E.Dropdown1OptionText1.ZIndex    = 4
    E.Dropdown1OptionText1.Visible   = false
    _FitText(E.Dropdown1OptionText1, 134)

    E.Dropdown1OptionBackground2.Position  = Vector2.new(751, 530)
    E.Dropdown1OptionBackground2.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground2.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1OptionBackground2.Filled    = true
    E.Dropdown1OptionBackground2.ZIndex    = 3
    E.Dropdown1OptionBackground2.Visible   = false

    E.Dropdown1OptionText2.Position  = Vector2.new(759, 537)
    E.Dropdown1OptionText2.Text      = "Cracked Lava"
    E.Dropdown1OptionText2.Size      = 16
    E.Dropdown1OptionText2.Font      = 2
    E.Dropdown1OptionText2.Color     = Color3.fromRGB(0, 0, 0)
    E.Dropdown1OptionText2.ZIndex    = 4
    E.Dropdown1OptionText2.Visible   = false
    _FitText(E.Dropdown1OptionText2, 134)

    E.Dropdown1OptionBackground3.Position  = Vector2.new(751, 560)
    E.Dropdown1OptionBackground3.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground3.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1OptionBackground3.Filled    = true
    E.Dropdown1OptionBackground3.ZIndex    = 3
    E.Dropdown1OptionBackground3.Visible   = false

    E.Dropdown1OptionText3.Position  = Vector2.new(759, 567)
    E.Dropdown1OptionText3.Text      = "Ice"
    E.Dropdown1OptionText3.Size      = 16
    E.Dropdown1OptionText3.Font      = 2
    E.Dropdown1OptionText3.Color     = Color3.fromRGB(0, 0, 0)
    E.Dropdown1OptionText3.ZIndex    = 4
    E.Dropdown1OptionText3.Visible   = false
    _FitText(E.Dropdown1OptionText3, 134)

    E.Dropdown1OptionBackground4.Position  = Vector2.new(751, 590)
    E.Dropdown1OptionBackground4.Size      = Vector2.new(150, 30)
    E.Dropdown1OptionBackground4.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1OptionBackground4.Filled    = true
    E.Dropdown1OptionBackground4.ZIndex    = 3
    E.Dropdown1OptionBackground4.Visible   = false

    E.Dropdown1OptionText4.Position  = Vector2.new(759, 597)
    E.Dropdown1OptionText4.Text      = "Glass"
    E.Dropdown1OptionText4.Size      = 16
    E.Dropdown1OptionText4.Font      = 2
    E.Dropdown1OptionText4.Color     = Color3.fromRGB(0, 0, 0)
    E.Dropdown1OptionText4.ZIndex    = 4
    E.Dropdown1OptionText4.Visible   = false
    _FitText(E.Dropdown1OptionText4, 134)
end

do
    local PrevLeftPressed: boolean = false

    local function OnSlider1Change(value: number): ()
        _G.red = value
    end

    local function OnSlider1CopyChange(value: number): ()
        _G.green = value
    end

    local function OnSlider1Copy2Change(value: number): ()
        _G.blue = value
    end

    local function OnDropdown1Change(selected: string, index: number): ()
        _G.mat= selected
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip input when Roblox unfocused
        local Mouse: Vector2       = UserInputService:GetMouseLocation()
        local LeftPressed: boolean = isleftpressed()
        local LeftClicked: boolean = LeftPressed and not PrevLeftPressed

        if LeftClicked then
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
                    E.Dropdown1Selected = "Forcefield"
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
                    E.Dropdown1Selected = "Neon"
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
                    E.Dropdown1Selected = "Cracked Lava"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 3
                    E.Dropdown1Fired    = true
                end
            end
            if E.Dropdown1Open then
                local Pos  = E.Dropdown1OptionBackground3.Position
                local Size = E.Dropdown1OptionBackground3.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown1Selected = "Ice"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 4
                    E.Dropdown1Fired    = true
                end
            end
            if E.Dropdown1Open then
                local Pos  = E.Dropdown1OptionBackground4.Position
                local Size = E.Dropdown1OptionBackground4.Size
                if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                    E.Dropdown1Selected = "Glass"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 5
                    E.Dropdown1Fired    = true
                end
            end
        end

        do
            local Pos  = E.Slider1Track.Position
            local Size = E.Slider1Track.Size
            local InRange: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                                 and Mouse.Y >= Pos.Y - 4 and Mouse.Y <= Pos.Y + Size.Y + 4
            if LeftPressed and (E.Slider1Dragging or InRange) then
                E.Slider1Dragging = true
                local T: number = MathClamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Raw: number = 0 + T * (255 - 0)
                E.Slider1Value         = MathFloor(Raw / 1 + 0.5) * 1
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
            if LeftPressed and (E.Slider1CopyDragging or InRange) then
                E.Slider1CopyDragging = true
                local T: number = MathClamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Raw: number = 0 + T * (255 - 0)
                E.Slider1CopyValue         = MathFloor(Raw / 1 + 0.5) * 1
                E.Slider1CopyFired         = true
            elseif not LeftPressed then
                E.Slider1CopyDragging = false
            end
        end

        do
            local Pos  = E.Slider1Copy2Track.Position
            local Size = E.Slider1Copy2Track.Size
            local InRange: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                                 and Mouse.Y >= Pos.Y - 4 and Mouse.Y <= Pos.Y + Size.Y + 4
            if LeftPressed and (E.Slider1Copy2Dragging or InRange) then
                E.Slider1Copy2Dragging = true
                local T: number = MathClamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Raw: number = 0 + T * (255 - 0)
                E.Slider1Copy2Value         = MathFloor(Raw / 1 + 0.5) * 1
                E.Slider1Copy2Fired         = true
            elseif not LeftPressed then
                E.Slider1Copy2Dragging = false
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1.Position
            local SquareSize: Vector2 = E.Square1.Size
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
                local ChildPos  = E.Slider1CopyTrack.Position
                local ChildSize = E.Slider1CopyTrack.Size
                if E.Slider1CopyDragging
                or (Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y - 8 and Mouse.Y <= ChildPos.Y + ChildSize.Y + 8) then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Slider1Copy2Track.Position
                local ChildSize = E.Slider1Copy2Track.Size
                if E.Slider1Copy2Dragging
                or (Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y - 8 and Mouse.Y <= ChildPos.Y + ChildSize.Y + 8) then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Dropdown1Background.Position
                local ChildSize = E.Dropdown1Background.Size
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

        PrevLeftPressed = LeftPressed
    end)

    do
        RunService.PostLocal:Connect(function()
            if not isrbxactive() then return end
            if E.Slider1Fired then
                E.Slider1Fired = false
                task.spawn(OnSlider1Change, E.Slider1Value)
            end
            if E.Slider1CopyFired then
                E.Slider1CopyFired = false
                task.spawn(OnSlider1CopyChange, E.Slider1CopyValue)
            end
            if E.Slider1Copy2Fired then
                E.Slider1Copy2Fired = false
                task.spawn(OnSlider1Copy2Change, E.Slider1Copy2Value)
            end
            if E.Dropdown1Fired then
                local _i: number = E.Dropdown1FiredIdx
                E.Dropdown1Fired = false
                task.spawn(OnDropdown1Change, E.Dropdown1Selected, _i)
            end
    if _G.red and _G.green and _G.blue then
        E.Square2.Color     = Color3.fromRGB(_G.red, _G.green, _G.blue)
    else
        E.Square2.Color     = Color3.fromRGB(255, 255, 255)
    end
        end)
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation()

        E.Dropdown1Text.Text  = E.Dropdown1Selected
        _FitText(E.Dropdown1Text, 122)
        E.Dropdown1Arrow.Text = if E.Dropdown1Open then "▲" else "▼"
        E.Dropdown1OptionBackground0.Visible = E.Dropdown1Open
        E.Dropdown1OptionText0.Visible       = E.Dropdown1Open
        E.Dropdown1OptionBackground1.Visible = E.Dropdown1Open
        E.Dropdown1OptionText1.Visible       = E.Dropdown1Open
        E.Dropdown1OptionBackground2.Visible = E.Dropdown1Open
        E.Dropdown1OptionText2.Visible       = E.Dropdown1Open
        E.Dropdown1OptionBackground3.Visible = E.Dropdown1Open
        E.Dropdown1OptionText3.Visible       = E.Dropdown1Open
        E.Dropdown1OptionBackground4.Visible = E.Dropdown1Open
        E.Dropdown1OptionText4.Visible       = E.Dropdown1Open

        do
            local T: number  = MathClamp((E.Slider1Value - 0) / 255, 0, 1)
            local FW: number = E.Slider1Track.Size.X * T
            E.Slider1Fill.Size     = Vector2.new(FW, E.Slider1Track.Size.Y)
            E.Slider1Knob.Position = Vector2.new(E.Slider1Track.Position.X + FW - 5, E.Slider1Track.Position.Y - 2)
            if E.Slider1Value ~= E.Slider1_LabelPrev then
                E.Slider1Label.Text = _FmtNum(E.Slider1Value) .. ""
                _FitText(E.Slider1Label, 200)
                E.Slider1_LabelPrev = E.Slider1Value
            end
        end
        do
            local T: number  = MathClamp((E.Slider1CopyValue - 0) / 255, 0, 1)
            local FW: number = E.Slider1CopyTrack.Size.X * T
            E.Slider1CopyFill.Size     = Vector2.new(FW, E.Slider1CopyTrack.Size.Y)
            E.Slider1CopyKnob.Position = Vector2.new(E.Slider1CopyTrack.Position.X + FW - 5, E.Slider1CopyTrack.Position.Y - 2)
            if E.Slider1CopyValue ~= E.Slider1Copy_LabelPrev then
                E.Slider1CopyLabel.Text = _FmtNum(E.Slider1CopyValue) .. ""
                _FitText(E.Slider1CopyLabel, 200)
                E.Slider1Copy_LabelPrev = E.Slider1CopyValue
            end
        end
        do
            local T: number  = MathClamp((E.Slider1Copy2Value - 0) / 255, 0, 1)
            local FW: number = E.Slider1Copy2Track.Size.X * T
            E.Slider1Copy2Fill.Size     = Vector2.new(FW, E.Slider1Copy2Track.Size.Y)
            E.Slider1Copy2Knob.Position = Vector2.new(E.Slider1Copy2Track.Position.X + FW - 5, E.Slider1Copy2Track.Position.Y - 2)
            if E.Slider1Copy2Value ~= E.Slider1Copy2_LabelPrev then
                E.Slider1Copy2Label.Text = _FmtNum(E.Slider1Copy2Value) .. ""
                _FitText(E.Slider1Copy2Label, 200)
                E.Slider1Copy2_LabelPrev = E.Slider1Copy2Value
            end
        end

        if E.Square1DragActive then
            local NewPos: Vector2 = E.Square1DragStartPos + (Mouse - E.Square1DragStartMouse)
            E.Square1.Position = NewPos

            E.Slider1Track.Position = NewPos + Vector2.new(46, 62)
            E.Slider1Fill.Position  = NewPos + Vector2.new(46, 62)
            E.Slider1Knob.Position  = NewPos + Vector2.new(46 + E.Slider1Fill.Size.X - 5, 62 - 2)
            E.Slider1Label.Position = NewPos + Vector2.new(146, 46)

            E.Slider1CopyTrack.Position = NewPos + Vector2.new(46, 84)
            E.Slider1CopyFill.Position  = NewPos + Vector2.new(46, 84)
            E.Slider1CopyKnob.Position  = NewPos + Vector2.new(46 + E.Slider1CopyFill.Size.X - 5, 84 - 2)
            E.Slider1CopyLabel.Position = NewPos + Vector2.new(146, 68)

            E.Slider1Copy2Track.Position = NewPos + Vector2.new(46, 108)
            E.Slider1Copy2Fill.Position  = NewPos + Vector2.new(46, 108)
            E.Slider1Copy2Knob.Position  = NewPos + Vector2.new(46 + E.Slider1Copy2Fill.Size.X - 5, 108 - 2)
            E.Slider1Copy2Label.Position = NewPos + Vector2.new(146, 92)

            E.Line1.From = NewPos + Vector2.new(266, 70)
            E.Line1.To   = NewPos + Vector2.new(310, 83)

            E.Line2.From = NewPos + Vector2.new(266, 89)
            E.Line2.To   = NewPos + Vector2.new(310, 89)

            E.Line3.From = NewPos + Vector2.new(268, 110)
            E.Line3.To   = NewPos + Vector2.new(311, 96)

            E.Square2.Position = NewPos + Vector2.new(328, 73)

            E.Dropdown1Background.Position = NewPos + Vector2.new(14, 142)
            E.Dropdown1Text.Position       = NewPos + Vector2.new(22, 149)
            E.Dropdown1Arrow.Position      = NewPos + Vector2.new(148, 149)
            E.Dropdown1OptionBackground0.Position = NewPos + Vector2.new(14, 172)
            E.Dropdown1OptionText0.Position       = NewPos + Vector2.new(22, 179)
            E.Dropdown1OptionBackground1.Position = NewPos + Vector2.new(14, 202)
            E.Dropdown1OptionText1.Position       = NewPos + Vector2.new(22, 209)
            E.Dropdown1OptionBackground2.Position = NewPos + Vector2.new(14, 232)
            E.Dropdown1OptionText2.Position       = NewPos + Vector2.new(22, 239)
            E.Dropdown1OptionBackground3.Position = NewPos + Vector2.new(14, 262)
            E.Dropdown1OptionText3.Position       = NewPos + Vector2.new(22, 269)
            E.Dropdown1OptionBackground4.Position = NewPos + Vector2.new(14, 292)
            E.Dropdown1OptionText4.Position       = NewPos + Vector2.new(22, 299)
        end

    end)
end
end)()
local mats = {
    ["ForceField"] = 1584,
    ["Neon"] = 288,
    ["CrackedLava"] = 804,
    ["Ice"] = 1536,
    ["Glass"] = 1568
}
local excluded = {}
task.spawn(function()
	while task.wait(0.75) do
		local ws = game.Workspace
		local cam = ws.CurrentCamera
		for _, v in pairs(cam:GetChildren()) do
			if not excluded[v] then
				if v:IsA("Model") then
					for _, b in pairs(v:GetChildren()) do
						if b.Name == "Arm" then
							excluded[b.Parent] = true
							continue
						end
						if not excluded[v] then
						for _, parts in pairs(b:GetChildren()) do
							if b:IsA("BasePart") then
								if b then
								local r = memory.readu8(b, 0x148)
								local g = memory.readu8(b, 0x148 + 0x1)
								local bl = memory.readu8(b, 0x148 + 0x2)
								memory.writeu8(b, 0x148, _G.red or r)
								memory.writeu8(b, 0x148 + 0x1, _G.green or g)
								memory.writeu8(b, 0x148 + 0x2, _G.blue or bl)
								local prim = memory.readu64(b, 0x128)
								local picked = _G.mat or 256
								memory.writeu16(prim, 0x23e, picked)
							end
							end
						end
					end
				end
			end
		end
	end
	end
end)
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
--[[task.spawn(function()
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
]]
