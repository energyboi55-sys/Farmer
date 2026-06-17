-- FarmerUI Pro v3.3 - Camera Bypass
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Camera = game:GetService("Workspace").CurrentCamera

local FarmerUI = { Options = {}, Toggles = {} }

-- Try parenting to Camera (often bypasses CoreGui protection)
local ScreenGui = Instance.new("ScreenGui", Camera)
ScreenGui.Name = "FarmerUI"
ScreenGui.IgnoreGuiInset = true

-- Mobile Toggle
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
ToggleBtn.Text = "O"
ToggleBtn.ZIndex = 100
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 200)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

function FarmerUI:CreateWindow(config)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    MainFrame.ZIndex = 99
    Instance.new("UICorner", MainFrame)
    
    ToggleBtn.MouseButton1Click:Connect(function() 
        MainFrame.Visible = not MainFrame.Visible 
    end)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = config.Title
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Size = UDim2.new(0, 120, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1

    local Window = { MainFrame = MainFrame }

    function Window:AddTab(name)
        local Tab = Instance.new("ScrollingFrame", MainFrame)
        Tab.Size = UDim2.new(1, -130, 1, -50)
        Tab.Position = UDim2.new(0, 130, 0, 40)
        Tab.Visible = false
        Tab.BackgroundTransparency = 1

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Text = name
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(MainFrame:GetChildren()) do if v:IsA("ScrollingFrame") and v ~= TabContainer then v.Visible = false end end
            Tab.Visible = true
        end)

        local TabObj = {}
        function TabObj:AddLeftGroupbox(name)
            local Box = Instance.new("Frame", Tab)
            Box.Size = UDim2.new(0.45, 0, 0, 300)
            Instance.new("UIListLayout", Box)
            return self:CreateGroupboxMethods(Box)
        end
        
        function TabObj:CreateGroupboxMethods(box)
            return {
                AddToggle = function(self, id, config)
                    local state = false
                    local t = Instance.new("TextButton", box)
                    t.Size = UDim2.new(1, 0, 0, 30)
                    t.Text = config.Text .. ": OFF"
                    t.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    Instance.new("UICorner", t)
                    t.MouseButton1Click:Connect(function()
                        state = not state
                        t.Text = config.Text .. ": " .. (state and "ON" or "OFF")
                        t.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
                        config.Callback(state)
                    end)
                    return {AddKeyPicker = function() end, AddColorPicker = function() return {AddColorPicker = function() end} end}
                end
            }
        end
        return TabObj
    end
    return Window
end

return FarmerUI
