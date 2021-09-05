SODA.MAT = {}

SODA.MAT.all = {"black", "yellow", "green", "azure", "gray", "pink", "lime", "blue", "white", "purple", "orange", "red"}

SODA.MAT.types = {
    fuel = {list = {"black", "yellow", "green"}, black = 1, yellow = 2, green = 3, ingots = false},
    structure = {list = {"azure", "gray", "pink"}, azure = 1, gray = 2, pink = 3, ingots = true},
    mechanisms = {list = {"lime", "blue", "white"}, lime = 1, blue = 2, white = 3, ingots = true},
    electronics = {list = {"purple", "orange", "red"}, purple = 1, orange = 2, red = 3, ingots = true},
}

SODA.MAT.black = {name = "kaerium", type = "fuel", order = "a1", map_color = {30, 30, 30}, tint = {60, 60, 60}, short = "K"}
SODA.MAT.yellow = {name = "empurite", type = "fuel", order = "a2", map_color = {225, 220, 90}, tint = {255, 250, 120}, short = "E"}
SODA.MAT.green = {name = "hualite", type = "fuel", order = "a3", map_color = {30, 160, 30}, tint = {60, 190, 60}, short = "H"}
SODA.MAT.azure = {name = "allasite", type = "structure", order = "b1", map_color = {75, 200, 225}, tint = {105, 230, 255}, short = "A"}
SODA.MAT.gray = {name = "starium", type = "structure", order = "b2", map_color = {120, 125, 130}, tint = {130, 155, 160}, short = "S"}
SODA.MAT.pink = {name = "ionite", type = "structure", order = "b3", map_color = {240, 120, 200}, tint = {255, 135, 215}, short = "I"}
SODA.MAT.lime = {name = "lamnium", type = "mechanisms", order = "c1", map_color = {130, 225, 30}, tint = {160, 255, 60}, short = "L"}
SODA.MAT.blue = {name = "catarite", type = "mechanisms", order = "c2", map_color = {60, 30, 225}, tint = {90, 60, 255}, short = "C"}
SODA.MAT.white = {name = "treptium", type = "mechanisms", order = "c3", map_color = {225, 225, 225}, tint = {255, 255, 255}, short = "T"}
SODA.MAT.purple = {name = "phabium", type = "electronics", order = "d1", map_color = {170, 30, 225}, tint = {200, 60, 255}, short = "P"}
SODA.MAT.orange = {name = "otheium", type = "electronics", order = "d2", map_color = {225, 110, 30}, tint = {255, 140, 60}, short = "O"}
SODA.MAT.red = {name = "rheonite", type = "electronics", order = "d3", map_color = {225, 30, 80}, tint = {255, 60, 60}, short = "R"} -- slightly pink to distinguish from biters
