-- FarmerUI Pro v1.6 - Screen-anchored Mobile Toggle
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local SAVE_FILE = "FarmerUI_Settings.json"
local DEFAULT_SIZE = {300, 200}
local settings = {Size = {300, 200}, Pos = {0.5, -150, 0.5, -100}}

if readfile and isfile and isfile(SAVE_FILE) then
    local data = HttpService:JSONDecode(readfile(SAVE_FILE))
    settings = data
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FarmerUI"
ScreenGui.IgnoreGuiInset = true 

-- Mobile Toggle Button
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
ToggleBtn.Text = "O"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 200)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Main Window
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, settings.Size[1], 0, settings.Size[2])
Frame.Position = UDim2.new(settings.Pos[1], settings.Pos[2], settings.Pos[3], settings.Pos[4])
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(0, 200, 200)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

ToggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

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
        
        -- Clamped to 350% of DEFAULT_SIZE
        local clampedX = math.clamp(newSize.X, 150, DEFAULT_SIZE[1] * 3.5)
        local clampedY = math.clamp(newSize.Y, 100, DEFAULT_SIZE[2] * 3.5)
        
        Frame.Size = UDim2.new(0, clampedX, 0, clampedY)
        settings.Size = {Frame.Size.X.Offset, Frame.Size.Y.Offset}
        if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(settings)) end
    end
end)
