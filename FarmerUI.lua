-- FarmerUI.lua (Updated with Button/Slider)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local FarmerUI = {}
FarmerUI.__index = FarmerUI

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

    self.TabContainer = Instance.new("Frame", self.MainFrame)
    self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.TabContainer.BackgroundTransparency = 1
    return self
end

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

function FarmerUI:AddButton(tab, name, callback)
    local btn = Instance.new("TextButton", tab.Frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function FarmerUI:AddSlider(tab, text, min, max, callback)
    local slider = Instance.new("Frame", tab.Frame)
    slider.Size = UDim2.new(0.9, 0, 0, 40)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", slider)

    local label = Instance.new("TextLabel", slider)
    label.Text = text
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    
    local bar = Instance.new("Frame", slider)
    bar.Size = UDim2.new(0.9, 0, 0, 5)
    bar.Position = UDim2.new(0.05, 0, 0.6, 0)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 200)

    -- Simple slider logic
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local percent = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            callback(math.floor(min + (max - min) * percent))
        end
    end)
    return slider
end

return FarmerUI
