local cloneref = cloneref or function(x) return x end

local game = cloneref(game)
local starter_gui = cloneref(game:GetService("StarterGui"))

local ___place_loaders = {
    [6701277882] = {
        name = "Hutan",
        url = "https://luaegis.net/scripts/v4/loaders/cc5e1426-c93e-4fe2-8f4b-cfdbc8432cd4.lua",
        version = "1.0.0",
        author = "cenhub",
    },
}

local function __notify(title, text)
    pcall(function()
        starter_gui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
        })
    end)
end

local function __load_script(url)
    local success, result = pcall(function()
        local source = game:HttpGet(url)
        local fn = loadstring(source)

        if not fn then
            error("failed to compile script")
        end

        fn()
    end)

    if not success then
        warn("[loader] failed:", result)
        __notify("loader", "failed to load script")
        return false
    end

    return true
end

local loader_config = ___place_loaders[game.PlaceId]

if not loader_config then
    __notify("loader", "unsupported game")
    return
end

__load_script(loader_config.url)
