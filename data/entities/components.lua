data.raw.character.character.crafting_categories = {"cutting", "milling", "cold-rolling", "pressing", "casting", "hot-rolling", "dry-mixing", "assembling"}

local subgroup = "machining-machine"
SODA.item.add_subgroup(subgroup, "production", "m")
-- START (speed 0.1, 600kW/1, 10p/1)
SODA.entity.add_assembling_machine(
    "fabricator", "0", subgroup, 3.8, 250, "assembling-machine", "assembling-machine-2", {"cutting", "milling", "cold-rolling", "pressing", "casting", "hot-rolling", "dry-mixing"}, 0.1, 60, true, 1,
    true, 0
)

-- EARLY (speed 0.5, 150kW/1, 5p/1)
-- azure
SODA.recipe.add_category("cutting")
SODA.recipe.add_category("cutting-1")
SODA.entity.add_assembling_machine("cutter", "1a", subgroup, {3.6, 1.9}, 300, "furnace", "electric-furnace", {"cutting", "cutting-1"}, 0.5, 90, true, 3, true, 0)

SODA.recipe.add_category("milling")
SODA.recipe.add_category("milling-1")
SODA.entity.add_assembling_machine("lathe-mill", "1b", subgroup, 2.75, 300, "assembling-machine", "assembling-machine-1", {"milling", "milling-1"}, 0.5, 60, true, 2, true, 0)

-- silver
SODA.recipe.add_category("cold-rolling")
SODA.recipe.add_category("cold-rolling-1")
SODA.entity.add_assembling_machine("cold-roller", "1c", subgroup, 2.9, 300, "assembling-machine", "assembling-machine-1", {"cold-rolling", "cold-rolling-1"}, 0.25, 30, true, 2, true, 0)

SODA.recipe.add_category("pressing")
SODA.recipe.add_category("pressing-1")
SODA.entity.add_assembling_machine("metal-press", "1d", subgroup, 1.9, 200, "assembling-machine", "assembling-machine-1", {"pressing", "pressing-1"}, 0.5, 90, true, 1, true, 0)

-- pink
SODA.recipe.add_category("casting")
SODA.recipe.add_category("casting-1")
SODA.entity.add_assembling_machine("casting-machine", "1e", subgroup, 3.7, 400, "furnace", "electric-furnace", {"casting", "casting-1"}, 1, 210, true, 6, true, 0)

SODA.recipe.add_category("hot-rolling")
SODA.recipe.add_category("hot-rolling-1")
SODA.entity.add_assembling_machine("hot-roller", "1f", subgroup, {2.8, 1.8}, 250, "assembling-machine", "assembling-machine-1", {"hot-rolling", "hot-rolling-1"}, 0.5, 45, true, 2, true, 0)

-- assembler (2p/1)
SODA.recipe.add_category("assembling")
SODA.recipe.add_category("assembling-1")
data.raw["assembling-machine"]["assembling-machine-1"].energy_source.emissions_per_minute = 1
data.raw["assembling-machine"]["assembling-machine-1"].energy_usage = SODA.entity.power(75, false)
data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories = {"assembling", "assembling-1"}
