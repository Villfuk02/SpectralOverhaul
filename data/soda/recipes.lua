SODA.recipe = {}

function SODA.recipe.add(name, category, input, amt, result, result_amt, time, subgroup, order, tint, show_products, icons, extras)
    if not category then
        category = name .. "-category"
        SODA.recipe.add_category(category)
    end
    local r = {
        type = "recipe",
        name = name,
        category = category,
        energy_required = time,
        ingredients = (amt and {{input, amt}} or input),
        subgroup = subgroup,
        order = order,
        localised_name = SODA.lang.cut_up(name),
        icons = icons,
        icon_size = icons and 64 or nil,
        enabled = false,
    }
    if result_amt then
        r.result = result
        r.result_count = result_amt
    else
        r.results = result
    end
    if tint then
        r.crafting_machine_tint = {primary = tint, secondary = tint, tertiary = tint, quaternary = tint}
    end
    if show_products then
        r.show_amount_in_title = false
        r.always_show_products = true
    end
    if extras then
        for key, value in pairs(extras) do
            r[key] = value
        end
    end
    data:extend{r}
end

function SODA.recipe.add_category(name)
    data:extend{{type = "recipe-category", name = name}}
end

function SODA.recipe.add_for_each_str_mat(color, name, category, inputs, result_amt, time, order, subgroup, stack_size)
    local color_name = color and (color .. "-") or ""
    local tint = color and SODA.MATS[color].tint or nil
    local order_prefix = color and SODA.MATS[color].order or ""
    if order and subgroup and stack_size then
        SODA.item.add(color_name .. name, order_prefix .. order, subgroup, stack_size, {folders = "intermediates", name = name, tint = tint})
    end
    if type(category) ~= "table" then
        category = {category, category, category}
    end
    if type(inputs[1][1]) ~= "table" then
        inputs = {table.deepcopy(inputs), table.deepcopy(inputs), table.deepcopy(inputs)}
    end
    if type(time) ~= "table" then
        time = {time, time, time}
    end
    for i, mat in pairs(SODA.mat.types.structure.list) do
        for j, value in pairs(inputs[i]) do
            if value[1] then
                inputs[i][j][1] = string.gsub(value[1], "MAT", mat)
            end
        end
        SODA.recipe.add(
            color_name .. name .. "-" .. mat, category[i], inputs[i], nil, color_name .. name, result_amt, time[i], nil, nil, nil, nil, nil, {localised_name = SODA.lang.cut_up(color_name .. name)}
        )
    end
end

function SODA.recipe.add_for_each_mech_mat(color, name, category, inputs, result_amt, time, order, subgroup, stack_size)
    local color_name = color and (color .. "-") or ""
    local tint = color and SODA.MATS[color].tint or nil
    local order_prefix = color and SODA.MATS[color].order or ""
    if order and subgroup and stack_size then
        SODA.item.add(color_name .. name, order_prefix .. order, subgroup, stack_size, {folders = "intermediates", name = name, tint = tint})
    end
    if type(inputs[1][1]) ~= "table" then
        inputs = {table.deepcopy(inputs), table.deepcopy(inputs), table.deepcopy(inputs)}
    end
    for i, mat in pairs(SODA.mat.types.mechanisms.list) do
        for j, value in pairs(inputs[i]) do
            if value[1] then
                inputs[i][j][1] = string.gsub(value[1], "MAT", mat)
            end
        end
        SODA.recipe.add(
            color_name .. name .. "-" .. mat, category, inputs[i], nil, color_name .. name, result_amt, time, nil, nil, nil, nil, nil, {localised_name = SODA.lang.cut_up(color_name .. name)}
        )
    end
end

