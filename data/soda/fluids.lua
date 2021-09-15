SODA.fluid = {}

function SODA.fluid.add(name, order, subgroup, color, icon_spec, auto_barrel, extras)
    if icon_spec == nil then
        icon_spec = {}
    end
    local fluid = {
        type = "fluid",
        name = name,
        order = order .. "[" .. name .. "]",
        subgroup = subgroup,
        base_color = color,
        flow_color = color,
        auto_barrel = auto_barrel,
        default_temperature = 15,
        localised_name = SODA.lang.cut_up(name),
    }
    if extras then
        for key, value in pairs(extras) do
            fluid[key] = value
        end
    end
    data:extend{fluid}
    SODA.icon.make(
        "fluid", name, 64, SODA.path.icons((icon_spec.folders and icon_spec.folders .. "/" or "") .. (icon_spec.name or name), icon_spec.vanilla), icon_spec.mipmaps, icon_spec.tint, icon_spec.icons
    )
end
