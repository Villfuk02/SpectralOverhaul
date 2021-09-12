local function for_all_processable(func)
    for key, value in pairs(SODA.MATS) do
        if SODA.mat.types[value.type].processing then
            func(key, value)
        end
    end
end

-- START (67% yield, 1.5 fuel per ingot)
data:extend{{type = "item-subgroup", name = "ingots", group = "intermediate-products", order = "bz"}}

for_all_processable(
    function(key, value)
        SODA.item.add(key .. "-ingot", value.order, "ingots", 100, {folders = "processing", name = "ingot", tint = value.tint})
        SODA.recipe.add_simple(key .. "-ingot", "smelting", key .. "-ore", 6, key .. "-ingot", 1, 24)
    end
)

-- EARLY (0.8 fuel per ingot)

data:extend{{type = "item-subgroup", name = "side-products", group = "intermediate-products", order = "c1"}}
data:extend{{type = "item-subgroup", name = "ingots-blasting", group = "intermediate-products", order = "c2a"}}
data:extend{{type = "item-subgroup", name = "reduction-mixes", group = "intermediate-products", order = "c2b1"}}
data:extend{{type = "item-subgroup", name = "ingots-reduction", group = "intermediate-products", order = "c2b2"}}
data:extend{{type = "item-subgroup", name = "purified", group = "intermediate-products", order = "c2c1"}}
data:extend{{type = "item-subgroup", name = "ingots-purified", group = "intermediate-products", order = "c2c2"}}

-- black

SODA.item.add("activated-black", "a", "side-products", 200, {folders = "processing"})
SODA.recipe.add_simple("activated-black", "smelting", "black-ore", 1, "activated-black", 4, SODA.constants.processing.total_time_per_ingot[2])
for_all_processable(
    function(name, values)
        SODA.recipe.add_simple(
            name .. "-ingot-blasting", "blast-smelting", {{"activated-black", 2}, {"stone", 2}, {name .. "-ore", 4}}, nil, {{name .. "-ingot", 1}, {"slag", 1}}, nil,
            SODA.constants.processing.total_time_per_ingot[2], "ingots-blasting", values.order
        )
        SODA.icon.make("recipe", name .. "-ingot-blasting", 64, SODA.path.icons("processing/ingot"), nil, values.tint)
    end
)
SODA.item.add("slag", "a", "side-products", 50, {folders = "processing"})
SODA.recipe.add_simple("slag-crushing", "crushing", "slag", 1, "stone", 2, SODA.constants.processing.total_time_per_ingot[2] / 4, nil, nil, nil, true)

-- yellow

for_all_processable(
    function(name, values)
        SODA.item.add(name .. "-reduction-mix", values.order, "reduction-mixes", 200, {folders = "processing", name = "reduction-mix", tint = values.tint})
        SODA.recipe.add_simple(
            name .. "-reduction-mix", "chemistry", {{"yellow-ore", 1}, {name .. "-ore", 2}}, nil, name .. "-reduction-mix", 3, SODA.constants.processing.total_time_per_ingot[2] / 2, nil, nil,
            values.tint
        )
        SODA.recipe.add_simple(
            name .. "-ingot-reduction", "smelting", name .. "-reduction-mix", 6, {{name .. "-ingot", 1}, {"yellow-oxide", 2}}, nil, SODA.constants.processing.total_time_per_ingot[2],
            "ingots-reduction", values.order
        )
        SODA.icon.make("recipe", name .. "-ingot-reduction", 64, SODA.path.icons("processing/ingot"), nil, values.tint)
    end
)
SODA.item.add("yellow-oxide", "b", "side-products", 100, {folders = "processing"})
SODA.recipe.add_simple("yellow-reduction", "smelting", "yellow-oxide", 4, "yellow-ore", 3, SODA.constants.processing.total_time_per_ingot[2] / 2, nil, nil, nil, true)

-- green

SODA.fluid.add("green-acid", "2c", "side-products", SODA.MATS.green.tint, {folders = "fluids"})
SODA.recipe.add_simple(
    "green-acid", "chemistry", {{"green-ore", 1}, {type = "fluid", name = "water", amount = 200}}, nil, {{type = "fluid", name = "green-acid", amount = 100}}, nil,
    SODA.constants.processing.total_time_per_ingot[2], nil, nil, SODA.MATS.green.tint
)
for_all_processable(
    function(name, values)
        SODA.item.add("purified-" .. name, values.order, "purified", 100, {folders = "processing", name = "purified", tint = values.tint})
        SODA.recipe.add_simple(
            "purified-" .. name, "chemistry", {{name .. "-ore", 4}, {type = "fluid", name = "green-acid", amount = 50}}, nil, "purified-" .. name, 4, SODA.constants.processing.total_time_per_ingot[2],
            nil, nil, values.tint
        )
        SODA.recipe.add_simple(
            "purified-" .. name .. "-smelting", "smelting", "purified-" .. name, 4, name .. "-ingot", 1, SODA.constants.processing.total_time_per_ingot[2], "ingots-purified", values.order
        )
        SODA.icon.make("recipe", "purified-" .. name .. "-smelting", 64, SODA.path.icons("processing/ingot"), nil, values.tint)
    end
)

-- MID (0.4 fuel per ingot)
-- LATE (0.32 fuel per ingot)
