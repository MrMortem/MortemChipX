return {
    descriptions = {
        Joker = {
            j_mcx_double_dip = {
                name = "Double Dip",
                text = {
                    "{X:chips,C:white}X#1#{} Chips if played hand",
                    "contains exactly {C:attention}#2#{}",
                    "scoring cards",
                },
            },
            j_mcx_compound_interest = {
                name = "Compound Interest",
                text = {
                    "Gains {X:chips,C:white}X#1#{} Chips when a",
                    "round is won without",
                    "using a {C:attention}discard{}",
                    "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
                },
            },
            j_mcx_wood_chipper = {
                name = "Wood Chipper",
                text = {
                    "When {C:attention}Boss Blind{} is defeated,",
                    "destroys a random card",
                    "held in hand and gains",
                    "{X:chips,C:white}X#1#{} Chips",
                    "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
                },
            },
            j_mcx_stack_overflow = {
                name = "Stack Overflow",
                text = {
                    "{X:chips,C:white}X#1#{} Chips if the hand",
                    "has at least {C:chips}#2#{} Chips",
                    "when this Joker triggers",
                },
            },
            j_mcx_cracked_piggy_bank = {
                name = "Cracked Piggy Bank",
                text = {
                    "{X:chips,C:white}X#1#{} Chips,",
                    "loses {X:chips,C:white}X#2#{} Chips",
                    "per hand played",
                    "{C:inactive}(Destroyed at {X:chips,C:white}X#3#{C:inactive})",
                },
            },
            j_mcx_bargaining_chip = {
                name = "Bargaining Chip",
                text = {
                    "{X:chips,C:white}X#1#{} Chips,",
                    "{C:attention}-#2#{} hand size",
                },
            },
            j_mcx_domino_effect = {
                name = "Domino Effect",
                text = {
                    "Each scoring card gives",
                    "{X:chips,C:white}X#1#{} Chips if its rank is",
                    "exactly {C:attention}one higher{} than the",
                    "scoring card to its left",
                },
            },
            j_mcx_all_in = {
                name = "All In",
                text = {
                    "{X:chips,C:white}X#1#{} Chips on {C:attention}final",
                    "{C:attention}hand{} of round,",
                    "{X:chips,C:white}X#2#{} Chips otherwise",
                },
            },
            j_mcx_pascals_wager = {
                name = "Pascal's Wager",
                text = {
                    "Each {C:attention}Ace{}",
                    "held in hand",
                    "gives {X:chips,C:white}X#1#{} Chips",
                },
            },
            j_mcx_unstable_chipset = {
                name = "Unstable Chipset",
                text = {
                    "{X:chips,C:white}X#1#{} to {X:chips,C:white}X#2#{} Chips,",
                    "chosen at random",
                    "each hand",
                },
            },
        },
    },
    misc = {
        dictionary = {
            k_mcx_broke_ex = "Broke!",
        },
    },
}
