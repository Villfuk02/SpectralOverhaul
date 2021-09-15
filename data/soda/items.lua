SODA.item = {}

function SODA.item.add(name, order, subgroup, stack_size, icon_spec, pictures, override_type, extras)
    if icon_spec == nil then
        icon_spec = {}
    end
    local item = {type = override_type or "item", name = name, order = order .. "[" .. name .. "]", stack_size = stack_size or 100, subgroup = subgroup, localised_name = SODA.lang.cut_up(name)}

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
    if extras then
        for key, value in pairs(extras) do
            item[key] = value
        end
    end
    data:extend{item}
    SODA.icon.make(
        override_type or "item", name, 64, SODA.path.icons((icon_spec.folders and icon_spec.folders .. "/" or "") .. (icon_spec.name or name), icon_spec.vanilla), icon_spec.mipmaps, icon_spec.tint,
        icon_spec.icons
    )
end

function SODA.item.add_group(name, order, icon_path)
    local group = {type = "item-group", name = name, order = order}
    data:extend{group}
    SODA.icon.make("item-group", name, 256, icon_path)
end

function SODA.item.add_subgroup(name, group, order)
    data:extend{{type = "item-subgroup", name = name, group = group, order = order}}
end

function SODA.item.make_fuel(name, value, fuel_type, burnt_result)
    data.raw.item[name].fuel_value = value .. "kJ"
    data.raw.item[name].fuel_category = fuel_type or "chemical"
    data.raw.item[name].burnt_result = burnt_result
end

function SODA.item.add_fuel_category(name)
    data:extend{{type = "fuel-category", name = name, localised_name = SODA.lang.cut_up(name)}}
end
