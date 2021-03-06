local blacklist_autoplace = {"stone", "coal", "iron-ore", "copper-ore", "uranium-ore"}

for _, key in pairs(blacklist_autoplace) do
    data.raw["resource"][key] = nil
    data.raw["autoplace-control"][key] = nil
    for _, preset in pairs(data.raw["map-gen-presets"]["default"]) do
        if preset.basic_settings and preset.basic_settings.autoplace_controls then
            preset.basic_settings.autoplace_controls[key] = nil
        end
    end
end

data.raw["simple-entity"]["rock-huge"].minable = {mining_particle = "stone-particle", mining_time = 3, results = {{amount_max = 72, amount_min = 24, name = "stone"}}}
