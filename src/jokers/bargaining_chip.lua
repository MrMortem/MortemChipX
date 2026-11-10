-- Bargaining Chip: X3 Chips, -2 hand size while owned.
-- The game calls add_to_deck/remove_from_deck in pairs for buying, selling,
-- destroying and for debuff on/off, and does not call them when a save is
-- loaded, so the penalty cannot drift or double up.

SMODS.Joker({
    key = "bargaining_chip",
    atlas = "chip_jokers",
    pos = { x = 1, y = 1 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true, -- copies the X3 only; the hooks below are not copied
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 3, hand_size = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.hand_size } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.extra.xchips }
        end
    end,
})
