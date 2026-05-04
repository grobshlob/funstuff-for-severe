--!strict
--!optimize 2

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera: Camera        = workspace.CurrentCamera
local ViewportSize: Vector2 = Camera.ViewportSize

local MathFloor  = math.floor
local TableFind  = table.find

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
E.Square2 = Drawing.new("Square")
E.Keybind1Background  = Drawing.new("Square")
E.Keybind1Text        = Drawing.new("Text")
E.Keybind1Key         = "B"
E.Keybind1Waiting     = false
E.Keybind1WaitReady   = false
E.Keybind1DisplayText = "[B]"
E.Keybind1Fired       = false
E.Text1 = Drawing.new("Text")
E.Line2 = Drawing.new("Line")
E.Text2 = Drawing.new("Text")

E.Square1DragActive     = false
E.Square1DragStartMouse = Vector2.new(0, 0)
E.Square1DragStartPos   = Vector2.new(0, 0)

do

    E.Square1.Position  = Vector2.new(140, 147)
    E.Square1.Size      = Vector2.new(276, 80)
    E.Square1.Color     = Color3.fromRGB(70, 12, 141)
    E.Square1.Opacity   = 1
    E.Square1.Filled    = false
    E.Square1.Thickness = 3
    E.Square1.ZIndex    = 0
    E.Square1.Visible   = true

    E.Square2.Position  = Vector2.new(140, 147)
    E.Square2.Size      = Vector2.new(276, 80)
    E.Square2.Color     = Color3.fromRGB(0, 0, 0)
    E.Square2.Opacity   = 1
    E.Square2.Filled    = true
    E.Square2.Thickness = 1
    E.Square2.ZIndex    = 1
    E.Square2.Visible   = true

    E.Keybind1Background.Position  = Vector2.new(353, 189)
    E.Keybind1Background.Size      = Vector2.new(48, 22)
    E.Keybind1Background.Color     = Color3.fromRGB(70, 12, 141)
    E.Keybind1Background.Filled    = false
    E.Keybind1Background.Thickness = 1
    E.Keybind1Background.ZIndex    = 1
    E.Keybind1Background.Visible   = true

    E.Keybind1Text.Position     = Vector2.new(377, 194)
    E.Keybind1Text.Text         = E.Keybind1DisplayText
    E.Keybind1Text.Size         = 13
    E.Keybind1Text.Font         = 2
    E.Keybind1Text.Color        = Color3.fromRGB(80, 24, 236)
    E.Keybind1Text.Center       = true
    E.Keybind1Text.Outline      = true
    E.Keybind1Text.OutlineColor = Vector3.new(0, 0, 0)
    E.Keybind1Text.ZIndex       = 2
    E.Keybind1Text.Visible      = true

    E.Text1.Position     = Vector2.new(152, 158)
    E.Text1.Text         = "Brog's AP: Combat Warriors"
    E.Text1.Size         = 16
    E.Text1.Font         = 0
    E.Text1.Color        = Color3.fromRGB(80, 24, 236)
    E.Text1.Opacity      = 1
    E.Text1.Center       = false
    E.Text1.Outline      = false
    E.Text1.ZIndex       = 3
    E.Text1.Visible      = true

    E.Line2.From      = Vector2.new(140, 175)
    E.Line2.To        = Vector2.new(415, 175)
    E.Line2.Color     = Color3.fromRGB(70, 12, 141)
    E.Line2.Opacity   = 1
    E.Line2.Thickness = 1
    E.Line2.ZIndex    = 5
    E.Line2.Visible   = true

    E.Text2.Position     = Vector2.new(159, 194)
    E.Text2.Text         = "Auto Parry"
    E.Text2.Size         = 15
    E.Text2.Font         = 0
    E.Text2.Color        = Color3.fromRGB(82, 82, 82)
    E.Text2.Opacity      = 1
    E.Text2.Center       = false
    E.Text2.Outline      = false
    E.Text2.ZIndex       = 7
    E.Text2.Visible      = true
end

do
    local PrevLeftPressed: boolean = false
    local PrevKeys: {string} = {}
    
    function OnKeybind1Change(key: string): ()
        _G.active = not _G.active
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip input when Roblox unfocused
        local Mouse: Vector2       = UserInputService:GetMouseLocation()
        local LeftPressed: boolean = isleftpressed()
        local LeftClicked: boolean = LeftPressed and not PrevLeftPressed
        local Keys: {string}      = getpressedkeys()

        if E.Keybind1Waiting then
            if E.Keybind1WaitReady then
                local Pressed: {string} = getpressedkeys()
                if #Pressed > 0 then
                    E.Keybind1Key         = Pressed[1]
                    E.Keybind1Waiting     = false
                    E.Keybind1WaitReady   = false
                    E.Keybind1DisplayText = "[" .. Pressed[1] .. "]"
                    E.Keybind1Text.Text   = E.Keybind1DisplayText
                    E.Keybind1Fired       = true
                end
            elseif not LeftPressed then
                E.Keybind1WaitReady = true
            end
        else
            if LeftClicked then
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
                E.Keybind1Fired = true
            end
        end

        do
            local SquarePos:  Vector2 = E.Square1.Position
            local SquareSize: Vector2 = E.Square1.Size
            local OnSquare: boolean = Mouse.X >= SquarePos.X and Mouse.X <= SquarePos.X + SquareSize.X
                                  and Mouse.Y >= SquarePos.Y and Mouse.Y <= SquarePos.Y + SquareSize.Y
            local OnChild: boolean = false
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

        PrevKeys        = Keys
        PrevLeftPressed = LeftPressed
    end)

    do
        RunService.PostLocal:Connect(function()
            if not isrbxactive() then return end
            if E.Keybind1Fired then
                E.Keybind1Fired = false
                OnKeybind1Change(E.Keybind1Key)
            end
        end)
    end

    RunService.PreLocal:Connect(function()
        if not isrbxactive() then return end  -- skip per-frame work when unfocused
        local Mouse: Vector2 = UserInputService:GetMouseLocation()

        if E.Square1DragActive then
            local NewPos: Vector2 = E.Square1DragStartPos + (Mouse - E.Square1DragStartMouse)
            E.Square1.Position = NewPos

            E.Text1.Position = NewPos + Vector2.new(12, 11)

            E.Line2.From = NewPos + Vector2.new(0, 28)
            E.Line2.To   = NewPos + Vector2.new(275, 28)

            E.Square2.Position = NewPos + Vector2.new(0, 0)

            E.Keybind1Background.Position = NewPos + Vector2.new(213, 42)
            E.Keybind1Text.Position       = NewPos + Vector2.new(237, 46)

            E.Text2.Position = NewPos + Vector2.new(19, 47)
        end

    end)
end
end)()
