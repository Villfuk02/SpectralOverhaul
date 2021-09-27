SODA.tech = {}
SODA.tech.pack_suffix = "-science-pack"
SODA.tech.start_resources = {{"item", "wood", 40}, {"item", "stone", 40}} -- add catalysts
for _, m in pairs(SODA.mat.list) do
    table.insert(SODA.tech.start_resources, {"item", m .. "-ore", 5})
end

SODA.tech.colored_list = {}

function SODA.tech.add(prefix, name, cost, prereqs, effects, icon_spec, upgrade, max_level)
    if not icon_spec then
        icon_spec = {}
    end
    local tech = {type = "technology", name = prefix .. name, upgrade = upgrade, max_level = max_level, prerequisites = prereqs, unit = cost, localised_name = SODA.lang.cut_up(name)}

    if effects then
        for key, value in pairs(effects) do
            if type(value) == "string" then
                effects[key] = {type = "unlock-recipe", recipe = value}
            end
        end
        tech.effects = effects
    end

    data:extend{tech}
    SODA.icon.make(
        "technology", prefix .. name, icon_spec.size or 256, SODA.path.icons((icon_spec.folders or "technology") .. "/" .. (icon_spec.name or name), icon_spec.vanilla), nil, icon_spec.tint,
        icon_spec.icons
    )
end

local function two_type_packs(ingredients, k, prefix, type1, type2)
    for _, a in pairs(SODA.mat.types[type1].list) do
        if k[a] then
            for _, b in pairs(SODA.mat.types[type2].list) do
                if k[b] then
                    ingredients[a .. "-" .. b .. "-" .. prefix] = 1
                end
            end
        end
    end
    return ingredients
end

function SODA.tech.generate_ingredients(tier, military, kind, ban_packs)
    if not ban_packs then
        ban_packs = {}
    end
    local ingredients = {}
    local k = {}
    for _, value in pairs(SODA.mat.list) do
        k[value] = string.find(kind, SODA.MATS[value].short)
    end

    if tier == 0 then
        for key, _ in pairs(k) do
            table.insert(ingredients, {key .. "-ore-sample", 1})
        end
        return ingredients
    end

    if tier >= 1 then
        if not ban_packs["automation"] then
            ingredients = two_type_packs(ingredients, k, "automation", "structure", "mechanisms")
        end
    end

    if tier >= 2 then
        if not ban_packs["energy"] then
            ingredients = two_type_packs(ingredients, k, "energy", "fuel", "electronics")
        end
        if not ban_packs["mechanism"] then
            ingredients = two_type_packs(ingredients, k, "mechanism", "mechanisms", "electronics")
        end
    end

    if military then
        ingredients = two_type_packs(ingredients, k, "military", "fuel", "mechanisms")
    end

    if tier >= 3 then
        for key, _ in pairs(k) do
            ingredients[key .. "-3"] = 1
        end
    end

    if tier >= 4 then
        ingredients["4"] = 1
    end

    if tier >= 5 then
        local r = {}
        for t, tv in pairs(SODA.mat.types) do
            r[t] = {[""] = 0}
            for _, ki in pairs(tv.list) do
                local nr = {}
                for key, v in pairs(r[t]) do
                    nr[key] = v
                    if k[ki] then
                        nr[key .. ki .. "-"] = v + 1
                    end
                end
                r[t] = nr
            end
        end
        for _, tv in pairs(r) do
            for key, value in pairs(tv) do
                if value == 2 then
                    ingredients[key .. "5"] = 1
                end
            end
        end
    end

    if tier >= 6 then
        ingredients["6"] = 1
    end

    local ni = {}
    for key, value in pairs(ingredients) do
        table.insert(ni, {key .. SODA.tech.pack_suffix, value})
    end

    return ni
end

function SODA.tech.generate_cost(tier, military, kind, time, amt, ban_packs)
    local cost = {}
    cost.time = time
    if type(amt) == "number" then
        cost.count = amt
    else
        cost.count_formula = amt
    end
    cost.ingredients = SODA.tech.generate_ingredients(tier, military, kind, ban_packs)
    return cost
end

function SODA.tech.generate_parallel(materials, name, effects, tier, military, time, amt, generate_icons, prereqs, ban_packs)
    if not SODA.tech.colored_list[name] then
        SODA.tech.colored_list[name] = {}
    end
    SODA.mat.for_all_combinations(
        materials, function(combination, c)

            SODA.tech.colored_list[name][c] = c .. name
            local es = {}

            for _, e in pairs(effects) do
                if type(e) == "string" then
                    if string.sub(e, 1, 3) == "ALL" then
                        e = string.sub(e, 4)
                        for k, v in pairs(SODA.recipe.colored_list[e]) do
                            if string.find(c, (string.gsub(k, "%-", ".*"))) then
                                table.insert(es, v)
                            end
                        end
                    elseif SODA.recipe.colored_list[e] then
                        for k, v in pairs(SODA.recipe.colored_list[e]) do
                            if string.find(c, (string.gsub(k, "%-", ".*"))) then
                                table.insert(es, v)
                                break
                            end
                        end
                    else
                        table.insert(es, e)
                    end
                end
            end
            local icon_spec = nil
            if generate_icons == true then
                icon_spec = {}
                for _, e in pairs(es) do
                    if type(e) == "string" then
                        local i = data.raw.recipe[e]
                        if i and (i.result or (i.results and i.results[1])) then
                            table.insert(icon_spec, i.result or i.results[1][1] or i.results[1].name)
                        end
                    end
                end
                icon_spec = {size = 64, icons = SODA.icon.any_number(icon_spec)}
            elseif type(generate_icons) == "number" then
                local i = data.raw.recipe[es[generate_icons]]
                if i and (i.result or (i.results and i.results[1])) then
                    icon_spec = i.result or i.results[1][1] or i.results[1].name
                end
                icon_spec = {size = 64, icons = SODA.icon.get_icons_from(icon_spec)}
            end
            local kinds = ""
            for _, value in pairs(combination) do
                kinds = kinds .. SODA.MATS[value].short
            end
            SODA.tech.add(c, name, SODA.tech.generate_cost(tier, military, kinds, time, amt, ban_packs), prereqs, es, icon_spec)
        end
    )

end
