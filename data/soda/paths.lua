SODA.path = {}
local root = "__SpectralOverhaul__/"
local vanilla_root = "__base__/"

function SODA.path.path(path, vanilla)
    if (vanilla) then
        return vanilla_root .. path
    else
        return root .. path
    end
end

function SODA.path.graphics(path, vanilla)
    return SODA.path.path("graphics/" .. path .. ".png", vanilla)
end

function SODA.path.icons(path, vanilla)
    return SODA.path.graphics("icons/" .. path, vanilla)
end

function SODA.path.entities(path, vanilla)
    return SODA.path.graphics("entities/" .. path, vanilla)
end
