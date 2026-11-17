
-- O-BLOCK 👺 | OUTSIDE PVP V7
-- Full panel | Roblox Luau

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

if _G.OBLOCK_CLEANUP then
    pcall(_G.OBLOCK_CLEANUP)
end

local old = PG:FindFirstChild("OBLOCK_V7")
if old then old:Destroy() end

local cfg = {
    Aim = false,
    ESP = false,
    Health = false,
    FOV = true,
    Wall = true,
    Dead = true,
    Team = false,
    Radius = 140,
    Smooth = 0.18
}

local purple = Color3.fromRGB(175, 70, 255)
local dark = Color3.fromRGB(13, 9, 23)
local connections = {}
local visuals = {}
local running = true
local aiming = false

local gui = Instance.new("ScreenGui")
gui.Name = "OBLOCK_V7"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PG

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function makeText(parent, value, size)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = value
    t.TextSize = size
    t.Font = Enum.Font.GothamBold
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Parent = parent
    return t
end

-- MAIN PANEL

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(310, 430)
panel.Position = UDim2.new(0.5, -155, 0.5, -215)
panel.BackgroundColor3 = dark
panel.BorderSizePixel = 0
panel.Active = true
panel.ClipsDescendants = true
panel.Parent = gui
round(panel, 15)

local border = Instance.new("UIStroke")
border.Color = purple
border.Thickness = 2
border.Parent = panel

-- ANIMATED BACKGROUND

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = dark
bg.BorderSizePixel = 0
bg.Parent = panel

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0, Color3.fromRGB(14, 8, 24)
    ),
    ColorSequenceKeypoint.new(
        0.5, Color3.fromRGB(75, 22, 110)
    ),
    ColorSequenceKeypoint.new(
        1, Color3.fromRGB(12, 7, 20)
    )
})
gradient.Parent = bg

local animation = TweenService:Create(
    gradient,
    TweenInfo.new(
        5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ),
    {Rotation = 180}
)
animation:Play()

local wallpaper = Instance.new("ImageLabel")
wallpaper.Size = UDim2.fromScale(1, 1)
wallpaper.BackgroundTransparency = 1
wallpaper.Image = ""
-- Insert Roblox image asset ID below:
-- wallpaper.Image = "rbxassetid://123456789"
wallpaper.ImageTransparency = 0.55
wallpaper.ScaleType = Enum.ScaleType.Crop
wallpaper.Parent = panel

local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1, 1)
shade.BackgroundColor3 = Color3.fromRGB(8, 5, 15)
shade.BackgroundTransparency = 0.4
shade.BorderSizePixel = 0
shade.Parent = panel

-- HEADER

local header = makeText(panel, "O-BLOCK 👺 | V7", 20)
header.Size = UDim2.new(1, -95, 0, 48)
header.Position = UDim2.fromOffset(15, 0)
header.TextXAlignment = Enum.TextXAlignment.Left
header.TextColor3 = Color3.fromRGB(220, 165, 255)
header.Active = true

local function smallButton(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(32, 32)
    b.Position = UDim2.new(1, x, 0, 8)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 19
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(80, 35, 130)
    b.Parent = panel
    round(b, 8)
    return b
end

local minimize = smallButton("-", -80)
local close = smallButton("X", -42)
close.BackgroundColor3 = Color3.fromRGB(145, 35, 65)

-- SCROLLING CONTENT

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -24, 1, -105)
scroll.Position = UDim2.fromOffset(12, 55)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.fromOffset(0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = scroll

local function button(label, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 42)
    b.BackgroundColor3 = Color3.fromRGB(55, 25, 85)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Text = label
    b.Parent = scroll
    round(b, 9)

    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback, b)
        if not ok then
            warn("O-BLOCK BUTTON:", err)
        end
    end)
    return b
end

local aimHold

local function toggle(label, key)
    local function refresh(b)
        b.Text = label .. ": " ..
            (cfg[key] and "ON" or "OFF")
        b.BackgroundColor3 = cfg[key]
            and Color3.fromRGB(110, 40, 165)
            or Color3.fromRGB(55, 25, 85)
    end

    local b = button("", function(btn)
        cfg[key] = not cfg[key]
        refresh(btn)

        if key == "Aim" and aimHold then
            aimHold.Visible = cfg.Aim
            if not cfg.Aim then aiming = false end
        end
    end)
    refresh(b)
end

toggle("🎯 AIMBOT HEAD", "Aim")
toggle("📦 ESP BOX", "ESP")
toggle("❤️ HEALTH BAR", "Health")
toggle("⭕ FOV CIRCLE", "FOV")
toggle("🧱 WALL CHECK", "Wall")
toggle("💀 IGNORE DEAD", "Dead")
toggle("🛡️ TEAM CHECK", "Team")

