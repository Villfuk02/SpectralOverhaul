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
