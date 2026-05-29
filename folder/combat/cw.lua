--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor

-- Cached Color3 constants for per-frame hover/toggle writes.
local _HC0: Color3 = Color3.fromRGB(118, 28, 120)
local _HC1: Color3 = Color3.fromRGB(204, 0, 139)
local _HC2: Color3 = Color3.fromRGB(34, 21, 60)
local _HC3: Color3 = Color3.fromRGB(255, 0, 0)
local _HC4: Color3 = Color3.fromRGB(255, 255, 255)

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

E.Square1Copy = Drawing.new("Square")
E.Line1Copy2 = Drawing.new("Line")
E.Text1Copy2 = Drawing.new("Text")
E.Text1Copy3 = Drawing.new("Text")
E.Line4Copy = Drawing.new("Line")
E.Line5Copy = Drawing.new("Line")
E.Line6Copy = Drawing.new("Line")
E.Line7Copy = Drawing.new("Line")
E.Checkbox1Copy2Background = Drawing.new("Square")
E.Checkbox1Copy2Fill       = Drawing.new("Square")
E.Checkbox1Copy2Label      = Drawing.new("Text")
E.Checkbox1Copy2Checked    = false
E.Checkbox1Copy3Background = Drawing.new("Square")
E.Checkbox1Copy3Fill       = Drawing.new("Square")
E.Checkbox1Copy3Label      = Drawing.new("Text")
E.Checkbox1Copy3Checked    = false
E.Line8Copy2 = Drawing.new("Line")
E.Line8Copy3 = Drawing.new("Line")
E.Line9Copy2 = Drawing.new("Line")
E.Line9Copy3 = Drawing.new("Line")
E.Line10Copy2 = Drawing.new("Line")
E.Line10Copy3 = Drawing.new("Line")
E.Text2Copy = Drawing.new("Text")
E.Button2CopyBackground = Drawing.new("Square")
E.Button2CopyText       = Drawing.new("Text")
E.Button2CopyFired    = false
E.Button3CopyBackground = Drawing.new("Square")
E.Button3CopyText       = Drawing.new("Text")

E.Square1CopyDragActive     = false
E.Square1CopyDragStartMouse = Vector2.new(0, 0)
E.Square1CopyDragStartPos   = Vector2.new(0, 0)

