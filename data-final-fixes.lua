local fixed_cost = settings.startup["rcc-fixed-cost"].value
local ignore_infinite = settings.startup["rcc-ignore-infinite"].value

if fixed_cost > 0 then
    for _, technology in pairs(data.raw.technology) do
        if technology.unit and technology.unit.count then
            technology.unit.count = fixed_cost
        end
    end
end

if ignore_infinite then
    for _, technology in pairs(data.raw.technology) do
        if technology.unit and technology.unit.count == nil then
            log(serpent.block(technology))

            technology.ignore_tech_cost_multiplier = true
        end

    end

end
