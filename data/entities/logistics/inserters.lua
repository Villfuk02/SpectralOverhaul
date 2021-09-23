local chases_belt_items = settings.startup["inserter-config-chase-belt-items"].value

for _, inserter in pairs(data.raw.inserter) do
    inserter.allow_custom_vectors = true
    inserter.chases_belt_items = chases_belt_items
end

-- START

local platform = table.deepcopy(data.raw["container"]["iron-chest"])
platform.name = "transport-platform"
platform.localised_name = SODA.lang.cut_up("transport-platform")
platform.max_health = 100
platform.inventory_size = 2
platform.picture = {filename = SODA.path.icons("logistics/transport-platform"), size = 64, scale = 0.5}
platform.minable = {mining_time = 0.1, result = "transport-platform"}
platform.placeable_by = {item = "transport-platform", count = 1}
data:extend{platform}
SODA.item.add("transport-platform", "0", "inserter", 100, {folders = "logistics"}, nil, nil, {place_result = "transport-platform"})
SODA.recipe.add_from_prefabs({"structure"}, {"cutting", "pressing", "casting"}, {{SODA.RIP.plate_4s, 1}}, "transport-platform", 4, 1) -- 1s (1)

data.raw.inserter["inserter"].energy_per_movement = "0.25kJ"
data.raw.inserter["inserter"].energy_per_rotation = "0.25kJ"
data.raw.inserter["inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}
SODA.recipe.add_from_prefabs({"structure", {"white"}}, "assembling", {{"simple-motor", 1}, {SODA.RIP.rod_2s, 1}, {SODA.RIP.mechanism_transmission_2m, 2}}, "inserter", 2, 0.5) -- 1.25s 3m 1e (5.25)

data.raw.inserter["thrower-inserter"].energy_per_movement = "2kJ"
data.raw.inserter["thrower-inserter"].energy_per_rotation = "2kJ"
data.raw.inserter["thrower-inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}
data.raw.inserter["thrower-inserter"].stack_size_bonus = 6
SODA.recipe.add_from_prefabs({"structure", {"white"}}, "assembling", {{"inserter", 1}, {"simple-motor", 2}, {SODA.RIP.mechanism_0_4m_1s, 2}, {SODA.RIP.rod_2s, 1}}, "thrower-inserter", 1, 1) -- 5.25s 19m 5e (29.25)

-- EARLY
data.raw.inserter["fast-inserter"].energy_per_movement = "0.35kJ"
data.raw.inserter["fast-inserter"].energy_per_rotation = "0.35kJ"
data.raw.inserter["fast-inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}
SODA.recipe.add_from_prefabs(nil, "assembling", {{"inserter", 1}, {"simple-motor", 1}, {"white-piston", 1}}, "fast-inserter", 1, 0.5) -- 2.75s 7m 3e (12.75)

data.raw.inserter["filter-inserter"].energy_per_movement = "0.4kJ"
data.raw.inserter["filter-inserter"].energy_per_rotation = "0.4kJ"
data.raw.inserter["filter-inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}
SODA.recipe.add_from_prefabs({"electronics"}, "assembling", {{"fast-inserter", 1}, {SODA.RIP.electronics_1_2e_1m_1s, 1}, {SODA.RIP.cable_1e, 2}}, "filter-inserter", 1, 0.5) -- 3.75s 8m 7e (18.75)

