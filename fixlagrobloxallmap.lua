-- Xóa Menu cũ nếu có để tránh trùng lặp
local oldUI = game.CoreGui:FindFirstChild("PinLagFixMenu")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FixBtn = Instance.new("TextButton")
local ClearEffectsBtn = Instance.new("TextButton")
local ResetBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "PinLagFixMenu"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.2, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Pin FPS Booster (Fixed)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

FixBtn.Name = "FixBtn"
FixBtn.Parent = MainFrame
FixBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
FixBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
FixBtn.Size = UDim2.new(0.8, 0, 0, 30)
FixBtn.Font = Enum.Font.SourceSansBold
FixBtn.Text = "SIÊU FIX LAG (MƯỢT MÀ)"
FixBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FixBtn.TextSize = 14

ClearEffectsBtn.Name = "ClearEffectsBtn"
ClearEffectsBtn.Parent = MainFrame
ClearEffectsBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
ClearEffectsBtn.Position = UDim2.new(0.1, 0, 0.50, 0)
ClearEffectsBtn.Size = UDim2.new(0.8, 0, 0, 30)
ClearEffectsBtn.Font = Enum.Font.SourceSansBold
ClearEffectsBtn.Text = "XÓA HIỆU ỨNG & SƯƠNG MÙ"
ClearEffectsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearEffectsBtn.TextSize = 14

ResetBtn.Name = "ResetBtn"
ResetBtn.Parent = MainFrame
ResetBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
ResetBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
ResetBtn.Size = UDim2.new(0.8, 0, 0, 30)
ResetBtn.Font = Enum.Font.SourceSansBold
ResetBtn.Text = "ĐÓNG MENU"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 14

-- Hàm tối ưu nâng cao: Chia nhỏ tiến trình để chống crash/đứng game
local function BoostFPS_Safe()
    local l = game:GetService("Lighting")
    l.GlobalShadows = false
    l.FogEnd = 9e9
    
    local descendants = game:GetDescendants()
    local count = 0
    
    for _, v in pairs(descendants) do
        count = count + 1
        -- Cứ quét được 500 vật thể thì nghỉ 1 khung hình nhỏ để CPU thở, không bị đơ máy
        if count % 500 == 0 then
            task.wait()
        end
        
        pcall(function()
            if v:IsA("Part") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("WedgePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.TextureID = ""
            end
        </pcall>)
    end
end

local function ClearEffects()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        end
    end
end

FixBtn.MouseButton1Click:Connect(function()
    FixBtn.Text = "DANG FIX... (KHOẢNG 5-10S)"
    FixBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    -- Chạy ngầm tiến trình quét bằng task.spawn để không làm treo giao diện chính
    task.spawn(function()
        pcall(BoostFPS_Safe)
        FixBtn.Text = "ĐÃ FIX LAG XONG!"
        FixBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
end)

ClearEffectsBtn.MouseButton1Click:Connect(function()
    pcall(ClearEffects)
    ClearEffectsBtn.Text = "ĐÃ XÓA HIỆU ỨNG!"
    ClearEffectsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

ResetBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
