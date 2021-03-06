local group_name = "intermediate-products"

-- START
SODA.item.add_subgroup("gravel", group_name, "a")

SODA.recipe.colored_list["gravel"] = {}
for _, m in pairs(SODA.mat.types.structure.list) do
    for _, n in pairs(SODA.mat.types.electronics.list) do
        SODA.recipe.add(
            "gravel-from-" .. m .. "-and-" .. n, "dry-mixing", {{m .. "-ore", 1}, {n .. "-ore", 1}}, nil, "stone", 2, 1, "gravel", "1" .. SODA.MATS[m].order .. SODA.MATS[n].order,
            SODA.color.lerp(SODA.MATS[m].tint, SODA.MATS[n].tint, 0.5), true, SODA.icon.icons_2_to_1(m .. "-ore", n .. "-ore", "stone"), {allow_as_intermediate = false}
        )
        SODA.recipe.colored_list["gravel"][m .. "-" .. n] = "gravel-from-" .. m .. "-and-" .. n
    end
end
SODA.recipe.add("stone-brick", "smelting", "stone", 2, "stone-brick", 1, 12)
data.raw.item["stone-brick"].subgroup = "gravel"
data.raw.item["stone"].subgroup = "gravel"

-- EARLY (some will be unlocked from start anyway)

local function for_all(kinds, f)
    for _, mat in pairs(kinds) do
        f(mat)
    end
end

SODA.item.add_subgroup("plates", group_name, "b")
local structure_subgroup = "structure-components"
SODA.item.add_subgroup(structure_subgroup, group_name, "c")
local mechanism_subgroup = "mechanism-components"
SODA.item.add_subgroup(mechanism_subgroup, group_name, "d")
local electronic_subgroup = "electronic-components"
SODA.item.add_subgroup(electronic_subgroup, group_name, "e")

-- plates 4x
for_all(
    SODA.mat.metals, function(mat)
        SODA.recipe.add_for_each_str_mat(mat, "plate", {"cutting", "cold-rolling", "hot-rolling"}, {{mat .. "-ingot", 1}}, 2, 2, SODA.MATS[mat].order, "plates", 100)
    end
)

-- rods 2s
for_all(
    SODA.mat.types.structure.list, function(mat)
        SODA.recipe.add_for_each_str_mat(mat, "rod", {"milling", "cold-rolling", "casting"}, {{mat .. "-ingot", 1}}, 4, 2, "1", structure_subgroup, 200)
    end
)

-- beams 8s
for_all(
    SODA.mat.types.structure.list, function(mat)
        SODA.recipe.add_for_each_str_mat(mat, "beam", {"cutting-1", "pressing-1", "hot-rolling-1"}, {{mat .. "-ingot", 1}, {mat .. "-plate", 2}}, 2, 16, "2", structure_subgroup, 100)
    end
)

-- structure specials
-- azure
SODA.item.add("azure-blade", "za", structure_subgroup, 200, {folders = "intermediates"})
SODA.recipe.add("azure-blade", "milling-1", "azure-plate", 1, "azure-blade", 2, 8) -- 2s
-- silver
SODA.item.add("silver-reinforced-plate", "zb", structure_subgroup, 100, {folders = "intermediates"})
SODA.recipe.add("silver-reinforced-plate", "pressing-1", "silver-plate", 2, "silver-reinforced-plate", 1, 16) -- 8s
-- pink
SODA.item.add("pink-tube", "zc", structure_subgroup, 100, {folders = "intermediates", name = "tube", tint = SODA.MATS.pink.tint})
SODA.recipe.add("pink-tube", "hot-rolling-1", "pink-plate", 1, "pink-tube", 1, 8) -- 4s

-- mechanism specials
-- lime
SODA.recipe.add_for_each_str_mat("lime", "transmission-belts", {"cutting", "pressing", "hot-rolling"}, {{"lime-plate", 1}}, 4, 2, "a", mechanism_subgroup, 200) -- 1m
SODA.recipe.add_for_each_str_mat("lime", "joints", {"milling", "pressing", "casting"}, {{"lime-ingot", 1}, {"MAT-rod", 2}}, 8, 6, "b", mechanism_subgroup, 200) -- 1m + 0.5s
SODA.recipe.add_for_each_str_mat("lime", "spring", {"milling-1", "cold-rolling-1", "hot-rolling-1"}, {{"lime-plate", 1}}, 2, 2, "c", mechanism_subgroup, 200) -- 2m

