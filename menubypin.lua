-- Xóa Menu cũ nếu có để tránh trùng lặp
local oldUI = game.CoreGui:FindFirstChild("PinScriptHub")
if oldUI then oldUI:Destroy() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Khởi tạo Giao diện chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PinScriptHub"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 310)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.65, 0, 0, 40)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "★ PIN SCRIPT HUB ★"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút tăng giảm kích cỡ menu (+/-)
local ZoomInBtn = Instance.new("TextButton")
ZoomInBtn.Name = "ZoomInBtn"
ZoomInBtn.Parent = MainFrame
ZoomInBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ZoomInBtn.Position = UDim2.new(0.72, 0, 0.02, 0)
ZoomInBtn.Size = UDim2.new(0, 32, 0, 26)
ZoomInBtn.Font = Enum.Font.SourceSansBold
ZoomInBtn.Text = "+"
ZoomInBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ZoomInBtn.TextSize = 16

local ZoomOutBtn = Instance.new("TextButton")
ZoomOutBtn.Name = "ZoomOutBtn"
ZoomOutBtn.Parent = MainFrame
ZoomOutBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ZoomOutBtn.Position = UDim2.new(0.85, 0, 0.02, 0)
ZoomOutBtn.Size = UDim2.new(0, 32, 0, 26)
ZoomOutBtn.Font = Enum.Font.SourceSansBold
ZoomOutBtn.Text = "-"
ZoomOutBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ZoomOutBtn.TextSize = 16

local currentScale = 1
local buttonCount = 0

local function CreateButton(name, text, color, widthScale, xPos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0, 270 * widthScale, 0, 38)
    
    local yOffset = 45 + (buttonCount * 48)
    btn.Position = UDim2.new(xPos, 0, 0, yOffset)
    
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

---------------------------------------------------------
-- CHỨC NĂNG 1: TỐC ĐỘ (FIX ĐỔI CHỮ LỖI)
---------------------------------------------------------
local speedEnabled = false
local speedValue = 100

local SpeedBtn
SpeedBtn = CreateButton("SpeedBtn", "TỐC ĐỘ: OFF", Color3.fromRGB(0, 110, 190), 0.7, 0.05, function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedBtn.Text = "TỐC ĐỘ: ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
    else
        SpeedBtn.Text = "TỐC ĐỘ: OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 190)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Parent = MainFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedInput.Position = UDim2.new(0.78, 0, 0, 45)
SpeedInput.Size = UDim2.new(0, 62, 0, 38)
SpeedInput.Font = Enum.Font.SourceSansBold
SpeedInput.Text = "100"
SpeedInput.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedInput.TextSize = 14
SpeedInput.PlaceholderText = "Số..."

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 5)
InputCorner.Parent = SpeedInput

SpeedInput.FocusLost:Connect(function()
    local num = tonumber(SpeedInput.Text)
    if num then
        speedValue = num
    else
        SpeedInput.Text = tostring(speedValue)
    end
end)

RunService.RenderStepped:Connect(function()
    if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue
    end
end)

buttonCount = buttonCount + 1

---------------------------------------------------------
-- CHỨC NĂNG 2: FLING
---------------------------------------------------------
local flingEnabled = false
local FlingBtn
FlingBtn = CreateButton("FlingBtn", "FLING (HÚC VĂNG ĐỊCH): OFF", Color3.fromRGB(210, 80, 0), 1, 0.05, function()
    flingEnabled = not flingEnabled
    if flingEnabled then
        FlingBtn.Text = "FLING: ĐANG XOÁY TỬ THẦN"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        
        task.spawn(function()
            while flingEnabled do
                RunService.Heartbeat:Wait()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local oldVel = hrp.Velocity
                    hrp.Velocity = Vector3.new(15000, 15000, 15000)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = oldVel
                end
            end
        end)
    else
        FlingBtn.Text = "FLING (HÚC VĂNG ĐỊCH): OFF"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(210, 80, 0)
    end
end)
buttonCount = buttonCount + 1

---------------------------------------------------------
-- CHỨC NĂNG 3: SHIFT LOCK MOBILE
---------------------------------------------------------
local shiftEnabled = false
local Crosshair = Instance.new("TextLabel")
Crosshair.Parent = ScreenGui
Crosshair.Size = UDim2.new(0, 20, 0, 20)
Crosshair.Position = UDim2.new(0.5, -10, 0.5, -10)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextSize = 20
Crosshair.TextColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.Visible = false

