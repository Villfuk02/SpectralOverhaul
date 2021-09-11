local function make_fuel(name, value, fuel_type)
    data.raw.item[name].fuel_value = value
    data.raw.item[name].fuel_category = fuel_type or "chemical"
end

make_fuel("wood", "2MJ")

make_fuel("black-ore", "3.2MJ")
make_fuel("yellow-ore", "3.2MJ")
make_fuel("green-ore", "3.2MJ")

make_fuel("activated-black", (8000 + SODA.constants.processing.energy_per_ingot[1] / SODA.constants.processing.total_time_per_ingot[1] * SODA.constants.processing.total_time_per_ingot[2]) / 4 .. "kJ")
