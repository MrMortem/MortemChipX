-- MortemChipX: 8 Jokers that multiply Chips.
-- Entry point: registers the shared Joker atlas, then loads one file per Joker.

-- One sheet for every Joker in the mod: 4 columns x 2 rows of 71x95 cells
-- (assets/1x/jokers.png is 284x190, assets/2x/jokers.png is 568x380).
-- A Joker picks its cell with `pos = { x = column, y = row }`, both 0-based.
SMODS.Atlas({
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- Load order is also collection order. Each name is a file in src/jokers/.
local JOKERS = {
    "example", -- placeholder, slot (0,0): replace with the first real Joker
}

for _, name in ipairs(JOKERS) do
    assert(SMODS.load_file("src/jokers/" .. name .. ".lua"))()
end
