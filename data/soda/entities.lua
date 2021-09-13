SODA.entity = {}

function SODA.entity.power(power_in_kW, no_drain)
    return (no_drain and power_in_kW or power_in_kW * 30 / 31) .. "kW"
end

local function add_machine(_type, name, order, subgroup, size, health, sound_type, sound_machine, to_add, extras)
    if type(size) == "number" then
        size = {size, size}
    end
    local bounds = {math.ceil(size[1]) / 2, math.ceil(size[2]) / 2}
    size = {size[1] / 2, size[2] / 2}

    local animation = {filename = SODA.path.entities("machines/" .. name), width = bounds[1] * 64, height = bounds[2] * 64, scale = size[1] / bounds[1]}

    SODA.item.add(name, order, subgroup, 50, {folders = "machines"})
    data.raw.item[name].place_result = name

    local entity = {
        type = _type,
        name = name,
        localised_name = SODA.lang.cut_up(name),
        max_health = health,
        minable = {mining_time = bounds[1] * bounds[2] * 0.045 + 0.1, result = name},
        collision_box = {{-size[1], -size[2]}, {size[1], size[2]}},
        selection_box = {{(-size[1] - bounds[1]) / 2, (-size[2] - bounds[2]) / 2}, {(size[1] + bounds[1]) / 2, (size[2] + bounds[2]) / 2}},
        resistances = {{percent = 70, type = "fire"}},
        animation = animation,
        idle_animation = table.deepcopy(animation),
        working_sound = sound_type and table.deepcopy(data.raw[sound_type][sound_machine].working_sound) or nil,
    }
    entity.idle_animation.tint = {0.7, 0.7, 0.7, 1}

    for key, value in pairs(to_add) do
        entity[key] = value
    end
    if extras then
        for key, value in pairs(extras) do
            entity[key] = value
        end
    end

    data:extend{entity}
    SODA.icon.make(_type, name, 64, SODA.path.icons("machines/" .. name))

end

local function add_crafting_machine(furnace, name, order, subgroup, size, health, sound_type, sound_machine, crafting_categories, speed, power, energy_type, pollution, has_drain, module_slots, extras) -- TODO: implement fluid power
    local type_name = furnace and "furnace" or "assembling-machine"
    local fluid_powered = type(energy_type) == "table"
    local burner = not (fluid_powered or energy_type == "electric" or energy_type == "heat" or energy_type == "void")

    local to_add = {
        crafting_categories = crafting_categories,
        crafting_speed = speed,
        energy_usage = SODA.entity.power(power, not has_drain),
        energy_source = {
            type = fluid_powered and "fluid" or (burner and "burner" or energy_type),
            fuel_category = burner and energy_type or nil,
            emissions_per_minute = pollution,
            fuel_inventory_size = burner and 1 or nil,
            drain = has_drain and power / 31 .. "kW" or "0W",
            usage_priority = energy_type == "electric" and "secondary-input" or nil,
        },
        module_specification = {module_slots = module_slots},
        match_animation_speed_to_activity = not furnace,
    }

    add_machine(type_name, name, order, subgroup, size, health, sound_type, sound_machine, to_add, extras)
end

function SODA.entity.add_assembling_machine(name, order, subgroup, size, health, sound_type, sound_machine, crafting_categories, speed, power, energy_type, pollution, has_drain, module_slots, extras)
    add_crafting_machine(false, name, order, subgroup, size, health, sound_type, sound_machine, crafting_categories, speed, power, energy_type, pollution, has_drain, module_slots, extras)
end

function SODA.entity.add_furnace(name, order, subgroup, size, health, sound_type, sound_machine, crafting_categories, speed, power, energy_type, pollution, has_drain, module_slots, results, extras)
    if not extras then
        extras = {}
    end
    extras.result_inventory_size = results
    extras.source_inventory_size = 1
    extras.resistances = {{percent = 90, type = "fire"}}
    add_crafting_machine(true, name, order, subgroup, size, health, sound_type, sound_machine, crafting_categories, speed, power, energy_type, pollution, has_drain, module_slots, extras)
end

local function add_generator()

end

function SODA.entity.add_fluid_generator()

end

function SODA.entity.add_burner_generator(name, order, subgroup, size, health, sound_type, sound_machine, fuel_type, power, effectivity, extras)

    local to_add = {
        energy_source = {type = "electric", usage_priority = "secondary-output"},
        burner = {
            type = "burner",
            fuel_category = type(fuel_type) == "string" and fuel_type or nil,
            fuel_categories = type(fuel_type) == "table" and fuel_type or nil,
            effectivity = effectivity,
            fuel_inventory_size = 1,
        },
        max_power_output = SODA.entity.power(power, true),
    }

    add_machine("burner-generator", name, order, subgroup, size, health, sound_type, sound_machine, to_add, extras)
end
