-- START
data.raw.furnace["stone-furnace"].energy_usage = 200 .. "kW"
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
crusher.localised_name = SODA.lang.cut_up("crusher")
crusher.result_inventory_size = 2
crusher.crafting_categories = {"crushing"}
crusher.crafting_speed = 1
crusher.energy_source.emissions_per_minute = 12
crusher.energy_usage = 600 * 30 / 31 .. "kW"
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
blast_furnace.localised_name = SODA.lang.cut_up("blast-furnace")
blast_furnace.type = "assembling-machine"
blast_furnace.crafting_categories = {"blast-smelting"}
blast_furnace.crafting_speed = 1
blast_furnace.energy_source = {type = "burner", emissions_per_minute = 8, drain = "0W", fuel_inventory_size = 1}
blast_furnace.energy_usage = 500 .. "kW"
blast_furnace.module_specification.module_slots = 0
blast_furnace.max_health = 350
blast_furnace.collision_box = {{-1.45, -1.45}, {1.45, 1.45}}
blast_furnace.minable.result = "blast-furnace"
blast_furnace.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
data:extend{blast_furnace}
SODA.icon.make("assembling-machine", "blast-furnace", 64, SODA.path.icons("machines/blast-furnace"))

-- CHEM PLANT

data.raw["assembling-machine"]["chemical-plant"].energy_usage = 125 * 30 / 31 .. "kW"
data.raw["assembling-machine"]["chemical-plant"].module_specification.module_slots = 0
data.raw["assembling-machine"]["chemical-plant"].energy_source.emissions_per_minute = 5

-- MID
-- LATE
