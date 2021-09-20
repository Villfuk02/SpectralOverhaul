-- ------------------------------
-- STOLEN FROM THE INSERTER CONFIG MOD
-- ------------------------------
-- ------------------------------
-- Dependencies
-- ------------------------------
local math2d = require("math2d")

-- ------------------------------
-- Math library additions
-- ------------------------------
function math2d.position.equal(p1, p2)
    p1 = math2d.position.ensure_xy(p1)
    p2 = math2d.position.ensure_xy(p2)
    return p1.x == p2.x and p1.y == p2.y
end

function math2d.position.dot_product(p1, p2)
    p1 = math2d.position.ensure_xy(p1)
    p2 = math2d.position.ensure_xy(p2)
    return p1.x * p2.x + p1.y * p2.y
end

-- splits a position into tile position int(x,y) and an offset float(x,y)
-- { x = -1.5, y = 2.5 } -> {{ x = -2, y = 2 }, { x = 0.5, y = 0.5 }}
function math2d.position.split(pos)
    pos = math2d.position.ensure_xy(pos)

    local x_int, x_frac = math.modf(pos.x)
    local y_int, y_frac = math.modf(pos.y)

    if x_frac < 0 then
        x_int = x_int - 1
        x_frac = x_frac + 1
    end

    if y_frac < 0 then
        y_int = y_int - 1
        y_frac = y_frac + 1
    end

    return {x = x_int, y = y_int}, {x = x_frac, y = y_frac}
end

function math2d.position.tilepos(pos)
    pos = math2d.position.ensure_xy(pos)
    return {x = math.floor(pos.x), y = math.floor(pos.y)}
end

math2d.direction = {}

function math2d.direction.from_vector(vec)
    vec = math2d.position.ensure_xy(vec)
    return math.floor(math.atan2(vec.x, -vec.y) * (4 / math.pi) + 0.5) % 8
end

math2d.direction.vectors = {{x = 0, y = -1}, {x = 1, y = -1}, {x = 1, y = 0}, {x = 1, y = 1}, {x = 0, y = 1}, {x = -1, y = 1}, {x = -1, y = 0}, {x = -1, y = -1}}

function math2d.direction.to_vector(dir)
    return math2d.direction.vectors[(dir % 8) + 1]
end

-- ------------------------------
-- Inserter utils
-- ------------------------------
local inserter_utils = {}

function inserter_utils.get_prototype(inserter)
    if inserter.type == "entity-ghost" then
        return inserter.ghost_prototype
    end
    return inserter.prototype
end

function inserter_utils.is_inserter(entity)
    return entity and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter"))
end

function inserter_utils.get_arm_positions(inserter)
    local base_tile, base_offset = math2d.position.split(inserter.position)
    local drop_tile, drop_offset = math2d.position.split(inserter.drop_position)
    local pickup_tile, pickup_offset = math2d.position.split(inserter.pickup_position)

    local drop_offset_vec = {x = 0, y = 0}

    if drop_offset.x > 0.5 then
        drop_offset_vec.x = 1
    elseif drop_offset.x < 0.5 then
        drop_offset_vec.x = -1
    end

    if drop_offset.y > 0.5 then
        drop_offset_vec.y = 1
    elseif drop_offset.y < 0.5 then
        drop_offset_vec.y = -1
    end

    local result = {
        base = base_tile,
        base_offset = base_offset,
        drop = math2d.position.subtract(drop_tile, base_tile),
        drop_offset = drop_offset_vec,
        pickup = math2d.position.subtract(pickup_tile, base_tile),
    }

    return result
end

function inserter_utils.set_arm_positions(inserter, positions)
    if positions.pickup then
        inserter.pickup_position = math2d.position.add(inserter.position, positions.pickup)
    end

    if positions.drop or positions.drop_offset then
        local base_tile, base_offset = math2d.position.split(inserter.position)
        local old_drop_tile, old_drop_offset = math2d.position.split(inserter.drop_position)

        local new_drop_tile, new_drop_offset
        if positions.drop then
            new_drop_tile = math2d.position.add(base_tile, positions.drop)
        else
            new_drop_tile = old_drop_tile
        end

        if positions.drop_offset then
            new_drop_offset = math2d.position.add(math2d.position.multiply_scalar(positions.drop_offset, 0.2), {0.5, 0.5})
        else
            new_drop_offset = old_drop_offset
        end

        inserter.drop_position = math2d.position.add(new_drop_tile, new_drop_offset)
    end
