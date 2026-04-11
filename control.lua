local function similar(n1, n2, precision)
    local s1 = string.format("%.10f", n1)
    local s2 = string.format("%.10f", n2)

    local decimal_index = s1:find("%.")
    if decimal_index ~= s2:find("%.") then
        return false
    end

    if decimal_index <= precision then
        precision = precision + 1
    end

    return s1:sub(1, precision) == s2:sub(1, precision)
end

local function apply_change(iterate)
    local old = game.difficulty_settings.technology_price_multiplier
    local new = old
    local mult = settings.global["rcc-multiplicative"].value
    local add = settings.global["rcc-additive"].value
    if iterate then
        new = new * mult
        new = new + add
    end
    local max = settings.global["rcc-maximum"].value
    local min = settings.global["rcc-minimum"].value
    new = math.max(math.min(new, max), min)
    if settings.global["rcc-print"].value and new ~= old then
        game.difficulty_settings.technology_price_multiplier = new
        local suffix = ""
        if new == max then
            suffix = " = maximum"
        end
        if new == min then
            suffix = " = minimum"
        end
        if not similar(old, new, settings.global["rcc-print-precision"].value) then
            game.print("Research price multiplier updated: (" .. old .. " + " .. add .. ") * " .. mult .. " =  " .. new .. "x" .. suffix)
        end
    end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting:match("^rcc%-") then
        apply_change(false)
    end
end)

script.on_event(defines.events.on_research_finished, function(event)
    if not event.by_script and not event.research.prototype.research_trigger then
        apply_change(true)
    end
end)
