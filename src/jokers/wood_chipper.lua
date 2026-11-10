-- Wood Chipper: starts at X1 Chips. After a Boss Blind is defeated it destroys
-- one random card still held in hand and gains X0.25. No card, no gain.

SMODS.Joker({
    key = "wood_chipper",
    atlas = "chip_jokers",
    pos = { x = 2, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 1, gain = 0.25 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.extra.xchips }
        end

        if context.end_of_round and context.main_eval and context.beat_boss
            and not context.game_over and MortemChipX.owns_state_change(context) then
            -- Skip cards another Wood Chipper already claimed this round, so
            -- several copies each take a different card.
            local eligible = {}
            for _, held in ipairs(G.hand.cards) do
                if not held.getting_sliced
                    and not SMODS.is_eternal(held, { destroy_cards = true }) then
                    eligible[#eligible + 1] = held
                end
            end
            if #eligible == 0 then return end

            local target = pseudorandom_element(eligible, "mcx_wood_chipper")
            local destroyed = SMODS.destroy_cards(target)
            if destroyed and #destroyed > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xchips",
                    scalar_value = "gain",
                })
            end
        end
    end,
})
