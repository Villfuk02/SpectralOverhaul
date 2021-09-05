SODA.icon = {}
function SODA.icon.make(tbl, size, path, mipmaps, tint, icons)
    tbl.icon_size = size
    tbl.icon_mipmaps = mipmaps
    if tint then
        tbl.icons = {{icon = path, tint = tint}}
    elseif icons then
        tbl.icons = icons
    else
        tbl.icon = path
    end

    return tbl
end

function SODA.icon.layers()
    return nil
end

