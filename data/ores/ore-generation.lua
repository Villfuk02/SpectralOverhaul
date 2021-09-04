local resource_autoplace = require("__core__/lualib/resource-autoplace")
local noise = require("__core__/lualib/noise")

local type_divisor = {fuel = 1, structure = 3, mechanisms = 9, electronics = 27}
return function(name)
    if SODA.MAT.types[SODA.MAT[name].type][name] == 1 then
        data:extend{
            {
                type = "autoplace-control",
                name = SODA.MAT[name].type .. "-ores",
                localised_name = {
                    "", "[item=" .. SODA.MAT.types[SODA.MAT[name].type].list[1] .. "-ore] ", "[item=" .. SODA.MAT.types[SODA.MAT[name].type].list[2] .. "-ore] ",
                    "[item=" .. SODA.MAT.types[SODA.MAT[name].type].list[3] .. "-ore] ", {"item-name." .. SODA.MAT[name].type .. "-ores"},
                },
                richness = true,
                order = "s-" .. SODA.MAT[name].order,
                category = "resource",
            },
        }
        for k, preset in pairs(data.raw["map-gen-presets"]["default"]) do
            if preset.basic_settings and preset.basic_settings.autoplace_controls then
                preset.basic_settings.autoplace_controls[SODA.MAT[name].type .. "-ores"] = SODA.autoplace_presets[k]
            end
        end
    end

    data:extend{{type = "noise-layer", name = name}}

    local autoplace = resource_autoplace.resource_autoplace_settings(
                          {
            name = name .. "-ore",
            order = "b",
            base_density = 10,
            has_starting_area_placement = true,
            regular_rq_factor_multiplier = 1.1,
            starting_rq_factor_multiplier = 1.1,
            autoplace_control_name = SODA.MAT[name].type .. "-ores",
        }
                      )

    local divisor = 512 * type_divisor[SODA.MAT[name].type]
    local match = SODA.MAT.types[SODA.MAT[name].type][name] - 1
    autoplace.probability_expression = noise.equals(noise.fmod(noise.floor(noise.var("map_seed") / divisor), 3), match)
    return autoplace
end
