-- FarmerUI Pro v1.8 - Final Tabs + Resizer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FarmerUI"
ScreenGui.IgnoreGuiInset = true

-- Toggle
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
ToggleBtn.Text = "O"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 200)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Main
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

ToggleBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)

-- Resizer
local Resizer = Instance.new("TextButton", Frame)
Resizer.Size = UDim2.new(0, 20, 0, 20)
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.Text = "◢"
Resizer.TextColor3 = Color3.new(1, 1, 1)
Resizer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", Resizer)

local resizing = false
Resizer.MouseButton1Down:Connect(function() resizing = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local newSize = Vector2.new(mousePos.X - Frame.AbsolutePosition.X, mousePos.Y - Frame.AbsolutePosition.Y)
        Frame.Size = UDim2.new(0, math.clamp(newSize.X, 150, 600), 0, math.clamp(newSize.Y, 100, 600))
    end
end)

-- Tabs
local TabContainer = Instance.new("Frame", Frame)
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function AddTab(name)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", btn)
    
    local content = Instance.new("ScrollingFrame", Frame)
    content.Size = UDim2.new(1, 0, 1, -30)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.BackgroundTransparency = 1
    content.Visible = false
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Frame:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        content.Visible = true
    end)
    return content
end

local tab1 = AddTab("Main")
local tab2 = AddTab("Settings")

-- Toggle
local toggle = Instance.new("TextButton", tab1)
toggle.Size = UDim2.new(0.9, 0, 0, 30)
toggle.Position = UDim2.new(0.05, 0, 0, 10)
toggle.Text = "AutoFarm: OFF"
toggle.MouseButton1Click:Connect(function()
    toggle.Text = (toggle.Text:find("OFF") and "AutoFarm: ON" or "AutoFarm: OFF")
end)
