local cloneref = cloneref or function(x) return x end

local game         = cloneref(game)
local starter_gui  = cloneref(game:GetService("StarterGui"))

--@types
type loader_config = {
    name: string,
    url: string,
    version: string?,
    author: string?,
}

--@list_place_loaders
local ___place_loaders: { [number]: loader_config } = {
    [17577256698] = {
        name    = "Hutan",
        url     = "https://luaegis.net/scripts/v4/loaders/cc5e1426-c93e-4fe2-8f4b-cfdbc8432cd4.lua",
        version = "1.0.0",
        author  = "cenhub",
    },
}


local function __notify(title: string, text: string)
    pcall(function()
        starter_gui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
        })
    end)
end

local function __load_script(url: string): boolean
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
        __notify("euphoria loader", "failed to load script")
        return false
    end

    return true
end

-- Main
local loader_config = ___place_loaders[game.PlaceId] 
__load_script(loader_config.url)
