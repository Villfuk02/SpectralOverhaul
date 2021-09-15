SODA.lang = {}

local capture = {"black-ore", "yellow-ore", "green-ore", "stone-analysis", "stone-sample"}
local capture_right = {"ingot"}
local capture_left = {}
for _, value in pairs(capture_left) do
    table.insert(capture, "[^-]+-" .. value)
end
for _, value in pairs(capture_right) do
    table.insert(capture, value .. "-[^-]+")
end
table.insert(capture, "[^-]+")
for key, value in pairs(capture) do
    capture[key] = string.gsub(value, "%-", "%%-")
end

function SODA.lang.cut_up(name)
    local result = {""}
    local start_index = 1

    while start_index <= #name do
        local t = {}
        local sub = string.sub(name, start_index)
        for _, pattern in pairs(capture) do
            for str in string.gmatch(sub, pattern) do
                local i, j = string.find(sub, str, nil, true)
                table.insert(t, {i, j, str})
                break
            end
        end
        local length = 0
        local selected = ""
        for _, value in pairs(t) do
            if value[1] == 1 and value[2] > length then
                length = value[2]
                selected = value[3]
            end
        end
        if length == 0 then
            break
        end
        start_index = start_index + length + 1
        if #result > 1 then
            table.insert(result, " ")
        end
        table.insert(result, {"token." .. selected})
    end
    return result
end
