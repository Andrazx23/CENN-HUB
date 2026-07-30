local cloneref = cloneref or function(x)
    return x
end

local game = cloneref(game)
local starter_gui = cloneref(game:GetService("StarterGui"))

type loader_config = {
    name: string,
    url: string,
    version: string?,
    author: string?,
}

local ___place_loaders: { [number]: loader_config } = {
    [17577256698] = {
        name = "Hutan",
        url = "https://luaegis.net/scripts/v4/loaders/cc5e1426-c93e-4fe2-8f4b-cfdbc8432cd4.lua",
        version = "1.0.0",
        author = "cenhub",
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
    for attempt = 1, 3 do
        print(("[Loader] Attempt %d"):format(attempt))
        print("[Loader] URL:", url)

        local success, result = pcall(function()
            local source = game:HttpGet(url)

            assert(type(source) == "string", "HttpGet returned nil")
            assert(#source > 0, "Downloaded script is empty")

            -- Jika server mengembalikan HTML (404/Cloudflare/login)
            local lower = source:lower()
            if lower:find("<html") or lower:find("<!doctype") then
                error("Server returned HTML instead of Lua source.")
            end

            local fn, compileErr = loadstring(source)
            assert(fn, compileErr)

            return fn()
        end)

        if success then
            print("[Loader] Loaded successfully.")
            return true
        end

        warn(("[Loader] Attempt %d failed: %s"):format(attempt, tostring(result)))

        if attempt < 3 then
            task.wait(1)
        end
    end

    __notify("Cenn hub Loader", "Failed to load script.")
    return false
end

local loader_config = ___place_loaders[game.PlaceId]

if not loader_config then
    warn("[Loader] Unsupported PlaceId:", game.PlaceId)

    __notify(
        "Cenn hub Loader",
        ("Unsupported game (%d)"):format(game.PlaceId)
    )

    return
end

print("[Loader] Game:", loader_config.name)
print("[Loader] Version:", loader_config.version or "Unknown")
print("[Loader] Author:", loader_config.author or "Unknown")

__load_script(loader_config.url)
