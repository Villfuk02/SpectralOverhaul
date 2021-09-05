SODA.MAT = {}

SODA.MAT.all = {"black", "yellow", "green", "azure", "gray", "pink", "lime", "blue", "white", "purple", "orange", "red"}

SODA.MAT.types = {
    fuel = {list = {"black", "yellow", "green"}, black = 1, yellow = 2, green = 3, ingots = false},
    structure = {list = {"azure", "gray", "pink"}, azure = 1, gray = 2, pink = 3, ingots = true},
    mechanisms = {list = {"lime", "blue", "white"}, lime = 1, blue = 2, white = 3, ingots = true},
    electronics = {list = {"purple", "orange", "red"}, purple = 1, orange = 2, red = 3, ingots = true},
}

SODA.MAT.black = {name = "empurite", type = "fuel", order = "a1", map_color = {30, 30, 30}, tint = {60, 60, 60}}
SODA.MAT.yellow = {name = "allasite", type = "fuel", order = "a2", map_color = {225, 220, 90}, tint = {255, 250, 120}}
SODA.MAT.green = {name = "catarite", type = "fuel", order = "a3", map_color = {30, 160, 30}, tint = {60, 190, 60}}
SODA.MAT.azure = {name = "hualite", type = "structure", order = "b1", map_color = {75, 200, 225}, tint = {105, 230, 255}}
SODA.MAT.gray = {name = "sterium", type = "structure", order = "b2", map_color = {120, 125, 130}, tint = {130, 155, 160}}
SODA.MAT.pink = {name = "ionite", type = "structure", order = "b3", map_color = {240, 120, 200}, tint = {255, 135, 215}}
SODA.MAT.lime = {name = "treptium", type = "mechanisms", order = "c1", map_color = {130, 225, 30}, tint = {160, 255, 60}}
SODA.MAT.blue = {name = "phokium", type = "mechanisms", order = "c2", map_color = {60, 30, 225}, tint = {90, 60, 255}}
SODA.MAT.white = {name = "rheonite", type = "mechanisms", order = "c3", map_color = {225, 225, 225}, tint = {255, 255, 255}}
SODA.MAT.purple = {name = "lampium", type = "electronics", order = "d1", map_color = {170, 30, 225}, tint = {200, 60, 255}}
SODA.MAT.orange = {name = "kaumium", type = "electronics", order = "d2", map_color = {225, 110, 30}, tint = {255, 140, 60}}
SODA.MAT.red = {name = "otheium", type = "electronics", order = "d3", map_color = {225, 30, 80}, tint = {255, 60, 60}} -- slightly pink to distinguish from biters
