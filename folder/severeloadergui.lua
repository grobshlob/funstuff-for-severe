--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor

-- Cached Color3 constants for per-frame hover/toggle writes.
local _HC0: Color3 = Color3.fromRGB(0, 119, 230)
local _HC1: Color3 = Color3.fromRGB(255, 255, 255)

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

E.Square1 = Drawing.new("Square")
E.Square3 = Drawing.new("Square")
E.Square2 = Drawing.new("Square")
E.Square4 = Drawing.new("Square")
E.Square5 = Drawing.new("Square")
E.Square6 = Drawing.new("Square")
E.Square5Copy = Drawing.new("Square")
E.Text2 = Drawing.new("Text")
E.Text2Copy = Drawing.new("Text")
E.Text2Copy2 = Drawing.new("Text")
E.Square2Copy = Drawing.new("Square")
E.Text3 = Drawing.new("Text")
E.Triangle1 = Drawing.new("Triangle")
E.Button2Background = Drawing.new("Square")
E.Button2Text       = Drawing.new("Text")
E.Button2Fired    = false
E.Dropdown1Background = Drawing.new("Square")
E.Dropdown1Text       = Drawing.new("Text")
E.Dropdown1Arrow      = Drawing.new("Text")
E.Dropdown1Selected   = "Combat Warriors"
E.Dropdown1Options    = { "Combat Warriors" }
E.Dropdown1Open       = false
E.Dropdown1Fired      = false
E.Dropdown1FiredIdx   = 0
E.Dropdown1OptionBackground0 = Drawing.new("Square")
E.Dropdown1OptionText0       = Drawing.new("Text")
E.Dropdown1_OptBg     = { E.Dropdown1OptionBackground0 }
E.Dropdown1_OptTx     = { E.Dropdown1OptionText0 }
E.Circle1 = Drawing.new("Circle")

E.Square1DragActive     = false
E.Square1DragStartMouse = Vector2.new(0, 0)
E.Square1DragStartPos   = Vector2.new(0, 0)

