SODA.entity = {}

function SODA.entity.power(power_in_kW, no_drain)
    return (no_drain and power_in_kW or power_in_kW * 30 / 31) .. "kW"
end

local function add_machine(_type, name, order, subgroup, size, health, sound_type, sound_machine, rotatable, animates, to_add, extras)
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
        animation = animates and animation or nil,
        idle_animation = animates and table.deepcopy(animation) or nil,
        horizontal_animation = _type == "generator" and animation or nil,
        vertical_animation = _type == "generator" and animation or nil,
        picture = (not animates) and animation or nil,
        working_light_picture = _type == "reactor" and table.deepcopy(animation) or nil,
        working_sound = sound_type and table.deepcopy(data.raw[sound_type][sound_machine].working_sound) or nil,
        flags = {"placeable-player", "player-creation"},
    }
    if animates then
        entity.idle_animation.tint = {0.7, 0.7, 0.7, 1}
    elseif _type == "reactor" then
        entity.picture.tint = {0.7, 0.7, 0.7, 1}
    end
    if not rotatable then
        table.insert(entity.flags, "not-rotatable")
    end

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

-- VOID: "void"
-- ELECTRIC: is_input
-- FLUID: TODO
-- HEAT: {max_temperature, min_temperature, specific_heat, connections}
-- BURNER: fuel_type or {fuel_types}
local function generate_energy_source(energy_type, power, pollution, has_drain, effectivity)
    local void = energy_type == "void"
    local electric = type(energy_type) == "boolean"
    local table = type(energy_type) == "table"
    local fluid = table and energy_type.fluid_box
    local heat = table and energy_type.max_temperature
    local burner = not (fluid or void or electric or heat)
    local es = {
        type = fluid and "fluid" or (heat and "heat" or (burner and "burner" or (electric and "electric" or "void"))),
        emissions_per_minute = pollution,
        fuel_category = (burner and not table) and energy_type or nil,
        fuel_categories = (burner and table) and energy_type or nil,
        fuel_inventory_size = burner and 1 or nil,
        drain = electric and (has_drain and power / 31 .. "kW" or "0W") or nil,
        usage_priority = electric and "secondary-" .. (energy_type and "input" or "output") or nil,
        effectivity = (burner or fluid) and effectivity or nil,
        burnt_inventory_size = burner and 1 or nil,
        max_temperature = heat and energy_type.max_temperature or nil,
        min_working_temperature = heat and energy_type.min_temperature or nil,
        specific_heat = heat and (energy_type.specific_heat .. "kJ") or nil,
        max_transfer = heat and (4 * power / (effectivity or 1) .. "kW") or nil,
        connections = heat and energy_type.connections or nil,
    }
    return es
end

local function add_crafting_machine(furnace, name, order, subgroup, size, health, sound_type, sound_machine, crafting_categories, speed, power, energy_type, pollution, has_drain, module_slots, extras)
    local type_name = furnace and "furnace" or "assembling-machine"

    local to_add = {
        crafting_categories = type(crafting_categories) == "table" and crafting_categories or {data.raw.recipe[crafting_categories].category},
        fixed_recipe = type(crafting_categories) == "string" and crafting_categories or nil,
        crafting_speed = speed,
        energy_usage = SODA.entity.power(power, not has_drain),
        energy_source = generate_energy_source(energy_type, power, pollution, has_drain, 1),
        module_specification = {module_slots = module_slots},
        match_animation_speed_to_activity = not furnace,
    }

    add_machine(type_name, name, order, subgroup, size, health, sound_type, sound_machine, true, true, to_add, extras)
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

function SODA.entity.add_fluid_generator(name, order, subgroup, size, health, sound_type, sound_machine, power, pollution, effectivity, fluid, fluid_per_sec, depth, capacity, pipes, rotatable, extras)
    local to_add = {
        effectivity = effectivity,
        energy_source = {type = "electric", usage_priority = "secondary-output", emissions_per_minute = pollution},
        fluid_box = {
            filter = fluid,
            production_type = "input-output",
            pipe_covers = pipecoverspictures(),
            pipe_picture = assembler2pipepictures(),
            height = depth,
            base_level = -depth,
            base_area = capacity / 100 / depth,
            pipe_connections = pipes,
        },
        fluid_usage_per_tick = fluid_per_sec / 60,
        max_power_output = SODA.entity.power(power, true),
        burns_fluid = true,
        maximum_temperature = 1000,
    }
    add_machine("generator", name, order, subgroup, size, health, sound_type, sound_machine, rotatable, false, to_add, extras)
end

function SODA.entity.add_burner_generator(name, order, subgroup, size, health, sound_type, sound_machine, fuel_type, power, pollution, effectivity, rotatable, extras)

    local to_add = {
        energy_source = {type = "electric", usage_priority = "secondary-output"},
        burner = generate_energy_source(fuel_type, power, pollution, false, effectivity),
        max_power_output = SODA.entity.power(power, true),
    }

    add_machine("burner-generator", name, order, subgroup, size, health, sound_type, sound_machine, rotatable, true, to_add, extras)
end

function SODA.entity.generate_heat_connections(size)
    local c = {}
    local edge = (size - 1) / 2
    for i = edge, 1, -2 do
        table.insert(c, {position = {i, -edge}, direction = defines.direction.north})
        table.insert(c, {position = {-i, -edge}, direction = defines.direction.north})
        table.insert(c, {position = {i, edge}, direction = defines.direction.south})
        table.insert(c, {position = {-i, edge}, direction = defines.direction.south})
        table.insert(c, {position = {edge, i}, direction = defines.direction.east})
        table.insert(c, {position = {edge, -i}, direction = defines.direction.east})
        table.insert(c, {position = {-edge, i}, direction = defines.direction.west})
        table.insert(c, {position = {-edge, -i}, direction = defines.direction.west})
    end
    if size % 4 == 1 then
        table.insert(c, {position = {0, -edge}, direction = defines.direction.north})
        table.insert(c, {position = {0, edge}, direction = defines.direction.south})
        table.insert(c, {position = {edge, 0}, direction = defines.direction.east})
        table.insert(c, {position = {-edge, 0}, direction = defines.direction.west})
    end
    return c
end

function SODA.entity.add_reactor(
    name, order, subgroup, size, health, sound_type, sound_machine, energy_type, power, efficiency, pollution, neighbour_bonus, scale_energy_usage, max_temp, specific_heat, rotatable, extras
)
    local to_add = {
        consumption = SODA.entity.power(power, true),
        energy_source = generate_energy_source(energy_type, power, pollution, false, efficiency),
        heat_buffer = {
            max_temperature = max_temp,
            specific_heat = specific_heat .. "kJ",
            max_transfer = 2 * power / (efficiency or 1) .. "kW",
            connections = SODA.entity.generate_heat_connections(math.ceil(size)),
            minimum_glow_temperature = max_temp * 0.35,
        },
        neighbour_bonus = neighbour_bonus,
        scale_energy_usage = scale_energy_usage,
        neighbour_collision_increase = 0,
    }
    add_machine("reactor", name, order, subgroup, size, health, sound_type, sound_machine, rotatable, false, to_add, extras)
end
