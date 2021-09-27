SODA.icon = {}

function SODA.icon.make(type, name, size, path, mipmaps, tint, icons)
    local tbl = data.raw[type][name]
    tbl.icon_size = size
    tbl.icon_mipmaps = mipmaps
    if tint then
        tbl.icons = {{icon = path, tint = tint}}
    elseif icons then
        tbl.icons = icons
    else
        tbl.icon = path
    end
    data.raw[type][name] = tbl
end

local all_types_to_check = {"item", "fluid", "capsule", "tool"}

function SODA.icon.get_from(name)
    local p = nil
    for _, t in pairs(all_types_to_check) do
        if data.raw[t][name] then
            p = data.raw[t][name]
            break
        end
    end
    if p == nil then
        error("Prototype to copy icon from was not found: " .. tostring(name))
    end
    local s = {}
    if p.icon then
        s.icon = p.icon
    else
        s = table.deepcopy(p.icons[1])
    end
    return s
end

function SODA.icon.icons_1_to_1(from, to)
    local layers = {SODA.icon.get_from(to), SODA.icon.get_from(from)}
    layers[2].scale = 0.3
    layers[2].shift = {-8, -8}
    return layers
end

function SODA.icon.icons_1_to_1_vertical(from, to)
    local layers = {{icon = SODA.path.graphics("almost-empty")}, SODA.icon.get_from(to), SODA.icon.get_from(from)}
    layers[2].scale = 0.4
    layers[2].shift = {0, 6}
    layers[3].scale = 0.3
    layers[3].shift = {0, -8}
    return layers
end

function SODA.icon.icons_2_to_1(from_left, from_right, to)
    local layers = {{icon = SODA.path.graphics("almost-empty")}, SODA.icon.get_from(to), SODA.icon.get_from(from_right), SODA.icon.get_from(from_left)}
    layers[2].scale = 0.4
    layers[2].shift = {0, 6}
    layers[3].scale = 0.3
    layers[3].shift = {8, -8}
    layers[4].scale = 0.3
    layers[4].shift = {-8, -8}
    return layers
end

function SODA.icon.icons_3_to_1(from_left, from_center, from_right, to)
    local layers = {{icon = SODA.path.graphics("almost-empty")}, SODA.icon.get_from(to), SODA.icon.get_from(from_left), SODA.icon.get_from(from_right), SODA.icon.get_from(from_center)}
    layers[2].scale = 0.4
    layers[2].shift = {0, 6}
    layers[3].scale = 0.25
    layers[3].shift = {-9, -6}
    layers[4].scale = 0.25
    layers[4].shift = {9, -6}
    layers[5].scale = 0.25
    layers[5].shift = {0, -9}
    return layers
end

function SODA.icon.any_number(items)
    local size = math.ceil(math.sqrt(#items))
    local layers = {{icon = SODA.path.graphics("almost-empty")}}
    local rows = math.ceil(#items / size)
    local scale = 1 / size
    for y = 1, rows, 1 do
        local columns = y == rows and #items - (rows - 1) * size or size
        for x = 1, columns, 1 do
            local i = SODA.icon.get_from(items[y * size + x - size])
            i.scale = scale
            i.shift = {64 / size * (x - (columns + 1) / 2), 64 / size * (y - (rows + 1) / 2)}
            table.insert(layers, i)
        end
    end
    return layers
end

function SODA.icon.get_icons_from(name)
    local p = nil
    for _, t in pairs(all_types_to_check) do
        if data.raw[t][name] then
            p = data.raw[t][name]
            break
        end
    end
    if p == nil then
        error("Prototype to copy icon from was not found: " .. tostring(name))
    end
    local icons = p.icons
    if not icons then
        icons = {{icon = p.icon}}
    end
    return table.deepcopy(icons)
end

