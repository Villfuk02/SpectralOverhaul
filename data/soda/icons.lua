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

function SODA.icon.layers()
    return nil
end

