SODA.MATS = {}
SODA.mat = {}

SODA.mat.list = {"black", "yellow", "green", "azure", "silver", "pink", "lime", "blue", "white", "purple", "orange", "red"}

SODA.mat.types = {
    fuel = {list = {"black", "yellow", "green"}, black = 1, yellow = 2, green = 3, processing = false},
    structure = {list = {"azure", "silver", "pink"}, azure = 1, silver = 2, pink = 3, processing = true},
    mechanisms = {list = {"lime", "blue", "white"}, lime = 1, blue = 2, white = 3, processing = true},
    electronics = {list = {"purple", "orange", "red"}, purple = 1, orange = 2, red = 3, processing = true},
}

SODA.MATS.black = {name = "kaerium", type = "fuel", order = "a1", map_color = {30, 30, 30}, tint = {60, 60, 60}, short = "K"}
SODA.MATS.yellow = {name = "empurite", type = "fuel", order = "a2", map_color = {225, 220, 90}, tint = {255, 250, 120}, short = "E"}
SODA.MATS.green = {name = "hualite", type = "fuel", order = "a3", map_color = {30, 160, 30}, tint = {60, 190, 60}, short = "H"}
SODA.MATS.azure = {name = "allasite", type = "structure", order = "b1", map_color = {75, 200, 225}, tint = {105, 230, 255}, short = "A"}
SODA.MATS.silver = {name = "starium", type = "structure", order = "b2", map_color = {130, 135, 140}, tint = {160, 165, 170}, short = "S"}
SODA.MATS.pink = {name = "ionite", type = "structure", order = "b3", map_color = {240, 120, 200}, tint = {255, 135, 215}, short = "I"}
SODA.MATS.lime = {name = "lamnium", type = "mechanisms", order = "c1", map_color = {130, 225, 30}, tint = {160, 255, 60}, short = "L"}
SODA.MATS.blue = {name = "catarite", type = "mechanisms", order = "c2", map_color = {60, 30, 225}, tint = {90, 60, 255}, short = "C"}
SODA.MATS.white = {name = "treptium", type = "mechanisms", order = "c3", map_color = {225, 225, 225}, tint = {255, 255, 255}, short = "T"}
SODA.MATS.purple = {name = "phabium", type = "electronics", order = "d1", map_color = {170, 30, 225}, tint = {200, 60, 255}, short = "P"}
SODA.MATS.orange = {name = "otheium", type = "electronics", order = "d2", map_color = {225, 110, 30}, tint = {255, 140, 60}, short = "O"}
SODA.MATS.red = {name = "rheonite", type = "electronics", order = "d3", map_color = {225, 30, 80}, tint = {255, 60, 60}, short = "R"} -- slightly pink to distinguish from biters

function SODA.mat.by_short(short)
    for _, value in pairs(SODA.MATS) do
        if value.short == short then
            return value
        end
    end
end
