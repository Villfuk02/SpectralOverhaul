local subgroup = "energy"

-- START (75% efficiency)
SODA.entity.add_burner_generator("stirling-engine", "1", subgroup, 3.75, 400, "generator", "steam-engine", "chemical", 300, 10, false, 0.75)

-- EARLY (100% efficiency)

-- purple
SODA.entity.add_burner_generator("UV-generator", "2a", subgroup, 1.95, 200, nil, nil, "UV-emitter", 300, 0, true)
SODA.entity.add_burner_generator("battery-discharger", "2b", subgroup, 1.6, 150, nil, nil, "battery", 200, 0, true)

-- orange
local per_orange_line = 440
SODA.entity.add_reactor("heat-reactor", "2c", subgroup, 2.9, 300, "boiler", "boiler", {"heat-cell", "chemical"}, 320, 0.8, 5, 0.125, true, 315, 2000, false)
SODA.fluid.add("heat-joule", "z", "fluid", SODA.MATS.orange.tint, {folders = "fluids"}, false)
data.raw.fluid["heat-joule"].fuel_value = "1J"
data.raw.fluid["heat-joule"].default_temperature = 1
data.raw.fluid["heat-joule"].gas_temperature = 0
SODA.recipe.add("heat-joule", nil, {}, nil, {{type = "fluid", name = "heat-joule", amount = per_orange_line * 50}}, nil, 0.1)
data.raw.recipe["heat-joule"].hidden = true
data.raw.recipe["heat-joule"].hide_from_stats = true
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
SODA.entity.add_fluid_generator(
    "thermoelectric-generator", "2e", subgroup, 1.9, 150, "accumulator", "accumulator", per_orange_line, 0, 1, "heat-joule", per_orange_line * 1000, 1000, per_orange_line * 2000,
    {{position = {0.5, 1.5}, type = "input"}, {position = {-0.5, 1.5}, type = "input"}, {position = {0.5, -1.5}, type = "input"}, {position = {-0.5, -1.5}, type = "input"}}, true
)

-- red
SODA.entity.add_assembling_machine(
    "combustion-chamber", "2f", subgroup, 1.8, 200, "furnace", "steel-furnace", "hot-air", 1, 240, "chemical", 5, false, 0, {
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
data.raw.generator["steam-engine"].fluid_box.filter = nil
data.raw.generator["steam-engine"].max_power_output = SODA.entity.power(900, true)
data.raw.generator["steam-engine"].maximum_temperature = 315

