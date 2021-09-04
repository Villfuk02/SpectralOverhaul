return function(p)
    local temp = {type = "item", name = p.name, order = p.order .. "[" .. p.name .. "]", stack_size = p.stack_size or 100, subgroup = p.subgroup}

    if p.tinted_icon then
        temp.icons = {{icon = SODA.path_icons(p.icon_folders, p.tinted_icon), icon_size = 64, icon_scale = 0.5, tint = p.tint}}
        temp.icon_mipmaps = p.icon_mipmaps
        temp.icon_size = 64
    elseif p.icons then
        temp.icons = p.icons
    else
        temp.icon = SODA.path_icons(p.icon_folders, p.name)
        temp.icon_mipmaps = p.icon_mipmaps
        temp.icon_size = 64
    end

    if p.pictures then
        temp.pictures = {}
        for i = 1, p.pictures, 1 do
            if p.tinted_icon then
                temp.pictures[i] = {filename = SODA.path_icons(p.icon_folders, p.tinted_icon .. (i == 1 and "" or "-" .. i - 1)), mipmap_count = p.icon_mipmaps, scale = 0.25, size = 64, tint = p.tint}
            elseif p.icons then
                error("Item with layers is expected to not have variations: " .. p.name)
            else
                temp.pictures[i] = {filename = SODA.path_icons(p.icon_folders, p.name .. (i == 1 and "" or "-" .. i - 1)), mipmap_count = p.icon_mipmaps, scale = 0.25, size = 64}
            end
        end
    end
    return temp
end
