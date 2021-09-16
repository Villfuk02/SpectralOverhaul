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
        enabled = true, -- CHANGE TO FALSE
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
