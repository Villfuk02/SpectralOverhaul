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
SODA.item.add("discharged-primitive-battery", "1d", subgroup, 10, {folders = "intermediates"})
SODA.item.add_fuel_category("battery")
SODA.item.make_fuel("primitive-battery", 8000, "battery", "discharged-primitive-battery")
SODA.recipe.add("primitive-battery", "chemistry", {{"purple-ingot", 1}, {"yellow-ore", 1}}, nil, "primitive-battery", 2, 8, nil, nil, SODA.MATS.yellow.tint) -- 1 per 10
SODA.recipe.add(
    "primitive-battery-reprocessing", "crushing", "discharged-primitive-battery", 1, "purple-ore", 2, 0.5, subgroup, "1d", nil, true,
    SODA.icon.icons_1_to_1_vertical("discharged-primitive-battery", "purple-ore") -- 1 per 80
)

SODA.item.add("simple-nuclear-fuel", "1e", subgroup, 10, {name = "uranium-fuel-cell", vanilla = true})
SODA.item.add("spent-simple-nuclear-fuel", "1f", subgroup, 10, {name = "used-up-uranium-fuel-cell", vanilla = true})
SODA.item.make_fuel("simple-nuclear-fuel", 27000, "simple-nuclear", "spent-simple-nuclear-fuel")
SODA.item.add_fuel_category("simple-nuclear")
SODA.recipe.add("simple-nuclear-fuel", "chemistry", "green-ore", 4, "simple-nuclear-fuel", 1, 30, nil, nil, SODA.MATS.green.tint) -- 1 per 3
SODA.recipe.add(
    "simple-nuclear-fuel-reprocessing", "chemistry", "spent-simple-nuclear-fuel", 1, {{"green-ore", 1}, {type = "item", name = "green-ore", amount = 1, probability = 0.25}}, nil, 10, subgroup, "1f",
    SODA.MATS.green.tint, true, SODA.icon.icons_1_to_1_vertical("spent-simple-nuclear-fuel", "green-ore")
) -- 1 per 9