button("⭕ FOV RADIUS: 140", function(b)
    cfg.Radius = cfg.Radius + 25
    if cfg.Radius > 350 then
        cfg.Radius = 50
    end
    b.Text = "⭕ FOV RADIUS: " .. cfg.Radius
end)

button("🎚️ AIM SMOOTH: 0.18", function(b)
    cfg.Smooth = cfg.Smooth + 0.1
    if cfg.Smooth > 0.85 then
        cfg.Smooth = 0.08
    end
    b.Text = string.format(
        "🎚️ AIM SMOOTH: %.2f", cfg.Smooth
    )
end)

local footer = makeText(
    panel,
    "OUTSIDE PVP | O-BLOCK SYSTEM",
    11
)
footer.Size = UDim2.new(1, -20, 0, 28)
footer.Position = UDim2.new(0, 10, 1, -35)
footer.TextColor3 = Color3.fromRGB(195, 130, 255)

-- MINIMIZE BUTTON

local floating = Instance.new("TextButton")
floating.Size = UDim2.fromOffset(56, 56)
floating.Position = UDim2.new(0, 15, 0.5, -28)
floating.BackgroundColor3 = Color3.fromRGB(45, 15, 75)
floating.Text = "👺"
floating.TextSize = 28
floating.Visible = false
floating.Active = true
floating.Parent = gui
round(floating, 28)

local fs = Instance.new("UIStroke")
fs.Color = purple
fs.Thickness = 2
fs.Parent = floating

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    floating.Visible = true
end)

floating.MouseButton1Click:Connect(function()
    panel.Visible = true
    floating.Visible = false
end)

-- DRAG SUPPORT

local function draggable(handle, target)
    local dragging = false
    local dragInput
    local start
    local original

    table.insert(connections,
        handle.InputBegan:Connect(function(input)
            if input.UserInputType ==
                Enum.UserInputType.Touch
            or input.UserInputType ==
                Enum.UserInputType.MouseButton1 then

                dragging = true
                start = input.Position
                original = target.Position

                table.insert(connections,
                    input.Changed:Connect(function()
                        if input.UserInputState ==
                            Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                )
            end
        end)
    )

    table.insert(connections,
        handle.InputChanged:Connect(function(input)
            if input.UserInputType ==
                Enum.UserInputType.Touch
            or input.UserInputType ==
                Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
    )

    table.insert(connections,
        UIS.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - start
                target.Position = UDim2.new(
                    original.X.Scale,
                    original.X.Offset + delta.X,
                    original.Y.Scale,
                    original.Y.Offset + delta.Y
                )
            end
        end)
    )
end

draggable(header, panel)
draggable(floating, floating)

-- AIM HOLD BUTTON

aimHold = Instance.new("TextButton")
aimHold.Size = UDim2.fromOffset(75, 48)
aimHold.Position = UDim2.new(1, -95, 0.58, 0)
aimHold.BackgroundColor3 = Color3.fromRGB(85, 30, 135)
aimHold.Text = "🎯 MIRAR"
aimHold.TextColor3 = Color3.new(1, 1, 1)
aimHold.TextSize = 13
aimHold.Font = Enum.Font.GothamBold
aimHold.Visible = false
aimHold.Parent = gui
round(aimHold, 12)

table.insert(connections,
    aimHold.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.Touch
        or input.UserInputType ==
            Enum.UserInputType.MouseButton1 then
            aiming = true
        end
    end)
)

table.insert(connections,
    aimHold.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.Touch
        or input.UserInputType ==
            Enum.UserInputType.MouseButton1 then
            aiming = false
        end
    end)
)

-- FOV CIRCLE

local circle = Instance.new("Frame")
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.Parent = gui
round(circle, 1000)

local cs = Instance.new("UIStroke")
cs.Color = purple
cs.Thickness = 2
cs.Parent = circle

-- PLAYER VALIDATION

local function valid(p)
    if p == LP then return nil end

    if cfg.Team and LP.Team ~= nil
        and p.Team == LP.Team then
        return nil
    end

    local char = p.Character
    if not char then return nil end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or not head or not root then
        return nil
    end

    if cfg.Dead and hum.Health <= 0 then
        return nil
    end

    return char, hum, head, root
end

-- WALL CHECK

local function visible(camera, char, head)
    if not cfg.Wall then return true end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local excluded = {camera}
    if LP.Character then
        table.insert(excluded, LP.Character)
    end

    params.FilterDescendantsInstances = excluded

    local origin = camera.CFrame.Position
    local hit = workspace:Raycast(
        origin,
        head.Position - origin,
        params
    )

    return hit ~= nil
        and hit.Instance:IsDescendantOf(char)
end

-- TARGET SELECTION

