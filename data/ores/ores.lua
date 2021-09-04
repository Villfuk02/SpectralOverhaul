local particle = require("data.ores.ore-particles")
require("data.ores.ore-generation")
require("data.ores.ore-items")

local stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80}
local walking_sound = {
    {filename = "__base__/sound/walking/resources/ore-01.ogg", volume = 0.7}, {filename = "__base__/sound/walking/resources/ore-02.ogg", volume = 0.7},
    {filename = "__base__/sound/walking/resources/ore-03.ogg", volume = 0.7}, {filename = "__base__/sound/walking/resources/ore-04.ogg", volume = 0.7},
    {filename = "__base__/sound/walking/resources/ore-05.ogg", volume = 0.7}, {filename = "__base__/sound/walking/resources/ore-06.ogg", volume = 0.7},
    {filename = "__base__/sound/walking/resources/ore-07.ogg", volume = 0.7}, {filename = "__base__/sound/walking/resources/ore-08.ogg", volume = 0.7},
    {filename = "__base__/sound/walking/resources/ore-09.ogg", volume = 0.7}, {filename = "__base__/sound/walking/resources/ore-10.ogg", volume = 0.7},
}

local function resource(name)
    local results = {{name = name .. "-ore", type = "item", amount = 1}}
    return {
        type = "resource",
        name = name,
        localised_name = {"item-name." .. name .. "-ore"},
        icons = {{icon = SODA.path_icons("ores", "ore"), icon_size = 64, icon_scale = 0.5, tint = SODA.MAT[name].tint}},
        icon_mipmaps = 4,
        icon_size = 64,
        flags = {"placeable-neutral"},
        order = "b-" .. SODA.MAT[name].order,
        minable = {mining_time = 1, mining_particle = name .. "-mining-particle", results = results},
        collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        -- autoplace = resource_autoplace.resource_autoplace_settings { -- TODO
        --     name = name,
        --     order = "b",
        --     base_density = oredata.base_density,
        --     has_starting_area_placement = oredata.start,
        --     regular_rq_factor_multiplier = oredata.ban_outside_start and -1 or oredata.frequency,
        --     starting_rq_factor_multiplier = oredata.frequency,
        --     autoplace_control_name = string.gsub(oredata.variant_of, "scrap", "ore"),
        --     base_spots_per_km2 = oredata.base_spots_per_km2,
        --     random_spot_size_minimum = oredata.random_spot_size_minimum,
        --     random_spot_size_maximum = oredata.random_spot_size_maximum,
        -- } or nil,
        stage_counts = stage_counts,
        stages = {sheet = {filename = SODA.path_entities("ores", "ore"), priority = "extra-high", width = 64, height = 64, frame_count = 8, variation_count = 8, tint = SODA.MAT[name].tint}},
        tree_removal_max_distance = 1024,
        tree_removal_probability = 0.9,
        map_color = SODA.MAT[name].map_color,
        walking_sound = walking_sound,
    }
end

for _, name in pairs(SODA.MAT.all) do
    data:extend({resource(name)})
    data:extend({particle(name)})

end

-- TODO
-- data:extend{
--         {
--             type = "autoplace-control",
--             name = name .. "-ore",
--             localised_name = {"", "[item=" .. name .. "-ore] ", {"item-name." .. name .. "-ore"}},
--             richness = true,
--             order = "c-" .. name,
--             category = "resource",
--         },
--     }

-- resource_autoplace.initialize_patch_set(name, oredata.start)
--     data:extend{{type = "noise-layer", name = name}}

-- for _, preset in pairs(data.raw["map-gen-presets"]["default"]) do
--         if preset.basic_settings and preset.basic_settings.autoplace_controls then
--             preset.basic_settings.autoplace_controls[name .. "-ore"] = preset.basic_settings.autoplace_controls["iron-ore"]
--         end
--     end
