
-- O-BLOCK 👺 | UNIVERSAL PVP V4
-- Roblox Luau | Delta Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer

if _G.OBLOCK_V4_STOP then
    pcall(_G.OBLOCK_V4_STOP)
end
if _G.OBLOCK_V3_STOP then
    pcall(_G.OBLOCK_V3_STOP)
end

local parent = CoreGui
if gethui then
    local ok, result = pcall(gethui)
    if ok and result then
        parent = result
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "OBLOCK_UNIVERSAL_V4"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

local cfg = {
    Aim = false,
    ESP = false,
    FOV = true,
    IgnoreDead = true,
    TeamCheck = false,
    WallCheck = true,
    Radius = 150,
    Smooth = 0.25
}

local purple = Color3.fromRGB(155, 70, 255)
local dark = Color3.fromRGB(17, 17, 25)
local connections = {}
local visuals = {}
local running = true

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function newFrame(parentObj, size, pos, color)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = color
    f.BorderSizePixel = 0
    f.Parent = parentObj
    return f
end

local panel = newFrame(
    gui,
    UDim2.fromOffset(310, 495),
    UDim2.new(0.5, -155, 0.5, -247),
    dark
)
panel.Active = true
corner(panel, 13)

local stroke = Instance.new("UIStroke")
stroke.Color = purple
stroke.Thickness = 2
stroke.Parent = panel

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -55, 0, 48)
header.Position = UDim2.fromOffset(14, 0)
header.BackgroundTransparency = 1
header.Text = "O-BLOCK 👺 | PVP V4"
header.TextColor3 = purple
header.TextSize = 19
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 32)
close.Position = UDim2.new(1, -42, 0, 8)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(150, 35, 60)
close.Font = Enum.Font.GothamBold
close.Parent = panel
corner(close, 7)

local content = newFrame(
    panel,
    UDim2.new(1, -20, 1, -65),
    UDim2.fromOffset(10, 55),
    dark
)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = content

local function button(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 39)
    b.BackgroundColor3 = Color3.fromRGB(65, 37, 100)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 14
    b.Text = text
    b.Parent = content
    corner(b, 8)

    b.MouseButton1Click:Connect(function()
        callback(b)
    end)

    return b
end

local function toggle(label, key)
    return button(
        label .. ": " .. (cfg[key] and "ON" or "OFF"),
        function(b)
            cfg[key] = not cfg[key]
            b.Text = label .. ": " ..
                (cfg[key] and "ON" or "OFF")
        end
    )
end

toggle("🎯 AIMBOT HEAD", "Aim")
toggle("📦 ESP BOX + HEALTH", "ESP")
toggle("⭕ SHOW FOV", "FOV")
toggle("💀 IGNORE DEAD", "IgnoreDead")
toggle("🛡️ TEAM CHECK", "TeamCheck")
toggle("🧱 WALL CHECK", "WallCheck")

button("⭕ FOV RADIUS: 150", function(b)
    cfg.Radius = cfg.Radius + 25
    if cfg.Radius > 350 then
        cfg.Radius = 50
    end
    b.Text = "⭕ FOV RADIUS: " .. cfg.Radius
end)

button("🎚️ AIM SMOOTH: 0.25", function(b)
    cfg.Smooth = cfg.Smooth + 0.1
    if cfg.Smooth > 0.85 then
        cfg.Smooth = 0.05
    end
    b.Text = string.format(
        "🎚️ AIM SMOOTH: %.2f",
        cfg.Smooth
    )
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 28)
status.BackgroundTransparency = 1
status.Text = "O-BLOCK V4 | WALL CHECK READY"
status.TextColor3 = Color3.fromRGB(185, 185, 195)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = content

-- Mobile dragging

local dragging = false
local dragStart
local startPos

header.Active = true

table.insert(connections, header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end))

table.insert(connections, UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end))

table.insert(connections, UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end))

-- FOV circle

local fov = Instance.new("Frame")
fov.Name = "FOV_CIRCLE"
fov.AnchorPoint = Vector2.new(0.5, 0.5)
fov.BackgroundTransparency = 1
fov.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fov

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = purple
fovStroke.Thickness = 2
fovStroke.Parent = fov

local function validPlayer(p)
    if p == LP then
        return false
    end

    if cfg.TeamCheck and LP.Team ~= nil
    and p.Team == LP.Team then
        return false
    end

    local char = p.Character
    if not char then
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")

    if not hum or not head then
        return false
    end

    if cfg.IgnoreDead and hum.Health <= 0 then
        return false
    end

    return true, head, hum
end

-- WALL CHECK / VISIBILITY CHECK

local function isVisible(camera, head, character)
    if not cfg.WallCheck then
        return true
    end

    local origin = camera.CFrame.Position
    local direction = head.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local filter = {camera}

    if LP.Character then
        table.insert(filter, LP.Character)
    end

    params.FilterDescendantsInstances = filter

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

