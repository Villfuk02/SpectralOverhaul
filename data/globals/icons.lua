local function add(tbl, size, path, mipmaps, tint, icns)
    tbl.icon_size = size
    tbl.icon_mipmaps = mipmaps
    if tint then
        tbl.icons = {{icon = path, icon_size = size, tint = tint, icon_mipmaps = mipmaps}}
    elseif icns then
        tbl.icons = icns
    else
        tbl.icon = path
    end

    return tbl
end

local function icons()
    return nil
end

return {add = add, icons = icons}
