-- START
data.raw.recipe["wooden-chest"].enabled = false
data.raw.recipe["wooden-chest"].category = "assembling"
table.insert(data.raw.technology["wood-analysis"].effects, {type = "unlock-recipe", recipe = "wooden-chest"})
table.insert(data.raw.technology["stone-analysis"].effects, {type = "unlock-recipe", recipe = "stone-brick"})
table.insert(data.raw.technology["stone-analysis"].effects, {type = "unlock-recipe", recipe = "stone-furnace"})

SODA.tech.generate_parallel(
    {"structure", SODA.mat.metals}, "basic-components", {"plate", "rod", "transmission-belts", "joints", "gears", "piston", "tubes", "cable", "foil", "coil"}, 0, false, 0.1, 100, true
)
SODA.mat.for_all_combinations(
    {"structure", "structure"}, function(c, prefix)
        if c[1] ~= c[2] then
            data.raw.technology[prefix .. "basic-components"] = nil
        end
    end
)
SODA.tech.generate_parallel({"structure", "mechanisms"}, "burner-mininer", {"burner-mining-drill"}, 0, false, 0.1, 100, 1)
SODA.tech.generate_parallel({"structure", "electronics"}, "gravel-making", {"gravel"}, 0, false, 0.1, 100, 1, {"stone-analysis"})
-- ELECTRICITY
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "electricity-1", {"stirling-engine", "small-electric-pole", "simple-motor"}, 0, false, 0.1, 200, 1)
-- AUTMATION
SODA.recipe.add_from_prefabs({"structure", "mechanisms"}, "assembling", {{"simple-motor", 4}, {SODA.RIP.plate_4s, 6}, {SODA.RIP.mechanism_0_4m_1s, 2}}, "lab", 1, 1)
local inputs = SODA.tech.generate_ingredients(3, true, "KEHASILCTPOR")
for key, value in pairs(inputs) do
    inputs[key] = value[1]
end
data.raw.lab.lab.inputs = inputs
SODA.recipe.add_from_prefabs({"structure", "mechanisms"}, "assembling", {{SODA.RIP.plate_4s, 1}, {SODA.RIP.mechanism_transmission_2m, 1}}, "automation-science-pack", 1, 10, nil, true)
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "automation-science-pack", {"lab", "automation-science-pack"}, 0, false, 0.2, 100, 2)

SODA.tech.generate_parallel(
    {"structure", {"lime"}, "electronics"}, "logistics-1", {"slow-transport-belt", "slow-underground-belt", "slow-splitter", "simple-miniloader", "iron-chest"}, 1, false, 30, 5, true
)
SODA.tech.generate_parallel({"structure", {"white"}, "electronics"}, "logistics-1", {"inserter", "thrower-inserter", "transport-platform", "iron-chest"}, 1, false, 30, 5, true)
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "fluid-handling", {"electric-offshore-pump", "pipe", "pipe-to-ground"}, 1, false, 30, 5, 2)
SODA.tech.generate_parallel({{"azure"}, "mechanisms", "electronics"}, "electric-miner", {"deep-miner"}, 1, false, 30, 10, 1)
SODA.tech.generate_parallel({{"silver"}, "mechanisms", "electronics"}, "electric-miner", {"surface-miner"}, 1, false, 30, 10, 1)
SODA.tech.generate_parallel({{"pink"}, "mechanisms", "electronics"}, "electric-miner", {"dissolving-miner"}, 1, false, 30, 10, 1)
SODA.recipe.add_from_prefabs({"structure", "mechanisms", "electronics"}, "assembling", {{SODA.RIP.rod_2s, 2}, {SODA.RIP.mechanism_transmission_2m, 1}, {SODA.RIP.cable_1e, 1}}, "repair-pack", 1, 0.5)
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "basic-machining", {"fabricator", "repair-pack"}, 1, false, 30, 5, 1)
SODA.recipe.add_from_prefabs(
    {"structure", "mechanisms", "electronics"}, "assembling", {{SODA.RIP.plate_4s, 2}, {"simple-motor", 1}, {SODA.RIP.mechanism_0_4m_1s, 1}, {SODA.RIP.electronics_0_2e, 6}}, "radar", 1, 0.5
)
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "radar", {"radar"}, 1, false, 30, 5, 1)

-- EARLY
SODA.recipe.add_from_prefabs({"mechanisms", "electronics"}, "assembling", {{SODA.RIP.mechanism_pack_ingredients, 1}, {SODA.RIP.cable_1e, 2}}, "mechanism-science-pack", 1, 10, nil, true)
SODA.recipe.add_from_prefabs({"fuel", "electronics"}, "assembling", {{SODA.RIP.fuel_unit_2f, 2}, {SODA.RIP.electronics_0_2e, 1}, {"simple-motor", 1}}, "energy-science-pack", 1, 10, nil, true)
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "mechanism-science-pack", {"mechanism-science-pack"}, 1, false, 60, 10, 1)
SODA.tech.generate_parallel({"fuel", "structure", "mechanisms", "electronics"}, "energy-science-pack", {"energy-science-pack"}, 1, false, 60, 10, 1)

SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "automation-1", {"assembling-machine-1"}, 2, false, 30, 10, 1)
SODA.tech.generate_parallel({"structure", "mechanisms", "electronics"}, "chemistry-1", {"chemical-plant"}, 2, false, 30, 10, 1)
SODA.tech.generate_parallel({"fuel", "structure", "mechanisms", "electronics"}, "crushing-1", {"crusher", "crushed-fuel"}, 2, false, 30, 10, 1, nil, {energy = true})