do

    E.Square1Copy.Position  = Vector2.new(725, 400)
    E.Square1Copy.Size      = Vector2.new(549, 325)
    E.Square1Copy.Color     = Color3.fromRGB(34, 21, 60)
    E.Square1Copy.Opacity   = 1
    E.Square1Copy.Filled    = true
    E.Square1Copy.Thickness = 1
    E.Square1Copy.Rounding  = 33
    E.Square1Copy.ZIndex    = -2
    E.Square1Copy.Visible   = true

    E.Line1Copy2.From      = Vector2.new(745, 458)
    E.Line1Copy2.To        = Vector2.new(1274, 458)
    E.Line1Copy2.Color     = Color3.fromRGB(133, 133, 133)
    E.Line1Copy2.Opacity   = 0.36
    E.Line1Copy2.Thickness = 1
    E.Line1Copy2.ZIndex    = -1
    E.Line1Copy2.Visible   = true

    E.Text1Copy2.Position     = Vector2.new(808, 421)
    E.Text1Copy2.Text         = "BROG"
    E.Text1Copy2.Size         = 23
    E.Text1Copy2.Font         = 0
    E.Text1Copy2.Color        = Color3.fromRGB(255, 255, 255)
    E.Text1Copy2.Opacity      = 1
    E.Text1Copy2.Center       = false
    E.Text1Copy2.Outline      = false
    E.Text1Copy2.ZIndex       = 0
    E.Text1Copy2.Visible      = true

    E.Text1Copy3.Position     = Vector2.new(870, 419)
    E.Text1Copy3.Text         = ": Combat Warriors"
    E.Text1Copy3.Size         = 23
    E.Text1Copy3.Font         = 0
    E.Text1Copy3.Color        = Color3.fromRGB(204, 0, 139)
    E.Text1Copy3.Opacity      = 1
    E.Text1Copy3.Center       = false
    E.Text1Copy3.Outline      = false
    E.Text1Copy3.ZIndex       = 0
    E.Text1Copy3.Visible      = true

    E.Line4Copy.From      = Vector2.new(760, 425)
    E.Line4Copy.To        = Vector2.new(763, 417)
    E.Line4Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line4Copy.Opacity   = 1
    E.Line4Copy.Thickness = 1
    E.Line4Copy.ZIndex    = 0
    E.Line4Copy.Visible   = true

    E.Line5Copy.From      = Vector2.new(763, 416)
    E.Line5Copy.To        = Vector2.new(767, 423)
    E.Line5Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line5Copy.Opacity   = 1
    E.Line5Copy.Thickness = 1
    E.Line5Copy.ZIndex    = 0
    E.Line5Copy.Visible   = true

    E.Line6Copy.From      = Vector2.new(779, 423)
    E.Line6Copy.To        = Vector2.new(783, 416)
    E.Line6Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line6Copy.Opacity   = 1
    E.Line6Copy.Thickness = 1
    E.Line6Copy.ZIndex    = 0
    E.Line6Copy.Visible   = true

    E.Line7Copy.From      = Vector2.new(783, 416)
    E.Line7Copy.To        = Vector2.new(787, 425)
    E.Line7Copy.Color     = Color3.fromRGB(255, 255, 255)
    E.Line7Copy.Opacity   = 1
    E.Line7Copy.Thickness = 1
    E.Line7Copy.ZIndex    = 0
    E.Line7Copy.Visible   = true

    E.Checkbox1Copy2Background.Position  = Vector2.new(763, 427)
    E.Checkbox1Copy2Background.Size      = Vector2.new(8, 8)
    E.Checkbox1Copy2Background.Color     = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy2Background.Filled    = true
    E.Checkbox1Copy2Background.Thickness = 1
    E.Checkbox1Copy2Background.Rounding  = 100
    E.Checkbox1Copy2Background.ZIndex    = 0
    E.Checkbox1Copy2Background.Visible   = true

    E.Checkbox1Copy2Fill.Position  = Vector2.new(766, 430)
    E.Checkbox1Copy2Fill.Size      = Vector2.new(2, 2)
    E.Checkbox1Copy2Fill.Color     = Color3.fromRGB(0, 255, 0)
    E.Checkbox1Copy2Fill.Filled    = true
    E.Checkbox1Copy2Fill.Rounding  = 99
    E.Checkbox1Copy2Fill.ZIndex    = 1
    E.Checkbox1Copy2Fill.Visible   = false

    E.Checkbox1Copy2Label.Position     = Vector2.new(777, 430)
    E.Checkbox1Copy2Label.Text         = "."
    E.Checkbox1Copy2Label.Size         = 1
    E.Checkbox1Copy2Label.Font         = 2
    E.Checkbox1Copy2Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy2Label.Outline      = false
    E.Checkbox1Copy2Label.ZIndex       = 1
    E.Checkbox1Copy2Label.Visible      = true

    E.Checkbox1Copy3Background.Position  = Vector2.new(776, 427)
    E.Checkbox1Copy3Background.Size      = Vector2.new(8, 8)
    E.Checkbox1Copy3Background.Color     = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy3Background.Filled    = true
    E.Checkbox1Copy3Background.Thickness = 1
    E.Checkbox1Copy3Background.Rounding  = 100
    E.Checkbox1Copy3Background.ZIndex    = 0
    E.Checkbox1Copy3Background.Visible   = true

    E.Checkbox1Copy3Fill.Position  = Vector2.new(779, 430)
    E.Checkbox1Copy3Fill.Size      = Vector2.new(2, 2)
    E.Checkbox1Copy3Fill.Color     = Color3.fromRGB(0, 255, 0)
    E.Checkbox1Copy3Fill.Filled    = true
    E.Checkbox1Copy3Fill.Rounding  = 99
    E.Checkbox1Copy3Fill.ZIndex    = 1
    E.Checkbox1Copy3Fill.Visible   = false

    E.Checkbox1Copy3Label.Position     = Vector2.new(790, 430)
    E.Checkbox1Copy3Label.Text         = "."
    E.Checkbox1Copy3Label.Size         = 1
    E.Checkbox1Copy3Label.Font         = 2
    E.Checkbox1Copy3Label.Color        = Color3.fromRGB(255, 255, 255)
    E.Checkbox1Copy3Label.Outline      = false
    E.Checkbox1Copy3Label.ZIndex       = 1
    E.Checkbox1Copy3Label.Visible      = true

    E.Line8Copy2.From      = Vector2.new(755, 436)
    E.Line8Copy2.To        = Vector2.new(763, 438)
    E.Line8Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy2.Opacity   = 1
    E.Line8Copy2.Thickness = 1
    E.Line8Copy2.ZIndex    = 0
    E.Line8Copy2.Visible   = true

    E.Line8Copy3.From      = Vector2.new(754, 441)
    E.Line8Copy3.To        = Vector2.new(764, 441)
    E.Line8Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line8Copy3.Opacity   = 1
    E.Line8Copy3.Thickness = 1
    E.Line8Copy3.ZIndex    = 0
    E.Line8Copy3.Visible   = true

    E.Line9Copy2.From      = Vector2.new(782, 441)
    E.Line9Copy2.To        = Vector2.new(791, 443)
    E.Line9Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy2.Opacity   = 1
    E.Line9Copy2.Thickness = 1
    E.Line9Copy2.ZIndex    = 0
    E.Line9Copy2.Visible   = true

    E.Line9Copy3.From      = Vector2.new(783, 439)
    E.Line9Copy3.To        = Vector2.new(791, 437)
    E.Line9Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line9Copy3.Opacity   = 1
    E.Line9Copy3.Thickness = 1
    E.Line9Copy3.ZIndex    = 0
    E.Line9Copy3.Visible   = true

    E.Line10Copy2.From      = Vector2.new(772, 440)
    E.Line10Copy2.To        = Vector2.new(773, 437)
    E.Line10Copy2.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy2.Opacity   = 1
    E.Line10Copy2.Thickness = 1
    E.Line10Copy2.ZIndex    = 0
    E.Line10Copy2.Visible   = true

    E.Line10Copy3.From      = Vector2.new(774, 441)
    E.Line10Copy3.To        = Vector2.new(772, 437)
    E.Line10Copy3.Color     = Color3.fromRGB(255, 255, 255)
    E.Line10Copy3.Opacity   = 1
    E.Line10Copy3.Thickness = 1
    E.Line10Copy3.ZIndex    = 0
    E.Line10Copy3.Visible   = true

    E.Text2Copy.Position     = Vector2.new(1164, 421)
    E.Text2Copy.Text         = "Text"
    E.Text2Copy.Size         = 19
    E.Text2Copy.Font         = 0
    E.Text2Copy.Color        = Color3.fromRGB(102, 102, 102)
    E.Text2Copy.Opacity      = 1
    E.Text2Copy.Center       = false
    E.Text2Copy.Outline      = false
    E.Text2Copy.ZIndex       = 0
    E.Text2Copy.Visible      = true

    E.Button2CopyBackground.Position  = Vector2.new(849, 515)
    E.Button2CopyBackground.Size      = Vector2.new(314, 137)
    E.Button2CopyBackground.Color     = Color3.fromRGB(118, 28, 120)
    E.Button2CopyBackground.Filled    = true
    E.Button2CopyBackground.Thickness = 1
    E.Button2CopyBackground.Rounding  = 4
    E.Button2CopyBackground.ZIndex    = 0
    E.Button2CopyBackground.Visible   = true

    E.Button2CopyText.Position     = Vector2.new(1006, 575)
    E.Button2CopyText.Text         = "ON"
    E.Button2CopyText.Size         = 16
    E.Button2CopyText.Font         = 2
    E.Button2CopyText.Color        = Color3.fromRGB(204, 0, 139)
    E.Button2CopyText.Center       = true
    E.Button2CopyText.Outline      = false
    E.Button2CopyText.ZIndex       = 1
    E.Button2CopyText.Visible      = true
    _FitText(E.Button2CopyText, 306.2852007088791)

    E.Button3CopyBackground.Position  = Vector2.new(753, 412)
    E.Button3CopyBackground.Size      = Vector2.new(40, 34)
    E.Button3CopyBackground.Color     = Color3.fromRGB(34, 21, 60)
    E.Button3CopyBackground.Filled    = false
    E.Button3CopyBackground.Thickness = 1
    E.Button3CopyBackground.Rounding  = 4
    E.Button3CopyBackground.ZIndex    = 0
    E.Button3CopyBackground.Visible   = true

    E.Button3CopyText.Position     = Vector2.new(773, 428)
    E.Button3CopyText.Text         = "."
    E.Button3CopyText.Size         = 1
    E.Button3CopyText.Font         = 2
    E.Button3CopyText.Color        = Color3.fromRGB(255, 255, 255)
    E.Button3CopyText.Center       = true
    E.Button3CopyText.Outline      = false
    E.Button3CopyText.ZIndex       = 1
    E.Button3CopyText.Visible      = true
    _FitText(E.Button3CopyText, 32.38921636450823)

    local _PlayerName: string = game.Players.LocalPlayer.Name
    E.Text2Copy.Text = _PlayerName
