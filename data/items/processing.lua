local function for_all_processable(func)
    for key, value in pairs(SODA.MATS) do
        if SODA.mat.types[value.type].processing then
            func(key, value)
        end
    end
end

local group_name = "processing"
SODA.item.add_group(group_name, "bz", SODA.path.graphics("technology/advanced-material-processing", true))
data.raw["item-subgroup"]["raw-resource"].group = group_name
data.raw["item-subgroup"]["raw-resource"].order = "a"

-- START (67% yield, 1.5 fuel per ingot)
SODA.item.add_subgroup("ingots", "processing", "b")

for_all_processable(
    function(key, value)
        SODA.item.add(key .. "-ingot", value.order, "ingots", 100, {folders = "processing", name = "ingot", tint = value.tint})
        SODA.recipe
            .add(key .. "-ingot", "smelting", key .. "-ore", 6, key .. "-ingot", 1, 24, nil, nil, nil, nil, SODA.icon.icons_1_to_1(key .. "-ore", key .. "-ingot"), {allow_as_intermediate = false})
    end
)

-- EARLY (0.8 fuel per ingot)
SODA.item.add_subgroup("side-products", group_name, "c")
SODA.item.add_subgroup("ingots-blasting", group_name, "da")
SODA.item.add_subgroup("reduction-mixes", group_name, "db1")
SODA.item.add_subgroup("ingots-reduction", group_name, "db2")
SODA.item.add_subgroup("purified", group_name, "dc1")
SODA.item.add_subgroup("ingots-purified", group_name, "dc2")

-- black

SODA.item.add("activated-black", "1a", "side-products", 200, {folders = "processing"})
SODA.recipe.add("activated-black", "smelting", "black-ore", 1, "activated-black", 4, 3.2)
SODA.item.make_fuel("activated-black", (8000 + 200 * 3.2) / 4)
for_all_processable(
    function(name, values)
        SODA.recipe.add(
            name .. "-ingot-blasting", "blast-smelting", {{"activated-black", 2}, {"stone", 2}, {name .. "-ore", 4}}, nil, {{name .. "-ingot", 1}, {"slag", 1}}, nil, 3.2, "ingots-blasting",
            values.order, nil, nil, SODA.icon.icons_3_to_1("activated-black", name .. "-ore", "stone", name .. "-ingot"), {allow_as_intermediate = false}
        )
    end
)
SODA.item.add("slag", "a", "side-products", 50, {folders = "processing"})
SODA.recipe.add("slag-crushing", "crushing", "slag", 1, "stone", 2, 3.2 / 4, nil, nil, nil, true, SODA.icon.icons_1_to_1_vertical("slag", "stone"), {allow_as_intermediate = false})

-- yellow

for_all_processable(
    function(name, values)
        SODA.item.add(name .. "-reduction-mix", values.order, "reduction-mixes", 200, {folders = "processing", name = "reduction-mix", tint = values.tint})
        SODA.recipe.add(name .. "-reduction-mix", "chemistry", {{"yellow-ore", 1}, {name .. "-ore", 2}}, nil, name .. "-reduction-mix", 3, 3.2 / 2, nil, nil, values.tint)
        SODA.recipe.add(
            name .. "-ingot-reduction", "smelting", name .. "-reduction-mix", 6, {{name .. "-ingot", 1}, {"yellow-oxide", 2}}, nil, 3.2, "ingots-reduction", values.order, nil, nil,
            SODA.icon.icons_1_to_1(name .. "-reduction-mix", name .. "-ingot"), {allow_as_intermediate = false}
        )
    end
)
SODA.item.add("yellow-oxide", "b", "side-products", 100, {folders = "processing"})
SODA.recipe.add(
    "yellow-reduction", "smelting", "yellow-oxide", 4, "yellow-ore", 3, 3.2 / 2, nil, nil, nil, true, SODA.icon.icons_1_to_1_vertical("yellow-oxide", "yellow-ore"), {allow_as_intermediate = false}
)

-- green

SODA.fluid.add("green-acid", "c", "side-products", SODA.MATS.green.tint, {folders = "fluids"})
SODA.recipe.add(
    "green-acid", "chemistry", {{"green-ore", 1}, {type = "fluid", name = "water", amount = 200}}, nil, {{type = "fluid", name = "green-acid", amount = 200}}, nil, 3.2, nil, nil, SODA.MATS.green.tint
)
for_all_processable(
    function(name, values)
        SODA.item.add("purified-" .. name, values.order, "purified", 100, {folders = "processing", name = "purified", tint = values.tint})
        SODA.recipe.add("purified-" .. name, "chemistry", {{name .. "-ore", 1}, {type = "fluid", name = "green-acid", amount = 25}}, nil, "purified-" .. name, 1, 3.2 / 4, nil, nil, values.tint)
        SODA.recipe.add(
            "purified-" .. name .. "-smelting", "smelting", "purified-" .. name, 4, name .. "-ingot", 1, 3.2, "ingots-purified", values.order, nil, nil,
            SODA.icon.icons_1_to_1("purified-" .. name, name .. "-ingot"), {allow_as_intermediate = false}
        )
    end
)

-- MID (0.4 fuel per ingot)

SODA.item.add_subgroup("crushed-ores", group_name, "ea")
SODA.item.add_subgroup("gravel", group_name, "eb")
SODA.recipe.add_category("crushing-2")

for_all_processable(
    function(name, values)
        SODA.item.add("crushed-" .. name .. "-ore", values.order, "crushed-ores", 100, {folders = "processing", name = "crushed-ore", tint = values.tint})
        SODA.recipe.add("crushed-" .. name .. "-ore", "crushing-2", name .. "-ore", 1, "crushed-" .. name .. "-ore", 2, 0.8)
    end
)

for _, m in pairs(SODA.mat.types.structure.list) do
    for _, n in pairs(SODA.mat.types.electronics.list) do
        SODA.recipe.add(
            "gravel-from-" .. m .. "-and-" .. n, "chemistry", {{"crushed-" .. m .. "-ore", 4}, {"crushed-" .. n .. "-ore", 4}}, nil, "stone", 4, 2, "gravel", SODA.MATS[m].order .. SODA.MATS[n].order,
            SODA.color.lerp(SODA.MATS[m].tint, SODA.MATS[n].tint, 0.5), true, SODA.icon.icons_2_to_1("crushed-" .. m .. "-ore", "crushed-" .. n .. "-ore", "stone"), {allow_as_intermediate = false}
        )
    end
end

-- LATE (0.32 fuel per ingot)
