-- ThemeManager.lua
local ThemeManager = {}

function ThemeManager:ApplyTheme(window, theme)
    window.BackgroundColor3 = theme.MainColor
    -- Add theme application logic here
end

return ThemeManager