end

do
    local PrevLeftPressed: boolean = false

local function _DestroyUI(): ()
    if _Destroyed then return end
    _Destroyed = true
    for _, c in _Conns do c:Disconnect() end
    table.clear(_Conns)
    if E.Square1Copy then E.Square1Copy:Remove() end
    if E.Line1Copy2 then E.Line1Copy2:Remove() end
    if E.Text1Copy2 then E.Text1Copy2:Remove() end
    if E.Text1Copy3 then E.Text1Copy3:Remove() end
    if E.Line4Copy then E.Line4Copy:Remove() end
    if E.Line5Copy then E.Line5Copy:Remove() end
    if E.Line6Copy then E.Line6Copy:Remove() end
    if E.Line7Copy then E.Line7Copy:Remove() end
    if E.Checkbox1Copy2Background then E.Checkbox1Copy2Background:Remove() end
    if E.Checkbox1Copy2Fill then E.Checkbox1Copy2Fill:Remove() end
    if E.Checkbox1Copy2Label then E.Checkbox1Copy2Label:Remove() end
    if E.Checkbox1Copy3Background then E.Checkbox1Copy3Background:Remove() end
    if E.Checkbox1Copy3Fill then E.Checkbox1Copy3Fill:Remove() end
    if E.Checkbox1Copy3Label then E.Checkbox1Copy3Label:Remove() end
    if E.Line8Copy2 then E.Line8Copy2:Remove() end
    if E.Line8Copy3 then E.Line8Copy3:Remove() end
    if E.Line9Copy2 then E.Line9Copy2:Remove() end
    if E.Line9Copy3 then E.Line9Copy3:Remove() end
    if E.Line10Copy2 then E.Line10Copy2:Remove() end
    if E.Line10Copy3 then E.Line10Copy3:Remove() end
    if E.Text2Copy then E.Text2Copy:Remove() end
    if E.Button2CopyBackground then E.Button2CopyBackground:Remove() end
    if E.Button2CopyText then E.Button2CopyText:Remove() end
    if E.Button3CopyBackground then E.Button3CopyBackground:Remove() end
    if E.Button3CopyText then E.Button3CopyText:Remove() end
