local all_unlocked = {water = true, ["discharged-primitive-battery"] = true, ["spent-nuclear-UV-emitter"] = true}
for key, _ in pairs(data.raw.tool) do
    if string.find(key, "%-sample") then
        all_unlocked[key] = true
    end
end
local unlocked_items = {}
local item_unlocks = {}
local categories = {chemistry = "chemical-plant", ["assembling-1"] = "assembling-machine-1"}

local techs_left = {}
for t, value in pairs(data.raw.technology) do
    if value.enabled or value.enabled == nil then
        local items = {}
        for _, i in pairs(value.unit.ingredients) do
            items[i[1]] = true
        end
        for _, e in pairs(value.effects) do
            if e.type == "unlock-recipe" then
                if data.raw.recipe[e.recipe] then
                    local ings = data.raw.recipe[e.recipe].ingredients
                    for _, i in pairs(ings) do
                        if items[i[1] or i.name] == nil then
                            items[i[1] or i.name] = true
                        end
                    end
                    local cat = data.raw.recipe[e.recipe].category
                    if categories[cat] then
                        items[categories[cat]] = true
                    end
                    local res = data.raw.recipe[e.recipe].result
                    if res then
                        items[res] = false
                    else
                        res = data.raw.recipe[e.recipe].results
                        for _, r in pairs(res) do
                            items[r[1] or r.name] = false
                        end
                    end
                else
                    error("Unknown recipe: " .. e.recipe)
                end
            end
        end
        table.insert(techs_left, {name = t, pre = table.deepcopy(value.prerequisites) or {}, items = items})
    end
end

local i = 0
local timeout = 0
local tech_count = #techs_left
while timeout <= tech_count do
    i = i + 1
    if i > tech_count then
        local nt = {}
        local j = 0
        for _, value in pairs(techs_left) do
            j = j + 1
            nt[j] = value
        end
        i = 1
        timeout = timeout - tech_count
        techs_left = nt
        tech_count = #techs_left
        timeout = timeout + tech_count
    end
    timeout = timeout + 1
    if techs_left[i] then
        local ready = true
        for _, value in pairs(techs_left[i].pre) do
            if not unlocked_items[value] then
                ready = false
                break
            end
        end
        if ready then
            for key, value in pairs(techs_left[i].items) do
                if value and (not all_unlocked[key]) then
                    ready = false
                    break
                end
            end
            if ready then
                local t = techs_left[i]
                techs_left[i] = nil
                timeout = 0

                -- set unlocks and find prereqs
                local unlocks = {}
                for key, value in pairs(t.items) do
                    if value then
                        local us = item_unlocks[key]
                        if us then
                            if #us == 1 then
                                table.insert(t.pre, {key, us[1]})
                            else
                                local max_amt = 0
                                local max = nil
                                for _, u in pairs(us) do
                                    local current = 0
                                    for match in string.gmatch(t.name, "[^-]+") do
                                        local h, o = string.gsub(u, match, "")
                                        h = nil
                                        current = current + o
                                    end
                                    if current > max_amt then
                                        max_amt = current
                                        max = u
                                    end
                                end
                                if max then
                                    table.insert(t.pre, {key, max})
                                end
                            end
                        else
                        end
                    else
                        unlocks[key] = true
                    end
                end
                -- remove (some) redundant prereqs
                local possible = {}
                local new_pre = {}

                for _, value in pairs(t.pre) do
                    if type(value) == "string" then
                        table.insert(new_pre, value)
                        for key, _ in pairs(unlocked_items[value]) do
                            unlocks[key] = true
                        end
                    else
                        possible[value[1]] = {tech = value[2], unlocks = unlocked_items[value[2]]}
                    end
                end
                while table_size(possible) > 0 do
                    for key, _ in pairs(possible) do
                        if unlocks[key] then
                            possible[key] = nil
                        end
                    end
                    if table_size(possible) == 0 then
                        break
                    end
                    local max_c = 0
                    local max = nil
                    for k, v in pairs(possible) do
                        local c = 0
                        for j, _ in pairs(possible) do
                            if v.unlocks[j] then
                                c = c + 1
                            end
                        end
                        if c > max_c then
                            max_c = c
                            max = k
                        end
                    end
                    for key, _ in pairs(possible[max].unlocks) do
                        unlocks[key] = true
                    end
                    table.insert(new_pre, possible[max].tech)
                    possible[max] = nil
                end

                -- update unlocks
                unlocked_items[t.name] = unlocks
                for key, value in pairs(t.items) do
                    if not value then
                        all_unlocked[key] = true
                        unlocks[key] = true
                        if not item_unlocks[key] then
                            item_unlocks[key] = {t.name}
                        else
                            table.insert(item_unlocks[key], t.name)
                        end
                    end
                end
                data.raw.technology[t.name].prerequisites = new_pre
            end
        end
    end
end
for _, _ in pairs(techs_left) do
    error("Unable to find prerequisites for technologies:\n" .. serpent.block(techs_left))
    break
end
