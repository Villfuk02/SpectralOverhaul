-- START
data.raw.furnace["stone-furnace"].energy_usage = SODA.entity.power(200, true)
data.raw.furnace["stone-furnace"].crafting_speed = 1
data.raw.furnace["stone-furnace"].energy_source.emissions_per_minute = 2.5
data.raw.furnace["stone-furnace"].result_inventory_size = 2

SODA.recipe.add("stone-furnace", "assembling", "stone-brick", 4, "stone-furnace", 1, 0.5)
-- EARLY

-- CRUSHER
SODA.recipe.add_category("crushing")
SODA.entity.add_furnace("crusher", "c1", "production-machine", 3.6, 400, "mining-drill", "electric-mining-drill", {"crushing"}, 1, 600, true, 12, true, 0, 2)
SODA.recipe.add_from_prefabs({"structure", "mechanisms"}, "assembling", {{"simple-motor", 4}, {SODA.RIP.plate_4s, 6}, {SODA.RIP.mechanism_0_4m_1s, 4}}, "crusher", 1, 0.5)

-- BLAST FURNACE
SODA.recipe.add_category("blast-smelting")
SODA.entity.add_assembling_machine("blast-furnace", "d1", "production-machine", 2.9, 350, "furnace", "steel-furnace", {"blast-smelting"}, 1, 500, "chemical", 8, false, 0)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{SODA.RIP.plate_4s, 4}, {"ceramic-sheet", 8}, {SODA.RIP.beam_8s, 2}}, "blast-furnace", 1, 1)

-- CHEM PLANT

SODA.recipe.add_category("dry-mixing")

data.raw["assembling-machine"]["chemical-plant"].energy_usage = SODA.entity.power(125)
data.raw["assembling-machine"]["chemical-plant"].module_specification.module_slots = 0
data.raw["assembling-machine"]["chemical-plant"].energy_source.emissions_per_minute = 5
data.raw["assembling-machine"]["chemical-plant"].crafting_categories = {"chemistry", "dry-mixing"}
SODA.recipe.add_from_prefabs(
    {"structure", "electronics"}, "assembling", {{"stone-brick", 6}, {"simple-motor", 1}, {SODA.RIP.plate_4s, 2}, {SODA.RIP.electronics_0_2e, 4}, {"pipe", 4}}, "chemical-plant", 1, 0.5
)

-- MID
-- LATE