SODA.tech.generate_parallel({"fuel", "structure", "mechanisms", "electronics"}, "ceramic", {"ceramic-mix", "ceramic-sheet"}, 2, false, 30, 10, 2, nil, {energy = true})

SODA.tech.generate_parallel({{"azure"}, "fuel", {"azure"}, "mechanisms", "electronics"}, "cutter", {"cutter", "beam"}, 2, false, 30, 20, 1, nil, {energy = true})
SODA.tech.generate_parallel({{"azure"}, {"azure"}, "mechanisms", "electronics"}, "lathe-mill", {"lathe-mill", "spring", "gaskets"}, 2, false, 30, 20, 1)
SODA.tech.generate_parallel({{"silver"}, {"silver"}, "mechanisms", "electronics"}, "cold-roller", {"cold-roller", "spring"}, 2, false, 30, 20, 1)
SODA.tech.generate_parallel({{"silver"}, "fuel", {"silver"}, "mechanisms", "electronics"}, "metal-press", {"metal-press", "beam", "gaskets"}, 2, false, 30, 20, 1, nil, {energy = true})
SODA.tech.generate_parallel({{"pink"}, {"pink"}, "mechanisms", "electronics"}, "casting-machine", {"casting-machine", "gaskets"}, 2, false, 30, 20, 1)
SODA.tech.generate_parallel({{"pink"}, "fuel", {"pink"}, "mechanisms", "electronics"}, "hot-roller", {"hot-roller", "beam", "spring"}, 2, false, 30, 20, 1, nil, {energy = true})

SODA.tech.generate_parallel(
    {{"black"}, "structure", "mechanisms", "electronics"}, "advanced-material-processing", {"activated-black", "blast-furnace", "slag-crushing", "ALLingot-blasting"}, 2, false, 30, 40, true, nil,
    {energy = true}
)
SODA.tech.generate_parallel(
    {{"yellow"}, "structure", "mechanisms", "electronics"}, "advanced-material-processing", {"ALLreduction-mix", "ALLingot-reduction", "yellow-reduction"}, 2, false, 30, 40, true,
    {"yellow-ore-analysis"}, {energy = true}
)
SODA.tech.generate_parallel(
    {{"green"}, "structure", "mechanisms", "electronics"}, "advanced-material-processing", {"ALLpurified", "ALLpurified-smelting", "green-acid"}, 2, false, 30, 40, true, nil, {energy = true}
)

SODA.tech.generate_parallel(
    {"fuel", "structure", "mechanisms", "electronics"}, "electronics-1", {"panel", "sensor", "electronic-components", "circuit", "magnet", "memory"}, 2, false, 30, 10, true, nil, {mechanism = true}
)

SODA.tech.generate_parallel({"fuel", "structure", {"lime"}, "electronics"}, "logistics-2", {"transport-belt", "underground-belt", "splitter", "slow-miniloader"}, 2, false, 30, 20, true)
SODA.tech.generate_parallel({"fuel", "structure", {"white"}, "electronics"}, "logistics-2", {"fast-inserter", "filter-inserter"}, 2, false, 30, 20, true)

SODA.tech.generate_parallel(
    {{"black"}, "structure", "mechanisms", {"purple"}}, "electricity-2", {"medium-electric-pole", "activated-black", "UV-emitter", "activated-UV-emitter", "UV-generator"}, 2, false, 30, 20, true
)
SODA.tech.generate_parallel(
    {{"yellow"}, "structure", "mechanisms", {"purple"}}, "electricity-2", {"medium-electric-pole", "primitive-battery", "primitive-battery-reprocessing", "battery-discharger"}, 2, false, 30, 20, true
)
SODA.tech.generate_parallel(
    {{"green"}, "structure", "mechanisms", {"purple"}}, "electricity-2", {"medium-electric-pole", "nuclear-UV-emitter", "nuclear-UV-emitter-reprocessing", "UV-generator"}, 2, false, 30, 20, true
)
SODA.tech.generate_parallel(
    {{"black"}, "structure", "mechanisms", {"orange"}}, "electricity-2", {"medium-electric-pole", "activated-black", "heat-pipe", "heat-reactor", "heat-adapter", "thermoelectric-generator"}, 2, false,
    30, 20, true
)
SODA.tech.generate_parallel(
    {{"yellow"}, "structure", "mechanisms", {"orange"}}, "electricity-2", {"medium-electric-pole", "heat-cell-from-yellow", "heat-pipe", "heat-reactor", "heat-adapter", "thermoelectric-generator"}, 2,
    false, 30, 20, true
)
SODA.tech.generate_parallel(
    {{"green"}, "structure", "mechanisms", {"orange"}}, "electricity-2", {"medium-electric-pole", "heat-cell-from-green", "heat-pipe", "heat-reactor", "heat-adapter", "thermoelectric-generator"}, 2,
    false, 30, 20, true
)
SODA.tech.generate_parallel({{"black"}, "structure", "mechanisms", {"red"}}, "electricity-2", {"medium-electric-pole", "activated-black", "combustion-chamber", "steam-engine"}, 2, false, 30, 20, true)
SODA.tech.generate_parallel({{"yellow"}, "structure", "mechanisms", {"red"}}, "electricity-2", {"medium-electric-pole", "yellow-gas", "steam-engine"}, 2, false, 30, 20, true)
SODA.tech.generate_parallel(
    {{"green"}, "structure", "mechanisms", {"red"}}, "electricity-2", {"medium-electric-pole", "green-acid", "steam-from-green-acid", "slag-crushing", "steam-engine"}, 2, false, 30, 20, true

)

data.raw.technology["simple-miniloader"].enabled = false