do

    E.Square1.Position  = Vector2.new(823, 459)
    E.Square1.Size      = Vector2.new(425, 197)
    E.Square1.Color     = Color3.fromRGB(16, 16, 35)
    E.Square1.Opacity   = 1
    E.Square1.Filled    = true
    E.Square1.Thickness = 1
    E.Square1.Rounding  = 42
    E.Square1.ZIndex    = -2
    E.Square1.Visible   = true

    E.Square3.Position  = Vector2.new(846, 481)
    E.Square3.Size      = Vector2.new(376, 111)
    E.Square3.Color     = Color3.fromRGB(30, 27, 54)
    E.Square3.Opacity   = 1
    E.Square3.Filled    = true
    E.Square3.Thickness = 1
    E.Square3.Rounding  = 30
    E.Square3.ZIndex    = -1
    E.Square3.Visible   = true

    E.Square2.Position  = Vector2.new(841, 606)
    E.Square2.Size      = Vector2.new(376, 34)
    E.Square2.Color     = Color3.fromRGB(0, 119, 230)
    E.Square2.Opacity   = 1
    E.Square2.Filled    = true
    E.Square2.Thickness = 1
    E.Square2.Rounding  = 21
    E.Square2.ZIndex    = 0
    E.Square2.Visible   = true

    E.Square4.Position  = Vector2.new(868, 497)
    E.Square4.Size      = Vector2.new(130, 86)
    E.Square4.Color     = Color3.fromRGB(145, 145, 145)
    E.Square4.Opacity   = 1
    E.Square4.Filled    = false
    E.Square4.Thickness = 0.20
    E.Square4.ZIndex    = 0
    E.Square4.Visible   = true

    E.Square5.Position  = Vector2.new(892, 507)
    E.Square5.Size      = Vector2.new(79, 68)
    E.Square5.Color     = Color3.fromRGB(79, 75, 114)
    E.Square5.Opacity   = 1
    E.Square5.Filled    = true
    E.Square5.Thickness = 1
    E.Square5.ZIndex    = 0
    E.Square5.Visible   = true

    E.Square6.Position  = Vector2.new(900, 511)
    E.Square6.Size      = Vector2.new(64, 59)
    E.Square6.Color     = Color3.fromRGB(255, 255, 255)
    E.Square6.Opacity   = 1
    E.Square6.Filled    = true
    E.Square6.Thickness = 1
    E.Square6.ZIndex    = 0
    E.Square6.Visible   = true

    E.Square5Copy.Position  = Vector2.new(925, 534)
    E.Square5Copy.Size      = Vector2.new(15, 15)
    E.Square5Copy.Color     = Color3.fromRGB(79, 75, 114)
    E.Square5Copy.Opacity   = 1
    E.Square5Copy.Filled    = true
    E.Square5Copy.Thickness = 1
    E.Square5Copy.ZIndex    = 0
    E.Square5Copy.Visible   = true

    E.Text2.Position     = Vector2.new(1020, 523)
    E.Text2.Text         = "Incomparable optimizations,"
    E.Text2.Size         = 14
    E.Text2.Font         = 0
    E.Text2.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2.Opacity      = 1
    E.Text2.Center       = false
    E.Text2.Outline      = false
    E.Text2.ZIndex       = 0
    E.Text2.Visible      = true

    E.Text2Copy.Position     = Vector2.new(1020, 540)
    E.Text2Copy.Text         = "outmaneuver your opponents with"
    E.Text2Copy.Size         = 14
    E.Text2Copy.Font         = 0
    E.Text2Copy.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2Copy.Opacity      = 1
    E.Text2Copy.Center       = false
    E.Text2Copy.Outline      = false
    E.Text2Copy.ZIndex       = 0
    E.Text2Copy.Visible      = true

    E.Text2Copy2.Position     = Vector2.new(1020, 557)
    E.Text2Copy2.Text         = "enhanced vision and precision."
    E.Text2Copy2.Size         = 14
    E.Text2Copy2.Font         = 0
    E.Text2Copy2.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2Copy2.Opacity      = 1
    E.Text2Copy2.Center       = false
    E.Text2Copy2.Outline      = false
    E.Text2Copy2.ZIndex       = 0
    E.Text2Copy2.Visible      = true

    E.Square2Copy.Position  = Vector2.new(1109, 497)
    E.Square2Copy.Size      = Vector2.new(103, 21)
    E.Square2Copy.Color     = Color3.fromRGB(0, 119, 230)
    E.Square2Copy.Opacity   = 1
    E.Square2Copy.Filled    = true
    E.Square2Copy.Thickness = 1
    E.Square2Copy.Rounding  = 21
    E.Square2Copy.ZIndex    = 0
    E.Square2Copy.Visible   = true

    E.Text3.Position     = Vector2.new(1146, 500)
    E.Text3.Text         = "V.1.0"
    E.Text3.Size         = 16
    E.Text3.Font         = 0
    E.Text3.Color        = Color3.fromRGB(255, 255, 255)
    E.Text3.Opacity      = 1
    E.Text3.Center       = false
    E.Text3.Outline      = false
    E.Text3.ZIndex       = 0
    E.Text3.Visible      = true

    E.Triangle1.PointA    = Vector2.new(996, 620)
    E.Triangle1.PointB    = Vector2.new(992, 628)
    E.Triangle1.PointC    = Vector2.new(1000, 628)
    E.Triangle1.Color     = Color3.fromRGB(255, 255, 255)
    E.Triangle1.Opacity   = 1
    E.Triangle1.Filled    = true
    E.Triangle1.Thickness = 1
    E.Triangle1.ZIndex    = 0
    E.Triangle1.Visible   = true

    E.Button2Background.Position  = Vector2.new(859, 611)
    E.Button2Background.Size      = Vector2.new(346, 22)
    E.Button2Background.Color     = Color3.fromRGB(0, 119, 230)
    E.Button2Background.Filled    = false
    E.Button2Background.Thickness = 1
    E.Button2Background.Rounding  = 4
    E.Button2Background.ZIndex    = 0
    E.Button2Background.Visible   = true

    E.Button2Text.Position     = Vector2.new(1032, 614)
    E.Button2Text.Text         = "Load"
    E.Button2Text.Size         = 16
    E.Button2Text.Font         = 2
    E.Button2Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button2Text.Center       = true
    E.Button2Text.Outline      = false
    E.Button2Text.ZIndex       = 1
    E.Button2Text.Visible      = true
    _FitText(E.Button2Text, 337.9029473601223)

    E.Dropdown1Background.Position  = Vector2.new(1005, 496)
    E.Dropdown1Background.Size      = Vector2.new(95, 16)
    E.Dropdown1Background.Color     = Color3.fromRGB(18, 19, 33)
    E.Dropdown1Background.Filled    = true
    E.Dropdown1Background.Thickness = 1
    E.Dropdown1Background.Rounding  = 21
    E.Dropdown1Background.ZIndex    = 0
    E.Dropdown1Background.Visible   = true

    E.Dropdown1Text.Position  = Vector2.new(1013, 499)
    E.Dropdown1Text.Text      = E.Dropdown1Selected
    E.Dropdown1Text.Size      = 11
    E.Dropdown1Text.Font      = 2
    E.Dropdown1Text.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1Text.Outline   = false
    E.Dropdown1Text.ZIndex    = 1
    E.Dropdown1Text.Visible   = true
    _FitText(E.Dropdown1Text, 67.05155227322803)

    E.Dropdown1Arrow.Position = Vector2.new(1084, 499)
    E.Dropdown1Arrow.Text     = "▼"
    E.Dropdown1Arrow.Size     = 10
    E.Dropdown1Arrow.Font     = 2
    E.Dropdown1Arrow.Color    = Color3.fromRGB(255, 255, 255)
    E.Dropdown1Arrow.ZIndex   = 1
    E.Dropdown1Arrow.Visible  = true

    E.Dropdown1OptionBackground0.Position  = Vector2.new(1005, 512)
    E.Dropdown1OptionBackground0.Size      = Vector2.new(95, 16)
    E.Dropdown1OptionBackground0.Color     = Color3.fromRGB(18, 19, 33)
    E.Dropdown1OptionBackground0.Filled    = true
    E.Dropdown1OptionBackground0.Rounding  = 21
    E.Dropdown1OptionBackground0.ZIndex    = 2
    E.Dropdown1OptionBackground0.Visible   = false

    E.Dropdown1OptionText0.Position  = Vector2.new(1013, 515)
    E.Dropdown1OptionText0.Text      = "Combat Warriors"
    E.Dropdown1OptionText0.Size      = 11
    E.Dropdown1OptionText0.Font      = 2
    E.Dropdown1OptionText0.Color     = Color3.fromRGB(255, 255, 255)
    E.Dropdown1OptionText0.ZIndex    = 3
    E.Dropdown1OptionText0.Visible   = false
    _FitText(E.Dropdown1OptionText0, 79.05155227322803)

    E.Circle1.Position  = Vector2.new(996, 624)
    E.Circle1.Radius    = 8.70917279899038
    E.Circle1.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1.Opacity   = 1
    E.Circle1.Filled    = false
    E.Circle1.Thickness = 1
    E.Circle1.NumSides  = 64
    E.Circle1.ZIndex    = 1
    E.Circle1.Visible   = true