end

function inserter_utils.get_max_range(inserter)
    local prototype = inserter
    if prototype.object_name == "LuaEntity" then
        prototype = inserter_utils.get_prototype(prototype)
    end

    if string.find(prototype.name, "miniloader") then
        return -1
    end

    local pickup_pos = math2d.position.tilepos(math2d.position.add(prototype.inserter_pickup_position, {0.5, 0.5}))
    local drop_pos = math2d.position.tilepos(math2d.position.add(prototype.inserter_drop_position, {0.5, 0.5}))
    local range = math.max(math.abs(pickup_pos.x), math.abs(pickup_pos.y), math.abs(drop_pos.x), math.abs(drop_pos.y))
    return (range < 4) and 2 or 0
end

function inserter_utils.enforce_max_range(inserter)
    local arm_positions = inserter_utils.get_arm_positions(inserter)
    local max_range = inserter_utils.get_max_range(inserter)

    if math.max(math.abs(arm_positions.drop.x), math.abs(arm_positions.drop.y)) > max_range then
        arm_positions.drop = math2d.position.multiply_scalar(math2d.direction.to_vector(math2d.direction.from_vector(arm_positions.drop)), max_range)
    end

    if math.max(math.abs(arm_positions.pickup.x), math.abs(arm_positions.pickup.y)) > max_range then
        arm_positions.pickup = math2d.position.multiply_scalar(math2d.direction.to_vector(math2d.direction.from_vector(arm_positions.pickup)), max_range)
    end

    if math2d.position.equal(arm_positions.pickup, arm_positions.drop) then
        arm_positions.pickup = {x = -arm_positions.drop.x, y = -arm_positions.drop.y}
    end

    inserter_utils.set_arm_positions(inserter, arm_positions)
end

function inserter_utils.calc_rotated_drop_offset(inserter, positions)

    local old_positions = inserter_utils.get_arm_positions(inserter)
    local old_drop_dir = math2d.direction.from_vector(old_positions.drop)

    if not positions.drop then
        return old_positions.drop_offset
    end

    local new_drop_dir = math2d.direction.from_vector(positions.drop)
    local new_drop_offset = {x = 0, y = 0}

    local delta = (new_drop_dir - old_drop_dir) % 8

    if delta % 2 == 0 then
        -- mirror
        if delta == 0 then
            new_drop_offset = old_positions.drop_offset
        elseif delta == 2 then
            new_drop_offset = {x = -old_positions.drop_offset.y, y = old_positions.drop_offset.x}
        elseif delta == 4 then
            new_drop_offset = {x = -old_positions.drop_offset.x, y = -old_positions.drop_offset.y}
        elseif delta == 6 then
            new_drop_offset = {x = old_positions.drop_offset.y, y = -old_positions.drop_offset.x}
        end
    else
        -- reset drop offset
        new_drop_offset = math2d.direction.to_vector(new_drop_dir + (new_drop_dir % 2) * 4)
    end

    return new_drop_offset
end

-- ------------------------------
-- Gui
-- ------------------------------
local gui = {}

