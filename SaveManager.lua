-- SaveManager.lua
local SaveManager = {}

function SaveManager:Save(folder, data)
    local HttpService = game:GetService("HttpService")
    local encoded = HttpService:JSONEncode(data)
    writefile(folder .. "/config.json", encoded)
end

function SaveManager:Load(folder)
    local HttpService = game:GetService("HttpService")
    if isfile(folder .. "/config.json") then
        return HttpService:JSONDecode(readfile(folder .. "/config.json"))
    end
    return {}
end

return SaveManager