-- TARGET SELECTION

local function getTarget(camera)
    local size = camera.ViewportSize
    local center = Vector2.new(
        size.X / 2,
        size.Y / 2
    )

    local nearest = nil
    local nearestDist = cfg.Radius

    for _, p in ipairs(Players:GetPlayers()) do
        local ok, head = validPlayer(p)

        if ok then
            local pos, onScreen =
                camera:WorldToViewportPoint(head.Position)

            if onScreen and pos.Z > 0 then
                local distance = (
                    Vector2.new(pos.X, pos.Y) - center
                ).Magnitude

                if distance < nearestDist then
                    if isVisible(camera, head, p.Character) then
                        nearest = head
                        nearestDist = distance
                    end
                end
            end
        end
    end

    return nearest
end

-- ESP BOX + HEALTH BAR

local function clearVisual(p)
    local v = visuals[p]
    if v then
        v.Gui:Destroy()
        visuals[p] = nil
    end
end

local function createVisual(p)
    local container = Instance.new("Frame")
    container.Name = "ESP_" .. p.UserId
    container.BackgroundTransparency = 1
    container.Parent = gui

    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.Size = UDim2.fromScale(1, 1)
    box.Parent = container

    local outline = Instance.new("UIStroke")
    outline.Color = purple
    outline.Thickness = 2
    outline.Parent = box

    local healthBack = Instance.new("Frame")
    healthBack.Size = UDim2.new(0, 5, 1, 0)
    healthBack.Position = UDim2.fromOffset(-10, 0)
    healthBack.BackgroundColor3 =
        Color3.fromRGB(90, 20, 20)
    healthBack.BorderSizePixel = 0
    healthBack.Parent = container

    local health = Instance.new("Frame")
    health.AnchorPoint = Vector2.new(0, 1)
    health.Position = UDim2.fromScale(0, 1)
    health.Size = UDim2.fromScale(1, 1)
    health.BackgroundColor3 =
        Color3.fromRGB(40, 255, 80)
    health.BorderSizePixel = 0
    health.Parent = healthBack

    visuals[p] = {
        Gui = container,
        Health = health
    }
end

local function updateESP(p, camera)
    if not cfg.ESP then
        clearVisual(p)
        return
    end

    local ok, head, hum = validPlayer(p)
    if not ok then
        clearVisual(p)
        return
    end

    local char = p.Character
    local root = char:FindFirstChild("HumanoidRootPart")

    if not root then
        clearVisual(p)
        return
    end

    local top = camera:WorldToViewportPoint(
        head.Position + Vector3.new(0, 0.7, 0)
    )

    local bottom = camera:WorldToViewportPoint(
        root.Position - Vector3.new(0, 3, 0)
    )

    if top.Z <= 0 or bottom.Z <= 0 then
        clearVisual(p)
        return
    end

    local height = math.abs(bottom.Y - top.Y)
    local width = height * 0.55

    if height < 2 then
        clearVisual(p)
        return
    end

    if not visuals[p] then
        createVisual(p)
    end

    local v = visuals[p]

    v.Gui.Size = UDim2.fromOffset(width, height)
    v.Gui.Position = UDim2.fromOffset(
        top.X - width / 2,
        math.min(top.Y, bottom.Y)
    )

    local ratio = math.clamp(
        hum.Health / math.max(hum.MaxHealth, 1),
        0,
        1
    )

    v.Health.Size = UDim2.fromScale(1, ratio)

    v.Health.BackgroundColor3 = Color3.fromRGB(
        math.floor(255 * (1 - ratio)),
        math.floor(255 * ratio),
        35
    )
end

-- MAIN LOOP

local espTimer = 0

table.insert(connections,
    RunService.RenderStepped:Connect(function(dt)
        if not running then
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then
            return
        end

        local size = camera.ViewportSize

        fov.Visible = cfg.FOV
        fov.Size = UDim2.fromOffset(
            cfg.Radius * 2,
            cfg.Radius * 2
        )
        fov.Position = UDim2.fromOffset(
            size.X / 2,
            size.Y / 2
        )

        if cfg.Aim then
            local target = getTarget(camera)

            if target then
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

        espTimer = espTimer + dt

        if espTimer >= 0.08 then
            espTimer = 0

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    updateESP(p, camera)
                end
            end
        end
    end)
)

table.insert(connections,
    Players.PlayerRemoving:Connect(function(p)
        clearVisual(p)
    end)
)

-- CLEANUP

local function cleanup()
    running = false

    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end

    for p in pairs(visuals) do
        clearVisual(p)
    end

    gui:Destroy()
end

_G.OBLOCK_V4_STOP = cleanup

close.MouseButton1Click:Connect(cleanup)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "O-BLOCK 👺 V4",
        Text = "Wall Check enabled!",
        Duration = 5
    })
end)
