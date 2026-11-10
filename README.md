# MortemChipX

A Balatro mod that adds 8 new Jokers that multiply your Chips.

> Work in progress. The Jokers are still being designed; the mod currently
> ships one placeholder Joker and placeholder art.

## Jokers

| # | Name | Rarity | Effect |
|---|------|--------|--------|
| 1 | TBD | | |
| 2 | TBD | | |
| 3 | TBD | | |
| 4 | TBD | | |
| 5 | TBD | | |
| 6 | TBD | | |
| 7 | TBD | | |
| 8 | TBD | | |

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
assets/1x, assets/2x   Joker sheet, 4x2 cells of 71x95 (2x: 142x190)
```

To add a Joker, follow the checklist at the top of
[src/jokers/example.lua](src/jokers/example.lua).

To test locally, symlink the repo into the Balatro `Mods` folder.

### Releasing

1. Set the same version in `manifest.json` (`version_number`) and
   `MortemChipX.json` (`version`).
2. Tag and push: `git tag v0.1.0 && git push origin v0.1.0`.
3. The Release workflow builds `MortemChipX-<version>.zip` and attaches it to
   a GitHub release. Upload that zip to Thunderstore.

## License

MIT
