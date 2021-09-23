-- data.raw["string-setting"]["discovery-tree-mode"].allowed_values = {"almost-all", "all"}
data.raw["string-setting"]["discovery-tree-mode"].default_value = "almost-all"
data.raw["bool-setting"]["stack-thrower-inserter"].default_value = true
data:extend({{type = "bool-setting", setting_type = "startup", name = "inserter-config-chase-belt-items", default_value = true}})
