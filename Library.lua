-- Library.lua
local Library = {}

function Library:CreateWindow(title)
    local Window = {}
    Window.Title = title
    print("Created Window: " .. title)
    -- Add UI creation logic here (ScreenGui, Frame, etc.)
    return Window
end

return Library
