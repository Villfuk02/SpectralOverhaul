local particle = require "data.ores.ore-particles"
require "data.ores.ore-generation"
require "data.ores.ore-items"
local autoplace = require "data.ores.ore-generation"

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
        autoplace = autoplace(name),
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
