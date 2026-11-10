-- Logic tests for the Jokers, run outside the game against a minimal stub of
-- the Steamodded/Balatro API:   luajit tests/test_jokers.lua
-- They cover each Joker's `calculate` rules, not rendering or engine timing.

local jokers = {}
local destroyed, hand_size_delta, chips = {}, 0, 0

G = {
    C = { RED = "red", CHIPS = "chips" },
    play = {},
    hand = { cards = {}, change_size = function(_, n) hand_size_delta = hand_size_delta + n end },
    GAME = { current_round = { hands_left = 3, discards_used = 0 } },
}
SMODS = {
    Atlas = function() end,
    Joker = function(def) jokers[def.key] = def end,
    load_file = function(path) return loadfile(path) end,
    get_scoring_parameter = function() return chips end,
    has_no_rank = function(c) return c.no_rank end,
    is_eternal = function(c) return c.eternal end,
    destroy_cards = function(c)
        c.getting_sliced = true
        destroyed[#destroyed + 1] = c
        return { c }
    end,
    scale_card = function(_, a) a.ref_table[a.ref_value] = a.ref_table[a.ref_value] + a.ref_table[a.scalar_value] end,
}
function pseudorandom_element(t) return t[1] end
local next_roll
function pseudorandom(_, min, max) return next_roll(min, max) end
function localize(a) return type(a) == "table" and a.key or a end

assert(loadfile("MortemChipX.lua"))()

local failures, count = 0, 0
local function check(name, got, want)
    count = count + 1
    local ok = got == want or (type(got) == "number" and type(want) == "number" and math.abs(got - want) < 1e-9)
    if not ok then
        failures = failures + 1
        print(("FAIL %s: got %s, want %s"):format(name, tostring(got), tostring(want)))
    end
end

local function new(key)
    local def = jokers[key]
    local extra = {}
    for k, v in pairs(def.config.extra) do extra[k] = v end
    local card = { ability = { extra = extra } }
    return card, function(context) return def:calculate(card, context) end, def
end
local function xchips(result) return result and result.xchips or nil end
local function cards(...)
    local out = {}
    for i, id in ipairs({ ... }) do
        out[i] = { base = { id = id }, no_rank = id == 0, get_id = function(c) return c.base.id end }
    end
    return out
end
local END_WIN = { end_of_round = true, main_eval = true, game_over = false }

do -- all ten are registered with the handoff's keys, rarity, cost and cell
    local want = {
        double_dip = { 1, 5, 0, 0 }, compound_interest = { 2, 6, 1, 0 },
        wood_chipper = { 3, 8, 2, 0 }, stack_overflow = { 2, 7, 3, 0 },
        cracked_piggy_bank = { 1, 5, 0, 1 }, bargaining_chip = { 3, 8, 1, 1 },
        domino_effect = { 2, 6, 2, 1 }, all_in = { 3, 9, 3, 1 },
        pascals_wager = { 4, 20, 0, 2 }, unstable_chipset = { 2, 6, 1, 2 },
    }
    for key, w in pairs(want) do
        local def = jokers[key]
        check(key .. " registered", def ~= nil, true)
        check(key .. " rarity", def.rarity, w[1])
        check(key .. " cost", def.cost, w[2])
        check(key .. " pos.x", def.pos.x, w[3])
        check(key .. " pos.y", def.pos.y, w[4])
        check(key .. " eternal", def.eternal_compat, key ~= "cracked_piggy_bank")
    end
end

do -- Double Dip
    local _, calc = new("double_dip")
    check("double dip 1", xchips(calc({ joker_main = true, scoring_hand = cards(5) })), nil)
    check("double dip 2", xchips(calc({ joker_main = true, scoring_hand = cards(5, 5) })), 2)
    check("double dip 3", xchips(calc({ joker_main = true, scoring_hand = cards(5, 5, 5) })), nil)
end

do -- Compound Interest
    local card, calc = new("compound_interest")
    check("interest start", xchips(calc({ joker_main = true })), 1)
    G.GAME.current_round.discards_used = 0
    calc(END_WIN)
    check("interest clean win", card.ability.extra.xchips, 1.15)
    G.GAME.current_round.discards_used = 1
    calc(END_WIN)
    check("interest after discard", card.ability.extra.xchips, 1.15)
    G.GAME.current_round.discards_used = 0
    calc({ end_of_round = true, main_eval = true, game_over = true })
    check("interest on loss", card.ability.extra.xchips, 1.15)
    calc({ end_of_round = true, main_eval = true, game_over = false, blueprint = true })
    check("interest via blueprint", card.ability.extra.xchips, 1.15)
    calc({ end_of_round = true, game_over = false, individual = true })
    check("interest per-card callback", card.ability.extra.xchips, 1.15)
    check("interest scores new value", xchips(calc({ joker_main = true })), 1.15)
end

do -- Wood Chipper
    local card, calc = new("wood_chipper")
    local boss = { end_of_round = true, main_eval = true, game_over = false, beat_boss = true }
    G.hand.cards = cards(2, 3)
    calc(END_WIN)
    check("chipper normal blind", #destroyed, 0)
    calc(boss)
    check("chipper boss destroys one", #destroyed, 1)
    check("chipper boss gain", card.ability.extra.xchips, 1.25)
    local _, second = new("wood_chipper")
    second(boss)
    check("second chipper takes another card", destroyed[2], G.hand.cards[2])
    local third_card, third = new("wood_chipper")
    third(boss)
    check("chipper with nothing left", #destroyed, 2)
    check("chipper no card no gain", third_card.ability.extra.xchips, 1)
    G.hand.cards = {}
    calc(boss)
    check("chipper empty hand", card.ability.extra.xchips, 1.25)
end

do -- Stack Overflow
    local _, calc = new("stack_overflow")
    chips = 499
    check("overflow 499", xchips(calc({ joker_main = true })), nil)
    chips = 500
    check("overflow 500", xchips(calc({ joker_main = true })), 3)
end

do -- Cracked Piggy Bank
    local card, calc = new("cracked_piggy_bank")
    destroyed = {}
    local used = {}
    for hand = 1, 6 do
        used[hand] = xchips(calc({ joker_main = true }))
        calc({ after = true, blueprint = true })
        check("piggy alive before hand " .. hand .. " ends", #destroyed, 0)
        calc({ after = true })
    end
    check("piggy values", table.concat(used, " "), "4 3.5 3 2.5 2 1.5")
    check("piggy destroyed after sixth hand", destroyed[1], card)
end

do -- Bargaining Chip
    local card, calc, def = new("bargaining_chip")
    hand_size_delta = 0
    def:add_to_deck(card)
    check("bargain owned", hand_size_delta, -2)
    def:remove_from_deck(card, true)
    check("bargain debuffed", hand_size_delta, 0)
    def:add_to_deck(card, true)
    def:remove_from_deck(card)
    check("bargain sold", hand_size_delta, 0)
    check("bargain xchips", xchips(calc({ joker_main = true })), 3)
end

do -- Domino Effect
    local _, calc = new("domino_effect")
    local function triggers(...)
        local hand, n = cards(...), 0
        for _, c in ipairs(hand) do
            if calc({ individual = true, cardarea = G.play, scoring_hand = hand, other_card = c }) then n = n + 1 end
        end
        return n
    end
    check("domino 2-3-4-5-6", triggers(2, 3, 4, 5, 6), 4)
    check("domino 2-4-5", triggers(2, 4, 5), 1)
    check("domino K-A", triggers(13, 14), 1)
    check("domino A-2", triggers(14, 2), 0)
    check("domino descending", triggers(6, 5, 4), 0)
    check("domino rankless breaks chain", triggers(2, 0, 3, 4), 1)
    local hand = cards(7, 8)
    local ctx = { individual = true, cardarea = G.play, scoring_hand = hand, other_card = hand[2] }
    check("domino retrigger repeats", xchips(calc(ctx)) == 1.15 and xchips(calc(ctx)) == 1.15, true)
    check("domino held in hand ignored", calc({ individual = true, cardarea = G.hand, scoring_hand = hand, other_card = hand[2] }), nil)
end

do -- All In
    local _, calc = new("all_in")
    G.GAME.current_round.hands_left = 2
    check("all in early", xchips(calc({ joker_main = true })), 0.75)
    G.GAME.current_round.hands_left = 0
    check("all in last hand", xchips(calc({ joker_main = true })), 5)
end

do -- Pascal's Wager
    local _, calc = new("pascals_wager")
    local function held_product(hand)
        local product = 1
        for _, c in ipairs(hand) do
            local r = calc({ individual = true, cardarea = G.hand, other_card = c })
            product = product * (r and r.xchips or 1)
        end
        return product
    end
    check("wager 0 aces", held_product(cards(13, 2)), 1)
    check("wager 1 ace", held_product(cards(14, 2)), 2)
    check("wager 4 aces", held_product(cards(14, 14, 14, 14)), 16)
    local hand = cards(14, 14)
    hand[1].debuff = true
    check("wager debuffed ace", held_product(hand), 2)
    hand = cards(14)
    hand[1].no_rank = true
    check("wager rankless ace", held_product(hand), 1)
    local ace = cards(14)[1]
    check("wager played ace", calc({ individual = true, cardarea = G.play, other_card = ace }), nil)
    check("wager end of round pass", calc({ individual = true, cardarea = G.hand, other_card = ace, end_of_round = true }), nil)
    check("wager no main multiplier", calc({ joker_main = true }), nil)
end

do -- Unstable Chipset
    local _, calc = new("unstable_chipset")
    next_roll = function(min) return min end
    check("chipset lowest roll", xchips(calc({ joker_main = true })), 0.5)
    next_roll = function(_, max) return max end
    check("chipset highest roll", xchips(calc({ joker_main = true })), 3)
    next_roll = function() return 17 end
    check("chipset mid roll", xchips(calc({ joker_main = true })), 1.7)
    check("chipset only in main scoring", calc({ after = true }), nil)
end

do -- every Joker has a name and description
    local loc = assert(loadfile("localization/en-us.lua"))()
    for key in pairs(jokers) do
        local entry = loc.descriptions.Joker["j_mcx_" .. key]
        check(key .. " localized", entry ~= nil and entry.name ~= nil and #entry.text > 0, true)
    end
end

print(("%d checks, %d failed"):format(count, failures))
os.exit(failures == 0 and 0 or 1)
