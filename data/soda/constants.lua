SODA.constants = {}

-- BELT SPEEDS
SODA.constants.belt_speeds = {7.5, 15, 30, 60, 120}

-- ORE PROCESSING
SODA.constants.processing = {}
SODA.constants.processing.processing_levels = 4
SODA.constants.processing.mining_levels = 3

SODA.constants.processing.ore_per_ingot = 4
SODA.constants.processing.productivity = {2 / 3, 1, 1, 1}
SODA.constants.processing.lines_per_basic_belt = {30, 6, 3, 1.5}
SODA.constants.processing.machine_speeds = {1, 1, 2, 4}

SODA.constants.processing.mining_speeds = {0.125, 0.25, 1.5}

SODA.constants.processing.energy_per_ore = {600, 400, 600} -- in kJ, vanilla = 600, 180 (x2)
SODA.constants.processing.energy_per_ingot = {4800, 6400, 4000, 2560} -- in kJ, vanilla (plates) = 288, 144, 288 (x8), including fuel used in processing

SODA.constants.processing.pollution_per_60_ore = {96, 36, 36} -- vanilla = 48, 20 (x2)
SODA.constants.processing.pollution_per_60_ingots = {60, 48, 36, 24} -- vanilla (plates) = 6.4, 6.4, 1.6 (x8)

-- CALCULATED
SODA.constants.processing.power_per_miner = {} -- in kW
SODA.constants.processing.power_per_processing_line = {} -- in kW
SODA.constants.processing.pollution_per_miner_per_minute = {}
SODA.constants.processing.pollution_per_processing_line_per_minute = {}

SODA.constants.processing.total_ore_per_ingot = {}
SODA.constants.processing.total_time_per_ingot = {}

for i = 1, SODA.constants.processing.mining_levels, 1 do
    SODA.constants.processing.power_per_miner[i] = SODA.constants.processing.energy_per_ore[i] * SODA.constants.processing.mining_speeds[i]
    SODA.constants.processing.pollution_per_miner_per_minute[i] = SODA.constants.processing.pollution_per_60_ore[i] * SODA.constants.processing.mining_speeds[i]
end

for i = 1, SODA.constants.processing.processing_levels, 1 do
    SODA.constants.processing.total_ore_per_ingot[i] = SODA.constants.processing.ore_per_ingot / SODA.constants.processing.productivity[i]
    SODA.constants.processing.total_time_per_ingot[i] = SODA.constants.processing.total_ore_per_ingot[i] * SODA.constants.processing.lines_per_basic_belt[i] *
                                                            SODA.constants.processing.machine_speeds[i] / SODA.constants.belt_speeds[1]
    SODA.constants.processing.power_per_processing_line[i] = SODA.constants.processing.energy_per_ingot[i] / SODA.constants.processing.total_time_per_ingot[i] *
                                                                 SODA.constants.processing.machine_speeds[i]
    SODA.constants.processing.pollution_per_processing_line_per_minute[i] = SODA.constants.processing.pollution_per_60_ingots[i] / SODA.constants.processing.total_time_per_ingot[i] *
                                                                                SODA.constants.processing.machine_speeds[i]
end

