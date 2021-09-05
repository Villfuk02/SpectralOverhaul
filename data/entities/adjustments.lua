-- STONE FURNACE
data.raw.furnace["stone-furnace"].energy_usage = SODA.constants.processing.power_per_processing_line[1] .. "kW"
data.raw.furnace["stone-furnace"].crafting_speed = SODA.constants.processing.machine_speeds[1]

-- BURNER MINER
data.raw["mining-drill"]["burner-mining-drill"].energy_usage = SODA.constants.processing.power_per_miner[1] .. "kW"
data.raw["mining-drill"]["burner-mining-drill"].mining_speed = SODA.constants.processing.mining_speeds[1]
