-- PLACEHOLDER Joker. It exists so the mod loads and the XChips plumbing can be
-- seen working in game. Copy this file for each real Joker, then delete it.
--
-- Checklist for a new Joker:
--   1. Copy this file to src/jokers/<name>.lua and change `key`.
--   2. Add "<name>" to the JOKERS list in MortemChipX.lua.
--   3. Add its name and text under j_mcx_<key> in localization/en-us.lua.
--   4. Draw it into a free cell of assets/1x and assets/2x jokers.png and
--      point `pos` at that cell.

SMODS.Joker({
    key = "example", -- full key in game: j_mcx_example
    atlas = "jokers",
    pos = { x = 0, y = 0 },
    rarity = 1, -- 1 Common, 2 Uncommon, 3 Rare, 4 Legendary
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { xchips = 2 } },

    -- Values substituted for #1#, #2#, ... in the localization text.
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = card.ability.extra.xchips }
        end
    end,
})
