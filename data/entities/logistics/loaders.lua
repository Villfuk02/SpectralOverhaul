local underground_entity = table.deepcopy(data.raw["underground-belt"]["express-underground-belt"])

underground_entity.minable.result = "simple-underground-belt"
underground_entity.name = "simple-underground-belt"
underground_entity.next_upgrade = nil
underground_entity.max_distance = 3
underground_entity.speed = 1.875 / 480

data:extend{underground_entity}

SODA.item.add("simple-underground-belt", "Y", "inserter", 50, {name = "express-underground-belt", vanilla = true})

more_miniloaders.create_miniloader {
    name = "simple",
    color = "778088",
    underground_belt = "simple-underground-belt",
    ingredients = {{"transport-belt", 1}},
    filter_ingredients = {{"slow-miniloader", 1}},
    tech_prereq = {"construction-robotics"},
    next_upgrade = "slow",
}
-- speed, rotation_speed, max_power
local miniloader_balance = {
    ["simple-miniloader-inserter"] = {1.875, 0.013, 5},
    ["slow-miniloader-inserter"] = {7.5, 0.053, 30},
    ["miniloader-inserter"] = {15, 0.125, 100},
    ["fast-miniloader-inserter"] = {30, 0.25, 250},
    ["express-miniloader-inserter"] = {45, 0.5, 450},
}

for key, v in pairs(miniloader_balance) do
    local pow = v[3] / v[1] * 0.6
    data.raw.inserter[key].rotation_speed = v[2]
    data.raw.inserter[key].extension_speed = v[3] / 60 / pow - v[2]
    data.raw.inserter[key].energy_per_movement = pow .. "kJ"
    data.raw.inserter[key].energy_per_rotation = pow .. "kJ"
end

