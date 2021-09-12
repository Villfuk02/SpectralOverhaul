-- START
data.raw.furnace["stone-furnace"].energy_usage = SODA.entity.energy(200, true)
data.raw.furnace["stone-furnace"].crafting_speed = SODA.constants.processing.machine_speeds[1]
data.raw.furnace["stone-furnace"].energy_source.emissions_per_minute = SODA.constants.processing.pollution_per_processing_line_per_minute[1]
data.raw.furnace["stone-furnace"].result_inventory_size = 2
-- EARLY

-- CRUSHER
SODA.recipe.add_category("crushing")
SODA.entity.add_furnace("crusher", "c1", "production-machine", 3.6, 400, {"crushing"}, 1, 600, "electric", 12, true, 0, "mining-drill", "electric-mining-drill", 2)

-- BLAST FURNACE
SODA.recipe.add_category("blast-smelting")
SODA.entity.add_assembling_machine("blast-furnace", "d1", "production-machine", 2.9, 350, {"blast-smelting"}, 1, 500, "chemical", 8, false, 0, "furnace", "steel-furnace")

-- CHEM PLANT

data.raw["assembling-machine"]["chemical-plant"].energy_usage = SODA.entity.energy(125)
data.raw["assembling-machine"]["chemical-plant"].module_specification.module_slots = 0
data.raw["assembling-machine"]["chemical-plant"].energy_source.emissions_per_minute = 5

-- MID
-- LATE
