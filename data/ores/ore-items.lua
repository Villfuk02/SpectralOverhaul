local item = require("data.globals.items")

local function ore_item(name)
    return item(
               {
            name = name .. "-ore",
            order = "e-" .. SODA.MAT[name].order,
            subgroup = "raw-resource",
            icon_folders = "ores",
            tinted_icon = "ore",
            tint = SODA.MAT[name].tint,
            pictures = 4,
            icon_mipmaps = 4,
        }
           )
end

for _, name in pairs(SODA.MAT.all) do
    data:extend({ore_item(name)})
end