-- blue
SODA.recipe.add_for_each_str_mat("blue", "gears", {"milling", "pressing", "casting"}, {{"blue-ingot", 1}}, 4, 4, "d", mechanism_subgroup, 200) -- 2m
for_all(
    {"blue", "white"}, function(mat)
        SODA.recipe.add_for_each_str_mat(mat, "piston", "assembling", {{mat .. "-plate", 1}, {"MAT-rod", 1}}, 2, 3, "e", mechanism_subgroup, 100) -- 2m + 1s
    end
)
SODA.recipe.add_for_each_str_mat("blue", "gaskets", {"milling-1", "pressing-1", "casting-1"}, {{"blue-plate", 1}}, 4, 2, "f", mechanism_subgroup, 200) -- 1m
-- white
SODA.recipe.add_for_each_str_mat("white", "tubes", {"milling", "cold-rolling", "hot-rolling"}, {{"white-plate", 1}}, 4, 2, "g", mechanism_subgroup, 200) -- 1m
SODA.recipe.add_for_each_str_mat("white", "spring", {"milling-1", "cold-rolling-1", "hot-rolling-1"}, {{"white-tubes", 1}}, 1, 2, "h", mechanism_subgroup, 200) -- 2m

-- electronic specials
for_all(
    SODA.mat.types.electronics.list, function(mat)
        SODA.recipe.add_for_each_str_mat(mat, "cable", {"cutting", "cold-rolling", "hot-rolling"}, {{mat .. "-plate", 1}}, 4, 2, "a", electronic_subgroup, 200) -- 1e
    end
)
-- purple
for_all(
    {"purple", "orange"}, function(mat)
        SODA.recipe.add_for_each_str_mat(mat, "foil", {"cutting", "pressing", "casting"}, {{mat .. "-plate", 1}}, 4, 2, "b", electronic_subgroup, 200) -- 1e
    end
)
SODA.recipe.add_for_each_mech_mat("purple", "panel", "assembling-1", {{"purple-foil", 2}, {"MAT-plate", 1}}, 2, 3, "c", electronic_subgroup, 100) -- 1e + 2m
SODA.recipe.add_for_each_str_mat("purple", "sensor", "assembling-1", {{"purple-panel", 2}, {"MAT-plate", 1}, {"purple-cable", 6}}, 4, 16, "d", electronic_subgroup, 100) -- 2e + 1m + 1s
-- orange
SODA.recipe.add_for_each_str_mat("orange", "electronic-components", "assembling-1", {{"orange-cable", 3}, {"MAT-rod", 1}}, 4, 2.5, "e", electronic_subgroup, 200) -- 0.75e + 0.5s
SODA.recipe.add_for_each_mech_mat("orange", "circuit", "assembling-1", {{"orange-electronic-components", 8}, {"orange-foil", 2}, {"MAT-plate", 1}}, 4, 16, "f", electronic_subgroup, 100) -- 2e + 1m + 1s
-- red
SODA.recipe.add_for_each_str_mat("red", "coil", {"milling", "cold-rolling", "hot-rolling"}, {{"red-cable", 2}}, 1, 1, "g", electronic_subgroup, 200) -- 2e
SODA.recipe.add_for_each_str_mat("red", "magnet", "assembling-1", {{"red-coil", 1}, {"MAT-rod", 1}}, 1, 2, "h", electronic_subgroup, 100) -- 2e + 2s
SODA.recipe.add_for_each_mech_mat("red", "memory", "assembling-1", {{"red-magnet", 4}, {"MAT-ingot", 1}, {"red-cable", 8}}, 8, 32, "i", electronic_subgroup, 100) -- 2e + 1m + 1s

-- MOTOR
local simple_subgroup = "simple-intermediates"
SODA.item.add_subgroup(simple_subgroup, group_name, "f")
SODA.item.add("simple-motor", "0", simple_subgroup, 100, {folders = "intermediates"})
SODA.recipe.add_from_prefabs({"mechanisms", "electronics"}, "assembling", {{SODA.RIP.cable_1e, 4}, {SODA.RIP.mechanism_0_4m_1s, 1}}, "simple-motor", 2, 4) -- 2e + 2m + 0.5s

-- CERAMIC
SODA.item.add("ceramic-mix", "1", simple_subgroup, 100, {folders = "intermediates"})
SODA.recipe.add_from_prefabs({"fuel", "structure"}, "dry-mixing", {{"stone", 2}, {SODA.RIP.crushed_ore_1f, 2}, {SODA.RIP.ore_2s, 1}}, "ceramic-mix", 2, 2) -- 1f + 2s + 1e
SODA.item.add("ceramic-sheet", "2", simple_subgroup, 100, {folders = "intermediates"})
SODA.recipe.add("ceramic-sheet", "smelting", "ceramic-mix", 1, "ceramic-sheet", 1, 24)
