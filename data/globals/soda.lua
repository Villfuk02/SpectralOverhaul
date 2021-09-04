SODA = {} -- Spectral Overhaul DAta

-- SAVE IRON-ORE PRESET SETTINGS
SODA.autoplace_presets = {}
for k, preset in pairs(data.raw["map-gen-presets"]["default"]) do
    if preset.basic_settings and preset.basic_settings.autoplace_controls then
        SODA.autoplace_presets[k] = preset.basic_settings.autoplace_controls["iron-ore"]
    end
end

-- REMOVE THESE
SODA.blacklist_autoplace = {"stone", "coal", "crude-oil", "iron-ore", "copper-ore", "uranium-ore"}

-- DO NOT REMOVE THESE
SODA.item_whitelist = {"rocket-silo", "furnace", "burner-miner"}
