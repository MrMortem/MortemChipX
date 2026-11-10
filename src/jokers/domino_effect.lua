-- Domino Effect: each scoring card gives X1.15 Chips if its rank is exactly
-- one higher than the scoring card to its left. 2-3-4-5-6 triggers four times.
-- Ranks run 2..10, J=11, Q=12, K=13, A=14 with no wraparound (A then 2 fails).

-- Rank of a scoring card, or nil if it has none (e.g. Stone Cards).
local function rank_of(playing_card)
    if SMODS.has_no_rank(playing_card) then return nil end
    return playing_card.base.id
end

SMODS.Joker({
    key = "domino_effect",
    atlas = "chip_jokers",
    pos = { x = 2, y = 1 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 1.15 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            -- The predecessor is looked up fresh on every call, so retriggers
            -- of the same card repeat the bonus without shifting the chain.
            local scoring_hand = context.scoring_hand
            for i = 2, #scoring_hand do
                if scoring_hand[i] == context.other_card then
                    local rank = rank_of(scoring_hand[i])
                    local previous = rank_of(scoring_hand[i - 1])
                    if rank and previous and rank == previous + 1 then
                        return { xchips = card.ability.extra.xchips }
                    end
                    return
                end
            end
        end
    end,
})
