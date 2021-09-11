SODA.recipe = {}

function SODA.recipe.add_simple(name, category, input, amt, result, result_amt, time, subgroup, order, tint)
    local r = {type = "recipe", name = name, category = category, energy_required = time, ingredients = (amt and {{input, amt}} or input), subgroup = subgroup, order = order}
    if result_amt then
        r.result = result
        r.result_count = result_amt
    else
        r.results = result
    end
    if tint then
        r.crafting_machine_tint = {primary = tint, secondary = tint, tertiary = tint, quaternary = tint}
    end
    data:extend{r}
end
