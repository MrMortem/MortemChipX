-- Unstable Chipset: multiplies Chips by a random amount from X0.5 to X3,
-- rerolled every hand in steps of 0.1. Each Blueprint copy rolls separately.

SMODS.Joker({
    key = "unstable_chipset",
    atlas = "chip_jokers",
    pos = { x = 1, y = 2 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { min = 0.5, max = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            -- Roll whole tenths so the result is a clean number like X1.7.
            local extra = card.ability.extra
            local tenths = pseudorandom("mcx_unstable_chipset",
                math.floor(extra.min * 10 + 0.5), math.floor(extra.max * 10 + 0.5))
            return { xchips = tenths / 10 }
        end
    end,
})
