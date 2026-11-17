
-- O-BLOCK 👺 | V1
-- Painel de teleportes e seleção de ovos

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local old = game:GetService("CoreGui"):FindFirstChild("OBLOCK_GUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "OBLOCK_GUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(290, 350)
frame.Position = UDim2.new(0.5, -145, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(180, 40, 255)
stroke.Thickness = 2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 48)
title.BackgroundTransparency = 1
title.Text = "O-BLOCK 👺"
title.TextColor3 = Color3.fromRGB(210, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35, 35)
close.Position = UDim2.new(1, -40, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(150, 35, 55)
close.Parent = frame
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 38)
status.Position = UDim2.fromOffset(10, 300)
status.BackgroundTransparency = 1
status.Text = "Pronto para selecionar um ovo"
status.TextColor3 = Color3.fromRGB(220, 220, 220)
status.TextScaled = true
status.TextWrapped = true
status.Parent = frame

local function button(txt, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 43)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = Color3.fromRGB(85, 35, 140)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.Text = txt
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local selectBtn = button("🥚 ESCOLHER OVO", 55)
local tpBtn = button("⚡ TELEPORTAR AO OVO", 107)
local baseBtn = button("🏠 SALVAR BASE", 159)
local returnBtn = button("🔥 VOLTAR À BASE", 211)
local quickBtn = button("👺 TP RÁPIDO + VOLTAR", 263)

local eggs = {}
local index = 0
local selected = nil
local base = nil
local busy = false

local function root()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getPart(obj)
    if not obj or not obj.Parent then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end
end

local function scan()
    eggs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart"))
            and string.find(string.lower(obj.Name), "egg", 1, true) then
            if getPart(obj) then
                table.insert(eggs, obj)
            end
        end
    end
end

local function teleport(cf)
    local r = root()
    if not r then
        status.Text = "Personagem não encontrado"
        return false
    end
    r.CFrame = cf
    return true
end

selectBtn.MouseButton1Click:Connect(function()
    scan()
    if #eggs == 0 then
        status.Text = "Nenhum objeto Egg encontrado"
        return
    end

    index = index % #eggs + 1
    selected = eggs[index]
    status.Text = "Selecionado: " .. selected.Name
end)

tpBtn.MouseButton1Click:Connect(function()
    local part = getPart(selected)
    if not part then
        status.Text = "Selecione um ovo primeiro"
        return
    end

    if teleport(part.CFrame * CFrame.new(0, 4, 0)) then
        status.Text = "TP realizado: " .. selected.Name
    end
end)

baseBtn.MouseButton1Click:Connect(function()
    local r = root()
    if r then
        base = r.CFrame
        status.Text = "Base salva com sucesso!"
    end
end)

returnBtn.MouseButton1Click:Connect(function()
    if not base then
        status.Text = "Salve sua base primeiro"
        return
    end

    if teleport(base) then
        status.Text = "Retornou à base!"
    end
end)

quickBtn.MouseButton1Click:Connect(function()
    if busy then return end
    local part = getPart(selected)

    if not part or not base then
        status.Text = "Selecione o ovo e salve a base"
        return
    end

    busy = true
    if teleport(part.CFrame * CFrame.new(0, 4, 0)) then
        status.Text = "Perto do ovo; retornando..."
        task.wait(0.5)
        teleport(base)
        status.Text = "Retorno concluído!"
    end
    busy = false
end)