function gui.create(player)
    local frame_main_anchor = {gui = defines.relative_gui_type.inserter_gui, position = defines.relative_gui_position.right}
    local frame_main = player.gui.relative.add({type = "frame", name = "inserter_config", caption = {"gui-inserter-config.configuration"}, anchor = frame_main_anchor})

    local frame_content = frame_main.add({type = "frame", name = "frame_content", style = "inside_shallow_frame_with_padding"})
    local flow_content = frame_content.add({type = "flow", name = "flow_content", direction = "vertical"})

    flow_content.add({type = "label", name = "label_position", caption = {"gui-inserter-config.position"}, style = "heading_2_label"})

    local table_range = 1
    local inserter_prototyes = game.get_filtered_entity_prototypes({{filter = "type", type = "inserter"}})
    for name, prototype in pairs(inserter_prototyes) do
        local range = inserter_utils.get_max_range(prototype)
        if range < 5 then
            table_range = math.max(table_range, range)
        end
    end

    local table_position = flow_content.add({type = "table", name = "table_position", column_count = 1 + table_range * 2})
    table_position.style.horizontal_spacing = 1
    table_position.style.vertical_spacing = 1

    for y = -table_range, table_range, 1 do
        for x = -table_range, table_range, 1 do

            local pos_suffix = "_" .. tostring(x + table_range + 1) .. "_" .. tostring(y + table_range + 1)

            if x == 0 and y == 0 then
                local sprite = table_position.add({type = "sprite", name = "sprite_inserter", sprite = "item/inserter"})
                sprite.style.stretch_image_to_widget_size = true
                sprite.style.size = {32, 32}
            else
                local button = table_position.add({type = "sprite-button", name = "button_position" .. pos_suffix, style = "slot_sized_button"})
                button.style.size = {32, 32}
            end
        end
    end

    flow_content.add({type = "line", name = "line", style = "control_behavior_window_line"})

    flow_content.add({type = "label", name = "label_offset", caption = {"gui-inserter-config.drop-offset"}, style = "heading_2_label"})

    table_position = flow_content.add({type = "table", name = "table_offset", column_count = 3})
    table_position.style.horizontal_spacing = 1
    table_position.style.vertical_spacing = 1

    for y = 1, 3, 1 do
        for x = 1, 3, 1 do
            local button_name = "button_offset_" .. tostring(x + table_range + 1) .. "_" .. tostring(y + table_range + 1)
            local button = table_position.add({type = "sprite-button", name = button_name, style = "slot_sized_button"})
            button.style.size = {32, 32}
        end
    end
end

function gui.delete(player)
    if player.gui.relative.inserter_config then
        player.gui.relative.inserter_config.destroy()
    end
end

function gui.create_all()
    for idx, player in pairs(game.players) do
        gui.delete(player)
        gui.create(player)
    end
end

function gui.update(player, inserter)

    local gui_instance = player.gui.relative.inserter_config.frame_content.flow_content

    local table_range = (gui_instance.table_position.column_count - 1) / 2
    local inserter_range = inserter_utils.get_max_range(inserter)

    local arm_positions = inserter_utils.get_arm_positions(inserter)

    local idx = 0
    for y = -table_range, table_range, 1 do
        for x = -table_range, table_range, 1 do
            idx = idx + 1

            if gui_instance.table_position.children[idx].type == "sprite-button" then

                if inserter_range > 0 and math2d.position.equal(arm_positions.drop, {x, y}) then
                    gui_instance.table_position.children[idx].sprite = "drop"
                elseif inserter_range > 0 and math2d.position.equal(arm_positions.pickup, {x, y}) then
                    gui_instance.table_position.children[idx].sprite = "pickup"
                elseif x ~= 0 or y ~= 0 then
                    gui_instance.table_position.children[idx].sprite = nil
                end

                gui_instance.table_position.children[idx].enabled = math.abs(x) + math.abs(y) <= inserter_range
            end
        end
    end

    for i = 1, 9, 1 do
        if gui_instance.table_offset.children[i].type == "sprite-button" then
            if inserter_range > 0 then
                gui_instance.table_offset.children[i].enabled = true
            elseif inserter_range == 0 then
                gui_instance.table_offset.children[i].enabled = (arm_positions.drop.x == 0 and i % 3 == 2) or (arm_positions.drop.y == 0 and math.floor((i - 1) / 3) == 1)
            elseif inserter_range == -1 then
                gui_instance.table_offset.children[i].enabled = false
            end
        end
    end

    local icon = "item/inserter"
    if inserter.prototype.items_to_place_this then
        icon = "item/" .. inserter.prototype.items_to_place_this[1].name
    end
    gui_instance.table_position.sprite_inserter.sprite = icon

    local idx = 0
    for y = -1, 1, 1 do
        for x = -1, 1, 1 do
            idx = idx + 1

            if math2d.position.equal(arm_positions.drop_offset, {x, y}) then
                gui_instance.table_offset.children[idx].sprite = "drop"
            else
                gui_instance.table_offset.children[idx].sprite = nil
            end
        end
    end
