
-- O-BLOCK 👺 | UNIVERSAL PVP V5
-- Roblox Luau

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer

if _G.OBLOCK_STOP then
    pcall(_G.OBLOCK_STOP)
end

local function notify(message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "O-BLOCK 👺 V5",
            Text = tostring(message),
            Duration = 5
        })
    end)
end

local parent = LP:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "OBLOCK_V5"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

local config = {
    Aim = false,
    ESP = false,
    FOV = true,
    WallCheck = true,
    IgnoreDead = true,
    TeamCheck = false,
    Radius = 140,
    Smooth = 0.18
}

local connections = {}
local visuals = {}
local running = true

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(300, 450)
panel.Position = UDim2.new(0.5, -150, 0.5, -225)
panel.BackgroundColor3 = Color3.fromRGB(20, 18, 29)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui
round(panel, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 70, 255)
stroke.Thickness = 2
stroke.Parent = panel

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -50, 0, 45)
header.Position = UDim2.fromOffset(12, 0)
header.BackgroundTransparency = 1
header.Text = "O-BLOCK 👺 | PVP V5"
header.TextColor3 = Color3.fromRGB(210, 145, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 19
header.TextXAlignment = Enum.TextXAlignment.Left
header.Active = true
header.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(150, 40, 65)
close.TextColor3 = Color3.new(1, 1, 1)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.Parent = panel
round(close, 7)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.fromOffset(10, 50)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.fromOffset(0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = content

local function button(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 39)
    b.BackgroundColor3 = Color3.fromRGB(75, 40, 115)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.Parent = content
    round(b, 8)

    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback, b)
        if not ok then
            warn("O-BLOCK BUTTON ERROR:", err)
            notify("Button error - check console")
        end
    end)

    return b
end

local function toggle(label, key)
    button(label .. ": " .. (config[key] and "ON" or "OFF"), function(b)
        config[key] = not config[key]
        b.Text = label .. ": " ..
            (config[key] and "ON" or "OFF")
    end)
end

toggle("🎯 AIMBOT HEAD", "Aim")
toggle("📦 ESP BOX + HEALTH", "ESP")
toggle("⭕ SHOW FOV", "FOV")
toggle("🧱 WALL CHECK", "WallCheck")
toggle("💀 IGNORE DEAD", "IgnoreDead")
toggle("🛡️ TEAM CHECK", "TeamCheck")

button("⭕ FOV: 140", function(b)
    config.Radius = config.Radius + 30
    if config.Radius > 350 then
        config.Radius = 50
    end
    b.Text = "⭕ FOV: " .. config.Radius
end)

button("🎚️ SMOOTH: 0.18", function(b)
    config.Smooth = config.Smooth + 0.1
    if config.Smooth > 0.85 then
        config.Smooth = 0.08
    end
    b.Text = string.format(
        "🎚️ SMOOTH: %.2f",
        config.Smooth
    )
end)

-- Dragging for mobile

local dragging = false
local dragStart
local startPosition

table.insert(connections, header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
    end
end))

table.insert(connections, UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart

        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end))

table.insert(connections, UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end))

-- FOV circle

local circle = Instance.new("Frame")
circle.Name = "FOV"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.Parent = gui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circle

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(190, 90, 255)
circleStroke.Thickness = 2
circleStroke.Parent = circle

local function valid(p)
    if p == LP then
        return nil
    end

    if config.TeamCheck
    and LP.Team ~= nil
    and p.Team == LP.Team then
        return nil
    end

    local character = p.Character
    if not character then
        return nil
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    local head = character:FindFirstChild("Head")

    if not humanoid or not head then
        return nil
    end

    if config.IgnoreDead and humanoid.Health <= 0 then
        return nil
    end

    return character, humanoid, head
end

-- Visibility check

local function visible(camera, character, head)
    if not config.WallCheck then
        return true
    end

    local origin = camera.CFrame.Position
    local direction = head.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local excluded = {camera}

    if LP.Character then
        table.insert(excluded, LP.Character)
    end

    params.FilterDescendantsInstances = excluded

    local hit = workspace:Raycast(
        origin,
        direction,
        params
    )

    if not hit then
        return true
    end

    return hit.Instance:IsDescendantOf(character)
