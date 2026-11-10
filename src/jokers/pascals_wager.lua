-- Pascal's Wager (Legendary): each Ace held in hand gives X2 Chips.
-- Fires once per held Ace during held-card scoring, so retriggers of an Ace
-- (Red Seal, Mime) repeat its X2 and there is no cap on the number of Aces.
-- Legendary rarity keeps it out of the shop; it comes from The Soul.

local ACE = 14

SMODS.Joker({
    key = "pascals_wager",
    atlas = "chip_jokers",
    pos = { x = 0, y = 2 },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        -- Held cards are also visited at end of round (Gold Cards, Blue
        -- Seals); that pass is not scoring.
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            local held = context.other_card
            if SMODS.has_no_rank(held) or held:get_id() ~= ACE then return end
            if held.debuff then
                return { message = localize("k_debuffed"), colour = G.C.RED }
            end
            return { xchips = card.ability.extra.xchips }
        end
    end,
})
