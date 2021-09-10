-- SUBGROUP
data:extend{{type = "item-subgroup", name = "mining-drills", group = "production", order = "b"}}

local function create_miner(name, order, width, height, mining_size, max_health, power, speed, yield, energy_source, module_slots)
    local miner = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
    miner.name = name
    miner.minable.result = name
    miner.placeable_by = {item = name, count = 1}
    miner.selection_box = {{-width / 2, -height / 2}, {width / 2, height / 2}}
    miner.collision_box = {{-width / 2 + 0.1, -height / 2 + 0.1}, {width / 2 - 0.1, height / 2 - 0.1}}
    miner.vector_to_place_result = {width % 2 == 0 and 0.5 or 0, -height / 2 - 0.35}
    miner.max_health = max_health
    miner.energy_usage = power and power .. "kW" or nil
    miner.energy_source = energy_source
    miner.mining_speed = speed
    miner.base_productivity = yield / 100 - 1
    miner.module_specification.module_slots = module_slots
    miner.resource_searching_radius = mining_size / 2 - 0.01
    miner.input_fluid_box = nil
    data:extend{miner}
    SODA.item.add(name, order, "mining-drills", 50, {folders = "mining-drills"})
    data.raw.item[name].place_result = name
end

create_miner(
    "deep-miner", "1a", 4, 4, 4, 400, SODA.constants.processing.power_per_miner[2] * 3 / 2, SODA.constants.processing.mining_speeds[2], 125,
    {type = "electric", emissions_per_minute = SODA.constants.processing.pollution_per_miner_per_minute[2] * 3 / 2, usage_priority = "secondary-input"}, 1
)
create_miner(
    "surface-miner", "1b", 4, 4, 6, 400, SODA.constants.processing.power_per_miner[2] * 3 / 2, SODA.constants.processing.mining_speeds[2] * 3 / 2, 100,
    {type = "electric", emissions_per_minute = SODA.constants.processing.pollution_per_miner_per_minute[2] * 3 / 2, usage_priority = "secondary-input"}, 1
)
create_miner(
    "dissolving-miner", "1c", 3, 3, 5, 300, SODA.constants.processing.power_per_miner[2], SODA.constants.processing.mining_speeds[2] * 3 / 5, 125, {
        type = "fluid",
        burns_fluid = true,
        fluid_box = {
            pipe_connections = {
                {position = {-2, -1}}, {position = {-1, -2}}, {position = {2, 1}}, {position = {1, 2}}, {position = {2, -1}}, {position = {1, -2}}, {position = {-2, 1}}, {position = {-1, 2}},
            },
            pipe_covers = pipecoverspictures(),
            filter = "water",
            base_level = -1,
            height = 2,
        },
        scale_fluid_usage = true,
        emissions_per_minute = SODA.constants.processing.pollution_per_miner_per_minute[2] / 2,
        usage_priority = "secondary-input",
    }, 1
)

create_miner(
    "big-deep-miner", "2a", 6, 6, 6, 600, SODA.constants.processing.power_per_miner[3] * 3 / 2, SODA.constants.processing.mining_speeds[3], 125,
    {type = "electric", emissions_per_minute = SODA.constants.processing.pollution_per_miner_per_minute[3] * 3 / 2, usage_priority = "secondary-input"}, 3
)
create_miner(
    "big-surface-miner", "2b", 7, 7, 11, 600, SODA.constants.processing.power_per_miner[3] * 3 / 2, SODA.constants.processing.mining_speeds[3] * 3 / 2, 100,
    {type = "electric", emissions_per_minute = SODA.constants.processing.pollution_per_miner_per_minute[3] * 3 / 2, usage_priority = "secondary-input"}, 3
)
create_miner(
    "big-dissolving-miner", "2c", 5, 5, 7, 600, SODA.constants.processing.power_per_miner[3], SODA.constants.processing.mining_speeds[3] * 3 / 5, 125, {
        type = "fluid",
        burns_fluid = true,
        fluid_box = {
            pipe_connections = {
                {position = {-2, -3}}, {position = {-3, -2}}, {position = {2, 3}}, {position = {3, 2}}, {position = {2, -3}}, {position = {3, -2}}, {position = {-2, 3}}, {position = {-3, 2}},
            },
            pipe_covers = pipecoverspictures(),
            filter = "water",
            base_level = -1,
            height = 2,
            base_area = 5,
        },
        scale_fluid_usage = true,
        emissions_per_minute = SODA.constants.processing.pollution_per_miner_per_minute[3] / 2,
        usage_priority = "secondary-input",
    }, 1
)
