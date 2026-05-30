--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor

-- Cached Color3 constants for per-frame hover/toggle writes.
local _HC0: Color3 = Color3.fromRGB(0, 59, 153)
local _HC1: Color3 = Color3.fromRGB(0, 179, 45)
local _HC2: Color3 = Color3.fromRGB(255, 255, 255)

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

E.Square1Copy3 = Drawing.new("Square")
E.Circle1Copy3 = Drawing.new("Circle")
E.Circle1Copy4 = Drawing.new("Circle")
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
E.Square6Copy = Drawing.new("Square")
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
E.Square1Copy7 = Drawing.new("Square")
E.Square1Copy8 = Drawing.new("Square")
E.Button1Background = Drawing.new("Square")
E.Button1Text       = Drawing.new("Text")
E.Button1Fired    = false
E.Line1Copy3 = Drawing.new("Line")
E.Line1Copy4 = Drawing.new("Line")
E.Line1Copy5 = Drawing.new("Line")

E.Square1Copy3DragActive     = false
E.Square1Copy3DragStartMouse = Vector2.new(0, 0)
E.Square1Copy3DragStartPos   = Vector2.new(0, 0)

do

    E.Square1Copy3.Position  = Vector2.new(789, 463)
    E.Square1Copy3.Size      = Vector2.new(407, 204)
    E.Square1Copy3.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy3.Opacity   = 1
    E.Square1Copy3.Filled    = false
    E.Square1Copy3.Thickness = 6
    E.Square1Copy3.Rounding  = 33
    E.Square1Copy3.ZIndex    = 0
    E.Square1Copy3.Visible   = true

    E.Circle1Copy3.Position  = Vector2.new(831, 489)
    E.Circle1Copy3.Radius    = 3.675981117494274
    E.Circle1Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy3.Opacity   = 1
    E.Circle1Copy3.Filled    = false
    E.Circle1Copy3.Thickness = 1
    E.Circle1Copy3.NumSides  = 64
    E.Circle1Copy3.ZIndex    = 1
    E.Circle1Copy3.Visible   = true

    E.Circle1Copy4.Position  = Vector2.new(819, 489)
    E.Circle1Copy4.Radius    = 3.675981117494274
    E.Circle1Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Circle1Copy4.Opacity   = 1
    E.Circle1Copy4.Filled    = false
    E.Circle1Copy4.Thickness = 1
    E.Circle1Copy4.NumSides  = 64
    E.Circle1Copy4.ZIndex    = 1
    E.Circle1Copy4.Visible   = true

    E.Text1Copy4.Position     = Vector2.new(860, 479)
    E.Text1Copy4.Text         = "BROG"
    E.Text1Copy4.Size         = 23
    E.Text1Copy4.Font         = 0
    E.Text1Copy4.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy4.Opacity      = 1
    E.Text1Copy4.Center       = false
    E.Text1Copy4.Outline      = false
    E.Text1Copy4.ZIndex       = 1
    E.Text1Copy4.Visible      = true

    E.Text1Copy5.Position     = Vector2.new(913, 480)
    E.Text1Copy5.Text         = ":   Violence District"
    E.Text1Copy5.Size         = 17
    E.Text1Copy5.Font         = 0
    E.Text1Copy5.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy5.Opacity      = 1
    E.Text1Copy5.Center       = false
    E.Text1Copy5.Outline      = false
    E.Text1Copy5.ZIndex       = 1
    E.Text1Copy5.Visible      = true

    E.Line4Copy2.From      = Vector2.new(811, 484)
    E.Line4Copy2.To        = Vector2.new(815, 476)
    E.Line4Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy2.Opacity   = 1
    E.Line4Copy2.Thickness = 1
    E.Line4Copy2.ZIndex    = 1
    E.Line4Copy2.Visible   = true

    E.Line5Copy2.From      = Vector2.new(815, 476)
    E.Line5Copy2.To        = Vector2.new(819, 483)
    E.Line5Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy2.Opacity   = 1
    E.Line5Copy2.Thickness = 1
    E.Line5Copy2.ZIndex    = 1
    E.Line5Copy2.Visible   = true

    E.Line6Copy2.From      = Vector2.new(831, 483)
    E.Line6Copy2.To        = Vector2.new(835, 476)
    E.Line6Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy2.Opacity   = 1
    E.Line6Copy2.Thickness = 1
    E.Line6Copy2.ZIndex    = 1
    E.Line6Copy2.Visible   = true

    E.Line7Copy2.From      = Vector2.new(835, 476)
    E.Line7Copy2.To        = Vector2.new(838, 485)
    E.Line7Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7Copy2.Opacity   = 1
    E.Line7Copy2.Thickness = 1
    E.Line7Copy2.ZIndex    = 1
    E.Line7Copy2.Visible   = true

    E.Line8Copy4.From      = Vector2.new(807, 496)
    E.Line8Copy4.To        = Vector2.new(815, 498)
    E.Line8Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy4.Opacity   = 1
    E.Line8Copy4.Thickness = 1
    E.Line8Copy4.ZIndex    = 1
    E.Line8Copy4.Visible   = true

    E.Line8Copy5.From      = Vector2.new(806, 501)
    E.Line8Copy5.To        = Vector2.new(816, 501)
    E.Line8Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy5.Opacity   = 1
    E.Line8Copy5.Thickness = 1
    E.Line8Copy5.ZIndex    = 1
    E.Line8Copy5.Visible   = true

    E.Line9Copy4.From      = Vector2.new(834, 501)
    E.Line9Copy4.To        = Vector2.new(843, 503)
    E.Line9Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy4.Opacity   = 1
    E.Line9Copy4.Thickness = 1
    E.Line9Copy4.ZIndex    = 1
    E.Line9Copy4.Visible   = true

    E.Line9Copy5.From      = Vector2.new(835, 499)
    E.Line9Copy5.To        = Vector2.new(843, 497)
    E.Line9Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy5.Opacity   = 1
    E.Line9Copy5.Thickness = 1
    E.Line9Copy5.ZIndex    = 1
    E.Line9Copy5.Visible   = true

    E.Text2Copy2.Position     = Vector2.new(1129, 481)
    E.Text2Copy2.Text         = "Text"
    E.Text2Copy2.Size         = 17
    E.Text2Copy2.Font         = 0
    E.Text2Copy2.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2Copy2.Opacity      = 1
    E.Text2Copy2.Center       = false
    E.Text2Copy2.Outline      = false
    E.Text2Copy2.ZIndex       = 1
    E.Text2Copy2.Visible      = true

    E.Line10Copy4.From      = Vector2.new(825, 497)
    E.Line10Copy4.To        = Vector2.new(823, 501)
    E.Line10Copy4.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy4.Opacity   = 1
    E.Line10Copy4.Thickness = 1
    E.Line10Copy4.ZIndex    = 1
    E.Line10Copy4.Visible   = true

    E.Line10Copy5.From      = Vector2.new(825, 497)
    E.Line10Copy5.To        = Vector2.new(828, 502)
    E.Line10Copy5.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy5.Opacity   = 1
    E.Line10Copy5.Thickness = 1
    E.Line10Copy5.ZIndex    = 1
    E.Line10Copy5.Visible   = true

    E.Square6Copy.Position  = Vector2.new(789, 463)
    E.Square6Copy.Size      = Vector2.new(405, 204)
    E.Square6Copy.Color     = Color3.fromRGB(44, 26, 81)
    E.Square6Copy.Opacity   = 0.50
    E.Square6Copy.Filled    = true
    E.Square6Copy.Thickness = 1
    E.Square6Copy.Rounding  = 33
    E.Square6Copy.ZIndex    = 1
    E.Square6Copy.Visible   = true

    E.Checkbox1Background.Position  = Vector2.new(814, 562)
    E.Checkbox1Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Background.Filled    = true
    E.Checkbox1Background.Thickness = 1
    E.Checkbox1Background.ZIndex    = 1
    E.Checkbox1Background.Visible   = true

    E.Checkbox1Fill.Position  = Vector2.new(817, 565)
    E.Checkbox1Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Fill.Filled    = true
    E.Checkbox1Fill.ZIndex    = 2
    E.Checkbox1Fill.Visible   = true

    E.Checkbox1Label.Position     = Vector2.new(846, 566)
    E.Checkbox1Label.Text         = "Generator ESP"
    E.Checkbox1Label.Size         = 16
    E.Checkbox1Label.Font         = 2
    E.Checkbox1Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Label.Outline      = true
    E.Checkbox1Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Label.ZIndex       = 2
    E.Checkbox1Label.Visible      = true

    E.Checkbox1CopyBackground.Position  = Vector2.new(814, 604)
    E.Checkbox1CopyBackground.Size      = Vector2.new(26, 24)
    E.Checkbox1CopyBackground.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1CopyBackground.Filled    = true
    E.Checkbox1CopyBackground.Thickness = 1
    E.Checkbox1CopyBackground.ZIndex    = 1
    E.Checkbox1CopyBackground.Visible   = true

    E.Checkbox1CopyFill.Position  = Vector2.new(817, 607)
    E.Checkbox1CopyFill.Size      = Vector2.new(20, 18)
    E.Checkbox1CopyFill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1CopyFill.Filled    = true
    E.Checkbox1CopyFill.ZIndex    = 2
    E.Checkbox1CopyFill.Visible   = true

    E.Checkbox1CopyLabel.Position     = Vector2.new(846, 608)
    E.Checkbox1CopyLabel.Text         = "Killer ESP"
    E.Checkbox1CopyLabel.Size         = 16
    E.Checkbox1CopyLabel.Font         = 2
    E.Checkbox1CopyLabel.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1CopyLabel.Outline      = true
    E.Checkbox1CopyLabel.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1CopyLabel.ZIndex       = 2
    E.Checkbox1CopyLabel.Visible      = true

    E.Checkbox1Copy2Background.Position  = Vector2.new(1011, 562)
    E.Checkbox1Copy2Background.Size      = Vector2.new(26, 24)
    E.Checkbox1Copy2Background.Color     = Color3.fromRGB(92, 79, 191)
    E.Checkbox1Copy2Background.Filled    = true
    E.Checkbox1Copy2Background.Thickness = 1
    E.Checkbox1Copy2Background.ZIndex    = 1
    E.Checkbox1Copy2Background.Visible   = true

    E.Checkbox1Copy2Fill.Position  = Vector2.new(1014, 565)
    E.Checkbox1Copy2Fill.Size      = Vector2.new(20, 18)
    E.Checkbox1Copy2Fill.Color     = Color3.fromRGB(219, 0, 161)
    E.Checkbox1Copy2Fill.Filled    = true
    E.Checkbox1Copy2Fill.ZIndex    = 2
    E.Checkbox1Copy2Fill.Visible   = true

    E.Checkbox1Copy2Label.Position     = Vector2.new(1043, 566)
    E.Checkbox1Copy2Label.Text         = "Auto Parry"
    E.Checkbox1Copy2Label.Size         = 16
    E.Checkbox1Copy2Label.Font         = 2
    E.Checkbox1Copy2Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy2Label.Outline      = true
    E.Checkbox1Copy2Label.OutlineColor = Vector3.new(0, 0, 0)
    E.Checkbox1Copy2Label.ZIndex       = 2
    E.Checkbox1Copy2Label.Visible      = true

    E.Square1Copy5.Position  = Vector2.new(809, 530)
    E.Square1Copy5.Size      = Vector2.new(177, 108)
    E.Square1Copy5.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy5.Opacity   = 1
    E.Square1Copy5.Filled    = false
    E.Square1Copy5.Thickness = 6
    E.Square1Copy5.Rounding  = 5
    E.Square1Copy5.ZIndex    = 1
    E.Square1Copy5.Visible   = true

    E.Text7.Position     = Vector2.new(816, 540)
    E.Text7.Text         = "ESP"
    E.Text7.Size         = 16
    E.Text7.Font         = 0
    E.Text7.Color        = Color3.fromRGB(204, 0, 139)
    E.Text7.Opacity      = 1
    E.Text7.Center       = false
    E.Text7.Outline      = false
    E.Text7.ZIndex       = 1
    E.Text7.Visible      = true

    E.Square1Copy6.Position  = Vector2.new(1001, 530)
    E.Square1Copy6.Size      = Vector2.new(177, 108)
    E.Square1Copy6.Color     = Color3.fromRGB(77, 8, 217)
    E.Square1Copy6.Opacity   = 1
    E.Square1Copy6.Filled    = false
    E.Square1Copy6.Thickness = 6
    E.Square1Copy6.Rounding  = 5
    E.Square1Copy6.ZIndex    = 1
    E.Square1Copy6.Visible   = true

    E.Text7Copy.Position     = Vector2.new(1011, 539)
    E.Text7Copy.Text         = "Automation"
    E.Text7Copy.Size         = 16
    E.Text7Copy.Font         = 0
    E.Text7Copy.Color        = Color3.fromRGB(204, 0, 139)
    E.Text7Copy.Opacity      = 1
    E.Text7Copy.Center       = false
    E.Text7Copy.Outline      = false
    E.Text7Copy.ZIndex       = 1
    E.Text7Copy.Visible      = true

    E.Square1Copy7.Position  = Vector2.new(809, 530)
    E.Square1Copy7.Size      = Vector2.new(177, 108)
    E.Square1Copy7.Color     = Color3.fromRGB(46, 0, 138)
    E.Square1Copy7.Opacity   = 0.36
    E.Square1Copy7.Filled    = true
    E.Square1Copy7.Thickness = 6
    E.Square1Copy7.Rounding  = 5
    E.Square1Copy7.ZIndex    = 1
    E.Square1Copy7.Visible   = true

    E.Square1Copy8.Position  = Vector2.new(1001, 530)
    E.Square1Copy8.Size      = Vector2.new(177, 108)
    E.Square1Copy8.Color     = Color3.fromRGB(46, 0, 138)
    E.Square1Copy8.Opacity   = 0.36
    E.Square1Copy8.Filled    = true
    E.Square1Copy8.Thickness = 6
    E.Square1Copy8.Rounding  = 5
    E.Square1Copy8.ZIndex    = 1
    E.Square1Copy8.Visible   = true

    E.Button1Background.Position  = Vector2.new(1031, 595)
    E.Button1Background.Size      = Vector2.new(120, 34)
    E.Button1Background.Color     = Color3.fromRGB(0, 59, 153)
    E.Button1Background.Filled    = true
    E.Button1Background.Thickness = 1
    E.Button1Background.Rounding  = 4
    E.Button1Background.ZIndex    = 1
    E.Button1Background.Visible   = true

    E.Button1Text.Position     = Vector2.new(1091, 604)
    E.Button1Text.Text         = "Load"
    E.Button1Text.Size         = 16
    E.Button1Text.Font         = 2
    E.Button1Text.Color        = Color3.fromRGB(255, 255, 255)
    E.Button1Text.Center       = true
    E.Button1Text.Outline      = false
    E.Button1Text.ZIndex       = 2
    E.Button1Text.Visible      = true
    _FitText(E.Button1Text, 112)

    E.Line1Copy3.From      = Vector2.new(800, 511)
    E.Line1Copy3.To        = Vector2.new(1187, 511)
    E.Line1Copy3.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy3.Opacity   = 0.33
    E.Line1Copy3.Thickness = 1
    E.Line1Copy3.ZIndex    = 2
    E.Line1Copy3.Visible   = true

    E.Line1Copy4.From      = Vector2.new(820, 557)
    E.Line1Copy4.To        = Vector2.new(973, 557)
    E.Line1Copy4.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy4.Opacity   = 0.33
    E.Line1Copy4.Thickness = 1
    E.Line1Copy4.ZIndex    = 2
    E.Line1Copy4.Visible   = true

    E.Line1Copy5.From      = Vector2.new(1014, 556)
    E.Line1Copy5.To        = Vector2.new(1168, 556)
    E.Line1Copy5.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy5.Opacity   = 0.33
    E.Line1Copy5.Thickness = 1
    E.Line1Copy5.ZIndex    = 2
    E.Line1Copy5.Visible   = true

    local _PlayerName: string = game.Players.LocalPlayer.Name
    E.Text2Copy2.Text = _PlayerName
