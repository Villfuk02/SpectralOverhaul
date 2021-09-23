local function on_init()
    remote.call("freeplay", "set_created_items", {["pistol"] = 1, ["firearm-magazine"] = 10, ["burner-mining-drill"] = 2, ["stone-furnace"] = 2, ["sample-extractor"] = 1, ["analyzer"] = 1})
    remote.call("freeplay", "set_debris_items", {["stone"] = 20, ["wood"] = 8, ["stone-brick"] = 10})
end

script.on_init(on_init)