end

function gui.update_all(inserter)
    for idx, player in pairs(game.players) do
        if (inserter and player.opened == inserter) or (not inserter and player.opened and player.opened.type == "inserter") then
            gui.update(player, player.opened)
        end
    end
end

function gui.get_button_pos(button)
    local idx = button.get_index_in_parent() - 1
    local len = button.parent.column_count
    local center = (len - 1) * -0.5
    return math2d.position.add({idx % len, math.floor(idx / len)}, {center, center})
end

function gui.on_button_position(player, event)

    local inserter = player.opened

    local new_pos = gui.get_button_pos(event.element)

    if event.button == defines.mouse_button_type.left and not event.control and not event.shift then
        local new_positions = {drop = new_pos}

        if event.element.sprite == "drop" then
            return
        end

        if event.element.sprite == "pickup" then
            new_positions.pickup = inserter_utils.get_arm_positions(inserter).drop
        end

        new_positions.drop_offset = inserter_utils.calc_rotated_drop_offset(inserter, new_positions)

        inserter_utils.set_arm_positions(inserter, new_positions)

    elseif event.button == defines.mouse_button_type.right or (event.button == defines.mouse_button_type.left and (event.control or event.shift)) then
        local new_positions = {pickup = new_pos}

        if event.element.sprite == "pickup" then
            return
        end

        if event.element.sprite == "drop" then
            new_positions.drop = inserter_utils.get_arm_positions(inserter).pickup
        end

        inserter_utils.set_arm_positions(inserter, new_positions)
    end

    gui.update_all(inserter)
end

function gui.on_button_offset(player, event)
    local new_drop_offset = gui.get_button_pos(event.element)
    inserter_utils.set_arm_positions(player.opened, {drop_offset = new_drop_offset})

    gui.update(player, player.opened)
end

-- ------------------------------
-- Event Handlers
-- ------------------------------
-- Mod init

local function on_init()
    gui.create_all()
end

local function on_configuration_changed(cfg_changed_data)
    gui.create_all()
    gui.update_all()
end

local function on_player_created(event)
    local player = game.players[event.player_index]
    gui.create(player)
end

local function on_entity_settings_pasted(event)
    if event.destination.type == "inserter" then
        if inserter_utils.get_max_range(event.destination) > 0 and inserter_utils.get_max_range(event.source) > 0 then
            event.destination.direction = event.source.direction
            inserter_utils.enforce_max_range(event.destination)
        end
        gui.update_all(event.destination)
    end
end

-- Gui Events

local function on_gui_opened(event)
    local player = game.players[event.player_index]

    if event.entity and event.entity.type == "inserter" then
        gui.update(player, event.entity, true)
    end
end

local function on_gui_click(event)
    local player = game.players[event.player_index]
    local gui_instance = player.gui.relative.inserter_config.frame_content.flow_content

    if event.element.parent == gui_instance.table_position and event.element ~= gui_instance.table_position.sprite_inserter then
        gui.on_button_position(player, event)
    elseif event.element.parent == gui_instance.table_offset then
        gui.on_button_offset(player, event)
    end
end

local function on_player_rotated_entity(event)
    if event.entity.type == "inserter" then
        gui.update_all(event.entity)
    end
end

-- Hotkey Events