local ShiftBtn
ShiftBtn = CreateButton("ShiftBtn", "SHIFT LOCK MOBILE: OFF", Color3.fromRGB(25, 130, 25), 1, 0.05, function()
    shiftEnabled = not shiftEnabled
    if shiftEnabled then
        ShiftBtn.Text = "SHIFT LOCK: ON"
        ShiftBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        Crosshair.Visible = true
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.AutoRotate = false
        end
    else
        ShiftBtn.Text = "SHIFT LOCK MOBILE: OFF"
        ShiftBtn.BackgroundColor3 = Color3.fromRGB(25, 130, 25)
        Crosshair.Visible = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.AutoRotate = true
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if shiftEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cam = workspace.CurrentCamera
        local root = player.Character.HumanoidRootPart
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        local camLook = cam.CFrame.LookVector
        root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(camLook.X, 0, camLook.Z).Unit)
        cam.CFrame = cam.CFrame * CFrame.new(1.7, 0, 0)
    end
end)
buttonCount = buttonCount + 1

---------------------------------------------------------
-- CHỨC NĂNG 4: FIX LAG
---------------------------------------------------------
local LagBtn
LagBtn = CreateButton("LagBtn", "SIÊU FIX LAG CHỐNG ĐƠ", Color3.fromRGB(85, 95, 105), 1, 0.05, function()
    LagBtn.Text = "ĐANG TỐI ƯU MAP..."
    LagBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    task.spawn(function()
        local l = game:GetService("Lighting")
        l.GlobalShadows = false
        l.FogEnd = 9e9
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        for _, v in pairs(l:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end

        local desc = game:GetDescendants()
        for i, v in pairs(desc) do
            if i % 2000 == 0 then task.wait() end
            pcall(function()
                if v:IsA("Part") or v:IsA("WedgePart") or v:IsA("CornerWedgePart") then
                    v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end)
        end
        LagBtn.Text = "ĐÃ FIX LAG XONG!"
        LagBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
    end)
end)
buttonCount = buttonCount + 1

---------------------------------------------------------
-- NÚT ĐÓNG MENU
---------------------------------------------------------
local CloseBtn = CreateButton("CloseBtn", "ĐÓNG PIN HUB", Color3.fromRGB(170, 30, 30), 1, 0.05, function()
    ScreenGui:Destroy()
end)

---------------------------------------------------------
-- HÀM ĐỔI KÍCH CỠ ĐỒNG BỘ
---------------------------------------------------------
local function ChangeMenuSize(scaleChange)
    currentScale = math.clamp(currentScale + scaleChange, 0.7, 1.6)
    MainFrame.Size = UDim2.new(0, 300 * currentScale, 0, 310 * currentScale)
    
    Title.TextSize = math.floor(16 * currentScale)
    ZoomInBtn.TextSize = math.floor(16 * currentScale)
    ZoomOutBtn.TextSize = math.floor(16 * currentScale)
    
    SpeedInput.Size = UDim2.new(0, 62 * currentScale, 0, 38 * currentScale)
    SpeedInput.Position = UDim2.new(0.74, 0, 0, 45 * currentScale)
    SpeedInput.TextSize = math.floor(14 * currentScale)
    
    SpeedBtn.Size = UDim2.new(0, 195 * currentScale, 0, 38 * currentScale)
    SpeedBtn.Position = UDim2.new(0.05, 0, 0, 45 * currentScale)
    SpeedBtn.TextSize = math.floor(13 * currentScale)
    
    local buttons = { {FlingBtn, 93}, {ShiftBtn, 141}, {LagBtn, 189}, {CloseBtn, 240} }
    for _, item in pairs(buttons) do
        item[1].Size = UDim2.new(0, 270 * currentScale, 0, 38 * currentScale)
        item[1].Position = UDim2.new(0.05, 0, 0, item[2] * currentScale)
        item[1].TextSize = math.floor(13 * currentScale)
    end
end

ZoomInBtn.MouseButton1Click:Connect(function() ChangeMenuSize(0.1) end)
ZoomOutBtn.MouseButton1Click:Connect(function() ChangeMenuSize(-0.1) end)
