local subgroup = "power-intermediates"
SODA.item.add_subgroup(subgroup, "intermediate-products", "p")
-- EARLY

-- purple
SODA.item.add("UV-emitter", "1a", subgroup, 100, {folders = "intermediates"})
SODA.item.add("activated-UV-emitter", "1b", subgroup, 10, {folders = "intermediates"})
SODA.recipe.add("activated-UV-emitter", "smelting", "UV-emitter", 1, "activated-UV-emitter", 1, 8)
SODA.item.add_fuel_category("UV-emitter")
SODA.item.make_fuel("activated-UV-emitter", 1600, "UV-emitter", "UV-emitter")

SODA.item.add("primitive-battery", "1c", subgroup, 200, {folders = "intermediates"})
SODA.item.add("discharged-primitive-battery", "1d", subgroup, 200, {folders = "intermediates"})
SODA.item.add_fuel_category("battery")
SODA.item.make_fuel("primitive-battery", 8000, "battery", "discharged-primitive-battery")
SODA.recipe
    .add("primitive-battery", "chemistry", {{"purple-ingot", 1}, {"yellow-ore", 1}}, nil, "primitive-battery", 2, 8, nil, nil, SODA.color.lerp(SODA.MATS.yellow.tint, SODA.MATS.purple.tint, 0.5)) -- 1 per 10
SODA.recipe.add(
    "primitive-battery-reprocessing", "crushing", "discharged-primitive-battery", 1, "purple-ore", 2, 0.5, subgroup, "1d", nil, true,
    SODA.icon.icons_1_to_1_vertical("discharged-primitive-battery", "purple-ore") -- 1 per 80
)

SODA.item.add("nuclear-UV-emitter", "1e", subgroup, 10, {folders = "intermediates"})
SODA.item.add("spent-nuclear-UV-emitter", "1f", subgroup, 10, {folders = "intermediates"})
SODA.item.make_fuel("nuclear-UV-emitter", 27000, "UV-emitter", "spent-nuclear-UV-emitter")
SODA.recipe.add("nuclear-UV-emitter", "chemistry", "green-ore", 4, "nuclear-UV-emitter", 1, 30, nil, nil, SODA.color.lerp(SODA.MATS.green.tint, SODA.MATS.purple.tint, 0.5)) -- 1 per 3
SODA.recipe.add(
    "nuclear-UV-emitter-reprocessing", "chemistry", "spent-nuclear-UV-emitter", 1, {{"green-ore", 1}, {type = "item", name = "green-ore", amount = 1, probability = 0.25}}, nil, 10, subgroup, "1f",
    SODA.MATS.green.tint, true, SODA.icon.icons_1_to_1_vertical("spent-nuclear-UV-emitter", "green-ore")
) -- 1 per 9

-- orange
SODA.item.add_fuel_category("heat-cell")
SODA.item.add("heat-cell", "1g", subgroup, 10, {folders = "intermediates"})
SODA.item.make_fuel("heat-cell", 20000, "heat-cell")
SODA.recipe.add(
    "heat-cell-from-yellow", "chemistry", {{"yellow-ore", 2}, {type = "fluid", name = "water", amount = 750}}, nil, "heat-cell", 1, 20, subgroup, "1g1", SODA.MATS.yellow.tint, false,
    SODA.icon.icons_1_to_1("yellow-ore", "heat-cell")
)
SODA.item.add("crushed-green-ore", "1c", "side-products", 100, {folders = "processing", name = "crushed-ore", tint = SODA.MATS.green.tint})
SODA.recipe.add("crushed-green-ore", "crushing", "green-ore", 1, "crushed-green-ore", 2, 0.8)
SODA.recipe.add("heat-cell-from-green", "chemistry", "crushed-green-ore", 4, "heat-cell", 1, 25, subgroup, "1g2", SODA.MATS.green.tint, false, SODA.icon.icons_1_to_1("crushed-green-ore", "heat-cell"))

-- red
SODA.fluid.add("hot-air", "1h", subgroup, SODA.MATS.white.tint, {folders = "fluids"}, false)
data.raw.fluid["hot-air"].max_temperature = 315
data.raw.fluid["hot-air"].gas_temperature = 0
data.raw.fluid["hot-air"].heat_capacity = 0.04 .. "kJ"
SODA.recipe.add("hot-air", nil, {}, nil, {{type = "fluid", name = "hot-air", amount = 2, temperature = 315}}, nil, 0.1)

SODA.item.add("crushed-yellow-ore", "1b", "side-products", 100, {folders = "processing", name = "crushed-ore", tint = SODA.MATS.yellow.tint})
SODA.recipe.add("crushed-yellow-ore", "crushing", "yellow-ore", 1, "crushed-yellow-ore", 2, 0.8)
SODA.fluid.add("yellow-gas", "1i", subgroup, SODA.MATS.yellow.tint, {folders = "fluid", name = "steam", tint = SODA.MATS.yellow.tint, vanilla = true}, false)
data.raw.fluid["yellow-gas"].max_temperature = 315
data.raw.fluid["yellow-gas"].gas_temperature = 0
data.raw.fluid["yellow-gas"].heat_capacity = 0.25 .. "kJ"
SODA.recipe.add(
    "yellow-gas", "chemistry", {{"crushed-yellow-ore", 1}, {type = "fluid", name = "water", amount = 80}}, nil, {{type = "fluid", name = "yellow-gas", amount = 300, temperature = 107}}, nil, 20, nil,
    nil, SODA.MATS.yellow.tint
)

SODA.recipe.add(
    "steam-from-green-acid", "chemistry", {{type = "fluid", name = "green-acid", amount = 50}, {"stone", 2}}, nil, {{"slag", 1}, {type = "fluid", name = "steam", amount = 160, temperature = 105}},
    nil, 1.6, subgroup, "1j", SODA.MATS.green.tint, true, SODA.icon.icons_2_to_1("green-acid", "stone", "steam")
)