local function getTarget(camera)
    local size = camera.ViewportSize
    local center = Vector2.new(
        size.X / 2, size.Y / 2
    )

    local best = nil
    local bestDist = cfg.Radius

    for _, p in ipairs(Players:GetPlayers()) do
        local char, hum, head = valid(p)

        if char then
            local pos, onScreen =
                camera:WorldToViewportPoint(head.Position)

            if onScreen and pos.Z > 0 then
                local dist = (
                    Vector2.new(pos.X, pos.Y) - center
                ).Magnitude

                if dist < bestDist
                    and visible(camera, char, head) then
                    best = head
                    bestDist = dist
                end
            end
        end
    end

    return best
end

-- ESP BOX + HEALTH BAR

local function clearESP(p)
    local v = visuals[p]
    if v then
        v.Frame:Destroy()
        visuals[p] = nil
    end
end

local function createESP(p)
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = gui

    local outline = Instance.new("UIStroke")
    outline.Color = purple
    outline.Thickness = 2
    outline.Parent = box

    local healthBack = Instance.new("Frame")
    healthBack.Size = UDim2.new(0, 5, 1, 0)
    healthBack.Position = UDim2.fromOffset(-10, 0)
    healthBack.BackgroundColor3 =
        Color3.fromRGB(90, 20, 25)
    healthBack.BorderSizePixel = 0
    healthBack.Parent = box

    local fill = Instance.new("Frame")
    fill.AnchorPoint = Vector2.new(0, 1)
    fill.Position = UDim2.fromScale(0, 1)
    fill.Size = UDim2.fromScale(1, 1)
    fill.BorderSizePixel = 0
    fill.Parent = healthBack

    visuals[p] = {
        Frame = box,
        Outline = outline,
        Back = healthBack,
        Fill = fill
    }
end

local function updateESP(p, camera)
    if not cfg.ESP and not cfg.Health then
        clearESP(p)
        return
    end

    local char, hum, head, root = valid(p)
    if not char then
        clearESP(p)
        return
    end

    local top, onScreen = camera:WorldToViewportPoint(
        head.Position + Vector3.new(0, 0.7, 0)
    )
    local bottom = camera:WorldToViewportPoint(
        root.Position - Vector3.new(0, 3, 0)
    )

    if not onScreen or top.Z <= 0 or bottom.Z <= 0 then
        clearESP(p)
        return
    end

    local height = math.abs(bottom.Y - top.Y)
    if height < 2 then
        clearESP(p)
        return
    end

    local width = height * 0.55

    if not visuals[p] then
        createESP(p)
    end

    local v = visuals[p]

    v.Frame.Size = UDim2.fromOffset(width, height)
    v.Frame.Position = UDim2.fromOffset(
        top.X - width / 2,
        math.min(top.Y, bottom.Y)
    )

    v.Outline.Enabled = cfg.ESP
    v.Back.Visible = cfg.Health

    local ratio = math.clamp(
        hum.Health / math.max(hum.MaxHealth, 1),
        0, 1
    )

    v.Fill.Size = UDim2.fromScale(1, ratio)
    v.Fill.BackgroundColor3 = Color3.fromRGB(
        math.floor(255 * (1 - ratio)),
        math.floor(255 * ratio),
        35
    )
end

-- MAIN LOOP

local timer = 0

table.insert(connections,
    RunService.RenderStepped:Connect(function(dt)
        if not running then return end

        local camera = workspace.CurrentCamera
        if not camera then return end

        local size = camera.ViewportSize

        circle.Visible = cfg.FOV
        circle.Size = UDim2.fromOffset(
            cfg.Radius * 2,
            cfg.Radius * 2
        )
        circle.Position = UDim2.fromOffset(
            size.X / 2,
            size.Y / 2
        )

        if cfg.Aim and aiming then
            local target = getTarget(camera)

            if target and target.Parent then
                local desired = CFrame.lookAt(
                    camera.CFrame.Position,
                    target.Position
                )

                camera.CFrame = camera.CFrame:Lerp(
                    desired,
                    math.clamp(cfg.Smooth, 0.01, 1)
                )
            end
        end

        timer = timer + dt

        if timer >= 0.1 then
            timer = 0

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    updateESP(p, camera)
                end
            end
        end
    end)
)

table.insert(connections,
    Players.PlayerRemoving:Connect(clearESP)
)

-- CLEANUP

local function cleanup()
    running = false
    aiming = false
    animation:Cancel()

    for _, c in ipairs(connections) do
        c:Disconnect()
    end

    for p in pairs(visuals) do
        clearESP(p)
    end

    gui:Destroy()
end

_G.OBLOCK_CLEANUP = cleanup

close.MouseButton1Click:Connect(cleanup)

print("O-BLOCK V7 loaded successfully")
