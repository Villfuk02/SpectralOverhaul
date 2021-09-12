SODA.recipe = {}

function SODA.recipe.add_simple(name, category, input, amt, result, result_amt, time, subgroup, order, tint, show_products, icons)
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
    data:extend{r}
end

function SODA.recipe.add_category(name)
    data:extend{{type = "recipe-category", name = name}}
end
