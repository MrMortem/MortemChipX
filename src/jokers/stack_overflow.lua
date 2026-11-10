-- Stack Overflow: X3 Chips if the hand already has at least 500 Chips when
-- this Joker triggers. Jokers to its left count; Jokers to its right do not.

-- Talisman replaces score numbers with big-number objects that cannot be
-- compared against plain Lua numbers, so wrap the threshold when it is loaded.
local function at_least(value, threshold)
    if to_big then
        return to_big(value) >= to_big(threshold)
    end
    return value >= threshold
end

SMODS.Joker({
    key = "stack_overflow",
    atlas = "chip_jokers",
    pos = { x = 3, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 3, threshold = 500 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.threshold } }
    end,

    calculate = function(self, card, context)
        if context.joker_main
            and at_least(SMODS.get_scoring_parameter("chips"), card.ability.extra.threshold) then
            return { xchips = card.ability.extra.xchips }
        end
    end,
})
