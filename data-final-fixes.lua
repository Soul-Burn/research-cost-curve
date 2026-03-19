local fixed_cost = settings.startup["rcc-fixed-cost"].value

if fixed_cost > 0 then
    for _, technology in pairs(data.raw.technology) do
        if technology.unit and technology.unit.count then
            technology.unit.count = fixed_cost
        end
    end
end
