local icons = require "data.globals.icons"

return function(name, order, subgroup, stack_size, icon_spec, pictures)
    if icon_spec == nil then
        icon_spec = {}
    end
    local temp = {type = "item", name = name, order = order .. "[" .. name .. "]", stack_size = stack_size or 100, subgroup = subgroup}
    temp = icons.add(temp, 64, SODA.path_icons(icon_spec.folders, icon_spec.name or name, icon_spec.vanilla), icon_spec.mipmaps, icon_spec.tint, icon_spec.icons)

    if pictures then
        if icon_spec.icons then
            error("Item with layers is expected to not have variations: " .. name)
        else
            temp.pictures = {}
            for i = 1, pictures, 1 do
                temp.pictures[i] = {
                    filename = SODA.path_icons(icon_spec.folders, icon_spec.name or name .. (i == 1 and "" or "-" .. i - 1), icon_spec.vanilla),
                    mipmap_count = icon_spec.mipmaps,
                    scale = 0.25,
                    size = 64,
                    tint = icon_spec.tint,
                }
            end
        end
    end
    return temp
end
