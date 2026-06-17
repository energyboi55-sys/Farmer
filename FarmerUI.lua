-- FarmerUI.lua
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local FarmerUI = {}
FarmerUI.__index = FarmerUI

-- Base Window
function FarmerUI.new(title: string)
    local self = setmetatable({}, FarmerUI)

self.ScreenGui = Instance.new("ScreenGui", CoreGui)
    self.ScreenGui.Name = title
    self.ScreenGui.IgnoreGuiInset = true
    
    self.MainFrame = Instance.new("Frame", self.ScreenGui)
    self.MainFrame.Size = UDim2.new(0, 300, 0, 200)
    self.MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)
    
    function FarmerUI:AddToggleBtn()
    local ToggleBtn = Instance.new("TextButton", self.ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
    ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
    ToggleBtn.Text = "O"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 200)
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)
    return ToggleBtn
end

    
    self.ScreenGui = Instance.new("ScreenGui", CoreGui)
    self.ScreenGui.Name = title
    self.ScreenGui.IgnoreGuiInset = true
    
    self.MainFrame = Instance.new("Frame", self.ScreenGui)
    self.MainFrame.Size = UDim2.new(0, 300, 0, 200)
    self.MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Resizer
    local Resizer = Instance.new("TextButton", self.MainFrame)
    Resizer.Size = UDim2.new(0, 20, 0, 20)
    Resizer.Position = UDim2.new(1, -20, 1, -20)
    Resizer.Text = "◢"
    Resizer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", Resizer)
    
    local resizing = false
    Resizer.MouseButton1Down:Connect(function() resizing = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local newSize = Vector2.new(mousePos.X - self.MainFrame.AbsolutePosition.X, mousePos.Y - self.MainFrame.AbsolutePosition.Y)
            self.MainFrame.Size = UDim2.new(0, math.clamp(newSize.X, 150, 975), 0, math.clamp(newSize.Y, 100, 650))
        end
    end)
    
    self.TabContainer = Instance.new("Frame", self.MainFrame)
    self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.TabContainer.BackgroundTransparency = 1
    
    return self
end

function FarmerUI:AddTab(name: string)
    local tab = {}
    tab.Frame = Instance.new("ScrollingFrame", self.MainFrame)
    tab.Frame.Size = UDim2.new(1, 0, 1, -30)
    tab.Frame.Position = UDim2.new(0, 0, 0, 30)
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.Visible = false
    Instance.new("UIListLayout", tab.Frame).Padding = UDim.new(0, 5)
    
    local btn = Instance.new("TextButton", self.TabContainer)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.MainFrame:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        tab.Frame.Visible = true
    end)
    
    return tab
end

-- Generators
function FarmerUI:AddToggle(tab, text, callback)
    local state = false
    local btn = Instance.new("TextButton", tab.Frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

function FarmerUI:AddSlider(tab, text, min, max, callback)
    local slider = Instance.new("Frame", tab.Frame)
    slider.Size = UDim2.new(0.9, 0, 0, 40)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local label = Instance.new("TextLabel", slider)
    label.Text = text
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    
    -- Slider logic (dragger) goes here
    return slider
end

function FarmerUI:AddKeyPicker(tab, text, callback)
    -- Keybind logic
end

function FarmerUI:AddColorPicker(tab, text, callback)
    -- Color picker logic
end

return FarmerUI
