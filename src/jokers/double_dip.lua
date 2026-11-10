-- Double Dip: X2 Chips if the played hand has exactly two scoring cards.
-- Counts distinct scoring cards, so kickers and retriggers do not matter.

SMODS.Joker({
    key = "double_dip",
    atlas = "chip_jokers",
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 2, cards = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.cards } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and #context.scoring_hand == card.ability.extra.cards then
            return { xchips = card.ability.extra.xchips }
        end
    end,
})
