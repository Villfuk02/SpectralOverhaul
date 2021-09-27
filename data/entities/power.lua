local subgroup = "energy"

-- START (75% efficiency)
SODA.entity.add_burner_generator("stirling-engine", "1", subgroup, 3.75, 400, "generator", "steam-engine", "chemical", 300, 10, 0.75, false)
SODA.recipe.add_from_prefabs(
    {"structure", "mechanisms", "electronics"}, "assembling",
    {{"stone-furnace", 1}, {SODA.RIP.electronics_0_2e, 1}, {SODA.RIP.cable_1e, 4}, {SODA.RIP.mechanism_0_4m_1s, 2}, {SODA.RIP.plate_4s, 2}, {SODA.RIP.rod_2s, 2}}, "stirling-engine", 1, 0.5
) -- 14s 8m 6e
SODA.recipe.add_from_prefabs({"electronics"}, "assembling", {{"wood", 1}, {SODA.RIP.cable_1e, 1}}, "small-electric-pole", 2, 0.5)

-- EARLY (100% efficiency)
SODA.recipe.add_from_prefabs({"structure", "electronics"}, "assembling", {{SODA.RIP.beam_8s, 1}, {SODA.RIP.cable_1e, 2}}, "medium-electric-pole", 1, 0.5)

-- purple
SODA.entity.add_burner_generator("UV-generator", "2a", subgroup, 1.95, 200, nil, nil, "UV-emitter", 300, 0, true)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"purple-panel", 2}, {"purple-cable", 2}, {SODA.RIP.plate_4s, 1}}, "UV-generator", 1, 0.5)
SODA.entity.add_burner_generator("battery-discharger", "2b", subgroup, 1.6, 150, nil, nil, "battery", 200, 1.25, true)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"purple-sensor", 1}, {"purple-cable", 2}, {SODA.RIP.rod_2s, 1}}, "battery-discharger", 1, 0.5)

-- orange
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{SODA.RIP.rod_2s, 1}, {"orange-plate", 2}}, "heat-pipe", 4, 0.5) -- 0.5s 2e

local per_orange_line = 440
SODA.entity.add_reactor("heat-reactor", "2c", subgroup, 2.9, 300, "boiler", "boiler", {"heat-cell", "chemical"}, 320, 0.8, 3, 0.125, true, 315, 2000, false)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"heat-pipe", 4}, {SODA.RIP.plate_4s, 2}, {"stone-brick", 4}}, "heat-reactor", 1, 1)

SODA.fluid.add("heat-joule", "z", "fluid", SODA.MATS.orange.tint, {folders = "fluids"}, false, {fuel_value = "1J", default_temperature = 1, gas_temperature = 0, hidden = true})

SODA.recipe.add("heat-joule", nil, {}, nil, {{type = "fluid", name = "heat-joule", amount = per_orange_line * 50}}, nil, 0.1, nil, nil, nil, nil, nil, {hidden = true, hide_from_stats = true})
SODA.entity.add_assembling_machine(
    "heat-adapter", "2d", subgroup, 0.8, 100, nil, nil, "heat-joule", 1, per_orange_line / 2,
    {max_temperature = 315, min_temperature = 115, specific_heat = 1250, connections = SODA.entity.generate_heat_connections(1)}, 0, false, 0, {
        show_recipe_icon = false,
        fluid_boxes = {
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = per_orange_line * 10,
                base_level = 1,
                pipe_connections = {{type = "output", position = {0, 1}}, {type = "output", position = {0, -1}}, {type = "output", position = {1, 0}}, {type = "output", position = {-1, 0}}},
            },
        },
    }
)
SODA.recipe.add_from_prefabs({}, "assembling", {{"pipe", 1}, {"heat-pipe", 1}}, "heat-adapter", 1, 0.5)
SODA.entity.add_fluid_generator(
    "thermoelectric-generator", "2e", subgroup, 1.9, 150, "accumulator", "accumulator", per_orange_line, 0, 1, "heat-joule", per_orange_line * 1000, 1000, per_orange_line * 2000,
    {{position = {0.5, 1.5}, type = "input"}, {position = {-0.5, 1.5}, type = "input"}, {position = {0.5, -1.5}, type = "input"}, {position = {-0.5, -1.5}, type = "input"}}, true
)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"orange-foil", 8}, {"orange-electronic-components", 2}, {SODA.RIP.plate_4s, 1}}, "thermoelectric-generator", 1, 1)

-- red
SODA.entity.add_assembling_machine(
    "combustion-chamber", "2f", subgroup, 1.8, 200, "furnace", "steel-furnace", "hot-air", 1, 240, "chemical", 4, false, 0, {
        show_recipe_icon = false,
        fluid_boxes = {
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 1,
                base_level = 1,
                pipe_connections = {{type = "output", position = {0.5, 1.5}}, {type = "output", position = {1.5, 0.5}}},
            },
        },
    }
)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"stone-furnace", 1}, {"ceramic-sheet", 1}, {"pipe", 2}}, "combustion-chamber", 1, 0.5)
data.raw.generator["steam-engine"].fluid_box.filter = nil
data.raw.generator["steam-engine"].max_power_output = SODA.entity.power(900, true)
data.raw.generator["steam-engine"].maximum_temperature = 315
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"red-magnet", 2}, {"red-coil", 2}, {SODA.RIP.plate_4s, 1}, {"pipe", 2}}, "steam-engine", 1, 1)

