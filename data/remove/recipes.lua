local whitelist = {["rocket-part"] = true}

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
    data.raw.technology[b].effects = nil
end

for b, _ in pairs(data.raw["tips-and-tricks-item"]) do
    data.raw["tips-and-tricks-item"][b] = nil
end
