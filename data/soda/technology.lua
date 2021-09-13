SODA.tech = {}
SODA.tech.pack_prefix = "science-pack-"

function SODA.tech.add(name, cost, prereqs, effects, icon_spec, upgrade, max_level)
    local tech = {type = "technology", name = name, upgrade = upgrade, max_level = max_level, prerequisites = prereqs, unit = cost}
    tech = SODA.icon.add(tech, icon_spec.size or 256, SODA.path.icons((icon_spec.folders or "technology") .. "/" .. (icon_spec.name or name), icon_spec.vanilla), nil, icon_spec.tint)

    if effects then
        for key, value in pairs(effects) do
            if type(value) == "string" then
                effects[key] = {type = "unlock-recipe", recipe = value}
            end
        end
        tech.effects = effects
    end

    data:extend{tech}
end

local function two_type_packs(ingredients, k, prefix, type1, type2)
    for _, a in pairs(SODA.mat.types[type1].list) do
        if k[a] then
            for _, b in pairs(SODA.mat.types[type2].list) do
                if k[b] then
                    ingredients[prefix .. SODA.MATS[a].short .. SODA.MATS[b].short] = 1
                end
            end
        end
    end
    return ingredients
end

function SODA.tech.generate_ingredients(tier, military, kind)
    local ingredients = {}
    local k = {}
    for _, value in pairs(SODA.mat.list) do
        k[value] = string.find(kind, SODA.MATS[value].short)
    end

    if tier >= 1 then
        ingredients = two_type_packs(ingredients, k, "1", "structure", "mechanisms")
    end

    if tier >= 2 then
        ingredients = two_type_packs(ingredients, k, "2", "fuel", "electronics")
        ingredients = two_type_packs(ingredients, k, "2", "mechanisms", "electronics")
    end

    if military then
        ingredients = two_type_packs(ingredients, k, "M", "fuel", "mechanisms")
    end

    if tier >= 3 then
        for key, _ in pairs(k) do
            ingredients["3" .. SODA.MATS[key].short] = 1
        end
    end

    if tier >= 4 then
        ingredients["4"] = 1
    end

    if tier >= 5 then
        local r = {}
        for t, tv in pairs(SODA.mat.types) do
            r[t] = {["5"] = 0}
            for _, ki in pairs(tv.list) do
                local nr = {}
                for key, v in pairs(r[t]) do
                    nr[key] = v
                    if k[ki] then
                        nr[key .. SODA.MATS[ki].short] = v + 1
                    end
                end
                r[t] = nr
            end
        end
        for _, tv in pairs(r) do
            for key, value in pairs(tv) do
                if value == 2 then
                    ingredients[key] = 1
                end
            end
        end
    end

    if tier >= 6 then
        ingredients["6"] = 1
    end

    local ni = {}
    for key, value in pairs(ingredients) do
        ni[SODA.tech.pack_prefix .. key] = value
    end

    return ni
end

function SODA.tech.generate_cost(tier, military, kind, time, amt)
    local cost = {}
    cost.time = time
    if type(amt) == "number" then
        cost.count = amt
    else
        cost.count_formula = amt
    end
    cost.ingredients = SODA.tech.generate_ingredients(tier, military, kind)
    return cost
end
