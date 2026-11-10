-- Compound Interest: starts at X1 Chips and gains X0.15 each time a round is
-- won without using a discard. The winning hand scores with the old value.

SMODS.Joker({
    key = "compound_interest",
    atlas = "chip_jokers",
    pos = { x = 1, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 1, gain = 0.15 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.extra.xchips }
        end

        -- Skipped blinds never reach end_of_round, so they cannot grow this.
        if context.end_of_round and context.main_eval and not context.game_over
            and MortemChipX.owns_state_change(context)
            and G.GAME.current_round.discards_used == 0 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xchips",
                scalar_value = "gain",
            })
        end
    end,
})
