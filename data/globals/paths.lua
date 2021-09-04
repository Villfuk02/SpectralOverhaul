SODA.path_root = "__SpectralOverhaul__/"
SODA.path_graphics_root = SODA.path_root .. "graphics/"

function SODA.path_graphics(folders_or_name, name)
    if name then
        return SODA.path_graphics_root .. folders_or_name .. "/" .. name .. ".png"
    else
        return SODA.path_graphics_root .. name .. ".png"
    end
end

function SODA.path_icons(folders_or_name, name)
    return SODA.path_graphics("icons/" .. folders_or_name, name)
end

function SODA.path_entities(folders_or_name, name)
    return SODA.path_graphics("entities/" .. folders_or_name, name)
end
