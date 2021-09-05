require("data.remove.ores")
require("data.remove.recipes")
require("data.remove.entity-adjustments")

local blacklist = {}
local whitelist = {recipe = {["rocket-part"] = true}}

for t, l in pairs(blacklist) do
    for _, b in pairs(l) do
        data.raw[t][b] = nil
    end
end

for t, l in pairs(whitelist) do
    for b, _ in pairs(data.raw[t]) do
        if not l[b] then
            local kill = true
            if l[1] then
                for _, f in pairs(l[1]) do
                    if string.find(b, f) then
                        kill = false
                        break
                    end
                end
            end
            if kill then
                data.raw[t][b] = nil
            end
        end
    end
end
