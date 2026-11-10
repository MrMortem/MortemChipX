# MortemChipX

A Balatro mod that adds 9 new Jokers that multiply your Chips.

## Jokers

| Joker | Rarity | Cost | Effect |
|---|---|---:|---|
| Double Dip | Common | $5 | X2 Chips if the played hand contains exactly 2 scoring cards. |
| Compound Interest | Uncommon | $6 | Starts at X1 Chips. Gains X0.15 each time a round is won without using a discard. |
| Wood Chipper | Rare | $8 | Starts at X1 Chips. When a Boss Blind is defeated, destroys a random card held in hand and gains X0.25. |
| Stack Overflow | Uncommon | $7 | X3 Chips if the hand has at least 500 Chips when this Joker triggers. |
| Cracked Piggy Bank | Common | $5 | X4 Chips, loses X0.5 per hand played. Destroyed at X1. |
| Bargaining Chip | Rare | $8 | X3 Chips, -2 hand size. |
| Domino Effect | Uncommon | $6 | Each scoring card gives X1.15 Chips if its rank is exactly one higher than the scoring card to its left. |
| All In | Rare | $9 | X5 Chips on the final hand of the round, X0.75 Chips otherwise. |
| Pascal's Wager | Legendary | $20 | Each Ace held in hand gives X2 Chips. |

## Installation

Requires [Steamodded](https://thunderstore.io/c/balatro/p/Steamodded/Steamodded/)
(which brings in Lovely).

- **Mod manager:** install MortemChipX from Thunderstore with r2modman or
  Gale; dependencies are installed for you.
- **Manual:** download the zip from
  [Releases](https://github.com/MrMortem/MortemChipX/releases) and extract it
  into a folder inside your Balatro `Mods` directory.

## Development

```
MortemChipX.lua        entry point: atlas + list of Jokers to load
MortemChipX.json       Steamodded metadata
manifest.json          Thunderstore metadata
icon.png               Thunderstore icon (256x256)
src/jokers/            one file per Joker
localization/en-us.lua Joker names and descriptions
assets/1x, assets/2x   Joker sheet, 4x3 cells of 71x95 (2x: 142x190)
tests/test_jokers.lua  Joker rule tests against a stubbed game API
```

To add a Joker: add a file in `src/jokers/`, list it in `MortemChipX.lua`,
add its text under `j_mcx_<key>` in `localization/en-us.lua`, and draw it into
a cell of both sheets.

Run the rule tests with `luajit tests/test_jokers.lua`.

To test locally, symlink the repo into the Balatro `Mods` folder.

### Releasing

1. Set the same version in `manifest.json` (`version_number`) and
   `MortemChipX.json` (`version`).
2. Tag and push: `git tag v0.1.0 && git push origin v0.1.0`.
3. The Release workflow builds `MortemChipX-<version>.zip` and attaches it to
   a GitHub release. Upload that zip to Thunderstore.

## License

MIT
