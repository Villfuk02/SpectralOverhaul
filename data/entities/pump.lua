data.raw.recipe["bop-make-water"].results = {{type = "fluid", name = "water", amount = 120}}
data.raw.recipe["bop-make-water"].energy_required = 0.1
data.raw["assembling-machine"]["electric-offshore-pump"].crafting_speed = 1
data.raw["assembling-machine"]["electric-offshore-pump"].module_specification = {module_slots = 0}
data.raw["assembling-machine"]["electric-offshore-pump"].fluid_boxes.fluid_box.base_area = 12
data.raw["assembling-machine"]["electric-offshore-pump"].fluid_boxes.fluid_box.height = 4
data.raw["assembling-machine"]["electric-offshore-pump"].working_sound = {
    audible_distance_modifier = 0.7,
    fade_in_ticks = 4,
    fade_out_ticks = 20,
    match_volume_to_activity = true,
    max_sounds_per_type = 3,
    sound = {{filename = "__base__/sound/offshore-pump.ogg", volume = 0.5}},
}
data.raw["assembling-machine"]["electric-offshore-pump"].energy_source.drain = "0W"

-- MAKE WATER BURNABLE
data.raw.fluid.water.fuel_value = "2kJ"

-- RECIPES
SODA.recipe.add_from_prefabs({"structure"}, {"milling", "cold-rolling", "hot-rolling"}, {{SODA.RIP.plate_4s, 1}}, "pipe", 2, 0.5)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{SODA.RIP.plate_4s, 2}, {"pipe", 10}}, "pipe-to-ground", 2, 1)
SODA.recipe.add_from_prefabs({"mechanisms"}, "assembling", {{"simple-motor", 4}, {SODA.RIP.mechanism_0_4m_1s, 2}, {"pipe", 4}}, "electric-offshore-pump", 1, 1)

