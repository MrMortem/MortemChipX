-- Cracked Piggy Bank: starts at X4 Chips and loses X0.5 after every played
-- hand. It scores at 4, 3.5, 3, 2.5, 2, 1.5 and then breaks on reaching X1.

SMODS.Joker({
    key = "cracked_piggy_bank",
    atlas = "chip_jokers",
    pos = { x = 0, y = 1 },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false, -- it has to be able to destroy itself
    perishable_compat = true,
    config = { extra = { xchips = 4, loss = 0.5, floor = 1 } },

    loc_vars = function(self, info_queue, card)
        local extra = card.ability.extra
        return { vars = { extra.xchips, extra.loss, extra.floor } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.extra.xchips }
        end

        if context.after and MortemChipX.owns_state_change(context) then
            local extra = card.ability.extra
            extra.xchips = extra.xchips - extra.loss
            if extra.xchips <= extra.floor then
                SMODS.destroy_cards(card)
                return { message = localize("k_mcx_broke_ex"), colour = G.C.RED }
            end
            return {
                message = localize({ type = "variable", key = "a_xchips_minus", vars = { extra.loss } }),
                colour = G.C.CHIPS,
            }
        end
    end,
})
