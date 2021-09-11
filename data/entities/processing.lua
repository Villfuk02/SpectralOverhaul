-- START
data.raw.furnace["stone-furnace"].energy_usage = SODA.constants.processing.power_per_processing_line[1] .. "kW"
data.raw.furnace["stone-furnace"].crafting_speed = SODA.constants.processing.machine_speeds[1]
data.raw.furnace["stone-furnace"].energy_source.emissions_per_minute = SODA.constants.processing.pollution_per_processing_line_per_minute[1]
data.raw.furnace["stone-furnace"].result_inventory_size = 2
-- EARLY

-- CRUSHER
data:extend{{type = "recipe-category", name = "crushing"}}
SODA.item.add("crusher", "c1", "production-machine", 50, {folders = "machines"})
data.raw.item.crusher.place_result = "crusher"
local crusher = table.deepcopy(data.raw.furnace["electric-furnace"])
crusher.name = "crusher"
crusher.result_inventory_size = 2
crusher.crafting_categories = {"crushing"}
crusher.crafting_speed = 1
crusher.energy_source.emissions_per_minute = SODA.constants.processing.pollution_per_processing_line_per_minute[2] * 4 / 15
crusher.energy_usage = SODA.constants.processing.power_per_processing_line[2] * 6 / 20 * 30 / 31 .. "kW"
crusher.module_specification.module_slots = 0
crusher.max_health = 400
crusher.collision_box = {{-1.8, -1.8}, {1.8, 1.8}}
crusher.fast_replaceable_group = "crusher"
crusher.minable.result = "crusher"
crusher.selection_box = {{-1.9, -1.9}, {1.9, 1.9}}
data:extend{crusher}
SODA.icon.make("furnace", "crusher", 64, SODA.path.icons("machines/crusher"))

-- BLAST FURNACE
data:extend{{type = "recipe-category", name = "blast-smelting"}}
SODA.item.add("blast-furnace", "d1", "production-machine", 50, {folders = "machines"})
data.raw.item["blast-furnace"].place_result = "blast-furnace"
local blast_furnace = table.deepcopy(data.raw.furnace["electric-furnace"])
blast_furnace.name = "blast-furnace"
blast_furnace.type = "assembling-machine"
blast_furnace.crafting_categories = {"blast-smelting"}
blast_furnace.crafting_speed = 1
blast_furnace.energy_source.emissions_per_minute = SODA.constants.processing.pollution_per_processing_line_per_minute[2] * 4 / 15
blast_furnace.energy_source.drain = "0W"
blast_furnace.energy_usage = SODA.constants.processing.power_per_processing_line[2] * 5 / 20 .. "kW"
blast_furnace.module_specification.module_slots = 0
blast_furnace.max_health = 350
blast_furnace.collision_box = {{-1.45, -1.45}, {1.45, 1.45}}
blast_furnace.minable.result = "blast-furnace"
blast_furnace.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
data:extend{blast_furnace}
SODA.icon.make("assembling-machine", "blast-furnace", 64, SODA.path.icons("machines/blast-furnace"))

-- CHEM PLANT

data.raw["assembling-machine"]["chemical-plant"].energy_usage = SODA.constants.processing.power_per_processing_line[2] * 1.25 / 20 * 30 / 31 .. "kW"
data.raw["assembling-machine"]["chemical-plant"].module_specification.module_slots = 0

-- MID
-- LATE