local function on_rotation_adjust(event)
    local player = game.players[event.player_index]
    if inserter_utils.is_inserter(player.selected) then
        local inserter = player.selected

        if inserter_utils.get_max_range(inserter) <= 0 then
            return
        end

        local is_drop = string.find(event.input_name, "drop", 17) and true or false
        local dir = string.find(event.input_name, "reverse", -7) and -2 or 2

        local target = is_drop and "drop" or "pickup"
        local check = is_drop and "pickup" or "drop"

        local arm_positions = inserter_utils.get_arm_positions(inserter)

        local range = math.max(math.abs(arm_positions[target].x), math.abs(arm_positions[target].y))

        local old_dir = math2d.direction.from_vector(arm_positions[target])

        local new_dir = (old_dir + dir) % 8
        local new_tile = math2d.position.multiply_scalar(math2d.direction.to_vector(new_dir), range)

        if math2d.position.equal(new_tile, arm_positions[check]) then
            new_dir = (new_dir + dir) % 8
            new_tile = math2d.position.multiply_scalar(math2d.direction.to_vector(new_dir), range)
        end

        local new_arm_positions = {}
        new_arm_positions[target] = new_tile
        new_arm_positions.drop_offset = inserter_utils.calc_rotated_drop_offset(inserter, new_arm_positions)

        inserter_utils.set_arm_positions(inserter, new_arm_positions)

        gui.update_all(inserter)
    end
end

local function on_distance_adjust(event)
    local player = game.players[event.player_index]
    if inserter_utils.is_inserter(player.selected) then
        local inserter = player.selected

        if inserter_utils.get_max_range(inserter) <= 0 then
            return
        end

        local is_drop = string.find(event.input_name, "drop", 17) and true or false

        local target = is_drop and "drop" or "pickup"
        local check = is_drop and "pickup" or "drop"

        local max_range = inserter_utils.get_max_range(inserter)
        local arm_positions = inserter_utils.get_arm_positions(inserter)

        local dir = math2d.direction.from_vector(arm_positions[target])
        local range = math.max(math.abs(arm_positions[target].x), math.abs(arm_positions[target].y))

        local new_range = (range % max_range) + 1
        local new_tile = math2d.position.multiply_scalar(math2d.direction.to_vector(dir), new_range)

        local new_positions = {}
        if math2d.position.equal(new_tile, arm_positions[check]) then
            new_range = (new_range % max_range) + 1
            new_tile = math2d.position.multiply_scalar(math2d.direction.to_vector(dir), new_range)

            if max_range == 2 then
                new_positions[target] = arm_positions[check]
                new_positions[check] = new_tile
            else
                new_positions[target] = new_tile
            end
        else
            new_positions[target] = new_tile
        end

        inserter_utils.set_arm_positions(inserter, new_positions)

        gui.update_all(inserter)
    end
end

local function on_offset_adjust(event)
    local player = game.players[event.player_index]
    if inserter_utils.is_inserter(player.selected) then
        local inserter = player.selected

        local lateral = string.find(event.input_name, "lateral", -7) ~= nil

        if inserter_utils.get_max_range(inserter) == -1 or (inserter_utils.get_max_range(inserter) == 0 and lateral) then
            return
        end

        local arm_positions = inserter_utils.get_arm_positions(inserter)

        local drop_dir = math2d.direction.from_vector(arm_positions.drop)

        drop_dir = drop_dir % 2 == 0 and drop_dir or 0

        local target = (drop_dir % 4 == 0 ~= lateral) and "y" or "x"

        local new_drop_offset = arm_positions.drop_offset
        new_drop_offset[target] = ((new_drop_offset[target] + 2) % 3) - 1

        inserter_utils.set_arm_positions(inserter, {drop_offset = new_drop_offset})

        gui.update_all(inserter)
    end
end

-- ------------------------------
-- Eventhandler registration
-- ------------------------------

script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_player_created, on_player_created)

script.on_event(defines.events.on_gui_opened, on_gui_opened)
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_player_rotated_entity, on_player_rotated_entity)
script.on_event(defines.events.on_entity_settings_pasted, on_entity_settings_pasted)

script.on_event("inserter-config-drop-rotate", on_rotation_adjust)
script.on_event("inserter-config-drop-rotate-reverse", on_rotation_adjust)
script.on_event("inserter-config-pickup-rotate", on_rotation_adjust)
script.on_event("inserter-config-pickup-rotate-reverse", on_rotation_adjust)

script.on_event("inserter-config-pickup-distance-adjust", on_distance_adjust)
script.on_event("inserter-config-drop-distance-adjust", on_distance_adjust)

script.on_event("inserter-config-drop-offset-adjust-lateral", on_offset_adjust)
script.on_event("inserter-config-drop-offset-adjust-distance", on_offset_adjust)