end

do
    local PrevLeftPressed: boolean = false

    local function OnButton2Click(): ()
        if _G.selectedgame == "Combat Warriors" then Drawing.clear()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/cw.lua"))()
            else send_notification("please select a game", "info")
                end
    end

    local function OnDropdown1Change(selected: string, index: number): ()
        _G.selectedgame = selected
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
                    E.Dropdown1Selected = "Combat Warriors"
                    E.Dropdown1Open     = false
                    E.Dropdown1FiredIdx = 1
                    E.Dropdown1Fired    = true
                end
            end
        end

        do
            local Pos  = E.Button2Background.Position
            local Size = E.Button2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if Over and LeftClicked then
                E.Button2Fired   = true
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1.Position
            local SquareSize: Vector2 = E.Square1.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
            do
                local ChildPos  = E.Button2Background.Position
                local ChildSize = E.Button2Background.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
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
            if E.Button2Fired then
                E.Button2Fired = false
                OnButton2Click()
            end
            if E.Dropdown1Fired then
                local _i: number = E.Dropdown1FiredIdx
                E.Dropdown1Fired = false
                OnDropdown1Change(E.Dropdown1Selected, _i)
            end
        end)
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation()

        E.Dropdown1Text.Text  = E.Dropdown1Selected
        _FitText(E.Dropdown1Text, 67.05155227322803)
        E.Dropdown1Arrow.Text = if E.Dropdown1Open then "▲" else "▼"
        E.Dropdown1OptionBackground0.Visible = E.Dropdown1Open
        E.Dropdown1OptionText0.Visible       = E.Dropdown1Open

        do
            local Pos  = E.Button2Background.Position
            local Size = E.Button2Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2Background.Color = if Over then _HC0 else _HC0
        end

        if E.Square1DragActive then
            local NewPos: Vector2 = E.Square1DragStartPos + (Mouse - E.Square1DragStartMouse)
            E.Square1.Position = NewPos

            E.Square2.Position = NewPos + Vector2.new(18, 147)

            E.Square3.Position = NewPos + Vector2.new(23, 22)

            E.Square4.Position = NewPos + Vector2.new(45, 38)

            E.Square5.Position = NewPos + Vector2.new(69, 48)

            E.Square6.Position = NewPos + Vector2.new(77, 52)

            E.Square5Copy.Position = NewPos + Vector2.new(102, 75)

            E.Text2.Position = NewPos + Vector2.new(197, 64)

            E.Text2Copy.Position = NewPos + Vector2.new(197, 81)

            E.Text2Copy2.Position = NewPos + Vector2.new(197, 98)

            E.Square2Copy.Position = NewPos + Vector2.new(286, 38)

            E.Text3.Position = NewPos + Vector2.new(323, 41)

            E.Triangle1.PointA = NewPos + Vector2.new(173, 161)
            E.Triangle1.PointB = NewPos + Vector2.new(169, 169)
            E.Triangle1.PointC = NewPos + Vector2.new(177, 169)

            E.Button2Background.Position = NewPos + Vector2.new(36, 152)
            E.Button2Text.Position       = NewPos + Vector2.new(209, 155)

            E.Dropdown1Background.Position = NewPos + Vector2.new(182, 37)
            E.Dropdown1Text.Position       = NewPos + Vector2.new(190, 40)
            E.Dropdown1Arrow.Position      = NewPos + Vector2.new(261.051552273228, 40)
            E.Dropdown1OptionBackground0.Position = NewPos + Vector2.new(182, 53.24665457998776)
            E.Dropdown1OptionText0.Position       = NewPos + Vector2.new(190, 56.24665457998776)

            E.Circle1.Position = NewPos + Vector2.new(173, 165)
        end

    end)
end
end)()
