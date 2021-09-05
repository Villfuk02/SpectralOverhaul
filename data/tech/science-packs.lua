local all_packs = SODA.tech.generate_cost(6, true, "KEHASILCTPOR").ingredients

-- GROUP
local group_name = "research"
local group = {type = "item-group", name = group_name, order = "r"}
group = SODA.icon.make(group, 256, SODA.path.graphics("technology/research-speed", true))
data:extend{group}

-- SUBGROUPS
local subgroups = {"production", "space", "packs"}
local tier_order = {["1"] = 1, ["2"] = 2, M = 3, ["3"] = 4, ["4"] = 5, ["5"] = 6, ["6"] = 7}
for key, value in pairs(subgroups) do
    data:extend{{type = "item-subgroup", name = group_name .. "-" .. value, group = group_name, order = "r" .. key}}
end

-- PACKS
for pack, _ in pairs(all_packs) do
    local tier = pack:sub(#SODA.tech.pack_prefix + 1, #SODA.tech.pack_prefix + 1)
    local comp = {}
    for i = #SODA.tech.pack_prefix + 2, #pack, 1 do
        comp[i - #SODA.tech.pack_prefix - 1] = pack:sub(i, i)
    end
    local order = tier_order[tier]
    local icons = {{icon = SODA.path.icons("science-packs/science-pack" .. (tier == "6" and "-space" or ""))}}
    for key, sh in pairs(comp) do
        local mat = SODA.mat.by_short(sh)
        order = order .. mat.order
        icons[key + 1] = {icon = SODA.path.icons("science-packs/science-pack-" .. #comp .. key), tint = mat.tint}
    end
    local icon_spec = {icons = icons}
    SODA.item.add(pack, order, group_name .. "-packs", (tier == "6" and 200 or 2000), icon_spec)
end
