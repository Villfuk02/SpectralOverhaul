SODA.color = {}

function SODA.color.lerp(a, b, t)
    local c = {}
    for key, value in pairs(a) do
        c[key] = value * (1 - t) + b[key] * t
    end
    return c
end
