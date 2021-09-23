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

-- START
SODA.recipe.add_from_prefabs(nil, "assembling", {{"lime-plate", 1}, {"lime-joints", 2}}, "slow-transport-belt", 6, 1) -- 0.17s 1m (1.17)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"slow-transport-belt", 4}, {SODA.RIP.plate_4s, 1}}, "slow-underground-belt", 2, 1) -- (2x) 4.67s 4m (8.67)
SODA.recipe.add_from_prefabs({"electronics"}, "assembling", {{"slow-transport-belt", 2}, {SODA.RIP.cable_1e, 4}, {"lime-joints", 4}, {"simple-motor", 1}}, "slow-splitter", 1, 1) -- 2.83s 6m 6e (14.83)

SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"slow-transport-belt", 1}, {"simple-motor", 2}, {SODA.RIP.plate_4s, 1}}, "simple-miniloader", 2, 0.5) -- 2.58s 2.5m 2e (7.08)

-- EARLY
SODA.recipe.add_from_prefabs(nil, "assembling", {{"slow-transport-belt", 3}, {"lime-transmission-belts", 2}}, "transport-belt", 1, 0.5) -- 0.5s 5m (5.5)
SODA.recipe.add_from_prefabs({"structure"}, "assembling", {{"transport-belt", 6}, {SODA.RIP.plate_4s, 4}}, "underground-belt", 2, 1) -- (2x) 19s 30m (49)
SODA.recipe.add_from_prefabs({"electronics"}, "assembling", {{"transport-belt", 2}, {SODA.RIP.electronics_1_2e_1m_1s, 2}, {"lime-spring", 4}, {"simple-motor", 2}}, "splitter", 1, 1) -- 4 24 8 (36)

SODA.recipe.add_from_prefabs(
    {"structure", {"lime"}}, "assembling", {{"slow-transport-belt", 1}, {"simple-motor", 4}, {SODA.RIP.plate_4s, 2}, {SODA.RIP.mechanism_1_6m_1s, 2}}, "slow-miniloader", 1, 0.5
) -- 12.17 21 8 (41.17)
