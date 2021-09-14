SODA = {} -- Spectral Overhaul DAta

-- INIT CONSTANTS
require "data.soda.constants"

-- INIT MATERIALS
require "data.soda.materials"

-- INIT COLORS
require "data.soda.colors"

-- ADD PATH GENERATORS
require "data.soda.paths"

-- ADD LANG ENGINE
require "data.soda.lang"

-- ADD ICON GENERATORS
require "data.soda.icons"

-- ADD ITEM GENERATORS
require "data.soda.items"

-- ADD FLUID GENERATORS
require "data.soda.fluids"

-- ADD RECIPE GENERATORS
require "data.soda.recipes"

-- ADD MACHINE GENERATORS
require "data.soda.entities"

-- ADD TECH GENERATORS
require "data.soda.technology"

-- SAVE IRON-ORE PRESET SETTINGS
SODA.autoplace_presets = {}
for k, preset in pairs(data.raw["map-gen-presets"]["default"]) do
    if preset.basic_settings and preset.basic_settings.autoplace_controls then
        SODA.autoplace_presets[k] = preset.basic_settings.autoplace_controls["iron-ore"]
    end
end

