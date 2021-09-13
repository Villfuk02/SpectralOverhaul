local subgroup = "energy"

-- START (75% efficiency)
SODA.entity.add_burner_generator("stirling-engine", "1", subgroup, 3.75, 400, "generator", "steam-engine", "chemical", 300, 10, false, 0.75)

-- EARLY (100% efficiency)

-- purple
SODA.entity.add_burner_generator("UV-generator", "2a", subgroup, 1.95, 200, nil, nil, {"UV-emitter", "simple-nuclear"}, 300, 0, true)
SODA.entity.add_burner_generator("battery-discharger", "2b", subgroup, 1.6, 150, nil, nil, {"battery"}, 200, 0, true)
