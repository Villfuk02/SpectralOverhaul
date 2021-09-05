local item = require "data.globals.items"

for _, name in pairs(SODA.MAT.all) do
    data:extend({item(name .. "-ore", "e-" .. SODA.MAT[name].order, "raw-resource", nil, {folders = "ores", name = "ore", mipmaps = 4, tint = SODA.MAT[name].tint}, 4)})
end