SODA.RIP = {
    plate_4s = {structure = {{{"azure-plate", 1}}, {{"silver-plate", 1}}, {{"pink-plate", 1}}}},
    rod_2s = {structure = {{{"azure-rod", 1}}, {{"silver-rod", 1}}, {{"pink-rod", 1}}}},
    structure_1_16s = {structure = {{{"azure-beam", 1}, {"azure-plate", 2}}, {{"silver-beam", 1}, {"silver-plate", 2}}, {{"pink-beam", 1}, {"pink-plate", 2}}}},
    cable_1e = {electronics = {{{"purple-cable", 1}}, {{"orange-cable", 1}}, {{"red-cable", 1}}}},
    mechanism_transmission_2m = {mechanisms = {{{"lime-transmission-belts", 2}}, {{"blue-gears", 1}}, {{"white-tube", 2}}}},
    mechanism_0_4m_1s = {mechanisms = {{{"lime-transmission-belts", 2}, {"lime-joints", 2}}, {{"blue-gears", 1}, {"blue-piston", 1}}, {{"white-piston", 1}, {"white-tube", 2}}}},
    mechanism_1_6m_1s = {
        mechanisms = {
            {{"lime-transmission-belts", 2}, {"lime-joints", 2}, {"lime-spring", 1}}, {{"blue-gears", 1}, {"blue-piston", 1}, {"blue-gaskets", 2}},
            {{"white-piston", 1}, {"white-tube", 2}, {"white-spring", 1}},
        },
    },
    electronics_0_2e = {electronics = {{{"purple-foil", 2}}, {{"orange-foil", 2}}, {{"red-spring", 1}}}},
    electronics_1_2e_1m_1s = {electronics = {{{"purple-sensor", 1}}, {{"orange-circuit", 1}}, {{"red-memory", 1}}}},
}

if not SODA.RIP.done then
    for key, value in pairs(SODA.RIP) do
        local prepared = {}
        for k, v in pairs(value) do
            if SODA.mat.types[k] then
                for i, m in pairs(SODA.mat.types[k].list) do
                    prepared[m] = v[i]
                end
            else
                prepared[k] = v
            end
        end
        SODA.RIP[key] = prepared
    end
    SODA.RIP.done = true
end

function SODA.recipe.add_from_prefabs(materials, categories, ingredients, result, amt, time, fluids)
    local combinations = {""}
    if materials ~= nil then
        for i, value in pairs(materials) do
            local new_combinations = {}
            if type(value) == "string" then
                value = SODA.mat.types[value].list
            end
            for _, v in pairs(value) do
                for _, c in pairs(combinations) do
                    table.insert(new_combinations, c .. v .. "-")
                end
            end
            combinations = new_combinations
        end
    end
    for _, c in pairs(combinations) do
        local category = "NOT FOUND"
        if type(categories) == "string" then
            category = categories
        else
            for key, value in pairs(categories) do
                if string.find(c, SODA.mat.types.structure.list[key], nil, true) then
                    category = value
                    break
                end
            end
        end
        local parsed_ingredients = {}
        for _, value in pairs(ingredients) do
            if type(value[1]) == "string" then
                if parsed_ingredients[value[1]] then
                    parsed_ingredients[value[1]] = parsed_ingredients[value[1]] + value[2]
                else
                    parsed_ingredients[value[1]] = value[2]
                end
            else
                local p = {}
                for k, v in pairs(value[1]) do
                    if string.find(c, k) then
                        p = table.deepcopy(v)
                        break
                    end
                end
                for k, v in pairs(p) do
                    p[k][2] = v[2] * value[2]
                end
                for _, v in pairs(p) do
                    if parsed_ingredients[v[1]] then
                        parsed_ingredients[v[1]] = parsed_ingredients[v[1]] + v[2]
                    else
                        parsed_ingredients[v[1]] = v[2]
                    end
                end
            end
        end
        local final_ingredients = {}
        for key, value in pairs(parsed_ingredients) do
            table.insert(final_ingredients, {key, value})
        end
        if fluids then
            for _, value in pairs(fluids) do
                table.insert(final_ingredients, {type = "fluid", name = value[1], count = value[2]})
            end
        end
        SODA.recipe.add(c .. result, category, final_ingredients, nil, result, amt, time, nil, nil, nil, nil, nil, {localised_name = SODA.lang.cut_up(result)})
    end
end
