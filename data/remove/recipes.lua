local whitelist = {["rocket-part"] = true, ["bop-make-water"] = true}

for b, _ in pairs(data.raw.recipe) do
    if not whitelist[b] then
        data.raw.recipe[b] = nil
    end
end

for b, _ in pairs(data.raw.module) do
    data.raw.module[b].limitation = nil
end

for b, _ in pairs(data.raw.module) do
    data.raw.module[b].limitation = nil
end

for b, _ in pairs(data.raw.technology) do
    if b == "construction-robotics" or b == "personal-roboport-equipment" or b == "exoskeleton-equipment" or b == "oil-processing" then
        data.raw.technology[b].prerequisites = nil
        data.raw.technology[b].effects = nil
    else
        data.raw.technology[b] = nil
    end
end

for b, _ in pairs(data.raw["tips-and-tricks-item"]) do
    data.raw["tips-and-tricks-item"][b] = nil
end
