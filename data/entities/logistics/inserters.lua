local chases_belt_items = settings.startup["inserter-config-chase-belt-items"].value

for _, inserter in pairs(data.raw.inserter) do
    inserter.allow_custom_vectors = true
    inserter.chases_belt_items = chases_belt_items
end

local platform = table.deepcopy(data.raw["container"]["iron-chest"])
platform.name = "transport-platform"
platform.localised_name = SODA.lang.cut_up("transport-platform")
platform.max_health = 100
platform.inventory_size = 2
platform.picture = {filename = SODA.path.icons("logistics/transport-platform"), size = 64, scale = 0.5}
platform.minable = {mining_time = 0.1, result = "transport-platform"}
platform.placeable_by = {item = "transport-platform", count = 1}
data:extend{platform}
SODA.item.add("transport-platform", "z", "inserter", 100, {folders = "logistics"}, nil, nil, {place_result = "transport-platform"})

data.raw.inserter["inserter"].energy_per_movement = "0.25kJ"
data.raw.inserter["inserter"].energy_per_rotation = "0.25kJ"
data.raw.inserter["inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}

data.raw.inserter["fast-inserter"].energy_per_movement = "0.35kJ"
data.raw.inserter["fast-inserter"].energy_per_rotation = "0.35kJ"
data.raw.inserter["fast-inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}

data.raw.inserter["filter-inserter"].energy_per_movement = "0.4kJ"
data.raw.inserter["filter-inserter"].energy_per_rotation = "0.4kJ"
data.raw.inserter["filter-inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}

data.raw.inserter["thrower-inserter"].energy_per_movement = "2kJ"
data.raw.inserter["thrower-inserter"].energy_per_rotation = "2kJ"
data.raw.inserter["thrower-inserter"].energy_source = {type = "electric", usage_priority = "secondary-input"}
data.raw.inserter["thrower-inserter"].stack_size_bonus = 6

