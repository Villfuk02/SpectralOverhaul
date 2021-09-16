-- START
data.raw.furnace["stone-furnace"].energy_usage = SODA.entity.power(200, true)
data.raw.furnace["stone-furnace"].crafting_speed = 1
data.raw.furnace["stone-furnace"].energy_source.emissions_per_minute = 2.5
data.raw.furnace["stone-furnace"].result_inventory_size = 2
-- EARLY

-- CRUSHER
SODA.recipe.add_category("crushing")
SODA.entity.add_furnace("crusher", "c1", "production-machine", 3.6, 400, "mining-drill", "electric-mining-drill", {"crushing"}, 1, 600, true, 12, true, 0, 2)

-- BLAST FURNACE
SODA.recipe.add_category("blast-smelting")
SODA.entity.add_assembling_machine("blast-furnace", "d1", "production-machine", 2.9, 350, "furnace", "steel-furnace", {"blast-smelting"}, 1, 500, "chemical", 8, false, 0)

-- CHEM PLANT

SODA.recipe.add_category("dry-mixing")

data.raw["assembling-machine"]["chemical-plant"].energy_usage = SODA.entity.power(125)
data.raw["assembling-machine"]["chemical-plant"].module_specification.module_slots = 0
data.raw["assembling-machine"]["chemical-plant"].energy_source.emissions_per_minute = 5
data.raw["assembling-machine"]["chemical-plant"].crafting_categories = {"chemistry", "dry-mixing"}

-- MID
-- LATE
