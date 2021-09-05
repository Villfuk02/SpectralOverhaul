local function make_fuel(name, value, fuel_type)
    data.raw.item[name].fuel_value = value
    data.raw.item[name].fuel_category = fuel_type or "chemical"
end

make_fuel("wood", "1MJ")

make_fuel("black-ore", "1MJ")
make_fuel("yellow-ore", "1MJ")
make_fuel("green-ore", "1MJ")