end

-- Target selection

local function getTarget(camera)
    local size = camera.ViewportSize
    local center = Vector2.new(
        size.X / 2,
        size.Y / 2
    )

    local best = nil
    local bestDistance = config.Radius

    for _, p in ipairs(Players:GetPlayers()) do
        local character, humanoid, head = valid(p)

        if character then
            local pos, onScreen =
                camera:WorldToViewportPoint(head.Position)

            if onScreen and pos.Z > 0 then
                local distance = (
                    Vector2.new(pos.X, pos.Y) - center
                ).Magnitude

                if distance < bestDistance
                and visible(camera, character, head) then
                    best = head
                    bestDistance = distance
                end
            end
        end
    end

    return best
end

-- ESP visuals

local function clearESP(p)
    if visuals[p] then
        visuals[p].Frame:Destroy()
        visuals[p] = nil
    end
end

local function createESP(p)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Parent = gui

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(180, 80, 255)
    outline.Thickness = 2
    outline.Parent = frame

    local background = Instance.new("Frame")
    background.Size = UDim2.new(0, 5, 1, 0)
    background.Position = UDim2.fromOffset(-10, 0)
    background.BackgroundColor3 = Color3.fromRGB(90, 20, 20)
    background.BorderSizePixel = 0
    background.Parent = frame

    local health = Instance.new("Frame")
    health.AnchorPoint = Vector2.new(0, 1)
    health.Position = UDim2.fromScale(0, 1)
    health.Size = UDim2.fromScale(1, 1)
    health.BackgroundColor3 = Color3.fromRGB(40, 255, 80)
    health.BorderSizePixel = 0
    health.Parent = background

    visuals[p] = {
        Frame = frame,
        Health = health
    }
end

local function updateESP(p, camera)
    if not config.ESP then
        clearESP(p)
        return
    end

    local character, humanoid, head = valid(p)

    if not character then
        clearESP(p)
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        clearESP(p)
        return
    end

    local top = camera:WorldToViewportPoint(
        head.Position + Vector3.new(0, 0.7, 0)
    )

    local bottom = camera:WorldToViewportPoint(
        root.Position - Vector3.new(0, 3, 0)
    )

    if top.Z <= 0 or bottom.Z <= 0 then
        clearESP(p)
        return
    end

    local height = math.abs(bottom.Y - top.Y)
    local width = height * 0.55

    if height < 2 then
        clearESP(p)
        return
    end

    if not visuals[p] then
        createESP(p)
    end

    local visual = visuals[p]

    visual.Frame.Size = UDim2.fromOffset(width, height)
    visual.Frame.Position = UDim2.fromOffset(
        top.X - width / 2,
        math.min(top.Y, bottom.Y)
    )

    local ratio = math.clamp(
        humanoid.Health / math.max(humanoid.MaxHealth, 1),
        0,
        1
    )

    visual.Health.Size = UDim2.fromScale(1, ratio)

    visual.Health.BackgroundColor3 = Color3.fromRGB(
        math.floor(255 * (1 - ratio)),
        math.floor(255 * ratio),
        35
    )
end

-- Main update loop

local timer = 0

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not running then
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    circle.Visible = config.FOV
    circle.Size = UDim2.fromOffset(
        config.Radius * 2,
        config.Radius * 2
    )
    circle.Position = UDim2.fromOffset(
        viewport.X / 2,
        viewport.Y / 2
    )

    if config.Aim then
        local target = getTarget(camera)

        if target and target.Parent then
            local desired = CFrame.lookAt(
                camera.CFrame.Position,
                target.Position
            )

            camera.CFrame = camera.CFrame:Lerp(
                desired,
                math.clamp(config.Smooth, 0.01, 1)
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
end))

table.insert(connections, Players.PlayerRemoving:Connect(clearESP))

-- Cleanup

local function cleanup()
    running = false

    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end

    for p in pairs(visuals) do
        clearESP(p)
    end

    gui:Destroy()
end

_G.OBLOCK_STOP = cleanup

close.MouseButton1Click:Connect(cleanup)

notify("O-BLOCK V5 loaded successfully!")
