SODA = {} -- Spectral Overhaul DAta

-- INIT MATERIALS
require "data.soda.materials"

-- ADD PATH GENERATORS
require "data.soda.paths"

-- ADD ICON GENERATORS
require "data.soda.icons"

-- ADD ITEM GENERATORS
require "data.soda.items"

-- ADD TECH GENERATORS
require "data.soda.technology"

-- SAVE IRON-ORE PRESET SETTINGS
SODA.autoplace_presets = {}
for k, preset in pairs(data.raw["map-gen-presets"]["default"]) do
    if preset.basic_settings and preset.basic_settings.autoplace_controls then
        SODA.autoplace_presets[k] = preset.basic_settings.autoplace_controls["iron-ore"]
    end
end

