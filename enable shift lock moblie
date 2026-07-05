-- Xóa Shift Lock cũ nếu có để tránh trùng lặp khi chạy lại
local oldShift = game.CoreGui:FindFirstChild("PinShiftLockMobile")
if oldShift then oldShift:Destroy() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Tạo Giao diện Nút Bấm
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PinShiftLockMobile"
ScreenGui.Parent = game.CoreGui

local ShiftButton = Instance.new("TextButton")
ShiftButton.Name = "ShiftButton"
ShiftButton.Parent = ScreenGui
ShiftButton.Size = UDim2.new(0, 55, 0, 55)
ShiftButton.Position = UDim2.new(0.85, 0, 0.7, 0) -- Vị trí góc phải màn hình, gần chỗ nhảy
ShiftButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ShiftButton.BackgroundTransparency = 0.3
ShiftButton.Text = "🔒"
ShiftButton.TextSize = 25
ShiftButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 50) -- Làm nút tròn xoay cho đẹp
UICorner.Parent = ShiftButton

-- Tạo Tâm Ngắm (Crosshair) ở giữa màn hình
local Crosshair = Instance.new("TextLabel")
Crosshair.Name = "Crosshair"
Crosshair.Parent = ScreenGui
Crosshair.Size = UDim2.new(0, 20, 0, 20)
Crosshair.Position = UDim2.new(0.5, -10, 0.5, -10)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextSize = 20
Crosshair.TextColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.Visible = false

-- Biến trạng thái bật/tắt
local shiftLockEnabled = false

-- Hàm xử lý xoay camera và nhân vật
local function UpdateCamera()
    if shiftLockEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
        local camera = workspace.CurrentCamera
        local rootPart = player.Character.HumanoidRootPart
        local humanoid = player.Character.Humanoid
        
        -- Khóa chuột/camera vào giữa
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        
        -- Ép nhân vật xoay theo hướng camera nhìn
        local cameraLook = camera.CFrame.LookVector
        local newLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + newLook)
        
        -- Chỉnh góc camera lệch sang phải một chút giống PC Shift Lock
        camera.CFrame = camera.CFrame * CFrame.new(1.7, 0, 0)
    end
end

-- Bật/Tắt Shift Lock khi bấm nút
ShiftButton.MouseButton1Click:Connect(function()
    shiftLockEnabled = not shiftLockEnabled
    
    if shiftLockEnabled then
        ShiftButton.BackgroundColor3 = Color3.fromRGB(0, 150, 70) -- Đổi sang màu xanh khi bật
        ShiftButton.Text = "🔓"
        Crosshair.Visible = true
        
        -- Đổi góc nhìn nhân vật về dạng Strafe (đi ngang)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.AutoRotate = false
        end
    else
        ShiftButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Về lại màu tối khi tắt
        ShiftButton.Text = "🔒"
        Crosshair.Visible = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.AutoRotate = true
        end
    end
end)

-- Chạy vòng lặp render liên tục để khóa camera mượt mà
RunService.RenderStepped:Connect(UpdateCamera)

-- Tự động bật lại AutoRotate nếu nhân vật bị reset/chết
player.CharacterAdded:Connect(function(char)
    shiftLockEnabled = false
    ShiftButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ShiftButton.Text = "🔒"
    Crosshair.Visible = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end)
