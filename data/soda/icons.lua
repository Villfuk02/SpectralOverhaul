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

local all_types_to_check = {"item", "fluid"}

local function get_icon_specs(name)
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
    local layers = {get_icon_specs(to), get_icon_specs(from)}
    layers[2].scale = 0.3
    layers[2].shift = {-8, -8}
    return layers
end

function SODA.icon.icons_1_to_1_vertical(from, to)
    local layers = {{icon = SODA.path.graphics("almost-empty")}, get_icon_specs(to), get_icon_specs(from)}
    layers[2].scale = 0.4
    layers[2].shift = {0, 6}
    layers[3].scale = 0.3
    layers[3].shift = {0, -8}
    return layers
end

function SODA.icon.icons_2_to_1(from_left, from_right, to)
    local layers = {{icon = SODA.path.graphics("almost-empty")}, get_icon_specs(to), get_icon_specs(from_right), get_icon_specs(from_left)}
    layers[2].scale = 0.4
    layers[2].shift = {0, 6}
    layers[3].scale = 0.3
    layers[3].shift = {8, -8}
    layers[4].scale = 0.3
    layers[4].shift = {-8, -8}
    return layers
end

function SODA.icon.icons_3_to_1(from_left, from_center, from_right, to)
    local layers = {{icon = SODA.path.graphics("almost-empty")}, get_icon_specs(to), get_icon_specs(from_left), get_icon_specs(from_right), get_icon_specs(from_center)}
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