end

do
    local PrevLeftPressed: boolean = false

    local function OnCheckbox1Toggle(state: boolean): ()
        
    end

    local function OnCheckbox1CopyToggle(state: boolean): ()
        
    end

    local function OnCheckbox1Copy2Toggle(state: boolean): ()
        
    end

    local function OnButton1Click(): ()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/vd/logic.lua"))()
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip input when Roblox unfocused
        local Mouse: Vector2       = UserInputService:GetMouseLocation()
        local LeftPressed: boolean = isleftpressed()
        local LeftClicked: boolean = LeftPressed and not PrevLeftPressed

        if LeftClicked then
            local Pos  = E.Checkbox1Background.Position
            local Size = E.Checkbox1Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Checked = not E.Checkbox1Checked
            end
        end

        if LeftClicked then
            local Pos  = E.Checkbox1CopyBackground.Position
            local Size = E.Checkbox1CopyBackground.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1CopyChecked = not E.Checkbox1CopyChecked
            end
        end

        if LeftClicked then
            local Pos  = E.Checkbox1Copy2Background.Position
            local Size = E.Checkbox1Copy2Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy2Checked = not E.Checkbox1Copy2Checked
            end
        end

        do
            local Pos  = E.Button1Background.Position
            local Size = E.Button1Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if Over and LeftClicked then
                E.Button1Fired   = true
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy3.Position
            local SquareSize: Vector2 = E.Square1Copy3.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
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
                local ChildPos  = E.Button1Background.Position
                local ChildSize = E.Button1Background.Size
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

        PrevLeftPressed = LeftPressed

    end)

    do
        local _wtCheckbox1: number = 0
        local function _waitCheckbox1(s: number) _wtCheckbox1 = os.clock() + s end
        local _wtCheckbox1Copy: number = 0
        local function _waitCheckbox1Copy(s: number) _wtCheckbox1Copy = os.clock() + s end
        local _wtCheckbox1Copy2: number = 0
        local function _waitCheckbox1Copy2(s: number) _wtCheckbox1Copy2 = os.clock() + s end
        RunService.PostLocal:Connect(function()
            if not isrbxactive() then return end
            if E.Button1Fired then
                E.Button1Fired = false
                OnButton1Click()
            end

            if E.Checkbox1Checked and os.clock() >= _wtCheckbox1 then
                local state: boolean = true
                local wait = _waitCheckbox1
                _G.genesp = true
            end

            if E.Checkbox1CopyChecked and os.clock() >= _wtCheckbox1Copy then
                local state: boolean = true
                local wait = _waitCheckbox1Copy
                _G.killesp = true
            end

            if E.Checkbox1Copy2Checked and os.clock() >= _wtCheckbox1Copy2 then
                local state: boolean = true
                local wait = _waitCheckbox1Copy2
                _G.ap = true
            end
        end)
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation()

        E.Checkbox1Fill.Visible = E.Checkbox1Checked
        E.Checkbox1CopyFill.Visible = E.Checkbox1CopyChecked
        E.Checkbox1Copy2Fill.Visible = E.Checkbox1Copy2Checked

        do
            local Pos  = E.Button1Background.Position
            local Size = E.Button1Background.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button1Background.Color = if Over then _HC1 else _HC0
        end

        if E.Square1Copy3DragActive then
            local NewPos: Vector2 = E.Square1Copy3DragStartPos + (Mouse - E.Square1Copy3DragStartMouse)
            E.Square1Copy3.Position = NewPos

            E.Line1Copy3.From = NewPos + Vector2.new(11, 48)
            E.Line1Copy3.To   = NewPos + Vector2.new(398, 48)

            E.Circle1Copy3.Position = NewPos + Vector2.new(42, 26)

            E.Circle1Copy4.Position = NewPos + Vector2.new(30, 26)

            E.Text1Copy4.Position = NewPos + Vector2.new(71, 16)

            E.Text1Copy5.Position = NewPos + Vector2.new(124, 17)

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

            E.Text2Copy2.Position = NewPos + Vector2.new(340, 18)

            E.Line10Copy4.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy4.To   = NewPos + Vector2.new(34, 38)

            E.Line10Copy5.From = NewPos + Vector2.new(36, 34)
            E.Line10Copy5.To   = NewPos + Vector2.new(39, 39)

            E.Square6Copy.Position = NewPos + Vector2.new(0, 0)

            E.Checkbox1Background.Position  = NewPos + Vector2.new(25, 99)
            E.Checkbox1Fill.Position        = NewPos + Vector2.new(28, 102)
            E.Checkbox1Label.Position       = NewPos + Vector2.new(57, 103)

            E.Checkbox1CopyBackground.Position  = NewPos + Vector2.new(25, 141)
            E.Checkbox1CopyFill.Position        = NewPos + Vector2.new(28, 144)
            E.Checkbox1CopyLabel.Position       = NewPos + Vector2.new(57, 145)

            E.Checkbox1Copy2Background.Position  = NewPos + Vector2.new(222, 99)
            E.Checkbox1Copy2Fill.Position        = NewPos + Vector2.new(225, 102)
            E.Checkbox1Copy2Label.Position       = NewPos + Vector2.new(254, 103)

            E.Square1Copy5.Position = NewPos + Vector2.new(20, 67)

            E.Text7.Position = NewPos + Vector2.new(27, 77)

            E.Line1Copy4.From = NewPos + Vector2.new(31, 94)
            E.Line1Copy4.To   = NewPos + Vector2.new(184, 94)

            E.Square1Copy6.Position = NewPos + Vector2.new(212, 67)

            E.Text7Copy.Position = NewPos + Vector2.new(222, 76)

            E.Line1Copy5.From = NewPos + Vector2.new(225, 93)
            E.Line1Copy5.To   = NewPos + Vector2.new(379, 93)

            E.Square1Copy7.Position = NewPos + Vector2.new(20, 67)

            E.Square1Copy8.Position = NewPos + Vector2.new(212, 67)

            E.Button1Background.Position = NewPos + Vector2.new(242, 132)
            E.Button1Text.Position       = NewPos + Vector2.new(302, 141)
        end

    end)
end
end)()
