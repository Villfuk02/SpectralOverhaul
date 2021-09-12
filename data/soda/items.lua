SODA.item = {}

function SODA.item.add(name, order, subgroup, stack_size, icon_spec, pictures)
    if icon_spec == nil then
        icon_spec = {}
    end
    local item = {type = "item", name = name, order = order .. "[" .. name .. "]", stack_size = stack_size or 100, subgroup = subgroup, localised_name = SODA.lang.cut_up(name)}

    if pictures then
        if icon_spec.icons then
            error("Item with layers is expected to not have variations: " .. name)
        else
            item.pictures = {}
            for i = 1, pictures, 1 do
                item.pictures[i] = {
                    filename = SODA.path.icons((icon_spec.folders and icon_spec.folders .. "/" or "") .. (icon_spec.name or name) .. (i == 1 and "" or "-" .. i - 1), icon_spec.vanilla),
                    mipmap_count = icon_spec.mipmaps,
                    scale = 0.25,
                    size = 64,
                    tint = icon_spec.tint,
                }
            end
        end
    end
    data:extend{item}
    SODA.icon.make(
        "item", name, 64, SODA.path.icons((icon_spec.folders and icon_spec.folders .. "/" or "") .. (icon_spec.name or name), icon_spec.vanilla), icon_spec.mipmaps, icon_spec.tint, icon_spec.icons
    )
end
