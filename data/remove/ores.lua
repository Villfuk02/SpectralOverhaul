for key, _ in pairs(data.raw["resource"]) do
    data.raw["resource"][key] = nil
end

local blacklist_autoplace = {"stone", "coal", "iron-ore", "copper-ore", "uranium-ore"}

for _, key in pairs(blacklist_autoplace) do
    data.raw["autoplace-control"][key] = nil
    for _, preset in pairs(data.raw["map-gen-presets"]["default"]) do
        if preset.basic_settings and preset.basic_settings.autoplace_controls then
            preset.basic_settings.autoplace_controls[key] = nil
        end
    end
end
