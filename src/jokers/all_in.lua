-- All In: X5 Chips on the last hand of the round, X0.75 Chips on any other.
-- The game spends the hand before scoring starts, so "last hand" means zero
-- hands left during scoring (the same test the base game's Acrobat uses).

SMODS.Joker({
    key = "all_in",
    atlas = "chip_jokers",
    pos = { x = 3, y = 1 },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 5, penalty = 0.75 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.penalty } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.current_round.hands_left == 0 then
                return { xchips = card.ability.extra.xchips }
            end
            return { xchips = card.ability.extra.penalty }
        end
    end,
})
