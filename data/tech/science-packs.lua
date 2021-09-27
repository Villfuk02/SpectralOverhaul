local all_packs = {}
for _, value in pairs(SODA.tech.generate_cost(6, true, "KEHASILCTPOR").ingredients) do
    all_packs[value[1]] = true
end

-- GROUP
local group_name = "research"
SODA.item.add_group(group_name, "r", SODA.path.graphics("technology/research-speed", true))

-- SUBGROUPS
local subgroups = {"production", "samples", "space", "packs"}
local tier_order = {automation = 1, energy = 2, mechanism = 3, military = 4, ["3"] = 5, ["4"] = 6, ["5"] = 7, ["6"] = 8}
for key, value in pairs(subgroups) do
    SODA.item.add_subgroup(group_name .. "-" .. value, group_name, "r" .. key)
end

-- PACKS
for pack, _ in pairs(all_packs) do
    local _, _, tier = string.find(pack, "([^-]+)" .. (string.gsub(SODA.tech.pack_suffix, "%-", "%%-")))
    local comp = {}
    for _, value in pairs(SODA.mat.list) do
        if string.find(pack, value) then
            table.insert(comp, value)
        end
    end
    local order = tier_order[tier]
    local icons = {{icon = SODA.path.icons("science-packs/science-pack" .. (tier == "6" and "-space" or ""))}}
    for key, mat in pairs(comp) do
        order = order .. SODA.MATS[mat].order
        icons[key + 1] = {icon = SODA.path.icons("science-packs/science-pack-" .. #comp .. key), tint = SODA.MATS[mat].tint}
    end
    local icon_spec = {icons = icons}
    SODA.item.add(pack, order, group_name .. "-packs", (tier == "6" and 200 or 2000), icon_spec, nil, "tool", {durability = 1})
end