end

    local function OnCheckbox1Copy2Toggle(state: boolean): ()
        
    end

    local function OnCheckbox1Copy3Toggle(state: boolean): ()
        
    end

    local function OnButton2CopyClick(): ()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/folder/combat/c_w.lua"))()
            _G.active = true
    end

    table.insert(_Conns, RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip input when Roblox unfocused
        local Mouse: Vector2       = UserInputService:GetMouseLocation()
        local LeftPressed: boolean = isleftpressed()
        local LeftClicked: boolean = LeftPressed and not PrevLeftPressed

        if LeftClicked then
            local Pos  = E.Checkbox1Copy2Background.Position
            local Size = E.Checkbox1Copy2Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy2Checked = not E.Checkbox1Copy2Checked
            end
        end

        if LeftClicked then
            local Pos  = E.Checkbox1Copy3Background.Position
            local Size = E.Checkbox1Copy3Background.Size
            if Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
            and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y then
                E.Checkbox1Copy3Checked = not E.Checkbox1Copy3Checked
            end
        end

        do
            local Pos  = E.Button2CopyBackground.Position
            local Size = E.Button2CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if Over and LeftClicked then
                E.Button2CopyFired   = true
            end
        end

        do
            local Pos  = E.Button3CopyBackground.Position
            local Size = E.Button3CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            if Over and LeftClicked then
                _DestroyUI()
                return
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1Copy.Position
            local SquareSize: Vector2 = E.Square1Copy.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
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
                local ChildPos  = E.Button2CopyBackground.Position
                local ChildSize = E.Button2CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            do
                local ChildPos  = E.Button3CopyBackground.Position
                local ChildSize = E.Button3CopyBackground.Size
                if Mouse.X >= ChildPos.X and Mouse.X <= ChildPos.X + ChildSize.X
                and Mouse.Y >= ChildPos.Y and Mouse.Y <= ChildPos.Y + ChildSize.Y then
                    OnChild = true
                end
            end
            if LeftPressed and not OnChild and (E.Square1CopyDragActive or OnSquare) then
                if not E.Square1CopyDragActive then
                    E.Square1CopyDragActive     = true
                    E.Square1CopyDragStartMouse = Mouse
                    E.Square1CopyDragStartPos   = SquarePos
                end
            elseif not LeftPressed then
                E.Square1CopyDragActive = false
            end
        end

        PrevLeftPressed = LeftPressed

    end))

    do
        table.insert(_Conns, RunService.PostLocal:Connect(function()
            if not isrbxactive() then return end
            if E.Button2CopyFired then
                E.Button2CopyFired = false
                OnButton2CopyClick()
            end
        end))
    end

    table.insert(_Conns, RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation()

        E.Checkbox1Copy2Fill.Visible = E.Checkbox1Copy2Checked
        E.Checkbox1Copy3Fill.Visible = E.Checkbox1Copy3Checked

        do
            local Pos  = E.Button2CopyBackground.Position
            local Size = E.Button2CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button2CopyBackground.Color = if Over then _HC0 else _HC0
        end
        do
            local Pos  = E.Button3CopyBackground.Position
            local Size = E.Button3CopyBackground.Size
            local Over: boolean = Mouse.X >= Pos.X and Mouse.X <= Pos.X + Size.X
                              and Mouse.Y >= Pos.Y and Mouse.Y <= Pos.Y + Size.Y
            E.Button3CopyBackground.Color = if Over then _HC3 else _HC2
        end

        if E.Square1CopyDragActive then
            local NewPos: Vector2 = E.Square1CopyDragStartPos + (Mouse - E.Square1CopyDragStartMouse)
            E.Square1Copy.Position = NewPos

            E.Text1Copy2.Position = NewPos + Vector2.new(83, 21)

            E.Text1Copy3.Position = NewPos + Vector2.new(145, 19)

            E.Line4Copy.From = NewPos + Vector2.new(35, 17)
            E.Line4Copy.To   = NewPos + Vector2.new(38, 9)

            E.Line5Copy.From = NewPos + Vector2.new(38, 16)
            E.Line5Copy.To   = NewPos + Vector2.new(42, 23)

            E.Line6Copy.From = NewPos + Vector2.new(54, 16)
            E.Line6Copy.To   = NewPos + Vector2.new(58, 9)

            E.Line7Copy.From = NewPos + Vector2.new(58, 16)
            E.Line7Copy.To   = NewPos + Vector2.new(62, 25)

            E.Checkbox1Copy2Background.Position  = NewPos + Vector2.new(38, 27)
            E.Checkbox1Copy2Fill.Position        = NewPos + Vector2.new(41, 30)
            E.Checkbox1Copy2Label.Position       = NewPos + Vector2.new(52, 31)

            E.Checkbox1Copy3Background.Position  = NewPos + Vector2.new(51, 27)
            E.Checkbox1Copy3Fill.Position        = NewPos + Vector2.new(54, 30)
            E.Checkbox1Copy3Label.Position       = NewPos + Vector2.new(65, 31)

            E.Line8Copy2.From = NewPos + Vector2.new(30, 36)
            E.Line8Copy2.To   = NewPos + Vector2.new(38, 38)

            E.Line8Copy3.From = NewPos + Vector2.new(29, 41)
            E.Line8Copy3.To   = NewPos + Vector2.new(39, 41)

            E.Line9Copy2.From = NewPos + Vector2.new(57, 41)
            E.Line9Copy2.To   = NewPos + Vector2.new(66, 43)

            E.Line9Copy3.From = NewPos + Vector2.new(58, 37)
            E.Line9Copy3.To   = NewPos + Vector2.new(66, 35)

            E.Line10Copy2.From = NewPos + Vector2.new(47, 37)
            E.Line10Copy2.To   = NewPos + Vector2.new(48, 34)

            E.Line10Copy3.From = NewPos + Vector2.new(47, 37)
            E.Line10Copy3.To   = NewPos + Vector2.new(45, 33)

            E.Text2Copy.Position = NewPos + Vector2.new(439, 21)

            E.Button2CopyBackground.Position = NewPos + Vector2.new(124, 115)
            E.Button2CopyText.Position       = NewPos + Vector2.new(281, 176)

            E.Button3CopyBackground.Position = NewPos + Vector2.new(28, 12)
            E.Button3CopyText.Position       = NewPos + Vector2.new(48, 29)

            E.Line1Copy2.From = NewPos + Vector2.new(20, 58)
            E.Line1Copy2.To   = NewPos + Vector2.new(549, 58)
        end

    end))
end
end)()
