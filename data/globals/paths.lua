SODA.path_root = "__SpectralOverhaul__/"
local vanilla_root = "__base__/"

function SODA.path(path, vanilla)
    if (vanilla) then
        return vanilla_root .. path
    else
        return SODA.path_root .. path
    end
end

function SODA.path_graphics(folders_or_name, name, vanilla)
    if name then
        return SODA.path("graphics/" .. folders_or_name .. "/" .. name .. ".png", vanilla)
    else
        return SODA.path("graphics/" .. folders_or_name .. ".png", vanilla)
    end
end

function SODA.path_icons(folders_or_name, name, vanilla)
    return SODA.path_graphics("icons/" .. folders_or_name, name, vanilla)
end

function SODA.path_entities(folders_or_name, name, vanilla)
    return SODA.path_graphics("entities/" .. folders_or_name, name, vanilla)
end
