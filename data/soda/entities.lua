SODA.entity = {}

function SODA.entity.energy(energy_in_kW, no_drain)
    return (no_drain and energy_in_kW or energy_in_kW * 30 / 31) .. "kW"
end

local function add_crafting_machine(
    furnace, name, order, subgroup, size, health, crafting_categories, speed, energy, energy_type, pollution, has_drain, module_slots, sound_type, sound_machine, extras
) -- TODO: implement fluid power
    local type_name = furnace and "furnace" or "assembling-machine"
    local fluid_powered = type(energy_type) == "table"
    local burner = not (fluid_powered or energy_type == "electric" or energy_type == "heat" or energy_type == "void")
    if type(size) == "number" then
        size = {size, size}
    end
    local bounds = {math.ceil(size[1]) / 2, math.ceil(size[2]) / 2}
    size = {size[1] / 2, size[2] / 2}

    local animation = {filename = SODA.path.entities("machines/" .. name), width = bounds[1] * 64, height = bounds[2] * 64, scale = size[1] / bounds[1]}

    SODA.item.add(name, order, subgroup, 50, {folders = "machines"})
    data.raw.item[name].place_result = name

    local e = {
        type = type_name,
        name = name,
        localised_name = SODA.lang.cut_up(name),
        crafting_categories = crafting_categories,
        crafting_speed = speed,
        energy_usage = SODA.entity.energy(energy, not has_drain),
        energy_source = {
            type = fluid_powered and "fluid" or (burner and "burner" or energy_type),
            fuel_category = burner and energy_type or nil,
            emissions_per_minute = pollution,
            fuel_inventory_size = burner and 1 or nil,
            drain = has_drain and energy / 31 .. "kW" or "0W",
            usage_priority = energy_type == "electric" and "secondary-input" or nil,
        },
        module_specification = {module_slots = module_slots},
        max_health = health,
        minable = {mining_time = bounds[1] * bounds[2] * 0.045 + 0.1, result = name},
        collision_box = {{-size[1], -size[2]}, {size[1], size[2]}},
        selection_box = {{(-size[1] - bounds[1]) / 2, (-size[2] - bounds[2]) / 2}, {(size[1] + bounds[1]) / 2, (size[2] + bounds[2]) / 2}},
        working_sound = table.deepcopy(data.raw[sound_type][sound_machine].working_sound),
        match_animation_speed_to_activity = not furnace,
        resistances = {{percent = furnace and 90 or 70, type = "fire"}},
        animation = animation,
        idle_animation = table.deepcopy(animation),
    }
    e.idle_animation.tint = {0.7, 0.7, 0.7, 1}
    if extras then
        for key, value in pairs(extras) do
            e[key] = value
        end
    end
    data:extend{e}
    SODA.icon.make(type_name, name, 64, SODA.path.icons("machines/" .. name))
end

function SODA.entity.add_assembling_machine(name, order, subgroup, size, health, crafting_categories, speed, energy, energy_type, pollution, has_drain, module_slots, sound_type, sound_machine, extras)
    add_crafting_machine(false, name, order, subgroup, size, health, crafting_categories, speed, energy, energy_type, pollution, has_drain, module_slots, sound_type, sound_machine, extras)
end

function SODA.entity.add_furnace(name, order, subgroup, size, health, crafting_categories, speed, energy, energy_type, pollution, has_drain, module_slots, sound_type, sound_machine, results, extras)
    if not extras then
        extras = {}
    end
    extras.result_inventory_size = results
    extras.source_inventory_size = 1
    add_crafting_machine(true, name, order, subgroup, size, health, crafting_categories, speed, energy, energy_type, pollution, has_drain, module_slots, sound_type, sound_machine, extras)
end

