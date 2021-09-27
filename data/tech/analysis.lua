local samples = {}

SODA.recipe.add_category("sample-extraction")
SODA.entity.add_furnace(
    "sample-extractor", "1", "research-production", 1.9, 400, "lab", "lab", {"sample-extraction"}, 1, 80, "chemical", 1, false, 0, 1, {
        fluid_boxes = {
            {
                production_type = "input",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 2,
                base_level = -1,
                pipe_connections = {{type = "input", position = {-0.5, -1.5}}},
            },
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 2,
                base_level = 1,
                pipe_connections = {{type = "output", position = {0.5, 1.5}}},
            },
        },
    }
)

for i, r in pairs(SODA.tech.start_resources) do
    local resource = r[2]
    local ingredients = {}
    if r[1] == "fluid" then
        ingredients = {{type = "fluid", name = resource, amount = r[3] / 5}, {"raw-fish", 1}}
    else
        ingredients = {{resource, r[3] / 5}}
    end
    SODA.item.add(resource .. "-sample", i, "research-samples", 100, {icons = {{icon = SODA.path.icons("science-packs/science-pack")}, SODA.icon.get_from(resource)}}, nil, "tool", {durability = 1})
    SODA.recipe.add(
        resource .. "-sample", "sample-extraction", ingredients, nil, resource .. "-sample", 20, 1, nil, nil, nil, nil, nil,
        {hide_from_player_crafting = true, allow_as_intermediate = false, enabled = true}
    )
    SODA.recipe.add(
        resource .. "-from-sample", "sample-extraction", resource .. "-sample", 20, ingredients, nil, 1, "research-samples", i, nil, true,
        SODA.icon.icons_1_to_1_vertical(resource .. "-sample", resource), {hide_from_player_crafting = true, allow_as_intermediate = false}
    )
    local color = nil
    for _, m in pairs(SODA.mat.metals) do
        if string.find(resource, m) then
            color = m
            break
        end
    end
    SODA.tech.add(
        "", resource .. "-analysis", {count = 100, time = 0.1, ingredients = {{resource .. "-sample", 1}}}, nil, {resource .. "-from-sample", color and color .. "-ingot" or nil},
        {icons = {SODA.icon.get_from(resource)}, size = 64}
    )
    table.insert(samples, resource .. "-sample")
end
SODA.entity.add_machine(
    "lab", "analyzer", "2", "research-production", 1.9, 400, "lab", "lab", false, true,
    {energy_source = {type = "void"}, energy_usage = "1W", researching_speed = 1, inputs = samples, allowed_effects = {}}
)

