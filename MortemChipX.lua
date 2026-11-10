-- MortemChipX: 10 Jokers that multiply Chips.
-- Entry point: registers the shared Joker atlas, then loads one file per Joker.

-- One sheet for every Joker in the mod: 4 columns x 3 rows of 71x95 cells
-- (assets/1x/chip_jokers.png is 284x285, assets/2x/chip_jokers.png is 568x570).
-- The last two cells of the bottom row are empty.
-- A Joker picks its cell with `pos = { x = column, y = row }`, both 0-based.
SMODS.Atlas({
    key = "chip_jokers",
    path = "chip_jokers.png",
    px = 71,
    py = 95,
})

MortemChipX = MortemChipX or {}

-- True for the one evaluation of a context that is allowed to change a Joker's
-- own state. Blueprint/Brainstorm copies and Joker retriggers re-run
-- `calculate` on the same card and must not grow, decay or destroy twice.
function MortemChipX.owns_state_change(context)
    return not context.blueprint and not context.retrigger_joker
end

-- Load order is also collection order (it follows the atlas, row by row).
-- Each name is a file in src/jokers/.
local JOKERS = {
    "double_dip",
    "compound_interest",
    "wood_chipper",
    "stack_overflow",
    "cracked_piggy_bank",
    "bargaining_chip",
    "domino_effect",
    "all_in",
    "pascals_wager",
    "unstable_chipset",
}

for _, name in ipairs(JOKERS) do
    assert(SMODS.load_file("src/jokers/" .. name .. ".lua"))()
end
